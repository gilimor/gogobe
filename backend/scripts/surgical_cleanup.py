import sys
import os
import psycopg2
from datetime import datetime

# DB Config
DB_HOST = os.environ.get('POSTGRES_HOST', 'db')
DB_NAME = os.environ.get('POSTGRES_DB', 'gogobe')
DB_USER = 'postgres'
DB_PASS = '9152245-Gl!'

def get_db_connection():
    return psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)

def run_cleanup(store_pattern, date_str, dry_run=True):
    conn = get_db_connection()
    cur = conn.cursor()
    
    print(f"--- SURGICAL CLEANUP TOOL ---")
    print(f"Target Store: {store_pattern}")
    print(f"Target Date: >= {date_str}")
    print(f"Mode: {'DRY RUN (Safe)' if dry_run else 'DESTRUCTIVE'}")
    print("-----------------------------")

    try:
        # 1. Find Stores matching pattern
        cur.execute("SELECT id, name FROM stores WHERE name ILIKE %s", (f"%{store_pattern}%",))
        stores = cur.fetchall()
        
        if not stores:
            print("No stores found matching pattern.")
            return

        store_ids = [s[0] for s in stores]
        print(f"Found {len(stores)} stores matching pattern:")
        for s in stores:
            print(f" - [{s[0]}] {s[1]}")
            
        # 2. Find Prices for these stores since date
        # query: count of prices
        cur.execute("""
            SELECT count(*) FROM prices 
            WHERE store_id = ANY(%s) AND scraped_at >= %s
        """, (store_ids, date_str))
        price_count = cur.fetchone()[0]
        
        print(f"\nPrices targeted for deletion: {price_count}")
        
        if price_count == 0:
            print("No prices found to delete.")
            return

        # 3. Find Orphaned Products (Products that would have 0 prices after this deletion)
        # Strategy: 
        #   Find products having prices in target set.
        #   For each, count if they have prices NOT in target set.
        #   If count_other == 0, then it's an orphan.
        
        print("\nAnalyzing Orphaned Products (Slow)...")
        # Find affected product_ids
        cur.execute("""
            SELECT DISTINCT product_id 
            FROM prices 
            WHERE store_id = ANY(%s) AND scraped_at >= %s
        """, (store_ids, date_str))
        affected_product_ids = [r[0] for r in cur.fetchall()]
        print(f"Products touched by these prices: {len(affected_product_ids)}")
        
        orphans = []
        if affected_product_ids:
            # Check how many of these have prices OUTSIDE the criteria
            cur.execute("CREATE TEMP TABLE target_prices AS SELECT id, product_id FROM prices WHERE store_id = ANY(%s) AND scraped_at >= %s", (store_ids, date_str))
            
            cur.execute("""
                SELECT tp.product_id 
                FROM target_prices tp
                LEFT JOIN prices p ON p.product_id = tp.product_id AND p.id NOT IN (SELECT id FROM target_prices)
                GROUP BY tp.product_id
                HAVING count(p.id) = 0
            """)
            orphans = [r[0] for r in cur.fetchall()]
            
        print(f"Orphan Candidates (Products to be deleted): {len(orphans)}")
        
        # 4. Master Product Links
        master_links_count = 0
        if orphans:
            cur.execute("SELECT count(*) FROM product_master_links WHERE product_id = ANY(%s)", (orphans,))
            master_links_count = cur.fetchone()[0]
            
        print(f"Master Product Links to sever: {master_links_count}")

        if dry_run:
            print("\n[DRY RUN] No changes made.")
            return

        # EXECUTION
        print("\n--- EXECUTING DELETION ---")
        
        # A. Delete Prices
        cur.execute("DELETE FROM prices WHERE store_id = ANY(%s) AND scraped_at >= %s", (store_ids, date_str))
        deleted_prices = cur.rowcount
        print(f"Deleted {deleted_prices} prices.")
        
        # B. Delete Orphan Products (and Cascading Links)
        if orphans:
             # Manual delete links first to be safe
             cur.execute("DELETE FROM product_master_links WHERE product_id = ANY(%s)", (orphans,))
             print(f"Deleted {cur.rowcount} master links.")
             
             cur.execute("DELETE FROM products WHERE id = ANY(%s)", (orphans,))
             print(f"Deleted {cur.rowcount} products.")
             
        conn.commit()
        print("Done.")

    except Exception as e:
        conn.rollback()
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python surgical_cleanup.py <store_pattern> <date_str> [--force]")
        sys.exit(1)
        
    store_pattern = sys.argv[1]
    date_str = sys.argv[2]
    dry_run = "--force" not in sys.argv
    
    run_cleanup(store_pattern, date_str, dry_run)
