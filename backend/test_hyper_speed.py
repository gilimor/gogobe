#!/usr/bin/env python3
"""
HYPER SPEED TEST - Using COPY method
Process existing Shufersal files with new COPY optimization
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
import psycopg2
from datetime import datetime
import glob

print("=" * 70)
print("⚡ HYPER SPEED TEST - COPY METHOD")
print("=" * 70)
print()

# Find existing Shufersal files
pattern = '/app/data/shufersal/PriceFull*23*.gz'  # Latest files (Dec 23)
files = sorted(glob.glob(pattern))

if not files:
    print("No Shufersal files found!")
    print(f"Searched: {pattern}")
    sys.exit(1)

# Limit to first 10 files
files = files[:10]

print(f"Found {len(files)} files to import")
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

print(f"BEFORE: {before_products:,} products, {before_prices:,} prices")
print()

start_time = datetime.now()

#Execute import with NEW COPY method
scraper = ShufersalScraper()
stats = scraper.import_files(limit=10)

duration = (datetime.now() - start_time).total_seconds()

# AFTER
cur.execute("SELECT COUNT(*) FROM products")
after_products = cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM prices")
after_prices = cur.fetchone()[0]

conn.close()

print("\n" + "=" * 70)
print("⚡ HYPER SPEED RESULTS!")
print("=" * 70)
print(f"Duration: {duration:.1f}s")
print()
print(f"Products: {before_products:,} → {after_products:,} (+{after_products-before_products:,})")
print(f"Prices: {before_prices:,} → {after_prices:,} (+{after_prices-before_prices:,})")
print()
print(f"Files: {stats.get('files', 0)}")
print(f"Products created: {stats.get('products', 0)}")
print(f"Prices imported: {stats.get('prices', 0)}")
print()

if duration > 0 and stats.get('prices', 0) > 0:
    speed = stats['prices'] / duration
    print(f"⚡⚡⚡ SPEED: {speed:.0f} prices/second ⚡⚡⚡")
    print()
    
    # Compare to old method
    old_speed = 705
    improvement = speed / old_speed
    print(f"Improvement over baseline: {improvement:.1f}x faster!")
    print(f"  Baseline: {old_speed} prices/sec")
    print(f"  With COPY: {speed:.0f} prices/sec")

print("=" * 70)
