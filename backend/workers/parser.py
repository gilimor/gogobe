#!/usr/bin/env python3
"""
PARSER WORKER
Parses XML files and adds products to process queue
Run multiple instances for parallel parsing
Supports ALL suppliers via Plugin Registry
"""
import sys
sys.path.insert(0, '/app/backend')

import os
import logging
from import_queue.import_queue import ImportQueue
from scrapers.scraper_registry import get_registry
import time

logger = logging.getLogger(__name__)
WORKER_ID = f"parser-{os.getpid()}"

print(f"📄 {WORKER_ID} starting...")

queue = ImportQueue()
registry = get_registry()
print(f"📋 Available scrapers: {list(registry.get_all_enabled().keys())}")

processed = 0
errors = 0

while True:
    # Get parse jobs
    jobs = queue.get_parse_jobs(WORKER_ID, count=5)
    
    if not jobs:
        time.sleep(1)
        continue
    
    for job in jobs:
        job_id = job['id']
        data = job['data']
        
        try:
            source_id = data.get('source_id', 'unknown')
            filepath = data['filepath']
            store_code = data.get('store_code', '')
            
            # Get scraper from registry
            scraper = registry.get(source_id)
            if not scraper:
                logger.error(f"[{WORKER_ID}] Scraper not available: {source_id}")
                errors += 1
                continue
            
            # Parse file
            metadata, products = scraper.parse_file(filepath)
            
            if not products:
                queue.ack_parse(job_id)
                continue
            
            # Get/create store
            store_id = scraper.get_or_create_store(store_code)
            
            # Add to process queue
            queue.add_process_job(
                source_id=source_id,
                products=products,
                store_id=store_id
            )
            
            # Acknowledge
            queue.ack_parse(job_id)
            processed += 1
            
            if processed % 10 == 0:
                print(f"[{WORKER_ID}] Parsed: {processed} files ({sum(len(p) for p in [products])} products), Errors: {errors}")
            
        except Exception as e:
            errors += 1
            print(f"[{WORKER_ID}] Error: {e}")
