#!/usr/bin/env python3
"""
Simple KingStore XML Import
Works with existing schema (products, prices, suppliers)
"""

import sys
from pathlib import Path
from datetime import datetime
import xml.etree.ElementTree as ET
import gzip
import psycopg2
import os
import json

def get_db_connection():
    """Get database connection with proper UTF-8 encoding"""
    conn = psycopg2.connect(
        dbname=os.getenv('DB_NAME', 'gogobe'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host=os.getenv('DB_HOST', 'db'),
        port=os.getenv('DB_PORT', '5432'),
        client_encoding='UTF8'
    )
    return conn

def log(message):
    """Print timestamped log"""
    timestamp = datetime.now().strftime('%H:%M:%S')
    print(f"[{timestamp}] {message}", flush=True)

def extract_gz(gz_path):
    """Extract GZ file"""
    xml_path = gz_path.with_suffix('')
    
    if xml_path.exists():
        return xml_path
    
    try:
        with gzip.open(gz_path, 'rb') as f_in:
            with open(xml_path, 'wb') as f_out:
                f_out.write(f_in.read())
        return xml_path
    except Exception as e:
        log(f"[ERROR] Extraction failed: {e}")
        return None

def parse_price_xml(xml_path):
    """Parse Prices XML file"""
    # KingStore store ID to name mapping (with full names from website)
    STORE_NAMES = {
        '1': 'קינג סטור - סניף 1',
        '2': 'קינג סטור - סניף 2',
        '3': 'קינג סטור - סניף 3',
        '5': 'קינג סטור - סניף 5',
        '6': 'קינג סטור - סניף 6',
        '7': 'קינג סטור - סניף 7',
        '8': 'קינג סטור - סניף 8',
        '9': 'קינג סטור - סניף 9',
        '10': 'קינג סטור - סניף 10',
        '12': 'קינג סטור - סניף 12',
        '13': 'קינג סטור - סניף 13',
        '14': 'קינג סטור - סניף 14',
        '15': 'קינג סטור - סניף 15',
        '16': 'קינג סטור - סניף 16',
        '17': 'קינג סטור - סניף 17',
        '18': 'קינג סטור - סניף 18',
        '19': 'קינג סטור - סניף 19',
        '27': 'קינג סטור - סניף 27',
        '28': 'קינג סטור - סניף 28',
        '30': 'קינג סטור - סניף 30',
        '31': 'צים סנטר נוף הגליל',
        '200': 'ירושליים',
        '334': 'דיר חנא זכיינות',
        '336': 'דוכאן קלנסווה',
        '338': 'דוכאן חי אלוורוד',
        '339': 'יפו תלאביב מכללה',
        '340': 'מיני קינג סח\'נין',
    }
    
    try:
        # Read with UTF-8 encoding (verified to work with KingStore files)
        with open(xml_path, 'r', encoding='utf-8') as f:
            tree = ET.parse(f)
        root = tree.getroot()
        
        store_id = root.findtext('StoreId')
        metadata = {
            'chain_id': root.findtext('ChainId'),
            'subchain_id': root.findtext('SubChainId'),
            'store_id': store_id,
            'store_name': STORE_NAMES.get(store_id, f'קינג סטור - סניף {store_id}') if store_id else 'קינג סטור',
            'bikoret_no': root.findtext('BikoretNo'),
        }
        
        items = []
        for item in root.findall('.//Item'):
            product = {
                'item_code': item.findtext('ItemCode'),
                'item_name': item.findtext('ItemNm') or item.findtext('ItemName'),
                'manufacturer_name': item.findtext('ManufacturerName'),
                'manufacturer_desc': item.findtext('ManufacturerItemDescription'),
                'manufacture_country': item.findtext('ManufactureCountry'),
                'price': item.findtext('ItemPrice'),
                'unit_qty': item.findtext('UnitQty'),
                'quantity': item.findtext('Quantity'),
                'unit_of_measure': item.findtext('UnitOfMeasure'),
                'is_weighted': item.findtext('bIsWeighted'),
                'qty_in_package': item.findtext('QtyInPackage'),
                'unit_price': item.findtext('UnitOfMeasurePrice'),
                'item_type': item.findtext('ItemType'),
            }
            items.append(product)
        
        return metadata, items
        
    except Exception as e:
        log(f"[ERROR] XML parsing failed: {e}")
        return None, []

def import_products_and_prices(conn, metadata, items):
    """Import products and prices"""
    cur = conn.cursor()
    stats = {'products': 0, 'prices': 0, 'skipped': 0}
    
    try:
        # Get or create vertical "Supermarket"
        cur.execute("""
            INSERT INTO verticals (name, slug, is_priority)
            VALUES ('Supermarket', 'supermarket', FALSE)
            ON CONFLICT (slug) DO NOTHING
        """)
        
        cur.execute("SELECT id FROM verticals WHERE slug = 'supermarket'")
        vertical_id = cur.fetchone()[0]
        
        # Get or create supplier "KingStore"
        cur.execute("""
            INSERT INTO suppliers (name, slug, country_code, supplier_type)
            VALUES ('KingStore', 'kingstore', 'IL', 'supermarket')
            ON CONFLICT (slug) DO NOTHING
        """)
        
        cur.execute("SELECT id FROM suppliers WHERE slug = 'kingstore'")
        supplier_id = cur.fetchone()[0]
        
        # Get or create chain
        cur.execute("SELECT id FROM chains WHERE slug = 'kingstore'")
        chain_result = cur.fetchone()
        if chain_result:
            chain_id = chain_result[0]
        else:
            cur.execute("""
                INSERT INTO chains (name, slug, name_he)
                VALUES ('KingStore', 'kingstore', 'קינג סטור')
                ON CONFLICT (slug) DO NOTHING
                RETURNING id
            """)
            result = cur.fetchone()
            if result:
                chain_id = result[0]
            else:
                cur.execute("SELECT id FROM chains WHERE slug = 'kingstore'")
                chain_id = cur.fetchone()[0]
        
        # Get store table ID from store_id (metadata has store_id like "15", we need stores.id)
        store_table_id = None
        if metadata.get('store_id'):
            cur.execute("""
                SELECT id FROM stores 
                WHERE chain_id = %s AND store_id = %s
                LIMIT 1
            """, (chain_id, metadata.get('store_id')))
            store_result = cur.fetchone()
            if store_result:
                store_table_id = store_result[0]
        
        conn.commit()
        
        # Import items
        for item in items:
            try:
                if not item['item_name'] or not item['price']:
                    stats['skipped'] += 1
                    continue
                
                # Check if product exists by barcode
                product_id = None
                if item.get('item_code'):
                    cur.execute("""
                        SELECT id FROM products 
                        WHERE (ean = %s OR manufacturer_code = %s)
                        LIMIT 1
                    """, (item['item_code'], item['item_code']))
                    
                    existing = cur.fetchone()
                    if existing:
                        product_id = existing[0]
                
                # Create new product if not found
                if not product_id:
                    description = f"{item.get('manufacturer_name', '')} {item.get('manufacturer_desc', '')}".strip()
                    
                    # Build attributes JSON with all extra fields
                    attributes = {
                        'unit_qty': item.get('unit_qty'),
                        'quantity': item.get('quantity'),
                        'unit_of_measure': item.get('unit_of_measure'),
                        'is_weighted': item.get('is_weighted') == '1',
                        'qty_in_package': item.get('qty_in_package'),
                        'manufacture_country': item.get('manufacture_country'),
                        'item_type': item.get('item_type'),
                        'chain_id': metadata.get('chain_id'),
                        'store_id': metadata.get('store_id'),
                        'store_name': metadata.get('store_name'),
                    }
                    # Remove None values
                    attributes = {k: v for k, v in attributes.items() if v is not None}
                    
                    cur.execute("""
                        INSERT INTO products (
                            name, 
                            description, 
                            vertical_id,
                            ean,
                            manufacturer_code,
                            attributes
                        )
                        VALUES (%s, %s, %s, %s, %s, %s::jsonb)
                        ON CONFLICT DO NOTHING
                        RETURNING id
                    """, (
                        item['item_name'][:500],
                        description[:1000],
                        vertical_id,
                        item.get('item_code'),
                        item.get('item_code'),
                        json.dumps(attributes, ensure_ascii=False)
                    ))
                    
                    result = cur.fetchone()
                    if result:
                        product_id = result[0]
                        stats['products'] += 1
                    else:
                        # Product already exists, get it by barcode first, then by name
                        if item.get('item_code'):
                            cur.execute("""
                                SELECT id FROM products 
                                WHERE (ean = %s OR manufacturer_code = %s)
                                LIMIT 1
                            """, (item['item_code'], item['item_code']))
                            result = cur.fetchone()
                        
                        if not result:
                            cur.execute("""
                                SELECT id FROM products 
                                WHERE name = %s AND vertical_id = %s
                                LIMIT 1
                            """, (item['item_name'][:500], vertical_id))
                            result = cur.fetchone()
                        
                        if result:
                            product_id = result[0]
                
                if not product_id:
                    stats['skipped'] += 1
                    continue
                
                # Insert price using smart upsert function
                try:
                    price_value = float(item['price'])
                except (TypeError, ValueError):
                    stats['skipped'] += 1
                    continue
                
                # Use upsert_price function for smart insert/update
                # store_table_id is the stores.id (not stores.store_id)
                cur.execute("""
                    SELECT upsert_price(
                        %s,    -- product_id
                        %s,    -- supplier_id
                        %s,    -- store_id (stores.id, not stores.store_id)
                        %s,    -- price
                        'ILS', -- currency
                        TRUE,  -- is_available
                        0.01   -- price_tolerance (1 אגורה)
                    )
                """, (product_id, supplier_id, store_table_id, price_value))
                
                price_id = cur.fetchone()[0]
                stats['prices'] += 1
                
            except Exception as e:
                # Skip problematic items but keep a trace
                log(f"[WARN] Skipping item {item.get('item_code') or item.get('item_name')} - {e}")
                stats['skipped'] += 1
                continue
        
        conn.commit()
        
    except Exception as e:
        log(f"[ERROR] Import failed: {e}")
        conn.rollback()
    finally:
        cur.close()
    
    return stats

def main():
    """Main entry point"""
    if len(sys.argv) > 1:
        data_dir = Path(sys.argv[1])
    else:
        data_dir = Path("/app/data/kingstore/downloads")
    
    log("=" * 80)
    log("KingStore Simple Import")
    log("=" * 80)
    log(f"Directory: {data_dir}")
    
    if not data_dir.exists():
        log(f"ERROR Directory not found: {data_dir}")
        return
    
    # Find XML and GZ files
    xml_files = sorted(data_dir.glob("Price*.xml"))
    gz_files = []  # Skip GZ files if XML exists
    
    log(f"Found: {len(xml_files)} XML files")
    
    if not xml_files and not gz_files:
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
    
    # Process XML files first
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
    
    # Process GZ files
    for i, gz_file in enumerate(gz_files):
        try:
            log(f"\n[{i+1+len(xml_files)}/{len(xml_files)+len(gz_files)}] {gz_file.name}")
            
            # Extract
            xml_file = extract_gz(gz_file)
            if not xml_file:
                log("ERROR Extraction failed")
                total_stats['errors'] += 1
                continue
            
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
    
    # Summary
    log("\n" + "=" * 80)
    log("SUMMARY")
    log("=" * 80)
    log(f"Files processed:    {total_stats['files']}")
    log(f"Products created:   {total_stats['products']}")
    log(f"Prices imported:    {total_stats['prices']}")
    log(f"Items skipped:      {total_stats['skipped']}")
    log(f"Errors:             {total_stats['errors']}")
    log("=" * 80)
    
    conn.close()

if __name__ == "__main__":
    main()
