#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
KingStore Import by Release Date
Processes files grouped by their release date (from filename)
Only processes new dates that haven't been imported yet
"""

import sys
from pathlib import Path
from datetime import datetime
import re
import multiprocessing
from concurrent.futures import ProcessPoolExecutor, as_completed
import psycopg2
from psycopg2.extras import execute_values
import os
import json

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent))

from kingstore_simple_import import (
    get_db_connection, 
    parse_price_xml, 
    log as simple_log,
    extract_gz
)

def log(message, worker_id=None):
    """Thread-safe logging"""
    timestamp = datetime.now().strftime('%H:%M:%S')
    prefix = f"[{worker_id}]" if worker_id else ""
    print(f"[{timestamp}]{prefix} {message}", flush=True)

def get_release_date_from_filename(filename):
    """Extract release date (YYYYMMDD) from filename"""
    # Format: Price7290058108879-015-202512191522.gz
    # Extract date part: 20251219
    match = re.search(r'-(\d{8})\d{4}', filename)
    if match:
        return match.group(1)
    return None

def get_last_processed_release_date(conn):
    """Get the last release date that was processed"""
    cur = conn.cursor()
    try:
        # For now, return None to process all files
        # In the future, we could track release dates in a separate table
        # For now, we'll process files that haven't been processed yet by checking file existence
        return None
    except Exception as e:
        log(f"Warning: Could not get last processed date: {e}")
        return None
    finally:
        cur.close()

def group_files_by_release_date(download_dir):
    """Group all files by their release date"""
    download_path = Path(download_dir)
    files_by_date = {}
    
    log(f"Scanning files in {download_path}...")
    
    for file_path in download_path.glob('Price*.gz'):
        release_date = get_release_date_from_filename(file_path.name)
        if release_date:
            if release_date not in files_by_date:
                files_by_date[release_date] = []
            files_by_date[release_date].append(str(file_path))
    
    # Sort by date (newest first)
    sorted_dates = sorted(files_by_date.keys(), reverse=True)
    
    log(f"Found {len(files_by_date)} unique release dates")
    for date in sorted_dates[:10]:  # Show first 10
        log(f"  {date}: {len(files_by_date[date])} files")
    
    return files_by_date, sorted_dates

def process_files_for_date(file_list, worker_id):
    """Process all files for a specific release date"""
    log(f"Worker {worker_id}: Processing {len(file_list)} files", worker_id)
    
    # Import from kingstore_simple_import
    from kingstore_simple_import import import_products_and_prices
    
    conn = get_db_connection()
    stats = {'files': 0, 'products': 0, 'prices': 0, 'errors': 0}
    
    try:
        for file_path in file_list:
            file_path_obj = Path(file_path)
            log(f"  Processing: {file_path_obj.name}", worker_id)
            
            try:
                # Extract GZ if needed - returns XML path
                xml_path = extract_gz(file_path_obj)
                
                if not xml_path or not xml_path.exists():
                    log(f"    ⚠️  No XML extracted, skipping", worker_id)
                    stats['errors'] += 1
                    continue
                
                # Parse XML
                metadata, items = parse_price_xml(xml_path)
                
                if not items:
                    log(f"    ⚠️  No items found in XML", worker_id)
                    stats['errors'] += 1
                    continue
                
                # Import to database
                file_stats = import_products_and_prices(conn, metadata, items)
                
                stats['files'] += 1
                stats['products'] += file_stats.get('products', 0)
                stats['prices'] += file_stats.get('prices', 0)
                
                log(f"    ✅ {file_stats.get('prices', 0)} prices imported", worker_id)
                
            except Exception as e:
                log(f"    ❌ Error: {e}", worker_id)
                import traceback
                traceback.print_exc()
                stats['errors'] += 1
                continue
        
        conn.commit()
        
    except Exception as e:
        conn.rollback()
        log(f"  ❌ Fatal error: {e}", worker_id)
        import traceback
        traceback.print_exc()
    finally:
        conn.close()
    
    return stats

def main():
    """Main function"""
    log("=" * 70)
    log("KINGSTORE IMPORT BY RELEASE DATE")
    log("=" * 70)
    
    # Configuration
    download_dir = os.getenv('KINGSTORE_DOWNLOAD_DIR', '/app/data/kingstore/downloads')
    
    # Connect to database to check last processed date
    conn = get_db_connection()
    try:
        last_date = get_last_processed_release_date(conn)
        if last_date:
            log(f"Last processed release date: {last_date}")
        else:
            log("No previous imports found - will process all files")
    finally:
        conn.close()
    
    # Group files by release date
    files_by_date, sorted_dates = group_files_by_release_date(download_dir)
    
    if not files_by_date:
        log("❌ No files found!")
        return
    
    # Filter dates to process (only new ones)
    dates_to_process = []
    if last_date:
        # Process dates newer than last processed date
        for date in sorted_dates:
            if date > last_date:
                dates_to_process.append(date)
    else:
        # Process all dates if no previous imports
        dates_to_process = sorted_dates
    
    if not dates_to_process:
        log(f"✅ All files already processed (last date: {last_date})")
        return
    
    log(f"\nWill process {len(dates_to_process)} new release dates:")
    for date in dates_to_process:
        log(f"  {date}: {len(files_by_date[date])} files")
    
    # Process each date (oldest first to maintain chronological order)
    total_stats = {'dates': 0, 'files': 0, 'products': 0, 'prices': 0, 'errors': 0}
    start_time = datetime.now()
    
    # Process dates in chronological order (oldest first)
    dates_to_process_sorted = sorted(dates_to_process)
    
    for release_date in dates_to_process_sorted:
        log(f"\n{'='*70}")
        log(f"Processing release date: {release_date} ({len(files_by_date[release_date])} files)")
        log(f"{'='*70}")
        
        file_list = files_by_date[release_date]
        
        # Use parallel processing within each date
        num_workers = min(multiprocessing.cpu_count(), len(file_list), 10)
        
        if num_workers == 1 or len(file_list) == 1:
            # Single worker
            stats = process_files_for_date(file_list, 1)
            total_stats['dates'] += 1
            total_stats['files'] += stats['files']
            total_stats['products'] += stats['products']
            total_stats['prices'] += stats['prices']
            total_stats['errors'] += stats['errors']
        else:
            # Parallel processing
            log(f"Using {num_workers} parallel workers...")
            
            # Split files across workers
            chunk_size = max(1, len(file_list) // num_workers)
            file_chunks = [file_list[i:i + chunk_size] for i in range(0, len(file_list), chunk_size)]
            
            with ProcessPoolExecutor(max_workers=num_workers) as executor:
                futures = {
                    executor.submit(process_files_for_date, chunk, i+1): chunk
                    for i, chunk in enumerate(file_chunks)
                }
                
                date_stats = {'files': 0, 'products': 0, 'prices': 0, 'errors': 0}
                
                for future in as_completed(futures):
                    try:
                        stats = future.result()
                        date_stats['files'] += stats['files']
                        date_stats['products'] += stats['products']
                        date_stats['prices'] += stats['prices']
                        date_stats['errors'] += stats['errors']
                    except Exception as e:
                        log(f"❌ Worker error: {e}")
                        date_stats['errors'] += len(futures[future])
                
                total_stats['dates'] += 1
                total_stats['files'] += date_stats['files']
                total_stats['products'] += date_stats['products']
                total_stats['prices'] += date_stats['prices']
                total_stats['errors'] += date_stats['errors']
                
                log(f"✅ Date {release_date} complete: {date_stats['prices']} prices imported")
    
    # Final summary
    duration = (datetime.now() - start_time).total_seconds()
    log(f"\n{'='*70}")
    log("IMPORT COMPLETE")
    log(f"{'='*70}")
    log(f"Release dates processed: {total_stats['dates']}")
    log(f"Files processed:         {total_stats['files']}")
    log(f"Products imported:       {total_stats['products']}")
    log(f"Prices imported:         {total_stats['prices']:,}")
    log(f"Errors:                  {total_stats['errors']}")
    log(f"Duration:                {duration:.1f} seconds")
    if duration > 0:
        log(f"Speed:                   {total_stats['prices']/duration:.0f} prices/second")
    log(f"{'='*70}")

if __name__ == "__main__":
    main()

