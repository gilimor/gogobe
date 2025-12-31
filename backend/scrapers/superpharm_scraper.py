"""
Super-Pharm Scraper
High-performance scraper with Redis Streams support

Features:
- Parallel processing ready
- Redis cache integration
- Geocoding support
- COPY method for DB writes
- Full store management
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.base_supermarket_scraper import BaseSupermarketScraper, logger, ParsedProduct
from bs4 import BeautifulSoup
import requests
import re
from typing import List, Dict
from dataclasses import dataclass

@dataclass
class FileMetadata:
    filename: str
    url: str
    store_id: str
    file_type: str  # 'Price' or 'Promo'
    store_name: str = None  # Store name from download page
    size_bytes: int = 0

class SuperPharmScraper(BaseSupermarketScraper):
    """
    Super-Pharm price scraper
    Supporting both Price and Promo files
    """
    
    def __init__(self):
        super().__init__(
            chain_name='SuperPharm',
            chain_slug='superpharm',
            chain_name_he='סופר-פארם',
            chain_id='7290172900007',  # Official chain ID
            country_code='IL'
        )
        
        # Data directory  
        self.download_dir = 'data/superpharm'
        self.base_url = 'https://prices.super-pharm.co.il/'
        
        # Store cache for get_or_create_store
        self.store_cache = {}
        
        # Store metadata registry (populated during fetch_file_list)
        # Format: {store_code: {'name': ..., 'city': ..., 'address': ...}}
        self.store_registry = {}
    
    def fetch_file_list(self, file_type: str = 'prices_full', limit=None) -> List[FileMetadata]:
        """
        Fetch list of price files from ALL pages (with pagination)
        Also builds store_registry with store names from HTML table
        """
        logger.info("Fetching SuperPharm file list from all pages...")
        
        all_files = []
        page = 1
        
        while True:
            try:
                url = f"{self.base_url}?page={page}"
                logger.info(f"Scanning page {page}...")
                
                response = requests.get(url, timeout=30)
                response.raise_for_status()
                
                soup = BeautifulSoup(response.text, 'html.parser')
                
                # Find the table
                table = soup.find('table')
                if not table:
                    logger.warning(f"No table found on page {page}")
                    break
                
                # Process rows
                page_files = []
                # Process rows
                page_files = []
                rows = table.find_all('tr')
                
                # SuperPharm table can have variable header rows
                # Iterate all rows and skip those without enough cells
                for row in rows:
                    cells = row.find_all('td')
                    if len(cells) < 6:
                        continue
                    
                    # Cell structure: [מספר, filename, תאריך, סוג, שם סניף, הורדה]
                    filename = cells[1].get_text(strip=True)
                    store_name = cells[4].get_text(strip=True)
                    
                    # Find download link
                    link = cells[5].find('a', href=True)
                    if not link:
                        continue
                    
                    href = link['href']
                    
                    # Extract details from filename
                    match = re.search(r'(Price(?:Full)?|Promo(?:Full)?)(\d+)-(\d+)-', filename)
                    if not match:
                        continue
                    
                    file_type_found = match.group(1)
                    chain_code = match.group(2)
                    store_code = match.group(3)
                    
                    # Build full URL
                    if href.startswith('http'):
                        full_url = href
                    else:
                        full_url = self.base_url.rstrip('/') + '/' + href.lstrip('/')
                    
                    # Store the store name in registry
                    if store_code not in self.store_registry:
                        # Try to extract city from store name
                        city = self._extract_city_from_name(store_name)
                        self.store_registry[store_code] = {
                            'name': store_name,
                            'city': city,
                            'address': None  # Not available from download page
                        }
                    
                    page_files.append(FileMetadata(
                        filename=filename,
                        url=full_url,
                        store_id=store_code,
                        file_type=file_type_found,
                        store_name=store_name
                    ))
                
                if not page_files:
                    logger.info(f"No more files on page {page}")
                    break
                
                logger.info(f"Page {page}: Found {len(page_files)} files")
                all_files.extend(page_files)
                
                # Check limit
                if limit and len(all_files) >= limit:
                    all_files = all_files[:limit]
                    break
                
                page += 1
                
                # Safety limit
                if page > 100:
                    logger.warning("Reached safety limit of 100 pages")
                    break
                    
            except Exception as e:
                logger.error(f"Error fetching page {page}: {e}")
                break
        
        logger.info(f"Found {len(all_files)} SuperPharm files total from {page-1} pages")
        logger.info(f"Store registry: {len(self.store_registry)} unique stores")
        return all_files
    
    def _extract_city_from_name(self, store_name: str) -> str:
        """Extract city name from store name like 'סופר-פארם גבעת סביון'"""
        # Remove 'סופר-פארם' / 'SuperPharm' prefix
        name = store_name.replace('סופר-פארם', '').replace('SuperPharm', '').strip()
        # The rest is usually the city/location
        return name if name else None
    
    # get_store_chain_id removed - uses BaseSupermarketScraper logic
    
    def get_or_create_store(self, store_data) -> int:
        """
        Get or create store with geocoding support
        Accepts either ParsedStore object or string store_code
        Uses store_registry for enriched store data
        """
        # Handle both ParsedStore object and string
        if isinstance(store_data, str):
            store_code = store_data
            # Try to get from registry
            if store_code in self.store_registry:
                store_info = self.store_registry[store_code]
                store_name = store_info['name']
                city = store_info['city']
            else:
                store_name = f"סופר-פארם - סניף {store_data}"
                city = None
        else:
            # ParsedStore object
            store_code = store_data.store_id
            # Prefer ParsedStore data, fallback to registry
            store_name = store_data.name
            city = store_data.city
            
            if not store_name and store_code in self.store_registry:
                store_info = self.store_registry[store_code]
                store_name = store_info['name']
                city = city or store_info['city']
        
        conn = self.get_db_connection()
        cur = conn.cursor()
        
        try:
            # Ensure chain exists (using Base logic)
            self.ensure_chain_exists()
            chain_id = self.chain_db_id
            
            if not chain_id:
                raise Exception("Failed to get chain ID")
            
            # Check cache
            cache_key = f"store:{chain_id}:{store_code}"
            if cache_key in self.store_cache:
                return self.store_cache[cache_key]
            
            # Check DB
            cur.execute("""
                SELECT id FROM stores 
                WHERE chain_id = %s AND store_id = %s
            """, (chain_id, store_code))
            
            result = cur.fetchone()
            if result:
                store_id = result[0]
                # Update name and city if we have better data
                if store_name and city:
                    cur.execute("""
                        UPDATE stores
                        SET name = %s, city = %s
                        WHERE id = %s AND (name IS NULL OR name LIKE %s OR name LIKE %s)
                    """, (store_name, city, store_id, f"%סניף {store_code}%", f"%Store {store_code}%"))
                    conn.commit()
                
                self.store_cache[cache_key] = store_id
                return store_id
            
            # Create new store with enriched data
            cur.execute("""
                INSERT INTO stores (
                    chain_id, store_id, name, name_he, city,
                    is_active, created_at, updated_at
                )
                VALUES (%s, %s, %s, %s, %s, TRUE, NOW(), NOW())
                RETURNING id
            """, (chain_id, store_code, store_name, store_name, city))
            
            store_id = cur.fetchone()[0]
            conn.commit()
            
            # Cache it
            self.store_cache[cache_key] = store_id
            
            city_str = f", {city}" if city else ""
            logger.info(f"Created store: {store_name}{city_str} (Code: {store_code}, DB ID: {store_id})")
            
            return store_id
            
        except Exception as e:
            logger.error(f"Error creating store: {e}")
            conn.rollback()
            raise
        finally:
            cur.close()
    
    def parse_file(self, filepath):
        """
        Parse SuperPharm XML file
        SuperPharm uses different XML structure than government standard
        
        Structure:
        <OrderXml>
          <Envelope>
            <ChainId>...</ChainId>
            <StoreId>...</StoreId>
            <Header>
              <Details>
                <Line>...</Line>  ← each product
              </Details>
            </Header>
          </Envelope>
        </OrderXml>
        """
        import os
        import xml.etree.ElementTree as ET
        
        filename = os.path.basename(str(filepath))
        
        # Parse file (both Price and Promo files have similar structure)
        try:
            tree = ET.parse(str(filepath))
            root = tree.getroot()
            
            # Extract metadata from Envelope
            envelope = root.find('.//Envelope')
            if envelope is None:
                logger.error(f"No Envelope found in {filename}")
                return ({}, [])
            
            metadata = {
                'chain_id': envelope.findtext('ChainId', ''),
                'store_id': envelope.findtext('StoreId', ''),
                'bikoret_no': envelope.findtext('BikoretNo', ''),
            }
            
            # Extract products from Details/Line elements
            products = []
            lines = root.findall('.//Details/Line')
            
            logger.info(f"Found {len(lines)} products in {filename}")
            
            for line in lines:
                try:
                    # Create ParsedProduct object
                    is_promo = 'Promo' in filename
                    
                    price = float(line.findtext('ItemPrice', '0') or '0')
                    price_regular = float(line.findtext('ItemPriceRegular', '0') or '0') if is_promo else None
                    promo_desc = line.findtext('PromoDescription', '') if is_promo else None
                    
                    parsed_product = ParsedProduct(
                        name=line.findtext('ItemName', ''),
                        barcode=line.findtext('ItemCode', ''),
                        manufacturer=line.findtext('ManufacturerName', ''),
                        description=line.findtext('ManufacturerItemDescription', ''),
                        price=price,
                        unit_qty=line.findtext('UnitQty', ''),
                        quantity=line.findtext('Quantity', '0'),
                        unit_of_measure=line.findtext('UnitOfMeasure', ''),
                        is_weighted=line.findtext('blsWeighted', '0') == '1',
                        manufacturer_code=line.findtext('ManufacturerCode', ''),
                        is_sale=is_promo,
                        price_regular=price_regular,
                        promo_description=promo_desc,
                        attributes={
                            'manufacture_country': line.findtext('ManufactureCountry', ''),
                            'qty_in_package': line.findtext('QtyInPackage', '1'),
                            'unit_of_measure_price': line.findtext('UnitOfMeasurePrice', '0'),
                            'allow_discount': line.findtext('AllowDiscount', '0') == '1',
                            'item_status': line.findtext('ItemStatus', '0'),
                            'price_update_date': line.findtext('PriceUpdateDate', '')
                        }
                    )
                    
                    products.append(parsed_product)
                    
                except Exception as e:
                    logger.warning(f"Error parsing product line: {e}")
                    continue
            
            return (metadata, products)
            
        except Exception as e:
            logger.error(f"Error parsing SuperPharm file {filename}: {e}")
            return ({}, [])
    
    def import_files(self, limit=None, **kwargs):
        """
        Import all SuperPharm files
        High-performance batch import
        """
        logger.info("=" * 80)
        logger.info("SuperPharm Import - Prices & Promos")
        logger.info("=" * 80)
        
        return super().import_files(limit=limit, **kwargs)


# CLI for testing
if __name__ == '__main__':
    scraper = SuperPharmScraper()
    
    # Test file list
    files = scraper.fetch_file_list(limit=10)
    print(f"\nFound {len(files)} files:")
    for f in files[:5]:
        print(f"  {f.file_type}: {f.filename} (Store: {f.store_code})")
