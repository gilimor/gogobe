
import logging
import sys
from pathlib import Path
from datetime import datetime

# Add /app to path
sys.path.append(str(Path(__file__).parent))

from scrapers.france_fuel_scraper import FranceFuelScraper

logging.basicConfig(level=logging.INFO, format='%(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger('FranceImport')

def run_import():
    scraper = FranceFuelScraper()
    
    logger.info("🚀 Starting France Fuel Import...")
    
    # 1. Fetch File List
    files = scraper.fetch_file_list(file_type='all')
    if not files:
        logger.error("No files found!")
        return
        
    target_file = files[0]
    logger.info(f"Target: {target_file.url}")
    
    # 2. Download
    # Create dir if needed
    download_dir = Path("/app/data/france_import")
    download_dir.mkdir(parents=True, exist_ok=True)
    
    local_path = scraper.download_file(target_file, download_dir)
    if not local_path:
        logger.error("Download failed")
        return
        
    logger.info(f"Downloaded to {local_path}")
    
    # 3. Parse
    logger.info("Parsing...")
    scraper.parse_file(local_path)
    
    logger.info("✅ France Import Completed.")
    
if __name__ == "__main__":
    run_import()
