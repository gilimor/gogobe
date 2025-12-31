
import sys
import os
import psycopg2
from pathlib import Path
from datetime import datetime

# Add backend to path
sys.path.append(str(Path(__file__).parent.parent))

from scrapers.walmart_scraper import WalmartScraper
from scrapers.openfoodfacts_scraper import OpenFoodFactsScraper
from database.db_connection import get_db_connection

def force_load():
    print("🚀 Force Loading Global Data for Demo...")
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        # 1. Load Walmart Data
        print("\n🛒 Fetching Walmart Data (Simulation)...")
        walmart = WalmartScraper()
        
        # Create a dummy file with mock Walmart data
        dummy_path = Path(__file__).parent / "Walmart_Grocery.json" 
        
        import json
        mock_walmart_data = {
            "items": [
                {
                    "name": "Great Value Whole Vitamin D Milk, Gallon", 
                    "salePrice": 3.14, 
                    "currency": "USD",
                    "upc": "07874235186",
                    "brandName": "Great Value"
                },
                {
                    "name": "Bananas, Bunch", 
                    "salePrice": 1.48, 
                    "currency": "USD",
                    "upc": "4011",
                    "brandName": "Fresh"
                },
                {
                    "name": "Kraft Macaroni & Cheese Dinner", 
                    "salePrice": 0.99, 
                    "currency": "USD",
                    "upc": "02100065883",
                    "brandName": "Kraft"
                },
                 {
                    "name": "Colgate Total Whitening Toothpaste", 
                    "salePrice": 4.96, 
                    "currency": "USD",
                    "upc": "03500044093",
                    "brandName": "Colgate"
                }
            ]
        }
        
        with open(dummy_path, 'w', encoding='utf-8') as f:
            json.dump(mock_walmart_data, f)
        
        # Manually trigger parse
        metadata, products = walmart.parse_file(dummy_path)
        
        # Get Store ID
        cur.execute("SELECT id FROM stores WHERE name LIKE 'Walmart Global%'")
        res = cur.fetchone()
        if not res:
            print("❌ Walmart Store not found! Run init_global_sources.py first.")
            return
        w_store_id = res[0]
        
        # Get Supplier ID (Assume slug is walmart)
        cur.execute("SELECT id FROM suppliers WHERE slug = 'walmart'")
        res = cur.fetchone()
        if not res:
            # Maybe created with capital W? But slug should be lowercase
             cur.execute("INSERT INTO suppliers (name, slug, country_code, is_active) VALUES ('Walmart', 'walmart', 'US', TRUE) RETURNING id")
             w_supp_id = cur.fetchone()[0]
        else:
            w_supp_id = res[0]

        print(f"   Found {len(products)} products. Inserting into DB (Store {w_store_id}, Supplier {w_supp_id})...")
        
        for p in products:
            # 1. Handle Brand
            brand_id = None
            brand_name = p.manufacturer or p.attributes.get('brand')
            if brand_name:
                cur.execute("SELECT id FROM brands WHERE name ILIKE %s", (brand_name,))
                res = cur.fetchone()
                if res:
                    brand_id = res[0]
                else:
                    cur.execute("INSERT INTO brands (name) VALUES (%s) RETURNING id", (brand_name,))
                    brand_id = cur.fetchone()[0]

            # 2. Upsert Product
            barcode_val = p.barcode if p.barcode and len(p.barcode) <= 20 else None
            
            cur.execute("""
                INSERT INTO products (name, ean, brand_id, category_id, is_active)
                VALUES (%s, %s, %s, NULL, TRUE)
                ON CONFLICT (ean) DO UPDATE SET name = EXCLUDED.name
                RETURNING id;
            """, (p.name, barcode_val, brand_id))
            prod_id = cur.fetchone()[0]
            
            # 3. Insert Price
            cur.execute("""
                INSERT INTO prices (product_id, supplier_id, store_id, price, currency, scraped_at)
                VALUES (%s, %s, %s, %s, %s, NOW())
                ON CONFLICT (product_id, supplier_id, store_id) DO UPDATE 
                SET price = EXCLUDED.price, scraped_at = NOW()
            """, (prod_id, w_supp_id, w_store_id, p.price, 'USD'))
            
        print("   ✅ Walmart Data Loaded.")

        # 2. Load Open Food Facts Data
        print("\n🌍 Fetching Open Food Facts Data (Simulation)...")
        
        # Get Store ID
        cur.execute("SELECT id FROM stores WHERE name LIKE 'Open Food Facts%'")
        res = cur.fetchone()
        if not res:
             print("❌ OFF Store not found!")
             return
        off_store_id = res[0]
        
        # Get Supplier ID
        cur.execute("SELECT id FROM suppliers WHERE slug = 'openfoodfacts'")
        off_supp_id = cur.fetchone()[0]

        off_products = [
            {"name": "Nutella Hazelnut Spread", "barcode": "3017620422003", "brand": "Ferrero"},
            {"name": "Coca-Cola Zero", "barcode": "5449000131805", "brand": "Coca-Cola"},
            {"name": "Oreo Original Cookies", "barcode": "7622210020304", "brand": "Nabisco"}
        ]
        
        print(f"   Inserting {len(off_products)} enrichment records (Store {off_store_id})...")
        
        for p in off_products:
             # Handle Brand
            brand_id = None
            if p['brand']:
                cur.execute("SELECT id FROM brands WHERE name ILIKE %s", (p['brand'],))
                res = cur.fetchone()
                if res:
                    brand_id = res[0]
                else:
                    cur.execute("INSERT INTO brands (name) VALUES (%s) RETURNING id", (p['brand'],))
                    brand_id = cur.fetchone()[0]

            # Upsert Product
            cur.execute("""
                INSERT INTO products (name, ean, brand_id, category_id, is_active)
                VALUES (%s, %s, %s, NULL, TRUE)
                ON CONFLICT (ean) DO UPDATE SET name = EXCLUDED.name
                RETURNING id;
            """, (p['name'], p['barcode'], brand_id))
            prod_id = cur.fetchone()[0]
            
            # Insert Price (Zero for enrichment)
            cur.execute("""
                INSERT INTO prices (product_id, supplier_id, store_id, price, currency, scraped_at)
                VALUES (%s, %s, %s, 0, 'USD', NOW())
                ON CONFLICT (product_id, supplier_id, store_id) DO NOTHING
            """, (prod_id, off_supp_id, off_store_id))
            
        print("   ✅ OFF Data Loaded.")
        
        conn.commit()
        print("\n✨ Done! Check the Frontend now.")
        
    except Exception as e:
        conn.rollback()
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
    finally:
        conn.close()

if __name__ == "__main__":
    force_load()
