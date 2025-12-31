
import sys
import os
from pathlib import Path
import logging

# Add backend to path
sys.path.insert(0, str(Path(__file__).parent / 'backend'))

from scrapers.lkltd_scraper import LKLtdScraper

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def main():
    logger.info("Initializing L.K. LTD Scraper...")
    scraper = LKLtdScraper()
    
    # 1. Fetch Categories
    logger.info("Step 1: Fetching Categories...")
    files = scraper.fetch_file_list(limit=3) # Try to get 3 categories
    
    if not files:
        logger.error("No categories found!")
        return
        
    for f in files:
        logger.info(f"Found Category: {f.filename} ({f.url})")
        
    # 2. Download & Parse First Category
    target_file = files[0]
    download_dir = Path("lkltd_data_test")
    download_dir.mkdir(exist_ok=True)
    
    logger.info(f"\nStep 2: Downloading {target_file.filename}...")
    json_path = scraper.download_file(target_file, download_dir)
    
    logger.info(f"\nStep 3: Parsing {json_path}...")
    meta, products = scraper.parse_file(json_path)
    
    logger.info(f"\nParsed {len(products)} products!")
    if products:
        logger.info("Sample Product:")
        p = products[0]
        print(f"Name: {p.name}")
        print(f"Price: {p.price}")
        print(f"Code: {p.barcode}")
        print(f"Image: {p.attributes.get('image_url')}")
    else:
        logger.warning("Category was empty or failed to parse.")

if __name__ == "__main__":
    main()
