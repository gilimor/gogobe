#!/usr/bin/env python3
"""
KingStore Ultra-Fast Import - Maximum performance
Uses COPY command, minimal commits, optimized for millions of records/hour
"""

import sys
from pathlib import Path
from datetime import datetime
import multiprocessing
from concurrent.futures import ProcessPoolExecutor, as_completed
import psycopg2
from psycopg2.extras import execute_values
from io import StringIO
import os
import json
import csv

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

def import_with_copy(conn, products_data, prices_data):
    """
    Ultra-fast import using PostgreSQL COPY command
    This is the fastest method for bulk inserts
    """
    cur = conn.cursor()
    stats = {'products': 0, 'prices': 0}
    
    try:
        # Import products using COPY
        if products_data:
            products_io = StringIO()
            writer = csv.writer(products_io, delimiter='\t')
            for row in products_data:
                writer.writerow(row)
            products_io.seek(0)
            
            cur.copy_from(
                products_io,
                'products',
                columns=('name', 'description', 'vertical_id', 'ean', 'manufacturer_code', 'attributes'),
                null=''
            )
            stats['products'] = len(products_data)
        
        # Import prices using COPY
        if prices_data:
            prices_io = StringIO()
            writer = csv.writer(prices_io, delimiter='\t')
            for row in prices_data:
                writer.writerow(row)
            prices_io.seek(0)
            
            cur.copy_from(
                prices_io,
                'prices',
                columns=('product_id', 'supplier_id', 'store_id', 'price', 'currency', 'is_available', 'first_scraped_at', 'last_scraped_at', 'scraped_at'),
                null=''
            )
            stats['prices'] = len(prices_data)
        
        conn.commit()
        
    except Exception as e:
        conn.rollback()
        raise e
    finally:
        cur.close()
    
    return stats

def import_products_and_prices_ultra_fast(conn, metadata, items):
    """Ultra-fast import optimized for maximum throughput"""
    cur = conn.cursor()
    stats = {'products': 0, 'prices': 0, 'skipped': 0}
    
    try:
        # Get IDs once
        cur.execute("SELECT id FROM verticals WHERE slug = 'supermarket'")
        vertical_id = cur.fetchone()[0]
        
        cur.execute("SELECT id FROM suppliers WHERE slug = 'kingstore'")
        supplier_id = cur.fetchone()[0]
        
        cur.execute("SELECT id FROM chains WHERE slug = 'kingstore'")
        chain_result = cur.fetchone()
        chain_id = chain_result[0] if chain_result else None
        
        store_table_id = None
        if metadata.get('store_id') and chain_id:
            cur.execute("SELECT id FROM stores WHERE chain_id = %s AND store_id = %s LIMIT 1", 
                       (chain_id, metadata.get('store_id')))
            store_result = cur.fetchone()
            if store_result:
                store_table_id = store_result[0]
        
        conn.commit()
        
        # Prepare all data in memory first
        products_map = {}  # barcode -> (product_id, name)
        products_to_insert = []
        prices_to_insert = []
        now = datetime.now()
        
        # Phase 1: Collect all barcodes and prepare product data
        for item in items:
            if not item.get('item_name') or not item.get('price'):
                stats['skipped'] += 1
                continue
            
            barcode = item.get('item_code')
            item_name = item['item_name'][:500]
            
            if barcode:
                products_map[barcode] = (None, item_name)  # Will be filled with product_id
        
        # Phase 2: Batch lookup existing products
        if products_map:
            barcodes = list(products_map.keys())
            cur.execute("""
                SELECT id, COALESCE(ean, manufacturer_code) as code
                FROM products 
                WHERE ean = ANY(%s) OR manufacturer_code = ANY(%s)
            """, (barcodes, barcodes))
            
            for row in cur.fetchall():
                product_id, code = row
                if code in products_map:
                    products_map[code] = (product_id, products_map[code][1])
        
        # Phase 3: Prepare new products for batch insert
        for barcode, (product_id, item_name) in products_map.items():
            if product_id is None:
                # Find item data
                item = next((i for i in items if i.get('item_code') == barcode), None)
                if item:
                    description = f"{item.get('manufacturer_name', '')} {item.get('manufacturer_desc', '')}".strip()
                    attributes = {
                        'unit_qty': item.get('unit_qty'),
                        'quantity': item.get('quantity'),
                        'unit_of_measure': item.get('unit_of_measure'),
                        'is_weighted': item.get('is_weighted') == '1',
                        'qty_in_package': item.get('qty_in_package'),
                        'manufacture_country': item.get('manufacture_country'),
                        'item_type': item.get('item_type'),
                    }
                    attributes = {k: v for k, v in attributes.items() if v is not None}
                    
                    products_to_insert.append((
                        item_name,
                        description[:1000],
                        vertical_id,
                        barcode,
                        barcode,
                        json.dumps(attributes, ensure_ascii=False) if attributes else '{}'
                    ))
        
        # Phase 4: Batch insert products using execute_values (faster than COPY for small batches)
        if products_to_insert:
            returned = execute_values(
                cur,
                """
                INSERT INTO products (name, description, vertical_id, ean, manufacturer_code, attributes)
                VALUES %s
                ON CONFLICT DO NOTHING
                RETURNING id, COALESCE(ean, manufacturer_code) as code
                """,
                products_to_insert,
                template=None,
                page_size=1000,
                fetch=True
            )
            
            # Update products_map with new IDs
            if returned:
                for row in returned:
                    product_id, code = row
                    if code in products_map:
                        products_map[code] = (product_id, products_map[code][1])
            
            stats['products'] = len(returned) if returned else 0
        
        # Phase 5: Prepare all prices
        for item in items:
            if not item.get('item_name') or not item.get('price'):
                continue
            
            try:
                price_value = float(item['price'])
            except (TypeError, ValueError):
                stats['skipped'] += 1
                continue
            
            barcode = item.get('item_code')
            product_id = None
            
            if barcode and barcode in products_map:
                product_id = products_map[barcode][0]
            
            if not product_id:
                # Fallback: find by name
                item_name = item['item_name'][:500]
                for b, (pid, name) in products_map.items():
                    if name == item_name and pid:
                        product_id = pid
                        break
            
            if product_id:
                prices_to_insert.append((
                    product_id,
                    supplier_id,
                    store_table_id,
                    price_value,
                    'ILS',
                    True,
                    now,
                    now,
                    now
                ))
        
        # Phase 6: Batch insert prices using execute_values (very fast)
        if prices_to_insert:
            # Use execute_values with page_size for optimal performance
            execute_values(
                cur,
                """
                INSERT INTO prices (
                    product_id, supplier_id, store_id, price, currency,
                    is_available, first_scraped_at, last_scraped_at, scraped_at
                )
                VALUES %s
                ON CONFLICT DO NOTHING
                """,
                prices_to_insert,
                template=None,
                page_size=5000  # Large page size for maximum speed
            )
            stats['prices'] = len(prices_to_insert)
        
        # Single commit for entire batch
        conn.commit()
        
    except Exception as e:
        log(f"[ERROR] Import failed: {e}")
        conn.rollback()
        raise
    finally:
        cur.close()
    
    return stats

