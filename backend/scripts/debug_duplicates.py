
import os
import sys
import logging

# Add app root to path
current_dir = os.path.dirname(os.path.abspath(__file__))
app_root = os.path.abspath(os.path.join(current_dir, "..", "..", ".."))
if app_root not in sys.path:
    sys.path.insert(0, app_root)

try:
    from backend.database.db_connection import get_db_cursor
except ImportError:
    from database.db_connection import get_db_cursor

def check_duplicates():
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        # Find all master products with similar names or exact names
        print("--- Duplicate Name Check ---")
        cur.execute("""
            SELECT name, COUNT(*), array_agg(id) as ids 
            FROM master_products 
            GROUP BY name 
            HAVING COUNT(*) > 1
        """)
        rows = cur.fetchall()
        if not rows:
            print("No exact name duplicates found.")
        else:
            for row in rows:
                print(f"Name: '{row['name']}' | Count: {row['count']} | IDs: {row['ids']}")

        print("\n--- Case-Insensitive / Whitespace Check ---")
        cur.execute("""
            SELECT LOWER(TRIM(name)) as clean_name, COUNT(*), array_agg(id) as ids 
            FROM master_products 
            GROUP BY LOWER(TRIM(name)) 
            HAVING COUNT(*) > 1
        """)
        rows = cur.fetchall()
        for row in rows:
            print(f"Clean Name: '{row['clean_name']}' | Count: {row['count']} | IDs: {row['ids']}")
            # Detail view for these IDs
            cur.execute("SELECT id, name, LENGTH(name) as len FROM master_products WHERE id = ANY(%s)", (row['ids'],))
            details = cur.fetchall()
            for d in details:
                print(f"  - ID: {d['id']} | Name: '{d['name']}' | Len: {d['len']}")

    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    check_duplicates()
