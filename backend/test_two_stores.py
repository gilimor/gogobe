#!/usr/bin/env python3
"""
Import 2 Shufersal stores
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper

print("=" * 70)
print("IMPORTING 2 SHUFERSAL STORES")
print("=" * 70)
print()

scraper = ShufersalScraper()

# Get current stats
import psycopg2
conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres',
    password='9152245-Gl!',
    host='gogobe-db-1'
)
cur = conn.cursor()

cur.execute("SELECT COUNT(*) FROM prices")
before_prices = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM products")
before_products = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM stores")
before_stores = cur.fetchone()[0]

print(f"BEFORE Import:")
print(f"  Products: {before_products:,}")
print(f"  Prices: {before_prices:,}")
print(f"  Stores: {before_stores}")
print()

# Import
print("Running import (2 files = 2 stores)...")
print()
stats = scraper.import_files(limit=2)

# After stats
cur.execute("SELECT COUNT(*) FROM prices")
after_prices = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM products")
after_products = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM stores")
after_stores = cur.fetchone()[0]

# Latest stores
cur.execute("""
    SELECT id, name, store_id, address 
    FROM stores 
    WHERE chain_id = 2 
    ORDER BY id DESC 
    LIMIT 2
""")
latest_stores = cur.fetchall()

conn.close()

print("\n" + "=" * 70)
print("RESULTS:")
print("=" * 70)
print(f"BEFORE → AFTER:")
print(f"  Products: {before_products:,} → {after_products:,} (+{after_products - before_products:,})")
print(f"  Prices: {before_prices:,} → {after_prices:,} (+{after_prices - before_prices:,})")
print(f"  Stores: {before_stores} → {after_stores} (+{after_stores - before_stores})")
print()
print("Latest Stores:")
for store_id, name, code, address in latest_stores:
    print(f"  #{store_id}: {name} (Code: {code})")
    if address:
        print(f"         {address}")
print("=" * 70)
