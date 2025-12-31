
import sys
import os
import logging
from pathlib import Path

# Set up path to include current directory (backend)
# Set up path to include backend (parent of scripts)
sys.path.append(str(Path(__file__).parent.parent))

from scrapers.lkltd_scraper import LKLtdScraper

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def main():
    logger.info("Initializing L.K. LTD Scraper (Docker Test)...")
    scraper = LKLtdScraper()
    
    # 1. Fetch Categories
    logger.info("Step 1: Fetching Categories...")
    files = scraper.fetch_file_list(limit=3) 
    
    if not files:
        logger.error("No categories found!")
        return
        
    for f in files:
        logger.info(f"Found Category: {f.filename} ({f.url})")
        
    # 2. Download & Parse First Category
    target_file = files[0]
    # Save to /app/data which is mounted to ./data on host
    download_dir = Path("/app/data/lkltd_test_v3")
    import shutil
    if download_dir.exists():
        shutil.rmtree(download_dir)
    download_dir.mkdir(parents=True, exist_ok=True)
    
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
