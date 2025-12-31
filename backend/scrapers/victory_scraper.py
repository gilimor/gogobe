
"""
Victory Scraper
Inherits from PublishedPricesScraper
"""
import logging

try:
    from .published_prices_scraper import PublishedPricesScraper
except ImportError:
    from published_prices_scraper import PublishedPricesScraper

logger = logging.getLogger(__name__)

class VictoryScraper(PublishedPricesScraper):
    """
    Victory Supermarket Chain
    """
    
    def __init__(self, username=None, password=None):
        super().__init__(
            chain_name='Victory',
            chain_slug='victory',
            chain_name_he='ויקטורי',
            chain_id='7290696200003',
            platform_user='victory', # Case sensitivity check
            platform_pass=''
        )
        logger.info("Initialized Victory scraper")
