
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
    logger.info("Starting FreshMarket Price Import Test...")
    
    scraper = FreshMarketScraper()
    if not scraper.login(): return

    # Known file from browser observation
    # Price7290876100000-002-202512260600.gz
    filename = "Price7290876100000-002-202512260600.gz"
    file_url = f"https://url.publishedprices.co.il/file/d/{filename}"
    
    f = FileMetadata(url=file_url, filename=filename, file_type='prices_full')
    
    try:
        download_dir = Path("/app/data/freshmarket_test")
        local_path = scraper.download_file(f, download_dir)
        clean_path = scraper.decompress_file(local_path)
        
        logger.info(f"Parsing {clean_path}...")
        meta, products = scraper.parse_file(clean_path)
        
        logger.info(f"Parsed {len(products)} products")
        
        # Simulare import
        stats = {'products': 0, 'prices': 0}
        
        # Get store ID
        conn = scraper.get_db_connection()
        cur = conn.cursor()
        # Find store 002
        cur.execute("SELECT id FROM stores WHERE chain_id=%s AND store_id LIKE '%%_002'", (scraper.chain_db_id,))
        res = cur.fetchone()
        store_id = res[0] if res else None
        logger.info(f"Store ID for 002: {store_id}")
        
        if store_id:
            for p in products[:50]: # Test 50
                res_stats = scraper.import_product(p, store_id=store_id)
                stats['products'] += res_stats['products']
                stats['prices'] += res_stats['prices']
            
            # Flush
            stats['prices'] += scraper._flush_price_batch()
            
            logger.info(f"Import stats: {stats}")
        
    except Exception as e:
        logger.error(f"Failed: {e}")
        import traceback
        logger.error(traceback.format_exc())

if __name__ == "__main__":
    run()
