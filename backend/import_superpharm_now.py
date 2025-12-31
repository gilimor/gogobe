#!/usr/bin/env python3
"""
SuperPharm Simple Import - Uses existing infrastructure
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.superpharm_scraper import SuperPharmScraper
from datetime import datetime
import psycopg2

print("=" * 80)
print("🚀 SUPER-PHARM IMPORT")
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

cur.execute("SELECT COUNT(*) FROM stores WHERE name LIKE '%סופר%פארם%'")
before_stores = cur.fetchone()[0]

conn.close()

print(f"📊 BEFORE:")
print(f"   Products: {before_products:,}")
print(f"   Prices:   {before_prices:,}")
print(f"   SuperPharm Stores: {before_stores}")
print()

# Run import
start_time = datetime.now()
print(f"🚀 Starting import...")
print()

scraper = SuperPharmScraper()
stats = scraper.import_files(limit=None)

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

cur.execute("SELECT COUNT(*) FROM stores WHERE name LIKE '%סופר%פארם%'")
after_stores = cur.fetchone()[0]

conn.close()

# Results
print()
print("=" * 80)
print("✅ SUPER-PHARM IMPORT COMPLETE")
print("=" * 80)
print()
print(f"⏱️  Duration: {duration/60:.1f} minutes")
print()
print(f"📊 RESULTS:")
print(f"   Products: {before_products:,} → {after_products:,} (+{after_products-before_products:,})")
print(f"   Prices:   {before_prices:,} → {after_prices:,} (+{after_prices-before_prices:,})")
print(f"   Stores:   {before_stores} → {after_stores} (+{after_stores-before_stores})")
print()
print(f"📈 STATS:")
print(f"   Files: {stats['files']}")
print(f"   Errors: {stats['errors']}")
print()

if duration > 0:
    prices_added = after_prices - before_prices
    print(f"⚡ PERFORMANCE:")
    print(f"   {prices_added/duration:.0f} prices/second")
    print(f"   Using COPY method (batch: 10,000)")

print()
print("=" * 80)
