
import os
import sys
import logging
from pathlib import Path

# Add /app to path
sys.path.append(str(Path(__file__).parent.parent))
sys.path.append(str(Path(__file__).parent))

from scrapers.italy_fuel_scraper import ItalyFuelScraper

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')
logger = logging.getLogger(__name__)

def run():
    logger.info("🚀 Starting Full Import for Italian Fuel (MIMIT)...")
    
    scraper = ItalyFuelScraper()
    download_dir = Path("/app/data/mimit_import")
    download_dir.mkdir(parents=True, exist_ok=True)
    
    # 1. Fetch File List
    files = scraper.fetch_file_list(file_type='all')
    
    # Separate types
    registry_file = next((f for f in files if f.file_type == 'stores'), None)
    prices_file = next((f for f in files if f.file_type == 'prices'), None)
    
    if not registry_file or not prices_file:
        logger.error("❌ Failed to identify both registry and price files.")
        return

    # 2. Process Registry First
    logger.info("📦 Step 1: Processing Stations Registry...")
    try:
        local_reg = scraper.download_file(registry_file, download_dir)
        scraper.parse_file(local_reg)
    except Exception as e:
        logger.error(f"Failed to process registry: {e}")
        return

    # 3. Process Prices Second
    logger.info("⛽ Step 2: Processing Fuel Prices...")
    try:
        local_prices = scraper.download_file(prices_file, download_dir)
        scraper.parse_file(local_prices)
    except Exception as e:
        logger.error(f"Failed to process prices: {e}")
        return
        
    logger.info("✅ Import Cycle Completed.")

if __name__ == "__main__":
    run()
