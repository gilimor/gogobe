#!/usr/bin/env python3
"""
Clean import of 3 Shufersal stores - after fix
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
import psycopg2

print("=" * 70)
print("CLEAN IMPORT - 3 SHUFERSAL STORES (AFTER FIX)")
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

cur.execute("SELECT COUNT(DISTINCT product_id) FROM prices WHERE store_id IN (470, 471, 472)")
before_products_in_stores = cur.fetchone()[0]

print(f"BEFORE:")
print(f"  Total Products: {before_products:,}")
print(f"  Total Prices: {before_prices:,}")
print(f"  Products in these 3 stores: {before_products_in_stores:,}")
print()

# Import
scraper = ShufersalScraper()
print("Importing 3 stores...")
print("Looking for: 0 errors, 0 warnings")
print()
stats = scraper.import_files(limit=3)

# After
cur.execute("SELECT COUNT(*) FROM products")
after_products = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM prices")
after_prices = cur.fetchone()[0]

cur.execute("SELECT COUNT(DISTINCT product_id) FROM prices WHERE store_id IN (470, 471, 472)")
after_products_in_stores = cur.fetchone()[0]

# Get stores
cur.execute("""
    SELECT s.id, s.name, COUNT(p.id) as price_count, COUNT(DISTINCT p.product_id) as product_count
    FROM stores s
    LEFT JOIN prices p ON s.id = p.store_id
    WHERE s.id IN (470, 471, 472)
    GROUP BY s.id, s.name
    ORDER BY s.id
""")
stores = cur.fetchall()

conn.close()

print("\n" + "=" * 70)
print("RESULTS:")
print("=" * 70)
print(f"Products: {before_products:,} → {after_products:,} (+{after_products - before_products:,})")
print(f"Prices: {before_prices:,} → {after_prices:,} (+{after_prices - before_prices:,})")
print(f"Products in stores: {before_products_in_stores:,} → {after_products_in_stores:,}")
print()
print("Stores:")
for store_id, name, price_count, product_count in stores:
    print(f"  #{store_id}: {name}")
    print(f"         {product_count:,} products, {price_count:,} prices")
print()
print("Import Stats:")
print(f"  Files: {stats.get('files', 0)}")
print(f"  Products created: {stats.get('products', 0)}")
print(f"  Prices imported: {stats.get('prices', 0)}")
print(f"  Items skipped: {stats.get('skipped', 0)}")
print(f"  Errors: {stats.get('errors', 0)}")
print()

if stats.get('errors', 0) == 0 and stats.get('skipped', 0) == 0:
    print("✅ SUCCESS - ZERO ERRORS!")
else:
    print("⚠️  Check warnings above")

print("=" * 70)
