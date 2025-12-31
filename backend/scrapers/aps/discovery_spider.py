
import scrapy
from scrapy_playwright.page import PageMethod
from urllib.parse import urlparse
import logging
import psycopg2
from datetime import datetime
import os

logger = logging.getLogger(__name__)

class DiscoverySpider(scrapy.Spider):
    name = "aps_discovery"
    
    custom_settings = {
        'DOWNLOAD_HANDLERS': {
            "http": "scrapy_playwright.handler.ScrapyPlaywrightDownloadHandler",
            "https": "scrapy_playwright.handler.ScrapyPlaywrightDownloadHandler",
        },
        'TWISTED_REACTOR': "twisted.internet.asyncioreactor.AsyncioSelectorReactor",
        'PLAYWRIGHT_LAUNCH_OPTIONS': {
            "headless": True,
            "timeout": 60000,
            "args": ["--no-sandbox"]
        },
        'LOG_LEVEL': 'INFO',
        'USER_AGENT': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    }

    def __init__(self, *args, **kwargs):
        self.start_url = kwargs.pop('start_url', None)
        super(DiscoverySpider, self).__init__(*args, **kwargs)
        
        self.start_urls = [self.start_url] if self.start_url else []
        if self.start_url:
            self.domain = urlparse(self.start_url).netloc
            self.allowed_domains = [self.domain]
        else:
            self.domain = None
            self.allowed_domains = []
        
    def get_db_connection(self):
        try:
            return psycopg2.connect(
                dbname='gogobe',
                user='postgres',
                password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
                host='db'
            )
        except Exception as e:
            logger.error(f"DB Connection Failed: {e}")
            return None

    def start_requests(self):
        if not self.start_urls:
            print("DEBUG: No start_url provided")
            return

        for url in self.start_urls:
            print(f"DEBUG: Yielding request for {url}")
            yield scrapy.Request(
                url,
                meta={
                    "playwright": True,
                    "playwright_page_methods": [
                        PageMethod("wait_for_load_state", "domcontentloaded"),
                    ],
                },
                callback=self.parse,
                errback=self.errback_http
            )

    def parse(self, response):
        try:
            print(f"DEBUG: Parsing {response.url}")
            logger.info(f"Scanning: {response.url}")
            
            # 1. Identify if this is a Product Page
            is_product = self.is_product_page(response)
            
            # 2. Extract Links
            links = response.css('a::attr(href)').getall()
            internal_links = set()
            
            for link in links:
                url = response.urljoin(link)
                parsed = urlparse(url)
                if parsed.netloc == self.domain:
                    internal_links.add(url)

            # 3. Save Stats to DB
            self.save_discovery_stats(is_product, len(internal_links))
        except Exception as e:
            logger.error(f"Parse Error: {e}")
            print(f"DEBUG: Parse Error: {e}")
            import traceback
            traceback.print_exc()

    def is_product_page(self, response):
        text = response.text.lower()
        has_cart = 'cart' in text or 'סל קניות' in text or 'הוסף לסל' in text
        has_price = '₪' in text or 'price' in text
        has_schema = 'schema.org/product' in text
        return (has_cart and has_price) or has_schema

    def save_discovery_stats(self, is_product, link_count):
        conn = self.get_db_connection()
        if not conn:
            logger.error("No DB Connection for stats save")
            return
            
        try:
            with conn.cursor() as cur:
                # Upsert Logic
                cur.execute("""
                    INSERT INTO source_discovery_tracking (domain, total_urls_found, product_urls_found, status, last_scanned_at)
                    VALUES (%s, %s, %s, 'scanning', NOW())
                    ON CONFLICT (domain) DO UPDATE 
                    SET 
                        total_urls_found = source_discovery_tracking.total_urls_found + EXCLUDED.total_urls_found,
                        product_urls_found = source_discovery_tracking.product_urls_found + EXCLUDED.product_urls_found,
                        last_scanned_at = NOW(),
                        status = 'scanning'
                """, (self.domain, link_count, 1 if is_product else 0))
                
                conn.commit()
                logger.info(f"DB Saved: {self.domain} (+{link_count} links)")
        except Exception as e:
            logger.error(f"DB Update Failed: {e}")
            conn.rollback()
        finally:
            conn.close()

    def closed(self, reason):
        pass

    def errback_http(self, failure):
        print(f"DEBUG: Request Failed: {repr(failure)}")
        logger.error(f"Request Failed: {repr(failure)}")
