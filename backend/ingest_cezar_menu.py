import os
import re
import json
import hashlib
import psycopg2
from psycopg2 import sql
from bs4 import BeautifulSoup
# from slugify import slugify

# DB Connection
DB_NAME = os.getenv("DB_NAME", "gogobe")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD", "password")
DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = os.getenv("DB_PORT", "5432")

def get_db_connection():
    return psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        host=DB_HOST,
        port=DB_PORT
    )

def parse_cezar_menu(html_path):
    with open(html_path, 'r', encoding='utf-8') as f:
        soup = BeautifulSoup(f, 'html.parser')

    menu_items = []
    current_section = "General"
    widgets = soup.find_all('div', class_='elementor-widget')
    last_dish_name = None
    
    for widget in widgets:
        if 'elementor-widget-divider' in widget.get('class', []):
            divider_text = widget.find('span', class_='elementor-divider__text')
            if divider_text:
                current_section = divider_text.get_text(strip=True)
                last_dish_name = None
                continue

        if 'elementor-widget-heading' in widget.get('class', []):
            h3 = widget.find('h3', class_='elementor-heading-title')
            p = widget.find('p', class_='elementor-heading-title')
            
            if h3:
                name = h3.get_text(strip=True)
                if name:
                    last_dish_name = name
            
            elif p and last_dish_name:
                content = p.get_text("\n", strip=True)
                # Helper to find price at end of string
                price_match = re.search(r'(\d+)$', content)
                
                if price_match:
                    price = float(price_match.group(1))
                    description = content[:price_match.start()].strip()
                    
                    # Create SKU based on hash of name + restaurant slug (implied)
                    sku_base = f"cezar_{last_dish_name}"
                    sku_hash = hashlib.md5(sku_base.encode('utf-8')).hexdigest()[:12]
                    sku = f"CEZAR_{sku_hash}"

                    item = {
                        "name": last_dish_name,
                        "description": description,
                        "price": price,
                        "menu_section": current_section,
                        "currency": "ILS",
                        "sku": sku
                    }
                    menu_items.append(item)
                    last_dish_name = None
    return menu_items

def run_ingestion():
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        print("Connected to DB.")
        
        # 1. Ensure Vertical
        cur.execute("SELECT id FROM verticals WHERE slug = 'restaurants'")
        res = cur.fetchone()
        if not res:
            print("Creating 'Restaurants' vertical...")
            cur.execute("INSERT INTO verticals (name, slug, is_active) VALUES ('Restaurants', 'restaurants', true) RETURNING id")
            vertical_id = cur.fetchone()[0]
        else:
            vertical_id = res[0]
        print(f"Vertical ID: {vertical_id}")
        
        # 2. Ensure Chain
        cur.execute("SELECT id FROM chains WHERE slug = 'cezar-bistro'")
        res = cur.fetchone()
        if not res:
            print("Creating 'Cezar Bistro' chain...")
            cur.execute("INSERT INTO chains (name, slug, name_he, is_active) VALUES ('Cezar Bistro', 'cezar-bistro', 'סזאר ביסטרו', true) RETURNING id")
            chain_id = cur.fetchone()[0]
        else:
            chain_id = res[0]
        print(f"Chain ID: {chain_id}")
        
        # 3. Ensure Store
        store_name = "Cezar Bistro - Rehovot"
        cur.execute("SELECT id FROM stores WHERE chain_id = %s AND name = %s", (chain_id, store_name))
        res = cur.fetchone()
        if not res:
            print(f"Creating store '{store_name}'...")
            cur.execute("""
                INSERT INTO stores (chain_id, name, name_he, city, is_active, store_id)
                VALUES (%s, %s, %s, 'Rehovot', true, 'CEZAR_REHOVOT_001') RETURNING id
            """, (chain_id, store_name, 'סזאר רחובות'))
            store_id = cur.fetchone()[0]
        else:
            store_id = res[0]
        print(f"Store ID: {store_id}")
        
        # 4. Ensure Supplier
        supplier_name = "Cezar Website"
        cur.execute("SELECT id FROM suppliers WHERE name = %s", (supplier_name,))
        res = cur.fetchone()
        if not res:
             print(f"Creating supplier '{supplier_name}'...")
             cur.execute("INSERT INTO suppliers (name) VALUES (%s) RETURNING id", (supplier_name,))
             supplier_id = cur.fetchone()[0]
        else:
            supplier_id = res[0]
        print(f"Supplier ID: {supplier_id}")
        
        # 5. Parse and Ingest
        items = parse_cezar_menu('/app/backend/cezar_raw.html')
        print(f"Found {len(items)} items to ingest.")
        
        for item in items:
            # Check if Product exists by SKU
            cur.execute("SELECT id FROM products WHERE sku = %s", (item['sku'],))
            res = cur.fetchone()
            
            attributes = json.dumps({"menu_section": item['menu_section'], "type": "dish"})
            
            if not res:
                # Insert Product
                cur.execute("""
                    INSERT INTO products (name, description, vertical_id, sku, attributes, is_active)
                    VALUES (%s, %s, %s, %s, %s, true) RETURNING id
                """, (item['name'], item['description'], vertical_id, item['sku'], attributes))
                product_id = cur.fetchone()[0]
                action = "Inserted"
            else:
                product_id = res[0]
                # Update attributes if needed
                cur.execute("UPDATE products SET attributes = %s, description = %s WHERE id = %s", (attributes, item['description'], product_id))
                action = "Updated"
            
            # Insert/Update Price
            cur.execute("""
                INSERT INTO prices (product_id, store_id, supplier_id, price, currency, is_available, scraped_at, first_scraped_at)
                VALUES (%s, %s, %s, %s, 'ILS', true, NOW(), NOW())
                ON CONFLICT (product_id, supplier_id, store_id) 
                DO UPDATE SET price = EXCLUDED.price, scraped_at = NOW(), is_available = true
            """, (product_id, store_id, supplier_id, item['price']))
            
            print(f"{action} Product: {item['name']} - Price: {item['price']}")
            
        conn.commit()
        print("Ingestion complete.")

    except Exception as e:
        conn.rollback()
        print(f"Error: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    run_ingestion()
