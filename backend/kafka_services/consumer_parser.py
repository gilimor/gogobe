
import os
import sys
import json
import logging
import time
import gzip
import shutil
from pathlib import Path
from kafka import KafkaConsumer, KafkaProducer

# Add backend to path
sys.path.append(str(Path(__file__).parent.parent))

from scrapers.scraper_registry import ScraperRegistry
from database.db_connection import get_db_connection
from services.file_processing_tracker import FileProcessingTracker

# Config
KAFKA_BROKER = 'kafka:29092'
TOPIC_SOURCE = 'gogobe.import.downloaded'
TOPIC_DEST = 'gogobe.import.products'
GROUP_ID = 'gogobe_processors_v1'

# Logging
logging.basicConfig(level=logging.INFO, format='[%(asctime)s] ⚡ %(message)s')
logger = logging.getLogger("Processor")

class ImportProcessor:
    def __init__(self, worker_id):
        self.worker_id = worker_id
        self.registry = ScraperRegistry()
        self.scrapers = {} 
        
        # Database & Tracker
        self.conn = get_db_connection()
        self.tracker = FileProcessingTracker(self.conn)
        
        # Kafka
        try:
            self.consumer = KafkaConsumer(
                TOPIC_SOURCE,
                bootstrap_servers=KAFKA_BROKER,
                group_id=GROUP_ID,
                value_deserializer=lambda x: json.loads(x.decode('utf-8'))
            )
            logger.info(f"✅ Processor #{worker_id} Ready. Listening on {TOPIC_SOURCE}")
        except Exception as e:
            logger.error(f"❌ Kafka Error: {e}")
            sys.exit(1)

    def get_scraper(self, chain_slug):
        if chain_slug not in self.scrapers:
            self.scrapers[chain_slug] = self.registry.get(chain_slug)
        return self.scrapers[chain_slug]

    def decompress_file(self, file_path: Path) -> Path:
        """Decompresses .gz items"""
        if str(file_path).endswith('.gz'):
            new_path = file_path.with_suffix('')
            with gzip.open(file_path, 'rb') as f_in:
                with open(new_path, 'wb') as f_out:
                    shutil.copyfileobj(f_in, f_out)
            return new_path
        return file_path

    def run(self):
        for message in self.consumer:
            job = message.value
            chain_slug = job['chain_slug']
            local_path = Path(job['local_path'])
            log_id = job.get('log_id')
            
            try:
                scraper = self.get_scraper(chain_slug)
                if not scraper:
                    continue
                
                logger.info(f"⚡ Processing {local_path.name}...")
                
                # 1. Decompress
                if self.tracker and log_id: self.tracker.update_status(log_id, 'extracting')
                clean_path = self.decompress_file(local_path)
                
                # Check for Stores File
                if job.get('file_type') == 'stores':
                     if self.tracker and log_id: self.tracker.update_status(log_id, 'parsing_stores')
                     logger.info(f"🏪 Processing Stores File: {clean_path.name}")
                     
                     if hasattr(scraper, 'parse_stores_file'):
                         scraper.ensure_chain_exists() # Ensure chain_db_id is set
                         parsed_stores = scraper.parse_stores_file(clean_path)
                         count = 0
                         for ps in parsed_stores:
                             if scraper.get_or_create_store(ps):
                                 count += 1
                         
                         stats = {'stores': count}
                         if self.tracker and log_id: self.tracker.mark_completed(log_id, stats)
                         logger.info(f"✅ Updated {count} stores from {clean_path.name}")
                     else:
                         logger.warning("Scraper does not support parse_stores_file")
                
                else:
                    # Standard Prices/Promo File
                    # 2. Parse
                    if self.tracker and log_id: self.tracker.update_status(log_id, 'parsing')
                    metadata, products = scraper.parse_file(clean_path)
                    
                    # Merge Kafka Metadata (e.g. Store Name from Scout)
                    if job.get('metadata') and isinstance(job['metadata'], dict):
                        kafka_meta = job['metadata']
                        # Populate store_name if missing
                        if not metadata.get('store_name') and kafka_meta.get('store_name'):
                             metadata['store_name'] = kafka_meta['store_name']
                        # Also sync store_id if parsed failed but metadata has it
                        if not metadata.get('store_id') and kafka_meta.get('store_id'):
                             metadata['store_id'] = kafka_meta['store_id']

                    logger.info(f"   Parsed {len(products)} products from {clean_path.name}")
                    
                    # 3. Import (using Scraper logic for now to reuse Upsert/Batch code)
                    # In V3, this would push Products to Kafka 'gogobe.import.products'
                    if self.tracker and log_id: self.tracker.update_status(log_id, 'importing')
                    
                    # Ensure Chain Exists (critical for supplier_id)
                    scraper.ensure_chain_exists()
    
                    # Resolve Store
                    store_id = None
                    if metadata.get('store_id'):
                        # Create ParsedStore object to find/create store in DB
                        from scrapers.base_supermarket_scraper import ParsedStore
                        
                        ps = ParsedStore(
                             store_id=metadata.get('store_id'),
                             name=metadata.get('store_name') or f"Store {metadata.get('store_id')}",
                             city=metadata.get('city'),
                             address=metadata.get('address'),
                             bikoret_no=metadata.get('bikoret_no')
                        )
                        store_id = scraper.get_or_create_store(ps)
    
                    # Bulk Import
                    stats = {'products': 0, 'prices': 0, 'skipped': 0}
                    for p in products:
                        # Leverage the scraper's existing import logic which handles Batching
                        # Note: We need to ensure scraper instance persists batch across calls if we want batching
                        # Or flush explicitly per file.
                        s = scraper.import_product(p, store_id=store_id)
                        stats['products'] += s['products']
                        stats['prices'] += s['prices']
                    
                    # Create a temporary 'Public' flush method or rely on size?
                    # Best to add `flush()` to BaseScraper interface.
                    if hasattr(scraper, '_flush_price_batch'):
                        inserted = scraper._flush_price_batch()
                        stats['prices'] += inserted
    
                    # Update Tracker
                    if self.tracker and log_id: self.tracker.mark_completed(log_id, stats)
                    logger.info(f"✅ Completed {local_path.name}: {stats}")
                
                # Cleanup
                if clean_path != local_path and clean_path.exists():
                    clean_path.unlink() # Delete unpacked
                
                if local_path.exists():
                    local_path.unlink() # Delete source GZ permanently
                    logger.info(f"🗑️ Deleted source file: {local_path.name}")

            except Exception as e:
                logger.error(f"❌ Error processing {local_path.name}: {e}")
                if self.tracker and log_id:
                    self.tracker.mark_failed(log_id, e)

if __name__ == "__main__":
    w_id = os.environ.get('WORKER_ID', '1')
    proc = ImportProcessor(w_id)
    proc.run()
