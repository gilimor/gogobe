#!/usr/bin/env python3
"""
High-Performance Parallel Importer for Shufersal
Uses Multiprocessing to parse and import multiple files simultaneously.
"""

import os
import sys
import glob
import time
import gzip
import logging
import argparse
import multiprocessing
import shutil
from pathlib import Path
from typing import List, Tuple, Dict
from concurrent.futures import ProcessPoolExecutor, as_completed

# Add backend to path
backend_dir = Path(__file__).parent.parent
sys.path.append(str(backend_dir))
# Add scrapers to path to allow direct imports inside scrapers
sys.path.append(str(backend_dir / 'scrapers'))

from scrapers.shufersal_scraper import ShufersalScraper
from scrapers.base_supermarket_scraper import ParsedStore
import xml.etree.ElementTree as ET

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='[%(asctime)s] P%(process)s %(levelname)s: %(message)s',
    datefmt='%H:%M:%S'
)
logger = logging.getLogger("BulkImporter")

def process_single_file(file_path: str) -> Dict:
    """
    Worker function to process a single file.
    Instantiates its own scraper to ensure DB connection safety in multiprocess env.
    """
    start_time = time.time()
    filename = os.path.basename(file_path)
    stats = {'file': filename, 'products': 0, 'prices': 0, 'status': 'failed', 'error': None}
    

    
    try:
        # Initialize scraper (creates new DB connection per process)
        scraper = ShufersalScraper()
        scraper.get_db_connection()
        scraper.ensure_chain_exists()
        
        # Determine file type
        file_type = "store" if "Stores" in filename else "price_full"
        
        if file_type == "store":
            # For store files
            if file_path.endswith('.gz'):
                # Use /tmp for temp files to ensure permissions
                temp_xml_path = f"/tmp/{filename}.{os.getpid()}.xml"
                try:
                    with gzip.open(file_path, 'rb') as f_in:
                        with open(temp_xml_path, 'wb') as f_out:
                            shutil.copyfileobj(f_in, f_out)
                    
                    # Parse stores
                    tree = ET.parse(temp_xml_path)
                    root = tree.getroot()
                    scraper.parse_stores_file(root)
                    stats['status'] = 'success (stores)'
                finally:
                    if os.path.exists(temp_xml_path):
                        os.remove(temp_xml_path)
                    
            else:
                try:
                    tree = ET.parse(file_path)
                    root = tree.getroot()
                    scraper.parse_stores_file(root)
                    stats['status'] = 'success (stores)'
                except Exception as e:
                    scraper.log(f"Error parsing store XML: {e}", level="ERROR")
            
        else: # Price Full
            # Decompress if needed
            temp_xml_path = file_path
            created_temp = False
            
            if file_path.endswith('.gz'):
                # Use /tmp for temp files
                temp_xml_path = f"/tmp/{filename}.{os.getpid()}.xml"
                try:
                    with gzip.open(file_path, 'rb') as f_in:
                        with open(temp_xml_path, 'wb') as f_out:
                            shutil.copyfileobj(f_in, f_out)
                    created_temp = True
                except Exception as e:
                    raise Exception(f"Decompression failed: {e}")
            
            try:
                # Parse
                tree = ET.parse(temp_xml_path)
                root = tree.getroot()
                
                # Check for needed data
                store_id = root.findtext('StoreId')
                if not store_id:
                     # Some files might be empty or invalid
                     raise ValueError("No StoreId found in file")
                
                # Create parser store object to reuse base method logic if possible, 
                # but shufersal relies on XML root.
                # We'll use get_or_create_store directly with a minimal object if needed, 
                # OR better, since ShufersalScraper has mapping, we trust it.
                # However, get_or_create_store in Base expects ParsedStore object.
                # Let's fix this interaction.
                
                # In ShufersalScraper.parse_file (which we are bypassing for speed), it does:
                # store_name = self.STORE_NAMES.get(store_id, {}).get('name', f"Shufersal {store_id}")
                # And creates a ParsedStore.
                
                # We need to replicate that logic or use the scraper method
                from base_supermarket_scraper import ParsedStore
                
                store_info = scraper.STORE_NAMES.get(store_id)
                if store_info:
                    store_name = store_info[0]
                    city = store_info[1]
                    address = store_info[2]
                else:
                    store_name = f"Shufersal {store_id}"
                    city = None
                    address = None
                
                parsed_store = ParsedStore(
                    store_id=store_id,
                    name=store_name,
                    city=city,
                    address=address
                )
                
                store_db_id = scraper.get_or_create_store(parsed_store)
                
                # Import items
                items = root.findall('.//Item')
                count = 0
                
                # Pre-fetch ParsedProduct class to avoid lookups in tight loop
                from scrapers.base_supermarket_scraper import ParsedProduct
                
                for item in items:
                    try:
                        # Extract parsing logic from ShufersalScraper.parse_file
                        # Since parse_product method doesn't exist on the class
                        name = item.findtext('ItemNm') or item.findtext('ItemName')
                        price_str = item.findtext('ItemPrice')
                        price = float(price_str) if price_str else None
                        
                        product = ParsedProduct(
                            name=name,
                            barcode=item.findtext('ItemCode'),
                            manufacturer=item.findtext('ManufacturerName'),
                            description=item.findtext('ManufacturerItemDescription'),
                            price=price,
                            unit_qty=item.findtext('UnitQty'),
                            quantity=item.findtext('Quantity'),
                            unit_of_measure=item.findtext('UnitOfMeasure'),
                            is_weighted=item.findtext('bIsWeighted') == '1',
                            manufacturer_code=item.findtext('ItemCode'),
                            attributes={
                                'qty_in_package': item.findtext('QtyInPackage'),
                                'manufacture_country': item.findtext('ManufactureCountry'),
                                'item_type': item.findtext('ItemType'),
                                'unit_price': item.findtext('UnitOfMeasurePrice'),
                                'store_id': store_id
                            }
                        )
                        
                        # Clean attributes
                        product.attributes = {k: v for k, v in product.attributes.items() if v is not None}
                        
                        scraper.import_product(product, store_db_id)
                        count += 1
                    except Exception as e:
                        # Log error but try next product
                        # logger.warning(f"Error parsing item: {e}")
                        pass
                        
                # Commit connection
                scraper.conn.commit()
                stats['products'] = count
                stats['prices'] = count
                stats['status'] = 'success'
                
            finally:
                if created_temp and os.path.exists(temp_xml_path):
                    os.remove(temp_xml_path)

        scraper.close()
        
    except Exception as e:
        stats['error'] = str(e)
        logger.error(f"Failed {filename}: {e}")
        
    stats['duration'] = time.time() - start_time
    return stats

