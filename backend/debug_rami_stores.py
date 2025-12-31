
import requests
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

CHAIN_ID = "7290058140886" # Rami Levy
BASE_URL = "https://url.publishedprices.co.il/file/d"
DATE = "20251226" # Today

def test_url(filename):
    url = f"{BASE_URL}/{filename}"
    try:
        r = requests.head(url, verify=False, timeout=2)
        if r.status_code == 200:
            logger.info(f"✅ FOUND: {filename}")
            return True
        elif r.status_code == 302:
            logger.info(f"redirect (login needed?): {filename}")
            # If it redirects, it means file exists but we are not logged in.
            # If it didn't exist, it usually returns 404 or 500.
            # Actually on this server, 302 to Login often means file exists but protected.
            # Let's check where it redirects.
            return True
        else:
            # logger.info(f"Failed ({r.status_code}): {filename}")
            pass
    except Exception as e:
        logger.error(f"Error: {e}")
    return False

def run():
    prefixes = ["Stores", "Store", "STORE", "STORES", "s", "S"]
    
    # Try different hours
    hours = ["0600", "0900", "1200", "0000", "2200", "2300"]
    
    logger.info("Starting Brute Force Check for Rami Levy Stores...")
    
    for prefix in prefixes:
        for h in hours:
            # Format: PrefixChainID-DateHour.gz
            fname1 = f"{prefix}{CHAIN_ID}-{DATE}{h}.gz"
            if test_url(fname1): return
            
            # Format: Prefix-ChainID-DateHour.gz
            fname2 = f"{prefix}-{CHAIN_ID}-{DATE}{h}.gz"
            if test_url(fname2): return
            
if __name__ == "__main__":
    run()
