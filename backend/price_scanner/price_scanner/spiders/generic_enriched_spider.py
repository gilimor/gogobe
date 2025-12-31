import json
import scrapy
import hashlib
import os
import re
import psycopg2
from scrapy_playwright.page import PageMethod

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
        },
        # Ensure we output logs
        'LOG_LEVEL': 'INFO'
    }

    def start_requests(self):
        city = getattr(self, 'city', 'Rehovot')
        service = getattr(self, 'service', None)
        
        # Try service-specific file first
        if service:
            input_file = f"/app/backend/enriched_{service}_{city}.json"
        else:
            # Fallback for backward compatibility
            input_file = f"/app/backend/enriched_{city}.json"

        # Check if file exists via os.path? No, we are in Docker.
        # Just try open.
        
        try:
            with open(input_file, 'r', encoding='utf-8') as f:
                restaurants = json.load(f)
        except FileNotFoundError:
             # Try alternate name if service was provided but failed
             if service:
                 fallback = f"/app/backend/enriched_{city}.json"
                 try:
                     with open(fallback, 'r', encoding='utf-8') as f:
                        restaurants = json.load(f)
                        input_file = fallback
                 except:
                     self.logger.error(f"Could not read {input_file} or {fallback}")
                     return
             else:
                self.logger.error(f"Could not read {input_file}")
                return
        except Exception as e:
            self.logger.error(f"Error reading {input_file}: {e}")
            return

        for r in restaurants:
            name = r['name']
            url = r.get('website')
            if not url or any(x in url for x in ['facebook', 'instagram', 'tripadvisor', 'linkedin']):
                continue
            
            yield scrapy.Request(
                url,
                meta={
                    'playwright': True,
                    'playwright_include_page': True,
                    'restaurant_name': name,
                    'city': city
                },
                callback=self.parse,
                errback=self.errback
            )

    async def parse(self, response):
        page = response.meta['playwright_page']
        name = response.meta['restaurant_name']
        city = response.meta['city']
        
        try:
            # Wait a bit for JS (optional, as domcontentloaded is default logic or we can wait)
            # Scrapy-Playwright handles page load.
            text = await page.evaluate("document.body.innerText")
        except Exception as e:
            self.logger.error(f"Page Error {name}: {e}")
            await page.close()
            return

        await page.close()
        
        items = self.parse_text(text, name)
        
        if items:
            self.ingest_items(items, name, city)
            self.logger.info(f"Ingested {len(items)} items for {name}")
        else:
            self.logger.warning(f"No items found for {name}")

    def errback(self, failure):
        self.logger.error(f"Request Loop Error: {repr(failure)}")

    # Patterns for "Starting From"
    START_PATTERNS = re.compile(r'(החל מ|מ-|from|starting at|starts from|ab)\s*$', re.IGNORECASE)

    def parse_text(self, text, restaurant_name):
        items = []
        if not text: return []
        lines = text.split('\n')
        # Regex: Symbol? Number? Symbol?
        # Must start with a digit. Matches 1,000 or 1000.00
        price_re = re.compile(r'([₪$€£฿])?\s*(\d[\d,]*\.?\d{0,2})\s*([₪$€£฿])?')
        
        for line in lines:
            line = line.strip()
            if len(line) < 5 or len(line) > 200: continue
            
            matches = price_re.findall(line)
            if not matches: continue
            
            symbol_pre, amount, symbol_suff = matches[-1]
            try:
                clean_amount = amount.replace(',', '')
                price = float(clean_amount)
            except: continue
            if price == 0 or price > 50000: continue
            
            # Name extraction
            price_str = amount
            parts = line.split(price_str)
            name_candidate = parts[0].strip()
            
            # Check for "Starting From" prefix in the name part (immediately before price)
            is_starting_price = False
            # Check if name_candidate ends with a start pattern
            # e.g. "Dental cleaning from " -> "Dental cleaning" + "from " match
            
            # We check the specific text immediately preceding the price
            # But regex already split it. 
            # Logic: Split regex captured `from`? No, price_re only captures symbol/digits.
            # So `name_candidate` contains the prefix.
            
            start_match = self.START_PATTERNS.search(name_candidate)
            if start_match:
                is_starting_price = True
                # Remove the pattern from name
                name_candidate = name_candidate[:start_match.start()].strip()
            
            name_candidate = re.sub(r'[₪$€£฿\-\.]', '', name_candidate).strip()
            
            # --- HEURISTICS BLOCKING (Garbage Filter) ---
            # 1. Block Pure Numbers (Phone numbers, IDs)
            if re.match(r'^\d+$', name_candidate): continue
            
            # 2. Block Dates (DD.MM.YYYY or similar)
            if re.search(r'\d{2}[\./]\d{2}[\./]\d{4}', name_candidate): continue
            
            # 3. Block Addresses / Locations
            bad_words = ['TelAviv', 'Rehovot', 'Street', 'St.', 'Rd.', 'Avenue', 'Ave.', 'Israel', 'Phone', 'Tel:', 'Mobile:', 'Fax:']
            if any(bw.lower() in name_candidate.lower() for bw in bad_words): continue
            
            # 4. Length Constraints
            if len(name_candidate) < 3 or len(name_candidate) > 100: continue
            # --------------------------------------------
            
            currency = 'ILS'
            if symbol_pre: currency = CURRENCY_SYMBOLS.get(symbol_pre, currency)
            if symbol_suff: currency = CURRENCY_SYMBOLS.get(symbol_suff, currency)
            
            sku_hash = hashlib.md5(f"{restaurant_name}_{name_candidate}".encode('utf-8')).hexdigest()[:12]
            sku = f"GEN_{sku_hash}"
            
            items.append({
                "name": name_candidate,
                "description": "",
                "price": price,
                "currency": currency,
                "sku": sku,
                "menu_section": "General",
                "is_starting_price": is_starting_price
            })
        return items

    def ingest_items(self, items, name, city):
        conn = psycopg2.connect(
            dbname=os.getenv("DB_NAME", "gogobe"),
            user=os.getenv("DB_USER", "postgres"),
            password=os.getenv("DB_PASSWORD", "password"),
            host=os.getenv("DB_HOST", "db"),
            port=os.getenv("DB_PORT", "5432")
        )
        cur = conn.cursor()
        
        try:
            # DB Logic...
            cur.execute("SELECT id FROM verticals WHERE slug = 'restaurants'")
            vid = cur.fetchone()
            vertical_id = vid[0] if vid else None 
            
            # Use 'Generic Web Scraper'
            cur.execute("INSERT INTO suppliers (name) VALUES ('Generic Web Scraper') ON CONFLICT (name) DO UPDATE SET name=EXCLUDED.name RETURNING id")
            supplier_id = cur.fetchone()[0]
            
            slug = hashlib.md5(name.encode()).hexdigest()[:10]
            cur.execute("INSERT INTO chains (name, slug, is_active) VALUES (%s, %s, true) ON CONFLICT (name) DO UPDATE SET is_active=true RETURNING id", (name, slug))
            chain_id = cur.fetchone()[0]
            
            store_name = f"{name} - {city}"
            cur.execute("INSERT INTO stores (chain_id, name, city, is_active, store_id) VALUES (%s, %s, %s, true, %s) ON CONFLICT (chain_id, store_id) DO UPDATE SET is_active=true RETURNING id", 
                        (chain_id, store_name, city, f"REST_{slug}_{city}"))
            store_id = cur.fetchone()[0]
            
            for item in items:
                attr = json.dumps({"menu_section": item['menu_section'], "detected_currency": item['detected'] if 'detected' in item else item['currency']})
                cur.execute("SELECT id FROM products WHERE sku = %s", (item['sku'],))
                pid = cur.fetchone()
                if not pid:
                     cur.execute("INSERT INTO products (name, description, vertical_id, sku, attributes, is_active, is_sandbox) VALUES (%s, %s, %s, %s, %s, true, true) RETURNING id",
                                (item['name'], item['description'], vertical_id, item['sku'], attr))
                     product_id = cur.fetchone()[0]
                else:
                    product_id = pid[0]
                
                cur.execute("""
                    INSERT INTO prices (product_id, store_id, supplier_id, price, currency, is_available, scraped_at, first_scraped_at, is_starting_price, is_sandbox)
                    VALUES (%s, %s, %s, %s, %s, true, NOW(), NOW(), %s, true)
                    ON CONFLICT (product_id, supplier_id, store_id) DO UPDATE SET price = EXCLUDED.price, is_starting_price = EXCLUDED.is_starting_price
                """, (product_id, store_id, supplier_id, item['price'], item['currency'], item['is_starting_price']))

            
            conn.commit()
        except Exception as e:
            self.logger.error(f"DB Error: {e}")
            conn.rollback()
        finally:
            cur.close()
            conn.close()
