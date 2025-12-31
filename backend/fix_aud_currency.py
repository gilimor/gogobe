
import os
import psycopg2

DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432'),
}

def add_aud():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        print("Adding AUD currency...")
        cur.execute("""
            INSERT INTO currencies (code, name, symbol) 
            VALUES ('AUD', 'Australian Dollar', 'A$') 
            ON CONFLICT (code) DO NOTHING
        """)
        
        conn.commit()
        print("AUD added successfully.")
        conn.close()
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    add_aud()
