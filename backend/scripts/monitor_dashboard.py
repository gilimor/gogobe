
import os
import sys
import time
import struct
import shutil
import psycopg2
from datetime import datetime, timedelta

# ANSI Colors
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def get_terminal_size():
    return shutil.get_terminal_size((80, 20))

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def get_db_connection():
    return psycopg2.connect(
        dbname=os.getenv('DB_NAME', 'gogobe'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host=os.getenv('DB_HOST', 'localhost'),
        port=os.getenv('DB_PORT', '5432')
    )

def fetch_active_status():
    conn = get_db_connection()
    cur = conn.cursor()
    
    # 1. Active/Recent Files (Last 12 hours)
    cur.execute("""
        SELECT 
            source,
            COUNT(*) as total_files,
            SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed,
            SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) as failed,
            SUM(CASE WHEN status IN ('processing', 'importing', 'parsing') THEN 1 ELSE 0 END) as processing,
            SUM(CASE WHEN status = 'downloading' THEN 1 ELSE 0 END) as downloading,
            MAX(updated_at) as last_update,
            SUM(products_added) as new_prods,
            SUM(prices_added) as new_prices
        FROM file_processing_log
        WHERE updated_at > NOW() - INTERVAL '12 hours'
        GROUP BY source
        ORDER BY last_update DESC
    """)
    file_stats = cur.fetchall()
    
    # 2. Currently processing detailed view
    cur.execute("""
        SELECT filename, source, status, processing_started_at, 
               EXTRACT(EPOCH FROM (NOW() - processing_started_at))/60 as minutes_running
        FROM file_processing_log
        WHERE status NOT IN ('completed', 'failed')
        ORDER BY processing_started_at DESC
    """)
    active_files = cur.fetchall()
    
    conn.close()
    return file_stats, active_files

def format_time_ago(dt):
    if not dt: return "-"
    now = datetime.now()
    diff = now - dt
    if diff.seconds < 60:
        return f"{diff.seconds}s ago"
    elif diff.seconds < 3600:
        return f"{diff.seconds//60}m ago"
    else:
        return f"{diff.seconds//3600}h ago"

def draw_dashboard():
    while True:
        try:
            file_stats, active_files = fetch_active_status()
            
            clear_screen()
            width, _ = get_terminal_size()
            
            print(f"{Colors.HEADER}╔{'═'*(width-2)}╗{Colors.ENDC}")
            title = " GOGOBE ORCHESTRATION CONTROL CENTER "
            print(f"{Colors.HEADER}║{title.center(width-2)}║{Colors.ENDC}")
            print(f"{Colors.HEADER}╚{'═'*(width-2)}╝{Colors.ENDC}")
            print(f"Time: {datetime.now().strftime('%H:%M:%S')} | Active Scrapers: {len(file_stats)}\n")
            
            # --- SUMMARY GRID ---
            print(f"{Colors.BOLD}{'SOURCE':<15} {'PROGRESS':<20} {'STATUS':<15} {'LAST UPDATE':<15} {'NEW PRICES':<10}{Colors.ENDC}")
            print("-" * width)
            
            total_prices_global = 0
            
            for row in file_stats:
                source, total, done, failed, proc, dl, last_up, new_p, new_pr = row
                
                # Progress Bar
                if total > 0:
                    percent = int((done / total) * 100)
                else:
                    percent = 0
                    
                bar_len = 10
                filled_len = int(bar_len * percent / 100)
                bar = '█' * filled_len + '-' * (bar_len - filled_len)
                progress_str = f"[{bar}] {done}/{total}"
                
                # Status Color
                if proc > 0 or dl > 0:
                    status_str = f"{Colors.CYAN}RUNNING ({proc+dl}){Colors.ENDC}"
                elif failed > 0 and failed == total:
                    status_str = f"{Colors.FAIL}FAILED{Colors.ENDC}"
                elif done == total and total > 0:
                    status_str = f"{Colors.GREEN}DONE{Colors.ENDC}"
                else:
                    status_str = "WAITING"
                
                new_pr_str = f"+{int(new_pr or 0):,}"
                total_prices_global += int(new_pr or 0)
                
                print(f"{source:<15} {progress_str:<20} {status_str:<25} {format_time_ago(last_up):<15} {Colors.GREEN}{new_pr_str:<10}{Colors.ENDC}")

            print("-" * width)
            print(f"TOTAL NEW PRICES IN SESSION: {Colors.GREEN}{total_prices_global:,}{Colors.ENDC}\n")

            # --- ACTIVE TASKS ---
            if active_files:
                print(f"{Colors.BOLD}>>> CURRENTLY PROCESSING ({len(active_files)}){Colors.ENDC}")
                for f_row in active_files:
                    fname, src, stat, started, mins = f_row
                    short_name = (fname[:45] + '..') if len(fname) > 45 else fname
                    
                    color = Colors.BLUE
                    if stat == 'downloading': color = Colors.CYAN
                    if mins > 30: color = Colors.WARNING # Stuck?
                    
                    print(f"  • {src:<12} | {color}{stat.upper():<12}{Colors.ENDC} | {short_name:<50} | {mins:.1f}m ago")
            else:
                print(f"{Colors.BOLD}>>> NO ACTIVE TASKS - SYSTEM IDLE{Colors.ENDC}")

            # Refresh rate
            time.sleep(2)
            
        except KeyboardInterrupt:
            print("\nExiting monitor...")
            sys.exit(0)
        except Exception as e:
            print(f"Error: {e}")
            time.sleep(5)

if __name__ == "__main__":
    # Ensure environment variables if running directly
    if not os.getenv('DB_PASSWORD'):
        os.environ['DB_PASSWORD'] = '9152245-Gl!'
        
    draw_dashboard()
