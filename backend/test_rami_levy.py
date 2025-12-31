
import os
import sys
import logging
from pathlib import Path

# Add /app to path (parent of backend)
sys.path.append(str(Path(__file__).parent.parent))
# Add /app/backend to path
sys.path.append(str(Path(__file__).parent))

from scrapers.rami_levy_scraper import RamiLevyScraper

# Configure logger
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')
logger = logging.getLogger(__name__)

def run():
    logger.info("🚀 Testing Rami Levy Scraper...")
    
    scraper = RamiLevyScraper()
    
    # 1. Login
    if not scraper.login():
        logger.error("❌ Login failed!")
        return
    else:
        logger.info("✅ Login successful!")
        
    # 2. Fetch File List (Stores)
    logger.info("📂 Fetching Stores files...")
    files = scraper.fetch_file_list(file_type='stores', limit=5)
    
    if not files:
        logger.warning("⚠️ No stores file found via API!")
    else:
        logger.info(f"✅ Found {len(files)} stores files")
        for f in files:
            logger.info(f"   - {f.filename}")

    # 3. Fetch File List (Prices)
    logger.info("📂 Fetching Prices files...")
    files = scraper.fetch_file_list(file_type='prices_full', limit=5)
    
    if not files:
        logger.warning("⚠️ No prices file found via API!")
    else:
        logger.info(f"✅ Found {len(files)} prices files")
        for f in files:
            logger.info(f"   - {f.filename}")

if __name__ == "__main__":
    run()
