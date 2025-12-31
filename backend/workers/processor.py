#!/usr/bin/env python3
"""
PROCESSOR WORKER
Imports products to database using COPY method
Run multiple instances for parallel DB writes
"""
import sys
sys.path.insert(0, '/app/backend')

import os
import json
from import_queue.import_queue import ImportQueue
from scrapers.shufersal_scraper import ShufersalScraper
import time

WORKER_ID = f"processor-{os.getpid()}"

print(f"💾 {WORKER_ID} starting...")

queue = ImportQueue()
scraper = ShufersalScraper()

processed_files = 0
processed_products = 0
errors = 0

while True:
    # Get process jobs
    jobs = queue.get_process_jobs(WORKER_ID, count=5)
    
    if not jobs:
        time.sleep(1)
        continue
    
    for job in jobs:
        job_id = job['id']
        data = job['data']
        
        try:
            products = json.loads(data['products'])
            store_id = int(data['store_id'])
            
            # Import all products
            for product in products:
                scraper.import_product(product, store_id)
            
            # Flush batch (COPY method)
            scraper._flush_price_batch()
            
            # Acknowledge
            queue.ack_process(job_id)
            
            processed_files += 1
            processed_products += len(products)
            
            if processed_files % 10 == 0:
                print(f"[{WORKER_ID}] Processed: {processed_files} files, {processed_products:,} products, Errors: {errors}")
            
        except Exception as e:
            errors += 1
            print(f"[{WORKER_ID}] Error: {e}")

