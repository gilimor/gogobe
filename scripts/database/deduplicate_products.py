"""
Product Deduplication Script
Merges duplicate products based on barcode/name similarity
"""

import psycopg2
from psycopg2.extras import RealDictCursor
from difflib import SequenceMatcher
import re

# Database configuration
DB_CONFIG = {
    'dbname': 'gogobe',
    'user': 'postgres',
    'password': '9152245-Gl!',
    'host': 'localhost',
    'port': '5432'
}

def normalize_name(name):
    """Normalize product name for comparison"""
    if not name:
        return ""
    
    # Convert to lowercase
    name = name.lower()
    
    # Remove extra spaces
    name = ' '.join(name.split())
    
    # Remove special characters but keep hebrew/english/numbers
    name = re.sub(r'[^\u0590-\u05FFa-z0-9\s]', '', name)
    
    return name

def similarity_ratio(name1, name2):
    """Calculate similarity between two names"""
    n1 = normalize_name(name1)
    n2 = normalize_name(name2)
    return SequenceMatcher(None, n1, n2).ratio()

def find_duplicates(conn):
    """Find potential duplicate products"""
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    print("=" * 80)
    print("🔍 מחפש מוצרים כפולים...")
    print("=" * 80)
    
    # Step 1: Find products with same barcode (EAN)
    print("\n1️⃣  מוצרים עם אותו ברקוד:")
    cur.execute("""
        SELECT 
            ean,
            COUNT(*) as product_count,
            array_agg(id) as product_ids,
            array_agg(name) as product_names
        FROM products
        WHERE ean IS NOT NULL AND ean != ''
        GROUP BY ean
        HAVING COUNT(*) > 1
        ORDER BY COUNT(*) DESC
        LIMIT 20
    """)
    
    barcode_duplicates = cur.fetchall()
    print(f"   נמצאו {len(barcode_duplicates)} ברקודים כפולים")
    
    for dup in barcode_duplicates[:5]:
        print(f"   ברקוד {dup['ean']}: {dup['product_count']} מוצרים")
        for name in dup['product_names'][:3]:
            print(f"      - {name[:60]}")
    
    # Step 2: Find products with similar names (same category)
    print("\n2️⃣  מוצרים עם שמות דומים:")
    cur.execute("""
        SELECT 
            p1.id as id1,
            p1.name as name1,
            p2.id as id2,
            p2.name as name2,
            p1.category_id
        FROM products p1
        JOIN products p2 ON p1.category_id = p2.category_id 
            AND p1.id < p2.id
        WHERE p1.category_id IS NOT NULL
        LIMIT 1000
    """)
    
    similar_products = []
    for row in cur.fetchall():
        ratio = similarity_ratio(row['name1'], row['name2'])
        if ratio > 0.85:  # 85% similarity
            similar_products.append({
                'id1': row['id1'],
                'id2': row['id2'],
                'name1': row['name1'],
                'name2': row['name2'],
                'similarity': ratio
            })
    
    similar_products.sort(key=lambda x: x['similarity'], reverse=True)
    print(f"   נמצאו {len(similar_products)} צמדים דומים")
    
    for sim in similar_products[:5]:
        print(f"   {sim['similarity']:.0%} דומים:")
        print(f"      - {sim['name1'][:50]}")
        print(f"      - {sim['name2'][:50]}")
    
    cur.close()
    return barcode_duplicates, similar_products

