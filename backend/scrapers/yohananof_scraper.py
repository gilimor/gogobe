
"""
Yohananof Scraper
Inherits from PublishedPricesScraper
"""
import logging

try:
    from .published_prices_scraper import PublishedPricesScraper
except ImportError:
    from published_prices_scraper import PublishedPricesScraper

logger = logging.getLogger(__name__)

class YohananofScraper(PublishedPricesScraper):
    """
    Yohananof Chain
    """
    
    def __init__(self, username=None, password=None):
        super().__init__(
            chain_name='Yohananof',
            chain_slug='yohananof',
            chain_name_he='יוחננוף',
            chain_id='7290803800003',
            platform_user='Yohananof', # Prediction
            platform_pass=''
        )
        logger.info("Initialized Yohananof scraper")
