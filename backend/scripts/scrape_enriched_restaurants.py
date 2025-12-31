import json
import hashlib
import sys
import os
import requests
import psycopg2
from bs4 import BeautifulSoup

# DB Credentials (reusing from previous scripts)
DB_NAME = os.getenv("DB_NAME", "gogobe")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD", "password")
DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = os.getenv("DB_PORT", "5432")

def get_db_connection():
    return psycopg2.connect(dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD, host=DB_HOST, port=DB_PORT)

def parse_elementor_content(html_content, restaurant_name):
    soup = BeautifulSoup(html_content, 'html.parser')
    items = []
    current_section = "General"
    
    # Generic Elementor Logic
    # 1. Look for headings (Dish Names)
    # 2. Look for price patterns in siblings or children
    
    # Refined Logic from Cezar:
    # Widgets are containers.
    widgets = soup.find_all('div', class_='elementor-widget')
    last_title = None
    
    for widget in widgets:
        # Divider -> Section
        if 'elementor-widget-divider' in widget.get('class', []):
            txt = widget.find(class_='elementor-divider__text')
            if txt:
                current_section = txt.get_text(strip=True)
                continue
        
        # Heading -> Title or Description+Price
        if 'elementor-widget-heading' in widget.get('class', []):
            # Elementor often uses H-tags for titles and P/Div for desc+price
            title_node = widget.find(['h2', 'h3', 'h4', 'h5', 'h6'], class_='elementor-heading-title')
            text_node = widget.find(['p', 'div', 'span'], class_='elementor-heading-title')
            
            if title_node:
                t = title_node.get_text(strip=True)
                # Heuristic: Titles are short
                if len(t) < 50 and not any(c.isdigit() for c in t):
                    last_title = t
            
            elif text_node and last_title:
                content = text_node.get_text("\n", strip=True)
                # Look for price at end: "Description... 55"
                import re
                match = re.search(r'(\d{2,3})$', content.strip())
                if match:
                    price = float(match.group(1))
                    desc = content[:match.start()].strip()
                    if len(desc) > 200: desc = desc[:200]
                    
                    # Generate SKU
                    sku_hash = hashlib.md5(f"{restaurant_name}_{last_title}".encode('utf-8')).hexdigest()[:12]
                    sku = f"REST_{sku_hash}"
                    
                    items.append({
                        "name": last_title,
                        "description": desc,
                        "price": price,
                        "menu_section": current_section,
                        "sku": sku
                    })
                    last_title = None # consumed

    return items

def scrape_and_ingest(city="Rehovot"):
    input_file = f"/app/backend/enriched_{city}.json"
    
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        
        # Ensure Vertical
        cur.execute("SELECT id FROM verticals WHERE slug = 'restaurants'")
        vid = cur.fetchone()
        vertical_id = vid[0] if vid else None # Should exist
        
        with open(input_file, 'r', encoding='utf-8') as f:
            restaurants = json.load(f)
            
        print(f"Loaded {len(restaurants)} restaurants.")
        
        for r in restaurants:
            name = r['name']
            url = r.get('website')
            if not url or 'facebook' in url or 'instagram' in url:
                print(f"Skipping {name} (Invalid URL)")
                continue
                
            print(f"Scraping {name} @ {url}...")
            try:
                # 1. Fetch
                headers = {'User-Agent': 'Mozilla/5.0'}
                res = requests.get(url, headers=headers, timeout=10)
                if res.status_code != 200:
                    print(f"  Failed HTTP {res.status_code}")
                    continue
                
                # 2. Parse
                items = parse_elementor_content(res.text, name)
                if not items:
                    print("  No items found (Not Elementor?)")
                    continue
                
                print(f"  Found {len(items)} items!")
                
                # 3. Create Chain/Store
                slug = hashlib.md5(name.encode()).hexdigest()[:10]
                cur.execute("INSERT INTO chains (name, slug, is_active) VALUES (%s, %s, true) ON CONFLICT (name) DO UPDATE SET is_active=true RETURNING id", (name, slug))
                chain_id = cur.fetchone()[0]
                
                store_name = f"{name} - {city}"
                cur.execute("INSERT INTO stores (chain_id, name, city, is_active, store_id) VALUES (%s, %s, %s, true, %s) ON CONFLICT (chain_id, store_id) DO UPDATE SET is_active=true RETURNING id", 
                            (chain_id, store_name, city, f"REST_{slug}_{city}"))
                store_id = cur.fetchone()[0]
                
                # 4. Ingest Items
                count = 0
                for item in items:
                    # Upsert Product
                    attr = json.dumps({"menu_section": item['menu_section'], "type": "dish"})
                    cur.execute("SELECT id FROM products WHERE sku = %s", (item['sku'],))
                    pid = cur.fetchone()
                    if not pid:
                        cur.execute("INSERT INTO products (name, description, vertical_id, sku, attributes, is_active) VALUES (%s, %s, %s, %s, %s, true) RETURNING id",
                                    (item['name'], item['description'], vertical_id, item['sku'], attr))
                        product_id = cur.fetchone()[0]
                    else:
                        product_id = pid[0]
                    
                    # Upsert Price
                    # Use a dummy supplier ID for now (Cezar Website ID=2822 or create new?)
                    # Let's use a generic 'Web Scraper' supplier or specific?
                    # I'll retrieve the 'Cezar Website' one or create a generic 'Restaurant Web'
                    # Reuse supplier ID from previous script ?? No, that was specific.
                    # I'll create one Supplier per Restaurant? Or one global? 
                    # One global "Restaurant Web Scraper" is cleaner.
                    
                    cur.execute("SELECT id FROM suppliers WHERE name = 'Restaurant Web Scraper'")
                    sid = cur.fetchone()
                    if not sid:
                        cur.execute("INSERT INTO suppliers (name) VALUES ('Restaurant Web Scraper') RETURNING id")
                        supplier_id = cur.fetchone()[0]
                    else:
                        supplier_id = sid[0]
                        
                    cur.execute("""
                        INSERT INTO prices (product_id, store_id, supplier_id, price, currency, is_available, scraped_at, first_scraped_at)
                        VALUES (%s, %s, %s, %s, 'ILS', true, NOW(), NOW())
                        ON CONFLICT (product_id, supplier_id, store_id) DO UPDATE SET price = EXCLUDED.price
                    """, (product_id, store_id, supplier_id, item['price']))
                    count += 1
                
                print(f"  Ingested {count} items.")
                conn.commit()

            except Exception as e:
                print(f"  Error: {e}")
                conn.rollback()

    except Exception as e:
        print(f"Fatal Error: {e}")
    finally:
        if conn: conn.close()

if __name__ == "__main__":
    city = sys.argv[1] if len(sys.argv) > 1 else "Rehovot"
    scrape_and_ingest(city)
