
import os
import sys
import logging
from pathlib import Path

# Add /app to path (parent of backend)
sys.path.append(str(Path(__file__).parent.parent))
# Add /app/backend to path
sys.path.append(str(Path(__file__).parent))

from scrapers.shufersal_scraper import ShufersalScraper

# Configure logger
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')
logger = logging.getLogger(__name__)

def run():
    logger.info("🚀 Starting Manual Store Update for Shufersal...")
    
    scraper = ShufersalScraper()
    scraper.ensure_chain_exists()
    
    # 1. Fetch File List
    files = scraper.fetch_file_list(file_type='stores', limit=1)
    
    if not files:
        logger.error("❌ No stores file found!")
        return
        
    f = files[0]
    logger.info(f"📂 Found file: {f.filename}")
    
    # 2. Download
    download_dir = Path("/app/data/shufersal")
    download_dir.mkdir(parents=True, exist_ok=True)
    
    local_path = scraper.download_file(f, download_dir)
    logger.info(f"⬇️ Downloaded to: {local_path}")
    
    # 3. Decompress (using scraper's helper which is in BaseScraper)
    # Note: ShufersalScraper inherits from BaseSupermarketScraper
    clean_path = scraper.decompress_file(local_path)
    logger.info(f"📦 Decompressed to: {clean_path}")
    
    # 4. Parse & Update
    # Using the fixed parse_stores_file logic in the scraper
    stores = scraper.parse_stores_file(clean_path)
    logger.info(f"📋 Parsed {len(stores)} stores")
    
    if not stores:
        logger.warning("⚠️ No stores parsed! Checking Debug Logs...")
    
    updated_count = 0
    for store in stores:
        # Debug first one
        if updated_count == 0:
            logger.info(f"   Sample Store: {store.name}, {store.city}, {store.address}")
            
        if scraper.get_or_create_store(store):
            updated_count += 1
            
    logger.info(f"✅ Successfully updated {updated_count} stores in Database!")
    
    # Cleanup
    if clean_path.exists(): clean_path.unlink()
    if local_path.exists(): local_path.unlink()

if __name__ == "__main__":
    run()
