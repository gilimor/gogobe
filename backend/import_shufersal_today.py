#!/usr/bin/env python3
"""
PRODUCTION IMPORT - All Shufersal Stores from Today
Import all Dec 23 files with COPY optimization
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
import psycopg2
from datetime import datetime
import glob
import os

print("=" * 70)
print("🏪 PRODUCTION IMPORT - ALL SHUFERSAL STORES")
print("=" * 70)
print()

# Find ALL Shufersalfiles (all dates)

# Find ALL Shufersal files (all dates)
patterns = [
    '/app/data/shufersal/PriceFull*.gz'
]

all_files = []
for pattern in patterns:
    found = glob.glob(pattern)
    all_files.extend(found)

# Filter only .gz files (not xml)
gz_files = [f for f in all_files if f.endswith('.gz')]
gz_files = sorted(set(gz_files))

print(f"📦 Found {len(gz_files)} files from Dec 23, 2025")

if not gz_files:
    print("❌ No files found!")
    print("Searched patterns:")
    for p in patterns:
        print(f"  - {p}")
    sys.exit(1)

print()
print("Files to import:")
for i, f in enumerate(gz_files[:10], 1):
    print(f"  {i}. {os.path.basename(f)}")
if len(gz_files) > 10:
    print(f"  ... and {len(gz_files) - 10} more files")
print()

# Connect to DB
conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres',
    password='9152245-Gl!',
    host='gogobe-db-1'
)
cur = conn.cursor()

# BEFORE stats
cur.execute("SELECT COUNT(*) FROM products")
before_products = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM prices")
before_prices = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM stores WHERE chain_id = 2")
before_stores = cur.fetchone()[0]

print("BEFORE:")
print(f"  Products: {before_products:,}")
print(f"  Prices: {before_prices:,}")
print(f"  Shufersal Stores: {before_stores}")
print()

start_time = datetime.now()

print(f"🚀 Starting production import of {len(gz_files)} files...")
print(f"   Using: COPY method + Redis cache + Batch 5000")
print()

# Initialize scraper
scraper = ShufersalScraper()

# Process each file
total_products = 0
total_prices = 0
total_files = 0
errors = 0

for i, filepath in enumerate(gz_files, 1):
    filename = os.path.basename(filepath)
    
    try:
        # Parse file
        products = scraper.parse_file(filepath)
        
        if not products:
            print(f"[{i}/{len(gz_files)}] {filename} - SKIPPED (no products)")
            continue
        
        # Get/create store for this file
        # Extract store code from filename (e.g., 001, 002, etc.)
        import re
        match = re.search(r'-(\d{3})-', filename)
        store_code = match.group(1) if match else f"{i:03d}"
        
        # Create full store code
        full_store_code = f"7290027600007_{store_code}"
        
        # Find or create store
        store_id = scraper.get_or_create_store(full_store_code, {
            'name': f'שופרסל - סניף {store_code}',
            'chain_id': 2
        })
        
        # Import products
        for product in products:
            scraper.import_product(product, store_id)
        
        # Flush remaining batch
        scraper._flush_price_batch()
        
        total_products += len(products)
        total_files += 1
        
        print(f"[{i}/{len(gz_files)}] {filename} ✓ {len(products)} products")
        
        # Progress update every 50 files
        if i % 50 == 0:
            elapsed = (datetime.now() - start_time).total_seconds()
            rate = i / elapsed if elapsed > 0 else 0
            remaining = len(gz_files) - i
            eta = remaining / rate if rate > 0 else 0
            print(f"   📊 Progress: {i}/{len(gz_files)} ({i/len(gz_files)*100:.1f}%) - ETA: {eta/60:.1f} min")
        
    except Exception as e:
        print(f"[{i}/{len(gz_files)}] {filename} ✗ Error: {e}")
        errors += 1

duration = (datetime.now() - start_time).total_seconds()

# AFTER stats
cur.execute("SELECT COUNT(*) FROM products")
after_products = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM prices")
after_prices = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM stores WHERE chain_id = 2")
after_stores = cur.fetchone()[0]

# Top stores
cur.execute("""
    SELECT s.id, s.name, COUNT(p.id) as price_count
    FROM stores s
    LEFT JOIN prices p ON s.id = p.store_id
    WHERE s.chain_id = 2
    GROUP BY s.id, s.name
    ORDER BY price_count DESC
    LIMIT 15
""")
top_stores = cur.fetchall()

conn.close()

# Print results
print("\n" + "=" * 70)
print("✅ PRODUCTION IMPORT COMPLETE!")
print("=" * 70)
print(f"Duration: {duration:.1f}s ({duration/60:.1f} minutes)")
print()
print(f"Products: {before_products:,} → {after_products:,} (+{after_products - before_products:,})")
print(f"Prices: {before_prices:,} → {after_prices:,} (+{after_prices - before_prices:,})")
print(f"Shufersal Stores: {before_stores} → {after_stores} (+{after_stores - before_stores})")
print()
print("Import Stats:")
print(f"  Files processed: {total_files}/{len(gz_files)}")
print(f"  Products imported: {total_products:,}")
print(f"  Errors: {errors}")
print()

if duration > 0:
    prices_imported = after_prices - before_prices
    print(f"⚡ Performance:")
    print(f"  {prices_imported/duration:.0f} prices/second")
    print(f"  {total_files/duration*60:.1f} files/minute")
    print()

print("🏪 Top 15 Shufersal Stores:")
for store_id, name, price_count in top_stores:
    print(f"  #{store_id}: {name} - {price_count:,} prices")

print()
print("=" * 70)
print("🎉 ALL SHUFERSAL STORES IMPORTED!")
print("=" * 70)
