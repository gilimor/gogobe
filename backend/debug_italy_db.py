
import os
import sys
import psycopg2
from psycopg2.extras import RealDictCursor

DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432'),
}

def check_db():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    cur.execute("SELECT * FROM chains WHERE id=1515")
    chain = cur.fetchone()
    print(f"Chain: {chain}")
    
    if chain:
        # Check specific store from log
        cur.execute("SELECT * FROM stores WHERE store_id = 'IT_FUEL_MIMIT_3464'")
        specific = cur.fetchone()
        print(f"Store 3464: {specific}")
        
        cur.execute("SELECT id, store_id FROM stores WHERE chain_id = %s LIMIT 5", (chain['id'],))
        stores = cur.fetchall()
        print("Sample Stores:")
        for s in stores:
            print(f" - {s}")
            
    conn.close()

if __name__ == "__main__":
    check_db()
