"""
Israeli Supermarket - Demo Data Generator
Creates realistic sample data to demonstrate the system
"""

import psycopg2
import json
from datetime import datetime, timedelta
import random

# Realistic Israeli supermarket products
SAMPLE_PRODUCTS = [
    # Dairy
    {"name": "חלב 3% תנובה 1 ליטר", "barcode": "7290000066707", "manufacturer": "תנובה", "category": "Dairy", "base_price": 6.90},
    {"name": "חלב 1% תנובה 1 ליטר", "barcode": "7290000066714", "manufacturer": "תנובה", "category": "Dairy", "base_price": 6.90},
    {"name": "יוגורט יופלה תות 150גר", "barcode": "7290000068008", "manufacturer": "תנובה", "category": "Dairy", "base_price": 5.50},
    {"name": "גבינה צהובה עמק 200גר", "barcode": "7290000067001", "manufacturer": "תנובה", "category": "Dairy", "base_price": 14.90},
    {"name": "חמאה 200גר תנובה", "barcode": "7290000068701", "manufacturer": "תנובה", "category": "Dairy", "base_price": 12.90},
    
    # Bread & Bakery
    {"name": "לחם פרוס 750גר אנג", "barcode": "7290000069001", "manufacturer": "אנג'ל", "category": "Bakery", "base_price": 7.90},
    {"name": "חלה 500גר", "barcode": "7290000069100", "manufacturer": "אנג'ל", "category": "Bakery", "base_price": 9.90},
    {"name": "לחמניות המבורגר 6 יח", "barcode": "7290000069200", "manufacturer": "אנג'ל", "category": "Bakery", "base_price": 11.90},
    
    # Meat & Poultry
    {"name": "חזה עוף טרי 1 ק\"ג", "barcode": "7290000070001", "manufacturer": "זוגלובק", "category": "Meat", "base_price": 34.90},
    {"name": "שניצל עוף קפוא 1 ק\"ג", "barcode": "7290000070100", "manufacturer": "עוף טוב", "category": "Meat", "base_price": 39.90},
    {"name": "נקניקיות 500גר", "barcode": "7290000070200", "manufacturer": "תבן", "category": "Meat", "base_price": 18.90},
    
    # Vegetables & Fruits
    {"name": "עגבניות 1 ק\"ג", "barcode": "2000000001001", "manufacturer": "חקלאי ישראלי", "category": "Vegetables", "base_price": 8.90},
    {"name": "מלפפונים 1 ק\"ג", "barcode": "2000000001002", "manufacturer": "חקלאי ישראלי", "category": "Vegetables", "base_price": 6.90},
    {"name": "תפוחי עץ 1 ק\"ג", "barcode": "2000000002001", "manufacturer": "חקלאי ישראלי", "category": "Fruits", "base_price": 12.90},
    {"name": "בננות 1 ק\"ג", "barcode": "2000000002002", "manufacturer": "ייבוא", "category": "Fruits", "base_price": 9.90},
    
    # Beverages
    {"name": "קוקה קולה 1.5 ליטר", "barcode": "7290000071001", "manufacturer": "קוקה קולה", "category": "Beverages", "base_price": 6.50},
    {"name": "ספרינג מים מינרליים 1.5 ליטר", "barcode": "7290000071100", "manufacturer": "מי עדן", "category": "Beverages", "base_price": 3.90},
    {"name": "תה פתיתים חליטה 100 שק", "barcode": "7290000071200", "manufacturer": "ויסוצקי", "category": "Beverages", "base_price": 11.90},
    
    # Snacks
    {"name": "במבה 200גר", "barcode": "7290000072001", "manufacturer": "אסם", "category": "Snacks", "base_price": 8.90},
    {"name": "ביסלי גריל 200גר", "barcode": "7290000072100", "manufacturer": "אסם", "category": "Snacks", "base_price": 8.90},
    {"name": "שוקולד מילקה 100גר", "barcode": "7290000072200", "manufacturer": "מילקה", "category": "Snacks", "base_price": 7.90},
    
    # Household
    {"name": "סנו סבון כלים לימון 1 ליטר", "barcode": "7290000073001", "manufacturer": "סנו", "category": "Household", "base_price": 9.90},
    {"name": "טישו נייר טואלט 24 גלילים", "barcode": "7290000073100", "manufacturer": "פמפרס", "category": "Household", "base_price": 39.90},
    {"name": "נייר מטבח 8 גלילים", "barcode": "7290000073200", "manufacturer": "סופרסל", "category": "Household", "base_price": 24.90},
    
    # Personal Care
    {"name": "משחת שיניים קולגייט 100מל", "barcode": "7290000074001", "manufacturer": "קולגייט", "category": "Personal Care", "base_price": 14.90},
    {"name": "שמפו 700מל הד אנד שולדרס", "barcode": "7290000074100", "manufacturer": "P&G", "category": "Personal Care", "base_price": 19.90},
    {"name": "סבון רחצה דאב 4 יח", "barcode": "7290000074200", "manufacturer": "דאב", "category": "Personal Care", "base_price": 16.90},
]

