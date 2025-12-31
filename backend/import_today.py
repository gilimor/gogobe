#!/usr/bin/env python3
"""
Import TODAY's files only - Fresh data!
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
from datetime import datetime
import psycopg2

print("=" * 80)
print("🆕 IMPORTING TODAY'S FILES ONLY")
print("=" * 80)
print()

# Get current DB stats
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

# Initialize scraper
scraper = ShufersalScraper()

# Get today's date string (format: 20251224)
today = datetime.now().strftime("%Y%m%d")
print(f"📅 Looking for files from: {today}")
print()

# Import using built-in limit=None which gets all files
start_time = datetime.now()
print(f"🚀 Starting import...")
print()

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

conn.close()

# Print results
print()
print("=" * 80)
print("✅ IMPORT COMPLETE!")
print("=" * 80)
print()
print(f"⏱️  Duration: {duration:.1f}s ({duration/60:.1f} minutes)")
print()
print(f"📊 BEFORE → AFTER:")
print(f"   Products: {before_products:,} → {after_products:,} (+{after_products-before_products:,})")
print(f"   Prices:   {before_prices:,} → {after_prices:,} (+{after_prices-before_prices:,})")
print()
print(f"📈 SESSION STATS:")
print(f"   Files: {stats['files']}")
print(f"   Products: {stats['products']}")
print(f"   Prices: {stats['prices']}")
print(f"   Errors: {stats['errors']}")
print()

if duration > 0 and stats['prices'] > 0:
    print(f"⚡ PERFORMANCE:")
    print(f"   {stats['prices']/duration:.0f} prices/second")
    print(f"   {stats['files']/duration*60:.1f} files/minute")

print()
print("=" * 80)
