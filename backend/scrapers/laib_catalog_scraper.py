#!/usr/bin/env python3
"""
LaibCatalog Platform Scraper
Generic scraper for chains using the laibcatalog.co.il platform
(Victory, Ma'asanei HaShuk, H. Cohen, etc.)
"""

import requests
from bs4 import BeautifulSoup
from pathlib import Path
from typing import List, Dict, Optional, Any, Tuple
from datetime import datetime, timedelta
import xml.etree.ElementTree as ET
import re
from base_supermarket_scraper import (
    BaseSupermarketScraper, FileMetadata, ParsedProduct, ParsedStore, logger
)

class LaibCatalogScraper(BaseSupermarketScraper):
    """
    Scraper for chains hosted on laibcatalog.co.il
    """
    
    def __init__(self, chain_name: str, chain_slug: str, chain_name_he: str, 
                 chain_id: str):
        super().__init__(
            chain_name=chain_name,
            chain_slug=chain_slug,
            chain_name_he=chain_name_he,
            chain_id=chain_id
        )
        self.base_url = "https://laibcatalog.co.il"
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Referer': self.base_url,
            'Origin': self.base_url
        })

    def fetch_file_list(self, file_type: str = 'prices_full', limit: Optional[int] = None) -> List[FileMetadata]:
        """Fetch list of available files - SIMPLIFIED VERSION"""
        logger.info(f"Fetching file list for {self.chain_name} from {self.base_url}")
        
        try:
            # Try direct access to the files directory
            # Pattern: https://laibcatalog.co.il/CompetitionRegulationsFiles/latest/{chain_id}/
            files_url = f"{self.base_url}/CompetitionRegulationsFiles/latest/{self.chain_id}/"
            
            response = self.session.get(files_url, timeout=30)
            
            if response.status_code == 200:
                # Parse directory listing
                soup = BeautifulSoup(response.content, 'html.parser')
                files = []
                
                # Map file types
                pattern_map = {
                    'prices_full': 'PriceFull',
                    'prices': 'Price',
                    'stores': 'StoresFull',
                    'promos': 'Promo'
                }
                target_prefix = pattern_map.get(file_type, 'Price')
                
                # Look for links to files
                for link in soup.find_all('a'):
                    href = link.get('href', '')
                    filename = link.get_text(strip=True)
                    
                    if filename.startswith(target_prefix) and self.chain_id in filename:
                        file_url = f"{files_url}{filename}"
                        files.append(FileMetadata(
                            url=file_url,
                            filename=filename,
                            file_type=file_type
                        ))
                
                # Sort by filename descending (newest first)
                files.sort(key=lambda x: x.filename, reverse=True)
                
                if limit:
                    files = files[:limit]
                    
                logger.info(f"Found {len(files)} files via direct access")
                return files
            
        except Exception as e:
            logger.warning(f"Direct access failed: {e}, trying known file pattern...")
        
        # Fallback: Try known recent file pattern
        try:
            files = []
            
            # Try last 3 days
            for days_ago in range(3):
                date = datetime.now() - timedelta(days=days_ago)
                date_str = date.strftime('%Y%m%d')
                
                # Try different hours
                for hour in ['0300', '1900', '2100']:
                    filename = f"PriceFull{self.chain_id}-001-{date_str}{hour}.gz"
                    file_url = f"{self.base_url}/CompetitionRegulationsFiles/latest/{self.chain_id}/{filename}"
                    
                    # Quick HEAD request to check if file exists
                    try:
                        head_response = self.session.head(file_url, timeout=5)
                        if head_response.status_code == 200:
                            files.append(FileMetadata(
                                url=file_url,
                                filename=filename,
                                file_type=file_type
                            ))
                            if limit and len(files) >= limit:
                                break
                    except:
                        continue
                
                if limit and len(files) >= limit:
                    break
            
            logger.info(f"Found {len(files)} files via pattern matching")
            return files[:limit] if limit else files
            
        except Exception as e:
            logger.error(f"Failed to fetch file list from LaibCatalog: {e}")
            return []

    def parse_file(self, file_path: Path) -> Tuple[Dict[str, Any], List[ParsedProduct]]:
        """Parse the supermarket XML file (standard format)"""
        try:
            tree = ET.parse(file_path)
            root = tree.getroot()
            
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
    # Test with Victory
    scraper = LaibCatalogScraper(
        chain_name="Victory",
        chain_slug="victory",
        chain_name_he="ויקטורי",
        chain_id="7290696200003"
    )
    
    files = scraper.fetch_file_list(file_type='prices_full', limit=2)
    for f in files:
        print(f"Candidate: {f.filename} -> {f.url}")
