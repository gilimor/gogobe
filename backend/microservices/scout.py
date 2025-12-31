
"""
Microservice #1: SCOUT (The Discovery Service)
Responsibility: Check remote servers for new files.
Output: 'New File Discovered' events.
"""
import sys
import os
import logging
from pathlib import Path

# Add parent directory to path to import backend modules
sys.path.append(str(Path(__file__).resolve().parents[2]))

from backend.scrapers.scraper_registry import SCRAPER_REGISTRY
from backend.services.file_processing_tracker import FileProcessingTracker
from backend.scrapers.base_supermarket_scraper import get_db_connection

logging.basicConfig(level=logging.INFO, format='%(asctime)s [SCOUT] %(message)s')
logger = logging.getLogger("Scout")

def run_scout(chain_name=None):
    logger.info("📡 Scout Service Started")
    
    # 1. Determine targets
    targets = SCRAPER_REGISTRY.keys() if not chain_name else [chain_name]
    
    # 2. Init DB Connection (for Tracker)
    try:
        conn = get_db_connection()
        tracker = FileProcessingTracker(conn)
    except Exception as e:
        logger.error(f"DB Connection failed: {e}")
        return

    # 3. Scan Loop
    for chain in targets:
        scraper_cls = SCRAPER_REGISTRY.get(chain)
        if not scraper_cls:
            continue
            
        try:
            logger.info(f"Scanning {chain}...")
            scraper = scraper_cls()
            files = scraper.fetch_file_list()
            
            new_files = 0
            for f in files:
                # Use Tracker to check if file requires processing
                if tracker.should_process(f.filename):
                    logger.info(f"✨ DISCOVERED: {f.filename} ({chain})")
                    new_files += 1
                    
                    # Push to Redis Queue
                    try:
                        import redis
                        import json
                        r = redis.Redis(host='localhost', port=6379, db=0)
                        payload = {
                            'url': f.url, 
                            'filename': f.filename, 
                            'chain': chain,
                            'timestamp': f.file_date.isoformat() if f.file_date else None
                        }
                        r.rpush('queue:downloads', json.dumps(payload))
                        logger.info(f"   -> Pushed to Redis: queue:downloads")
                    except Exception as e:
                        logger.warning(f"   -> Redis push failed (running standalone?): {e}")

            if new_files == 0:
                logger.debug(f"{chain}: No new files.")
                
        except Exception as e:
            logger.error(f"Error scanning {chain}: {e}")

if __name__ == "__main__":
    chain = sys.argv[1] if len(sys.argv) > 1 else None
    run_scout(chain)
