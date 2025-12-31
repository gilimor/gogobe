#!/usr/bin/env python3
"""
PRODUCTION IMPORT - All Shufersal Stores
Full import with Redis cache and all optimizations
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
import psycopg2
from datetime import datetime

print("=" * 70)
print("🏪 PRODUCTION IMPORT - ALL SHUFERSAL")
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

# BEFORE
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

# Check available files
scraper = ShufersalScraper()
files = scraper.fetch_file_list(file_type='prices_full', limit=None)
print(f"📦 Found {len(files)} files available")
print()

# Ask for confirmation
print(f"⚠️  This will import ALL {len(files)} files")
print(f"   Estimated time: ~{len(files) * 0.5:.0f} minutes")
print()

start_time = datetime.now()

print("🚀 Starting FULL PRODUCTION import...")
print()

# Import ALL files (no limit)
stats = scraper.import_files(limit=None)

duration = (datetime.now() - start_time).total_seconds()

# AFTER
cur.execute("SELECT COUNT(*) FROM products")
after_products = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM prices")
after_prices = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM stores WHERE chain_id = 2")
after_stores = cur.fetchone()[0]

# Top stores
cur.execute("""
    SELECT s.id, s.name, s.city, COUNT(p.id) as price_count
    FROM stores s
    LEFT JOIN prices p ON s.id = p.store_id
    WHERE s.chain_id = 2
    GROUP BY s.id, s.name, s.city
    ORDER BY price_count DESC
    LIMIT 10
""")
top_stores = cur.fetchall()

conn.close()

print("\n" + "=" * 70)
print("✅ PRODUCTION IMPORT COMPLETE!")
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

# Performance
if duration > 0:
    prices_per_sec = stats.get('prices', 0) / duration
    files_per_min = stats.get('files', 0) / duration * 60
    print(f"⚡ Performance:")
    print(f"  {prices_per_sec:.0f} prices/second")
    print(f"  {files_per_min:.1f} files/minute")
    print()

print("🏪 Top 10 Stores by product count:")
for store_id, name, city, price_count in top_stores:
    city_str = f" ({city})" if city else ""
    print(f"  #{store_id}: {name}{city_str} - {price_count:,} prices")

print()
print("=" * 70)
print("✅ PRODUCTION DATA READY!")
print("=" * 70)
