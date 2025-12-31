import sys
import os
from pathlib import Path
import inspect
import psycopg2

# Add path
current_dir = Path(__file__).parent
app_root = current_dir
if str(app_root) not in sys.path:
    sys.path.insert(0, str(app_root))

try:
    from scrapers.base_supermarket_scraper import BaseSupermarketScraper
    print("Code Source:")
    print(inspect.getsource(BaseSupermarketScraper.ensure_chain_exists))
except Exception as e:
    print(f"Failed to import: {e}")

# DB Test
try:
    conn = psycopg2.connect(
        host="localhost",
        database="gogobe",
        user="postgres",
        password="password"
    )
    cur = conn.cursor()
    
    print("\nDB Test 1 (Correct Query):")
    try:
        cur.execute("SELECT id FROM store_chains WHERE chain_code='7290172900007'")
        res = cur.fetchone()
        print(f"Result: {res}")
    except Exception as e:
        print(f"Error: {e}")
        conn.rollback()

    print("\nDB Test 2 (Bad Query):")
    try:
        cur.execute("SELECT id FROM store_chains WHERE chain_id='7290172900007'")
        res = cur.fetchone()
        print(f"Result: {res}")
    except Exception as e:
        print(f"Error (Expected): {e}")
        conn.rollback()
        
    conn.close()

except Exception as e:
    print(f"DB Connection failed: {e}")
