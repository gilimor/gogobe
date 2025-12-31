#!/usr/bin/env python3
"""
SANDBOX MODE - Super Fast Testing
Uses pre-downloaded files, limits to first N products
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
import psycopg2
from datetime import datetime
import os
import glob

print("=" * 70)
print("⚡ SANDBOX MODE - SUPER FAST")
print("=" * 70)
print()

# Configuration
LIMIT_PRODUCTS = 100  # Import only first 100 products per file!
LIMIT_FILES = 1       # Import only 1 file!

print(f"Config: {LIMIT_FILES} file(s), {LIMIT_PRODUCTS} products/file max")
print()

# Find existing files
search_patterns = [
    '/app/data/*/downloads/PriceFull*.xml',
    '/app/data/*/downloads/PriceFull*.gz',
]

files_found = []
for pattern in search_patterns:
    files_found.extend(glob.glob(pattern))

if not files_found:
    print("❌ No files found!")
    print("   Searched:", search_patterns)
    sys.exit(1)

print(f"✓ Found {len(files_found)} files")
files_to_use = files_found[:LIMIT_FILES]
print(f"✓ Will use {len(files_to_use)} file(s)")
print()

# Connect to DB
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
start_mark = start_time

# Parse and import with LIMIT
scraper = ShufersalScraper()

total_imported = 0
for i, filepath in enumerate(files_to_use, 1):
    filename = os.path.basename(filepath)
    print(f"[{i}/{len(files_to_use)}] {filename}")
    
    # Parse file
    all_products = scraper.parse_file(filepath)
    print(f"   Parsed {len(all_products)} products")
    
    # LIMIT to first N products
    limited_products = all_products[:LIMIT_PRODUCTS]
    print(f"   Using first {len(limited_products)} products (SANDBOX limit)")
    
    # Import these products only
    for product in limited_products:
        scraper.import_product(product)
        total_imported += 1
    
    # Flush any remaining prices
    scraper._flush_price_batch()
    
    print(f"   ✓ Imported {len(limited_products)} products")
    print()

duration = (datetime.now() - start_time).total_seconds()

# AFTER
cur.execute("SELECT COUNT(*) FROM products")
after_products = cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM prices")
after_prices = cur.fetchone()[0]

# Mark as sandbox
try:
    cur.execute("UPDATE products SET is_sandbox = TRUE WHERE created_at > %s", (start_mark,))
    products_marked = cur.rowcount
    cur.execute("UPDATE prices SET is_sandbox = TRUE WHERE scraped_at > %s", (start_mark,))
    prices_marked = cur.rowcount
    cur.execute("UPDATE stores SET is_sandbox = TRUE WHERE created_at > %s", (start_mark,))
    stores_marked = cur.rowcount
    conn.commit()
    sandbox_ok = True
except Exception as e:
    print(f"⚠️  Sandbox marking failed: {e}")
    sandbox_ok = False
    products_marked = prices_marked = stores_marked = 0

conn.close()

print("=" * 70)
print("✅ SANDBOX COMPLETE!")
print("=" * 70)
print(f"Duration: {duration:.1f}s")
print()
print(f"Products: {before_products:,} → {after_products:,} (+{after_products-before_products:,})")
print(f"Prices: {before_prices:,} → {after_prices:,} (+{after_prices-before_prices:,})")
print()
if duration > 0:
    print(f"Performance: {total_imported/duration:.0f} products/sec")
print()
if sandbox_ok:
    print(f"🏷️  Marked as SANDBOX:")
    print(f"   Products: {products_marked:,}")
    print(f"   Prices: {prices_marked:,}")
    print(f"   Stores: {stores_marked}")
    print()
    print("To cleanup:")
    print('   docker exec gogobe-db-1 psql -U postgres -d gogobe -c "DELETE FROM prices WHERE is_sandbox=TRUE; DELETE FROM products WHERE is_sandbox=TRUE;"')
print("=" * 70)
