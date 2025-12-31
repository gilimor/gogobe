#!/usr/bin/env python3
"""Check what we imported"""
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

print("📊 DATABASE STATUS")
print("=" * 80)
print()

# Products
cur.execute("SELECT COUNT(*) FROM products")
products = cur.fetchone()[0]
print(f"Products: {products:,}")

# Prices
cur.execute("SELECT COUNT(*) FROM prices")
prices = cur.fetchone()[0]
print(f"Prices: {prices:,}")

# By Chain
print("\n🏪 By Chain:")
cur.execute("""
    SELECT sc.name_en, COUNT(DISTINCT s.id) as stores, COUNT(p.id) as prices
    FROM store_chains sc
    LEFT JOIN stores s ON s.chain_id = sc.id
    LEFT JOIN prices p ON p.store_id = s.id
    GROUP BY sc.name_en
    ORDER BY prices DESC
""")
for chain, stores, chain_prices in cur.fetchall():
    if chain_prices > 0:
        print(f"   {chain}: {stores} stores, {chain_prices:,} prices")

print()
print("=" * 80)

cur.close()
conn.close()
