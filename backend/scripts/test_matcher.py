
import os
import psycopg2
import logging
import json
import sys
from pathlib import Path
# Add backend to path
sys.path.append(str(Path(__file__).parent.parent))

from services.master_product_matcher import MasterProductMatcher

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def test_matcher():
    db_config = {
        'dbname': os.getenv('DB_NAME', 'gogobe'),
        'user': os.getenv('DB_USER', 'postgres'),
        'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
        'host': os.getenv('DB_HOST', 'localhost'),
        'port': os.getenv('DB_PORT', '5432')
    }
    
    try:
        matcher = MasterProductMatcher(db_config, use_ai=False)
        logger.info("Matcher initialized")
        
        conn = psycopg2.connect(**db_config)
        cur = conn.cursor()
        
        # Get a product
        cur.execute("SELECT id, name, ean FROM products WHERE ean IS NOT NULL LIMIT 1")
        row = cur.fetchone()
        
        if not row:
            logger.warning("No products with EAN found!")
            return
            
        pid, name, ean = row
        logger.info(f"Testing match for Product #{pid}: {name} (EAN: {ean})")
        
        # Run match
        match = matcher.match_product(pid)
        
        logger.info(f"Match Result: {match}")
        
        if match.master_product_id:
             logger.info(f"SUCCESS: Linked to Master #{match.master_product_id}")
             
             # Verify link table
             cur.execute("SELECT * FROM product_master_links WHERE product_id = %s", (pid,))
             link = cur.fetchone()
             logger.info(f"Link record: {link}")
        else:
             logger.info("FAILURE: No match found/created")

    except Exception as e:
        logger.error(f"Test failed: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    test_matcher()
