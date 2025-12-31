
import logging
from pathlib import Path
import sys
# Add /app to path
sys.path.append(str(Path(__file__).parent.parent))
sys.path.append(str(Path(__file__).parent)) # backend

from scrapers.fresh_market_scraper import FreshMarketScraper

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def run():
    scraper = FreshMarketScraper()
    scraper.login()
    
    # Get /file page
    resp = scraper.session.get("https://url.publishedprices.co.il/file", verify=False)
    logger.info(f"Page Status: {resp.status_code}")
    
    # Save HTML to file
    with open("freshmarket_file_page.html", "w", encoding="utf-8") as f:
        f.write(resp.text)
        
    logger.info("Saved freshmarket_file_page.html")
    
    # Also try to print first 500 chars
    logger.info(f"Content: {resp.text[:500]}")

if __name__ == "__main__":
    run()
