#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Update Shufersal store names from Stores XML file
Extracts store names, addresses, and cities from the Stores XML file
and updates the stores table in the database
"""

import sys
import os
from pathlib import Path
import gzip
import xml.etree.ElementTree as ET
import psycopg2
from datetime import datetime

# Database configuration
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432'),
    'client_encoding': 'UTF8'
}

def log(message):
    """Print timestamped log"""
    timestamp = datetime.now().strftime('%H:%M:%S')
    print(f"[{timestamp}] {message}", flush=True)

def get_db_connection():
    """Get database connection"""
    return psycopg2.connect(**DB_CONFIG)

def parse_stores_xml(file_path):
    """Parse Shufersal Stores XML file and extract store information"""
    log(f"Parsing stores file: {file_path}")
    
    stores_data = {}
    
    try:
        # Handle GZ file
        if file_path.endswith('.gz'):
            with gzip.open(file_path, 'rb') as f:
                tree = ET.parse(f)
        else:
            tree = ET.parse(file_path)
        
        root = tree.getroot()
        
        # Find all STORE elements (handle different XML structures)
        stores = root.findall('.//STORE')
        
        log(f"Found {len(stores)} stores in XML")
        
        for store in stores:
            try:
                store_id_elem = store.find('STOREID')
                store_name_elem = store.find('STORENAME')
                address_elem = store.find('ADDRESS')
                city_elem = store.find('CITY')
                zipcode_elem = store.find('ZIPCODE')
                
                if store_id_elem is not None and store_name_elem is not None:
                    store_id = store_id_elem.text.strip() if store_id_elem.text else None
                    store_name = store_name_elem.text.strip() if store_name_elem.text else None
                    address = address_elem.text.strip() if address_elem is not None and address_elem.text else None
                    city = city_elem.text.strip() if city_elem is not None and city_elem.text else None
                    zipcode = zipcode_elem.text.strip() if zipcode_elem is not None and zipcode_elem.text else None
                    
                    if store_id and store_name:
                        # Normalize store_id (remove leading zeros for matching)
                        store_id_normalized = str(int(store_id)) if store_id.isdigit() else store_id
                        stores_data[store_id_normalized] = {
                            'store_id': store_id,  # Keep original for database
                            'name_he': store_name,
                            'address': address,
                            'city': city,
                            'zipcode': zipcode
                        }
                        
            except Exception as e:
                log(f"Error parsing store element: {e}")
                continue
        
        log(f"Successfully parsed {len(stores_data)} stores")
        return stores_data
        
    except Exception as e:
        log(f"Error parsing XML file: {e}")
        import traceback
        traceback.print_exc()
        return {}

def update_stores_in_db(conn, stores_data):
    """Update stores table with parsed store information"""
    log(f"Updating {len(stores_data)} stores in database...")
    
    cur = conn.cursor()
    
    try:
        # Get Shufersal chain ID
        cur.execute("SELECT id FROM chains WHERE slug = 'shufersal'")
        chain_result = cur.fetchone()
        
        if not chain_result:
            log("❌ Shufersal chain not found in database!")
            return 0
        
        chain_id = chain_result[0]
        updated = 0
        created = 0
        
        for store_id_normalized, store_info in stores_data.items():
            try:
                # Try to find store by store_id (may have leading zeros in DB)
                # Try multiple variations: original, normalized, zero-padded
                store_id_variations = [
                    store_info['store_id'],  # Original (e.g., "001")
                    store_id_normalized,     # Normalized (e.g., "1")
                    store_info['store_id'].zfill(3)  # Zero-padded to 3 digits
                ]
                
                cur.execute("""
                    SELECT id, store_id, name_he, city, address
                    FROM stores
                    WHERE chain_id = %s AND store_id = ANY(%s)
                    LIMIT 1
                """, (chain_id, store_id_variations))
                
                existing = cur.fetchone()
                
                if existing:
                    db_id, db_store_id, db_name_he, db_city, db_address = existing
                    
                    # Update if different
                    if (db_name_he != store_info['name_he'] or 
                        db_city != store_info.get('city') or 
                        db_address != store_info.get('address')):
                        
                        cur.execute("""
                            UPDATE stores 
                            SET name = %s,
                                name_he = %s,
                                city = COALESCE(NULLIF(%s, ''), city),
                                address = COALESCE(NULLIF(%s, ''), address)
                            WHERE id = %s
                        """, (
                            store_info['name_he'],  # Use Hebrew name for both name and name_he
                            store_info['name_he'],
                            store_info.get('city'),
                            store_info.get('address'),
                            db_id
                        ))
                        updated += 1
                        log(f"  ✅ Updated: {db_store_id} → {store_info['name_he']}")
                    else:
                        log(f"  ⏭️  Skipped: {db_store_id} (already up to date)")
                else:
                    # Store doesn't exist, create it
                    cur.execute("""
                        INSERT INTO stores (chain_id, store_id, name, name_he, city, address)
                        VALUES (%s, %s, %s, %s, %s, %s)
                        ON CONFLICT (chain_id, store_id) DO UPDATE
                        SET name = EXCLUDED.name,
                            name_he = EXCLUDED.name_he,
                            city = COALESCE(NULLIF(EXCLUDED.city, ''), stores.city),
                            address = COALESCE(NULLIF(EXCLUDED.address, ''), stores.address)
                    """, (
                        chain_id,
                        store_info['store_id'],
                        store_info['name_he'],
                        store_info['name_he'],
                        store_info.get('city'),
                        store_info.get('address')
                    ))
                    created += 1
                    log(f"  ➕ Created: {store_info['store_id']} → {store_info['name_he']}")
                    
            except Exception as e:
                log(f"  ❌ Error updating store {store_id_normalized}: {e}")
                continue
        
        conn.commit()
        log(f"\n✅ Update complete: {updated} updated, {created} created")
        return updated + created
        
    except Exception as e:
        conn.rollback()
        log(f"❌ Error updating stores: {e}")
        import traceback
        traceback.print_exc()
        return 0
    finally:
        cur.close()

def main():
    """Main function"""
    log("=" * 70)
    log("SHUFERSAL STORE NAMES UPDATER")
    log("=" * 70)
    
    # Find Stores XML file
    data_dir = Path(os.getenv('SHUFERSAL_DATA_DIR', '/app/data/shufersal'))
    
    stores_files = list(data_dir.glob('Stores*.gz')) + list(data_dir.glob('Stores*.xml'))
    
    if not stores_files:
        log(f"❌ No Stores XML files found in {data_dir}")
        return
    
    # Use the most recent file
    stores_file = max(stores_files, key=lambda p: p.stat().st_mtime)
    log(f"Using file: {stores_file.name}")
    
    # Parse stores XML
    stores_data = parse_stores_xml(str(stores_file))
    
    if not stores_data:
        log("❌ No stores found in XML file")
        return
    
    # Connect to database and update
    conn = get_db_connection()
    try:
        updated_count = update_stores_in_db(conn, stores_data)
        log(f"\n✅ Successfully processed {updated_count} stores")
    finally:
        conn.close()

if __name__ == "__main__":
    main()

