
import os
import sys
import json
import logging
import time
from pathlib import Path
from kafka import KafkaConsumer, KafkaProducer

# Add backend to path
sys.path.append(str(Path(__file__).parent.parent))

from scrapers.scraper_registry import ScraperRegistry
from scrapers.base_supermarket_scraper import FileMetadata
from database.db_connection import get_db_connection
from services.file_processing_tracker import FileProcessingTracker

# Config
KAFKA_BROKER = 'kafka:29092'
TOPIC_SOURCE = 'gogobe.import.discovered'
TOPIC_DEST = 'gogobe.import.downloaded'
GROUP_ID = 'gogobe_carriers_v1'

# Logging
logging.basicConfig(level=logging.INFO, format='[%(asctime)s] 🦅 %(message)s')
logger = logging.getLogger("Carrier")

class ImportCarrier:
    def __init__(self, worker_id):
        self.worker_id = worker_id
        self.registry = ScraperRegistry()
        self.scrapers = {} # Cache scraper instances
        
        # Database & Tracker
        self.conn = get_db_connection()
        self.tracker = FileProcessingTracker(self.conn)
        
        # Kafka
        try:
            self.consumer = KafkaConsumer(
                TOPIC_SOURCE,
                bootstrap_servers=KAFKA_BROKER,
                group_id=GROUP_ID,
                auto_offset_reset='earliest',
                value_deserializer=lambda x: json.loads(x.decode('utf-8'))
            )
            self.producer = KafkaProducer(
                bootstrap_servers=KAFKA_BROKER,
                value_serializer=lambda v: json.dumps(v).encode('utf-8')
            )
            logger.info(f"✅ Carrier #{worker_id} Ready. Listening on {TOPIC_SOURCE}")
        except Exception as e:
            logger.error(f"❌ Kafka Error: {e}")
            sys.exit(1)

    def get_scraper(self, chain_slug):
        if chain_slug not in self.scrapers:
            self.scrapers[chain_slug] = self.registry.get(chain_slug)
        return self.scrapers[chain_slug]

    def run(self):
        for message in self.consumer:
            job = message.value
            chain_slug = job['chain_slug']
            filename = job['filename']
            
            try:
                # 1. Deduplication using DB Tracker
                if not self.tracker.should_process(filename):
                    logger.info(f"⏭️ Skipping {filename} (Already in DB)")
                    continue
                
                # 2. Get Scraper to handle download
                scraper = self.get_scraper(chain_slug)
                if not scraper:
                    logger.error(f"❌ No scraper found for {chain_slug}")
                    continue
                
                logger.info(f"⬇️ Downloading {filename}...")
                
                # Start tracking
                log_id = self.tracker.start_processing(filename, scraper.chain_name)
                
                # Reconstruct Metadata object
                meta = FileMetadata(
                    url=job['url'],
                    filename=filename,
                    file_type=job['file_type']
                )
                
                # Execute Download
                download_dir = Path(f"/app/data/{chain_slug}")
                download_dir.mkdir(parents=True, exist_ok=True)
                
                local_path = scraper.download_file(meta, download_dir)
                
                # Update Tracker
                self.tracker.update_status(log_id, 'downloaded')
                logger.info(f"✅ Downloaded {filename}")
                
                # 3. Push to Next Stage (Parser)
                payload = job.copy()
                payload['local_path'] = str(local_path)
                payload['log_id'] = log_id
                
                self.producer.send(TOPIC_DEST, payload)
                
            except Exception as e:
                logger.error(f"❌ Error processing {filename}: {e}")
                # self.tracker.mark_failed(log_id, e) # Need log_id here

if __name__ == "__main__":
    w_id = os.environ.get('WORKER_ID', '1')
    carrier = ImportCarrier(w_id)
    carrier.run()
