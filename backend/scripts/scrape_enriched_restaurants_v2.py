import asyncio
import json
import hashlib
import sys
import os
import re
from playwright.async_api import async_playwright
import psycopg2

# DB Config
DB_NAME = os.getenv("DB_NAME", "gogobe")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD", "password")
DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = os.getenv("DB_PORT", "5432")

# Currency Map
CURRENCY_SYMBOLS = {
    '₪': 'ILS', 'NIS': 'ILS',
    '$': 'USD', 'USD': 'USD',
    '€': 'EUR', 'EUR': 'EUR',
    '£': 'GBP', 'GBP': 'GBP',
    '฿': 'THB', 'THB': 'THB'
}

def get_db_connection():
    return psycopg2.connect(dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD, host=DB_HOST, port=DB_PORT)

class GenericMenuParser:
    def __init__(self, default_currency='ILS'):
        self.default_currency = default_currency
    
    def parse_text(self, text, restaurant_name):
        """
        Parses raw text from the page to find menu items.
        Strategy: Look for lines with <Text> ... <Price> or <Text> <Price>
        """
        items = []
        lines = text.split('\n')
        
        # Regex for price: (Symbol)? Number (Symbol)?
        # e.g. ₪50, 50₪, 50, 50.00
        # We need to be careful not to capture years or phone numbers.
        # Strict price: 1-4 digits, optional decimal. 
        # Context: "Schnitzel ... 50"
        
        price_re = re.compile(r'([₪$€£฿])?\s*(\d{1,4}(?:\.\d{2})?)\s*([₪$€£฿])?')
        
        for line in lines:
            line = line.strip()
            if len(line) < 5 or len(line) > 200: continue
            
            # Find price
            matches = price_re.findall(line)
            if not matches: continue
            
            # Take the last number as probable price (e.g. "Burger 200g 50")
            # match is tuple (prefix, number, suffix)
            m = matches[-1]
            symbol_pre, amount, symbol_suff = m
            
            try:
                price = float(amount)
            except: continue
                
            # Filter noise
            if price == 0 or price > 10000: continue # unlikely for a menu item
            if price > 1900 and price < 2100: continue # Likely a year 2020...
            
            # Extract Name
            # Remove the price part from line
            # This is tricky with simple regex, but let's just take the text BEFORE the price
            # if price is at end.
            
            # Simple heuristic: Split by the price string
            price_str = amount
            parts = line.split(price_str)
            name_candidate = parts[0].strip()
            
            # Clean name
            name_candidate = name_candidate.replace('₪', '').replace('$', '').replace('-', '').strip()
            
            if len(name_candidate) < 3: continue
            if len(name_candidate) > 100: continue # Description? Maybe.
            
            # Currency detection
            found_currency = self.default_currency
            if symbol_pre: found_currency = CURRENCY_SYMBOLS.get(symbol_pre, found_currency)
            if symbol_suff: found_currency = CURRENCY_SYMBOLS.get(symbol_suff, found_currency)
            
            # SKU
            sku_hash = hashlib.md5(f"{restaurant_name}_{name_candidate}".encode('utf-8')).hexdigest()[:12]
            sku = f"GEN_{sku_hash}"
            
            items.append({
                "name": name_candidate,
                "description": "", # Text based parsing rarely gets clean description separator
                "price": price,
                "currency": found_currency,
                "sku": sku,
                "menu_section": "General" 
            })
            
        return items

    def parse_dom_elements(self, visible_texts, restaurant_name):
        # Playwright gives us a list of strings of visible elements.
        # We can treat this as a stream of text blocks.
        # This basically calls parse_text but we can be smarter if we had DOM structure.
        # For V2, let's stick to text analysis of the whole page text content 
        # or specific selectors if we wanted.
        
        # Actually, extracting `innerText` of the whole body preserves layout somewhat (newlines).
        return self.parse_text(visible_texts, restaurant_name)


async def scrape_site(url, name, parser):
    print(f"Scraping {name} @ {url}...")
    try:
        async with async_playwright() as p:
            # Launch with generic user agent
            browser = await p.chromium.launch(headless=True, args=["--no-sandbox", "--disable-setuid-sandbox"])
            context = await browser.new_context(user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36")
            page = await context.new_page()
            
            try:
                await page.goto(url, timeout=30000, wait_until='domcontentloaded')
                # Wait for potential JS rendering (Wix)
                await page.wait_for_timeout(5000)
            except Exception as e:
                print(f"  Load Error: {e}")
                await browser.close()
                return []

            # Extract visible text
            # innerText is better than textContent for visual layout
            text = await page.evaluate("document.body.innerText")
            
            # Parse
            items = parser.parse_text(text, name)
            
            await browser.close()
            return items
            
    except Exception as e:
        print(f"  Browser Error: {e}")
        return []

async def run_scraper(city="Rehovot", default_currency="ILS"):
    input_file = f"/app/backend/enriched_{city}.json"
    
    # Connect DB
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Ensure Vertical
    cur.execute("SELECT id FROM verticals WHERE slug = 'restaurants'")
    res = cur.fetchone()
    if not res:
        # Create if missing (should exist)
        cur.execute("INSERT INTO verticals (name, slug, is_active) VALUES ('Restaurants', 'restaurants', true) RETURNING id")
        vertical_id = cur.fetchone()[0]
    else:
        vertical_id = res[0]
        
    # Ensure Supplier
    cur.execute("SELECT id FROM suppliers WHERE name = 'Generic Web Scraper'")
    res = cur.fetchone()
    if not res:
        cur.execute("INSERT INTO suppliers (name) VALUES ('Generic Web Scraper') RETURNING id")
        supplier_id = cur.fetchone()[0]
    else:
        supplier_id = res[0]

    with open(input_file, 'r', encoding='utf-8') as f:
        restaurants = json.load(f)
        
    parser = GenericMenuParser(default_currency=default_currency)
    
    for r in restaurants:
        name = r['name']
        url = r.get('website')
        if not url or 'facebook' in url or 'instagram' in url: continue
        
        items = await scrape_site(url, name, parser)
        if not items:
            print("  No items found.")
            continue
            
        print(f"  Found {len(items)} items.")
        
        # DEDUP by Price/Name?
        # Text parsing is noisy. We might get "Tel 08" as price 8.
        # We'll ingest anyway and user can filter.
        # Or better: Require specific currency symbol for high confidence?
        # User said "Don't hardcode NIS".
        # So we trust the parser's filters.
        
        # Create Chain/Store
        slug = hashlib.md5(name.encode()).hexdigest()[:10]
        cur.execute("INSERT INTO chains (name, slug, is_active) VALUES (%s, %s, true) ON CONFLICT (name) DO UPDATE SET is_active=true RETURNING id", (name, slug))
        chain_id = cur.fetchone()[0]
        
        store_name = f"{name} - {city}"
        cur.execute("INSERT INTO stores (chain_id, name, city, is_active, store_id) VALUES (%s, %s, %s, true, %s) ON CONFLICT (chain_id, store_id) DO UPDATE SET is_active=true RETURNING id", 
                    (chain_id, store_name, city, f"REST_{slug}_{city}"))
        store_id = cur.fetchone()[0]
        
        count = 0
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
            count += 1
            
        print(f"  Ingested {count} items.")
        conn.commit()


if __name__ == "__main__":
    city = sys.argv[1] if len(sys.argv) > 1 else "Rehovot"
    asyncio.run(run_scraper(city))
