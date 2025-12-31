import scrapy
from scrapy.spiders import Spider
from scrapy.http import Request
import json
import re
from datetime import datetime
from ..items import ScrapedProductItem
from scrapy.utils.sitemap import Sitemap
from scrapy.utils.gz import gunzip

class GenericPriceSpider(Spider):
    name = 'price_hunter'
    
    def __init__(self, domain=None, sitemap_url=None, source_id=None, use_playwright="false", *args, **kwargs):
        """
        Initialize the spider with target config.
        Args:
            domain: Target domain (e.g. example.com)
            sitemap_url: Full URL to sitemap.xml
            source_id: UUID from DB tracking table
            use_playwright: String "true"/"false" (passed from CLI)
        """
        super(GenericPriceSpider, self).__init__(*args, **kwargs)
        
        if not domain or not sitemap_url:
            raise ValueError("You must provide 'domain' and 'sitemap_url' arguments.")
            
        self.allowed_domains = [domain]
        self.sitemap_url = sitemap_url
        self.source_domain = domain
        self.source_id = source_id
        # Parse boolean string argument
        self.use_playwright = str(use_playwright).lower() in ['true', '1', 'yes', 'on']
        self.use_ai = kwargs.get('use_ai', 'false').lower() in ['true', '1', 'yes', 'on']

    def start_requests(self):
        self.logger.info(f"🚀 Starting scan for {self.source_domain} (Playwright: {self.use_playwright})")
        yield Request(self.sitemap_url, callback=self.parse_sitemap)

    def parse_sitemap(self, response):
        """
        Manually parse sitemap XML to have full control over Request creation.
        Handles both XML and GZIP sitemaps.
        """
        body = response.body
        if response.url.endswith('.gz'):
            body = gunzip(body)

        s = Sitemap(body)
        
        # Define product URL patterns (simple heuristic for now)
        product_patterns = [r'/product/', r'/p/', r'/item/', r'/shop/', r'/buy/', r'/catalog/']
        
        for entry in s:
            url = entry['loc']
            
            # Check if URL looks like a product (or if it's a nested sitemap)
            # Note: Sitemap iterator usually handles nested sitemaps automatically? 
            # Scrapy's Sitemap utils is a simple parser. It yields dicts.
            # If 'loc' ends in .xml, it's a nested sitemap.
            
            if url.endswith('.xml') or url.endswith('.xml.gz'):
                yield Request(url, callback=self.parse_sitemap)
                continue

            # Filter for product pages
            is_product = any(opt in url for opt in product_patterns)
            
            if is_product:
                meta = {
                    'source_id': self.source_id,
                    'playwright': self.use_playwright,
                    'playwright_include_page': True if self.use_playwright else False
                }
                
                yield Request(url, callback=self.parse_product, meta=meta)

    async def parse_product(self, response):
        """
        Extract product data. Handles both standard Response and Playwright response.
        """
        # If using playwright, we might need to close the page context if we opened it?
        # Scrapy-playwright handles page closing automatically usually.
        
        self.logger.info(f"📦 Scanning product: {response.url}")
        
        product_name = None
        price = None
        currency = None
        barcode = None
        
        # --- Strategy 1: Structured Data (JSON-LD) ---
        # Priorities: Product > Offer
        ld_json_scripts = response.xpath('//script[@type="application/ld+json"]/text()').getall()
        for script in ld_json_scripts:
            try:
                data = json.loads(script)
                if isinstance(data, dict):
                    data = [data]
                
                for item in data:
                    item_type = item.get('@type')
                    if isinstance(item_type, list):
                        item_type = item_type[0] # Sometimes it's ["Product", "Thing"]

                    if item_type == 'Product':
                        product_name = product_name or item.get('name')
                        barcode = barcode or item.get('gtin') or item.get('gtin13') or item.get('ean') or item.get('sku')
                        
                        offers = item.get('offers')
                        if isinstance(offers, dict):
                            offers = [offers]
                        
                        if offers and isinstance(offers, list):
                            first_offer = offers[0]
                            price = price or first_offer.get('price')
                            currency = currency or first_offer.get('priceCurrency')
                    
                    elif item_type == 'Offer':
                        price = price or item.get('price')
                        currency = currency or item.get('priceCurrency')
                        
            except json.JSONDecodeError:
                continue
                
        # --- Strategy 2: Meta Tags ---
        if not price:
            price = response.css('meta[property="product:price:amount"]::attr(content)').get() or \
                    response.css('meta[property="og:price:amount"]::attr(content)').get()
            
        if not currency:
            currency = response.css('meta[property="product:price:currency"]::attr(content)').get() or \
                       response.css('meta[property="og:price:currency"]::attr(content)').get()
                       
        if not product_name:
            product_name = response.css('meta[property="og:title"]::attr(content)').get()

        # --- Strategy 3: Heuristic CSS Selectors ---
        if not price:
            # Common price classes
            price_candidates = response.css('.price::text, .current-price::text, .product-price::text, .amount::text, [itemprop="price"]::text, .special-price::text').getall()
            for cand in price_candidates:
                cleaned = self.clean_price(cand)
                if cleaned:
                    price = cleaned
                    break
        
        if not product_name:
            product_name = response.css('h1::text').get()

        # --- Strategy 4: AI Fallback (Optional) ---
        if self.use_ai and (not product_name or not clean_price_val):
            self.logger.warning(f"🤖 Triggering AI Fallback for {response.url}")
            from ..ai_extractor import extract_product_with_ai
            
            # Use raw HTML text
            ai_data = extract_product_with_ai(response.text, response.url)
            
            if ai_data:
                product_name = product_name or ai_data.get('name')
                price = price or ai_data.get('price')
                currency = currency or ai_data.get('currency')
                barcode = barcode or ai_data.get('barcode')
                self.logger.info(f"✨ AI Recovered data: {product_name} - {price}")

        # --- Final Validation & Yield ---
        clean_price_val = self.clean_price(price)
        
        if product_name and clean_price_val:
            item = ScrapedProductItem()
            item['url'] = response.url
            item['name'] = product_name.strip() if product_name else None
            item['price'] = clean_price_val
            item['currency'] = currency or 'ILS' 
            item['scraped_at'] = datetime.now()
            item['source_domain'] = self.source_domain
            item['source_id'] = self.source_id
            item['barcode'] = barcode
            item['image_url'] = response.css('meta[property="og:image"]::attr(content)').get()
            
            yield item
        else:
             self.logger.debug(f"❌ Missing essential data for {response.url} (Name: {product_name}, Price: {price})")

    def clean_price(self, price_str):
        """
        Cleans price string to float.
        Handles '1,200.50 ₪', '$12.99', '50.00 EUR' etc.
        """
        if not price_str:
            return None
        
        if isinstance(price_str, (int, float)):
             return float(price_str)

        # Remove currency symbols and non-numeric chars except dot and comma
        # Sometimes 1.200,00 (EU) vs 1,200.00 (US)
        clean = re.sub(r'[^\d.,]', '', str(price_str))
        
        # Simple heuristic: if ',' is last separator, it's decimal (EU style usually, but ILS is often . for decimal)
        # Assuming ILS/USD standard (comma for thousands, dot for decimal)
        clean = clean.replace(',', '') 
        
        try:
            return float(clean)
        except ValueError:
            return None

