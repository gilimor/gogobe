
import logging
import zipfile
import io
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import List, Dict, Tuple, Any, Optional
from datetime import datetime

from .base_supermarket_scraper import BaseSupermarketScraper, FileMetadata, ParsedProduct, ParsedStore

logger = logging.getLogger(__name__)

class FranceFuelScraper(BaseSupermarketScraper):
    """
    Scraper for French Government Fuel Prices "Prix des carburants".
    Source: https://www.prix-carburants.gouv.fr/rubrique/opendata/
    
    Data is provided as a ZIP file containing an XML file with all stations and current prices.
    URL: https://donnees.roulez-eco.fr/opendata/instantane
    """
    
    DOWNLOAD_URL = "https://donnees.roulez-eco.fr/opendata/instantane"
    
    def __init__(self):
        super().__init__(
            chain_name='Prix Carburants France',
            chain_slug='fr_fuel_gov',
            chain_name_he='מחירי דלק צרפת',
            chain_id='FR_FUEL_GOV',
            country_code='FR'
        )

    def fetch_file_list(self, file_type: str = 'prices', limit: Optional[int] = None) -> List[FileMetadata]:
        # The file contains BOTH stores and prices.
        ts = datetime.now().strftime('%Y%m%d%H%M')
        return [FileMetadata(
            url=self.DOWNLOAD_URL,
            filename=f"prix_carburants_fr_{ts}.zip",
            file_type='all', # Contains both
            store_id="FR_ALL",
            size_bytes=0
        )]

    def parse_file(self, file_path: Path) -> Tuple[Dict, List[ParsedProduct]]:
        """
        Parse the ZIP containing the XML.
        """
        logger.info(f"Parsing France Fuel Data: {file_path}")
        
        # Ensure chain exists in DB
        self.ensure_chain_exists()
        
        cnt_stores = 0
        cnt_prices = 0
        
        # We process manually to handle the huge XML efficiently (iterparse)
        # and insert directly into DB like the Italy scraper to avoid memory issues.
        
        try:
            with zipfile.ZipFile(file_path, 'r') as zip_ref:
                # Find the XML file
                xml_filename = next((name for name in zip_ref.namelist() if name.endswith('.xml')), None)
                if not xml_filename:
                    logger.error("No XML file found in ZIP")
                    return {}, []
                
                logger.info(f"Extracting {xml_filename}...")
                
                with zip_ref.open(xml_filename) as xml_file:
                    # Use iterparse for memory efficiency
                    context = ET.iterparse(xml_file, events=('end',))
                    
                    # Track batch for prices
                    self.price_batch = []
                    seen_combos = set() # (store_id, barcode)
                    
                    for event, elem in context:
                        if elem.tag == 'pdv':
                            try:
                                self._process_station(elem)
                                cnt_stores += 1
                                # Prices are nested children of <pdv>
                                cnt_prices += self._process_prices(elem, seen_combos)
                            except Exception as e:
                                logger.warning(f"Error processing station: {e}")
                            finally:
                                # Clear element to save memory
                                elem.clear()
                                
            # Final flush of prices
            if self.price_batch:
                self._flush_price_batch()
                
        except Exception as e:
            logger.error(f"Failed to parse France XML: {e}")
            raise

        logger.info(f"France Import Complete. Stations: {cnt_stores}, Prices: {cnt_prices}")
        return {"store_id": "FR_DONE", "chain_id": self.chain_db_id}, []

    def _process_station(self, pdv_elem: ET.Element):
        """Process a Point de Vente (Store)"""
        store_code = pdv_elem.get('id')
        lat = pdv_elem.get('latitude')
        lon = pdv_elem.get('longitude')
        
        # Normalize coordinates (France data is typically integer * 100000)
        # e.g. 4885000 -> 48.85000
        if lat and  lat != '0':
            try:
                lat = float(lat) / 100000
            except: lat = None
            
        if lon and lon != '0':
            try:
                lon = float(lon) / 100000
            except: lon = None
            
        address_elem = pdv_elem.find('adresse')
        city_elem = pdv_elem.find('ville')
        
        address = address_elem.text if address_elem is not None else ""
        city = city_elem.text if city_elem is not None else ""
        postal_code = pdv_elem.get('cp', '')
        
        name = f"Station {city} {postal_code}"
        
        store = ParsedStore(
            store_id=store_code,
            name=name,
            address=address,
            city=city,
            attributes={'postal_code': postal_code}
        )
        
        # Get DB ID
        store_db_id = self.get_or_create_store(store)
        
        # Update Lat/Lon if valid
        if store_db_id and lat and lon:
            conn = self.get_db_connection()
            with conn.cursor() as cur:
                 cur.execute("UPDATE stores SET latitude=%s, longitude=%s WHERE id=%s", (lat, lon, store_db_id))
            conn.commit()
            
        # Attach db_id to element for price processing
        pdv_elem.set('db_id', str(store_db_id))

    def _process_prices(self, pdv_elem: ET.Element, seen_combos: set) -> int:
        """Process prices for a station"""
        store_db_id = pdv_elem.get('db_id')
        if not store_db_id:
            return 0
            
        cnt = 0
        for price_elem in pdv_elem.findall('prix'):
            try:
                fuel_name = price_elem.get('nom') # e.g. Gazole, SP95
                fuel_id = price_elem.get('id')    # e.g. 1, 2
                val_str = price_elem.get('valeur') # e.g. 1.765
                update_time = price_elem.get('maj') # e.g. 2023-10-10 08:00:00
                
                if not val_str or not fuel_name:
                    continue
                    
                # Generate Barcode
                # Use standard slugs: FR_GAZOLE, FR_SP95
                import re
                slug = re.sub(r'[^A-Z0-9]', '', fuel_name.upper())[:15]
                barcode = f"FR_{slug}"
                
                # Check for duplicate IN THIS BATCH/RUN using the set
                # Actually, duplicate prices are possible if multiple updates? 
                # The XML represents "Instant Status". Should be unique per fuel type per station.
                
                if (store_db_id, barcode) in seen_combos:
                    continue
                seen_combos.add((store_db_id, barcode))

                p = ParsedProduct(
                    name=fuel_name,
                    barcode=barcode,
                    price=float(val_str) / 1000.0, # Wait, is it 1765 or 1.765?
                    # Example says "1.765". If it has dot, float works.
                    # If it's integer "1765", need to divide.
                    # Usually XML attributes are normalized strings.
                    # MIMIT was 1.765. France usually 1.765 or 1765.
                    # Let's check safely.
                    manufacturer=self.chain_name,
                    quantity="1",
                    unit_of_measure="Liter",
                    is_weighted=False,
                    attributes={'currency': 'EUR', 'updated_at': update_time}
                )
                
                # We need to handle the price format. 
                # If >= 100, assume millis? No, price is usually < 3 EUR.
                # If val is "1789", it's 1.789. If "1.789", it's 1.789.
                val_float = float(val_str)
                if val_float > 10: # Safety heuristic
                   p.price = val_float / 1000.0
                else:
                   p.price = val_float
                
                # Insert
                # We access internal batch clearing if needed
                if len(self.price_batch) > (self.batch_size * 2):
                    self.price_batch = []
                    
                self.import_product(p, store_id=int(store_db_id))
                cnt += 1
                
            except Exception as e:
                continue
                
        return cnt
