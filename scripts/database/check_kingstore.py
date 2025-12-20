import psycopg2
from psycopg2.extras import RealDictCursor

# Database configuration
DB_CONFIG = {
    'dbname': 'gogobe',
    'user': 'postgres',
    'password': '9152245-Gl!',
    'host': 'host.docker.internal',
    'port': '5432'
}

print("=" * 80)
print("בדיקת נתוני KingStore")
print("=" * 80)

conn = psycopg2.connect(**DB_CONFIG)
cur = conn.cursor(cursor_factory=RealDictCursor)

# 1. כמה חנויות KingStore?
print("\n1. כמה חנויות KingStore בDB?")
cur.execute("""
    SELECT COUNT(*) as total
    FROM stores
""")
result = cur.fetchone()
print(f"   סה\"כ חנויות: {result['total']}")

# 2. רשימת החנויות
print("\n2. רשימת חנויות KingStore:")
cur.execute("""
    SELECT s.store_code, s.store_name, s.city, COUNT(p.id) as price_count
    FROM stores s
    LEFT JOIN prices p ON p.store_id = s.id
    GROUP BY s.id, s.store_code, s.store_name, s.city
    ORDER BY s.store_code
""")
stores = cur.fetchall()
for store in stores:
    print(f"   {store['store_code']:>3} | {store['store_name']:<30} | {store['city'] or 'N/A':<15} | {store['price_count']:>5} מחירים")

# 3. האם יש מוצרים שמופיעים ביותר מסניף אחד?
print("\n3. מוצרים שמופיעים ביותר מסניף אחד:")
cur.execute("""
    SELECT 
        pr.name,
        COUNT(DISTINCT p.store_id) as store_count,
        string_agg(DISTINCT s.store_code, ', ' ORDER BY s.store_code) as store_codes,
        MIN(p.price) as min_price,
        MAX(p.price) as max_price
    FROM products pr
    JOIN prices p ON p.product_id = pr.id
    JOIN stores s ON s.id = p.store_id
    WHERE p.supplier_id IN (SELECT id FROM suppliers WHERE name = 'KingStore')
    GROUP BY pr.id, pr.name
    HAVING COUNT(DISTINCT p.store_id) > 1
    ORDER BY store_count DESC
    LIMIT 10
""")
multi_store_products = cur.fetchall()
if multi_store_products:
    for prod in multi_store_products:
        print(f"   {prod['name'][:50]:<50} | {prod['store_count']} חנויות | קודים: {prod['store_codes']}")
else:
    print("   ❌ אין מוצרים שמופיעים ביותר מסניף אחד!")

# 4. כמה מוצרים יש לכל סניף?
print("\n4. כמה מוצרים יש לכל סניף (Top 10):")
cur.execute("""
    SELECT 
        s.store_code,
        s.store_name,
        COUNT(DISTINCT p.product_id) as product_count
    FROM stores s
    LEFT JOIN prices p ON p.store_id = s.id
    GROUP BY s.id, s.store_code, s.store_name
    ORDER BY product_count DESC
    LIMIT 10
""")
store_products = cur.fetchall()
for sp in store_products:
    print(f"   {sp['store_code']:>3} | {sp['store_name']:<30} | {sp['product_count']:>5} מוצרים")

cur.close()
conn.close()

print("\n" + "=" * 80)
print("סיום בדיקה")
print("=" * 80)

