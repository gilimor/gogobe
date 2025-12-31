import re
from typing import Dict, List, Optional, Tuple
import logging
import psycopg2
import os

logger = logging.getLogger(__name__)

class AutoCategorizer:
    """
    Automatic Product Categorizer
    Based on keyword matching and heuristics relevant to Israeli Supermarkets.
    Maps products to a clean hierarchy inspired by Google Product Taxonomy.
    """
    
    def __init__(self, db_config: Dict):
        self.db_config = db_config
        self.categories_cache = {}
        self.rules = self._load_rules()
        
    def _load_rules(self) -> Dict[str, Dict]:
        """
        Define classification rules.
        Format: 'Category Name': {'keywords': [...], 'negative': [...], 'parent': '...'}
        Includes expanded categories based on Google Product Taxonomy.
        """
        return {
            # --- פירות וירקות ---
            'ירקות טריים': {
                'keywords': ['מלפפון', 'עגבני', 'בצל', 'גזר', 'פלפל', 'חסה', 'כרוב', 'פטרוזיליה', 'שמיר', 'כוסברה', 'תפוח אדמה', 'תפ"א', 'בטטה', 'קישוא', 'חציל', 'דלעת', 'סלק', 'צנון', 'צנונית', 'שום', 'שומר', 'קולורבי', 'ברוקולי', 'כרובית'], 
                'parent': 'פירות וירקות'
            },
            'פירות טריים': {
                'keywords': ['תפוח', 'בננה', 'אגס', 'ענבים', 'אפרסק', 'משמש', 'שזיף', 'נקטרינה', 'אבטיח', 'מלון', 'תפוז', 'קלמנטינה', 'מנדרינה', 'פומלה', 'אשכולית', 'לימון', 'תות שדה', 'דובדבן', 'רימון', 'תמר', 'חבוש', 'אפרסמון', 'מנגו', 'אבוקדו', 'פסיפלורה', 'אננס'],
                'parent': 'פירות וירקות'
            },
            
            # --- חלב וביצים ---
            'חלב טרי': {
                'keywords': ['חלב', 'משקה חלב', 'שוקו'],
                'negative': ['סויה', 'שקדים', 'אורז', 'שיבולת שועל', 'קוקוס'], 
                'parent': 'חלב ומוצרי חלב'
            },
            'משקאות תחליפי חלב': {
                'keywords': ['משקה סויה', 'משקה שקדים', 'משקה שיבולת', 'משקה אורז', 'חלב סויה'],
                'parent': 'חלב ומוצרי חלב'
            },
            'גבינות': {
                'keywords': ['גבינה', 'גבינת', 'קוטג', 'מוצרלה', 'ריקוטה', 'מסקרפונה', 'פרמזן', 'בולגרית', 'צפתית', 'פטה', 'עמק', 'נעם', 'גלבוע', 'חלומי'],
                'parent': 'חלב ומוצרי חלב'
            },
            'יוגורטים ומעדנים': {
                'keywords': ['יוגורט', 'מעדן', 'דני', 'מילקי', 'גמדים', 'אקטיביה', 'דנונה', 'יולו', 'מוס', 'YOLO'],
                'parent': 'חלב ומוצרי חלב'
            },
            'חמאה ושמנת': {
                'keywords': ['חמאה', 'שמנת', 'מרגרינה', 'מחמאה'],
                'parent': 'חלב ומוצרי חלב'
            },
            'ביצים': {
                'keywords': ['ביצים', 'ביצה'],
                'negative': ['שוקולד', 'הפתעה'],
                'parent': 'חלב ומוצרי חלב'
            },

            # --- לחם ומאפים ---
            'לחם': {
                'keywords': ['לחם', 'חלה', 'לחמניה', 'לחמנייה', 'פיתה', 'באגט', 'גבטה', 'בגט', 'טורטיה'],
                'negative': ['פירורי'],
                'parent': 'לחמים ומאפים'
            },
            'מאפים מתוקים': {
                'keywords': ['עוגה', 'עוגת', 'רולדה', 'קרואסון', 'רוגלך', 'בורקס', 'גחנון', 'מלוואח', 'בצק עלים', 'סופגניה', 'דונאט'],
                'parent': 'לחמים ומאפים'
            },
             'עוגיות': {
                'keywords': ['עוגיות', 'ביסקוויט', 'וופל', 'בפלות', 'עוגיו'],
                'parent': 'לחמים ומאפים'
            },

            # --- בשר ודגים ---
            'עוף והודו': {
                'keywords': ['עוף', 'הודו', 'שניצל', 'כרעיים', 'שוקיים', 'חזה עוף', 'כנפיים', 'פרגיות'],
                'parent': 'בשר ודגים'
            },
            'בקר': {
                'keywords': ['בקר', 'אנטריקוט', 'סינטה', 'פילה', 'צלעות', 'אסאדו', 'טחון', 'קבב', 'המבורגר', 'נקניקיות'],
                'parent': 'בשר ודגים'
            },
            'דגים': {
                'keywords': ['דג', 'סלמון', 'טונה', 'מושט', 'אמנון', 'דניס', 'לברק', 'נסיכת הנילוס', 'בקלה', 'סרדינים', 'הרינג'],
                'negative': ['שימורי'],
                'parent': 'בשר ודגים'
            },
            
            # --- מזווה (Pantry) ---
            'פסטה ואורז': {
                'keywords': ['פסטה', 'ספגטי', 'מקרוני', 'פתיתים', 'קוסקוס', 'אורז', 'נודלס', 'אטריות'],
                'parent': 'דגנים ופסטות'
            },
            'קטניות ודגנים': {
                'keywords': ['עדשים', 'שעועית', 'חומוס גרגרים', 'בורגול', 'קינואה', 'כוסמת', 'סולת', 'תירס'],
                'negative': ['שימורי', 'קפוא'],
                'parent': 'דגנים ופסטות'
            },
            'קמח וסוכר': {
                'keywords': ['קמח', 'סוכר', 'מלח', 'שמרים', 'פודינג', 'גלי', 'אבקת אפייה', 'סוכר וניל', 'קקאו'],
                'parent': 'מוצרי אפייה'
            },
            'שימורים': {
                'keywords': ['שימורי', 'רסק', 'חמוצים', 'זיתים', 'מלפפון חמוץ', 'תירס מתוק', 'אפונה וגזר', 'טונה בשמן', 'טונה במים', 'סרדינים'],
                'parent': 'שימורים'
            },
            'שמן': {
                'keywords': ['שמן זית', 'שמן קנולה', 'שמן חמניות', 'שמן סויה', 'שמן תירס', 'תרסיס שמן'],
                'parent': 'תבלינים ורטבים'
            },
            'רטבים ותבלינים': {
                'keywords': ['רוטב', 'קטשופ', 'מיונז', 'חרדל', 'טחינה', 'חומץ', 'לימון משומר', 'תבלין', 'פלפל שחור', 'פפריקה', 'כמון', 'זעתר', 'אבקת מרק'],
                 'parent': 'תבלינים ורטבים'
            },
            
            # --- משקאות ---
            'משקאות קלים': {
                'keywords': ['קוקה קולה', 'פפסי', 'ספרייט', 'פאנטה', 'מיץ', 'נביעות', 'מי עדן', 'סודה', 'משקה', 'נקטר', 'פריגת', 'שוופס', 'ספרינג', 'גאמפ', 'קולה'],
                'parent': 'משקאות'
            },
             'משקאות חמים': {
                'keywords': ['קפה', 'נס קפה', 'תה', 'תמצית', 'קפסולות', 'שוקולית'],
                'parent': 'משקאות'
            },
             'אלכוהול': {
                'keywords': ['יין', 'בירה', 'וודקה', 'וויסקי', 'ערק', 'ברנדי', 'ליקר', 'רום', 'ג\'ין', 'קברנה', 'מרלו', 'שיראז', 'היינקן', 'גולדסטאר', 'קורונה'],
                'parent': 'משקאות'
            },

            # --- קפואים (NEW) ---
            'גלידות וקינוחים קפואים': {
                'keywords': ['גלידה', 'גלידת', 'ארטיק', 'שלגון', 'קרמבו', 'סורבה', 'מגנום'],
                'parent': 'מוצרים קפואים'
            },
            'ארוחות קפואות': {
                'keywords': [' פיצה ', 'פיצה', 'בורקס קפוא', 'גחנון קפוא', 'מלוואח', 'שניצל תירס', 'שניצל סויה', 'טבעול', 'המבורגר צמחי', 'צ\'יפס קפוא', 'לקט ירקות'],
                'parent': 'מוצרים קפואים'
            },

            # --- ניקיון והיגיינה ---
             'מוצרי כביסה': {
                'keywords': ['אבקת כביסה', 'ג\'ל כביסה', 'מרכך כביסה', 'מסיר כתמים', 'דפים למייבש', 'קפסולות כביסה'],
                'parent': 'מוצרי ניקיון'
            },
             'ניקיון הבית': {
                'keywords': ['אקונומיקה', 'נוזל כלים', 'סבון כלים', 'מסיר שומנים', 'מנקה רצפות', 'תרסיס חלונות', 'פותח סתימות', 'סנו', 'סיליט', 'פיירי'],
                'parent': 'מוצרי ניקיון'
            },
             'נייר וחד פעמי': {
                'keywords': ['נייר טואלט', 'מגבות נייר', 'טישו', 'מגבונים', 'חיתולים', 'חד פעמי', 'צלחות', 'כוסות', 'סכו"ם', 'מפות', 'שקיות אשפה', 'נייר אפייה', 'נר נשמה'],
                'negative': ['בד'],
                'parent': 'נייר ומוצרי חד פעמי'
            },
             'רחצה וטיפוח': {
                'keywords': ['שמפו', 'מרכך שיער', 'סבון גוף', 'תחליב רחצה', 'דאודורנט', 'משחת שיניים', 'מברשת שיניים', 'מי פה', 'קרם גוף', 'סכיני גילוח', 'קצף גילוח', 'תחבושות', 'טמפונים', 'פנטן', 'הד אנד שולדרס'],
                'parent': 'מוצרי היגיינה'
            },

            # --- תינוקות (NEW) ---
            'מזון לתינוקות': {
                'keywords': ['מטרנה', 'סימילאק', 'נוטרילון', 'דייסה', 'מחית', 'גרבר', 'ביסקוויט לתינוק'],
                'parent': 'תינוקות'
            },
            'חיתולים והחתלה': {
                'keywords': ['טיטולים', 'פמפרס', 'האגיס', 'huggies', 'pampers', 'מגבונים לתינוק', 'משחת החתלה'],
                'parent': 'תינוקות'
            },
            'בקבוקים ומוצצים': {
                 'keywords': ['מוצץ', 'בקבוק לתינוק', 'פטמה לבקבוק'],
                 'parent': 'תינוקות'
            },

            # --- חיות מחמד (NEW) ---
            'מזון לחיות': {
                'keywords': ['דוגלי', 'בונזו', 'לה קט', 'מזון לכלבים', 'מזון לחתולים', 'חטיף לכלב', 'שימורים לחתול', 'fancy feast', 'proplan'],
                'parent': 'חיות מחמד'
            },

             # --- פארם ובריאות (NEW) ---
            'ויטמינים ותוספים': {
                'keywords': ['ויטמין', 'תוסף תזונה', 'אומגה 3', 'פרוביוטיקה', 'ברזל', 'מגנזיום', 'צנטרום', 'אלטמן'],
                'parent': 'פארם ובריאות'
            },
            'עזרה ראשונה': {
                'keywords': ['פלסטר', 'תחבושת', 'יוד', 'אלכוהול לחיטוי', 'מד חום'],
                'parent': 'פארם ובריאות'
            },
            
            # --- חשמל ובית (Expanded) ---
             'חשמל ותאורה': {
                'keywords': ['סוללות', 'נורה', 'לד', 'כבל מאריך', 'מפצל', 'שקע', 'תקע', 'מתג'],
                'parent': 'מוצרים לבית'
            },
             'מוצרי חשמל ואלקטרוניקה': {
                'keywords': ['טלוויזיה', 'מסך', 'מחשב', 'סלולר', 'מטען', 'אוזניות', 'כבל', 'גלקסי', 'אייפון', 'שיאומי', 'usb', 'hdmi', 'מיקרוגל', 'תנור', 'טוסטר', 'קומקום', 'בלנדר', 'מכונת כביסה', 'מקרר', 'מגהץ', 'פלטה', 'מיחם', 'מאוורר', 'מפזר חום', 'רדיאטור', 'מזגן'],
                'parent': 'מוצרים לבית'
            },
            'כלי בית ומטבח': {
                 'keywords': ['קופסת אוכל', 'סיר', 'מחבת', 'צלחת', 'כוס', 'ספל', 'קערה', 'מגש', 'סכין שף', 'כלי אחסון', 'קולפן', 'פומפיה', 'קרש חיתוך', 'תבנית'],
                 'parent': 'מוצרים לבית'
            },
            'כלי עבודה': {
                'keywords': ['בוקסה', 'מפתח שוודי', 'מפתח צינורות', 'מפתח סגירה', 'מברג', 'פטיש', 'מקדחה', 'דיסק חיתוך', 'דיסק ליטוש', 'משחזת', 'פלייר', 'מטר מדידה', 'אימפקט', 'מסור', 'מקדח', 'דיבלים', 'ברגים'],
                'parent': 'מוצרים לבית'
            },

            # --- פארם ויופי (Expanded) ---
            'איפור וקוסמטיקה': {
                'keywords': ['צבע לשיער', 'ליפסטיק', 'אודם', 'מייקאפ', 'לק', 'מסיר איפור', 'מסקרה', 'צללית', 'איליינר', 'קרם פנים', 'סרום', 'בושם', 'אדט', 'אדפ', 'או דה טואלט'],
                'parent': 'פארם ובריאות'
            },
            
            # ... (rest of rules)

        }

    def get_db_connection(self):
        return psycopg2.connect(**self.db_config)
        
    def categorize_product(self, product_name: str) -> Optional[Tuple[str, str]]:
        """
        Determine category based on product name.
        Uses Regex Word Boundaries to avoid partial matches (e.g. 'דיסק' in 'דיסקריט').
        Returns: (Category Name, Parent Category)
        """
        # Normalize name: lowercase, dots/dashes to spaces, keep Hebrew/English chars
        name = product_name.lower().replace('-', ' ').replace('.', ' ').replace(',', ' ')
        # Clean extra spaces
        name = ' '.join(name.split())
        
        for category, rule in self.rules.items():
            # Check negatives first (Substring is often safer for negatives, but let's consistency)
            # Actually negatives match often compound words, so substring match is usually OK for negatives
            # but regex is safer to avoid over-blocking.
            if 'negative' in rule:
                if any(neg in name for neg in rule['negative']):
                    continue
            
            # Check keywords with Word Boundary
            # Compile regex pattern: (\bkw1\b|\bkw2\b|...)
            # For efficiency we could cache these patterns, but current list is small enough.
            
            for kw in rule['keywords']:
                # Escape keyword just in case
                escaped = re.escape(kw)
                # Note: Hebrew boundaries \b might be tricky with non-word chars. 
                # Better approach: (?:^|\s)keyword(?:$|\s)
                pattern = r'(?:^|\s)' + escaped + r'(?:$|\s)'
                
                if re.search(pattern, name):
                    return category, rule['parent']
                
        return None, None

    def setup_categories(self, conn):
        """Ensure all categories exist in DB (supporting English/Hebrew)"""
        cur = conn.cursor()
        
        # 1. Ensure Root 'supermarket'
        cur.execute("SELECT id FROM verticals WHERE slug='supermarket'")
        res = cur.fetchone()
        if not res:
            cur.execute("INSERT INTO verticals (name, slug) VALUES ('Supermarket', 'supermarket') RETURNING id")
            vertical_id = cur.fetchone()[0]
        else:
            vertical_id = res[0]
            
        # 2. Collect all unique Parents and Children
        parents = set()
        children = set()
        for cat, rule in self.rules.items():
            parents.add(rule['parent'])
            children.add((cat, rule['parent']))
            
        # 3. Insert Parents (Level 1)
        parent_map = {} # Name -> ID
        
        # English mapping dictionary (Ideally this would be in a config file)
        en_map = {
            'פירות וירקות': 'Fruits & Vegetables',
            'חלב ומוצרי חלב': 'Dairy & Cheese',
            'לחמים ומאפים': 'Bread & Bakery',
            'בשר ודגים': 'Meat & Fish',
            'דגנים ופסטות': 'Grains & Pasta',
            'מוצרי אפייה': 'Baking Needs',
            'שימורים': 'Canned Goods',
            'תבלינים ורטבים': 'Spices & Sauces',
            'משקאות': 'Beverages',
            'מוצרים קפואים': 'Frozen Food',
            'מוצרי ניקיון': 'Cleaning Supplies',
            'נייר ומוצרי חד פעמי': 'Paper & Disposables',
            'מוצרי היגיינה': 'Hygiene & Personal Care',
            'תינוקות': 'Baby Products',
            'חיות מחמד': 'Pets',
            'פארם ובריאות': 'Pharmacy & Health',
            'מוצרים לבית': 'Home & Electrical',
        }

        for parent in parents:
            slug_val = parent.replace(' ', '-')
            full_path = f"supermarket/{slug_val}"
            
            # Use name_en if column exists, else ignore (handled by schema migration ideally)
            # For now simplified insert
            
            cur.execute("""
                INSERT INTO categories (name, slug, full_path, level)
                VALUES (%s, %s, %s, 1)
                ON CONFLICT (full_path) DO UPDATE SET name=EXCLUDED.name
                RETURNING id
            """, (parent, slug_val, full_path))
            parent_map[parent] = cur.fetchone()[0]
            
        # 4. Insert Children (Level 2)
        child_map = {}
        for child, parent_name in children:
            parent_id = parent_map[parent_name]
            child_slug_val = child.replace(' ', '-')
            full_path = f"supermarket/{parent_name.replace(' ', '-')}/{child_slug_val}"
            
            cur.execute("""
                INSERT INTO categories (name, slug, full_path, parent_id, level)
                VALUES (%s, %s, %s, %s, 2)
                ON CONFLICT (full_path) DO UPDATE SET name=EXCLUDED.name, parent_id=EXCLUDED.parent_id
                RETURNING id
            """, (child, child_slug_val, full_path, parent_id))
            child_map[child] = cur.fetchone()[0]
            
        conn.commit()
        logger.info(f"✓ Setup complete: {len(parents)} parents, {len(children)} sub-categories")
        return child_map

    def run_bulk_categorization(self):
        """Categorize all uncategorized products in DB"""
        conn = self.get_db_connection()
        cur = conn.cursor()
        
        try:
            logger.info("Setting up category hierarchy based on Google Product Taxonomy principles...")
            category_map = self.setup_categories(conn)
            
            # Fetch products needing categorization
            # Criteria: category_id IS NULL OR category_id points to "Other" (292, 404)
            # LIMIT: Process 10,000 at a time to keep it snappy
            logger.info("Fetching products to categorize...")
            cur.execute("""
                SELECT id, name FROM products 
                WHERE category_id IS NULL 
                   OR category_id IN (292, 404)
                LIMIT 50000
            """)
            points_to_process = cur.fetchall()
            logger.info(f"Found {len(points_to_process)} products to process")
            
            updates = []
            classified_count = 0
            
            for pid, name in points_to_process:
                cat_name, parent_name = self.categorize_product(name)
                
                if cat_name and cat_name in category_map:
                    cat_id = category_map[cat_name]
                    updates.append((cat_id, pid))
                    classified_count += 1
                    
                if len(updates) >= 1000:
                    self._commit_batch(cur, updates)
                    updates = []
                    
            if updates:
                self._commit_batch(cur, updates)
                
            conn.commit()
            logger.info(f"✓ Categorization complete: {classified_count}/{len(points_to_process)} classified")
            
        except Exception as e:
            logger.error(f"Categorization failed: {e}")
            conn.rollback()
        finally:
            conn.close()

    def _commit_batch(self, cur, updates):
        from psycopg2.extras import execute_values
        # Correct way to do bulk update with execute_values
        query = """
            UPDATE products AS p 
            SET category_id = v.cat_id 
            FROM (VALUES %s) AS v(cat_id, pid) 
            WHERE p.id = v.pid
        """
        execute_values(cur, query, updates)
        logger.info(f"Updated {len(updates)} products")

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    
    db_config = {
        'dbname': os.getenv('DB_NAME', 'gogobe'),
        'user': os.getenv('DB_USER', 'postgres'),
        'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
        'host': os.getenv('DB_HOST', 'localhost'),
        'port': os.getenv('DB_PORT', '5432')
    }
    
    categorizer = AutoCategorizer(db_config)
    categorizer.run_bulk_categorization()
