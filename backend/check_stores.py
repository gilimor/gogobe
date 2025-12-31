#!/usr/bin/env python3
import sys
sys.path.insert(0, '/app/backend')
import psycopg2
import os

conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres',
    password='9152245-Gl!',
    host='localhost'
)

cur = conn.cursor()

# Show stores table structure
cur.execute("""
    SELECT column_name, data_type 
    FROM information_schema.columns 
    WHERE table_name='stores' 
    ORDER BY ordinal_position
""")
print("📋 Stores table columns:")
for col, dtype in cur.fetchall():
    print(f"  - {col}: {dtype}")

print("\n" + "=" * 60)

# Count prices by store
cur.execute("""
    SELECT s.id, s.name, COUNT(p.id) as price_count
    FROM stores s
    LEFT JOIN prices p ON p.store_id = s.id
    WHERE p.id IS NOT NULL
    GROUP BY s.id, s.name
    ORDER BY price_count DESC
    LIMIT 10
""")

print("\n🏪 Top 10 חנויות עם הכי הרבה מחירים:")
for store_id, name, count in cur.fetchall():
    print(f"  {name}: {count:,} מחירים")

# Total unique stores with prices
cur.execute("""
    SELECT COUNT(DISTINCT p.store_id) FROM prices p
""")
stores_with_prices = cur.fetchone()[0]
print(f"\nסה\"כ חנויות עם מחירים: {stores_with_prices}")

cur.close()
conn.close()
