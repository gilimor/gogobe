
import os
import sys
import json
import logging
import time
from datetime import datetime
from pathlib import Path

# Add backend to path
sys.path.append(str(Path(__file__).parent.parent))

from scrapers.scraper_registry import ScraperRegistry
from kafka import KafkaProducer

# Config
KAFKA_BROKER = 'kafka:29092'
TOPIC_DISCOVERED = 'gogobe.import.discovered'

# Logging
logging.basicConfig(level=logging.INFO, format='[%(asctime)s] 🕵️ %(message)s')
logger = logging.getLogger("Scout")

class ImportScout:
    def __init__(self):
        self.registry = ScraperRegistry()
        try:
            self.producer = KafkaProducer(
                bootstrap_servers=KAFKA_BROKER,
                value_serializer=lambda v: json.dumps(v).encode('utf-8')
            )
            logger.info(f"✅ Connected to Kafka at {KAFKA_BROKER}")
        except Exception as e:
            logger.error(f"❌ Failed to connect to Kafka: {e}")
            sys.exit(1)

    def scan_sources(self):
        """Scans all enabled sources and pushes files to Kafka"""
        scrapers = list(self.registry.get_all_enabled().values())
        logger.info(f"🔍 Scanning {len(scrapers)} sources...")

        total_files = 0
        
        for scraper in scrapers:
            try:
                logger.info(f"👉 Checking {scraper.chain_name}...")
                files = scraper.fetch_file_list(file_type='all', limit=20) 
                
                if not files:
                    logger.warning(f"   No files found for {scraper.chain_name}")
                    continue
                    
                logger.info(f"   Found {len(files)} files for {scraper.chain_name}")
                
                for f in files:
                    # Create Job Payload
                    payload = {
                        'chain_slug': scraper.chain_slug,
                        'filename': f.filename,
                        'url': f.url,
                        'file_type': f.file_type,
                        'discovered_at': datetime.now().isoformat(),
                        'metadata': {
                            'store_id': f.store_id,
                            'size': f.size_bytes,
                            'store_name': getattr(f, 'store_name', None) # Pass store name if available (e.g. SuperPharm)
                        }
                    }
                    
                    # Push to Kafka
                    self.producer.send(TOPIC_DISCOVERED, payload)
                    total_files += 1
                    
                self.producer.flush()
                logger.info(f"   ✅ Pushed {len(files)} jobs to Kafka")
                
            except Exception as e:
                logger.error(f"   ❌ Error scanning {scraper.chain_name}: {e}")

        logger.info(f"🏁 Scan complete. Total items dispatched: {total_files}")

if __name__ == "__main__":
    scout = ImportScout()
    while True:
        scout.scan_sources()
        logger.info("💤 Sleeping for 1 hour before next scan...")
        time.sleep(3600)
