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

def check_prices_columns():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    try:
        cur.execute("""
            SELECT column_name, data_type 
            FROM information_schema.columns 
            WHERE table_name = 'prices'
        """)
        columns = cur.fetchall()
        print("Prices Columns:")
        for c in columns:
            print(f" - {c[0]} ({c[1]})")
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    check_prices_columns()
