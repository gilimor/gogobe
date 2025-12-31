import psycopg2
import os

DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432')
}

def check_prices():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        # Check prices for a sample product found earlier
        pid = 53695 # 'קוקה קולה 330 מ"ל'
        print(f"--- Checking Prices for Product ID {pid} ---")
        cur.execute("SELECT count(*) FROM prices WHERE product_id = %s;", (pid,))
        count = cur.fetchone()[0]
        print(f"Price count: {count}")
        
        if count == 0:
            print("WARNING: Product exists but has NO prices.")
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if 'conn' in locals() and conn:
            conn.close()

if __name__ == "__main__":
    check_prices()
