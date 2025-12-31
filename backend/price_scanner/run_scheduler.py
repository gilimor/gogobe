import time
import psycopg2
import os
import subprocess
from datetime import datetime, timedelta

def get_db_connection():
    return psycopg2.connect(
        dbname=os.getenv('DB_NAME', 'gogobe'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host=os.getenv('DB_HOST', 'localhost'),
        port=os.getenv('DB_PORT', '5432')
    )

def calculate_next_scan(last_scan_at, status, success_rate):
    """
    Determine if it's time to re-scan based on spec logic.
    """
    if not last_scan_at:
        return True # Found but never scanned (should verify status PENDING)
        
    now = datetime.now()
    delta = now - last_scan_at
    
    # 9.1 Dynamic Re-Scan Logic from Spec
    # | Status (Success Rate) | Re-Scan Interval |
    # | > 80% (Excellent)     | 7 days           |
    # | 50-80% (Good)         | 14 days          |
    # | 20-50% (Risky)        | 30 days          |
    # | < 20% (Poor)          | 90 days          |
    # | NO_PRICES             | 365 days         |
    
    if status == 'NO_PRICES_FOUND':
        return delta.days >= 365
        
    if status == 'ERROR':
        return delta.total_seconds() >= 3600 # Retry errors after 1 hour (simple retry policy)

    rate = success_rate or 0
    
    if rate > 0.8:
        return delta.days >= 7
    elif rate > 0.5:
        return delta.days >= 14
    elif rate > 0.2:
        return delta.days >= 30
    else:
        return delta.days >= 90


def check_and_run_ai_matching(last_run_time):
    """
    Triggers AI product matching once every 24 hours.
    """
    now = datetime.now()
    if not last_run_time or (now - last_run_time).total_seconds() >= 86400: # 24 Hours
        print("🧠 Triggering Daily AI Matching...")
        try:
            # We call the internal service or API.
            # Since we are in the same docker network, calling the API is safest/easiest way to invoke the logic
            # properly handled by the FastAPI container (which has openai/deps).
            import requests # Must be installed
            try:
                response = requests.post("http://api:8000/api/admin/ai/run", timeout=10)
                if response.status_code == 200:
                    print(f"✅ AI Matching triggered successfully: {response.json()}")
                    return now
                else:
                    print(f"⚠️ AI Matching trigger failed: {response.status_code} - {response.text}")
            except Exception as req_err:
                 print(f"⚠️ AI Matching API unreachable: {req_err}")
                 
        except Exception as e:
            print(f"❌ AI Matching Error: {e}")
            
    return last_run_time

def scheduler_loop():
    print("⏰ Scanner Scheduler started...")
    
    last_ai_run = None
    
    while True:
        # --- Task 1: Scraper ---
        try:
            conn = get_db_connection()
            cur = conn.cursor()
            
            # 1. Fetch candidates (PENDING or ACTIVE/NO_PRICES that might need update)
            # We fetch all that are not BLOCKED or SCANNING
            cur.execute("""
                SELECT id, domain, sitemap_url, discovery_status, last_scan_at, success_rate
                FROM source_discovery_tracking
                WHERE discovery_status NOT IN ('BLOCKED', 'SCANNING', 'BLOCKED_AGGREGATOR')
            """)
            candidates = cur.fetchall()
            cur.close()
            conn.close()
            
            for row in candidates:
                source_id, domain, sitemap_url, status, last_scan, rate = row
                
                should_run = False
                
                if status == 'PENDING':
                    should_run = True
                
                elif status in ['ACTIVE', 'NO_PRICES_FOUND', 'ERROR']:
                     should_run = calculate_next_scan(last_scan, status, float(rate or 0))
                
                if should_run:
                    print(f"🚀 Triggering scan for {domain} (Status: {status})")
                    trigger_scan(source_id, domain, sitemap_url)
                    
        except Exception as e:
            print(f"❌ Scheduler Error: {e}")

        # --- Task 2: AI Matching (Daily) ---
        last_ai_run = check_and_run_ai_matching(last_ai_run)
            
        time.sleep(60) # Check every minute

def trigger_scan(source_id, domain, sitemap_url):
    # Update status to SCANNING
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("UPDATE source_discovery_tracking SET discovery_status = 'SCANNING' WHERE id = %s", (source_id,))
        conn.commit()
        conn.close()
        
        # Run Scrapy
        # Note: We must run this from the project root or correct dir
        # In Docker, app is at /app
        # We also pass use_ai=true for robustness now that we have it
        cmd = [
            "scrapy", "crawl", "price_hunter",
            "-a", f"domain={domain}",
            "-a", f"sitemap_url={sitemap_url}",
            "-a", f"source_id={source_id}",
            "-a", "use_ai=true"
        ]
        
        result = subprocess.run(
            cmd,
            cwd="/app/backend/price_scanner",
            capture_output=True,
            text=True
        )
        
        conn = get_db_connection()
        cur = conn.cursor()
        
        if result.returncode == 0:
            # Check logs/output or just assume active if finished.
            # Ideally the pipeline updates the stats, here we just set status back to done.
            # But wait, how do we know if NO_PRICES_FOUND? 
            # We can check products_found in DB.
            
            check_cur = conn.cursor()
            check_cur.execute("SELECT products_found FROM source_discovery_tracking WHERE id = %s", (source_id,))
            products_count = check_cur.fetchone()[0]
            check_cur.close()
            
            new_status = 'ACTIVE'
            if products_count == 0:
                new_status = 'NO_PRICES_FOUND'
                
            cur.execute("""
                UPDATE source_discovery_tracking 
                SET discovery_status = %s, last_scan_at = NOW() 
                WHERE id = %s
            """, (new_status, source_id))
            print(f"✅ Scan finished for {domain}. Status: {new_status}")
            
        else:
            print(f"⚠️ Scan failed for {domain}: {result.stderr}")
            cur.execute("UPDATE source_discovery_tracking SET discovery_status = 'ERROR' WHERE id = %s", (source_id,))
            
        conn.commit()
        conn.close()
        
    except Exception as e:
        print(f"❌ Execution Error: {e}")
        # Try to reset status if locked
        try:
             conn = get_db_connection()
             cur = conn.cursor()
             cur.execute("UPDATE source_discovery_tracking SET discovery_status = 'ERROR' WHERE id = %s", (source_id,))
             conn.commit()
             conn.close()
        except:
            pass

if __name__ == "__main__":
    # Ensure dependencies
    scheduler_loop()
