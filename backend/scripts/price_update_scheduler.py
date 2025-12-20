"""
Automated Price Update Scheduler
Runs price scrapers on schedule and manages updates
"""

import sys
from pathlib import Path
from datetime import datetime, timedelta
import time
import subprocess
import schedule

# Add backend to path
backend_path = Path(__file__).parent.parent
sys.path.insert(0, str(backend_path))

from database.db_connection import get_db_connection


class PriceUpdateScheduler:
    def __init__(self):
        self.project_root = Path(__file__).parent.parent.parent
        self.python_exe = r"C:\Users\shake\miniconda3\python.exe"
        
    def log(self, message):
        """Print timestamped log message"""
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        print(f"[{timestamp}] {message}")
    
    def get_active_sources(self):
        """Get list of active price sources from database"""
        conn = get_db_connection()
        cur = conn.cursor()
        
        try:
            cur.execute("""
                SELECT id, name, source_type, base_url, check_frequency_hours,
                       last_check_at, last_success_at
                FROM price_sources
                WHERE is_active = true
                ORDER BY name
            """)
            
            sources = []
            for row in cur.fetchall():
                sources.append({
                    'id': row[0],
                    'name': row[1],
                    'type': row[2],
                    'url': row[3],
                    'frequency_hours': row[4] or 24,
                    'last_check': row[5],
                    'last_success': row[6]
                })
            
            return sources
            
        finally:
            cur.close()
            conn.close()
    
    def should_check_source(self, source):
        """Determine if source should be checked now"""
        if not source['last_check']:
            return True
        
        frequency_hours = source['frequency_hours']
        next_check = source['last_check'] + timedelta(hours=frequency_hours)
        
        return datetime.now() >= next_check
    
    def update_source_check_time(self, source_id, success=True):
        """Update last check time for source"""
        conn = get_db_connection()
        cur = conn.cursor()
        
        try:
            if success:
                cur.execute("""
                    UPDATE price_sources
                    SET last_check_at = NOW(),
                        last_success_at = NOW(),
                        error_count = 0,
                        last_error = NULL
                    WHERE id = %s
                """, (source_id,))
            else:
                cur.execute("""
                    UPDATE price_sources
                    SET last_check_at = NOW(),
                        error_count = error_count + 1
                    WHERE id = %s
                """, (source_id,))
            
            conn.commit()
            
        finally:
            cur.close()
            conn.close()
    
    def run_kingstore_scraper(self):
        """Run KingStore full scraper"""
        self.log("=" * 60)
        self.log("Starting KingStore scraper...")
        self.log("=" * 60)
        
        try:
            script_path = self.project_root / "backend" / "scripts" / "kingstore_full_scraper.py"
            
            # Run scraper
            result = subprocess.run(
                [self.python_exe, str(script_path)],
                cwd=str(self.project_root),
                capture_output=True,
                text=True,
                encoding='utf-8',
                errors='replace'
            )
            
            if result.returncode == 0:
                self.log("[OK] KingStore scraper completed successfully")
                
                # Now process the downloaded files
                self.log("")
                self.log("=" * 60)
                self.log("Processing downloaded files...")
                self.log("=" * 60)
                
                processor_path = self.project_root / "backend" / "scripts" / "kingstore_xml_processor.py"
                
                proc_result = subprocess.run(
                    [self.python_exe, str(processor_path)],
                    cwd=str(self.project_root),
                    capture_output=True,
                    text=True,
                    encoding='utf-8',
                    errors='replace'
                )
                
                if proc_result.returncode == 0:
                    self.log("[OK] Processing completed successfully")
                else:
                    self.log(f"[WARN] Processing had errors: {proc_result.stderr}")
                
                # Update source
                sources = self.get_active_sources()
                for source in sources:
                    if 'KingStore' in source['name']:
                        self.update_source_check_time(source['id'], success=True)
                        break
                
                return True
            else:
                self.log(f"[ERROR] KingStore scraper failed with code {result.returncode}")
                self.log(f"[ERROR] {result.stderr}")
                return False
                
        except Exception as e:
            self.log(f"[ERROR] Failed to run scraper: {e}")
            import traceback
            traceback.print_exc()
            return False
    
    def check_all_sources(self):
        """Check all active sources and run scrapers if needed"""
        self.log("\n" + "=" * 60)
        self.log("Checking all price sources...")
        self.log("=" * 60)
        
        sources = self.get_active_sources()
        
        if not sources:
            self.log("[WARN] No active price sources found")
            return
        
        self.log(f"[INFO] Found {len(sources)} active source(s)")
        
        for source in sources:
            self.log(f"\n--- {source['name']} ---")
            self.log(f"    Type: {source['type']}")
            self.log(f"    Frequency: Every {source['frequency_hours']} hours")
            self.log(f"    Last check: {source['last_check']}")
            self.log(f"    Last success: {source['last_success']}")
            
            if self.should_check_source(source):
                self.log(f"    [INFO] Time to check this source!")
                
                # Run appropriate scraper based on source
                if 'KingStore' in source['name']:
                    self.run_kingstore_scraper()
                else:
                    self.log(f"    [WARN] No scraper configured for this source yet")
                    
            else:
                next_check = source['last_check'] + timedelta(hours=source['frequency_hours'])
                self.log(f"    [SKIP] Next check at: {next_check}")
    
    def run_scheduler(self):
        """Main scheduler loop"""
        print("=" * 70)
        print("            GOGOBE PRICE UPDATE SCHEDULER")
        print("=" * 70)
        print()
        print("  This scheduler will automatically check and update prices")
        print("  from all configured sources based on their check frequency.")
        print()
        print("  Press Ctrl+C to stop")
        print("=" * 70)
        print()
        
        # Schedule jobs
        schedule.every(1).hours.do(self.check_all_sources)
        
        # Run immediately on start
        self.log("[INFO] Running initial check...")
        self.check_all_sources()
        
        self.log("\n[INFO] Scheduler started. Checking every hour...")
        self.log("[INFO] Press Ctrl+C to stop")
        
        # Main loop
        try:
            while True:
                schedule.run_pending()
                time.sleep(60)  # Check every minute
                
        except KeyboardInterrupt:
            self.log("\n[INFO] Scheduler stopped by user")
            print("\n" + "=" * 70)
            print("  Scheduler stopped!")
            print("=" * 70)


def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Price Update Scheduler')
    parser.add_argument('--once', action='store_true', help='Run once and exit (no scheduling)')
    parser.add_argument('--force', action='store_true', help='Force update all sources regardless of schedule')
    
    args = parser.parse_args()
    
    scheduler = PriceUpdateScheduler()
    
    if args.once:
        # Run once and exit
        scheduler.check_all_sources()
    else:
        # Run continuous scheduler
        scheduler.run_scheduler()


if __name__ == "__main__":
    main()

