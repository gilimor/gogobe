#!/usr/bin/env python3
"""
Create hierarchical category structure for Supermarket vertical
Based on project documentation (schema.sql)
"""
import psycopg2
import os

# Hierarchical category structure
CATEGORY_TREE = {
    'חלב ומוצרי חלב': {
        'children': [
            'חלב טרי',
            'חלב מעובד',
            'גבינות קשות',
            'גבינות רכות',
            'יוגורטים',
            'שמנת וחמאה',
            'מעדנים',
        ],
        'keywords': ['חלב', 'גבינה', 'קוטג', 'יוגורט', 'שמנת', 'חמאה', 'לבן', 'מעדן', 'פודינג', 'בולגרית', 'דנונה']
    },
    'בשר ודגים': {
        'children': [
            'בשר בקר',
            'בשר עוף',
            'בשר מעובד',
            'דגים',
        ],
        'keywords': ['בשר', 'עוף', 'הודו', 'נקניק', 'קבב', 'פסטרמה', 'סלמי', 'נקניקיות', 'דג', 'פילה', 'המבורגר', 'שניצל']
    },
    'לחמים ומאפים': {
        'children': [
            'לחמים',
            'חלות',
            'מאפים מתוקים',
            'עוגיות וביסקוויטים',
        ],
        'keywords': ['לחם', 'חלה', 'פיתה', 'בגט', 'לחמניה', 'מאפה', 'עוגה', 'עוגיות', 'ביסקוויט', 'קרקר', 'ופל']
    },
    'פירות וירקות': {
        'children': [
            'פירות טריים',
            'ירקות טריים',
            'פירות קפואים',
            'ירקות קפואים',
        ],
        'keywords': ['תפוח', 'בננה', 'תפוז', 'אבוקדו', 'מלפפון', 'עגבניה', 'חסה', 'גזר', 'בצל', 'שום', 'פלפל', 'תרד']
    },
    'דגנים ופסטות': {
        'children': [
            'אורז',
            'פסטות',
            'קמח',
            'דגני בוקר',
        ],
        'keywords': ['אורז', 'פסטה', 'ספגטי', 'מקרוני', 'קוסקוס', 'בורגול', 'קמח', 'פתיתים', 'קורנפלקס', 'שיבולת']
    },
    'שימורים': {
        'children': [
            'שימורי דגים',
            'שימורי ירקות',
            'שימורי פירות',
        ],
        'keywords': ['שימורים', 'קופסה', 'טונה', 'תירס', 'פטריות', 'זיתים', 'חומוס', 'טחינה', 'ממרח']
    },
    'ממתקים וחטיפים': {
        'children': [
            'שוקולד',
            'סוכריות',
            'חטיפים מלוחים',
        ],
        'keywords': ['שוקולד', 'סוכריות', 'ממתק', 'וופל', 'חטיף', 'במבה', 'ביסלי', 'דורי', 'טפוצי']
    },
    'משקאות': {
        'children': [
            'משקאות קלים',
            'מיצים',
            'משקאות חמים',
            'אלכוהול',
        ],
        'keywords': ['קולה', 'ספרייט', 'פאנטה', 'משקה', 'מיץ', 'סודה', 'בירה', 'יין', 'קפה', 'תה', 'נקטר']
    },
    'מוצרי ניקיון': {
        'children': [
            'ניקוי כלים',
            'ניקוי כביסה',
            'ניקוי רצפות',
            'ניקוי אסלה',
        ],
        'keywords': ['סבון', 'אבקת כביסה', 'מרכך', 'ניקוי', 'דומסטוס', 'אסלה', 'רצפה', 'כלים', 'ג\'ל']
    },
    'מוצרי היגיינה': {
        'children': [
            'נייר טואלט',
            'מוצרי רחצה',
            'טיפוח שיער',
            'טיפוח פה',
        ],
        'keywords': ['טואלט', 'מגבת', 'תחבושת', 'טמפון', 'חיתול', 'שמפו', 'מרכך שיער', 'משחת שיניים', 'מברשת']
    },
    'תינוקות': {
        'children': [
            'חיתולים',
            'מזון לתינוקות',
            'אביזרים לתינוקות',
        ],
        'keywords': ['תינוק', 'חיתול', 'מוצץ', 'בקבוק', 'מטרנה', 'מילופה', 'סימילאק', 'ביולה']
    },
    'נייר ומוצרי חד פעמי': {
        'children': [
            'מגבות נייר',
            'צלחות חד פעמי',
            'כוסות וסכו"ם',
        ],
        'keywords': ['נייר', 'ניר', 'מגבת נייר', 'טישו', 'צלחת חד פעמי', 'כוס חד פעמי', 'מזלג', 'סכין', 'אלומיניום']
    },
    'תבלינים ורטבים': {
        'children': [
            'תבלינים',
            'רטבים',
            'שמנים',
        ],
        'keywords': ['תבלין', 'פלפל שחור', 'מלח', 'כורכום', 'קארי', 'קטשופ', 'מיונז', 'חרדל', 'רוטב', 'שמן', 'זית']
    },
}

