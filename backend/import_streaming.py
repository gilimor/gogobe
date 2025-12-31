#!/usr/bin/env python3
"""
ULTRA-OPTIMIZED STREAMING PIPELINE IMPORT
- Fetch pages in background (producer)
- Process files immediately as they arrive (consumers)
- Maximum parallelism and throughput
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime
from queue import Queue
import threading
import psycopg2

print("=" * 70)
print("⚡⚡⚡ ULTRA-OPTIMIZED STREAMING PIPELINE")
print("=" * 70)
print()

# Configuration
NUM_DOWNLOAD_WORKERS = 4  # Parallel downloaders
NUM_PROCESS_WORKERS = 4   # Parallel processors

# Shared queues
file_queue = Queue(maxsize=50)  # Files to download
download_queue = Queue(maxsize=20)  # Downloaded files to process

# Stats
stats_lock = threading.Lock()
stats = {
    'files_found': 0,
    'files_downloaded': 0,
    'files_processed': 0,
    'products': 0,
    'prices': 0,
    'errors': 0
}

def producer_fetch_files():
    """
    Producer: Fetch file list and add to queue
    Runs in background, streams results
    """
    try:
        scraper = ShufersalScraper()
        
        print("📡 Producer: Fetching file list (streaming)...")
        
        # Fetch files page by page
        page = 1
        while True:
            try:
                # Fetch single page
                print(f"📡 Fetching page {page}...")
                files = scraper.fetch_file_list_page(page)
                
                if not files:
                    break
                
                # Add files to queue immediately
                for file in files:
                    file_queue.put(file)
                    with stats_lock:
                        stats['files_found'] += 1
                
                print(f"✓ Page {page}: Added {len(files)} files to queue "
                      f"(total: {stats['files_found']})")
                
                page += 1
                
            except Exception as e:
                print(f"Error fetching page {page}: {e}")
                break
        
        # Signal end of files
        for _ in range(NUM_DOWNLOAD_WORKERS):
            file_queue.put(None)
        
        print(f"✅ Producer done: {stats['files_found']} files found")
        
    except Exception as e:
        print(f"Producer error: {e}")

def worker_download():
    """
    Worker: Download files from queue
    """
    scraper = ShufersalScraper()
    
    while True:
        file_metadata = file_queue.get()
        
        if file_metadata is None:
            # End signal
            download_queue.put(None)
            break
        
        try:
            # Download file
            filepath = scraper.download_file(file_metadata)
            
            if filepath:
                download_queue.put((file_metadata, filepath))
                with stats_lock:
                    stats['files_downloaded'] += 1
            else:
                with stats_lock:
                    stats['errors'] += 1
                    
        except Exception as e:
            print(f"Download error {file_metadata.filename}: {e}")
            with stats_lock:
                stats['errors'] += 1
        
        finally:
            file_queue.task_done()

def worker_process():
    """
    Worker: Process downloaded files
    """
    scraper = ShufersalScraper()
    
    while True:
        item = download_queue.get()
        
        if item is None:
            # End signal
            break
        
        file_metadata, filepath = item
        
        try:
            # Parse file
            products = scraper.parse_file(filepath)
            
            if not products:
                continue
            
            # Get store
            store_id = scraper.get_or_create_store(file_metadata.store_code)
            
            # Import all products
            for product in products:
                scraper.import_product(product, store_id)
            
            # Flush batch
            scraper._flush_price_batch()
            
            # Update stats
            with stats_lock:
                stats['files_processed'] += 1
                stats['products'] += len(products)
                stats['prices'] += len(products)
            
            # Progress
            if stats['files_processed'] % 10 == 0:
                print(f"Progress: {stats['files_processed']} files processed, "
                      f"{stats['prices']:,} prices imported")
            
        except Exception as e:
            print(f"Process error {file_metadata.filename}: {e}")
            with stats_lock:
                stats['errors'] += 1
        
        finally:
            download_queue.task_done()

# Get initial DB stats
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

start_time = datetime.now()

print(f"🚀 Starting STREAMING PIPELINE:")
print(f"   Producer: 1 thread (fetch pages)")
print(f"   Downloaders: {NUM_DOWNLOAD_WORKERS} threads")
print(f"   Processors: {NUM_PROCESS_WORKERS} threads (with COPY)")
print()

# Start all workers
producer_thread = threading.Thread(target=producer_fetch_files, daemon=True)
producer_thread.start()

download_threads = []
for i in range(NUM_DOWNLOAD_WORKERS):
    t = threading.Thread(target=worker_download, daemon=True)
    t.start()
    download_threads.append(t)

process_threads = []
for i in range(NUM_PROCESS_WORKERS):
    t = threading.Thread(target=worker_process, daemon=True)
    t.start()
    process_threads.append(t)

# Wait for completion
producer_thread.join()
print("✓ Producer finished")

for t in download_threads:
    t.join()
print("✓ All downloads finished")

for t in process_threads:
    t.join()
print("✓ All processing finished")

duration = (datetime.now() - start_time).total_seconds()

# Final stats
cur.execute("SELECT COUNT(*) FROM products")
after_products = cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM prices")
after_prices = cur.fetchone()[0]

conn.close()

# Print results
print("\n" + "=" * 70)
print("✅ STREAMING PIPELINE COMPLETE!")
print("=" * 70)
print(f"Duration: {duration:.1f}s ({duration/60:.1f} minutes)")
print()
print(f"Products: {before_products:,} → {after_products:,} (+{after_products-before_products:,})")
print(f"Prices: {before_prices:,} → {after_prices:,} (+{after_prices-before_prices:,})")
print()
print("Pipeline Stats:")
print(f"  Files found: {stats['files_found']}")
print(f"  Files downloaded: {stats['files_downloaded']}")
print(f"  Files processed: {stats['files_processed']}")
print(f"  Products imported: {stats['products']:,}")
print(f"  Errors: {stats['errors']}")
print()

if duration > 0:
    prices_imported = after_prices - before_prices
    print(f"⚡⚡⚡ PERFORMANCE:")
    print(f"  {prices_imported/duration:.0f} prices/second")
    print(f"  {stats['files_processed']/duration*60:.1f} files/minute")
    print(f"  Pipeline: Producer + {NUM_DOWNLOAD_WORKERS}D + {NUM_PROCESS_WORKERS}P workers")

print()
print("=" * 70)
print("🎉 STREAMING PIPELINE = MAXIMUM SPEED!")
print("=" * 70)
