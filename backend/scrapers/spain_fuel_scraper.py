
import requests
import json
import logging
from datetime import datetime
from typing import List, Dict, Optional
from pathlib import Path

from .base_supermarket_scraper import BaseSupermarketScraper, FileMetadata, ParsedProduct, ParsedStore

logger = logging.getLogger(__name__)

class SpainFuelScraper(BaseSupermarketScraper):
    """
    Scraper for Spanish Fuel Prices (Geoportal Gasolineras).
    Source: https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/
    """
    
    BASE_URL = "https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/"
    
    # Product Mapping: API Field -> (Barcode, Name)
    PRODUCT_MAP = {
        'Precio Gasolina 95 E5': ('ES_FUEL_95_E5', 'Gasolina 95 E5'),
        'Precio Gasolina 98 E5': ('ES_FUEL_98_E5', 'Gasolina 98 E5'),
        'Precio Gasoleo A': ('ES_FUEL_DIESEL_A', 'Gasoleo A (Diesel)'),
        'Precio Gasoleo Premium': ('ES_FUEL_DIESEL_PLUS', 'Gasoleo Premium'),
        'Precio Gases licuados del petróleo': ('ES_FUEL_LPG', 'GLP (Gases Licuados)'),
        'Precio Gas Natural Comprimido': ('ES_FUEL_CNG', 'GNC (Gas Natural)'),
    }

    def __init__(self):
        super().__init__(
            chain_name='Spain Fuel (Geoportal)',
            chain_slug='spain_fuel_geoportal',
            chain_name_he='מחירי דלק ספרד',
            chain_id='ES_FUEL',
            country_code='ES'
        )
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': 'application/json'
        }

    def fetch_file_list(self, file_type: str = 'prices', limit: Optional[int] = None) -> List[FileMetadata]:
        # Single live JSON endpoint
        # We'll treat it as a "file" that downloads the JSON content
        now = datetime.now()
        filename = f"spain_fuel_{now.strftime('%Y%m%d_%H%M')}.json"
        
        return [FileMetadata(
            url=self.BASE_URL,
            filename=filename,
            file_type='json',
            size_bytes=0,
            store_id='ES_ALL',
            timestamp=now
        )]

    def download_file(self, file_metadata: FileMetadata, download_dir: Path) -> Optional[Path]:
        """Override download to fetch JSON properly"""
        local_path = download_dir / file_metadata.filename
        try:
            logger.info(f"Downloading {file_metadata.url}...")
            resp = requests.get(file_metadata.url, headers=self.headers, timeout=60, verify=False) # Skip verify for gov sites sometimes
            resp.raise_for_status()
            
            with open(local_path, 'w', encoding='utf-8') as f:
                json.dump(resp.json(), f, ensure_ascii=False, indent=2)
                
            return local_path
        except Exception as e:
            logger.error(f"Download failed: {e}")
            return None

    def parse_file(self, file_path: Path):
        """Parse the JSON file"""
        self.ensure_chain_exists() # Ensure chain ID is loaded
        logger.info(f"Parsing Spain Fuel Data: {file_path}")
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                
            stations = data.get('ListaEESSPrecio', [])
            logger.info(f"Found {len(stations)} stations to process.")
            
            cnt_prices = 0
            
            for item in stations:
                try:
                    self._process_station(item)
                    cnt_prices += 1
                    
                    if cnt_prices % 1000 == 0:
                        logger.info(f"Processed {cnt_prices} stations...")
                        self._flush_price_batch()
                        
                except Exception as e:
                    pass # Skip problematic items
                    
            self._flush_price_batch()
            logger.info("Parsing completed.")
            return {}, []
            
        except Exception as e:
            logger.error(f"Parse error: {e}")
            return {}, []

    def _process_station(self, item: Dict):
        """Process a single station object"""
        # 1. Identify Store
        store_id = item.get('IDEESS')
        if not store_id: return
        
        # Parse fields
        lat_str = item.get('Latitud', '').replace(',', '.')
        lon_str = item.get('Longitud', '').replace(',', '.')
        
        brand = item.get('Rótulo', 'UNKNOWN').strip()
        address = item.get('Dirección', '').strip()
        city = item.get('Localidad', '').strip()
        province = item.get('Provincia', '').strip()
        
        try:
            lat = float(lat_str) if lat_str else None
            lon = float(lon_str) if lon_str else None
        except:
            lat, lon = None, None
            
        store = ParsedStore(
            store_id=f"ES_{store_id}",
            name=f"{brand} {city}".strip(),
            address=f"{address}, {city}, {province}",
            city=city,
            latitude=lat,
            longitude=lon,
            attributes={
                'brand': brand,
                'province': province,
                'schedule': item.get('Horario')
            }
        )
        
        store_db_id = self.get_or_create_store(store)
        if not store_db_id: return
        
        # 2. Extract Prices
        for field, (barcode, name) in self.PRODUCT_MAP.items():
            price_raw = item.get(field)
            if not price_raw: continue
            
            try:
                # convert "1,299" -> 1.299
                price_val = float(price_raw.replace(',', '.'))
            except:
                continue
                
            if price_val <= 0: continue
            
            p = ParsedProduct(
                name=name,
                barcode=barcode,
                price=price_val,
                manufacturer=brand,
                quantity="1",
                unit_of_measure="Liter",
                attributes={
                    'currency': 'EUR',
                    'brand': brand
                }
            )
            
            self.import_product(p, store_id=store_db_id)

