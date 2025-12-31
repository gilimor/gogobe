#!/usr/bin/env python3
"""
SUPER-PHARM PARALLEL IMPORT
Uses Redis Streams for maximum performance

Run this to import all SuperPharm files with distributed workers
"""
import sys
sys.path.insert(0, '/app/backend')

from import_queue.import_queue import ImportQueue
from scrapers.superpharm_scraper import SuperPharmScraper
from datetime import datetime

print("=" * 80)
print("🚀 SUPER-PHARM DISTRIBUTED IMPORT")
print("=" * 80)
print()

# Initialize
queue = ImportQueue()
scraper = SuperPharmScraper()

# Fetch files
print("📡 Fetching SuperPharm file list...")
files = scraper.fetch_file_list(limit=None)
total_files = len(files)

print(f"✓ Found {total_files} files")
print(f"   Price files: {len([f for f in files if f.file_type == 'Price'])}")
print(f"   Promo files: {len([f for f in files if f.file_type == 'Promo'])}")
print()

# Populate queue
print("📤 Populating Redis queue...")
start = datetime.now()

for idx, file_metadata in enumerate(files, 1):
    queue.add_download_job(
        source_id='superpharm',
        file_metadata={
            'filename': file_metadata.filename,
            'url': file_metadata.url,
            'store_code': file_metadata.store_code,
            'file_type': file_metadata.file_type
        }
    )
    
    if idx % 50 == 0:
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
print("🚀 NOW START WORKERS:")
print()
print("# Parsers (10 workers):")
print("for i in {1..10}; do")
print("  docker exec -d gogobe-api-1 python /app/backend/workers/parser.py")
print("done")
print()
print("# Processors (10 workers):")
print("for i in {1..10}; do")
print("  docker exec -d gogobe-api-1 python /app/backend/workers/processor.py")
print("done")
print()
print("# Downloaders (5 workers) - if needed:")
print("for i in {1..5}; do")
print("  docker exec -d gogobe-api-1 python /app/backend/workers/downloader.py")
print("done")
print()
print("=" * 80)
print()
print("Expected speed with 20 workers: 15,000-20,000 prices/second!")
print("=" * 80)
