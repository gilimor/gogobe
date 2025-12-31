
import logging
import requests
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import List, Dict, Tuple, Any, Optional
from datetime import datetime, timedelta

from .base_supermarket_scraper import BaseSupermarketScraper, FileMetadata, ParsedProduct, ParsedStore

logger = logging.getLogger(__name__)

class WAFuelScraper(BaseSupermarketScraper):
    """
    Scraper for Western Australia FuelWatch (RSS).
    Source: https://www.fuelwatch.wa.gov.au/fuelwatch/fuelWatchRSS
    """
    
    BASE_URL = "https://www.fuelwatch.wa.gov.au/fuelwatch/fuelWatchRSS"
    PRODUCTS = {
        1: "Unleaded Petrol",
        2: "Premium Unleaded", # PULP
        4: "Diesel",
        5: "LPG",
        6: "98 RON",
        10: "E85",
        11: "Brand Diesel"
    }
    
    def __init__(self):
        super().__init__(
            chain_name='FuelWatch WA',
            chain_slug='wa_fuel_watch',
            chain_name_he='מחירי דלק אוסטרליה',
            chain_id='WA_FUEL_WATCH',
            country_code='AU'
        )
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }

    def fetch_file_list(self, file_type: str = 'prices', limit: Optional[int] = None) -> List[FileMetadata]:
        # We define virtual files for Today and Tomorrow for each product
        files = []
        days = ['today', 'tomorrow']
        
        for pid, pname in self.PRODUCTS.items():
            for day in days:
                url = f"{self.BASE_URL}?Product={pid}&Day={day}"
                filename = f"wa_fuel_{pid}_{day}.xml"
                files.append(FileMetadata(
                    url=url,
                    filename=filename,
                    file_type='xml',
                    size_bytes=0,
                    store_id=f"WA_{day.upper()}"
                ))
                
        return files

    def download_file(self, file_metadata: FileMetadata, download_dir: Path) -> Optional[Path]:
        # Custom download to handle User-Agent and verify content
        local_path = download_dir / file_metadata.filename
        try:
            logger.info(f"Downloading {file_metadata.url}")
            r = requests.get(file_metadata.url, headers=self.headers, timeout=30)
            r.raise_for_status()
            
            with open(local_path, 'wb') as f:
                f.write(r.content)
            
            return local_path
        except Exception as e:
            logger.error(f"Failed to download {file_metadata.url}: {e}")
            return None

    def parse_file(self, file_path: Path) -> Tuple[Dict, List[ParsedProduct]]:
        """
        Parse RSS XML.
        """
        logger.info(f"Parsing WA Fuel Data: {file_path}")
        self.ensure_chain_exists()
        
        # Determine Product and Day from filename
        # filename: wa_fuel_{pid}_{day}.xml
        parts = file_path.stem.split('_')
        if len(parts) >= 4:
            pid = int(parts[2])
            day = parts[3]
        else:
            logger.warning(f"Invalid filename format: {file_path}")
            return {}, []
            
        pname = self.PRODUCTS.get(pid, "Unknown")
        is_tomorrow = (day == 'tomorrow')
        
        cnt_stores = 0
        cnt_prices = 0
        
        try:
            tree = ET.parse(file_path)
            root = tree.getroot()
            channel = root.find('channel')
            
            # channel contains <item> elements
            for item in channel.findall('item'):
                try:
                    self._process_item(item, pid, pname, is_tomorrow)
                    cnt_prices += 1
                except Exception as e:
                    # logger.warning(f"Error item: {e}")
                    pass
            
            # Flush batch
            self._flush_price_batch()
            
        except Exception as e:
            logger.error(f"Error parsing XML {file_path}: {e}")
            
        logger.info(f"WA {day} {pname}: Processed {cnt_prices} prices.")
        return {"store_id": "WA_DONE", "chain_id": self.chain_db_id}, []

    def _process_item(self, item: ET.Element, pid: int, pname: str, is_tomorrow: bool):
        # Extract fields
        # FuelWatch RSS puts most fields as simple tags under item
        trading_name = item.findtext('trading-name')
        location = item.findtext('location') # Suburb
        address = item.findtext('address')
        brand = item.findtext('brand')
        price_str = item.findtext('price')
        date_str = item.findtext('date') # 2025-12-26
        lat = item.findtext('latitude')
        lon = item.findtext('longitude')
        site_phone = item.findtext('phone')
        
        # Construct Store
        # Unique ID? Trading Name + Address? Or Lat/Lon?
        # RSS doesn't give a stable ID.
        # We'll generate one from Name + Suburb
        if not trading_name:
            return

        import re
        slug_name = re.sub(r'[^A-Z0-9]', '', trading_name.upper())[:15]
        slug_suburb = re.sub(r'[^A-Z0-9]', '', location.upper())[:10] if location else "WA"
        
        store_code = f"WA_{slug_suburb}_{slug_name}" # e.g. WA_PERTH_BPPERTH
        
        # Use phone as well?
        
        store = ParsedStore(
            store_id=store_code,
            name=f"{brand} {location}" if brand else trading_name,
            address=f"{address}, {location}, WA",
            city=location,
            attributes={
                'latitude': lat,
                'longitude': lon,
                'phone': site_phone,
                'brand': brand
            }
        )
        
        store_db_id = self.get_or_create_store(store)
        
        # Update Lat/Lon
        if store_db_id and lat and lon:
             # Basic check if update needed? BaseScraper does insert only.
             # We can run an update query if needed.
             pass

        # Construct Product
        # Barcode: WA_{PID} or WA_{PID}_TMR
        suffix = "_TMR" if is_tomorrow else ""
        product_name = f"{pname} (Tomorrow)" if is_tomorrow else pname
        barcode = f"WA_FUEL_{pid}{suffix}"
        
        p = ParsedProduct(
            name=product_name,
            barcode=barcode,
            price=float(price_str) if price_str else 0.0,
            manufacturer=brand, # Or FuelWatch?
            quantity="1",
            unit_of_measure="Liter",
            is_weighted=False,
            attributes={
                'currency': 'AUD',
                'date': date_str,
                'is_tomorrow': is_tomorrow
            }
        )
        
        self.import_product(p, store_id=store_db_id)
