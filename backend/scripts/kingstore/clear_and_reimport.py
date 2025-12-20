#!/usr/bin/env python3
"""
Clear KingStore data and reimport with correct encoding
"""

import sys
import os
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

import psycopg2

def get_db_connection():
    """Get database connection"""
    return psycopg2.connect(
        dbname=os.getenv('DB_NAME', 'gogobe'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host=os.getenv('DB_HOST', 'db'),
        port=os.getenv('DB_PORT', '5432')
    )

def main():
    """Clear and reimport"""
    print("=" * 80)
    print("CLEARING KINGSTORE DATA")
    print("=" * 80)
    
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        # Get KingStore supplier ID
        cur.execute("SELECT id FROM suppliers WHERE slug = 'kingstore'")
        result = cur.fetchone()
        
        if not result:
            print("KingStore supplier not found!")
            return
        
        supplier_id = result[0]
        print(f"KingStore supplier ID: {supplier_id}")
        
        # Delete all prices from KingStore
        cur.execute("DELETE FROM prices WHERE supplier_id = %s", (supplier_id,))
        deleted_prices = cur.rowcount
        print(f"Deleted {deleted_prices} prices")
        
        # Delete all products from Supermarket vertical that have no prices
        cur.execute("""
            DELETE FROM products 
            WHERE vertical_id = (SELECT id FROM verticals WHERE slug = 'supermarket')
            AND id NOT IN (SELECT DISTINCT product_id FROM prices)
        """)
        deleted_products = cur.rowcount
        print(f"Deleted {deleted_products} products with no prices")
        
        conn.commit()
        print("\n✅ Database cleared successfully!")
        
    except Exception as e:
        print(f"ERROR: {e}")
        conn.rollback()
    finally:
        cur.close()
        conn.close()
    
    print("\n" + "=" * 80)
    print("Now run: python /app/backend/scripts/kingstore_simple_import.py")
    print("=" * 80)

if __name__ == "__main__":
    main()

