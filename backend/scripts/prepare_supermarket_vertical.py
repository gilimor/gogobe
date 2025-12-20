"""
Ensure Supermarket vertical exists in database
"""
import sys
from pathlib import Path

backend_path = Path(__file__).parent.parent
sys.path.insert(0, str(backend_path))

from database.db_connection import get_db_connection

def main():
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        # Check if Supermarket vertical exists
        cur.execute("SELECT id, name FROM verticals WHERE name ILIKE '%supermarket%'")
        result = cur.fetchone()
        
        if result:
            print(f"[OK] Supermarket vertical already exists: {result}")
        else:
            print("[INFO] Creating Supermarket vertical...")
            cur.execute("""
                INSERT INTO verticals (name, slug, description)
                VALUES ('Supermarket', 'supermarket', 'Supermarket products and groceries')
                RETURNING id, name
            """)
            result = cur.fetchone()
            conn.commit()
            print(f"[OK] Supermarket vertical created: {result}")
        
        # Also ensure KingStore supplier exists
        cur.execute("SELECT id, name FROM suppliers WHERE name = 'KingStore'")
        supplier = cur.fetchone()
        
        if supplier:
            print(f"[OK] KingStore supplier already exists: {supplier}")
        else:
            print("[INFO] Creating KingStore supplier...")
            cur.execute("""
                INSERT INTO suppliers (name, city, country_code, supplier_type)
                VALUES ('KingStore', 'Tel Aviv', 'IL', 'supermarket')
                RETURNING id, name
            """)
            supplier = cur.fetchone()
            print(f"[OK] KingStore supplier created: {supplier}")
        
        conn.commit()
        
    except Exception as e:
        print(f"[ERROR] Error: {e}")
        conn.rollback()
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    main()

