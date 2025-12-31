#!/usr/bin/env python3
"""
ROBUST IMPORT WITH CHUNKING - Fixed version
Uses existing scraper methods correctly
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
from datetime import datetime
import psycopg2
import json
import os
import time

# Configuration
CHUNK_SIZE = 50  # Files per chunk
CHECKPOINT_FILE = '/tmp/shufersal_checkpoint.json'

def load_checkpoint():
    """Load last successful position"""
    if os.path.exists(CHECKPOINT_FILE):
        with open(CHECKPOINT_FILE, 'r') as f:
            return json.load(f)
    return {'position': 0, 'total_prices': 0}

def save_checkpoint(position, total_prices):
    """Save current position"""
    checkpoint = {
        'position': position,
        'total_prices': total_prices,
        'timestamp': datetime.now().isoformat()
    }
    with open(CHECKPOINT_FILE, 'w') as f:
        json.dump(checkpoint, f, indent=2)
    print(f"💾 Checkpoint: position={position}, prices={total_prices:,}")

def get_db_stats():
    """Get DB stats"""
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
    
    cur.execute("SELECT COUNT(*) FROM stores WHERE name LIKE '%שופרסל%'")
    stores = cur.fetchone()[0]
    
    conn.close()
    return {'products': products, 'prices': prices, 'stores': stores}

print("=" * 80)
print("🚀 ROBUST CHUNKED IMPORT - Shufersal")
print("=" * 80)
print()

# Load checkpoint
checkpoint = load_checkpoint()
start_pos = checkpoint['position']

if start_pos > 0:
    print(f"📍 RESUMING from position {start_pos}")
    print(f"   (Previously: {checkpoint['total_prices']:,} prices)")
else:
    print("🆕 NEW IMPORT")

print()

# Get initial stats
initial_stats = get_db_stats()
print(f"📊 DATABASE:")
print(f"   Products: {initial_stats['products']:,}")
print(f"   Prices:   {initial_stats['prices']:,}")
print(f"   Stores:   {initial_stats['stores']}")
print()

# Initialize scraper
scraper = ShufersalScraper()

# Fetch file list
print("📡 Fetching file list...")
all_files = scraper.fetch_file_list(limit=None)
total_files = len(all_files)

print(f"✓ {total_files} files available")
print(f"✓ Need to process: {total_files - start_pos} files")
print(f"✓ Processing in chunks of {CHUNK_SIZE}")
print()

# Process in chunks
overall_start = datetime.now()
position = start_pos
chunk_num = start_pos // CHUNK_SIZE + 1

while position < total_files:
    chunk_start = position
    chunk_end = min(position + CHUNK_SIZE, total_files)
    chunk_files = chunk_end - chunk_start
    
    print("─" * 80)
    print(f"📦 CHUNK #{chunk_num}: Files {chunk_start+1}-{chunk_end} ({chunk_files} files)")
    print("─" * 80)
    
    chunk_start_time = datetime.now()
    
    try:
        # Get files for this chunk
        files_to_process = all_files[chunk_start:chunk_end]
        
        # Process each file
        processed = 0
        errors = 0
        chunk_prices = 0
        
        for idx, file_metadata in enumerate(files_to_process, 1):
            file_num = chunk_start + idx
            
            try:
                print(f"[{file_num}/{total_files}] {file_metadata.filename}... ", end='', flush=True)
                
                # Use scraper's built-in methods
                filepath = scraper.download_dir + '/' + file_metadata.filename
                
                # Check if already exists
                if not os.path.exists(filepath):
                    # Download
                    downloaded = scraper.download_file(file_metadata, scraper.download_dir)
                    if not downloaded:
                        print("❌ Download failed")
                        errors += 1
                        continue
                    filepath = downloaded
                
                # Parse
                products = scraper.parse_file(filepath)
                if not products:
                    print("⚠️ Empty")
                    continue
                
                # Get/create store
                store_id = scraper.get_or_create_store(file_metadata.store_code)
                
                # Import products
                for product in products:
                    scraper.import_product(product, store_id)
                
                # Flush batch
                scraper._flush_price_batch()
                
                processed += 1
                chunk_prices += len(products)
                print(f"✓ {len(products)}")
                
            except Exception as e:
                print(f"❌ {str(e)[:50]}")
                errors += 1
        
        # Chunk summary
        chunk_duration = (datetime.now() - chunk_start_time).total_seconds()
        
        print()
        print(f"✅ Chunk done in {chunk_duration:.1f}s")
        print(f"   Processed: {processed}/{chunk_files}")
        print(f"   Prices: {chunk_prices:,}")
        print(f"   Errors: {errors}")
        if chunk_duration > 0:
            print(f"   Speed: {chunk_prices/chunk_duration:.0f} prices/sec")
        print()
        
        # Update position and save checkpoint
        position = chunk_end
        save_checkpoint(position, initial_stats['prices'] + chunk_prices)
        
        chunk_num += 1
        
        # Brief pause between chunks
        if position < total_files:
            time.sleep(2)
        
    except Exception as e:
        print()
        print(f"❌ CHUNK FAILED: {e}")
        print(f"💾 Saved at position {position}")
        print("   Run again to resume")
        break

# Final summary
overall_duration = (datetime.now() - overall_start).total_seconds()
final_stats = get_db_stats()

print()
print("=" * 80)
print("🎉 IMPORT SESSION COMPLETE")
print("=" * 80)
print()
print(f"⏱️  Duration: {overall_duration/60:.1f} minutes")
print()
print(f"📊 RESULTS:")
print(f"   Products: {initial_stats['products']:,} → {final_stats['products']:,} (+{final_stats['products']-initial_stats['products']:,})")
print(f"   Prices:   {initial_stats['prices']:,} → {final_stats['prices']:,} (+{final_stats['prices']-initial_stats['prices']:,})")
print(f"   Stores:   {initial_stats['stores']} → {final_stats['stores']} (+{final_stats['stores']-initial_stats['stores']})")
print()
print(f"📈 PROGRESS: {position}/{total_files} ({position/total_files*100:.1f}%)")
print()

if overall_duration > 0:
    prices_added = final_stats['prices'] - initial_stats['prices']
    print(f"⚡ PERFORMANCE:")
    print(f"   {prices_added/overall_duration:.0f} prices/second")

if position >= total_files:
    print()
    print("✅ ALL FILES PROCESSED!")
    if os.path.exists(CHECKPOINT_FILE):
        os.remove(CHECKPOINT_FILE)
        print("🗑️  Checkpoint removed")
else:
    print()
    print(f"▶️  Run again to continue from file {position+1}")

print()
print("=" * 80)
