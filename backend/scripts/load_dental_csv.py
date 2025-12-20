"""
Load dental products from CSV into Gogobe database
"""
import csv
import psycopg2
from datetime import datetime
import os

# Database connection
DB_CONFIG = {
    'dbname': 'gogobe',
    'user': 'postgres',
    'password': '9152245-Gl!',
    'host': 'localhost',
    'port': '5432'
}

# CSV file path
CSV_PATH = r"C:\Users\shake\Limor Shaked Dropbox\LIMOR SHAKED ADVANCED COSMETICS LTD\Gogobe\Doc\dentistry_prices_june2024.csv"

def connect_db():
    """Connect to database"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        print("✅ Connected to database 'gogobe'")
        return conn
    except Exception as e:
        print(f"❌ Connection failed: {e}")
        return None

def get_or_create_vertical(cursor, name='Dental Equipment'):
    """Get dental vertical ID"""
    cursor.execute("SELECT id FROM verticals WHERE slug = 'dental'")
    result = cursor.fetchone()
    return result[0] if result else None

def get_or_create_category(cursor, vertical_id, category_name):
    """Get or create category"""
    # Normalize category name
    slug = category_name.lower().replace(' ', '-').replace('&', 'and')
    
    cursor.execute("""
        SELECT id FROM categories 
        WHERE vertical_id = %s AND slug = %s
    """, (vertical_id, slug))
    
    result = cursor.fetchone()
    
    if result:
        return result[0]
    else:
        # Create new category
        cursor.execute("""
            INSERT INTO categories (vertical_id, name, slug, level, full_path)
            VALUES (%s, %s, %s, 1, %s)
            RETURNING id
        """, (vertical_id, category_name, slug, f"dental/{slug}"))
        
        return cursor.fetchone()[0]

def get_or_create_supplier(cursor, supplier_name, website=None, country_code='GB'):
    """Get or create supplier"""
    slug = supplier_name.lower().replace(' ', '-').replace('.', '')
    
    cursor.execute("""
        SELECT id FROM suppliers WHERE slug = %s
    """, (slug,))
    
    result = cursor.fetchone()
    
    if result:
        return result[0]
    else:
        # Create new supplier
        cursor.execute("""
            INSERT INTO suppliers 
            (name, slug, website, country_code, supplier_type, verticals, ships_internationally)
            VALUES (%s, %s, %s, %s, 'retailer', ARRAY['dental'], TRUE)
            RETURNING id
        """, (supplier_name, slug, website, country_code))
        
        print(f"   Created supplier: {supplier_name}")
        return cursor.fetchone()[0]

def load_csv_data():
    """Load data from CSV"""
    conn = connect_db()
    if not conn:
        return
    
    cursor = conn.cursor()
    
    # Get dental vertical
    vertical_id = get_or_create_vertical(cursor)
    if not vertical_id:
        print("❌ Could not find dental vertical")
        return
    
    print(f"\n📂 Loading products from: {CSV_PATH}\n")
    
    # Read CSV
    with open(CSV_PATH, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        loaded = 0
        skipped = 0
        
        for row in reader:
            try:
                # Extract data
                product_name = row['Product_Name']
                supplier_name = row['Supplier']
                category_name = row['Category']
                price = float(row['Price_GBP']) if row['Price_GBP'] else None
                currency = row['Currency'] or 'GBP'
                description = row['Description']
                features = row['Features']
                website = row['Contact_Website']
                
                # Skip non-product items
                if category_name in ['Government Scheme', 'Education', 'Event', 'Subscription']:
                    print(f"⏭️  Skipping: {product_name} (not a product)")
                    skipped += 1
                    continue
                
                print(f"📦 Loading: {product_name}")
                
                # Get or create category
                category_id = get_or_create_category(cursor, vertical_id, category_name)
                
                # Get or create supplier
                supplier_id = get_or_create_supplier(cursor, supplier_name, website)
                
                # Check if product exists
                cursor.execute("""
                    SELECT id FROM products WHERE name = %s
                """, (product_name,))
                
                existing = cursor.fetchone()
                
                if existing:
                    product_id = existing[0]
                    print(f"   ✓ Product exists (ID: {product_id})")
                else:
                    # Create product
                    cursor.execute("""
                        INSERT INTO products 
                        (name, description, vertical_id, category_id, 
                         main_image_url, is_active, attributes)
                        VALUES (%s, %s, %s, %s, %s, TRUE, %s)
                        RETURNING id
                    """, (
                        product_name,
                        description,
                        vertical_id,
                        category_id,
                        None,  # No image yet
                        {
                            'features': features.split('; ') if features else [],
                            'warranty': row['Warranty'],
                            'source': 'Dentistry Magazine June 2024'
                        }
                    ))
                    
                    product_id = cursor.fetchone()[0]
                    print(f"   ✅ Created product (ID: {product_id})")
                
                # Add price
                if price:
                    cursor.execute("""
                        INSERT INTO prices 
                        (product_id, supplier_id, price, currency, 
                         is_available, source_url, scraped_at)
                        VALUES (%s, %s, %s, %s, TRUE, %s, %s)
                    """, (
                        product_id,
                        supplier_id,
                        price,
                        currency,
                        f"https://{website}" if website else None,
                        datetime.now()
                    ))
                    
                    print(f"   💰 Price: £{price}")
                
                loaded += 1
                
            except Exception as e:
                print(f"   ❌ Error: {e}")
                conn.rollback()
                continue
        
        # Commit all changes
        conn.commit()
        print(f"\n{'='*50}")
        print(f"✅ Loaded: {loaded} products")
        print(f"⏭️  Skipped: {skipped} non-products")
        print(f"{'='*50}\n")
    
    # Show summary
    cursor.execute("SELECT COUNT(*) FROM products WHERE vertical_id = %s", (vertical_id,))
    total_products = cursor.fetchone()[0]
    
    cursor.execute("SELECT COUNT(*) FROM prices")
    total_prices = cursor.fetchone()[0]
    
    print(f"📊 Database Summary:")
    print(f"   Products: {total_products}")
    print(f"   Prices: {total_prices}")
    print(f"   Suppliers: ", end='')
    
    cursor.execute("SELECT COUNT(*) FROM suppliers WHERE 'dental' = ANY(verticals)")
    print(cursor.fetchone()[0])
    
    cursor.close()
    conn.close()

if __name__ == "__main__":
    print("="*50)
    print("🦷 Gogobe - Load Dental Products")
    print("="*50)
    print()
    
    load_csv_data()
    
    print("\n✅ Done!")
    print("\nNext steps:")
    print("1. Check products: SELECT * FROM products;")
    print("2. Check prices: SELECT * FROM prices;")
    print("3. Build a scraper to get more products!")






