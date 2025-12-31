
import requests
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

BASE_URL = "https://url.publishedprices.co.il/file/d"

def run():
    filename = "StoresFAKE-202512260600.gz"
    url = f"{BASE_URL}/{filename}"
    try:
        r = requests.head(url, verify=False, timeout=2)
        logger.info(f"File: {filename} -> Status: {r.status_code}")
        if r.status_code == 302:
             logger.info("Redirect location: " + r.headers.get('Location', 'Unknown'))
    except Exception as e:
        logger.error(f"Error: {e}")

if __name__ == "__main__":
    run()
