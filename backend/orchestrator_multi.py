#!/usr/bin/env python3
"""
MULTI-SOURCE ORCHESTRATOR
Populates Redis queue from MULTIPLE supermarket chains in parallel
"""
import sys
sys.path.insert(0, '/app/backend')

from import_queue.import_queue import ImportQueue
from scrapers.shufersal_scraper import ShufersalScraper
from scrapers.superpharm_scraper import SuperPharmScraper
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor
import time

print("=" * 80)
print("🚀 MULTI-SOURCE DISTRIBUTED IMPORT ORCHESTRATOR")
print("=" * 80)
print()

queue = ImportQueue()

def populate_shufersal():
    """Populate Shufersal files"""
    print("📡 [Shufersal] Starting...")
    scraper = ShufersalScraper()
    files = scraper.fetch_file_list(file_type='prices_full', limit=100)  # Start with 100
    
    print(f"   [Shufersal] Found {len(files)} files")
    
    for idx, file_meta in enumerate(files, 1):
        queue.add_download_job(
            source_id='shufersal',
            file_metadata={
                'filename': file_meta.filename or '',
                'url': file_meta.url or '',
                'store_code': file_meta.store_id or '',  # Shufersal uses store_id
                'file_type': file_meta.file_type or 'prices_full'
            }
        )
        if idx % 20 == 0:
            print(f"   [Shufersal] Queued: {idx}/{len(files)}")
    
    print(f"✅ [Shufersal] Queued {len(files)} files")
    return len(files)

def populate_superpharm():
    """Populate SuperPharm files"""
    print("📡 [SuperPharm] Starting...")
    scraper = SuperPharmScraper()
    files = scraper.fetch_file_list(limit=100)  # Start with 100
    
    # Filter only PriceFull for now
    price_files = [f for f in files if 'Price' in f.file_type]
    print(f"   [SuperPharm] Found {len(price_files)} Price files (out of {len(files)} total)")
    
    for idx, file_meta in enumerate(price_files, 1):
        queue.add_download_job(
            source_id='superpharm',
            file_metadata={
                'filename': file_meta.filename or '',
                'url': file_meta.url or '',
                'store_code': file_meta.store_code or '',
                'file_type': file_meta.file_type or 'PriceFull'
            }
        )
        if idx % 20 == 0:
            print(f"   [SuperPharm] Queued: {idx}/{len(price_files)}")
    
    print(f"✅ [SuperPharm] Queued {len(price_files)} files")
    return len(price_files)

# Populate from multiple sources IN PARALLEL
print("📤 Populating from multiple sources in parallel...")
start = datetime.now()

with ThreadPoolExecutor(max_workers=2) as executor:
    future_shufersal = executor.submit(populate_shufersal)
    future_superpharm = executor.submit(populate_superpharm)
    
    shufersal_count = future_shufersal.result()
    superpharm_count = future_superpharm.result()

duration = (datetime.now() - start).total_seconds()
total = shufersal_count + superpharm_count

print()
print("=" * 80)
print(f"✅ Queue Population Complete!")
print(f"   Duration: {duration:.1f}s")
print(f"   Total files queued: {total}")
print(f"   - Shufersal: {shufersal_count}")
print(f"   - SuperPharm: {superpharm_count}")
print()

# Show queue stats
print("📊 Queue Stats:")
stats = queue.get_stats()
for stream, info in stats.items():
    print(f"   {stream}: {info['length']} pending")

print()
print("=" * 80)
print()
print("🚀 NOW START WORKERS:")
print()
print("# Downloaders (5 workers):")
print("for ($i=1; $i -le 5; $i++) { docker exec -d gogobe-api-1 python /app/backend/workers/downloader.py }")
print()
print("# Parsers (10 workers):")
print("for ($i=1; $i -le 10; $i++) { docker exec -d gogobe-api-1 python /app/backend/workers/parser.py }")
print()
print("# Processors (10 workers):")
print("for ($i=1; $i -le 10; $i++) { docker exec -d gogobe-api-1 python /app/backend/workers/processor.py }")
print()
print("=" * 80)