def merge_products(conn, master_id, duplicate_ids, dry_run=True):
    """Merge duplicate products into one master product"""
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        print(f"\n{'[DRY RUN] ' if dry_run else ''}מאחד מוצרים:")
        print(f"   מוצר ראשי: {master_id}")
        print(f"   מוצרים לאיחוד: {duplicate_ids}")
        
        # Update all prices to point to master product
        for dup_id in duplicate_ids:
            if not dry_run:
                cur.execute("""
                    UPDATE prices
                    SET product_id = %s
                    WHERE product_id = %s
                """, (master_id, dup_id))
                
                affected = cur.rowcount
                print(f"   ✓ הועברו {affected} מחירים ממוצר {dup_id}")
            else:
                cur.execute("""
                    SELECT COUNT(*) as count
                    FROM prices
                    WHERE product_id = %s
                """, (dup_id,))
                count = cur.fetchone()['count']
                print(f"   [DRY RUN] יועברו {count} מחירים ממוצר {dup_id}")
        
        # Delete duplicate products
        if not dry_run:
            cur.execute("""
                DELETE FROM products
                WHERE id = ANY(%s)
            """, (duplicate_ids,))
            print(f"   ✓ נמחקו {len(duplicate_ids)} מוצרים כפולים")
        else:
            print(f"   [DRY RUN] יימחקו {len(duplicate_ids)} מוצרים כפולים")
        
        if not dry_run:
            conn.commit()
            print("   ✅ האיחוד הושלם!")
        else:
            print("   [DRY RUN] לא בוצעו שינויים")
        
    except Exception as e:
        conn.rollback()
        print(f"   ❌ שגיאה: {e}")
    
    cur.close()

def auto_merge_by_barcode(conn, dry_run=True):
    """Automatically merge products with same barcode"""
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    print("\n" + "=" * 80)
    print(f"{'[DRY RUN] ' if dry_run else ''}🔀 איחוד אוטומטי לפי ברקוד")
    print("=" * 80)
    
    # Get all barcode groups
    cur.execute("""
        SELECT 
            ean,
            array_agg(id ORDER BY id) as product_ids
        FROM products
        WHERE ean IS NOT NULL AND ean != ''
        GROUP BY ean
        HAVING COUNT(*) > 1
    """)
    
    duplicates = cur.fetchall()
    total_merged = 0
    
    for dup in duplicates:
        master_id = dup['product_ids'][0]  # First product is master
        duplicate_ids = dup['product_ids'][1:]  # Rest are duplicates
        
        merge_products(conn, master_id, duplicate_ids, dry_run=dry_run)
        total_merged += len(duplicate_ids)
    
    print(f"\n{'[DRY RUN] ' if dry_run else ''}סה\"כ: {total_merged} מוצרים אוחדו מתוך {len(duplicates)} קבוצות")
    
    cur.close()
    return total_merged

def main():
    """Main execution"""
    print("=" * 80)
    print("🔧 Product Deduplication Tool")
    print("=" * 80)
    
    conn = psycopg2.connect(**DB_CONFIG)
    
    try:
        # Find duplicates
        barcode_dups, similar_dups = find_duplicates(conn)
        
        # Show summary
        print("\n" + "=" * 80)
        print("📊 סיכום:")
        print("=" * 80)
        print(f"   ברקודים כפולים: {len(barcode_dups)}")
        print(f"   שמות דומים: {len(similar_dups)}")
        
        # Ask user
        print("\n" + "=" * 80)
        print("🤔 מה לעשות?")
        print("=" * 80)
        print("   1. Dry Run - הצג מה יקרה (ללא שינויים)")
        print("   2. Merge - אחד מוצרים לפי ברקוד (משנה DB!)")
        print("   3. יציאה")
        
        choice = input("\nבחר (1/2/3): ").strip()
        
        if choice == "1":
            auto_merge_by_barcode(conn, dry_run=True)
        elif choice == "2":
            confirm = input("\n⚠️  זה ישנה את הDB! אתה בטוח? (yes/no): ").strip().lower()
            if confirm == "yes":
                auto_merge_by_barcode(conn, dry_run=False)
            else:
                print("בוטל.")
        else:
            print("יציאה.")
    
    finally:
        conn.close()
    
    print("\n" + "=" * 80)
    print("✅ הסתיים!")
    print("=" * 80)

if __name__ == "__main__":
    main()

