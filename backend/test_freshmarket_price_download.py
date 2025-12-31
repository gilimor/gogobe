
import os
import sys
import logging
from pathlib import Path
from datetime import datetime

# Add /app to path
sys.path.append(str(Path(__file__).parent.parent))
sys.path.append(str(Path(__file__).parent))

from scrapers.fresh_market_scraper import FreshMarketScraper
from scrapers.base_supermarket_scraper import FileMetadata

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')
logger = logging.getLogger(__name__)

def run():
    logger.info("🚀 Testing FreshMarket Price File Download...")
    
    scraper = FreshMarketScraper()
    if not scraper.login():
        logger.error("Login failed")
        return

    chain_id = "7290876100000"
    date_str = datetime.now().strftime("%Y%m%d")
    hour = "0600"
    store = "006" # Known store
    
    filename = f"Price{chain_id}-{store}-{date_str}{hour}.gz"
    file_url = f"https://url.publishedprices.co.il/file/d/{filename}"
    
    logger.info(f"Targeting Price file: {filename}")
    
    try:
        f = FileMetadata(
            url=file_url,
            filename=filename,
            file_type='prices_full'
        )
        # Download
        download_dir = Path("/app/data/freshmarket")
        download_dir.mkdir(parents=True, exist_ok=True)
        local_path = scraper.download_file(f, download_dir)
        logger.info(f"✅ Success! Downloaded to {local_path}")
        
    except Exception as e:
        logger.error(f"Download failed: {e}")

if __name__ == "__main__":
    run()
