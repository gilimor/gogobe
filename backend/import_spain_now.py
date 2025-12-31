
import logging
import sys
from pathlib import Path

# Add /app to path
sys.path.append(str(Path(__file__).parent))

from scrapers.spain_fuel_scraper import SpainFuelScraper

logging.basicConfig(level=logging.INFO, format='%(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger('SpainImport')

def run_import():
    scraper = SpainFuelScraper()
    
    logger.info("🚀 Starting Spain Fuel Import...")
    
    # 1. Fetch File List
    files = scraper.fetch_file_list()
    logger.info(f"Found {len(files)} files to process.")
    
    download_dir = Path("/app/data/spain_import")
    download_dir.mkdir(parents=True, exist_ok=True)
    
    for f in files:
        # 2. Download
        local_path = scraper.download_file(f, download_dir)
        if not local_path:
            continue
            
        # 3. Parse
        scraper.parse_file(local_path)
    
    logger.info("✅ Spain Import Completed.")
    
if __name__ == "__main__":
    run_import()