# Israeli supermarket chains and stores
CHAINS = [
    {
        "name": "שופרסל",
        "name_en": "Shufersal",
        "stores": [
            {"name": "שופרסל דיל תל אביב", "city": "תל אביב"},
            {"name": "שופרסל שלי ירושלים", "city": "ירושלים"},
            {"name": "שופרסל אונליין חיפה", "city": "חיפה"},
        ]
    },
    {
        "name": "רמי לוי",
        "name_en": "Rami Levy",
        "stores": [
            {"name": "רמי לוי רמת גן", "city": "רמת גן"},
            {"name": "רמי לוי פתח תקווה", "city": "פתח תקווה"},
            {"name": "רמי לוי באר שבע", "city": "באר שבע"},
        ]
    },
    {
        "name": "ויקטורי",
        "name_en": "Victory",
        "stores": [
            {"name": "ויקטורי נתניה", "city": "נתניה"},
            {"name": "ויקטורי חולון", "city": "חולון"},
        ]
    },
    {
        "name": "יינות ביתן",
        "name_en": "Yeinot Bitan",
        "stores": [
            {"name": "יינות ביתן רעננה", "city": "רעננה"},
            {"name": "יינות ביתן הרצליה", "city": "הרצליה"},
        ]
    }
]


def generate_price_variation(base_price, store_index, product_index):
    """Generate realistic price variations between stores"""
    # Each store has a general pricing level
    store_factors = [1.0, 0.95, 1.05, 0.98, 1.02, 1.08, 0.92, 1.01]
    store_factor = store_factors[store_index % len(store_factors)]
    
    # Add some product-specific variation
    variation = random.uniform(-0.05, 0.05)
    
    # Apply
    final_price = base_price * store_factor * (1 + variation)
    
    # Round to realistic Israeli pricing (usually ends in .90 or .50)
    final_price = round(final_price * 2) / 2  # Round to nearest 0.50
    
    return max(0.50, final_price)  # Minimum 0.50 ₪


