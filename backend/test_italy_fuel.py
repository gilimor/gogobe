
import os
import sys
import logging
from pathlib import Path
from datetime import datetime

# Add /app to path
sys.path.append(str(Path(__file__).parent.parent))
sys.path.append(str(Path(__file__).parent))

from scrapers.italy_fuel_scraper import ItalyFuelScraper

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')
logger = logging.getLogger(__name__)

def run():
    logger.info("Starting Italy Fuel Scraper Test...")
    
    scraper = ItalyFuelScraper()
    
    # 1. Fetch List
    files = scraper.fetch_file_list(file_type='all')
    logger.info(f"Found {len(files)} files to process:")
    for f in files:
        logger.info(f" - {f.file_type}: {f.url}")
        
    # 2. Test Download (Anagrafica)
    anagrafica = next((f for f in files if f.file_type == 'stores'), None)
    if anagrafica:
        logger.info("Downloading Registry...")
        download_dir = Path("/app/data/mimit_test")
        try:
            local_path = scraper.download_file(anagrafica, download_dir)
            logger.info(f"Downloaded to {local_path}")
            
            # 3. Peak at content
            with open(local_path, 'r', encoding='utf-8', errors='replace') as f:
                header = f.readline().strip()
                logger.info(f"Header: {header}")
                line1 = f.readline().strip()
                logger.info(f"Row 1: {line1}")
                
        except Exception as e:
            logger.error(f"Download failed: {e}")
            import traceback
            logger.error(traceback.format_exc())

if __name__ == "__main__":
    run()
