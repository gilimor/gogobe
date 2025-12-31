
import psycopg2

def fix_locations():
    try:
        conn = psycopg2.connect(dbname='gogobe', user='postgres', password='9152245-Gl!', host='db')
        cur = conn.cursor()
        
        # Update Tokyo (Toyosu Market)
        # Found ID: 73096 or pattern JP_TOKYO_MARKET_TOKYO_TOYOSU_MARKET
        cur.execute("UPDATE stores SET latitude = 35.646564, longitude = 139.787640 WHERE store_id LIKE '%TOYOSU_MARKET%'")
        print(f"Updated {cur.rowcount} Tokyo stores")
        
        conn.commit()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    fix_locations()
