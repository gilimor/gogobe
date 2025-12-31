import sys
import codecs
import time
from datetime import datetime
import psycopg2
import os

sys.stdout.reconfigure(encoding='utf-8')

# Database Config
DB_CONFIG = {
    'dbname': 'gogobe',
    'user': 'postgres',
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': 'localhost',
    'port': '5432'
}

def get_connection():
    return psycopg2.connect(**DB_CONFIG)

def check_status():
    print(f"[{datetime.now().strftime('%H:%M:%S')}] Checking Import Activity...")
    
    conn = get_connection()
    cur = conn.cursor()
    
    try:
        # Check running queries (Activity)
        cur.execute("SELECT count(*) FROM pg_stat_activity WHERE state = 'active' AND query NOT LIKE '%pg_stat_activity%'")
        active_queries = cur.fetchone()[0]
        
        # Check recent price updates (Last 5 minutes)
        cur.execute("""
            SELECT count(*) 
            FROM prices 
            WHERE scraped_at > NOW() - INTERVAL '30 minutes'
        """)
        new_prices = cur.fetchone()[0]
        
        # Check Master Product Links (MML Status)
        cur.execute("SELECT count(*) FROM product_master_links")
        total_links = cur.fetchone()[0]
        
        cur.execute("SELECT count(*) FROM master_products")
        total_masters = cur.fetchone()[0]

        # Check Active Jobs
        cur.execute("SELECT count(*) FROM scraping_jobs WHERE status = 'running'")
        running_jobs = cur.fetchone()
        running_jobs_count = running_jobs[0] if running_jobs else 0
        
        print("\n=== SYSTEM HEALTH ===")
        print(f"Active DB Queries: {active_queries}")
        print(f"Active Scraping Jobs: {running_jobs_count}")
        print(f"Prices Added (Last 30m): {new_prices:,}")
        
        print("\n=== MML STATUS (Patent Engine) ===")
        print(f"Total Master Products: {total_masters:,}")
        print(f"Total Linked Products: {total_links:,}")
        
        if new_prices == 0:
            print("\nWARNING: No prices ingested recently. Scrapers might be stuck or still downloading files.")
        else:
            print(f"\nSUCCESS: System is ingesting data at speed.")
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    check_status()
