#!/usr/bin/env python3
"""
PIPELINE IMPORT ARCHITECTURE
Multiple specialized workers in parallel pipeline

Pipeline Stages:
1. DOWNLOADER → downloads files
2. PARSER → extracts products from files  
3. PROCESSOR → imports to database
4. MATCHER → links to master products (future)
5. CLEANER → removes duplicates (future)

Each stage runs independently with queues between them
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
from datetime import datetime
from queue import Queue
import threading
import psycopg2
import time

# CONFIGURATION
NUM_DOWNLOADERS = 2   # Parallel downloads
NUM_PARSERS = 4       # Parallel XML parsing
NUM_PROCESSORS = 4    # Parallel DB writes

# Queues for pipeline
download_queue = Queue(maxsize=50)   # Files to download
parse_queue = Queue(maxsize=100)     # Files to parse
process_queue = Queue(maxsize=200)   # Products to import

# Stats
stats_lock = threading.Lock()
stats = {
    'downloaded': 0,
    'parsed': 0,
    'processed': 0,
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

def producer_fetch_files(scraper):
    """
    STAGE 0: Fetch file list and add to download queue
    """
    print("[PRODUCER] Fetching file list...")
    
    try:
        files = scraper.fetch_file_list(limit=None)
        print(f"[PRODUCER] Found {len(files)} files")
        
        for file_metadata in files:
            download_queue.put(file_metadata)
        
        # Signal end
        for _ in range(NUM_DOWNLOADERS):
            download_queue.put(None)
        
        print(f"[PRODUCER] Done - queued {len(files)} files")
    except Exception as e:
        print(f"[PRODUCER] Error: {e}")

def worker_downloader(worker_id):
    """
    STAGE 1: Download files
    Input: file_metadata from download_queue
    Output: filepath to parse_queue
    """
    scraper = ShufersalScraper()
    
    while True:
        file_metadata = download_queue.get()
        
        if file_metadata is None:
            # End signal - pass it on
            parse_queue.put(None)
            download_queue.task_done()
            break
        
        try:
            # Check if already exists
            filepath = scraper.download_dir + '/' + file_metadata.filename
            import os
            
            if os.path.exists(filepath):
                # Already have it
                parse_queue.put((file_metadata, filepath))
            else:
                # Download
                downloaded = scraper.download_file(file_metadata, scraper.download_dir)
                if downloaded:
                    parse_queue.put((file_metadata, downloaded))
                    with stats_lock:
                        stats['downloaded'] += 1
            
        except Exception as e:
            print(f"[DOWNLOAD-{worker_id}] Error: {e}")
            with stats_lock:
                stats['errors'] += 1
        finally:
            download_queue.task_done()

def worker_parser(worker_id):
    """
    STAGE 2: Parse files
    Input: (file_metadata, filepath) from parse_queue
    Output: (file_metadata, products) to process_queue
    """
    scraper = ShufersalScraper()
    
    while True:
        item = parse_queue.get()
        
        if item is None:
            # End signal
            process_queue.put(None)
            parse_queue.task_done()
            break
        
        file_metadata, filepath = item
        
        try:
            # Parse file
            products = scraper.parse_file(filepath)
            
            if products:
                process_queue.put((file_metadata, products))
                with stats_lock:
                    stats['parsed'] += 1
            
        except Exception as e:
            print(f"[PARSER-{worker_id}] Error parsing {file_metadata.filename}: {e}")
            with stats_lock:
                stats['errors'] += 1
        finally:
            parse_queue.task_done()

def worker_processor(worker_id):
    """
    STAGE 3: Process products (import to DB)
    Input: (file_metadata, products) from process_queue
    Output: Database writes
    """
    scraper = ShufersalScraper()
    
    while True:
        item = process_queue.get()
        
        if item is None:
            # End signal
            # Flush any remaining batch
            scraper._flush_price_batch()
            process_queue.task_done()
            break
        
        file_metadata, products = item
        
        try:
            # Get/create store
            store_id = scraper.get_or_create_store(file_metadata.store_code)
            
            # Import all products
            for product in products:
                scraper.import_product(product, store_id)
            
            # Flush batch periodically
            if len(scraper.price_batch) >= scraper.batch_size:
                scraper._flush_price_batch()
            
            with stats_lock:
                stats['processed'] += len(products)
            
        except Exception as e:
            print(f"[PROCESSOR-{worker_id}] Error: {e}")
            with stats_lock:
                stats['errors'] += 1
        finally:
            process_queue.task_done()

def monitor_progress(total_files, start_time):
    """
    Monitor and display progress
    """
    while True:
        time.sleep(10)
        
        elapsed = (datetime.now() - start_time).total_seconds()
        
        with stats_lock:
            downloaded = stats['downloaded']
            parsed = stats['parsed']
            processed = stats['processed'] 
            errors = stats['errors']
        
        if parsed >= total_files:
            break
        
        rate = processed / elapsed if elapsed > 0 else 0
        
        print(f"\n📊 PROGRESS:")
        print(f"   Downloaded: {downloaded}/{total_files}")
        print(f"   Parsed: {parsed}/{total_files}")
        print(f"   Processed: {processed:,} products")
        print(f"   Errors: {errors}")
        print(f"   Speed: {rate:.0f} products/sec")
        print(f"   Queues: D={download_queue.qsize()} P={parse_queue.qsize()} Pr={process_queue.qsize()}")

print("=" * 80)
print("⚙️  PIPELINE IMPORT ARCHITECTURE")
print("=" * 80)
print(f"Downloaders: {NUM_DOWNLOADERS}")
print(f"Parsers:     {NUM_PARSERS}")
print(f"Processors:  {NUM_PROCESSORS}")
print()

# Get initial stats
initial = get_db_stats()
print(f"📊 BEFORE:")
print(f"   Products: {initial['products']:,}")
print(f"   Prices:   {initial['prices']:,}")
print()

start_time = datetime.now()

# Initialize main scraper
main_scraper = ShufersalScraper()

# Start producer (file list fetcher)
producer = threading.Thread(target=producer_fetch_files, args=(main_scraper,), daemon=True)
producer.start()

# Wait for initial files
time.sleep(5)
total_files = download_queue.qsize()

print(f"🚀 Starting pipeline with {total_files} files...")
print()

# Start all workers
threads = []

# Downloaders
for i in range(NUM_DOWNLOADERS):
    t = threading.Thread(target=worker_downloader, args=(i,), daemon=True)
    t.start()
    threads.append(t)

# Parsers
for i in range(NUM_PARSERS):
    t = threading.Thread(target=worker_parser, args=(i,), daemon=True)
    t.start()
    threads.append(t)

# Processors
for i in range(NUM_PROCESSORS):
    t = threading.Thread(target=worker_processor, args=(i,), daemon=True)
    t.start()
    threads.append(t)

# Monitor progress
monitor = threading.Thread(target=monitor_progress, args=(total_files, start_time), daemon=True)
monitor.start()

# Wait for completion
producer.join()
for t in threads:
    t.join()

duration = (datetime.now() - start_time).total_seconds()
final = get_db_stats()

# Final summary
print()
print("=" * 80)
print("✅ PIPELINE IMPORT COMPLETE!")
print("=" * 80)
print()
print(f"⏱️  Duration: {duration/60:.1f} minutes")
print()
print(f"📊 RESULTS:")
print(f"   Products: {initial['products']:,} → {final['products']:,} (+{final['products']-initial['products']:,})")
print(f"   Prices:   {initial['prices']:,} → {final['prices']:,} (+{final['prices']-initial['prices']:,})")
print()
print(f"📈 STATS:")
print(f"   Downloaded: {stats['downloaded']}")
print(f"   Parsed: {stats['parsed']}")
print(f"   Processed: {stats['processed']:,}")
print(f"   Errors: {stats['errors']}")
print()

if duration > 0:
    prices_added = final['prices'] - initial['prices']
    print(f"⚡⚡⚡ PERFORMANCE:")
    print(f"   {prices_added/duration:.0f} prices/second")
    print(f"   Pipeline: {NUM_DOWNLOADERS}D + {NUM_PARSERS}P + {NUM_PROCESSORS}Pr")

print()
print("=" * 80)
