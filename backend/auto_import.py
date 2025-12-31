#!/usr/bin/env python3
"""
COMPLETE AUTOMATED IMPORT
Everything in the right order
"""
import sys
sys.path.insert(0, '/app/backend')
import subprocess
import time

print("🤖 AUTOMATED DISTRIBUTED IMPORT")
print("=" * 80)
print()

# Step 1: Reset streams
print("1️⃣  Resetting streams...")
import redis
r = redis.Redis(host='redis')
for stream in ['import:download', 'import:parse', 'import:process']:
    r.delete(stream)
print("   ✅ Done\n")

# Step 2: START WORKERS FIRST (before populating!)
print("2️⃣  Starting workers...")
print("   Starting 3 downloaders...")
for i in range(3):
    subprocess.Popen(['python', '/app/backend/workers/downloader.py'], 
                     stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(2)

print("   Starting 5 parsers...")
for i in range(5):
    subprocess.Popen(['python', '/app/backend/workers/parser.py'],
                     stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
time.sleep(2)

print("   Starting 5 processors...")
for i in range(5):
    subprocess.Popen(['python', '/app/backend/workers/processor.py'],
                     stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

print("   ✅ All workers started\n")
time.sleep(3)

# Step 3: NOW populate (workers are already listening!)
print("3️⃣  Populating queue...")
from import_queue.import_queue import ImportQueue
from scrapers.scraper_registry import get_registry

queue = ImportQueue()
registry = get_registry()

def populate_source(source_id, limit=50):
    scraper = registry.get(source_id)
    if not scraper:
        return 0
    
    files = scraper.fetch_file_list(limit=limit)
    if source_id == 'superpharm':
        files = [f for f in files if 'Price' in f.file_type]
    
    count = 0
    for f in files:
        queue.add_download_job(
            source_id=source_id,
            file_metadata={
                'filename': f.filename or '',
                'url': f.url or '',
                'store_code': getattr(f, 'store_code', None) or getattr(f, 'store_id', '') or '',
                'file_type': f.file_type or ''
            }
        )
        count += 1
    
    print(f"   ✅ {source_id}: {count} files added")
    return count

# Populate sequentially (to avoid race conditions)
total = 0
total += populate_source('superpharm', 30)
total += populate_source('shufersal', 50)

print(f"\n   📊 Total: {total} files queued\n")

# Step 4: Monitor progress
print("4️⃣  Monitoring progress...")
print()

for i in range(60):  # Monitor for up to 2 minutes
    stats = queue.get_stats()
    download = stats.get('import:download', {}).get('length', 0)
    parse = stats.get('import:parse', {}).get('length', 0)
    process = stats.get('import:process', {}).get('length', 0)
    
    print(f"\r   ⏳ Download:{download:3d} | Parse:{parse:3d} | Process:{process:3d}", end='', flush=True)
    
    if download == 0 and parse == 0 and process == 0:
        print("\n\n   ✅ All queues empty - work complete!")
        break
    
    time.sleep(2)

print("\n")
print("=" * 80)
print("✅ IMPORT COMPLETE!")
print("=" * 80)
