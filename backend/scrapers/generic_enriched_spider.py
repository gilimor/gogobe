import json
import scrapy
import hashlib
import os
import re
from scrapy_playwright.page import PageMethod
from backend.models import get_db_connection

# Currency Map
CURRENCY_SYMBOLS = {
    '₪': 'ILS', 'NIS': 'ILS',
    '$': 'USD', 'USD': 'USD',
    '€': 'EUR', 'EUR': 'EUR', 'GBP': 'GBP', 'THB': 'THB'
}

class GenericEnrichedSpider(scrapy.Spider):
    name = "generic_enriched"
    
    custom_settings = {
        'DOWNLOAD_HANDLERS': {
            "http": "scrapy_playwright.handler.ScrapyPlaywrightDownloadHandler",
            "https": "scrapy_playwright.handler.ScrapyPlaywrightDownloadHandler",
        },
        'PLAYWRIGHT_LAUNCH_OPTIONS': {
            "headless": True,
            "args": ["--no-sandbox", "--disable-setuid-sandbox"]
        }
    }

    def start_requests(self):
        city = getattr(self, 'city', 'Rehovot')
        input_file = f"/app/backend/enriched_{city}.json"
        
        try:
            with open(input_file, 'r', encoding='utf-8') as f:
                restaurants = json.load(f)
        except Exception as e:
            self.logger.error(f"Could not read {input_file}: {e}")
            return

        for r in restaurants:
            name = r['name']
            url = r.get('website')
            if not url or any(x in url for x in ['facebook', 'instagram', 'tripadvisor']):
                continue
            
            yield scrapy.Request(
                url,
                meta={
                    'playwright': True,
                    'playwright_include_page': True,
                    'restaurant_name': name,
                    'city': city
                },
                callback=self.parse
            )

    async def parse(self, response):
        page = response.meta['playwright_page']
        name = response.meta['restaurant_name']
        city = response.meta['city']
        
        # Get visible text
        # We can extract text directly from body
        text = await page.evaluate("document.body.innerText")
        await page.close()
        
        # Parse Text
        items = self.parse_text(text, name)
        
        if items:
            self.ingest_items(items, name, city)
        else:
            self.logger.warning(f"No items found for {name}")

    def parse_text(self, text, restaurant_name):
        items = []
        lines = text.split('\n')
        # Regex: Digit(1-4).Decimal(opt)
        price_re = re.compile(r'([₪$€£฿])?\s*(\d{1,4}(?:\.\d{2})?)\s*([₪$€£฿])?')
        
        for line in lines:
            line = line.strip()
            if len(line) < 5 or len(line) > 200: continue
            
            matches = price_re.findall(line)
            if not matches: continue
            
            # Simple assumption: Last match is price
            symbol_pre, amount, symbol_suff = matches[-1]
            try:
                price = float(amount)
            except: continue
            if price == 0 or price > 2000: continue
            
            # Name is text before price
            price_str = amount
            parts = line.split(price_str)
            name_candidate = parts[0].strip()
            
            # Clean
            name_candidate = re.sub(r'[₪$€£฿\-\.]', '', name_candidate).strip()
            if len(name_candidate) < 3: continue
            
            # Currency
            currency = 'ILS' # Default
            if symbol_pre: currency = CURRENCY_SYMBOLS.get(symbol_pre, currency)
            if symbol_suff: currency = CURRENCY_SYMBOLS.get(symbol_suff, currency)
            
            # SKU
            sku_hash = hashlib.md5(f"{restaurant_name}_{name_candidate}".encode('utf-8')).hexdigest()[:12]
            sku = f"GEN_{sku_hash}"
            
            items.append({
                "name": name_candidate,
                "description": "",
                "price": price,
                "currency": currency,
                "sku": sku,
                "menu_section": "General"
            })
        return items

    def ingest_items(self, items, name, city):
        # We need a quick DB connection
        # Since Scrapy is async, we should use asyncpg or just sync psycopg2 in a thread?
        # For simplicity, sync psycopg2 is fine if volume is low.
        # Or better: Print/Log items and let a pipeline handle it.
        # But I'll do direct ingestion here to match previous script logic.
        
        conn = psycopg2.connect(
            dbname=os.getenv("DB_NAME", "gogobe"),
            user=os.getenv("DB_USER", "postgres"),
            password=os.getenv("DB_PASSWORD", "password"),
            host=os.getenv("DB_HOST", "db"),
            port=os.getenv("DB_PORT", "5432")
        )
        cur = conn.cursor()
        
        try:
            # Vertical
            cur.execute("SELECT id FROM verticals WHERE slug = 'restaurants'")
            vid = cur.fetchone()
            vertical_id = vid[0] if vid else None # Should exist
            
            # Supplier
            cur.execute("INSERT INTO suppliers (name) VALUES ('Generic Web Scraper') ON CONFLICT (name) DO UPDATE SET name=EXCLUDED.name RETURNING id")
            supplier_id = cur.fetchone()[0]
            
            # Chain/Store
            slug = hashlib.md5(name.encode()).hexdigest()[:10]
            cur.execute("INSERT INTO chains (name, slug, is_active) VALUES (%s, %s, true) ON CONFLICT (name) DO UPDATE SET is_active=true RETURNING id", (name, slug))
            chain_id = cur.fetchone()[0]
            
            store_name = f"{name} - {city}"
            cur.execute("INSERT INTO stores (chain_id, name, city, is_active, store_id) VALUES (%s, %s, %s, true, %s) ON CONFLICT (chain_id, store_id) DO UPDATE SET is_active=true RETURNING id", 
                        (chain_id, store_name, city, f"REST_{slug}_{city}"))
            store_id = cur.fetchone()[0]
            
            for item in items:
                attr = json.dumps({"menu_section": item['menu_section'], "detected_currency": item['currency']})
                cur.execute("SELECT id FROM products WHERE sku = %s", (item['sku'],))
                pid = cur.fetchone()
                if not pid:
                     cur.execute("INSERT INTO products (name, description, vertical_id, sku, attributes, is_active) VALUES (%s, %s, %s, %s, %s, true) RETURNING id",
                                (item['name'], item['description'], vertical_id, item['sku'], attr))
                     product_id = cur.fetchone()[0]
                else:
                    product_id = pid[0]
                
                cur.execute("""
                    INSERT INTO prices (product_id, store_id, supplier_id, price, currency, is_available, scraped_at, first_scraped_at)
                    VALUES (%s, %s, %s, %s, %s, true, NOW(), NOW())
                    ON CONFLICT (product_id, supplier_id, store_id) DO UPDATE SET price = EXCLUDED.price
                """, (product_id, store_id, supplier_id, item['price'], item['currency']))
            
            conn.commit()
            self.logger.info(f"Ingested {len(items)} items for {name}")
            
        except Exception as e:
            self.logger.error(f"DB Error: {e}")
            conn.rollback()
        finally:
            cur.close()
            conn.close()
