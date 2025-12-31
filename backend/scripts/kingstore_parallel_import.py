#!/usr/bin/env python3
"""
KingStore Parallel Import
Process multiple stores in parallel for faster import
"""

import sys
from pathlib import Path
from datetime import datetime
import multiprocessing
from concurrent.futures import ProcessPoolExecutor, as_completed
import psycopg2
import os

# Note: Functions imported inside process_single_file for multiprocessing compatibility

def log(message, worker_id=None):
    """Thread-safe logging"""
    timestamp = datetime.now().strftime('%H:%M:%S')
    prefix = f"[{worker_id}]" if worker_id else ""
    print(f"[{timestamp}]{prefix} {message}", flush=True)

def process_single_file(file_info):
    """
    Process a single file - designed to run in parallel
    Returns: (filename, success, stats, error_message)
    
    NOTE: This function runs in a separate process, so imports must be here
    """
    file_path, worker_id = file_info
    stats = {'products': 0, 'prices': 0, 'skipped': 0}
    
    # Import here (needed for multiprocessing)
    from pathlib import Path
    from kingstore_simple_import import (
        get_db_connection, 
        parse_price_xml, 
        import_products_and_prices
    )
    
    try:
        log(f"Processing: {Path(file_path).name}", worker_id)
        
        # Each worker gets its own DB connection
        conn = get_db_connection()
        
        try:
            # Parse XML
            metadata, items = parse_price_xml(Path(file_path))
            if not metadata:
                return (Path(file_path).name, False, stats, "Failed to parse XML")
            
            log(f"Found {len(items)} items (Store: {metadata.get('store_name', 'Unknown')})", worker_id)
            
            # Import
            stats = import_products_and_prices(conn, metadata, items)
            
            log(f"✅ +{stats['products']} products, +{stats['prices']} prices, {stats['skipped']} skipped", worker_id)
            
            return (Path(file_path).name, True, stats, None)
            
        finally:
            conn.close()
            
    except Exception as e:
        error_msg = str(e)
        log(f"❌ Error: {error_msg}", worker_id)
        return (Path(file_path).name, False, stats, error_msg)

def main():
    """Main entry point with parallel processing"""
    if len(sys.argv) > 1:
        data_dir = Path(sys.argv[1])
    else:
        data_dir = Path("/app/data/kingstore/downloads")
    
    # Number of parallel workers (default: number of CPU cores, max 8)
    num_workers = int(os.getenv('KINGSTORE_WORKERS', min(multiprocessing.cpu_count(), 8)))
    
    log("=" * 80)
    log("KingStore Parallel Import")
    log("=" * 80)
    log(f"Directory: {data_dir}")
    log(f"Parallel workers: {num_workers}")
    
    if not data_dir.exists():
        log(f"ERROR Directory not found: {data_dir}")
        return
    
    # Find XML files
    xml_files = sorted(data_dir.glob("Price*.xml"))
    gz_files = []  # Skip GZ files if XML exists
    
    log(f"Found: {len(xml_files)} XML files")
    
    if not xml_files and not gz_files:
        log("ERROR No files found!")
        return
    
    # Prepare file list with worker IDs
    file_list = [(str(f), i % num_workers) for i, f in enumerate(xml_files)]
    
    # Process files in parallel
    total_stats = {'files': 0, 'products': 0, 'prices': 0, 'skipped': 0, 'errors': 0}
    
    start_time = datetime.now()
    
    log(f"\n🚀 Starting parallel import with {num_workers} workers...")
    
    with ProcessPoolExecutor(max_workers=num_workers) as executor:
        # Submit all tasks
        future_to_file = {
            executor.submit(process_single_file, file_info): file_info[0] 
            for file_info in file_list
        }
        
        # Process completed tasks
        completed = 0
        total = len(file_list)
        
        for future in as_completed(future_to_file):
            completed += 1
            filename = future_to_file[future]
            
            try:
                result_filename, success, stats, error = future.result()
                
                if success:
                    total_stats['files'] += 1
                    total_stats['products'] += stats['products']
                    total_stats['prices'] += stats['prices']
                    total_stats['skipped'] += stats['skipped']
                    log(f"[{completed}/{total}] ✅ {result_filename}")
                else:
                    total_stats['errors'] += 1
                    log(f"[{completed}/{total}] ❌ {result_filename}: {error}")
                    
            except Exception as e:
                total_stats['errors'] += 1
                log(f"[{completed}/{total}] ❌ {filename}: {e}")
    
    # Process GZ files sequentially (if any)
    if gz_files:
        log("\nProcessing GZ files...")
        from kingstore_simple_import import get_db_connection, extract_gz, parse_price_xml, import_products_and_prices
        conn = get_db_connection()
        try:
            for gz_file in gz_files:
                try:
                    log(f"Extracting: {gz_file.name}")
                    xml_file = extract_gz(gz_file)
                    if not xml_file:
                        total_stats['errors'] += 1
                        continue
                    
                    metadata, items = parse_price_xml(xml_file)
                    if not metadata:
                        total_stats['errors'] += 1
                        continue
                    
                    stats = import_products_and_prices(conn, metadata, items)
                    total_stats['files'] += 1
                    total_stats['products'] += stats['products']
                    total_stats['prices'] += stats['prices']
                    total_stats['skipped'] += stats['skipped']
                    
                except Exception as e:
                    log(f"ERROR {gz_file.name}: {e}")
                    total_stats['errors'] += 1
        finally:
            conn.close()
    
    # Summary
    end_time = datetime.now()
    duration = (end_time - start_time).total_seconds()
    
    log("\n" + "=" * 80)
    log("SUMMARY")
    log("=" * 80)
    log(f"Files processed:    {total_stats['files']}")
    log(f"Products created:   {total_stats['products']}")
    log(f"Prices imported:    {total_stats['prices']}")
    log(f"Items skipped:      {total_stats['skipped']}")
    log(f"Errors:             {total_stats['errors']}")
    log(f"Duration:           {duration:.1f} seconds ({duration/60:.1f} minutes)")
    log(f"Speed:              {total_stats['prices']/duration:.1f} prices/second")
    log("=" * 80)
    
    if total_stats['errors'] == 0:
        log("✅ All files processed successfully!")
    else:
        log(f"⚠️  {total_stats['errors']} files had errors")

if __name__ == "__main__":
    main()

