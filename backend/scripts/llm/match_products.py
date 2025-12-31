import sys
import os
import logging
from typing import List, Dict
import json

# Add app root to path to import database module
current_dir = os.path.dirname(os.path.abspath(__file__))
# Navigate up to the root (backend/scripts/llm -> backend/scripts -> backend -> root)
app_root = os.path.abspath(os.path.join(current_dir, "..", "..", ".."))
if app_root not in sys.path:
    sys.path.insert(0, app_root)

try:
    from backend.database.db_connection import get_db_cursor
except ImportError:
    # Fallback if structure is different
    from database.db_connection import get_db_cursor

try:
    from thefuzz import fuzz, process
except ImportError:
    fuzz, process = None, None

try:
    import google.generativeai as genai
except ImportError:
    genai = None

try:
    from .config import LLM_PROVIDER, GEMINI_API_KEY, OPENAI_API_KEY
except (ImportError, ValueError):
    try:
        from backend.scripts.llm.config import LLM_PROVIDER, GEMINI_API_KEY, OPENAI_API_KEY
    except ImportError:
        try:
            from config import LLM_PROVIDER, GEMINI_API_KEY, OPENAI_API_KEY
        except ImportError:
            LLM_PROVIDER, GEMINI_API_KEY, OPENAI_API_KEY = 'mock', '', ''

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("LLM_Matcher")

# Configure Gemini if available
if genai and GEMINI_API_KEY:
    genai.configure(api_key=GEMINI_API_KEY)

def get_unmapped_products(limit=100) -> List[Dict]:
    """Get products that don't have a master yet"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        cur.execute("""
            SELECT id, name, description 
            FROM products 
            WHERE master_product_id IS NULL AND is_active = TRUE 
            ORDER BY created_at DESC
            LIMIT %s
        """, (limit,))
        return cur.fetchall()
    finally:
        cur.close()
        conn.close()

def get_feedback_history() -> List[Dict]:
    """Get manual rejections to avoid repeating them"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        cur.execute("SELECT product_id, master_product_id FROM matching_feedback WHERE feedback_type = 'reject'")
        return cur.fetchall()
    finally:
        cur.close()
        conn.close()

import re

def extract_attributes(name: str) -> Dict:
    """
    Extract weight/volume, units, and flavors/scents from product name.
    Example: "Milk 3% 1L" -> {"weight": 1.0, "unit": "l", "flavors": set()}
    """
    res = {"weight": None, "unit": None, "brand": None, "flavors": set()}
    
    # 1. Weight/Volume Extraction
    # Added ג', ג, מל' to the units list
    # The regex below tries to catch numbers + units even without spaces
    weight_pattern = r'(\d+[\.]?\d*)\s*(ml|(?:\'|מל|מ"ל)|(?:\'|ג"ר|גר|ג|ג)|(?:\'|ל|ליטר)|kg|(?:\'|ק"ג|קג))'
    match = re.search(weight_pattern, name.lower())
    if match:
        val = float(match.group(1))
        unit_raw = match.group(2)
        
        # Normalize units
        unit = 'other'
        if any(x in unit_raw for x in ['ג"ר', 'גר', 'ג']): unit = 'g'
        elif any(x in unit_raw for x in ['ל', 'ליטר']): unit = 'l'
        elif any(x in unit_raw for x in ['ק"ג', 'קג', 'kg']): unit = 'kg'
        elif any(x in unit_raw for x in ['ml', 'מל', 'מ"ל']): unit = 'ml'
        
        res['weight'] = val
        res['unit'] = unit
        res['original'] = match.group(0)

    # 2. Flavor/Scent Extraction (Multiple allowed)
    flavor_list = [
        'וניל', 'שוקולד', 'תות', 'בננה', 'ריבת חלב', 'פיסטוק', 'קפה', 'מוקה', 
        'לימון', 'תפוז', 'דובדבן', 'קרמל', 'חרדל', 'קטשופ', 'ברביקיו', 'מעושן', 
        'אפרסק', 'מנגו', 'אננס', 'מלון', 'אוכמניות', 'פטל', 'אגוז', 'שקדים'
    ]
    for f in flavor_list:
        if f in name:
            res['flavors'].add(f)

    # 3. Brand/Manufacturer Detection
    brands = ['תנובה', 'שטראוס', 'טרה', 'אסם', 'עלית', 'יוניליוור', 'נטו', 'סנו', 'וילי פוד', 'גד', 'משק צוריאל', 'מחלבות', 'בלו', 'blu', 'xl', 'אקסאל', 'קוקה קולה', 'פריגת', 'יפאורה', 'טמפו']
    res['brand'] = None
    for b in brands:
        if b in name.lower():
            res['brand'] = b
            break
            
    # 4. Color/Type Detection
    types = ['לבן', 'אדום', 'לייט', 'דיאט', 'זירו', 'נטול', 'מלא', 'מריר', 'חלב', 'מועשר', 'דל שומן', 'ללא סוכר']
    res['type'] = None
    for t in types:
        if t in name:
            res['type'] = t
            break
            
    return res

