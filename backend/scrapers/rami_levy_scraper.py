
"""
Rami Levy Scraper
Inherits from PublishedPricesScraper
Login: RamiLevi / (empty password)
"""
import logging
from .published_prices_scraper import PublishedPricesScraper

logger = logging.getLogger(__name__)

class RamiLevyScraper(PublishedPricesScraper):
    """
    Rami Levy Shiuk Hashikma
    Uses PublishedPrices platform
    """
    
    def __init__(self, username=None, password=None):
        super().__init__(
            chain_name='Rami Levy',
            chain_slug='rami_levy',
            chain_name_he='רמי לוי',
            chain_id='7290058140886',
            platform_user=username or 'RamiLevi',
            platform_pass=password or '',
            base_domain='url.publishedprices.co.il'
        )
        logger.info("Initialized Rami Levy scraper")

if __name__ == "__main__":
    scraper = RamiLevyScraper()
    files = scraper.fetch_file_list(limit=5)
    print(f"Found {len(files)} files")
