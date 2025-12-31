
import os
import psycopg2
from psycopg2.extras import RealDictCursor

DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432'),
}

def check_prices():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    # 1. Total Price Count for Italy
    cur.execute("""
        SELECT COUNT(*) as cnt 
        FROM prices pr
        JOIN stores s ON pr.store_id = s.id
        WHERE s.chain_id = (SELECT id FROM chains WHERE slug='mimit_fluels_it')
    """)
    total = cur.fetchone()['cnt']
    print(f"Total Italian Prices: {total}")
    
    if total > 0:
        # 2. Sample Prices
        cur.execute("""
            SELECT 
                pr.price, 
                pr.currency, 
                p.name as product_name,
                s.name as store_name
            FROM prices pr
            JOIN products p ON pr.product_id = p.id
            JOIN stores s ON pr.store_id = s.id
            WHERE s.chain_id = (SELECT id FROM chains WHERE slug='mimit_fluels_it')
            LIMIT 5
        """)
        samples = cur.fetchall()
        for s in samples:
            print(f" - {s['price']} {s['currency']} | {s['product_name']} @ {s['store_name']}")

    conn.close()

if __name__ == "__main__":
    check_prices()
