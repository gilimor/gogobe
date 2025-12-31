#!/usr/bin/env python3
"""
ORCHESTRATOR
Populates download queue with all files to import
Run once to kick off distributed import
"""
import sys
sys.path.insert(0, '/app/backend')

from import_queue.import_queue import ImportQueue
from scrapers.shufersal_scraper import ShufersalScraper
from datetime import datetime

print("=" * 80)
print("🎯 DISTRIBUTED IMPORT ORCHESTRATOR")
print("=" * 80)
print()

# Initialize
queue = ImportQueue()
scraper = ShufersalScraper()

# Clear previous jobs (optional)
# queue.clear_all()

print("📡 Fetching file list...")
files = scraper.fetch_file_list(limit=None)
total_files = len(files)

print(f"✓ Found {total_files} files")
print()

print("📤 Populating download queue...")
start = datetime.now()

for idx, file_metadata in enumerate(files, 1):
    queue.add_download_job(
        source_id='shufersal',
        file_metadata={
            'filename': file_metadata.filename,
            'url': file_metadata.url if hasattr(file_metadata, 'url') else '',
            'store_code': file_metadata.store_code
        }
    )
    
    if idx % 100 == 0:
        print(f"  Queued: {idx}/{total_files}")

duration = (datetime.now() - start).total_seconds()

print()
print(f"✅ Queued {total_files} files in {duration:.1f}s")
print()
print("📊 Queue Stats:")
stats = queue.get_stats()
for stream, info in stats.items():
    print(f"   {stream}: {info['length']} pending")
print()
print("🚀 Workers can now process the queue!")
print()
print("To start workers:")
print("  docker exec gogobe-api-1 python /app/backend/workers/downloader.py")
print("  docker exec gogobe-api-1 python /app/backend/workers/parser.py")
print("  docker exec gogobe-api-1 python /app/backend/workers/processor.py")
print()
print("=" * 80)
