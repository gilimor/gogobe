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

def list_constraints():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    try:
        cur.execute("""
            SELECT conname, pg_get_constraintdef(oid) 
            FROM pg_constraint 
            WHERE conrelid = 'prices'::regclass
        """)
        constraints = cur.fetchall()
        print("Constraints on 'prices':")
        found = False
        for c in constraints:
            print(f" - {c[0]}: {c[1]}")
            if c[0] == 'prices_unique_key':
                found = True
        
        if not found:
            print("ERROR: prices_unique_key NOT FOUND!")
        else:
            print("SUCCESS: prices_unique_key FOUND.")
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    list_constraints()
