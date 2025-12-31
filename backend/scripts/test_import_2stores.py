#!/usr/bin/env python3
"""
Test import with optimized upsert_price on 2 stores only
"""

import sys
from pathlib import Path

# Set to import only 2 files
MAX_FILES = 2

# Add the parent directory to path
sys.path.insert(0, str(Path(__file__).parent))

# Import the main script
from kingstore_simple_import import *

def main():
    """Import only first 2 stores for testing"""
    data_dir = Path("/app/data/kingstore/downloads")
    
    log("=" * 80)
    log("KingStore Test Import - 2 Stores Only (with upsert_price)")
    log("=" * 80)
    log(f"Directory: {data_dir}")
    
    if not data_dir.exists():
        log(f"ERROR Directory not found: {data_dir}")
        return
    
    # Find XML files - LIMIT TO 2
    xml_files = sorted(data_dir.glob("Price*.xml"))[:MAX_FILES]
    
    log(f"Found: {len(xml_files)} XML files (limited to {MAX_FILES})")
    
    if not xml_files:
        log("ERROR No files found!")
        return
    
    # Connect to database
    try:
        conn = get_db_connection()
        log("Connected to database")
    except Exception as e:
        log(f"ERROR Database connection failed: {e}")
        return
    
    # Process files
    total_stats = {'files': 0, 'products': 0, 'prices': 0, 'skipped': 0, 'errors': 0}
    
    for i, xml_file in enumerate(xml_files):
        try:
            log(f"\n[{i+1}/{len(xml_files)}] {xml_file.name}")
            
            metadata, items = parse_price_xml(xml_file)
            if not metadata:
                log("ERROR Failed to parse")
                total_stats['errors'] += 1
                continue
            
            log(f"Found {len(items)} items")
            
            stats = import_products_and_prices(conn, metadata, items)
            
            total_stats['files'] += 1
            total_stats['products'] += stats['products']
            total_stats['prices'] += stats['prices']
            total_stats['skipped'] += stats['skipped']
            
            log(f"OK +{stats['products']} products, +{stats['prices']} prices, {stats['skipped']} skipped")
            
        except Exception as e:
            log(f"ERROR {e}")
            total_stats['errors'] += 1
    
    conn.close()
    
    # Final summary
    log("\n" + "=" * 80)
    log("IMPORT COMPLETE")
    log("=" * 80)
    log(f"Files processed: {total_stats['files']}")
    log(f"Products imported: {total_stats['products']}")
    log(f"Prices imported: {total_stats['prices']}")
    log(f"Items skipped: {total_stats['skipped']}")
    log(f"Errors: {total_stats['errors']}")
    log("=" * 80)

if __name__ == "__main__":
    main()

