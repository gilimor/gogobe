#!/usr/bin/env python3
"""
SMART PRODUCTION IMPORT
Process existing downloaded files immediately, don't wait for full list
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
import psycopg2
from datetime import datetime
import glob
import os

print("=" * 70)
print("⚡ SMART PRODUCTION IMPORT - Process Existing Files")
print("=" * 70)
print()

# Find ALL existing downloaded files
data_patterns = [
    '/app/data/*/downloads/PriceFull7290027600007-*',  # Shufersal pattern
]

all_files = []
for pattern in data_patterns:
    found = glob.glob(pattern)
    all_files.extend(found)

# Filter only .gz or .xml files
all_files = [f for f in all_files if f.endswith('.gz') or f.endswith('.xml')]
all_files = sorted(set(all_files))  # Remove duplicates

print(f"📦 Found {len(all_files)} existing files locally")

if not all_files:
    print("⚠️  No files found locally!")
    print("   Will download from website...")
    print()
    # Fallback to normal import
    scraper = ShufersalScraper()
    
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
    print(f"BEFORE: {before_products:,} products, {before_prices:,} prices")
    print()
    
    start = datetime.now()
    stats = scraper.import_files(limit=10)  # Just 10 files for now
    duration = (datetime.now() - start).total_seconds()
    
    cur.execute("SELECT COUNT(*) FROM products")
    after_products = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM prices")
    after_prices = cur.fetchone()[0]
    conn.close()
    
    print(f"\n✅ Imported {stats.get('files', 0)} files in {duration:.1f}s")
    print(f"Products: {before_products:,} → {after_products:,}")
    print(f"Prices: {before_prices:,} → {after_prices:,}")
    sys.exit(0)

print(f"✓ Will process these files WITHOUT downloading")
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

print(f"🚀 Processing {len(all_files)} files...")
print()

start_time = datetime.now()

# Initialize scraper
scraper = ShufersalScraper()

# Process files directly (skip download phase)
total_products_imported = 0
total_files = 0
errors = 0

for i, filepath in enumerate(all_files, 1):
    filename = os.path.basename(filepath)
    print(f"[{i}/{len(all_files)}] {filename}", end=" ... ")
    
    try:
        # Parse file
        products = scraper.parse_file(filepath)
        
        # Import each product
        for product in products:
            scraper.import_product(product)
        
        # Flush batch
        scraper._flush_price_batch()
        
        total_products_imported += len(products)
        total_files += 1
        print(f"✓ {len(products)} products")
        
    except Exception as e:
        print(f"✗ Error: {e}")
        errors += 1
    
    # Progress update every 50 files
    if i % 50 == 0:
        elapsed = (datetime.now() - start_time).total_seconds()
        rate = i / elapsed if elapsed > 0 else 0
        remaining = len(all_files) - i
        eta = remaining / rate if rate > 0 else 0
        print(f"   Progress: {i}/{len(all_files)} ({i/len(all_files)*100:.1f}%) - ETA: {eta/60:.1f} min")

duration = (datetime.now() - start_time).total_seconds()

# AFTER
cur.execute("SELECT COUNT(*) FROM products")
after_products = cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM prices")
after_prices = cur.fetchone()[0]

conn.close()

print("\n" + "=" * 70)
print("✅ SMART IMPORT COMPLETE!")
print("=" * 70)
print(f"Duration: {duration:.1f}s ({duration/60:.1f} min)")
print()
print(f"Products: {before_products:,} → {after_products:,} (+{after_products-before_products:,})")
print(f"Prices: {before_prices:,} → {after_prices:,} (+{after_prices-before_prices:,})")
print()
print(f"Files processed: {total_files}/{len(all_files)}")
print(f"Products imported: {total_products_imported:,}")
print(f"Errors: {errors}")
print()

if duration > 0:
    print(f"⚡ Performance:")
    print(f"  {total_products_imported/duration:.0f} products/second")
    print(f"  {total_files/duration*60:.1f} files/minute")

print("=" * 70)
