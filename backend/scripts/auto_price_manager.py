#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Automated Multi-Source Price Management Scheduler
Runs continuously, downloading and processing prices from multiple sources
"""
import sys
import os
import time
import schedule
import subprocess
from datetime import datetime
from typing import Dict, List
import psycopg2
from psycopg2.extras import RealDictCursor
import json

sys.stdout.reconfigure(encoding='utf-8')

DB_CONFIG = {
    'dbname': 'gogobe',
    'user': 'postgres',
    'password': '9152245-Gl!',
    'host': 'localhost',
    'port': '5432'
}

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# ========================================
# Source Configurations
# ========================================

SOURCES_CONFIG = {
    'kingstore': {
        'name': 'KingStore',
        'downloader_script': 'backend/scripts/kingstore_smart_downloader.py',
        'processor_script': 'backend/scripts/kingstore_xml_processor.py',
        'classifier_script': 'backend/scripts/parallel_multilang_classifier.py',
        'vertical': 'supermarket',
        'schedule': '0 */6 * * *',  # Every 6 hours
        'parallel_downloads': 10,
        'parallel_processing': 4,
        'enabled': True
    },
    # Template for adding more sources:
    # 'shufersal': {
    #     'name': 'Shufersal',
    #     'downloader_script': 'backend/scripts/shufersal_downloader.py',
    #     'processor_script': 'backend/scripts/shufersal_processor.py',
    #     'classifier_script': 'backend/scripts/parallel_multilang_classifier.py',
    #     'vertical': 'supermarket',
    #     'schedule': '0 */8 * * *',  # Every 8 hours
    #     'enabled': True
    # },
}


def log(message: str, level: str = "INFO"):
    """Log with timestamp"""
    timestamp = datetime.now().strftime("%H:%M:%S")
    print(f"[{timestamp}] [{level:5}] {message}")


def run_script(script_path: str, args: List[str] = None) -> Dict:
    """
    Run a Python script and return results
    """
    if args is None:
        args = []
    
    full_path = os.path.join(PROJECT_ROOT, script_path)
    
    if not os.path.exists(full_path):
        return {'success': False, 'error': f'Script not found: {full_path}'}
    
    cmd = [
        'python',
        full_path
    ] + args
    
    try:
        start_time = time.time()
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=3600,  # 1 hour timeout
            encoding='utf-8',
            errors='replace'
        )
        elapsed = time.time() - start_time
        
        return {
            'success': result.returncode == 0,
            'returncode': result.returncode,
            'stdout': result.stdout,
            'stderr': result.stderr,
            'elapsed': elapsed
        }
    except subprocess.TimeoutExpired:
        return {'success': False, 'error': 'Script timed out'}
    except Exception as e:
        return {'success': False, 'error': str(e)}


def create_scraping_session(source_name: str) -> int:
    """Create a new scraping session in the database"""
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        cur.execute("""
            INSERT INTO scraping_sessions (session_name, status, started_at)
            VALUES (%s, 'running', NOW())
            RETURNING id
        """, (f"{source_name} - {datetime.now().strftime('%Y-%m-%d %H:%M')}",))
        
        session_id = cur.fetchone()['id']
        conn.commit()
        return session_id
    finally:
        conn.close()


def update_scraping_session(session_id: int, updates: Dict):
    """Update scraping session with results"""
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    
    try:
        set_clauses = []
        params = []
        
        for key, value in updates.items():
            set_clauses.append(f"{key} = %s")
            params.append(value)
        
        params.append(session_id)
        
        cur.execute(f"""
            UPDATE scraping_sessions 
            SET {', '.join(set_clauses)}, completed_at = NOW()
            WHERE id = %s
        """, params)
        
        conn.commit()
    finally:
        conn.close()


def process_source(source_key: str, config: Dict):
    """
    Process a single price source
    Steps:
    1. Download files
    2. Process files (extract and import data)
    3. Classify products
    """
    log(f"Starting {config['name']} processing...")
    log("="*70)
    
    session_id = create_scraping_session(config['name'])
    
    # Step 1: Download
    log(f"Step 1/3: Downloading from {config['name']}...")
    download_result = run_script(
        config['downloader_script'],
        ['--limit', '50', '--parallel', str(config.get('parallel_downloads', 5))]
    )
    
    if not download_result['success']:
        log(f"Download failed: {download_result.get('error', 'Unknown error')}", "ERROR")
        update_scraping_session(session_id, {
            'status': 'failed',
            'error_message': download_result.get('error', 'Download failed')
        })
        return False
    
    log(f"Download completed in {download_result['elapsed']:.1f}s")
    
    # Step 2: Process files
    log(f"Step 2/3: Processing files...")
    process_result = run_script(
        config['processor_script'],
        ['--parallel', str(config.get('parallel_processing', 4))]
    )
    
    if not process_result['success']:
        log(f"Processing failed: {process_result.get('error', 'Unknown error')}", "ERROR")
        update_scraping_session(session_id, {
            'status': 'partial',
            'error_message': process_result.get('error', 'Processing failed')
        })
        return False
    
    log(f"Processing completed in {process_result['elapsed']:.1f}s")
    
    # Step 3: Classify products
    log(f"Step 3/3: Classifying products...")
    classify_result = run_script(
        config['classifier_script'],
        ['--vertical', config['vertical'], '--workers', str(config.get('parallel_processing', 4))]
    )
    
    if not classify_result['success']:
        log(f"Classification warning: {classify_result.get('error', 'Unknown')}", "WARN")
    else:
        log(f"Classification completed in {classify_result['elapsed']:.1f}s")
    
    # Update session
    update_scraping_session(session_id, {
        'status': 'completed',
        'duration_seconds': int(download_result['elapsed'] + process_result['elapsed'] + classify_result.get('elapsed', 0))
    })
    
    log(f"✅ {config['name']} processing complete!")
    log("="*70)
    
    return True


def run_all_sources():
    """Run all enabled sources"""
    log("🚀 Starting automated price update cycle...")
    start_time = time.time()
    
    success_count = 0
    for source_key, config in SOURCES_CONFIG.items():
        if not config.get('enabled', True):
            log(f"Skipping {config['name']} (disabled)")
            continue
        
        try:
            if process_source(source_key, config):
                success_count += 1
        except Exception as e:
            log(f"Unexpected error processing {config['name']}: {e}", "ERROR")
    
    elapsed = time.time() - start_time
    log(f"✅ Update cycle complete! {success_count}/{len(SOURCES_CONFIG)} sources successful")
    log(f"Total time: {elapsed/60:.1f} minutes")


def main():
    """Main scheduler loop"""
    log("="*70)
    log("🤖 Gogobe Automated Price Management System")
    log("="*70)
    log(f"Configured sources: {len(SOURCES_CONFIG)}")
    for key, config in SOURCES_CONFIG.items():
        status = "✅ Enabled" if config.get('enabled', True) else "⛔ Disabled"
        log(f"  - {config['name']}: {status}")
    log("="*70)
    
    # Schedule tasks
    log("\nScheduling tasks...")
    
    # Run immediately on start
    schedule.every().day.at("00:00").do(run_all_sources)  # Daily at midnight
    
    # You can add more schedules:
    # schedule.every(6).hours.do(run_all_sources)  # Every 6 hours
    # schedule.every().monday.at("08:00").do(run_all_sources)  # Every Monday 8am
    
    log("✅ Scheduler initialized")
    log("\nNext run: Midnight (00:00)")
    log("\nScheduler is running. Press Ctrl+C to stop.")
    log("="*70 + "\n")
    
    # Run once immediately
    log("Running initial update cycle...")
    run_all_sources()
    
    # Main loop
    try:
        while True:
            schedule.run_pending()
            time.sleep(60)  # Check every minute
    except KeyboardInterrupt:
        log("\n👋 Scheduler stopped by user")


if __name__ == '__main__':
    import argparse
    
    parser = argparse.ArgumentParser(description='Automated price management scheduler')
    parser.add_argument('--once', action='store_true', help='Run once and exit (no scheduling)')
    parser.add_argument('--source', type=str, help='Process only specific source')
    
    args = parser.parse_args()
    
    if args.once:
        if args.source:
            if args.source in SOURCES_CONFIG:
                process_source(args.source, SOURCES_CONFIG[args.source])
            else:
                log(f"Unknown source: {args.source}", "ERROR")
        else:
            run_all_sources()
    else:
        main()


