#!/usr/bin/env python3
"""
COMPLETE IMPORT DEMO
Fresh start with all suppliers
"""
import sys
sys.path.insert(0, '/app/backend')

print("🎯 COMPLETE DISTRIBUTED IMPORT DEMO")
print("=" * 80)
print()

# Step 1: Reset everything
print("1️⃣  Resetting streams...")
import redis
r = redis.Redis(host='redis')
for stream in ['import:download', 'import:parse', 'import:process']:
    r.delete(stream)
print("   ✅ Streams reset\n")

# Step 2: Populate queue
print("2️⃣  Populating queue from multiple sources...")
from import_queue.import_queue import ImportQueue
from scrapers.scraper_registry import get_registry
from concurrent.futures import ThreadPoolExecutor

queue = ImportQueue()
registry = get_registry()

def populate_source(source_id, limit=50):
    scraper = registry.get(source_id)
    if not scraper:
        return 0
    
    files = scraper.fetch_file_list(limit=limit)
    # Filter only Price files for SuperPharm
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
    
    print(f"   ✅ {source_id}: {count} files queued")
    return count

with ThreadPoolExecutor(max_workers=2) as executor:
    future1 = executor.submit(populate_source, 'shufersal', 50)
    future2 = executor.submit(populate_source, 'superpharm', 30)
    
    total = future1.result() + future2.result()

print(f"\n   📊 Total queued: {total} files\n")

# Step 3: Show status
stats = queue.get_stats()
print("3️⃣  Queue status:")
for stream, info in stats.items():
    print(f"   {stream}: {info['length']} jobs")

print()
print("=" * 80)
print("✅ READY! Now start workers manually:")
print()
print("Downloaders: for ($i=1; $i -le 3; $i++) { docker exec -d gogobe-api-1 python /app/backend/workers/downloader.py }")
print("Parsers:     for ($i=1; $i -le 5; $i++) { docker exec -d gogobe-api-1 python /app/backend/workers/parser.py }")
print("Processors:  for ($i=1; $i -le 5; $i++) { docker exec -d gogobe-api-1 python /app/backend/workers/processor.py }")
print()
print("Monitor:     docker exec gogobe-api-1 python /app/backend/monitor_queue.py")
print("=" * 80)
