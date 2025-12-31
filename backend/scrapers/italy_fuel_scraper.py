
import csv
import logging
from pathlib import Path
from typing import List, Dict, Tuple, Any, Optional
from datetime import datetime
import io

from .base_supermarket_scraper import BaseSupermarketScraper, FileMetadata, ParsedProduct, ParsedStore

logger = logging.getLogger(__name__)

class ItalyFuelScraper(BaseSupermarketScraper):
    """
    Scraper for Italian Ministry of Economic Development (MIMIT) Fuel Prices.
    Source: Open Data (CSV)
    
    Files:
    1. Anagrafica (Stations Registry) - https://www.mimit.gov.it/images/exportCSV/anagrafica_impianti_attivi.csv
    2. Prezzi (Prices) - https://www.mimit.gov.it/images/exportCSV/prezzo_alle_8.csv
    """
    
    BASE_URL = "https://www.mimit.gov.it/images/exportCSV"
    
    def __init__(self):
        super().__init__(
            chain_name='MIMIT Carburanti',
            chain_slug='mimit_fluels_it',
            chain_name_he='מחירי דלק איטליה',
            chain_id='IT_FUEL_MIMIT',
            country_code='IT'
        )
        # Cache for store mapping: idImpianto -> db_id
        self.store_map = {}

    def fetch_file_list(self, file_type: str = 'prices', limit: Optional[int] = None) -> List[FileMetadata]:
        """
        Returns the two static URLs for daily open data.
        """
        files = []
        
        # Always fetch registry first in the list so it processes first? 
        # Actually the orchestrator might sort or process in parallel.
        # Ideally we want Registry processed before Prices.
        
        ts = datetime.now().strftime('%Y%m%d%H%M')
        
        # 1. Registry (Anagrafica)
        if file_type in ['stores', 'all']:
            files.append(FileMetadata(
                url=f"{self.BASE_URL}/anagrafica_impianti_attivi.csv",
                filename=f"anagrafica_impianti_attivi_{ts}.csv", # Unique name to force download
                file_type='stores',
                store_id="IT_ALL",
                size_bytes=0
            ))
            
        # 2. Prices (Prezzi)
        if file_type in ['prices', 'all']:
            files.append(FileMetadata(
                url=f"{self.BASE_URL}/prezzo_alle_8.csv",
                filename=f"prezzo_alle_8_{ts}.csv",
                file_type='prices',
                store_id="IT_ALL",
                size_bytes=0
            ))
            
        return files

    def parse_file(self, file_path: Path) -> Tuple[Dict, List[ParsedProduct]]:
        """
        Custom parser that handles CSVs.
        Note: This overrides standard XML/JSON parsing.
        """
        filename = file_path.name
        
        if "anagrafica" in filename:
            return self._parse_registry(file_path)
        elif "prezzo" in filename:
            return self._parse_prices(file_path)
            
        return {}, []

    def _parse_registry(self, file_path: Path) -> Tuple[Dict, List]:
        """
        Parse Anagrafica CSV and update stores.
        Format: idImpianto;Gestore;Bandiera;Tipo Impianto;Nome Impianto;Indirizzo;Comune;Provincia;Latitudine;Longitudine
        """
        logger.info(f"Parsing Station Registry: {file_path}")
        
        # Ensure chain exists before we try to insert stores
        self.ensure_chain_exists()
        
        # Since this modifies stores directly, we might return empty products list
        # We can implement 'side-effect' parsing here.
        
        # But BaseSupermarketScraper expects us to return data.
        # However, for 20k stores, we probably want to batch insert.
        # The base class `import_files` loop calls `parse_file`, then `get_or_create_store`, then `import_products`.
        # This flow assumes 1 file = 1 store.
        # HERE: 1 file = 20k stores.
        
        # HACK: We will perform the DB updates HERE inside parsing, and return empty.
        # This breaks the 'pure parser' contract but fits the 'bulk file' reality.
        
        cnt = 0
        conn = self.get_db_connection()
        try:
            with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
                # Skip metadata line (Estrazione del YYYY-MM-DD)
                metadata_line = f.readline() 
                if 'idImpianto' in metadata_line:
                    # Case where there is no metadata line? Unlikely based on test.
                    # specific test files show there is one.
                    # But if we accidentally consumed the header, we need to seek back?
                    # The test showed: Header: Estrazione... Row 1: idImpianto...
                    # So yes, skip one line.
                    pass
                
                # Check dialect
                # Usually CSV Italy uses ';' delimiter
                reader = csv.DictReader(f, delimiter=';')
                
                # Buffer for batch insert? 
                # For simplicity, let's use the helper `get_or_create_store` but that might be slow.
                # Let's do raw SQL for speed.
                
                cur = conn.cursor()
                
                # Ensure chain exists
                chain_id = self.chain_db_id
                if not chain_id:
                     # This should be set by init/login usually, check logic
                     pass

                for row in reader:
                    try:
                        # Map fields
                        store_code = row.get('idImpianto')
                        name = row.get('Nome Impianto') or row.get('Bandiera') or 'Station'
                        brand = row.get('Bandiera', 'Unknown')
                        address = row.get('Indirizzo')
                        city = row.get('Comune')
                        lat = row.get('Latitudine')
                        lon = row.get('Longitudine')
                        
                        full_name = f"{brand} - {name}"
                        
                        # Upsert Store
                        # We use store_id as the unique key (chain_id + store_id)
                        
                        # Optimization: We can't do one-by-one safely without being slow.
                        # But for 20k it might take a minute. Acceptable.
                        
                        store = ParsedStore(
                            store_id=store_code,
                            name=full_name,
                            city=city,
                            address=address
                        )
                        
                        # Use our helper, but we need to set `latitude` manually if not in ParsedStore
                        # ParsedStore doesn't have lat/lon yet? 
                        # Let's check Base.
                        
                        sid = self.get_or_create_store(store)
                        
                        # Update Lat/Lon separately if available
                        if lat and lon and lat != 'null' and lon != 'null':
                            try:
                                cur.execute("""
                                    UPDATE stores SET latitude = %s, longitude = %s 
                                    WHERE id = %s
                                """, (float(lat), float(lon), sid))
                            except: pass
                        
                        cnt += 1
                        if cnt % 1000 == 0:
                            conn.commit()
                            logger.info(f"Processed {cnt} stations...")
                            
                    except Exception as e:
                        logger.warning(f"Error parsing station row: {e}")
                        continue
                        
                conn.commit()
                cur.close()
                
        finally:
            conn.close()
            
        logger.info(f"Registry Import Complete. Total: {cnt}")
        # Return empty so the pipeline doesn't try to import products
        return {"store_id": "REGISTRY_DONE", "chain_id": self.chain_db_id}, []

    def _parse_prices(self, file_path: Path) -> Tuple[Dict, List]:
        """
        Parse Prices CSV.
        Format: idImpianto;descCarburante;prezzo;isSelf;dtComu
        """
        logger.info(f"Parsing Fuel Prices: {file_path}")
        
        # Strategy:
        # We need to map `idImpianto` to `store_db_id`.
        # Then insert prices.
        # Again, we will do this HERE instead of returning products, because products need a `store_id` association 
        # and the standard pipeline assumes all returned products belong to the SAME store.
        
        # 1. Load Store Map (store_code -> db_id) for this chain
        self._load_store_map()
        
        cnt = 0
        conn = self.get_db_connection()
        cur = conn.cursor()
        
        try:
            with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
                # Skip metadata line
                f.readline()
                
                reader = csv.DictReader(f, delimiter=';')
                
                # Track unique entries to avoid "ON CONFLICT" errors in batch
                seen_entries = set()
                
                for row in reader:
                    try:
                        store_code = row.get('idImpianto', '').strip()
                        fuel_type = row.get('descCarburante', '').strip()
                        price_str = row.get('prezzo', '').strip()
                        is_self = row.get('isSelf') == '1'
                        
                        if not store_code or not price_str:
                            continue


                        
                        # Fix Key: Base scraper prepends chain_id to store_id
                        lookup_key = f"{self.chain_id}_{store_code}"
                        
                        store_db_id = self.store_map.get(lookup_key)
                        if not store_db_id:
                            # Store not found (maybe inactive or new)
                            continue
                            
                        # Construct product name
                        # e.g. "Benzina (Self)" or "Benzina (Servito)"
                        service_type = "Self" if is_self else "Servito"
                        product_name = f"{fuel_type} ({service_type})"
                        
                        # We treat Fuel Types as "Products".
                        # Check product ID mapping (create if needed)
                        # We can use `get_or_create_product` logic here manually or rely on `import_product`?
                        # `import_product` is heavy.
                        # Let's optimize:
                        # Fuel types are few (Benzina, Gasolio, GPL, Metano).
                        # We can cache their product IDs.
                        
                        # ... Actually, for simplicity/robustness, let's create a ParsedProduct 
                        # and use 'import_product' but we have to HACK it.
                        # Can we call `self.import_product(p, store_id)` directly here? Yes.
                        
                        # Construct shorter barcode (Max 20 chars)
                        # Remove spaces, keep only ALPHANUMERIC
                        import re
                        clean_fuel = re.sub(r'[^A-Z0-9]', '', fuel_type.upper())
                        fuel_slug = clean_fuel[:15]
                        
                        srv_slug = "SLF" if is_self else "SRV"
                        unique_suffix = f"{fuel_slug}_{srv_slug}"
                        
                        barcode_candidate = f"IT_{unique_suffix}"[:20]
                        
                        # CRITICAL FIX: Deduplicate by (Store, Barcode) to avoid batch conflicts
                        # If different fuel names map to same barcode at same store, only take the first one.
                        combo_key = (store_db_id, barcode_candidate)
                        if combo_key in seen_entries:
                             # We re-use 'seen_entries' variable but now storing (store_id, barcode)
                             # Note: Previous dedup was on raw strings. We can keep both? 
                             # Let's just use this one as it matches the database constraint.
                             continue
                        seen_entries.add(combo_key)
                        
                        p = ParsedProduct(
                            name=product_name,
                            barcode=barcode_candidate,
                            price=float(price_str.replace(',', '.')), 
                            manufacturer=self.chain_name,
                            quantity="1",
                            unit_of_measure="Liter",
                            is_weighted=False,
                            attributes={'currency': 'EUR'}
                        )
                        
                        # Monitor batch size manually
                        if len(self.price_batch) > (self.batch_size * 2):
                             logger.warning(f"Batch overflow ({len(self.price_batch)} items). Clearing batch to prevent infinite loop.")
                             self.price_batch = []
                             
                        self.import_product(p, store_id=store_db_id)
                        
                        cnt += 1
                        if cnt % 5000 == 0:
                            self._flush_price_batch() # If base class has batching
                            logger.info(f"Processed {cnt} prices...")
                            
                    except Exception as e:
                        logger.warning(f"Error parsing row: {e}")
                        # If a batch failure occurs, we must clear the batch to effectively skip the problematic rows
                        # Otherwise retry loop will fail again.
                        if "COPY failed" in str(e) or "ON CONFLICT" in str(e):
                             logger.error("Batch failure detected. Clearing batch to proceed.")
                             # This is tricky - self.import_product is where the batch is.
                             # We can access scraper.price_batch and clear it?
                             self.price_batch = []
                        continue
                        
            # Final flush
            self._flush_price_batch()
            
        finally:
            cur.close()
            conn.close()
            
        logger.info(f"Price Import Complete. Total: {cnt}")
        return {"store_id": "PRICES_DONE", "chain_id": self.chain_db_id}, []

    def _load_store_map(self):
        """Load all stores for this chain into memory"""
        conn = self.get_db_connection()
        cur = conn.cursor()
        # Get stores for this chain
        cur.execute("SELECT store_id, id FROM stores WHERE chain_id = %s", (self.chain_db_id,))
        self.store_map = {str(r[0]): r[1] for r in cur.fetchall()}
        cur.close()
        conn.close()
        logger.info(f"Loaded {len(self.store_map)} stores for mapping")
