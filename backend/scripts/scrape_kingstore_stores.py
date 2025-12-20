"""
Scrape KingStore store names from https://kingstore.binaprojects.com/Main.aspx
and update the stores table with proper names
"""

import requests
from bs4 import BeautifulSoup
import psycopg2
import os
import re

# Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', 5432),
    'database': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', 'postgres'),
    'client_encoding': 'UTF8'
}

def get_db_connection():
    """Create database connection"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except Exception as e:
        print(f"❌ Database connection failed: {e}")
        return None

def scrape_kingstore_stores():
    """
    Scrape store information from KingStore website
    Returns: dict of {store_id: store_name}
    """
    url = "https://kingstore.binaprojects.com/Main.aspx"
    
    print(f"📡 Fetching data from: {url}")
    
    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Find the table with store data
        stores = {}
        
        # Look for rows in the table
        # The structure: | שם קובץ | סניף | סוג | סיומת | תאריך |
        rows = soup.find_all('tr')
        
        print(f"📊 Found {len(rows)} rows in table")
        
        for row in rows:
            cols = row.find_all('td')
            if len(cols) >= 2:
                # Column 0: filename
                # Column 1: store name (סניף)
                filename = cols[0].get_text(strip=True)
                store_name = cols[1].get_text(strip=True)
                
                # Extract store ID from filename
                # Example: PricesFull7290058179503-015-202501201040.xml
                match = re.search(r'-(\d+)-', filename)
                if match:
                    store_id = match.group(1).lstrip('0')  # Remove leading zeros
                    if store_name and store_name != '-':
                        stores[store_id] = store_name
                        print(f"  ✓ סניף {store_id}: {store_name}")
        
        print(f"\n✅ Found {len(stores)} stores with names")
        return stores
        
    except Exception as e:
        print(f"❌ Error scraping website: {e}")
        return {}

def update_store_names(conn, stores_data):
    """Update store names in database"""
    print("\n🔄 Updating store names in database...")
    
    with conn.cursor() as cur:
        # Get KingStore chain ID
        cur.execute("SELECT id FROM chains WHERE slug = 'kingstore'")
        chain = cur.fetchone()
        
        if not chain:
            print("❌ KingStore chain not found!")
            return
        
        chain_id = chain[0]
        updated = 0
        
        for store_id, store_name in stores_data.items():
            try:
                cur.execute("""
                    UPDATE stores 
                    SET name = %s,
                        name_he = %s
                    WHERE chain_id = %s 
                      AND store_id = %s
                    RETURNING id
                """, (store_name, store_name, chain_id, store_id))
                
                if cur.fetchone():
                    updated += 1
                    print(f"  ✓ Updated: סניף {store_id} → {store_name}")
                else:
                    # Store doesn't exist, create it
                    cur.execute("""
                        INSERT INTO stores (chain_id, store_id, name, name_he)
                        VALUES (%s, %s, %s, %s)
                        ON CONFLICT (chain_id, store_id) DO UPDATE
                        SET name = EXCLUDED.name,
                            name_he = EXCLUDED.name_he
                    """, (chain_id, store_id, store_name, store_name))
                    updated += 1
                    print(f"  ✓ Created: סניף {store_id} → {store_name}")
                
            except Exception as e:
                print(f"❌ Error updating store {store_id}: {e}")
                continue
        
        conn.commit()
        print(f"\n✅ Updated {updated} stores")

def display_results(conn):
    """Display updated store information"""
    print("\n📊 Updated Store List:")
    
    with conn.cursor() as cur:
        cur.execute("""
            SELECT 
                s.store_id,
                s.name,
                s.city,
                s.address,
                COUNT(DISTINCT pr.product_id) as product_count
            FROM stores s
            JOIN chains c ON s.chain_id = c.id
            LEFT JOIN prices pr ON pr.store_id = s.id
            WHERE c.slug = 'kingstore'
            GROUP BY s.id, s.store_id, s.name, s.city, s.address
            ORDER BY s.store_id
        """)
        
        stores = cur.fetchall()
        
        for store in stores:
            store_id, name, city, address, product_count = store
            print(f"\n  סניף {store_id}: {name}")
            if city:
                print(f"    📍 {city}, {address or ''}")
            print(f"    📦 {product_count:,} מוצרים")

def main():
    print("=" * 60)
    print("🏪 KINGSTORE STORE NAMES SCRAPER")
    print("=" * 60)
    print(f"Source: https://kingstore.binaprojects.com/Main.aspx")
    print("=" * 60)
    
    # Step 1: Scrape website
    stores_data = scrape_kingstore_stores()
    
    if not stores_data:
        print("\n⚠️ No store data found")
        return
    
    # Step 2: Connect to database
    conn = get_db_connection()
    if not conn:
        return
    
    try:
        # Step 3: Update database
        update_store_names(conn, stores_data)
        
        # Step 4: Display results
        display_results(conn)
        
        print("\n✅ Store names update completed successfully!")
        print("\n💡 Next steps:")
        print("   1. Run this script regularly to keep store names updated")
        print("   2. Consider adding GOV.IL API for full store details (address, phone)")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        conn.rollback()
    finally:
        conn.close()

if __name__ == "__main__":
    main()

