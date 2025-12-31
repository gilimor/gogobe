import psycopg2
from psycopg2.extras import RealDictCursor
import os

DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432')
}

def inspect():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor(cursor_factory=RealDictCursor)
        
        # Check colums
        cur.execute("SELECT * FROM stores LIMIT 1")
        cols = [desc[0] for desc in cur.description]
        print(f"Columns: {cols}")

        print("\n--- Generic Stores Sample ---")
        cur.execute("""
            SELECT id, chain_id, name, branch_name, city, address 
            FROM stores 
            WHERE name LIKE '%סניף%' OR branch_name LIKE '%סניף%'
            LIMIT 20
        """)
        for row in cur.fetchall():
            print(f"ID: {row['id']} | Chain: {row['chain_id']} | Name: {row['name']} | Branch: {row['branch_name']} | City: {row['city']} | Addr: {row['address']}")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        if 'conn' in locals(): conn.close()

if __name__ == "__main__":
    inspect()
