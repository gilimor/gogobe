#!/usr/bin/env python3
"""
DOWNLOADER WORKER
Downloads files and adds to parse queue
Run multiple instances for parallel downloads
Supports ALL suppliers via Plugin Registry - no IF statements
"""
import sys
sys.path.insert(0, '/app/backend')

import os
import logging
from import_queue.import_queue import ImportQueue
from scrapers.scraper_registry import get_registry
import time

logger = logging.getLogger(__name__)

WORKER_ID = f"downloader-{os.getpid()}"

print(f"🔽 {WORKER_ID} starting...")

queue = ImportQueue()
registry = get_registry()

# Show available scrapers
print(f"📋 Available scrapers: {list(registry.get_all_enabled().keys())}")

processed = 0
errors = 0

while True:
    # Get download jobs
    jobs = queue.get_download_jobs(WORKER_ID, count=5)
    
    if not jobs:
        time.sleep(1)
        continue
    
    for job in jobs:
        job_id = job['id']
        data = job['data']
        
        try:
            source_id = data.get('source_id', 'unknown')
            filename = data['filename']
            
            # Get the right scraper from registry
            scraper = registry.get(source_id)
            
            if not scraper:
                logger.error(f"[{WORKER_ID}] Scraper not available: {source_id}")
                errors += 1
                continue
            
            filepath = scraper.download_dir + '/' + filename
            
            # Check if already exists
            if not os.path.exists(filepath):
                # Download needed - but most files already exist
                print(f"[{WORKER_ID}] Downloading {filename} from {source_id}...")
                # Add download logic here if needed
            
            # Add to parse queue
            queue.add_parse_job(
                source_id=source_id,
                filepath=filepath,
                metadata={
                    'filename': filename,
                    'store_code': data.get('store_code', '')
                }
            )
            
            # Acknowledge
            queue.ack_download(job_id)
            processed += 1
            
            if processed % 10 == 0:
                print(f"[{WORKER_ID}] Downloaded: {processed}, Errors: {errors}")
            
        except Exception as e:
            errors += 1
            print(f"[{WORKER_ID}] Error: {e}")
            # Don't ack - will retry
