"""
Simple check of stores and products
"""
import sys
from pathlib import Path

# Add backend to path
backend_path = Path(__file__).parent.parent
sys.path.insert(0, str(backend_path))

from database.db_connection import get_db_connection

def main():
    print("=" * 60)
    print("בדיקת מוצרים וסניפים - KingStore")
    print("=" * 60)
    print()
    
    conn = get_db_connection()
    if not conn:
        print("❌ לא הצלחתי להתחבר לדאטהבייס")
        return
    
    cur = conn.cursor()
    
    # 1. Products count
    print("1. כמה מוצרים יש:")
    cur.execute("""
        SELECT COUNT(*) 
        FROM products 
        WHERE vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%supermarket%')
    """)
    product_count = cur.fetchone()[0]
    print(f"   {product_count:,} מוצרים")
    print()
    
    # 2. Stores count
    print("2. כמה חנויות יש:")
    cur.execute("SELECT COUNT(*) FROM stores")
    store_count = cur.fetchone()[0]
    print(f"   {store_count} חנויות")
    print()
    
    # 3. Stores with prices
    print("3. חנויות עם מחירים:")
    cur.execute("SELECT COUNT(DISTINCT store_id) FROM prices WHERE store_id IS NOT NULL")
    stores_with_prices = cur.fetchone()[0]
    print(f"   {stores_with_prices} חנויות")
    print()
    
    # 4. Products in multiple stores
    print("4. מוצרים שנמכרים ביותר מסניף אחד:")
    cur.execute("""
        SELECT 
            p.name,
            COUNT(DISTINCT pr.store_id) as store_count
        FROM products p
            JOIN prices pr ON p.id = pr.product_id
        WHERE 
            p.vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%supermarket%')
            AND pr.store_id IS NOT NULL
        GROUP BY p.id, p.name
        HAVING COUNT(DISTINCT pr.store_id) > 1
        ORDER BY store_count DESC
        LIMIT 10
    """)
    
    multi_store_products = cur.fetchall()
    
    if multi_store_products:
        print(f"   כן! {len(multi_store_products)} דוגמאות:")
        for name, count in multi_store_products:
            print(f"      {name[:50]}... : {count} סניפים")
    else:
        print("   ❌ אין מוצרים שנמכרים ביותר מסניף אחד")
        print("      זו בעיה! כל מוצר צריך להיות במספר סניפים")
    print()
    
    # 5. Top stores by price count
    print("5. חנויות עם הכי הרבה מחירים:")
    cur.execute("""
        SELECT 
            s.store_name,
            s.store_code,
            COUNT(pr.id) as price_count
        FROM stores s
            LEFT JOIN prices pr ON s.id = pr.store_id
        GROUP BY s.id, s.store_name, s.store_code
        ORDER BY price_count DESC
        LIMIT 10
    """)
    
    top_stores = cur.fetchall()
    
    for i, (name, code, count) in enumerate(top_stores, 1):
        store_name = name or 'ללא שם'
        store_code = code or 'N/A'
        print(f"   {i:2d}. {store_name} ({store_code}): {count:,} מחירים")
    print()
    
    # 6. Statistics
    print("6. סטטיסטיקות כלליות:")
    cur.execute("""
        SELECT 
            COUNT(*) as total_prices,
            COUNT(DISTINCT product_id) as unique_products,
            COUNT(DISTINCT store_id) as unique_stores
        FROM prices
        WHERE store_id IS NOT NULL
    """)
    
    total, unique_products, unique_stores = cur.fetchone()
    print(f"   סה\"כ מחירים: {total:,}")
    print(f"   מוצרים ייחודיים: {unique_products:,}")
    print(f"   סניפים ייחודיים: {unique_stores}")
    print()
    
    cur.close()
    conn.close()
    
    print("=" * 60)
    print("✅ הבדיקה הושלמה")
    print("=" * 60)

if __name__ == "__main__":
    main()





