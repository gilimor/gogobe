#!/usr/bin/env python3
"""
PARALLEL HYPER-SPEED IMPORT
Processes multiple files simultaneously for maximum throughput
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime
import psycopg2
import threading

# Number of parallel workers
NUM_WORKERS = 4

print("=" * 70)
print(f"⚡⚡⚡ PARALLEL HYPER-SPEED IMPORT ({NUM_WORKERS} workers)")
print("=" * 70)
print()

# Stats tracking
stats_lock = threading.Lock()
total_files = 0
total_products = 0
total_prices = 0
errors = 0

def import_file_worker(scraper, file_metadata):
    """Worker function to import a single file"""
    global total_files, total_products, total_prices, errors
    
    try:
        # Download and import file
        filename = scraper.download_file(file_metadata)
        if not filename:
            with stats_lock:
                errors += 1
            return None
        
        # Parse and import
        products = scraper.parse_file(filename)
        if not products:
            return None
        
        #Get store
        store_id = scraper.get_or_create_store(file_metadata.store_code)
        
        # Import all products
        for product in products:
            scraper.import_product(product, store_id)
        
        # Flush remaining batch
        scraper._flush_price_batch()
        
        # Update stats
        with stats_lock:
            total_files += 1
            total_products += len(products)
            total_prices += len(products)
        
        return len(products)
        
    except Exception as e:
        with stats_lock:
            errors += 1
        print(f"Error processing {file_metadata.filename}: {e}")
        return None

# Connect to DB for stats
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

print(f"BEFORE: {before_products:,} products, {before_prices:,} prices")
print()

start_time = datetime.now()

# Initialize scraper (main thread)
print(f"🚀 Starting parallel import with {NUM_WORKERS} workers...")
print()

scraper = ShufersalScraper()

# Get file list
print("Fetching file list...")
files = scraper.fetch_file_list(limit=None)
print(f"Found {len(files)} files")
print()

# Process files in parallel
with ThreadPoolExecutor(max_workers=NUM_WORKERS) as executor:
    # Submit all files
    futures = []
    for file in files:
        # Each worker gets its own scraper instance
        worker_scraper = ShufersalScraper()
        future = executor.submit(import_file_worker, worker_scraper, file)
        futures.append(future)
    
    # Wait for completion and show progress
    completed = 0
    for future in as_completed(futures):
        completed += 1
        if completed % 10 == 0:
            elapsed = (datetime.now() - start_time).total_seconds()
            rate = completed / elapsed if elapsed > 0 else 0
            eta = (len(files) - completed) / rate if rate > 0 else 0
            print(f"Progress: {completed}/{len(files)} ({completed/len(files)*100:.1f}%) "
                  f"- {rate:.1f} files/sec - ETA: {eta/60:.1f} min")

duration = (datetime.now() - start_time).total_seconds()

# AFTER stats
cur.execute("SELECT COUNT(*) FROM products")
after_products = cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM prices")
after_prices = cur.fetchone()[0]

conn.close()

# Print results
print("\n" + "=" * 70)
print("✅ PARALLEL IMPORT COMPLETE!")
print("=" * 70)
print(f"Duration: {duration:.1f}s ({duration/60:.1f} minutes)")
print()
print(f"Products: {before_products:,} → {after_products:,} (+{after_products - before_products:,})")
print(f"Prices: {before_prices:,} → {after_prices:,} (+{after_prices - before_prices:,})")
print()
print("Import Stats:")
print(f"  Files processed: {total_files}/{len(files)}")
print(f"  Products imported: {total_products:,}")
print(f"  Errors: {errors}")
print()

if duration > 0:
    prices_imported = after_prices - before_prices
    print(f"⚡⚡⚡ PERFORMANCE:")
    print(f"  {prices_imported/duration:.0f} prices/second")
    print(f"  {total_files/duration*60:.1f} files/minute")
    print(f"  Speedup: {NUM_WORKERS}x parallel workers")

print()
print("=" * 70)
print(f"🎉 HYPER-SPEED IMPORT COMPLETE! ({NUM_WORKERS}x PARALLEL)")
print("=" * 70)