def create_demo_data(db_config):
    """Create demo supermarket data in Gogobe database"""
    
    print("="*60)
    print("🇮🇱 Israeli Supermarket - Demo Data Generator")
    print("="*60)
    
    try:
        conn = psycopg2.connect(**db_config)
        cursor = conn.cursor()
        
        # 1. Create Supermarket vertical
        print("\n1️⃣ Creating Supermarket vertical...")
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
        
        # 2. Create categories
        print("\n2️⃣ Creating categories...")
        categories = {}
        category_names = list(set([p['category'] for p in SAMPLE_PRODUCTS]))
        
        for cat_name in category_names:
            cursor.execute("""
                INSERT INTO categories (vertical_id, name, slug, level, full_path)
                VALUES (%s, %s, %s, 1, %s)
                ON CONFLICT DO NOTHING
                RETURNING id
            """, (vertical_id, cat_name, cat_name.lower(), f"supermarket/{cat_name.lower()}"))
            
            result = cursor.fetchone()
            if result:
                cat_id = result[0]
            else:
                cursor.execute("""
                    SELECT id FROM categories 
                    WHERE vertical_id = %s AND slug = %s
                """, (vertical_id, cat_name.lower()))
                cat_id = cursor.fetchone()[0]
            
            categories[cat_name] = cat_id
            print(f"   ✅ {cat_name}: ID {cat_id}")
        
        # 3. Create suppliers (chains + stores)
        print("\n3️⃣ Creating suppliers (stores)...")
        suppliers = []
        store_index = 0
        
        for chain in CHAINS:
            for store in chain['stores']:
                cursor.execute("""
                    INSERT INTO suppliers (name, slug, country_code, city, supplier_type)
                    VALUES (%s, %s, 'IL', %s, 'supermarket')
                    ON CONFLICT (slug) DO NOTHING
                    RETURNING id
                """, (
                    f"{chain['name']} - {store['name']}",
                    f"{chain['name_en']}-{store['city']}".lower().replace(' ', '-'),
                    store['city']
                ))
                
                result = cursor.fetchone()
                if result:
                    supplier_id = result[0]
                else:
                    cursor.execute(
                        "SELECT id FROM suppliers WHERE slug = %s",
                        (f"{chain['name_en']}-{store['city']}".lower().replace(' ', '-'),)
                    )
                    supplier_id = cursor.fetchone()[0]
                
                suppliers.append({
                    'id': supplier_id,
                    'name': store['name'],
                    'chain': chain['name'],
                    'index': store_index
                })
                
                print(f"   ✅ {chain['name']} - {store['name']}: ID {supplier_id}")
                store_index += 1
        
        # 4. Create products and prices
        print("\n4️⃣ Creating products and prices...")
        products_added = 0
        prices_added = 0
        
        for idx, product_data in enumerate(SAMPLE_PRODUCTS):
            category_id = categories[product_data['category']]
            
            # Create product
            cursor.execute("""
                INSERT INTO products (name, vertical_id, category_id, attributes)
                VALUES (%s, %s, %s, %s)
                ON CONFLICT DO NOTHING
                RETURNING id
            """, (
                product_data['name'],
                vertical_id,
                category_id,
                json.dumps({
                    'barcode': product_data['barcode'],
                    'manufacturer': product_data['manufacturer']
                })
            ))
            
            result = cursor.fetchone()
            if result:
                product_id = result[0]
                products_added += 1
            else:
                cursor.execute("""
                    SELECT id FROM products 
                    WHERE name = %s AND vertical_id = %s
                """, (product_data['name'], vertical_id))
                product_id = cursor.fetchone()[0]
            
            # Add prices for each store (with variations)
            for supplier in suppliers:
                price = generate_price_variation(
                    product_data['base_price'],
                    supplier['index'],
                    idx
                )
                
                cursor.execute("""
                    INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
                    VALUES (%s, %s, %s, 'ILS', NOW())
                """, (product_id, supplier['id'], price))
                
                prices_added += 1
        
        conn.commit()
        cursor.close()
        conn.close()
        
        print("\n" + "="*60)
        print("✅ Demo Data Created Successfully!")
        print("="*60)
        print(f"Vertical: Supermarkets")
        print(f"Categories: {len(categories)}")
        print(f"Suppliers (stores): {len(suppliers)}")
        print(f"Products: {products_added}")
        print(f"Prices: {prices_added}")
        print("="*60)
        
        return True
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        return False


if __name__ == "__main__":
    DB_CONFIG = {
        'host': 'localhost',
        'port': 5432,
        'database': 'gogobe',
        'user': 'postgres',
        'password': '9152245-Gl!'
    }
    
    create_demo_data(DB_CONFIG)

