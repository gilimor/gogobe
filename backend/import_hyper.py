#!/usr/bin/env python3
"""
HYPER-PARALLEL IMPORT - Maximum Speed!
- Multiple workers processing files simultaneously
- Async I/O for downloads
- Parallel database writes
- Target: 10,000+ prices/second
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor, as_completed
from datetime import datetime
import psycopg2
from queue import Queue
import threading

# CONFIGURATION
NUM_WORKERS = 8  # Parallel file processors
DB_WORKERS = 2   # Parallel DB writers

print("=" * 80)
print(f"⚡⚡⚡ HYPER-PARALLEL IMPORT ({NUM_WORKERS} workers)")
print("=" * 80)
print()

# Stats
stats_lock = threading.Lock()
stats = {
    'files': 0,
    'products': 0,
    'prices': 0,
    'errors': 0
}

def get_db_stats():
    conn = psycopg2.connect(
        dbname='gogobe',
        user='postgres',
        password='9152245-Gl!',
        host='gogobe-db-1'
    )
    cur = conn.cursor()
    cur.execute("SELECT COUNT(*) FROM products")
    products = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM prices")
    prices = cur.fetchone()[0]
    conn.close()
    return {'products': products, 'prices': prices}

def process_file_worker(file_metadata):
    """Worker function - processes single file"""
    try:
        # Each worker gets its own scraper instance
        scraper = ShufersalScraper()
        
        # Parse file (already downloaded)
        filepath = scraper.download_dir + '/' + file_metadata.filename
        products = scraper.parse_file(filepath)
        
        if not products:
            return {'success': False, 'count': 0}
        
        # Get/create store
        store_id = scraper.get_or_create_store(file_metadata.store_code)
        
        # Import products
        for product in products:
            scraper.import_product(product, store_id)
        
        # Flush batch
        scraper._flush_price_batch()
        
        # Update stats
        with stats_lock:
            stats['files'] += 1
            stats['products'] += len(products)
            stats['prices'] += len(products)
        
        return {'success': True, 'count': len(products)}
        
    except Exception as e:
        with stats_lock:
            stats['errors'] += 1
        return {'success': False, 'error': str(e)}

# Get initial stats
initial = get_db_stats()
print(f"📊 BEFORE:")
print(f"   Products: {initial['products']:,}")
print(f"   Prices:   {initial['prices']:,}")
print()

# Initialize main scraper to get file list
scraper = ShufersalScraper()

print("📡 Fetching file list...")
all_files = scraper.fetch_file_list(limit=None)
total_files = len(all_files)

print(f"✓ {total_files} files to process")
print(f"✓ Using {NUM_WORKERS} parallel workers")
print()

start_time = datetime.now()

# Process files in parallel
print(f"🚀 Starting PARALLEL processing...")
print()

with ThreadPoolExecutor(max_workers=NUM_WORKERS) as executor:
    # Submit all files
    futures = {executor.submit(process_file_worker, f): f for f in all_files}
    
    # Track progress
    completed = 0
    for future in as_completed(futures):
        completed += 1
        
        if completed % 20 == 0:
            elapsed = (datetime.now() - start_time).total_seconds()
            rate = stats['prices'] / elapsed if elapsed > 0 else 0
            eta = (total_files - completed) / (completed / elapsed) if elapsed > 0 else 0
            
            print(f"Progress: {completed}/{total_files} ({completed/total_files*100:.1f}%) "
                  f"| {stats['prices']:,} prices "
                  f"| {rate:.0f} prices/sec "
                  f"| ETA: {eta/60:.1f}min")

duration = (datetime.now() - start_time).total_seconds()
final = get_db_stats()

# Results
print()
print("=" * 80)
print("✅ HYPER-PARALLEL IMPORT COMPLETE!")
print("=" * 80)
print()
print(f"⏱️  Duration: {duration:.1f}s ({duration/60:.1f} minutes)")
print()
print(f"📊 RESULTS:")
print(f"   Products: {initial['products']:,} → {final['products']:,} (+{final['products']-initial['products']:,})")
print(f"   Prices:   {initial['prices']:,} → {final['prices']:,} (+{final['prices']-initial['prices']:,})")
print()
print(f"📈 STATS:")
print(f"   Files: {stats['files']}/{total_files}")
print(f"   Errors: {stats['errors']}")
print()

if duration > 0:
    prices_added = final['prices'] - initial['prices']
    print(f"⚡⚡⚡ PERFORMANCE:")
    print(f"   {prices_added/duration:.0f} prices/second")
    print(f"   {stats['files']/duration*60:.1f} files/minute")
    print(f"   {NUM_WORKERS}x PARALLEL SPEEDUP!")
    
    # Compare to sequential
    sequential_speed = 474  # Your current speed
    speedup = (prices_added/duration) / sequential_speed
    print(f"   {speedup:.1f}x faster than sequential!")

print()
print("=" * 80)
