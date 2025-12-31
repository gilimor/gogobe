import sys
import psycopg2
import os

DB_CONFIG = {
    'dbname': 'gogobe',
    'user': 'postgres',
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': 'localhost',
    'port': '5432'
}

def verify_constraint():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    try:
        # Check if constraint exists definitively
        cur.execute("""
            SELECT conname 
            FROM pg_constraint 
            WHERE conrelid = 'prices'::regclass 
            AND conname = 'prices_unique_key'
        """)
        found = cur.fetchone()
        if not found:
            print("CRITICAL: Constraint 'prices_unique_key' NOT FOUND in pg_constraint!")
            return
        
        print(f"Constraint Found: {found[0]}")
        
        # Try a dummy upsert via Temp Table (matching scraper logic)
        cur.execute("SELECT id FROM products LIMIT 1")
        pid = cur.fetchone()[0]
        cur.execute("SELECT id FROM suppliers LIMIT 1")
        sid = cur.fetchone()[0]
        cur.execute("SELECT id FROM stores LIMIT 1")
        stid = cur.fetchone()[0]
        
        print(f"Testing UPSERT via TEMP TABLE with PID={pid}, SID={sid}, STID={stid}")
        
        # Create temp table
        cur.execute("CREATE TEMP TABLE prices_temp (LIKE prices INCLUDING DEFAULTS)")
        
        # Insert into temp
        cur.execute("""
            INSERT INTO prices_temp (product_id, supplier_id, store_id, price, first_scraped_at)
            VALUES (%s, %s, %s, 88.88, NOW())
        """, (pid, sid, stid))
        
        # Perform Upsert
        sql = """
            INSERT INTO prices (product_id, supplier_id, store_id, price, first_scraped_at)
            SELECT product_id, supplier_id, store_id, price, first_scraped_at FROM prices_temp
            ON CONFLICT ON CONSTRAINT "prices_unique_key"
            DO UPDATE SET price = 88.88
        """
        try:
            cur.execute(sql)
            conn.commit()
            print("UPSERT via TEMP SUCCESS!")
        except Exception as e:
            print(f"UPSERT via TEMP FAILED: {e}")
            conn.rollback()
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    verify_constraint()