def process_single_file_ultra_fast(file_info):
    """Process a single file - ultra-fast version"""
    file_path, worker_id = file_info
    
    from pathlib import Path
    from kingstore_ultra_fast_import import get_db_connection, parse_price_xml, import_products_and_prices_ultra_fast
    
    stats = {'products': 0, 'prices': 0, 'skipped': 0}
    
    try:
        log(f"Processing: {Path(file_path).name}", worker_id)
        
        conn = get_db_connection()
        
        try:
            metadata, items = parse_price_xml(Path(file_path))
            if not metadata:
                return (Path(file_path).name, False, stats, "Failed to parse XML")
            
            log(f"Found {len(items)} items (Store: {metadata.get('store_name', 'Unknown')})", worker_id)
            
            stats = import_products_and_prices_ultra_fast(conn, metadata, items)
            
            log(f"✅ +{stats['products']} products, +{stats['prices']} prices, {stats['skipped']} skipped", worker_id)
            
            return (Path(file_path).name, True, stats, None)
            
        finally:
            conn.close()
            
    except Exception as e:
        error_msg = str(e)
        log(f"❌ Error: {error_msg}", worker_id)
        return (Path(file_path).name, False, stats, error_msg)

def main():
    """Main entry point - ultra-fast version"""
    if len(sys.argv) > 1:
        data_dir = Path(sys.argv[1])
    else:
        data_dir = Path("/app/data/kingstore/downloads")
    
    # Maximum workers for ultra-fast import
    num_workers = int(os.getenv('KINGSTORE_WORKERS', min(multiprocessing.cpu_count() * 2, 20)))
    
    log("=" * 80)
    log("KingStore ULTRA-FAST Import")
    log("=" * 80)
    log(f"Directory: {data_dir}")
    log(f"Parallel workers: {num_workers}")
    
    if not data_dir.exists():
        log(f"ERROR Directory not found: {data_dir}")
        return
    
    xml_files = sorted(data_dir.glob("Price*.xml"))
    log(f"Found: {len(xml_files)} XML files")
    
    if not xml_files:
        log("ERROR No files found!")
        return
    
    file_list = [(str(f), i % num_workers) for i, f in enumerate(xml_files)]
    
    total_stats = {'files': 0, 'products': 0, 'prices': 0, 'skipped': 0, 'errors': 0}
    start_time = datetime.now()
    
    log(f"\n🚀 Starting ULTRA-FAST import with {num_workers} workers...")
    
    with ProcessPoolExecutor(max_workers=num_workers) as executor:
        future_to_file = {
            executor.submit(process_single_file_ultra_fast, file_info): file_info[0] 
            for file_info in file_list
        }
        
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
                    if completed % 20 == 0 or completed == total:
                        log(f"[{completed}/{total}] ✅ Progress: {total_stats['prices']} prices imported")
                else:
                    total_stats['errors'] += 1
                    log(f"[{completed}/{total}] ❌ {result_filename}: {error}")
                    
            except Exception as e:
                total_stats['errors'] += 1
                log(f"[{completed}/{total}] ❌ {filename}: {e}")
    
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
    if duration > 0:
        log(f"Speed:              {total_stats['prices']/duration:.1f} prices/second")
        log(f"Throughput:         {total_stats['prices']/duration*3600/1000000:.2f}M prices/hour")
    log("=" * 80)
    
    if total_stats['errors'] == 0:
        log("✅ All files processed successfully!")
    else:
        log(f"⚠️  {total_stats['errors']} files had errors")

if __name__ == "__main__":
    main()


