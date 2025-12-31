
import requests
import logging
from datetime import datetime, timedelta

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

CHAIN_ID = "7290876100000" # Fresh Market
BASE_URL = "https://url.publishedprices.co.il/file/d"

def test_url(filename):
    url = f"{BASE_URL}/{filename}"
    try:
        r = requests.head(url, verify=False, timeout=2)
        if r.status_code == 200:
            logger.info(f"✅ FOUND: {filename}")
            return True
        elif r.status_code == 302:
            logger.info(f"redirect (login needed?): {filename}")
            return True
    except: pass
    return False

def run():
    logger.info("Starting FreshMarket STORES File Check...")
    
    # Check last 3 days
    for d in range(3):
        date_str = (datetime.now() - timedelta(days=d)).strftime("%Y%m%d")
        
        # Hours
        hours = ["0600", "0900", "0000", "2300"]
        
        for h in hours:
            # Variations
            candidates = [
                f"Stores{CHAIN_ID}-{date_str}{h}.gz",
                f"Store{CHAIN_ID}-{date_str}{h}.gz",
                f"Stores-{CHAIN_ID}-{date_str}{h}.gz",
                f"Store-{CHAIN_ID}-{date_str}{h}.gz",
                f"Stores{CHAIN_ID}{date_str}{h}.gz",
            ]
            
            for fname in candidates:
                if test_url(fname): return

if __name__ == "__main__":
    run()
