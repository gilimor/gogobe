#!/usr/bin/env python3
"""
Test import on 2 stores to verify store_id fix
"""

import sys
from pathlib import Path
from kingstore_simple_import import get_db_connection, parse_price_xml, import_products_and_prices, log

def main():
    """Test import on 2 files"""
    data_dir = Path("/app/data/kingstore/downloads")
    
    if not data_dir.exists():
        log(f"ERROR Directory not found: {data_dir}")
        return
    
    # Find XML files
    xml_files = sorted(data_dir.glob("Price*.xml"))
    
    if len(xml_files) < 2:
        log(f"ERROR Need at least 2 XML files, found {len(xml_files)}")
        return
    
    # Take first file and find a file from a different store
    test_files = [xml_files[0]]  # First file (store 1)
    
    # Parse first file to get its store_id
    from kingstore_simple_import import parse_price_xml
    metadata1, _ = parse_price_xml(xml_files[0])
    store_id_1 = metadata1.get('store_id') if metadata1 else None
    
    # Find a file from a different store
    for f in xml_files[1:]:
        metadata2, _ = parse_price_xml(f)
        store_id_2 = metadata2.get('store_id') if metadata2 else None
        if store_id_2 and store_id_2 != store_id_1:
            test_files.append(f)
            break
    
    if len(test_files) < 2:
        # Fallback: just take first 2 files
        test_files = xml_files[:2]
    
    log("=" * 80)
    log("TEST: KingStore Import (2 stores)")
    log("=" * 80)
    log(f"Testing with {len(test_files)} files:")
    for f in test_files:
        log(f"  - {f.name}")
    
    # Connect to database
    try:
        conn = get_db_connection()
    except Exception as e:
        log(f"ERROR Database connection failed: {e}")
        return
    
    total_stats = {'files': 0, 'products': 0, 'prices': 0, 'skipped': 0, 'errors': 0}
    
    # Process test files
    for xml_file in test_files:
        try:
            log("")
            log("-" * 80)
            log(f"Processing: {xml_file.name}")
            
            # Parse XML
            metadata, items = parse_price_xml(xml_file)
            if not metadata:
                log("ERROR Failed to parse")
                total_stats['errors'] += 1
                continue
            
            log(f"Found: {len(items)} items")
            log(f"Store ID: {metadata.get('store_id')}")
            log(f"Store Name: {metadata.get('store_name')}")
            
            # Import
            stats = import_products_and_prices(conn, metadata, items)
            
            log(f"OK +{stats['products']} products, +{stats['prices']} prices, {stats['skipped']} skipped")
            
            total_stats['files'] += 1
            total_stats['products'] += stats['products']
            total_stats['prices'] += stats['prices']
            total_stats['skipped'] += stats['skipped']
            
        except Exception as e:
            log(f"ERROR {e}")
            total_stats['errors'] += 1
    
    conn.close()
    
    log("")
    log("=" * 80)
    log("TEST SUMMARY")
    log("=" * 80)
    log(f"Files processed:    {total_stats['files']}")
    log(f"Products created:   {total_stats['products']}")
    log(f"Prices imported:    {total_stats['prices']}")
    log(f"Items skipped:      {total_stats['skipped']}")
    log(f"Errors:             {total_stats['errors']}")
    log("=" * 80)
    
    if total_stats['errors'] == 0:
        log("✅ TEST PASSED - No errors!")
    else:
        log("❌ TEST FAILED - Errors detected!")

if __name__ == "__main__":
    main()

