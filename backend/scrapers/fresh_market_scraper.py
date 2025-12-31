"""
Fresh Market Scraper
Inherits from PublishedPricesScraper
Fresh Market uses the publishedprices.co.il platform
Login: freshmarket / (empty password)
"""
import logging

try:
    from .published_prices_scraper import PublishedPricesScraper
except ImportError:
    from published_prices_scraper import PublishedPricesScraper

logger = logging.getLogger(__name__)


class FreshMarketScraper(PublishedPricesScraper):
    """
    Fresh Market - Israeli fresh produce supermarket
    Uses PublishedPrices (Cerberus) platform
    """
    
    def __init__(self, username=None, password=None):
        # Initialize parent with Fresh Market details
        super().__init__(
            chain_name='Fresh Market',
            chain_slug='fresh_market',
            chain_name_he='פרש מרקט',
            chain_id='7290876100000',
            platform_user=username or 'freshmarket',
            platform_pass=password or '',
            base_domain='url.publishedprices.co.il'
        )
        
        logger.info("Initialized Fresh Market scraper (using PublishedPrices platform)")


if __name__ == "__main__":
   # Test
    scraper = FreshMarketScraper(username='freshmarket', password='')
    
    # Login
    scraper.login()
    
    # Test file list
    files = scraper.fetch_file_list(limit=5)
    print(f"\nFound {len(files)} files:")
    for f in files:
        print(f"  - {f.filename}")
    
    # Full import
    result = scraper.run_full_import(limit=2)
    print(f"\nResult: {result}")
