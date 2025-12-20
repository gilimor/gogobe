"""
KingStore XML Processor
Processes downloaded XML files and imports products/prices to database
"""

import sys
from pathlib import Path
from datetime import datetime
import xml.etree.ElementTree as ET
import zipfile
import gzip
import hashlib
import json
import psycopg2
import os

def get_db_connection():
    """Get database connection"""
    return psycopg2.connect(
        dbname=os.getenv('DB_NAME', 'gogobe'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host=os.getenv('DB_HOST', 'host.docker.internal'),
        port=os.getenv('DB_PORT', '5432')
    )


class KingStoreXMLProcessor:
    def __init__(self):
        self.stats = {
            'files_processed': 0,
            'files_failed': 0,
            'products_found': 0,
            'products_imported': 0,
            'prices_imported': 0,
            'chains_created': 0,
            'stores_created': 0
        }
        
    def log(self, message):
        """Print timestamped log"""
        timestamp = datetime.now().strftime('%H:%M:%S')
        print(f"[{timestamp}] {message}")
    
    def extract_archive(self, filepath):
        """Extract .gz or .zip file"""
        try:
            # Check file type
            with open(filepath, 'rb') as f:
                magic = f.read(2)
            
            is_zip = (magic == b'PK')
            is_gzip = (magic == b'\x1f\x8b')
            
            if is_zip or filepath.suffix == '.zip':
                # Extract ZIP
                extract_dir = filepath.parent
                with zipfile.ZipFile(filepath, 'r') as zip_ref:
                    zip_ref.extractall(extract_dir)
                    xml_files = list(extract_dir.glob(f"{filepath.stem}*.xml"))
                    if xml_files:
                        return xml_files[0]
                        
            elif is_gzip or filepath.suffix == '.gz':
                # Extract GZIP
                xml_filepath = filepath.with_suffix('')
                
                if xml_filepath.exists():
                    return xml_filepath
                
                with gzip.open(filepath, 'rb') as f_in:
                    with open(xml_filepath, 'wb') as f_out:
                        f_out.write(f_in.read())
                
                return xml_filepath
            
            return None
            
        except Exception as e:
            self.log(f"[ERROR] Extraction failed: {e}")
            return None
    
    def parse_price_xml(self, xml_path):
        """Parse Prices XML file"""
        try:
            tree = ET.parse(xml_path)
            root = tree.getroot()
            
            # Extract metadata
            metadata = {
                'chain_id': root.findtext('ChainId'),
                'subchain_id': root.findtext('SubChainId'),
                'store_id': root.findtext('StoreId'),
                'bikoret_no': root.findtext('BikoretNo'),
                'store_name': root.findtext('StoreName'),
                'update_date': root.findtext('PriceUpdateDate')
            }
            
            # Extract items
            items = []
            for item in root.findall('.//Item'):
                product = {
                    'item_code': item.findtext('ItemCode'),
                    'item_type': item.findtext('ItemType'),
                    'item_name': item.findtext('ItemNm') or item.findtext('ItemName'),  # Try both
                    'manufacturer_name': item.findtext('ManufacturerName'),
                    'manufacturer_item_description': item.findtext('ManufacturerItemDescription'),
                    'unit_qty': item.findtext('UnitQty'),
                    'unit_of_measure': item.findtext('UnitOfMeasure'),
                    'quantity': item.findtext('Quantity'),
                    'price': item.findtext('ItemPrice'),
                    'unit_of_measure_price': item.findtext('UnitOfMeasurePrice'),
                    'allow_discount': item.findtext('AllowDiscount'),
                    'item_status': item.findtext('ItemStatus')
                }
                items.append(product)
            
            return metadata, items
            
        except Exception as e:
            self.log(f"[ERROR] XML parsing failed: {e}")
            return None, []
    
    def parse_promo_xml(self, xml_path):
        """Parse Promos XML file"""
        try:
            tree = ET.parse(xml_path)
            root = tree.getroot()
            
            # Extract metadata
            metadata = {
                'chain_id': root.findtext('ChainId'),
                'subchain_id': root.findtext('SubChainId'),
                'store_id': root.findtext('StoreId'),
                'bikoret_no': root.findtext('BikoretNo')
            }
            
            # Extract promotions
            promos = []
            for promo in root.findall('.//Promotion'):
                promo_data = {
                    'promo_id': promo.findtext('PromotionId'),
                    'description': promo.findtext('PromotionDescription'),
                    'start_date': promo.findtext('PromotionStartDate'),
                    'end_date': promo.findtext('PromotionEndDate'),
                    'discount_rate': promo.findtext('DiscountRate'),
                    'discounted_price': promo.findtext('DiscountedPrice'),
                    'items': []
                }
                
                # Get items in promotion
                for item in promo.findall('.//PromotionItems/Item'):
                    promo_data['items'].append({
                        'item_code': item.findtext('ItemCode'),
                        'is_gift': item.findtext('IsGiftItem')
                    })
                
                promos.append(promo_data)
            
            return metadata, promos
            
        except Exception as e:
            self.log(f"[ERROR] Promo XML parsing failed: {e}")
            return None, []
    
    def get_or_create_chain(self, conn, chain_id, subchain_id=None):
        """Get or create store chain"""
        cur = conn.cursor()
        
        try:
            # Check if chain exists
            cur.execute("""
                SELECT id FROM store_chains
                WHERE chain_code = %s AND (sub_chain_id = %s OR (sub_chain_id IS NULL AND %s IS NULL))
            """, (chain_id, subchain_id, subchain_id))
            
            result = cur.fetchone()
            if result:
                return result[0]
            
            # Create new chain
            # Get price source
            cur.execute("SELECT id FROM price_sources WHERE name LIKE '%KingStore%' LIMIT 1")
            source = cur.fetchone()
            source_id = source[0] if source else None
            
            cur.execute("""
                INSERT INTO store_chains (chain_code, sub_chain_id, chain_name, price_source_id, country_code)
                VALUES (%s, %s, %s, %s, 'IL')
                RETURNING id
            """, (chain_id, subchain_id, f"Chain {chain_id}", source_id))
            
            chain_id_db = cur.fetchone()[0]
            conn.commit()
            
            self.stats['chains_created'] += 1
            return chain_id_db
            
        except Exception as e:
            self.log(f"[ERROR] Chain creation failed: {e}")
            conn.rollback()
            return None
        finally:
            cur.close()
    
    def get_or_create_store(self, conn, chain_db_id, store_code, store_name=None, bikoret_no=None):
        """Get or create store"""
        cur = conn.cursor()
        
        try:
            # Check if store exists
            cur.execute("""
                SELECT id FROM stores
                WHERE chain_id = %s AND store_code = %s
            """, (chain_db_id, store_code))
            
            result = cur.fetchone()
            if result:
                return result[0]
            
            # Create new store
            cur.execute("""
                INSERT INTO stores (chain_id, store_code, store_name, bikoret_no)
                VALUES (%s, %s, %s, %s)
                RETURNING id
            """, (chain_db_id, store_code, store_name or f"Store {store_code}", bikoret_no))
            
            store_id = cur.fetchone()[0]
            conn.commit()
            
            self.stats['stores_created'] += 1
            return store_id
            
        except Exception as e:
            self.log(f"[ERROR] Store creation failed: {e}")
            conn.rollback()
            return None
        finally:
            cur.close()
    
    def import_products_and_prices(self, conn, metadata, items, store_db_id):
        """Import products and prices to database"""
        cur = conn.cursor()
        
        try:
            # Get supermarket vertical
            cur.execute("SELECT id FROM verticals WHERE name ILIKE '%supermarket%' LIMIT 1")
            vertical_result = cur.fetchone()
            vertical_id = vertical_result[0] if vertical_result else None
            
            if not vertical_id:
                self.log("[ERROR] Supermarket vertical not found")
                return
            
            # Get or create KingStore supplier
            cur.execute("""
                SELECT id FROM suppliers WHERE name = 'KingStore' LIMIT 1
            """)
            
            supplier_result = cur.fetchone()
            
            if not supplier_result:
                # Create KingStore supplier
                cur.execute("""
                    INSERT INTO suppliers (name, country_code, supplier_type)
                    VALUES ('KingStore', 'IL', 'supermarket')
                    RETURNING id
                """)
                supplier_id = cur.fetchone()[0]
                conn.commit()
            else:
                supplier_id = supplier_result[0]
            
            # Import items - each item in its own savepoint
            for item in items:
                try:
                    if not item['item_name'] or not item['price']:
                        continue
                    
                    # Start savepoint for this item
                    cur.execute("SAVEPOINT item_import")
                    
                    try:
                        # Check if product exists by barcode FIRST
                        product_id = None
                        
                        if item.get('item_code'):
                            cur.execute("""
                                SELECT id FROM products 
                                WHERE (ean = %s OR upc = %s OR manufacturer_code = %s)
                                AND vertical_id = %s
                                LIMIT 1
                            """, (item['item_code'], item['item_code'], item['item_code'], vertical_id))
                            
                            existing = cur.fetchone()
                            if existing:
                                product_id = existing[0]
                        
                        # If not found by barcode, try by name
                        if not product_id:
                            cur.execute("""
                                SELECT id FROM products 
                                WHERE name = %s AND vertical_id = %s
                                LIMIT 1
                            """, (item['item_name'][:500], vertical_id))
                            
                            existing = cur.fetchone()
                            if existing:
                                product_id = existing[0]
                        
                        # Create new product if not found
                        if not product_id:
                            # Create new product WITH barcode
                            cur.execute("""
                                INSERT INTO products (
                                    name, 
                                    description, 
                                    vertical_id,
                                    ean,
                                    manufacturer_code
                                )
                                VALUES (%s, %s, %s, %s, %s)
                                RETURNING id
                            """, (
                                item['item_name'][:500],
                                f"{item['manufacturer_name'] or ''} {item['manufacturer_item_description'] or ''}".strip()[:1000],
                                vertical_id,
                                item.get('item_code'),
                                item.get('item_code')
                            ))
                            product_id = cur.fetchone()[0]
                            self.stats['products_imported'] += 1
                        
                        self.stats['products_found'] += 1
                        
                        # Create or update price
                        price_value = float(item['price'])
                        
                        # Check if price exists for this product + supplier + store
                        cur.execute("""
                            SELECT id FROM prices
                            WHERE product_id = %s AND supplier_id = %s AND store_id = %s
                        """, (product_id, supplier_id, store_db_id))
                        
                        existing_price = cur.fetchone()
                        
                        if existing_price:
                            # Update existing price
                            cur.execute("""
                                UPDATE prices
                                SET price = %s,
                                    scraped_at = NOW()
                                WHERE id = %s
                            """, (price_value, existing_price[0]))
                        else:
                            # Insert new price with store_id
                            cur.execute("""
                                INSERT INTO prices (product_id, supplier_id, store_id, price, currency, scraped_at)
                                VALUES (%s, %s, %s, %s, 'ILS', NOW())
                            """, (product_id, supplier_id, store_db_id, price_value))
                            self.stats['prices_imported'] += 1
                        
                        # Savepoint succeeded - release it
                        cur.execute("RELEASE SAVEPOINT item_import")
                        
                    except Exception as e:
                        # Rollback this item only
                        cur.execute("ROLLBACK TO SAVEPOINT item_import")
                        # Track error types
                        error_msg = str(e)[:100]
                        if error_msg not in self.stats:
                            self.stats[error_msg] = 0
                        self.stats[error_msg] += 1
                        # Log first occurrence
                        if self.stats[error_msg] == 1:
                            self.log(f"[ERROR] {error_msg}")
                        continue
                    
                except Exception as e:
                    # Outer exception - skip item
                    continue
            
            conn.commit()
            
        except Exception as e:
            self.log(f"[ERROR] Import failed: {e}")
            conn.rollback()
        finally:
            cur.close()
    
    def update_file_status(self, conn, file_id, status, products_found=0, products_imported=0, prices_imported=0, error=None):
        """Update downloaded_files status"""
        cur = conn.cursor()
        
        try:
            if status == 'completed':
                cur.execute("""
                    UPDATE downloaded_files
                    SET processing_status = %s,
                        processing_completed_at = NOW(),
                        products_found = %s,
                        products_imported = %s,
                        prices_imported = %s
                    WHERE id = %s
                """, (status, products_found, products_imported, prices_imported, file_id))
            else:
                cur.execute("""
                    UPDATE downloaded_files
                    SET processing_status = %s,
                        processing_error = %s
                    WHERE id = %s
                """, (status, error, file_id))
            
            conn.commit()
            
        except Exception as e:
            self.log(f"[ERROR] Status update failed: {e}")
            conn.rollback()
        finally:
            cur.close()
    
    def process_pending_files(self):
        """Process all pending downloaded files"""
        self.log("=" * 60)
        self.log("Starting XML Processing")
        self.log("=" * 60)
        
        conn = get_db_connection()
        cur = conn.cursor()
        
        try:
            # Get pending files
            cur.execute("""
                SELECT id, filename, local_path, file_type
                FROM downloaded_files
                WHERE processing_status = 'pending'
                ORDER BY downloaded_at DESC
            """)
            
            pending_files = cur.fetchall()
            
            self.log(f"Found {len(pending_files)} pending files")
            
            for file_id, filename, local_path, file_type in pending_files:
                self.log(f"\n--- Processing: {filename} ---")
                
                try:
                    filepath = Path(local_path)
                    
                    if not filepath.exists():
                        self.log(f"[ERROR] File not found: {filepath}")
                        self.update_file_status(conn, file_id, 'failed', error='File not found')
                        continue
                    
                    # Update status to processing
                    cur.execute("""
                        UPDATE downloaded_files
                        SET processing_status = 'processing',
                            processing_started_at = NOW()
                        WHERE id = %s
                    """, (file_id,))
                    conn.commit()
                    
                    # Extract if needed
                    if filepath.suffix in ['.gz', '.zip']:
                        xml_path = self.extract_archive(filepath)
                    else:
                        xml_path = filepath
                    
                    if not xml_path or not xml_path.exists():
                        self.log(f"[ERROR] Could not extract XML")
                        self.update_file_status(conn, file_id, 'failed', error='Extraction failed')
                        continue
                    
                    # Parse XML
                    if 'Price' in filename:
                        metadata, items = self.parse_price_xml(xml_path)
                    elif 'Promo' in filename:
                        metadata, items = self.parse_promo_xml(xml_path)
                    else:
                        self.log(f"[SKIP] Unknown file type")
                        self.update_file_status(conn, file_id, 'skipped', error='Unknown file type')
                        continue
                    
                    if not metadata:
                        self.log(f"[ERROR] Failed to parse XML")
                        self.update_file_status(conn, file_id, 'failed', error='XML parsing failed')
                        continue
                    
                    self.log(f"Found {len(items)} items")
                    
                    # Create chain and store
                    chain_db_id = self.get_or_create_chain(conn, metadata['chain_id'], metadata.get('subchain_id'))
                    if not chain_db_id:
                        self.log(f"[ERROR] Failed to create chain")
                        continue
                    
                    store_db_id = self.get_or_create_store(
                        conn, chain_db_id, metadata['store_id'],
                        metadata.get('store_name'), metadata.get('bikoret_no')
                    )
                    if not store_db_id:
                        self.log(f"[ERROR] Failed to create store")
                        continue
                    
                    # Import data
                    before_products = self.stats['products_imported']
                    before_prices = self.stats['prices_imported']
                    
                    self.import_products_and_prices(conn, metadata, items, store_db_id)
                    
                    products_imported = self.stats['products_imported'] - before_products
                    prices_imported = self.stats['prices_imported'] - before_prices
                    
                    # Update file status
                    self.update_file_status(
                        conn, file_id, 'completed',
                        len(items), products_imported, prices_imported
                    )
                    
                    self.stats['files_processed'] += 1
                    self.log(f"[OK] Imported {products_imported} products, {prices_imported} prices")
                    
                except Exception as e:
                    self.log(f"[ERROR] Processing failed: {e}")
                    import traceback
                    traceback.print_exc()
                    
                    self.update_file_status(conn, file_id, 'failed', error=str(e))
                    self.stats['files_failed'] += 1
            
            # Print summary
            self.log("\n" + "=" * 60)
            self.log("Processing Summary")
            self.log("=" * 60)
            self.log(f"Files processed:      {self.stats['files_processed']}")
            self.log(f"Files failed:         {self.stats['files_failed']}")
            self.log(f"Chains created:       {self.stats['chains_created']}")
            self.log(f"Stores created:       {self.stats['stores_created']}")
            self.log(f"Products found:       {self.stats['products_found']}")
            self.log(f"Products imported:    {self.stats['products_imported']}")
            self.log(f"Prices imported:      {self.stats['prices_imported']}")
            self.log("=" * 60)
            
        finally:
            cur.close()
            conn.close()


def main():
    """Main entry point"""
    import sys
    
    # Get directory from command line or use default
    if len(sys.argv) > 1:
        data_dir = Path(sys.argv[1])
    else:
        data_dir = Path(__file__).parent.parent / "data" / "kingstore"
    
    print("=" * 80)
    print("🏪 KingStore XML Processor - Full Import")
    print("=" * 80)
    print(f"Directory: {data_dir}")
    
    if not data_dir.exists():
        print(f"\n❌ Directory not found: {data_dir}")
        return
    
    # Find all XML and GZ files
    xml_files = list(data_dir.glob("Price*.xml"))
    gz_files = list(data_dir.glob("Price*.gz"))
    
    print(f"\nFound:")
    print(f"  • {len(xml_files)} XML files")
    print(f"  • {len(gz_files)} GZ files")
    print(f"  • Total: {len(xml_files) + len(gz_files)} files")
    
    if not xml_files and not gz_files:
        print("\n❌ No KingStore files found!")
        return
    
    print("\n" + "=" * 80)
    input("Press Enter to start processing...")
    print()
    
    processor = KingStoreXMLProcessor()
    
    # Process all files
    processor.process_directory(data_dir)


if __name__ == "__main__":
    main()

