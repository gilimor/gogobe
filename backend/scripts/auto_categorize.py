#!/usr/bin/env python3
"""
Auto-categorize products based on product names
"""
import psycopg2
import os
import re

# Category keywords mapping (Hebrew)
CATEGORY_KEYWORDS = {
    'חלב ומוצרי חלב': [
        'חלב', 'גבינה', 'קוטג', 'יוגורט', 'שמנת', 'חמאה', 'לבן', 'מעדן', 'פודינג',
        'בולגרית', 'דנונה', 'תנובה', 'יטבתה', 'גד', 'פירות ירקות'
    ],
    'בשר ודגים': [
        'בשר', 'עוף', 'הודו', 'נקניק', 'קבב', 'פסטרמה', 'סלמי', 'נקניקיות',
        'דג', 'פילה', 'המבורגר', 'שניצל', 'כבד'
    ],
    'לחמים ומאפים': [
        'לחם', 'חלה', 'פיתה', 'בגט', 'לחמניה', 'מאפה', 'עוגה', 'עוגיות',
        'ביסקוויט', 'קרקר', 'ופל', 'רוגלך', 'בורקס'
    ],
    'פירות וירקות': [
        'תפוח', 'בננה', 'תפוז', 'אבוקדו', 'מלפפון', 'עגבניה', 'חסה', 'גזר',
        'בצל', 'שום', 'פלפל', 'תפוד', 'ירקות', 'פירות', 'מיץ', 'תרד'
    ],
    'דגנים ופסטות': [
        'אורז', 'פסטה', 'ספגטי', 'מקרוני', 'קוסקוס', 'בורגול', 'קמח',
        'פתיתים', 'קורנפלקס', 'שיבולת', 'דגנים', 'פנקייק'
    ],
    'שימורים': [
        'שימורים', 'קופסה', 'טונה', 'תירס', 'פטריות', 'זיתים', 'חומוס',
        'טחינה', 'ממרח', 'רסק', 'משמש'
    ],
    'ממתקים וחטיפים': [
        'שוקולד', 'סוכריות', 'ממתק', 'וופל', 'חטיף', 'במבה', 'ביסלי', 
        'דורי', 'טפוצי', 'גומי', 'סוכר', 'דבש'
    ],
    'משקאות': [
        'קולה', 'ספרייט', 'פאנטה', 'משקה', 'מיץ', 'סודה', 'בירה', 'יין',
        'וודקה', 'וויסקי', 'מים', 'קפה', 'תה', 'נסקפה', 'נקטר'
    ],
    'מוצרי ניקיון': [
        'סבון', 'אבקת כביסה', 'מרכך', 'ניקוי', 'סמרטוט', 'ספוג', 'דומסטוס',
        'אסלה', 'רצפה', 'כלים', 'ג\'ל', 'אקונומיקה'
    ],
    'מוצרי היגיינה': [
        'טואלט', 'מגבת', 'תחבושת', 'טמפון', 'חיתול', 'שמפו', 'מרכך שיער',
        'משחת שיניים', 'מברשת', 'דאודורנט', 'סבון גוף', 'מקלחת'
    ],
    'תינוקות': [
        'תינוק', 'חיתול', 'מוצץ', 'בקבוק', 'מטרנה', 'מילופה', 'סימילאק',
        'אוכל תינוקות', 'ביולה'
    ],
    'נייר ומוצרי חד פעמי': [
        'נייר', 'ניר', 'מגבת נייר', 'טישו', 'ממחטה', 'צלחת חד פעמי',
        'כוס חד פעמי', 'מזלג', 'סכין', 'קש', 'אלומיניום', 'פויל', 'תבנית'
    ],
    'תבלינים ורטבים': [
        'תבלין', 'פלפל שחור', 'מלח', 'כורכום', 'קארי', 'קטשופ', 'מיונז',
        'חרדל', 'רוטב', 'חומץ', 'שמן', 'זית', 'קנולה'
    ],
}

def categorize_product(name):
    """Find category for product based on name"""
    name_lower = name.lower()
    
    # Check each category
    for category, keywords in CATEGORY_KEYWORDS.items():
        for keyword in keywords:
            if keyword in name_lower:
                return category
    
    return 'אחר'  # Default category

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
    print("AUTO-CATEGORIZING PRODUCTS")
    print("=" * 80)
    
    # Create categories
    print("\nCreating categories...")
    
    # Get supermarket vertical ID
    cur.execute("SELECT id FROM verticals WHERE slug = 'supermarket'")
    vertical_id = cur.fetchone()[0]
    
    for category_name in CATEGORY_KEYWORDS.keys():
        slug = category_name.replace(' ', '-').lower()
        cur.execute("""
            INSERT INTO categories (name, slug, vertical_id)
            VALUES (%s, %s, %s)
            ON CONFLICT (vertical_id, slug, parent_id) DO NOTHING
        """, (category_name, slug, vertical_id))
    
    # Create "Other" category
    cur.execute("""
        INSERT INTO categories (name, slug, vertical_id)
        VALUES ('אחר', 'other', %s)
        ON CONFLICT (vertical_id, slug, parent_id) DO NOTHING
    """, (vertical_id,))
    
    conn.commit()
    
    # Get all categories
    cur.execute("SELECT id, name FROM categories")
    categories = {row[1]: row[0] for row in cur.fetchall()}
    
    print(f"Created {len(categories)} categories")
    
    # Get products without category
    cur.execute("""
        SELECT id, name 
        FROM products 
        WHERE category_id IS NULL
        AND vertical_id = (SELECT id FROM verticals WHERE slug = 'supermarket')
    """)
    
    products = cur.fetchall()
    print(f"\nCategorizing {len(products)} products...")
    
    categorized = {}
    for product_id, name in products:
        category_name = categorize_product(name)
        category_id = categories.get(category_name)
        
        if category_id:
            cur.execute("""
                UPDATE products 
                SET category_id = %s 
                WHERE id = %s
            """, (category_id, product_id))
            
            categorized[category_name] = categorized.get(category_name, 0) + 1
            
            if sum(categorized.values()) % 500 == 0:
                print(f"  Categorized {sum(categorized.values())}...")
                conn.commit()
    
    conn.commit()
    
    print(f"\n✅ Categorized {sum(categorized.values())} products")
    print("\nBreakdown by category:")
    for cat, count in sorted(categorized.items(), key=lambda x: x[1], reverse=True):
        print(f"  {cat}: {count}")
    
    print("=" * 80)
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()

