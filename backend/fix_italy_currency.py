
import os
import psycopg2

DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432'),
}

def fix():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        print("Fixing Italy Currency to EUR...")
        
        # Get Chain ID
        cur.execute("SELECT id FROM chains WHERE name='MIMIT Carburanti'")
        chain = cur.fetchone()
        if not chain:
            print("Chain not found!")
            return
            
        chain_id = chain[0]
        
        # Update
        cur.execute("""
            UPDATE prices 
            SET currency = 'EUR'
            WHERE store_id IN (
                SELECT id FROM stores WHERE chain_id = %s
            ) AND currency != 'EUR'
        """, (chain_id,))
        
        print(f"Updated {cur.rowcount} rows.")
        conn.commit()
        conn.close()
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    fix()
