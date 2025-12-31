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

def test_insert():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    try:
        # Get a product and supplier and store
        cur.execute("SELECT id FROM products LIMIT 1")
        pid = cur.fetchone()[0]
        cur.execute("SELECT id FROM suppliers LIMIT 1")
        sid = cur.fetchone()[0]
        cur.execute("SELECT id FROM stores LIMIT 1")
        stid = cur.fetchone()[0]
        
        print(f"Testing Insert with: PID={pid}, SID={sid}, STID={stid}")
        
        # Test 1: Inference
        print("Test 1: Inference ON CONFLICT (product_id, supplier_id, store_id)")
        try:
            cur.execute("""
                INSERT INTO prices (product_id, supplier_id, store_id, price, first_scraped_at)
                VALUES (%s, %s, %s, 10.0, NOW())
                ON CONFLICT (product_id, supplier_id, store_id) 
                DO UPDATE SET price = EXCLUDED.price
            """, (pid, sid, stid))
            print(" -> Success")
        except Exception as e:
            print(f" -> FAILED: {e}")
            conn.rollback()
            
        # Test 2: Named Constraint
        print("Test 2: Named Constraint ON CONFLICT ON CONSTRAINT \"prices_unique_key\"")
        try:
            cur.execute("""
                INSERT INTO prices (product_id, supplier_id, store_id, price, first_scraped_at)
                VALUES (%s, %s, %s, 20.0, NOW())
                ON CONFLICT ON CONSTRAINT "prices_unique_key"
                DO UPDATE SET price = EXCLUDED.price
            """, (pid, sid, stid))
            print(" -> Success")
        except Exception as e:
            print(f" -> FAILED: {e}")
            conn.rollback()

        # Test 3: NULL Store ID (Inference)
        print("Test 3: NULL Store (Inference)")
        try:
            cur.execute("""
                INSERT INTO prices (product_id, supplier_id, store_id, price, first_scraped_at)
                VALUES (%s, %s, NULL, 30.0, NOW())
                ON CONFLICT (product_id, supplier_id, store_id) 
                DO UPDATE SET price = EXCLUDED.price
            """, (pid, sid))
            print(" -> Success (But created duplicate?)")
        except Exception as e:
            print(f" -> FAILED: {e}")
            conn.rollback()
            
        # Test 6: Inference with TEMP table + NULL Store (NULLS NOT DISTINCT)
        print("Test 6: Inference with TEMP table + NULL Store (NULLS NOT DISTINCT)")
        
        # Cleanup temp
        cur.execute("DROP TABLE IF EXISTS prices_temp")
        cur.execute("CREATE TEMP TABLE prices_temp (LIKE prices INCLUDING DEFAULTS)")
        
        cur.execute("""
            INSERT INTO prices_temp (product_id, supplier_id, store_id, price, first_scraped_at)
            VALUES (%s, %s, NULL, 60.0, NOW())
        """, (pid, sid))
        
        try:
            cur.execute("""
                INSERT INTO prices (product_id, supplier_id, store_id, price, first_scraped_at)
                SELECT product_id, supplier_id, store_id, price, first_scraped_at FROM prices_temp
                ON CONFLICT (product_id, supplier_id, store_id) 
                DO UPDATE SET price = 60.0
            """)
            print(" -> Success")
        except Exception as e:
            print(f" -> FAILED: {e}")
            conn.rollback()

    except Exception as e:
        print(f"Error fetching IDs: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    test_insert()