def main():
    conn = psycopg2.connect(
        dbname=os.getenv('DB_NAME', 'gogobe'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host=os.getenv('DB_HOST', 'db'),
        port=os.getenv('DB_PORT', '5432'),
        client_encoding='UTF8'
    )
    
    cur = conn.cursor()
    
    print("=" * 80)
    print("CREATING HIERARCHICAL CATEGORY STRUCTURE")
    print("=" * 80)
    
    # Get supermarket vertical
    cur.execute("SELECT id FROM verticals WHERE slug = 'supermarket'")
    vertical_id = cur.fetchone()[0]
    
    # Create main categories and subcategories
    category_mapping = {}  # parent_name -> id
    
    for parent_name, data in CATEGORY_TREE.items():
        parent_slug = parent_name.replace(' ', '-').lower()
        
        # Create or get parent category
        cur.execute("""
            INSERT INTO categories (vertical_id, name, slug, level, full_path)
            VALUES (%s, %s, %s, 1, %s)
            ON CONFLICT (vertical_id, slug, parent_id) DO UPDATE
            SET name = EXCLUDED.name
            RETURNING id
        """, (vertical_id, parent_name, parent_slug, f'supermarket/{parent_slug}'))
        
        parent_id = cur.fetchone()[0]
        category_mapping[parent_name] = {
            'id': parent_id,
            'keywords': data['keywords']
        }
        
        print(f"\n📁 {parent_name} (ID: {parent_id})")
        
        # Create subcategories
        for child_name in data.get('children', []):
            child_slug = child_name.replace(' ', '-').lower()
            
            cur.execute("""
                INSERT INTO categories (vertical_id, parent_id, name, slug, level, full_path)
                VALUES (%s, %s, %s, %s, 2, %s)
                ON CONFLICT (vertical_id, slug, parent_id) DO UPDATE
                SET name = EXCLUDED.name
                RETURNING id
            """, (vertical_id, parent_id, child_name, child_slug, f'supermarket/{parent_slug}/{child_slug}'))
            
            child_id = cur.fetchone()[0]
            print(f"  ├─ {child_name} (ID: {child_id})")
    
    conn.commit()
    
    print(f"\n✅ Created hierarchical structure:")
    print(f"   - {len(CATEGORY_TREE)} main categories")
    print(f"   - {sum(len(v.get('children', [])) for v in CATEGORY_TREE.values())} subcategories")
    
    print("\n" + "=" * 80)
    print("Recategorizing products with hierarchy...")
    print("=" * 80)
    
    # Now recategorize products
    for parent_name, data in category_mapping.items():
        parent_id = data['id']
        keywords = data['keywords']
        
        # Build search condition
        conditions = ' OR '.join(['LOWER(name) LIKE %s'] * len(keywords))
        params = [f'%{kw}%' for kw in keywords]
        
        query = f"""
            UPDATE products
            SET category_id = %s
            WHERE vertical_id = %s
            AND ({conditions})
        """
        
        params.insert(0, parent_id)
        params.insert(1, vertical_id)
        
        cur.execute(query, params)
        
        updated = cur.rowcount
        if updated > 0:
            print(f"  {parent_name}: {updated} products")
    
    conn.commit()
    
    print("\n✅ Recategorization complete!")
    print("=" * 80)
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()

