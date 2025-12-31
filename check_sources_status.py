import psycopg2

conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres', 
    password='1234',
    host='localhost',
    port='5432'
)

cur = conn.cursor()

# Get chain statistics
cur.execute("""
    SELECT 
        sc.chain_name,
        sc.chain_code,
        COUNT(DISTINCT p.id) as price_count,
        MAX(p.scraped_at) as last_update
    FROM store_chains sc
    LEFT JOIN stores s ON s.chain_id = sc.id
    LEFT JOIN prices p ON p.store_id = s.id
    GROUP BY sc.id, sc.chain_name, sc.chain_code
    ORDER BY price_count DESC
""")

results = cur.fetchall()

print("\n=== סטטוס מקורות נתונים ===\n")
print(f"{'רשת':<25} {'קוד':<20} {'מחירים':<15} {'עדכון אחרון'}")
print("-" * 90)

for row in results:
    chain_name = row[0] or "לא ידוע"
    chain_code = row[1] or "N/A"
    price_count = row[2] or 0
    last_update = str(row[3])[:19] if row[3] else "אין נתונים"
    print(f"{chain_name:<25} {chain_code:<20} {price_count:<15} {last_update}")

conn.close()
