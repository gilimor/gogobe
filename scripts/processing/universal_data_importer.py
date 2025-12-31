"""
Universal Data Importer
Supports multiple data sources and formats
"""

import psycopg2
from psycopg2.extras import RealDictCursor
import requests
import json
from pathlib import Path
from datetime import datetime
import csv

# Database configuration
DB_CONFIG = {
    'dbname': 'gogobe',
    'user': 'postgres',
    'password': '9152245-Gl!',
    'host': 'localhost',
    'port': '5432'
}

class DataImporter:
    def __init__(self):
        self.conn = psycopg2.connect(**DB_CONFIG)
        self.cur = self.conn.cursor(cursor_factory=RealDictCursor)
        self.stats = {
            'products_created': 0,
            'products_updated': 0,
            'prices_created': 0,
            'errors': []
        }
    
    def import_csv(self, csv_path, supplier_name, vertical_name='Supermarkets'):
        """Import products from CSV file"""
        print(f"\n📂 מייבא מ-CSV: {csv_path}")
        
        # Get or create supplier
        supplier_id = self.get_or_create_supplier(supplier_name, vertical_name)
        
        # Get vertical
        vertical_id = self.get_vertical_id(vertical_name)
        
        with open(csv_path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            
            for row in reader:
                try:
                    # Extract data
                    product_name = row.get('name') or row.get('product_name')
                    barcode = row.get('barcode') or row.get('ean')
                    price = float(row.get('price', 0))
                    category_name = row.get('category')
                    
                    if not product_name or not price:
                        continue
                    
                    # Get or create product
                    product_id = self.get_or_create_product(
                        name=product_name,
                        ean=barcode,
                        vertical_id=vertical_id,
                        category_name=category_name
                    )
                    
                    # Create price
                    self.create_price(
                        product_id=product_id,
                        supplier_id=supplier_id,
                        price=price,
                        currency='ILS'
                    )
                    
                except Exception as e:
                    self.stats['errors'].append(f"שורה {reader.line_num}: {e}")
        
        self.conn.commit()
        print(f"✅ הסתיים!")
    
    def import_json(self, json_path, supplier_name, vertical_name='Supermarkets'):
        """Import products from JSON file"""
        print(f"\n📂 מייבא מ-JSON: {json_path}")
        
        with open(json_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Get or create supplier
        supplier_id = self.get_or_create_supplier(supplier_name, vertical_name)
        vertical_id = self.get_vertical_id(vertical_name)
        
        products = data if isinstance(data, list) else data.get('products', [])
        
        for item in products:
            try:
                product_id = self.get_or_create_product(
                    name=item.get('name'),
                    ean=item.get('barcode') or item.get('ean'),
                    vertical_id=vertical_id,
                    category_name=item.get('category')
                )
                
                if 'price' in item:
                    self.create_price(
                        product_id=product_id,
                        supplier_id=supplier_id,
                        price=float(item['price']),
                        currency=item.get('currency', 'ILS')
                    )
            
            except Exception as e:
                self.stats['errors'].append(f"מוצר {item.get('name', 'N/A')}: {e}")
        
        self.conn.commit()
        print(f"✅ הסתיים!")
    
    def import_api(self, api_url, supplier_name, vertical_name='Supermarkets'):
        """Import products from API endpoint"""
        print(f"\n🌐 מייבא מ-API: {api_url}")
        
        try:
            response = requests.get(api_url)
            response.raise_for_status()
            data = response.json()
            
            # Save to temp file and import
            temp_file = Path('temp_api_data.json')
            with open(temp_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False)
            
            self.import_json(temp_file, supplier_name, vertical_name)
            temp_file.unlink()
            
        except Exception as e:
            print(f"❌ שגיאה ב-API: {e}")
            self.stats['errors'].append(f"API Error: {e}")
    
    def get_vertical_id(self, vertical_name):
        """Get or create vertical"""
        self.cur.execute("""
            SELECT id FROM verticals WHERE name ILIKE %s
        """, (vertical_name,))
        
        result = self.cur.fetchone()
        if result:
            return result['id']
        
        # Create new vertical
        self.cur.execute("""
            INSERT INTO verticals (name, slug)
            VALUES (%s, %s)
            RETURNING id
        """, (vertical_name, vertical_name.lower().replace(' ', '-')))
        
        return self.cur.fetchone()['id']
    
    def get_or_create_supplier(self, supplier_name, vertical_name):
        """Get or create supplier"""
        self.cur.execute("""
            SELECT id FROM suppliers WHERE name = %s
        """, (supplier_name,))
        
        result = self.cur.fetchone()
        if result:
            return result['id']
        
        # Create new supplier
        self.cur.execute("""
            INSERT INTO suppliers (name, slug, supplier_type, verticals)
            VALUES (%s, %s, 'retailer', ARRAY[%s])
            RETURNING id
        """, (supplier_name, supplier_name.lower().replace(' ', '-'), vertical_name))
        
        return self.cur.fetchone()['id']
    
    def get_or_create_product(self, name, ean, vertical_id, category_name=None):
        """Get or create product"""
        # Try to find existing product by EAN
        if ean:
            self.cur.execute("""
                SELECT id FROM products WHERE ean = %s
            """, (ean,))
            
            result = self.cur.fetchone()
            if result:
                self.stats['products_updated'] += 1
                return result['id']
        
        # Try to find by name (exact match)
        self.cur.execute("""
            SELECT id FROM products WHERE name = %s
        """, (name,))
        
        result = self.cur.fetchone()
        if result:
            self.stats['products_updated'] += 1
            return result['id']
        
        # Create new product
        category_id = self.get_category_id(category_name, vertical_id) if category_name else None
        
        self.cur.execute("""
            INSERT INTO products (name, ean, vertical_id, category_id)
            VALUES (%s, %s, %s, %s)
            RETURNING id
        """, (name, ean, vertical_id, category_id))
        
        self.stats['products_created'] += 1
        return self.cur.fetchone()['id']
    
    def get_category_id(self, category_name, vertical_id):
        """Get or create category"""
        self.cur.execute("""
            SELECT id FROM categories 
            WHERE name = %s AND vertical_id = %s
        """, (category_name, vertical_id))
        
        result = self.cur.fetchone()
        if result:
            return result['id']
        
        # Create new category
        self.cur.execute("""
            INSERT INTO categories (name, slug, vertical_id)
            VALUES (%s, %s, %s)
            RETURNING id
        """, (category_name, category_name.lower().replace(' ', '-'), vertical_id))
        
        return self.cur.fetchone()['id']
    
    def create_price(self, product_id, supplier_id, price, currency='ILS'):
        """Create price record"""
        self.cur.execute("""
            INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
            VALUES (%s, %s, %s, %s, NOW())
        """, (product_id, supplier_id, price, currency))
        
        self.stats['prices_created'] += 1
    
    def print_stats(self):
        """Print import statistics"""
        print("\n" + "=" * 80)
        print("📊 סטטיסטיקות יבוא:")
        print("=" * 80)
        print(f"   מוצרים חדשים: {self.stats['products_created']}")
        print(f"   מוצרים עודכנו: {self.stats['products_updated']}")
        print(f"   מחירים נוספו: {self.stats['prices_created']}")
        print(f"   שגיאות: {len(self.stats['errors'])}")
        
        if self.stats['errors']:
            print("\n❌ שגיאות:")
            for error in self.stats['errors'][:10]:
                print(f"   - {error}")
    
    def close(self):
        """Close database connection"""
        self.cur.close()
        self.conn.close()

def main():
    """Main execution"""
    print("=" * 80)
    print("📥 Universal Data Importer")
    print("=" * 80)
    
    importer = DataImporter()
    
    try:
        print("\nבחר אופן יבוא:")
        print("   1. CSV File")
        print("   2. JSON File")
        print("   3. API Endpoint")
        print("   4. יציאה")
        
        choice = input("\nבחר (1/2/3/4): ").strip()
        
        if choice == "1":
            csv_path = input("נתיב קובץ CSV: ").strip()
            supplier_name = input("שם הספק: ").strip()
            vertical_name = input("Vertical (ברירת מחדל: Supermarkets): ").strip() or "Supermarkets"
            
            importer.import_csv(csv_path, supplier_name, vertical_name)
        
        elif choice == "2":
            json_path = input("נתיב קובץ JSON: ").strip()
            supplier_name = input("שם הספק: ").strip()
            vertical_name = input("Vertical (ברירת מחדל: Supermarkets): ").strip() or "Supermarkets"
            
            importer.import_json(json_path, supplier_name, vertical_name)
        
        elif choice == "3":
            api_url = input("API URL: ").strip()
            supplier_name = input("שם הספק: ").strip()
            vertical_name = input("Vertical (ברירת מחדל: Supermarkets): ").strip() or "Supermarkets"
            
            importer.import_api(api_url, supplier_name, vertical_name)
        
        else:
            print("יציאה.")
            return
        
        importer.print_stats()
    
    finally:
        importer.close()
    
    print("\n" + "=" * 80)
    print("✅ הסתיים!")
    print("=" * 80)

if __name__ == "__main__":
    main()




