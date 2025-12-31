import psycopg2
import os

DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432')
}

def check_data():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        print("--- Checking Products ---")
        cur.execute("SELECT COUNT(*) FROM products;")
        print(f"Total Products: {cur.fetchone()[0]}")
        
        cur.execute("SELECT COUNT(*) FROM products WHERE is_active = TRUE;")
        print(f"Active Products: {cur.fetchone()[0]}")
        
        print("\n--- Searching for 'קוקה' ---")
        cur.execute("SELECT id, name, is_active FROM products WHERE name ILIKE '%קוקה%' LIMIT 5;")
        rows = cur.fetchall()
        if rows:
            for r in rows:
                print(r)
        else:
            print("No matches found for 'קוקה'")

        print("\n--- Sample Products ---")
        cur.execute("SELECT id, name, is_active FROM products LIMIT 5;")
        for r in cur.fetchall():
            print(r)
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if 'conn' in locals() and conn:
            conn.close()

if __name__ == "__main__":
    check_data()
