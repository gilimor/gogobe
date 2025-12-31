
import os
import psycopg2
from psycopg2.extras import RealDictCursor

DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432'),
}

def check_and_fix():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor(cursor_factory=RealDictCursor)
        
        print("\n=== FUEL IMPORT CURRENCY CHECK ===\n")
        
        # Italy
        cur.execute("SELECT id FROM chains WHERE name='MIMIT Carburanti'")
        it_id = cur.fetchone()['id']
        cur.execute("""
            SELECT currency, COUNT(*) as cnt 
            FROM prices p JOIN stores s ON p.store_id = s.id
            WHERE s.chain_id = %s
            GROUP BY currency
        """, (it_id,))
        print(f"🇮🇹 Italy (ID {it_id}):")
        for row in cur.fetchall():
            print(f"   {row['currency']}: {row['cnt']}")
            
        # France
        cur.execute("SELECT id FROM chains WHERE name='Prix Carburants France'")
        fr_id = cur.fetchone()['id']
        cur.execute("""
            SELECT currency, COUNT(*) as cnt 
            FROM prices p JOIN stores s ON p.store_id = s.id
            WHERE s.chain_id = %s
            GROUP BY currency
        """, (fr_id,))
        print(f"🇫🇷 France (ID {fr_id}):")
        for row in cur.fetchall():
            print(f"   {row['currency']}: {row['cnt']}")

        print("\n=== FIXING CURRENCIES TO EUR ===\n")
        
        # Repair Italy
        cur.execute("""
            UPDATE prices SET currency='EUR' 
            WHERE store_id IN (SELECT id FROM stores WHERE chain_id=%s) 
            AND currency != 'EUR'
        """, (it_id,))
        it_fixed = cur.rowcount
        print(f"Fixed {it_fixed} Italian prices to EUR.")
        
        # Repair France
        cur.execute("""
            UPDATE prices SET currency='EUR' 
            WHERE store_id IN (SELECT id FROM stores WHERE chain_id=%s) 
            AND currency != 'EUR'
        """, (fr_id,))
        fr_fixed = cur.rowcount
        print(f"Fixed {fr_fixed} French prices to EUR.")
        
        conn.commit()
        conn.close()
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_and_fix()
