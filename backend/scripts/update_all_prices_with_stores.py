#!/usr/bin/env python3
"""
Update ALL prices with store_id based on product attributes
Even for older prices that don't have store info in attributes
"""

import psycopg2
from psycopg2.extras import RealDictCursor
import os

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

def update_all_prices_with_stores(conn):
    """
    Update ALL prices with store_id
    Strategy: If product has store_id in attributes, use it for ALL prices of that product
    """
    print("\n🔄 Updating ALL prices with store_ids...")
    
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        # Get all products that have store_id in attributes
        cur.execute("""
            SELECT DISTINCT
                p.id as product_id,
                p.attributes->>'store_id' as store_id_str,
                s.id as store_db_id
            FROM products p
            JOIN stores s ON s.store_id = p.attributes->>'store_id'
            WHERE p.attributes->>'store_id' IS NOT NULL
        """)
        
        products_with_stores = cur.fetchall()
        print(f"📊 Found {len(products_with_stores)} products with store information")
        
        updated = 0
        for product in products_with_stores:
            # Update ALL prices for this product with the store_id
            cur.execute("""
                UPDATE prices
                SET store_id = %s
                WHERE product_id = %s
                  AND store_id IS NULL
            """, (product['store_db_id'], product['product_id']))
            
            updated += cur.rowcount
            
            if updated % 1000 == 0 and updated > 0:
                print(f"  ✓ Updated {updated:,} prices...")
                conn.commit()
        
        conn.commit()
        print(f"\n✅ Updated {updated:,} prices with store_ids")
        
        # Show statistics
        cur.execute("""
            SELECT 
                COUNT(*) as total_prices,
                COUNT(store_id) as with_store,
                COUNT(*) - COUNT(store_id) as without_store
            FROM prices
        """)
        stats = cur.fetchone()
        
        print(f"\n📊 Price Statistics:")
        print(f"   Total prices: {stats['total_prices']:,}")
        print(f"   With store: {stats['with_store']:,} ({100*stats['with_store']/stats['total_prices']:.1f}%)")
        print(f"   Without store: {stats['without_store']:,} ({100*stats['without_store']/stats['total_prices']:.1f}%)")

def main():
    print("=" * 60)
    print("🔄 UPDATE ALL PRICES WITH STORE IDS")
    print("=" * 60)
    
    conn = get_db_connection()
    if not conn:
        return
    
    try:
        update_all_prices_with_stores(conn)
        print("\n✅ Update completed successfully!")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        conn.rollback()
    finally:
        conn.close()

if __name__ == "__main__":
    main()

