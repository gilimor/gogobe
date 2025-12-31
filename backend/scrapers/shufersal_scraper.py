#!/usr/bin/env python3
"""
Shufersal Supermarket Scraper
Imports price data from Shufersal's transparency website
"""

try:
    from .base_supermarket_scraper import (
        BaseSupermarketScraper, FileMetadata, ParsedProduct, ParsedStore, logger
    )
except ImportError:
    from base_supermarket_scraper import (
        BaseSupermarketScraper, FileMetadata, ParsedProduct, ParsedStore, logger
    )

from typing import List, Dict, Optional, Any, Tuple
from pathlib import Path
from datetime import datetime
import xml.etree.ElementTree as ET
import requests
from bs4 import BeautifulSoup
import re


class ShufersalScraper(BaseSupermarketScraper):
    """
    Scraper for Shufersal supermarket chain
    
    Data source: https://prices.shufersal.co.il/
    Format: XML files compressed with GZ, stored in Azure Blob Storage
    """
    
    # Shufersal store mapping (from official website)
    # Format: store_id -> (name, city, address)
    STORE_NAMES = {
        '001': ('שלי ת"א- בן יהודה', 'תל אביב יפו', 'בן יהודה 152'),
        '002': ('שלי ירושלים- אגרון', 'ירושלים', 'אגרון 3'),
        '003': ('שלי חיפה- הנביאים', 'חיפה', 'הנביאים 22'),
        '004': ('שלי באר שבע- רמב"ם', 'באר שבע', 'רמב"ם 14'),
        '005': ('שלי פתח תקווה- רוטשילד', 'פתח תקווה', 'רוטשילד 45'),
        '006': ('שלי נתניה- הרצל', 'נתניה', 'הרצל 8'),
        '007': ('שלי ראשון לציון- רוטשילד', 'ראשון לציון', 'רוטשילד 70'),
        '008': ('שלי חולון- ויצמן', 'חולון', 'ויצמן 120'),
        '009': ('שלי בני ברק- רבי עקיבא', 'בני ברק', 'רבי עקיבא 80'),
        '010': ('שלי רמת גן- ביאליק', 'רמת גן', 'ביאליק 101'),
        # Add more as needed - this is a sample mapping
        # Full list should be extracted from Stores XML file
    }

    
    def __init__(self):
        super().__init__(
            chain_name="Shufersal",
            chain_slug="shufersal",
            chain_name_he="שופרסל",
            chain_id="7290027600007",
            country_code="IL"
        )
        self.base_url = "https://prices.shufersal.co.il/"
    
    # ensure_chain_exists is handled by BaseSupermarketScraper
    
    def fetch_file_list(self, file_type: str = 'prices_full', 
                       limit: Optional[int] = None) -> List[FileMetadata]:
        """
        Fetch list of available files from Shufersal website
        
        Args:
            file_type: Type of files ('stores', 'prices_full', 'prices', 'promos_full', 'promos')
            limit: Maximum number of files to return
            
        Returns:
            List of FileMetadata objects
        """
        logger.info(f"Fetching {file_type} files from {self.base_url}")
        
        files = []
        if file_type == 'all':
            file_types_to_fetch = ['stores', 'prices_full']
        else:
            file_types_to_fetch = [file_type]
            
        all_files = []
        
        for f_type in file_types_to_fetch:
            # Map file type to category value
            category_map = {
                'prices': '1',
                'prices_full': '2',
                'promos': '3',
                'promos_full': '4',
                'stores': '5'
            }
            
            cat_id = category_map.get(f_type)
            if not cat_id: continue
            
            # Iterate through pages
            max_pages = 5 if limit else 20
            current_page = 1
            
            while True:
                if limit and len(all_files) >= limit:
                    break
                
                if current_page > max_pages:
                    break
                    
                # Construct URL
                url = f"https://prices.shufersal.co.il/FileObject/UpdateCategory?catID={cat_id}&page={current_page}"
                logger.info(f"Fetching {f_type} page {current_page}: {url}")
                
                try:
                    response = requests.get(url, timeout=30)
                    response.raise_for_status()
                    
                    soup = BeautifulSoup(response.content, 'html.parser')
                    download_links = soup.find_all('a', text=re.compile(r'לחץ להורדה', re.I))
                    
                    if not download_links:
                        break
                    
                    page_files_count = 0
                    for link in download_links:
                        if limit and len(all_files) >= limit:
                            break
                        
                        file_url = link['href']
                        if not file_url.startswith('http'):
                            continue
                        
                        # Extract filename
                        filename = None
                        if '/pricefull/' in file_url:
                            filename = file_url.split('/pricefull/')[1].split('?')[0]
                        elif '/price/' in file_url:
                            filename = file_url.split('/price/')[1].split('?')[0]
                        elif '/store/' in file_url: # Handle Stores URL pattern if different
                             # Assuming stores are in /store/ or similar. Let's check generally
                             # Actually Shufersal links are usually blob storage direct links.
                             # Let's just take the last part of path
                             pass
                        
                        # Generic filename extraction fallback
                        if not filename:
                             filename = file_url.split('/')[-1].split('?')[0]

                        if not filename:
                            continue
                        
                        all_files.append(FileMetadata(
                            url=file_url,
                            filename=filename,
                            file_type=f_type
                        ))
                        page_files_count += 1
                    
                    if page_files_count == 0:
                        break
                        
                    current_page += 1
                    
                except Exception as e:
                    logger.error(f"Error fetching page {current_page} for {f_type}: {e}")
                    break
        
        logger.info(f"Found {len(all_files)} files total")
        return all_files
    
    def parse_stores_file(self, file_path: Path) -> List[ParsedStore]:
        """
        Parse Stores XML file
        
        Args:
            file_path: Path to Stores XML file
            
        Returns:
            List of ParsedStore objects
        """
        stores = []
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                tree = ET.parse(f)
            root = tree.getroot()
            
            debug_count = 0
            for elem in root.iter():
                tag = elem.tag
                if debug_count < 5:
                    logger.info(f"DEBUG XML TAG: {tag}")
                    debug_count += 1
                
                if '}' in tag:
                    tag = tag.split('}', 1)[1]
                
                if tag.upper() == 'STORE':
                    store_elem = elem
                    
                    # Debug first store children
                    if debug_count < 6:
                        logger.info(f"DEBUG STORE CHILDREN: {[c.tag for c in store_elem]}")
                        debug_count += 10 # Stop debugging
                    
                    # Helper to get text from child with namespace handling and case-insensitivity
                    def get_text(parent, tag_name):
                        for child in parent:
                            c_tag = child.tag.split('}', 1)[1] if '}' in child.tag else child.tag
                            if c_tag.upper() == tag_name.upper():
                                return child.text
                        return None

                    store = ParsedStore(
                        store_id=get_text(store_elem, 'StoreId'),
                        name=get_text(store_elem, 'StoreName') or f"שופרסל - סניף {get_text(store_elem, 'StoreId')}",
                        city=get_text(store_elem, 'City'),
                        address=get_text(store_elem, 'Address'),
                        bikoret_no=get_text(store_elem, 'BikoretNo'),
                        attributes={
                            'subchain_id': get_text(store_elem, 'SubChainId'),
                            'store_type': get_text(store_elem, 'StoreType'),
                        }
                    )
                    stores.append(store)
                    
                    # Update store names mapping
                    if store.store_id:
                        self.STORE_NAMES[store.store_id] = store.name
            
            logger.info(f"Parsed {len(stores)} stores from {file_path.name}")
            return stores
            
        except Exception as e:
            logger.error(f"Failed to parse stores file: {e}")
            return []
    
    def parse_file(self, file_path: Path) -> Tuple[Dict[str, Any], List[ParsedProduct]]:
        """
        Parse Shufersal XML file (Prices or PricesFull)
        """
        try:
            # Metadata holders
            metadata = {}
            products = []
            
            # Streaming parse - drastically reduces memory usage for large XMLs
            context = ET.iterparse(str(file_path), events=('end',))
            
            for event, elem in context:
                tag = elem.tag
                # Strip namespace if present
                if '}' in tag:
                    tag = tag.split('}', 1)[1]
                
                # Metadata (Top level elements)
                if tag == 'StoreId':
                    store_id = elem.text
                    store_info = self.STORE_NAMES.get(store_id, (f'שופרסל - סניף {store_id}', None, None))
                    store_name, city, address = store_info if isinstance(store_info, tuple) else (store_info, None, None)
                    metadata['store_id'] = store_id
                    metadata['store_name'] = store_name
                    metadata['city'] = city
                    metadata['address'] = address
                elif tag == 'ChainId':
                    metadata['chain_id'] = elem.text
                elif tag == 'SubChainId':
                    metadata['subchain_id'] = elem.text
                elif tag == 'BikoretNo':
                    metadata['bikoret_no'] = elem.text
                    
                # Product Item
                elif tag == 'Item':
                    p = self._parse_item_element(elem, metadata)
                    if p:
                        products.append(p)
                    # Clear element to free memory
                    elem.clear()
                    
            logger.info(f"Parsed {len(products)} products from {file_path.name}")
            return metadata, products
            
        except Exception as e:
            logger.error(f"Failed to parse file {file_path}: {e}")
            return {}, []

    def _parse_item_element(self, item, metadata):
        """Helper to parse a single Item element"""
        try:
            name = item.findtext('ItemNm') or item.findtext('ItemName')
            if not name: return None

            product = ParsedProduct(
                name=name,
                barcode=item.findtext('ItemCode'),
                manufacturer=item.findtext('ManufacturerName'),
                description=item.findtext('ManufacturerItemDescription'),
                price=self._parse_float(item.findtext('ItemPrice')),
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
                    'chain_id': metadata.get('chain_id'),
                    'store_id': metadata.get('store_id'),
                    'store_name': metadata.get('store_name'),
                }
            )
            # Remove None values
            product.attributes = {k: v for k, v in product.attributes.items() if v is not None}
            return product
        except Exception:
            return None
    
    def _parse_float(self, value: Optional[str]) -> Optional[float]:
        """Safely parse float value"""
        if not value:
            return None
        try:
            return float(value)
        except (ValueError, TypeError):
            return None
    
    def import_stores(self, stores_file: Path) -> int:
        """
        Import stores from Stores XML file
        
        Args:
            stores_file: Path to Stores XML file
            
        Returns:
            Number of stores imported
        """
        logger.info(f"Importing stores from {stores_file}")
        
        # Ensure chain exists
        self.ensure_chain_exists()
        
        # Parse stores file
        stores = self.parse_stores_file(stores_file)
        
        # Import each store
        count = 0
        for store in stores:
            store_id = self.get_or_create_store(store)
            if store_id:
                count += 1
        
        logger.info(f"Imported {count} stores")
        return count


def main():
    """Main entry point for testing"""
    import sys
    
    scraper = ShufersalScraper()
    
    if len(sys.argv) > 1:
        file_path = Path(sys.argv[1])
        
        if 'Store' in file_path.name:
            # Import stores
            scraper.import_stores(file_path)
        else:
            # Import prices
            scraper.import_files(
                file_type='prices_full',
                download_dir=file_path.parent
            )
    else:
        print("Usage:")
        print("  python shufersal_scraper.py <file_path>")
        print("")
        print("Examples:")
        print("  python shufersal_scraper.py /data/shufersal/Stores7290027600007-000-202512200300.xml")
        print("  python shufersal_scraper.py /data/shufersal/PriceFull7290027600007-001-202512200300.xml")
    
    scraper.close()


if __name__ == "__main__":
    main()
