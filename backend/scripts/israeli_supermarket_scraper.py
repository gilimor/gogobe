"""
Israeli Supermarket Price Scraper
Direct XML parsing - no external dependencies!
"""

import requests
import xml.etree.ElementTree as ET
import json
from datetime import datetime
from pathlib import Path
import sys

try:
    import psycopg2
    HAS_DB = True
except ImportError:
    HAS_DB = False
    print("Warning: psycopg2 not available. Will save to files only.")


class IsraeliSupermarketScraper:
    """Scrape Israeli supermarket prices from public XML feeds"""
    
    # Public XML endpoints (as per government regulations)
    CHAINS = {
        'shufersal': {
            'name': 'שופרסל',
            'name_en': 'Shufersal',
            'chain_id': '7290027600007',
            'stores_url': 'http://prices.shufersal.co.il/FileObject/UpdatePrice?storeId=0&fileType=1',
            'prices_url': 'http://prices.shufersal.co.il/FileObject/UpdatePrice?storeId={store_id}&fileType=2',
            'promos_url': 'http://prices.shufersal.co.il/FileObject/UpdatePrice?storeId={store_id}&fileType=3'
        },
        'rami_levy': {
            'name': 'רמי לוי',
            'name_en': 'Rami Levy',
            'chain_id': '7290058140886',
            'base_url': 'http://publishedprice.rami-levy.co.il/'
        },
        'victory': {
            'name': 'ויקטורי',
            'name_en': 'Victory',
            'chain_id': '7290696200003',
            'base_url': 'http://matrixcatalog.co.il/NBCompetitionRegulations/'
        }
    }
    
    def __init__(self, output_dir='supermarket_data'):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
    
    def download_xml(self, url, description="data"):
        """Download XML from URL with error handling"""
        print(f"  Downloading {description}...")
        try:
            response = self.session.get(url, timeout=30)
            response.raise_for_status()
            
            # Check if it's actually XML
            if response.content.startswith(b'<?xml') or b'<Root' in response.content[:100]:
                return response.content
            else:
                print(f"    Warning: Response doesn't look like XML")
                return None
                
        except requests.exceptions.RequestException as e:
            print(f"    Error downloading: {e}")
            return None
    
    def parse_shufersal_stores(self, xml_content):
        """Parse Shufersal stores XML"""
        stores = []
        
        try:
            root = ET.fromstring(xml_content)
            
            # Find all Store elements
            for store_elem in root.findall('.//Store'):
                store_id = store_elem.find('StoreId')
                store_name = store_elem.find('StoreName')
                city = store_elem.find('City')
                address = store_elem.find('Address')
                
                if store_id is not None and store_name is not None:
                    stores.append({
                        'id': store_id.text,
                        'name': store_name.text,
                        'city': city.text if city is not None else '',
                        'address': address.text if address is not None else ''
                    })
            
            print(f"    Found {len(stores)} stores")
            return stores
            
        except ET.ParseError as e:
            print(f"    XML Parse Error: {e}")
            return []
    
    def parse_shufersal_prices(self, xml_content, store_info):
        """Parse Shufersal prices XML"""
        products = []
        
        try:
            root = ET.fromstring(xml_content)
            
            # Find all Item elements
            for item_elem in root.findall('.//Item'):
                item_code = item_elem.find('ItemCode')
                item_name = item_elem.find('ItemName')
                item_price = item_elem.find('ItemPrice')
                manufacturer = item_elem.find('ManufacturerName')
                unit_measure = item_elem.find('UnitOfMeasure')
                quantity = item_elem.find('Quantity')
                
                if all([item_code is not None, item_name is not None, item_price is not None]):
                    try:
                        price = float(item_price.text)
                        
                        products.append({
                            'barcode': item_code.text,
                            'name': item_name.text,
                            'price': price,
                            'currency': 'ILS',
                            'manufacturer': manufacturer.text if manufacturer is not None else '',
                            'unit': unit_measure.text if unit_measure is not None else '',
                            'quantity': quantity.text if quantity is not None else '1',
                            'store_id': store_info['id'],
                            'store_name': store_info['name'],
                            'chain': 'Shufersal',
                            'scraped_at': datetime.now().isoformat()
                        })
                    except (ValueError, TypeError):
                        continue
            
            print(f"    Found {len(products)} products")
            return products
            
        except ET.ParseError as e:
            print(f"    XML Parse Error: {e}")
            return []
    
    def scrape_shufersal(self, max_stores=3, max_products_per_store=100):
        """Scrape Shufersal supermarket chain"""
        print("\n" + "="*60)
        print("🛒 Scraping Shufersal")
        print("="*60)
        
        chain_info = self.CHAINS['shufersal']
        
        # 1. Get stores
        stores_xml = self.download_xml(chain_info['stores_url'], "stores list")
        if not stores_xml:
            print("❌ Failed to get stores")
            return []
        
        stores = self.parse_shufersal_stores(stores_xml)
        if not stores:
            print("❌ No stores found")
            return []
        
        print(f"✅ Found {len(stores)} stores")
        print(f"   Processing first {max_stores} stores...")
        
        # 2. Get prices from each store
        all_products = []
        
        for i, store in enumerate(stores[:max_stores], 1):
            print(f"\n[{i}/{max_stores}] Store: {store['name']} (ID: {store['id']})")
            
            prices_url = chain_info['prices_url'].format(store_id=store['id'])
            prices_xml = self.download_xml(prices_url, "prices")
            
            if prices_xml:
                products = self.parse_shufersal_prices(prices_xml, store)
                
                # Limit products per store for testing
                products = products[:max_products_per_store]
                
                all_products.extend(products)
                print(f"    ✅ Added {len(products)} products")
            else:
                print(f"    ⚠️ Skipped (no data)")
        
        # 3. Save to JSON
        output_file = self.output_dir / f"shufersal_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump({
                'chain': 'Shufersal',
                'scraped_at': datetime.now().isoformat(),
                'total_products': len(all_products),
                'stores_count': len(stores[:max_stores]),
                'products': all_products
            }, f, ensure_ascii=False, indent=2)
        
        print(f"\n✅ Saved {len(all_products)} products to: {output_file}")
        
        return all_products
    
    def save_to_database(self, products, db_config):
        """Save products to Gogobe PostgreSQL database"""
        
        if not HAS_DB:
            print("❌ Cannot save to database - psycopg2 not installed")
            return False
        
        print("\n" + "="*60)
        print("💾 Saving to Gogobe Database")
        print("="*60)
        
        try:
            conn = psycopg2.connect(**db_config)
            cursor = conn.cursor()
            
            # 1. Create/get Supermarket vertical
            print("\n1. Setting up Supermarket vertical...")
            cursor.execute("""
                INSERT INTO verticals (name, slug, description, icon)
                VALUES ('Supermarkets', 'supermarket', 
                        'Israeli supermarket prices - daily updates', '🛒')
                ON CONFLICT (slug) 
                DO UPDATE SET description = EXCLUDED.description
                RETURNING id
            """)
            
            result = cursor.fetchone()
            if result:
                vertical_id = result[0]
            else:
                cursor.execute("SELECT id FROM verticals WHERE slug = 'supermarket'")
                vertical_id = cursor.fetchone()[0]
            
            print(f"   ✅ Vertical ID: {vertical_id}")
            
            # 2. Create default category
            print("\n2. Setting up categories...")
            cursor.execute("""
                INSERT INTO categories (vertical_id, name, slug, level, full_path)
                VALUES (%s, 'General', 'general', 1, 'supermarket/general')
                ON CONFLICT DO NOTHING
                RETURNING id
            """, (vertical_id,))
            
            result = cursor.fetchone()
            if result:
                category_id = result[0]
            else:
                cursor.execute("""
                    SELECT id FROM categories 
                    WHERE vertical_id = %s AND slug = 'general'
                """, (vertical_id,))
                category_id = cursor.fetchone()[0]
            
            print(f"   ✅ Category ID: {category_id}")
            
            # 3. Process products by store (each store is a supplier)
            print("\n3. Importing products...")
            
            stores_processed = {}
            products_added = 0
            prices_added = 0
            
            for product in products:
                # Create supplier for this store (if not exists)
                store_key = f"{product['chain']}-{product['store_id']}"
                
                if store_key not in stores_processed:
                    cursor.execute("""
                        INSERT INTO suppliers (name, slug, country_code, attributes)
                        VALUES (%s, %s, 'IL', %s)
                        ON CONFLICT (slug) DO NOTHING
                        RETURNING id
                    """, (
                        f"{product['chain']} - {product['store_name']}",
                        store_key.lower().replace(' ', '-'),
                        json.dumps({
                            'chain': product['chain'],
                            'store_id': product['store_id'],
                            'store_name': product['store_name']
                        })
                    ))
                    
                    result = cursor.fetchone()
                    if result:
                        supplier_id = result[0]
                    else:
                        cursor.execute(
                            "SELECT id FROM suppliers WHERE slug = %s",
                            (store_key.lower().replace(' ', '-'),)
                        )
                        supplier_id = cursor.fetchone()[0]
                    
                    stores_processed[store_key] = supplier_id
                    print(f"   ✅ Supplier: {product['chain']} - {product['store_name']}")
                
                supplier_id = stores_processed[store_key]
                
                # Create/get product
                cursor.execute("""
                    INSERT INTO products (name, vertical_id, category_id, attributes)
                    VALUES (%s, %s, %s, %s)
                    ON CONFLICT DO NOTHING
                    RETURNING id
                """, (
                    product['name'],
                    vertical_id,
                    category_id,
                    json.dumps({
                        'barcode': product['barcode'],
                        'manufacturer': product['manufacturer'],
                        'unit': product['unit'],
                        'quantity': product['quantity']
                    })
                ))
                
                result = cursor.fetchone()
                if result:
                    product_id = result[0]
                    products_added += 1
                else:
                    # Product exists, get ID
                    cursor.execute("""
                        SELECT id FROM products 
                        WHERE name = %s AND vertical_id = %s
                    """, (product['name'], vertical_id))
                    result = cursor.fetchone()
                    if result:
                        product_id = result[0]
                    else:
                        continue
                
                # Add price
                cursor.execute("""
                    INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
                    VALUES (%s, %s, %s, %s, NOW())
                """, (product_id, supplier_id, product['price'], product['currency']))
                
                prices_added += 1
            
            conn.commit()
            cursor.close()
            conn.close()
            
            print("\n" + "="*60)
            print("✅ Database Import Complete!")
            print("="*60)
            print(f"Suppliers (stores): {len(stores_processed)}")
            print(f"New products: {products_added}")
            print(f"Prices added: {prices_added}")
            print("="*60)
            
            return True
            
        except Exception as e:
            print(f"\n❌ Database error: {e}")
            return False


def main():
    """Main entry point"""
    print("="*60)
    print("🇮🇱 Israeli Supermarket Scraper")
    print("="*60)
    print("POC Version - Shufersal only")
    print("="*60)
    
    # Create scraper
    scraper = IsraeliSupermarketScraper()
    
    # Scrape Shufersal (limit to 3 stores, 100 products each for POC)
    products = scraper.scrape_shufersal(max_stores=3, max_products_per_store=100)
    
    if not products:
        print("\n❌ No products scraped")
        return
    
    print(f"\n✅ Total scraped: {len(products)} products")
    
    # Save to database
    if HAS_DB:
        db_config = {
            'host': 'localhost',
            'port': 5432,
            'database': 'gogobe',
            'user': 'postgres',
            'password': '9152245-Gl!'
        }
        
        scraper.save_to_database(products, db_config)
    else:
        print("\n⚠️  Database save skipped (psycopg2 not installed)")
        print("   Data saved to JSON file only")
    
    print("\n" + "="*60)
    print("🎉 POC Complete!")
    print("="*60)


if __name__ == "__main__":
    main()






