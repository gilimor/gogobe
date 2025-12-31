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

def run_migration():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    try:
        with open('backend/database/create_logging_table.sql', 'r') as f:
            sql = f.read()
            cur.execute(sql)
            conn.commit()
            print("Migration executed successfully.")
    except Exception as e:
        conn.rollback()
        print(f"Migration failed: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    run_migration()
