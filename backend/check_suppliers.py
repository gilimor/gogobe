#!/usr/bin/env python3
import sys
sys.path.insert(0, '/app/backend')
import psycopg2
import os

conn = psycopg2.connect(
    dbname=os.getenv('DB_NAME', 'gogobe'),
    user=os.getenv('DB_USER', 'postgres'),
    password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
    host=os.getenv('DB_HOST', 'localhost'),
    port=os.getenv('DB_PORT', '5432')
)

cur = conn.cursor()

print("🔍 מקור המחירים:")
print("=" * 60)

# Check by supplier_name in stores
cur.execute("""
    SELECT s.supplier_name, COUNT(DISTINCT s.id) as stores, COUNT(p.id) as prices
    FROM stores s
    LEFT JOIN prices p ON p.store_id = s.id
    WHERE p.id IS NOT NULL
    GROUP BY s.supplier_name
    ORDER BY prices DESC
""")

results = cur.fetchall()

total_prices = sum(r[2] for r in results)
print(f"\nסה\"כ מחירים: {total_prices:,}\n")

for supplier, stores, prices in results:
    pct = (prices / total_prices * 100) if total_prices > 0 else 0
    print(f"  {supplier or 'Unknown'}: {stores} חנויות, {prices:,} מחירים ({pct:.1f}%)")

print()
print("=" * 60)

# SuperPharm specifically
cur.execute("""
    SELECT COUNT(*) FROM stores 
    WHERE supplier_name ILIKE '%superpharm%' OR supplier_name ILIKE '%super-pharm%'
""")
superpharm_stores = cur.fetchone()[0]

if superpharm_stores > 0:
    cur.execute("""
        SELECT COUNT(p.id) FROM prices p
        JOIN stores s ON p.store_id = s.id
        WHERE s.supplier_name ILIKE '%superpharm%' OR s.supplier_name ILIKE '%super-pharm%'
    """)
    superpharm_prices = cur.fetchone()[0]
    print(f"\n🏥 SuperPharm: {superpharm_stores} חנויות, {superpharm_prices:,} מחירים")
else:
    print("\n❌ אין חנויות SuperPharm במערכת")

cur.close()
conn.close()