def main():
    parser = argparse.ArgumentParser(description='Bulk Parallel Importer')
    parser.add_argument('dir', type=str, help='Directory containing files')
    parser.add_argument('--workers', type=int, default=8, help='Number of worker processes')
    args = parser.parse_args()
    
    data_dir = Path(args.dir)
    if not data_dir.exists():
        logger.error(f"Directory not found: {data_dir}")
        return

    # Find all relevant files (both GZ and XML)
    all_files = list(data_dir.glob('PriceFull*')) + list(data_dir.glob('Stores*'))
    
    if not all_files:
        logger.warning("No files found to import")
        return

    # De-duplicate: prefer GZ if both exist
    files_map = {}
    for f in all_files:
        base = f.name.replace('.gz', '').replace('.xml', '')
        if base not in files_map:
            files_map[base] = f
        elif f.suffix == '.gz':
            files_map[base] = f
            
    files_to_process = list(files_map.values())
    
    logger.info("=" * 60)
    logger.info(f"🚀 Starting Bulk Import: {len(files_to_process)} files")
    logger.info(f"🔥 Speed Mode: Parallel (Workers: {args.workers})")
    logger.info("=" * 60)
    
    start_total = time.time()
    results = []
    
    # Process files
    with ProcessPoolExecutor(max_workers=args.workers) as executor:
        futures = {executor.submit(process_single_file, str(f)): f for f in files_to_process}
        
        for i, future in enumerate(as_completed(futures), 1):
            file_path = futures[future]
            try:
                res = future.result()
                results.append(res)
                
                if res['status'].startswith('success'):
                    logger.info(f"✅ [{i}/{len(files_to_process)}] {res['file']} -> {res['products']} items ({res.get('duration',0):.1f}s)")
                else:
                    logger.error(f"❌ [{i}/{len(files_to_process)}] {res['file']} -> Failed: {res['error']}")
                    
            except Exception as e:
                logger.error(f"❌ Crash processing {file_path.name}: {e}")

    total_duration = time.time() - start_total
    total_products = sum(r.get('products', 0) for r in results)
    
    logger.info("=" * 60)
    logger.info(f"🏁 DONE! Processed {len(files_to_process)} files in {total_duration:.1f}s")
    logger.info(f"📦 Total Products Processed: {total_products}")
    logger.info(f"⚡ Average Speed: {total_products/total_duration:.1f} products/sec")
    logger.info("=" * 60)

if __name__ == "__main__":
    main()
