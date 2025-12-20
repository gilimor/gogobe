#!/usr/bin/env python3
"""
Populate stores table from product attributes
Extracts store information from products.attributes and creates store records
"""

import psycopg2
from psycopg2.extras import RealDictCursor
import os
import json
from collections import defaultdict

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

def extract_stores_from_products(conn):
    """Extract unique store information from product attributes"""
    stores_data = {}
    
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        # Get all products with store information in attributes
        cur.execute("""
            SELECT DISTINCT
                attributes->'chain_id' as chain_id,
                attributes->'store_id' as store_id,
                attributes->'store_name' as store_name,
                attributes->'bikoret_no' as bikoret_no,
                attributes->'subchain_id' as subchain_id
            FROM products
            WHERE attributes->>'store_id' IS NOT NULL
                AND attributes->>'store_name' IS NOT NULL
        """)
        
        products = cur.fetchall()
        print(f"📊 Found {len(products)} products with store information")
        
        # Group by store_id to deduplicate
        for product in products:
            store_id = product['store_id']
            if store_id and isinstance(store_id, str):
                store_id = store_id.strip('"')
                
                if store_id not in stores_data:
                    store_name = product['store_name']
                    if store_name and isinstance(store_name, str):
                        store_name = store_name.strip('"')
                    
                    bikoret_no = product['bikoret_no']
                    if bikoret_no and isinstance(bikoret_no, str):
                        bikoret_no = bikoret_no.strip('"')
                    
                    stores_data[store_id] = {
                        'store_id': store_id,
                        'store_name': store_name,
                        'bikoret_no': bikoret_no
                    }
        
        print(f"🏪 Found {len(stores_data)} unique stores")
        return stores_data

def populate_stores(conn, stores_data):
    """Create store records in the database"""
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        # Get KingStore chain ID
        cur.execute("SELECT id FROM chains WHERE slug = 'kingstore'")
        chain = cur.fetchone()
        
        if not chain:
            print("❌ KingStore chain not found!")
            return
        
        chain_id = chain['id']
        print(f"✅ KingStore chain_id: {chain_id}")
        
        created = 0
        updated = 0
        
        for store_id, store_info in stores_data.items():
            try:
                # Use the get_or_create_store function
                cur.execute("""
                    SELECT get_or_create_store(%s, %s, %s, NULL, %s)
                """, (
                    chain_id,
                    store_info['store_id'],
                    store_info['store_name'],
                    store_info['bikoret_no']
                ))
                
                result = cur.fetchone()
                if result:
                    created += 1
                    if created % 10 == 0:
                        print(f"  ✓ Created/Updated {created} stores...")
                
            except Exception as e:
                print(f"❌ Error creating store {store_id}: {e}")
                continue
        
        conn.commit()
        print(f"\n✅ Store population complete:")
        print(f"   - Total stores processed: {len(stores_data)}")
        print(f"   - Successfully created/updated: {created}")

def update_prices_with_store_ids(conn):
    """Update existing prices with store_id based on product attributes"""
    print("\n🔄 Updating prices with store_ids...")
    
    with conn.cursor() as cur:
        # Update prices by matching store_id from product attributes
        cur.execute("""
            UPDATE prices pr
            SET store_id = s.id
            FROM products p
            JOIN stores s ON s.store_id = p.attributes->>'store_id'
            WHERE pr.product_id = p.id
                AND pr.store_id IS NULL
                AND p.attributes->>'store_id' IS NOT NULL
        """)
        
        updated = cur.rowcount
        conn.commit()
        print(f"✅ Updated {updated:,} price records with store_ids")

def display_store_stats(conn):
    """Display statistics about stores"""
    print("\n📊 Store Statistics:")
    
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        # Store count
        cur.execute("SELECT COUNT(*) as count FROM stores")
        store_count = cur.fetchone()['count']
        print(f"   Total stores: {store_count}")
        
        # Stores with prices
        cur.execute("""
            SELECT COUNT(DISTINCT store_id) as count 
            FROM prices 
            WHERE store_id IS NOT NULL
        """)
        stores_with_prices = cur.fetchone()['count']
        print(f"   Stores with prices: {stores_with_prices}")
        
        # Top stores by product count
        cur.execute("""
            SELECT 
                s.name,
                s.store_id,
                s.bikoret_no,
                COUNT(DISTINCT pr.product_id) as product_count,
                COUNT(pr.id) as price_count
            FROM stores s
            LEFT JOIN prices pr ON pr.store_id = s.id
            GROUP BY s.id, s.name, s.store_id, s.bikoret_no
            ORDER BY product_count DESC
            LIMIT 10
        """)
        
        top_stores = cur.fetchall()
        if top_stores:
            print("\n   Top 10 stores by product count:")
            for store in top_stores:
                print(f"     - {store['name']} (ID: {store['store_id']}, ביקורת: {store['bikoret_no']})")
                print(f"       {store['product_count']:,} products, {store['price_count']:,} prices")

def main():
    print("=" * 60)
    print("🏪 POPULATE STORES FROM PRODUCT ATTRIBUTES")
    print("=" * 60)
    
    conn = get_db_connection()
    if not conn:
        return
    
    try:
        # Step 1: Extract store data from products
        stores_data = extract_stores_from_products(conn)
        
        if not stores_data:
            print("⚠️  No store data found in products")
            return
        
        # Step 2: Populate stores table
        populate_stores(conn, stores_data)
        
        # Step 3: Update prices with store_ids
        update_prices_with_store_ids(conn)
        
        # Step 4: Display statistics
        display_store_stats(conn)
        
        print("\n✅ Store population completed successfully!")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        conn.rollback()
    finally:
        conn.close()

if __name__ == "__main__":
    main()

