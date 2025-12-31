#!/usr/bin/env python3
"""
BinaProjects Platform Scraper
Generic scraper for chains using the binaprojects.com platform
(King Store, Zol VeBegadol, Maayan 2000, etc.)
"""

import requests
from bs4 import BeautifulSoup
from pathlib import Path
from typing import List, Dict, Optional, Any, Tuple
from datetime import datetime
import xml.etree.ElementTree as ET
import re
try:
    from .base_supermarket_scraper import (
        BaseSupermarketScraper, FileMetadata, ParsedProduct, ParsedStore, logger
    )
except ImportError:
    from base_supermarket_scraper import (
        BaseSupermarketScraper, FileMetadata, ParsedProduct, ParsedStore, logger
    )

class BinaProjectsScraper(BaseSupermarketScraper):
    """
    Scraper for chains hosted on binaprojects.com subdomains
    """
    
    def __init__(self, chain_name: str, chain_slug: str, chain_name_he: str, 
                 chain_id: str, subdomain: str):
        super().__init__(
            chain_name=chain_name,
            chain_slug=chain_slug,
            chain_name_he=chain_name_he,
            chain_id=chain_id
        )
        self.base_url = f"https://{subdomain}.binaprojects.com"
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Gogobe Price Scraper'
        })

    def fetch_file_list(self, file_type: str = 'prices_full', 
                       limit: Optional[int] = None) -> List[FileMetadata]:
        """Fetch available files from the platform"""
        logger.info(f"Fetching file list from {self.base_url}/Main.aspx")
        try:
            # Type mapping based on browser inspection
            # 1=Stores, 2=Prices, 4=PriceFull
            type_map = {
                'prices_full': '4',
                'prices': '2',
                'stores': '1',
                'promos': '3'
            }
            file_type_val = type_map.get(file_type, '4')

            # The site uses a simple POST form filter without ViewState
            # Try to send just the relevant fields
            payload = {
                'wFileType': file_type_val,
                'Button1': 'חפש' 
            }
            
            # Send POST to get filtered table
            # Verify=False because some israeli subdomains have cert issues
            response = self.session.post(f"{self.base_url}/Main.aspx", data=payload, timeout=30, verify=False)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.content, 'html.parser')
            files = []
            
            # Map gogobe file types to platform naming conventions for Validation
            pattern_map = {
                'prices_full': r'PriceFull',
                'prices': r'Price\d',
                'stores': r'Stores',
                'promos': r'Promo'
            }
            pattern = pattern_map.get(file_type, r'Price')
            
            # Find all file links
            for link in soup.find_all('a', href=True):
                href = link['href']
                filename = link.get_text(strip=True) or href.split('/')[-1]
                
                # Check for XML/GZ and match the pattern in either filename or href
                if any(ext in href.lower() for ext in ['.xml', '.gz']):
                    # Use search instead of match for partial matches
                    # Check both displayed text and the URL itself
                    if re.search(pattern, filename, re.IGNORECASE) or re.search(pattern, href, re.IGNORECASE):
                        file_url = href if href.startswith('http') else f"{self.base_url}/{href}"
                        
                        files.append(FileMetadata(
                            url=file_url,
                            filename=href.split('/')[-1], # Use actual filename from URL for metadata
                            file_type=file_type
                        ))
            
            # Sort by filename descending (usually newest first)
            files.sort(key=lambda x: x.filename, reverse=True)
            
            if limit:
                files = files[:limit]
            
            logger.info(f"Found {len(files)} matching files for type {file_type} (val={file_type_val})")
            return files
            
        except Exception as e:
            logger.error(f"Failed to fetch file list: {e}")
            return []

    def parse_file(self, file_path: Path) -> Tuple[Dict[str, Any], List[ParsedProduct]]:
        """Parse the supermarket XML file"""
        try:
            tree = ET.parse(file_path)
            root = tree.getroot()
            
            # Extract store metadata
            store_id = root.findtext('StoreId')
            chain_id = root.findtext('ChainId')
            
            metadata = {
                'store_id': store_id,
                'chain_id': chain_id,
                'bikoret_no': root.findtext('BikoretNo'),
            }
            
            products = []
            for item in root.findall('.//Item'):
                name = item.findtext('ItemNm') or item.findtext('ItemName')
                barcode = item.findtext('ItemCode')
                price = item.findtext('ItemPrice')
                
                if not name or not price:
                    continue
                    
                products.append(ParsedProduct(
                    name=name,
                    barcode=barcode,
                    price=float(price),
                    manufacturer=item.findtext('ManufacturerName'),
                    unit_qty=item.findtext('UnitQty'),
                    quantity=item.findtext('Quantity'),
                    unit_of_measure=item.findtext('UnitOfMeasure'),
                    is_weighted=item.findtext('bIsWeighted') == '1',
                    manufacturer_code=barcode,
                    attributes={
                        'qty_in_package': item.findtext('QtyInPackage'),
                        'manufacture_country': item.findtext('ManufactureCountry'),
                    }
                ))
                
            return metadata, products
        except Exception as e:
            logger.error(f"Failed to parse XML {file_path}: {e}")
            return {}, []

if __name__ == "__main__":
    # Test with King Store
    scraper = BinaProjectsScraper(
        chain_name="King Store",
        chain_slug="kingstore",
        chain_name_he="קינג סטור",
        chain_id="7290172911110",
        subdomain="kingstore"
    )
    
    files = scraper.fetch_file_list(file_type='prices_full', limit=2)
    for f in files:
        print(f"Candidate: {f.filename} -> {f.url}")
