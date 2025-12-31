
import psycopg2

def check_spain():
    try:
        conn = psycopg2.connect(dbname='gogobe', user='postgres', password='9152245-Gl!', host='db')
        cur = conn.cursor()
        
        cur.execute("SELECT count(*) FROM prices WHERE currency = 'EUR'")
        print(f"Total EUR prices: {cur.fetchone()[0]}")
        
        cur.execute("SELECT count(*) FROM stores WHERE store_id LIKE 'ES_%'")
        print(f"Total Spain stores: {cur.fetchone()[0]}")
        
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_spain()
