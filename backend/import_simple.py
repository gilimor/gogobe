#!/usr/bin/env python3
"""
ROBUST IMPORT - Uses existing import_files method with chunking
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
from datetime import datetime
import psycopg2

print("=" * 80)
print("🚀 SHUFERSAL IMPORT")
print("=" * 80)
print()

# Get initial stats
conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres',
    password='9152245-Gl!',
    host='gogobe-db-1'
)
cur = conn.cursor()

cur.execute("SELECT COUNT(*) FROM products")
before_products = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM prices")
before_prices = cur.fetchone()[0]

conn.close()

print(f"📊 BEFORE:")
print(f"   Products: {before_products:,}")
print(f"   Prices:   {before_prices:,}")
print()

# Run import
start_time = datetime.now()
print(f"🚀 Starting import...")
print()

scraper = ShufersalScraper()
stats = scraper.import_files(limit=None)  # Built-in method handles everything

duration = (datetime.now() - start_time).total_seconds()

# Final stats
conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres',
    password='9152245-Gl!',
    host='gogobe-db-1'
)
cur = conn.cursor()

cur.execute("SELECT COUNT(*) FROM products")
after_products = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM prices")
after_prices = cur.fetchone()[0]

conn.close()

# Results
print()
print("=" * 80)
print("✅ IMPORT COMPLETE")
print("=" * 80)
print()
print(f"⏱️  Duration: {duration/60:.1f} minutes")
print()
print(f"📊 RESULTS:")
print(f"   Products: {before_products:,} → {after_products:,} (+{after_products-before_products:,})")
print(f"   Prices:   {before_prices:,} → {after_prices:,} (+{after_prices-before_prices:,})")
print()
print(f"📈 STATS:")
print(f"   Files: {stats['files']}")
print(f"   Errors: {stats['errors']}")
print()

if duration > 0:
    prices_added = after_prices - before_prices
    print(f"⚡ PERFORMANCE:")
    print(f"   {prices_added/duration:.0f} prices/second")

print()
print("=" * 80)
