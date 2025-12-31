import psycopg2
import os
import random
from datetime import datetime, timedelta

# DB Config
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'localhost'), # Assuming local run for this script
    'port': os.getenv('DB_PORT', '5432')
}

def inject_history():
    print("--- INJECTING MOCK HISTORY FOR DEMO ---")
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        # 1. Get 20 random products
        cur.execute("SELECT id, name FROM products LIMIT 50;")
        products = cur.fetchall()
        
        if not products:
            print("No products found! Import something first.")
            return

        print(f"Injecting history for {len(products)} products...")
        
        for p in products:
            pid = p[0]
            # Create a price from 7 days ago
            base_price = random.uniform(10.0, 100.0)
            
            # Make some DROP (-20%)
            if random.random() > 0.5:
                old_price = base_price * 1.3
                new_price = base_price
            # Make some HIKE (+20%)
            else:
                old_price = base_price * 0.8
                new_price = base_price
                
            # Insert OLD price (7 days ago)
            cur.execute("""
                INSERT INTO prices (product_id, store_id, price, currency, scraped_at)
                VALUES (%s, 1, %s, 'ILS', NOW() - INTERVAL '7 days');
            """, (pid, old_price))
            
            # Insert NEW price (Today)
            cur.execute("""
                INSERT INTO prices (product_id, store_id, price, currency, scraped_at)
                VALUES (%s, 1, %s, 'ILS', NOW());
            """, (pid, new_price))
            
        conn.commit()
        print("Done. Now run Recalc Stats via API.")
        
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if conn: conn.close()

if __name__ == "__main__":
    inject_history()
