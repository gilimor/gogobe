import sys
import codecs

# Force UTF-8 encoding for console output
sys.stdout.reconfigure(encoding='utf-8')

import psycopg2
import os

try:
    conn = psycopg2.connect(
        dbname='gogobe',
        user='postgres',
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host='localhost',
        port='5432'
    )
    
    cur = conn.cursor()
    
    print("\n" + "="*80)
    print("בדיקת בסיס נתונים")
    print("="*80)
    
    # Check products
    cur.execute("SELECT COUNT(*) FROM products")
    products_count = cur.fetchone()[0]
    print(f"מוצרים: {products_count:,}")
    
    # Check prices
    cur.execute("SELECT COUNT(*) FROM prices")
    prices_count = cur.fetchone()[0]
    print(f"מחירים: {prices_count:,}")
    
    # Check categories
    cur.execute("SELECT COUNT(*) FROM categories")
    categories_count = cur.fetchone()[0]
    print(f"קטגוריות: {categories_count:,}")
    
    # Check suppliers
    cur.execute("SELECT COUNT(*) FROM suppliers")
    suppliers_count = cur.fetchone()[0]
    print(f"ספקים: {suppliers_count:,}")
    
    # Check store_chains
    cur.execute("SELECT COUNT(*) FROM store_chains")
    chains_count = cur.fetchone()[0]
    print(f"רשתות: {chains_count:,}")
    
    # Check stores
    cur.execute("SELECT COUNT(*) FROM stores")
    stores_count = cur.fetchone()[0]
    print(f"סניפים: {stores_count:,}")
    
    print("\n" + "="*80)
    print("פירוט מחירים לפי ספק:")
    print("="*80)
    
    cur.execute("""
        SELECT 
            s.name,
            COUNT(p.id) as price_count,
            MAX(p.scraped_at) as last_update
        FROM suppliers s
        LEFT JOIN prices p ON p.supplier_id = s.id
        GROUP BY s.id, s.name
        ORDER BY price_count DESC
    """)
    
    for row in cur.fetchall():
        name = row[0]
        count = row[1]
        last = row[2]
        print(f"{name:<30} {count:>10,} מחירים   {str(last)[:19] if last else 'אין'}")
    
    print("="*80)
    
    conn.close()
    
except Exception as e:
    print(f"שגיאה: {e}")
    import traceback
    traceback.print_exc()
