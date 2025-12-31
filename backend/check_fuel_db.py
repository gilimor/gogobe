
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

def check():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor(cursor_factory=RealDictCursor)
        
        print("\n=== FUEL IMPORT STATUS ===\n")

        print("\n=== CHAIN DEBUG ===")
        cur.execute("SELECT id, name, slug FROM chains WHERE name LIKE '%Fuel%' OR name LIKE '%MIMIT%' OR name LIKE '%France%'")
        for c in cur.fetchall():
            print(f"ID: {c['id']}, Name: {c['name']}, Slug: {c['slug']}")

        
        # Check Italy by Name
        cur.execute("SELECT id FROM chains WHERE name='MIMIT Carburanti'")
        it_chain = cur.fetchone()
        if it_chain:
            cur.execute("""
                SELECT COUNT(*) as cnt FROM prices p
                JOIN stores s ON p.store_id = s.id
                WHERE s.chain_id = %s
            """, (it_chain['id'],))
            cnt = cur.fetchone()['cnt']
            print(f"🇮🇹 Italy (MIMIT) [ID {it_chain['id']}]: {cnt} prices")
            
            if cnt > 0:
                cur.execute("""
                    SELECT p.price, p.currency, pr.name, s.name as store
                    FROM prices p
                    JOIN stores s ON p.store_id = s.id
                    JOIN products pr ON p.product_id = pr.id
                    WHERE s.chain_id = %s
                    LIMIT 3
                """, (it_chain['id'],))
                for row in cur.fetchall():
                    print(f"   - {row['price']} {row['currency']} | {row['name']} @ {row['store']}")
        else:
            print("🇮🇹 Italy: Chain not found by Name")

        print("-" * 30)

        # Check France by Name
        cur.execute("SELECT id FROM chains WHERE name='Prix Carburants France'")
        fr_chain = cur.fetchone()
        if fr_chain:
            cur.execute("""
                SELECT COUNT(*) as cnt FROM prices p
                JOIN stores s ON p.store_id = s.id
                WHERE s.chain_id = %s
            """, (fr_chain['id'],))
            cnt = cur.fetchone()['cnt']
            print(f"🇫🇷 France (Gov) [ID {fr_chain['id']}]: {cnt} prices")
            
            if cnt > 0:
                cur.execute("""
                    SELECT p.price, p.currency, pr.name, s.name as store
                    FROM prices p
                    JOIN stores s ON p.store_id = s.id
                    JOIN products pr ON p.product_id = pr.id
                    WHERE s.chain_id = %s
                    LIMIT 3
                """, (fr_chain['id'],))
                for row in cur.fetchall():
                    print(f"   - {row['price']} {row['currency']} | {row['name']} @ {row['store']}")
        else:
            print("🇫🇷 France: Chain not found by Name")
            
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check()