def get_rejected_examples(limit=5) -> str:
    """Get a few recently rejected matches to teach the AI what NOT to do"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        cur.execute("""
            SELECT p.name as product_name, m.name as master_name
            FROM matching_feedback f
            JOIN products p ON f.product_id = p.id
            JOIN master_products m ON f.master_product_id = m.id
            WHERE f.feedback_type = 'reject'
            ORDER BY f.id DESC
            LIMIT %s
        """, (limit,))
        examples = cur.fetchall()
        if not examples: return ""
        
        text = "\n⚠️ דוגמאות לקישורים שגויים שדחית בעבר (אל תחזור עליהם!):\n"
        for ex in examples:
            text += f"- המוצר '{ex['product_name']}' הוצע לאוב '{ex['master_name']}' - וזה שגוי! שים לב להבדל בטעם, משקל או יצרן.\n"
        return text
    finally:
        cur.close()
        conn.close()

def cluster_products(products: List[Dict], threshold: int = 85) -> List[List[Dict]]:
    """
    Cluster products using fuzzy string matching + strict attribute check.
    """
    if not fuzz or not process:
        logger.warning("fuzzywuzzy/thefuzz not installed, falling back to naive clustering")
        # Fallback to simple clustering
        clusters = {}
        for p in products:
            key = " ".join(p['name'].split()[:2])
            if key not in clusters: clusters[key] = []
            clusters[key].append(p)
        return [c for c in clusters.values() if len(c) > 1]

    clusters = []
    
    # Pre-extract attributes for all products
    for p in products:
        p['_attrs'] = extract_attributes(p['name'])
    
    for product in products:
        found_cluster = False
        name = product['name']
        attrs = product['_attrs']
        
        # Try to find a matching cluster
        for cluster in clusters:
            rep = cluster[0] # representative
            
            # 1. Strict Attribute Check: If weights OR flavors are different, REJECT
            rep_attrs = rep['_attrs']
            
            # Weight/Unit Check: 150g is NOT 175g
            if attrs['weight'] and rep_attrs['weight']:
                if abs(attrs['weight'] - rep_attrs['weight']) > 0.01 or attrs['unit'] != rep_attrs['unit']:
                    continue
            
            # Flavor Check: Strawberry is NOT Peach-Mango
            # If both have detected flavors and they differ significantly, reject
            if attrs['flavors'] and rep_attrs['flavors']:
                # If they don't have overlapping flavors, they are different
                if not (attrs['flavors'] & rep_attrs['flavors']):
                    continue
            
            # 2. Fuzzy Score
            score = fuzz.token_set_ratio(name, rep['name'])
            if score >= threshold:
                cluster.append(product)
                found_cluster = True
                break
        
        if not found_cluster:
            clusters.append([product])
            
    # Return clusters with at least 2 items
    return [c for c in clusters if len(c) > 1]

def get_approved_examples(limit=5) -> str:
    """Get a few recently approved matches to teach the AI"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        cur.execute("""
            SELECT p.name as product_name, m.name as master_name
            FROM product_master_links l
            JOIN products p ON l.product_id = p.id
            JOIN master_products m ON l.master_product_id = m.id
            WHERE l.match_method = 'manual_approved'
            ORDER BY l.id DESC
            LIMIT %s
        """, (limit,))
        examples = cur.fetchall()
        if not examples: return ""
        
        text = "\nדוגמאות לקישורים נכונים שאישרת בעבר:\n"
        for ex in examples:
            text += f"- המוצר '{ex['product_name']}' קושר לאב '{ex['master_name']}'\n"
        return text
    finally:
        cur.close()
        conn.close()

def call_llm_for_master_name(cluster: List[Dict]) -> Dict:
    """
    Ask LLM for the best Master Name for this cluster.
    Returns: {"name": str, "confidence": float}
    """
    product_names = [p['name'] for p in cluster]
    unique_names = set(n.strip().lower() for n in product_names)
    
    # FAST PATH: If all names are 100% identical, return confidence 1.0 immediately
    if len(unique_names) == 1:
        return {"name": product_names[0], "confidence": 1.0}

    if LLM_PROVIDER == 'mock' or not genai or not GEMINI_API_KEY:
        # Improved mock logic
        best_name = product_names[0].split("-")[0].split("(")[0].strip()
        return {"name": best_name, "confidence": 0.7}

    # Fetch few-shot examples (Positive and Negative)
    examples_text = get_approved_examples(5)
    negative_examples = get_rejected_examples(5)

    try:
        model = genai.GenerativeModel('gemini-1.5-flash')
        prompt = f"""
        אני עושה סדר בקטלוג מוצרים. לפניך רשימת שמות של אותו מוצר כפי שהם מופיעים בחנויות שונות:
        {json.dumps(product_names, ensure_ascii=False)}
        
        {examples_text}
        
        {negative_examples}
        
        משימה קריטית (עקרונות ברזל):
        1. צור שם "אב מוצר" (Master Product Name) נקי ורשמי בעברית.
        2. שים לב במיוחד: 150 גרם זה לא 175 גרם! וניל זה לא שוקולד! תות זה לא אפרסק! שטראוס זה לא תנובה! XL זה לא BLU!
        3. המשתמש לחץ על ה-X האדום על הצעות קודמות שכללו שילובים כאלו. למד מהם ואל תחזור על הטעות!
        4. אם המוצרים ברשימה הם בעלי משקל שונה, טעם שונה, צבע/סוג שונה או יצרן/מותג שונה - הם אינם אותו מוצר בשום פנים ואופן.
        5. השם חייב לכלול את המותג, סוג המוצר, הטעם הספציפי ומשקל/נפח מדויק.
        6. החזר ציון ביטחון (confidence) של 0.1 בלבד אם יש ולו גרם אחד של שוני, או כל הבדל אחר שראית בדוגמאות השגויות.
        
        החזר תשובה בפורמט JSON בלבד:
        {{"name": "שם המוצר", "confidence": 0.95}}
        """
        
        response = model.generate_content(prompt)
        # Attempt to parse JSON from response
        try:
            # Clean up potential markdown formatting
            text = response.text.strip()
            if "```json" in text:
                text = text.split("```json")[1].split("```")[0].strip()
            elif "```" in text:
                text = text.split("```")[1].split("```")[0].strip()
            
            result = json.loads(text)
            return {
                "name": result.get("name", product_names[0]),
                "confidence": result.get("confidence", 0.9)
            }
        except Exception as e:
            logger.error(f"Error parsing Gemini response: {e}. Raw: {response.text}")
            return {"name": product_names[0].split("-")[0].strip(), "confidence": 0.5}
            
    except Exception as e:
        logger.error(f"Gemini API error: {e}")
        return {"name": product_names[0].split("-")[0].strip(), "confidence": 0.5}

def save_matches(cluster: List[Dict], master_data: Dict):
    """Save the suggested matches to DB (as 'llm_pending' links)"""
    conn, cur = get_db_cursor(dict_cursor=True)
    master_name = master_data['name']
    confidence = master_data['confidence']
    
    try:
        # 1. Check if a master with this name already exists (Strict: Trim + Lower)
        cur.execute("SELECT id FROM master_products WHERE LOWER(TRIM(name)) = LOWER(TRIM(%s))", (master_name,))
        existing_master = cur.fetchone()
        
        if existing_master:
            master_id = existing_master['id']
            logger.info(f"Reusing existing master '{master_name}' (ID: {master_id})")
            # Fetch rejections for this master
            cur.execute("SELECT product_id FROM matching_feedback WHERE master_product_id = %s AND feedback_type = 'reject'", (master_id,))
            rejected_product_ids = {r['product_id'] for r in cur.fetchall()}
        else:
            # Create a potential master (inactive/pending)
            # Ensure we strip it before inserting
            master_name = master_name.strip()
            cur.execute("""
                INSERT INTO master_products (name, is_active, description)
                VALUES (%s, FALSE, 'Auto-generated by AI')
                RETURNING id
            """, (master_name,))
            master_id = cur.fetchone()['id']
            logger.info(f"Created new pending master '{master_name}' (ID: {master_id})")
            rejected_product_ids = set()
        
        for p in cluster:
            # SKIP if this product was explicitly rejected from this master before
            if p['id'] in rejected_product_ids:
                logger.warning(f"Skipping product '{p['name']}' because it was previously rejected from master '{master_name}'")
                continue
                
            # Create link with status 'llm_pending'
            cur.execute("""
                INSERT INTO product_master_links (master_product_id, product_id, confidence_score, match_method)
                VALUES (%s, %s, %s, 'llm_pending')
                ON CONFLICT (product_id) DO UPDATE 
                SET master_product_id = EXCLUDED.master_product_id,
                    confidence_score = EXCLUDED.confidence_score,
                    match_method = 'llm_pending'
                WHERE product_master_links.match_method = 'llm_pending' 
                   OR product_master_links.match_method = 'llm_suggested'
            """, (master_id, p['id'], confidence))
            
        conn.commit()
        logger.info(f"Created pending master '{master_name}' with {len(cluster)} products. Quality: {confidence}")
    except Exception as e:
        conn.rollback()
        logger.error(f"Error saving matches: {e}")
    finally:
        cur.close()
        conn.close()

def run_matching_job(limit: int = 500):
    logger.info("Starting High-Quality LLM Matching Job with Feedback Loop...")
    
    # 1. Fetch unmapped products
    products = get_unmapped_products(limit=limit)
    if not products:
        logger.info("No unmapped products found.")
        return
        
    logger.info(f"Processing {len(products)} unmapped products.")
    
    # 2. Fetch feedback (rejected pairs)
    feedback = get_feedback_history()
    rejected_pairs = {(f['product_id'], f['master_product_id']) for f in feedback}
    logger.info(f"Loaded {len(rejected_pairs)} rejected pairs to avoid.")
    
    # 3. Group into clusters by name similarity + strict weight check
    clusters = cluster_products(products, threshold=88)
    logger.info(f"Found {len(clusters)} potential clusters.")
    
    processed_count = 0
    for cluster in clusters:
        # Check if this cluster contains products previously rejected from each other? 
        # (Actually our clustering is new products only, so we check against existing masters if we were linking to them)
        # But here we are creating NEW masters. 
        
        # 4. Use LLM to get a canonical name
        master_data = call_llm_for_master_name(cluster)
        
        # 5. Save to database as pending suggestions
        save_matches(cluster, master_data)
        processed_count += len(cluster)
        
    logger.info(f"Job Complete. Processed {processed_count} products into {len(clusters)} master suggestions.")

if __name__ == "__main__":
    run_matching_job()
