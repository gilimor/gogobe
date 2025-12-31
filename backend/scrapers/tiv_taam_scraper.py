
"""
Tiv Taam Scraper
Inherits from PublishedPricesScraper
"""
import logging

try:
    from .published_prices_scraper import PublishedPricesScraper
except ImportError:
    from published_prices_scraper import PublishedPricesScraper

logger = logging.getLogger(__name__)

class TivTaamScraper(PublishedPricesScraper):
    """
    Tiv Taam Supermarket Chain
    """
    
    def __init__(self, username=None, password=None):
        super().__init__(
            chain_name='Tiv Taam',
            chain_slug='tiv_taam',
            chain_name_he='טיב טעם',
            chain_id='7290873255550',
            platform_user='TivTaam', # Hardcoded as per common config
            platform_pass=''
        )
        logger.info("Initialized Tiv Taam scraper")
