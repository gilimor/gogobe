
import sys
import os
import psycopg2
from pathlib import Path

# DB Config
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432')
}

def init_global_sources():
    print("Initializing Global Sources in Database...")
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    
    try:
        # 1. Create/Get Suppliers
        suppliers = [
            ('Walmart', 'walmart', 'US'),
            ('Open Food Facts', 'openfoodfacts', 'GL')
        ]
        
        for name, slug, country in suppliers:
            cur.execute("""
                INSERT INTO suppliers (name, slug, country_code, is_active)
                VALUES (%s, %s, %s, TRUE)
                ON CONFLICT (slug) DO UPDATE SET is_active = TRUE
                RETURNING id;
            """, (name, slug, country))
            supp_id = cur.fetchone()[0]
            print(f"✅ Supplier: {name} (ID: {supp_id})")
            
            # 2. Create Chains
            cur.execute("""
                INSERT INTO chains (name, slug, is_active, chain_type)
                VALUES (%s, %s, TRUE, 'online')
                ON CONFLICT (slug) DO UPDATE SET is_active = TRUE
                RETURNING id;
            """, (name, slug))
            chain_id = cur.fetchone()[0]
            print(f"✅ Chain: {name} (ID: {chain_id})")
            
            # 3. Create "Virtual Stores"
            store_name = f"{name} Global/Online"
            store_external_id = f"{slug.upper()}_GLOBAL"
            
            cur.execute("""
                INSERT INTO stores (chain_id, store_id, name, city, is_active)
                VALUES (%s, %s, %s, 'Online', TRUE)
                ON CONFLICT (chain_id, store_id) DO UPDATE SET is_active = TRUE
                RETURNING id;
            """, (chain_id, store_external_id, store_name))
            store_id = cur.fetchone()[0]
            print(f"✅ Store: {store_name} (ID: {store_id})")

        conn.commit()
        print("\nInitialization Complete!")
        
    except Exception as e:
        conn.rollback()
        print(f"Error: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    init_global_sources()
