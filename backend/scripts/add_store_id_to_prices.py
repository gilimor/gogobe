#!/usr/bin/env python3
"""Add store_id column to prices table"""

import sys
sys.path.insert(0, 'backend/database')
from db_connection import get_db_connection

def main():
    conn = get_db_connection()
    cur = conn.cursor()
    
    print("=" * 70)
    print("ADDING store_id COLUMN TO prices TABLE")
    print("=" * 70)
    
    try:
        # Add column
        print("\n1. Adding store_id column...")
        cur.execute("""
            ALTER TABLE prices 
            ADD COLUMN IF NOT EXISTS store_id INTEGER REFERENCES stores(id)
        """)
        print("   ✅ Column added")
        
        # Create indexes
        print("\n2. Creating indexes...")
        cur.execute("""
            CREATE INDEX IF NOT EXISTS idx_prices_store_id ON prices(store_id)
        """)
        cur.execute("""
            CREATE INDEX IF NOT EXISTS idx_prices_store_product ON prices(store_id, product_id)
        """)
        print("   ✅ Indexes created")
        
        # Add comment
        print("\n3. Adding column comment...")
        cur.execute("""
            COMMENT ON COLUMN prices.store_id IS 'The specific store where this price was found'
        """)
        print("   ✅ Comment added")
        
        conn.commit()
        
        print("\n" + "=" * 70)
        print("✅ SUCCESS - store_id column added to prices table")
        print("=" * 70)
        
        # Verify
        cur.execute("""
            SELECT column_name, data_type, is_nullable
            FROM information_schema.columns
            WHERE table_name = 'prices' AND column_name = 'store_id'
        """)
        result = cur.fetchone()
        if result:
            print(f"\nColumn details: {result[0]} ({result[1]}) - Nullable: {result[2]}")
        
    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        conn.rollback()
        return 1
    finally:
        cur.close()
        conn.close()
    
    return 0

if __name__ == "__main__":
    sys.exit(main())








