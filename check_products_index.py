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

def check_products_index():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    try:
        cur.execute("""
            SELECT indexname, indexdef 
            FROM pg_indexes 
            WHERE tablename = 'products' 
            AND indexname = 'idx_products_ean'
        """)
        idx = cur.fetchone()
        if idx:
            print(f"Index Found: {idx[0]}")
            print(f"Definition: {idx[1]}")
            if "UNIQUE" in idx[1].upper():
                print(" -> IS UNIQUE")
            else:
                print(" -> NOT UNIQUE (PROBLEM!)")
        else:
            print("Index idx_products_ean NOT FOUND")
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    check_products_index()
