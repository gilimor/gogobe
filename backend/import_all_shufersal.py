#!/usr/bin/env python3
"""
Import ALL Shufersal stores
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
import psycopg2
from datetime import datetime

print("=" * 70)
print("IMPORTING ALL SHUFERSAL STORES")
print("=" * 70)
print()

start_time = datetime.now()

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

# Import ALL files (no limit)
scraper = ShufersalScraper()

# First check how many files available
files = scraper.fetch_file_list(file_type='prices_full', limit=None)
print(f"Found {len(files)} files to import")
print()

print("Starting full import...")
print("This may take several minutes...")
print()

stats = scraper.import_files(limit=None)  # Import ALL

# After
cur.execute("SELECT COUNT(*) FROM products")
after_products = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM prices")
after_prices = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM stores WHERE chain_id = 2")
after_stores = cur.fetchone()[0]

# Top 5 stores
cur.execute("""
    SELECT s.id, s.name, s.city, COUNT(p.id) as price_count
    FROM stores s
    LEFT JOIN prices p ON s.id = p.store_id
    WHERE s.chain_id = 2
    GROUP BY s.id, s.name, s.city
    ORDER BY price_count DESC
    LIMIT 5
""")
top_stores = cur.fetchall()

conn.close()

end_time = datetime.now()
duration = (end_time - start_time).total_seconds()

print("\n" + "=" * 70)
print("FULL IMPORT COMPLETE!")
print("=" * 70)
print(f"Duration: {duration:.1f} seconds ({duration/60:.1f} minutes)")
print()
print(f"Products: {before_products:,} → {after_products:,} (+{after_products - before_products:,})")
print(f"Prices: {before_prices:,} → {after_prices:,} (+{after_prices - before_prices:,})")
print(f"Stores: {before_stores} → {after_stores} (+{after_stores - before_stores})")
print()
print("Import Stats:")
print(f"  Files processed: {stats.get('files', 0)}")
print(f"  Products created: {stats.get('products', 0)}")
print(f"  Prices imported: {stats.get('prices', 0)}")
print(f"  Items skipped: {stats.get('skipped', 0)}")
print(f"  Errors: {stats.get('errors', 0)}")
print()
print("Top 5 Stores by product count:")
for store_id, name, city, price_count in top_stores:
    city_str = f" ({city})" if city else ""
    print(f"  #{store_id}: {name}{city_str} - {price_count:,} prices")
print()

# Performance
if duration > 0:
    products_per_sec = after_products / duration
    prices_per_sec = (after_prices - before_prices) / duration
    print(f"Performance:")
    print(f"  {prices_per_sec:.0f} prices/second")
    print(f"  {stats.get('files', 0) / duration * 60:.1f} files/minute")

print("=" * 70)
