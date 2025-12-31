
import sys
import os
import logging

# Add backend to path
sys.path.append('/app/backend')

# Configure logging
logging.basicConfig(level=logging.INFO)

from scrapers.fresh_market_scraper import FreshMarketScraper

def test_login():
    print("Testing Fresh Market Login...")
    try:
        scraper = FreshMarketScraper(username='freshmarket', password='')
        if scraper.login():
            print("✅ Login SUCCESS!")
        else:
            print("❌ Login FAILED!")
    except Exception as e:
        print(f"❌ Login CRASHED: {e}")

if __name__ == "__main__":
    test_login()
