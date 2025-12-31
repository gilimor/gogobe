
import logging
import sys
from pathlib import Path

# Add /app to path
sys.path.append(str(Path(__file__).parent))

from scrapers.tokyo_market_scraper import TokyoMarketScraper

logging.basicConfig(level=logging.INFO, format='%(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger('TokyoImport')

def run_import():
    scraper = TokyoMarketScraper()
    
    logger.info("🚀 Starting Tokyo Wholesale Market Import...")
    
    # 1. Fetch File List
    files = scraper.fetch_file_list()
    logger.info(f"Found {len(files)} markets/categories to process.")
    
    download_dir = Path("/app/data/tokyo_import")
    download_dir.mkdir(parents=True, exist_ok=True)
    
    for f in files:
        # 2. Download
        local_path = scraper.download_file(f, download_dir)
        if not local_path:
            continue
            
        # 3. Parse
        scraper.parse_file(local_path)
    
    logger.info("✅ Tokyo Import Completed.")
    
if __name__ == "__main__":
    run_import()
