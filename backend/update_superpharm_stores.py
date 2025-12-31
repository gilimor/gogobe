
import os
import sys
import logging
from pathlib import Path

# Add /app to path
sys.path.append(str(Path(__file__).parent.parent))
# Add /app/backend to path
sys.path.append(str(Path(__file__).parent))

from scrapers.superpharm_scraper import SuperPharmScraper
from scrapers.base_supermarket_scraper import ParsedStore

# Configure logger
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')
logger = logging.getLogger(__name__)

def run():
    logger.info("🚀 Starting Manual SuperPharm Store Update...")
    
    scraper = SuperPharmScraper()
    scraper.ensure_chain_exists()
    
    # 1. Fetch File List (this populates store_registry)
    logger.info("📂 Fetching file list to build registry...")
    files = scraper.fetch_file_list(limit=None) # All files
    
    logger.info(f"✅ Found {len(files)} files")
    logger.info(f"✅ Registry size: {len(scraper.store_registry)}")
    
    if not scraper.store_registry:
        logger.warning("⚠️ Registry is empty! Check fetch_file_list logic.")
        return

    # 2. Iterate registry and update stores
    updated_count = 0
    for store_code, info in scraper.store_registry.items():
        name = info['name']
        city = info['city']
        
        # Create ParsedStore (minimal)
        ps = ParsedStore(
            store_id=store_code,
            name=name,
            city=city,
            address=None,
            bikoret_no=None
        )
        
        try:
            # This handles creation or update
            db_id = scraper.get_or_create_store(ps)
            updated_count += 1
            if updated_count % 10 == 0:
                logger.info(f"   Updated {updated_count} stores...")
        except Exception as e:
            logger.error(f"Failed to update store {store_code}: {e}")
            
    logger.info(f"🏁 Finished. Updated {updated_count} stores.")

if __name__ == "__main__":
    run()
