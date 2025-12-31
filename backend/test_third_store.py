#!/usr/bin/env python3
"""
Import 1 more Shufersal store - skip first 2
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
import psycopg2

print("=" * 70)
print("IMPORTING 3RD SHUFERSAL STORE")
print("=" * 70)
print()

# Connect
conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres',
    password='9152245-Gl!',
    host='gogobe-db-1'
)
cur = conn.cursor()

# Before
cur.execute("SELECT COUNT(*) FROM products")
before_products = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM prices")
before_prices = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM stores WHERE chain_id = 2")
before_stores = cur.fetchone()[0]

print(f"BEFORE:")
print(f"  Products: {before_products:,}")
print(f"  Prices: {before_prices:,}")
print(f"  Stores: {before_stores}")
print()

# Import 3 files (1st and 2nd will update timestamps, 3rd is new)
scraper = ShufersalScraper()
print("Importing 3 files (first 2 already imported, 3rd is new)...")
print()
stats = scraper.import_files(limit=3)

# After
cur.execute("SELECT COUNT(*) FROM products")
after_products = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM prices")
after_prices = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM stores WHERE chain_id = 2")
after_stores = cur.fetchone()[0]

# Latest store
cur.execute("""
    SELECT id, name, store_id, address, city
    FROM stores 
    WHERE chain_id = 2 
    ORDER BY id DESC 
    LIMIT 1
""")
latest_store = cur.fetchone()

print("\n" + "=" * 70)
print("RESULTS:")
print("=" * 70)
print(f"Products: {before_products:,} → {after_products:,} (+{after_products - before_products:,})")
print(f"Prices: {before_prices:,} → {after_prices:,} (+{after_prices - before_prices:,})")
print(f"Stores: {before_stores} → {after_stores} (+{after_stores - before_stores})")
print()

if latest_store:
    store_id, name, code, address, city = latest_store
    print(f"Latest Store: #{store_id}")
    print(f"  Name: {name}")
    print(f"  Code: {code}")
    if address:
        print(f"  Address: {address}")
    if city:
        print(f"  City: {city}")

print("=" * 70)

conn.close()
