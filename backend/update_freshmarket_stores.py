
import os
import sys
import logging
from pathlib import Path
from datetime import datetime

# Add /app to path
sys.path.append(str(Path(__file__).parent.parent))
# Add /app/backend to path
sys.path.append(str(Path(__file__).parent))

from scrapers.fresh_market_scraper import FreshMarketScraper
from scrapers.base_supermarket_scraper import FileMetadata

# Configure logger
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')
logger = logging.getLogger(__name__)

def run():
    logger.info("🚀 Starting Manual FreshMarket Store Update...")
    
    scraper = FreshMarketScraper()
    if not scraper.login():
        logger.error("Login failed")
        return

    scraper.ensure_chain_exists()
    
    # Construct filename manually
    # Stores7290876100000-202512260600.gz
    chain_id = "7290876100000"
    today = datetime.now()
    # Based on browser discovery, the file is old and has .xml extension (not .gz)
    filename = "Stores7290876100000-2025042909000.xml" 
    file_url = f"https://url.publishedprices.co.il/file/d/{filename}"
    
    logger.info(f"Targeting discovered file: {filename}")
    
    try:
        f = FileMetadata(
            url=file_url,
            filename=filename,
            file_type='stores'
        )
        
        # Download
        download_dir = Path("/app/data/freshmarket")
        download_dir.mkdir(parents=True, exist_ok=True)
        # Note: Base scraper might expect .gz behavior in download_file if we don't watch out
        # But download_file just streams content.
        local_path = scraper.download_file(f, download_dir)
        
        # Decompress? No, it's XML.
        clean_path = local_path
        
        # Parse Stores (XML)
        logger.info(f"Parsing {clean_path}...")
        
        # We need to manually call parse because parse_file might expect .gz or handle cleanup
        # FreshMarket inherits PublishedPricesScraper -> _parse_stores_file(root)
        
        with open(clean_path, 'r', encoding='utf-16') as f:
            logger.info("XML Content: " + f.read(1000))        
        import xml.etree.ElementTree as ET
        tree = ET.parse(clean_path)
        root = tree.getroot()
        
        logger.info(f"Root tag: {root.tag}")
        for child in root[:2]:
            logger.info(f"Child: {child.tag} - {child.attrib}")
            for sub in child[:5]:
                logger.info(f"  Sub: {sub.tag} = {sub.text}")

        # Call the internal parser
        scraper._parse_stores_file(root)
        
        # Verify specific Freshmarket store (006)
        conn = scraper.get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT name, city FROM stores WHERE chain_id=%s AND store_id='006'", (scraper.chain_db_id,))
        res = cur.fetchone()
        if res:
            logger.info(f"✅ Store 006 name in DB: {res[0]} - {res[1]}")
        else:
            logger.warning("❌ Store 006 not found after parsing")
            
        cur.execute("SELECT count(*) FROM stores WHERE chain_id=%s AND name IS NOT NULL", (scraper.chain_db_id,))
        count = cur.fetchone()[0]
        logger.info(f"📊 Total named stores for FreshMarket: {count}")
        
    except Exception as e:
        logger.error(f"Error processing {filename}: {e}")
        import traceback
        logger.error(traceback.format_exc())

if __name__ == "__main__":
    run()
