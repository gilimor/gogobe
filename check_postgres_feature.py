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

def check_feature():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    try:
        print("Checking Postgres Version...")
        cur.execute("SELECT version()")
        print(cur.fetchone()[0])
        
        print("\nChecking UNIQUE NULLS NOT DISTINCT support...")
        try:
            cur.execute("""
                CREATE TABLE test_unique_nulls (
                    id int,
                    val int,
                    UNIQUE NULLS NOT DISTINCT (id, val)
                )
            """)
            print(" -> SUPPORTED!")
            cur.execute("DROP TABLE test_unique_nulls")
        except Exception as e:
            print(f" -> NOT SUPPORTED: {e}")
            conn.rollback()

    except Exception as e:
        print(f"Error: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    check_feature()
