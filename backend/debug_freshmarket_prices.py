
import requests
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

CHAIN_ID = "7290876100000" # Fresh Market
BASE_URL = "https://url.publishedprices.co.il/file/d"
DATE = "20251226" # Today
STORES = ["006", "014", "002"] # Known stores

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
        else:
            # logger.info(f"Failed ({r.status_code}): {filename}")
            pass
    except Exception as e:
        logger.error(f"Error: {e}")
    return False

def run():
    logger.info("Starting FreshMarket Price File Check...")
    
    # Try different hours
    hours = ["0600", "0900", "1200", "0000"]
    
    for store in STORES:
        for h in hours:
            # Format: PriceChainID-Store-DateHour.gz
            fname = f"Price{CHAIN_ID}-{store}-{DATE}{h}.gz"
            if test_url(fname): return

if __name__ == "__main__":
    run()
