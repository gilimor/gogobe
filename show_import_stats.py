import psycopg2

conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres',
    password='1234',
    host='localhost',
    port='5432'
)

cur = conn.cursor()

# Get updated statistics
cur.execute("""
    SELECT 
        sc.chain_name,
        sc.chain_code,
        COUNT(DISTINCT s.id) as stores,
        COUNT(DISTINCT p.product_id) as products,
        COUNT(p.id) as prices,
        MAX(p.scraped_at) as last_update
    FROM store_chains sc
    LEFT JOIN stores s ON s.chain_id = sc.id
    LEFT JOIN prices p ON p.store_id = s.id
    GROUP BY sc.id, sc.chain_name, sc.chain_code
    HAVING COUNT(p.id) > 0
    ORDER BY prices DESC
""")

results = cur.fetchall()

print("\n" + "="*100)
print("סטטוס רשתות עם מחירים")
print("="*100)
print(f"{'רשת':<25} {'קוד':<20} {'סניפים':<10} {'מוצרים':<12} {'מחירים':<12} {'עדכון אחרון'}")
print("-"*100)

total_chains = 0
total_stores = 0
total_products = 0
total_prices = 0

for row in results:
    chain_name = row[0] or "לא ידוע"
    chain_code = row[1] or "N/A"
    stores = row[2] or 0
    products = row[3] or 0
    prices = row[4] or 0
    last_update = str(row[5])[:19] if row[5] else "אין נתונים"
    
    print(f"{chain_name:<25} {chain_code:<20} {stores:<10} {products:<12} {prices:<12} {last_update}")
    
    total_chains += 1
    total_stores += stores
    total_products += products
    total_prices += prices

print("-"*100)
print(f"{'סה״כ':<25} {'':<20} {total_stores:<10} {total_products:<12} {total_prices:<12}")
print(f"\nסה״כ רשתות: {total_chains}")
print("="*100)

conn.close()
