
import psycopg2
import os

def check_tokyo():
    try:
        conn = psycopg2.connect(
            dbname='gogobe', 
            user='postgres', 
            password='9152245-Gl!', 
            host='db'
        )
        cur = conn.cursor()
        cur.execute("SELECT id, store_id, name, latitude, longitude FROM stores WHERE store_id LIKE 'TOKYO%'")
        rows = cur.fetchall()
        print("Tokyo Stores:")
        for r in rows:
            print(r)
            
        cur.execute("SELECT id, store_id, name, latitude, longitude FROM stores WHERE store_id LIKE 'WA_%' LIMIT 5")
        rows = cur.fetchall()
        print("\nWA Stores (Sample):")
        for r in rows:
            print(r)
            
        conn.close()
    except Exception as e:
        print(e)

if __name__ == "__main__":
    check_tokyo()
