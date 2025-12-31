
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
    logger.info("🚀 Retrying Prices Import...")
    
    scraper = ItalyFuelScraper()
    download_dir = Path("/app/data/mimit_import")
    
    # Manually trigger parse_prices on the existing file to save time
    # Check if file exists
    import glob
    files = glob.glob("/app/data/mimit_import/prezzo_alle_8*.csv")
    if not files:
        logger.error("No price file found")
        return
        
    prices_file = Path(files[0]) # Take the first one
    logger.info(f"Parsing existing file: {prices_file}")
    
    # We must ensure chain and store map are loaded.
    # The `parse_file` calls `_parse_prices` which handles store map loading.
    scraper.ensure_chain_exists()
    scraper.parse_file(prices_file)
        
    logger.info("✅ Retry Completed.")

if __name__ == "__main__":
    run()
