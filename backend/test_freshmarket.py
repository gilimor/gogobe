
import os
import sys
import logging
from pathlib import Path

# Add /app to path
sys.path.append(str(Path(__file__).parent.parent))
# Add /app/backend to path
sys.path.append(str(Path(__file__).parent))

from scrapers.fresh_market_scraper import FreshMarketScraper

# Configure logger
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')
logger = logging.getLogger(__name__)

def run():
    logger.info("🚀 Testing FreshMarket Scraper for Store Names...")
    
    scraper = FreshMarketScraper()
    
    # 1. Login
    if not scraper.login():
        logger.error("❌ Login failed!")
        return
        
    # 2. Fetch File List (Stores)
    logger.info("📂 Fetching Stores files...")
    files = scraper.fetch_file_list(file_type='stores', limit=3)
    
    if not files:
        logger.warning("⚠️ No stores file found via API!")
    else:
        logger.info(f"✅ Found {len(files)} stores files")
        for f in files:
            logger.info(f"   - {f.filename}")
            
        # 3. Try to download and parse one to check names
        f = files[0]
        try:
            download_dir = Path("/app/data/freshmarket")
            download_dir.mkdir(parents=True, exist_ok=True)
            local_path = scraper.download_file(f, download_dir)
            clean_path = scraper.decompress_file(local_path)
            
            # Parse
            # Note: We need to see if parse_stores_file is called or generic parse_file
            # FreshMarket inherits PublishedPricesScraper which has parse_stores_file
            
            logger.info(f"Parsing {clean_path}...")
            # We call the internal method directly or via parse_file if logic exists
            # PublishedPricesScraper.parse_file dispatches to _parse_stores_file if 'stores' in name
            
            metadata, products = scraper.parse_file(clean_path)
            
            # The _parse_stores_file returns ({}, []) but inserts to DB. 
            # We want to see logs of insertion.
            
        except Exception as e:
            logger.error(f"Failed to process file: {e}")

if __name__ == "__main__":
    run()
