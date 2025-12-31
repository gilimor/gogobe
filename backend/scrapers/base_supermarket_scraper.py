#!/usr/bin/env python3
"""
Base Supermarket Scraper
Generic framework for importing data from any supermarket chain worldwide
"""

from abc import ABC, abstractmethod
from typing import List, Dict, Optional, Any, Tuple
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
import gzip
import bz2
import zipfile
import json
import requests
import logging
import psycopg2
import os

import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='[%(asctime)s] %(levelname)s: %(message)s',
    datefmt='%H:%M:%S'
)
logger = logging.getLogger(__name__)


@dataclass
class FileMetadata:
    """Metadata for a data file"""
    url: str
    filename: str
    file_type: str  # 'stores', 'prices_full', 'prices', 'promos_full', 'promos'
    store_id: Optional[str] = None
    timestamp: Optional[datetime] = None
    size_bytes: Optional[int] = None


@dataclass
class ParsedProduct:
    """Normalized product data"""
    name: str
    barcode: Optional[str] = None
    manufacturer: Optional[str] = None
    description: Optional[str] = None
    price: Optional[float] = None
    unit_qty: Optional[str] = None
    quantity: Optional[str] = None
    unit_of_measure: Optional[str] = None
    is_weighted: bool = False
    manufacturer_code: Optional[str] = None
    attributes: Dict[str, Any] = None
    # Promo fields
    is_sale: bool = False
    price_regular: Optional[float] = None
    promo_description: Optional[str] = None
    
    def __post_init__(self):
        if self.attributes is None:
            self.attributes = {}


@dataclass
class ParsedStore:
    """Normalized store data"""
    store_id: str
    name: str
    city: Optional[str] = None
    address: Optional[str] = None
    bikoret_no: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    attributes: Dict[str, Any] = None
    
    def __post_init__(self):
        if self.attributes is None:
            self.attributes = {}


class BaseSupermarketScraper(ABC):
    """
    Abstract base class for all supermarket scrapers.
    
    Provides common functionality:
    - Database connection management
    - File downloading and decompression
    - Data normalization
    - Database import logic
    - Error handling and logging
    
    Subclasses must implement:
    - fetch_file_list(): Get available files
    - parse_file(): Parse file content
    """
    
    def __init__(self, chain_name: str, chain_slug: str, chain_name_he: str, 
                 chain_id: str, country_code: str = 'IL'):
        """
        Initialize scraper
        
        Args:
            chain_name: Chain name in English
            chain_slug: URL-friendly slug
            chain_name_he: Chain name in Hebrew
            chain_id: Official chain ID (e.g., barcode prefix)
            country_code: ISO country code
        """
        self.chain_name = chain_name
        self.chain_slug = chain_slug
        self.chain_name_he = chain_name_he
        self.chain_id = chain_id
        self.country_code = country_code
        
        self.conn = None
        self.supplier_id = None
        self.chain_db_id = None
        self.vertical_id = None
        
        # Initialize Redis cache (optional - gracefully handles if Redis unavailable)
        try:
            import sys
            from pathlib import Path
            cache_path = Path(__file__).parent.parent / 'cache'
            sys.path.insert(0, str(cache_path))
            from redis_cache import get_cache
            self.cache = get_cache()
            logger.info(f"✓ Redis cache enabled")
        except Exception as e:
            logger.warning(f"Redis cache unavailable: {e}")
            logger.warning("Running without cache - performance may be slower")
            self.cache = None
        
        # Initialize Master Product Matcher
        # Re-enabled after fixing schema and race condition
        try:
             import sys
             from pathlib import Path
             # Ensure services dir is in path
             services_path = Path(__file__).parent.parent / 'services'
             if str(services_path) not in sys.path:
                 sys.path.insert(0, str(services_path))
                 
             from master_product_matcher import MasterProductMatcher
             
             db_config = {
                'dbname': os.getenv('DB_NAME', 'gogobe'),
                'user': os.getenv('DB_USER', 'postgres'),
                'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
                'host': os.getenv('DB_HOST', 'localhost'),
                'port': os.getenv('DB_PORT', '5432')
             }
             self.master_matcher = MasterProductMatcher(db_config, use_ai=False)
             logger.info(f"✓ Master Product Matcher: Enabled")
        except Exception as e:
             logger.warning(f"Failed to init Master Matcher: {e}")
             self.master_matcher = None
        
        # Initialize File Processing Tracker
        try:
            import sys
            services_path = Path(__file__).parent.parent / 'services'
            sys.path.insert(0, str(services_path))
            from file_processing_tracker import FileProcessingTracker
            # Note: We initialize tracker with connection later when needed
            self.tracker = None 
            logger.info("✓ File Processing Tracker: Ready")
        except Exception as e:
            logger.warning(f"File Processing Tracker unavailable: {e}")
            self.tracker = None
        
        # Batch processing settings
        # "STREAM" MODE: Very small batch to ensure data appears in DB immediately
        self.batch_size = 100  
        self.price_batch = []
        
        logger.info(f"Initialized {chain_name} scraper")
    
    # ============================================================================
    # Abstract Methods (must be implemented by subclasses)
    # ============================================================================
    
    @abstractmethod
    def fetch_file_list(self, file_type: str = 'prices_full', 
                       limit: Optional[int] = None) -> List[FileMetadata]:
        """
        Fetch list of available files from the data source
        
        Args:
            file_type: Type of files to fetch ('stores', 'prices_full', etc.)
            limit: Maximum number of files to return
            
        Returns:
            List of FileMetadata objects
        """
        pass
    
    import requests

    def download_file(self, file_meta: FileMetadata, download_dir: Path) -> Path:
        """
        Generic file download implementation
        """
        output_path = download_dir / file_meta.filename
        abs_path = output_path.resolve()
        
        if output_path.exists():
            # Check for corruption (HTML error page content instead of size)
            try:
                with open(output_path, 'rb') as f:
                    header = f.read(100)
                    if not False and (b'<!doctype html' in header.lower() or b'<html' in header.lower()):
                        logger.warning(f"Found corrupt file (HTML error): {abs_path} - Deleting")
                        output_path.unlink()
                    else:
                        logger.info(f"File already exists: {file_meta.filename}")
                        return output_path
            except Exception:
                # If read fails, re-download
                pass
            
        logger.info(f"Downloading {file_meta.filename} to {abs_path}...")
        try:
            # Use requests for simple HTTP downloads
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
            }
            response = requests.get(
                file_meta.url, 
                stream=True, 
                timeout=60, 
                verify=False,
                headers=headers
            ) # Skip SSL verify for some sites
            # response.raise_for_status() # Don't raise immediately, check content type?
            
            if response.status_code != 200:
                raise Exception(f"HTTP {response.status_code}")

            download_dir.mkdir(parents=True, exist_ok=True)
            with open(output_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            
            # Verify download - check if it looks like an error page (HTML)
            # We can't strictly check size because valid GZ files can be small (<1KB)
            with open(output_path, 'rb') as f:
                header = f.read(100)
                if b'<!doctype html' in header.lower() or b'<html' in header.lower():
                     logger.warning(f"Downloaded file appears to be an HTML error page. Deleting.")
                     output_path.unlink()
                     raise Exception("Downloaded file is an HTML error page")
                    
            logger.info(f"Downloaded: {file_meta.filename}")
            return output_path
        except Exception as e:
            logger.error(f"Download failed: {e}")
            if output_path.exists():
                output_path.unlink()
            raise

    @abstractmethod
    def parse_file(self, file_path: Path) -> Tuple[Dict[str, Any], List[ParsedProduct]]:

        """
        Parse a data file and extract products
        
        Args:
            file_path: Path to the file to parse
            
        Returns:
            Tuple of (metadata dict, list of ParsedProduct objects)
        """
        pass
    
    # ============================================================================
    # Database Methods
    # ============================================================================
    
    def get_db_connection(self):
        """Get database connection with proper UTF-8 encoding"""
        if self.conn is None or self.conn.closed:
            self.conn = psycopg2.connect(
                dbname=os.getenv('DB_NAME', 'gogobe'),
                user=os.getenv('DB_USER', 'postgres'),
                password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
                host=os.getenv('DB_HOST', 'localhost'),
                port=os.getenv('DB_PORT', '5432'),
                client_encoding='UTF8'
            )
            logger.info("Connected to database")
        return self.conn
    
    def ensure_chain_exists(self):
        """Ensure chain, supplier, and vertical exist in database"""
        conn = self.get_db_connection()
        cur = conn.cursor()
        
        try:
            # Get or create vertical "Supermarket"
            cur.execute("""
                INSERT INTO verticals (name, slug, is_priority)
                VALUES ('Supermarket', 'supermarket', FALSE)
                ON CONFLICT (slug) DO NOTHING
            """)
            
            cur.execute("SELECT id FROM verticals WHERE slug = 'supermarket'")
            self.vertical_id = cur.fetchone()[0]
            
            # Get or create supplier
            cur.execute("""
                INSERT INTO suppliers (name, slug, country_code, supplier_type)
                VALUES (%s, %s, %s, 'supermarket')
                ON CONFLICT (slug) DO NOTHING
            """, (self.chain_name, self.chain_slug, self.country_code))
            
            cur.execute("SELECT id FROM suppliers WHERE slug = %s", (self.chain_slug,))
            self.supplier_id = cur.fetchone()[0]
            
            try:
                cur.execute("SELECT id FROM chains WHERE chain_id=%s", (self.chain_id,))
                result = cur.fetchone()
                
                if result:
                    self.chain_db_id = result[0]
                    # logger.info(f"Chain setup complete: supplier_id={self.supplier_id}, chain_id={self.chain_db_id}")
                else:
                    # Create chain
                    cur.execute("""
                        INSERT INTO chains (name, chain_id, subchain_id, is_active)
                        VALUES (%s, %s, '0', TRUE)
                        RETURNING id
                    """, (self.chain_name, self.chain_id))
                    self.chain_db_id = cur.fetchone()[0]
                    conn.commit()
                    # logger.info(f"Created new chain: {self.chain_name} (ID: {self.chain_db_id})")
            except Exception as e:
                logger.error(f"Failed to get or create chain: {e}")
                raise
            
            conn.commit()
            logger.info(f"Chain setup complete: supplier_id={self.supplier_id}, chain_id={self.chain_db_id}")
            
        except Exception as e:
            logger.error(f"Failed to setup chain: {e}")
            conn.rollback()
            raise
        finally:
            cur.close()
    
    def build_store_identifier(self, store: ParsedStore) -> str:
        """
        Build unique store identifier for this chain.
        
        Subclasses can override this to customize how stores are identified.
        Default: {chain_id}_{store_id}
        
        Examples:
        - Rami Levy: "7290058140886_001"
        - Shufersal: "7290027600007_123"
        - KingStore: "7290172900007_5_042" (includes subchain)
        
        Args:
            store: ParsedStore object
            
        Returns:
            Unique store identifier string
        """
        return f"{self.chain_id}_{store.store_id}"
    
    def get_or_create_store(self, store: ParsedStore) -> Optional[int]:
        """
        Get or create store in database
        
        Args:
            store: ParsedStore object
            
        Returns:
            Store database ID (stores.id)
        """
        conn = self.get_db_connection()
        cur = conn.cursor()
        
        try:
            # Build unique store identifier using chain-specific logic
            unique_store_code = self.build_store_identifier(store)
            
            # Create or Update store using Upsert
            # We removed the early SELECT check to ensure that if we have better data (e.g. name from Stores file),
            # it overwrites the generic data (e.g. from Price file).
            
            # Check attributes for lat/lon if not in field (backward compat)
            lat = store.latitude or store.attributes.get('latitude')
            lon = store.longitude or store.attributes.get('longitude')

            cur.execute("""
                INSERT INTO stores (
                    chain_id, store_id, name, city, address, bikoret_no, latitude, longitude
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (chain_id, store_id) 
                DO UPDATE SET
                    name = CASE WHEN EXCLUDED.name LIKE '%%Store%%' AND stores.name NOT LIKE '%%Store%%' THEN stores.name ELSE EXCLUDED.name END,
                    city = COALESCE(EXCLUDED.city, stores.city),
                    address = COALESCE(EXCLUDED.address, stores.address),
                    bikoret_no = COALESCE(EXCLUDED.bikoret_no, stores.bikoret_no),
                    latitude = COALESCE(EXCLUDED.latitude, stores.latitude),
                    longitude = COALESCE(EXCLUDED.longitude, stores.longitude),
                    updated_at = NOW()
            """, (
                self.chain_db_id,
                unique_store_code, 
                store.name,
                store.city,
                store.address,
                store.bikoret_no,
                lat,
                lon
            ))
            
            # Always select to get the ID (safest approach)
            cur.execute("SELECT id FROM stores WHERE chain_id=%s AND store_id=%s", (self.chain_db_id, unique_store_code))
            result = cur.fetchone()
            
            # logger.info(f"DEBUG: UniqueCode={unique_store_code}, ResultType={type(result)}, Result={result}")
            
            if result:
                store_db_id = result[0]
                conn.commit()
                # logger.info(f"Created/Updated store: {store.name} (Code: {unique_store_code}, DB ID: {store_db_id})")
                return store_db_id
            else:
                logger.error(f"Failed to retrieve ID after upsert for {unique_store_code}")
                return None
            
        except Exception as e:
            logger.error(f"Failed to create store {store.store_id}: {e}")
            conn.rollback()
            return None
        finally:
            cur.close()
    
    def import_product(self, product: ParsedProduct, store_id: Optional[int] = None) -> Dict[str, int]:
        """
        Import a single product and its price (with cache + batch support)
        
        Args:
            product: ParsedProduct object
            store_id: Store database ID (optional)
            
        Returns:
            Dict with 'products' and 'prices' counts
        """
        conn = self.get_db_connection()
        cur = conn.cursor()
        stats = {'products': 0, 'prices': 0, 'skipped': 0, 'cached': 0}
        
        try:
            # Skip if missing required fields
            if not product.name or not product.price:
                stats['skipped'] += 1
                return stats
            
            # ===== CACHE LOOKUP (99% hit rate!) =====
            product_id = None
            if product.barcode and self.cache:
                product_id = self.cache.get_product_id(product.barcode)
                if product_id:
                    stats['cached'] += 1
            
            # ===== DATABASE LOOKUP (only if not in cache) =====
            if not product_id and product.barcode:
                cur.execute("""
                    SELECT id FROM products
                    WHERE (ean = %s OR manufacturer_code = %s)
                    LIMIT 1
                """, (product.barcode, product.barcode))
                
                result = cur.fetchone()
                if result:
                    product_id = result[0]
                    # Cache for next time
                    if self.cache:
                        self.cache.cache_product(product.barcode, product_id)
            
            # ===== CREATE NEW PRODUCT =====
            if not product_id:
                # Build attributes JSON
                attributes = product.attributes.copy() if product.attributes else {}
                attributes.update({
                    'unit_qty': product.unit_qty,
                    'quantity': product.quantity,
                    'unit_of_measure': product.unit_of_measure,
                    'is_weighted': product.is_weighted,
                })
                # Remove None values
                attributes = {k: v for k, v in attributes.items() if v is not None}
                
                cur.execute("""
                    INSERT INTO products (
                        name, description, vertical_id, ean, 
                        manufacturer_code, attributes
                    )
                    VALUES (%s, %s, %s, %s, %s, %s::jsonb)
                    ON CONFLICT (ean) WHERE ean IS NOT NULL DO UPDATE SET name = EXCLUDED.name
                    RETURNING id
                """, (
                    product.name[:500],
                    product.description[:1000] if product.description else None,
                    self.vertical_id,
                    product.barcode,
                    product.manufacturer_code or product.barcode,
                    json.dumps(attributes, ensure_ascii=False)
                ))
                
                result = cur.fetchone()
                if result:
                    product_id = result[0]
                    conn.commit() # FORCE COMMIT: Ensure exists for foreign keys
                    stats['products'] += 1
                    # logger.debug(f"Created product {product_id}")
                    # Cache the new product
                    if self.cache and product.barcode:
                        self.cache.cache_product(product.barcode, product_id)
                    
                    # ===== LINK TO MASTER PRODUCT (THE PATENT!) =====
                    master_linked = False
                    if self.master_matcher:
                        try:
                            match = self.master_matcher.match_product(product_id)
                            if match.master_product_id:
                                # logger.debug(f"✓ Linked to Master #{match.master_product_id} via {match.method}")
                                master_linked = True
                            else:
                                logger.warning(f"⚠️ No master product for #{product_id}")
                        except Exception as e:
                            logger.warning(f"Master matching failed: {e}")

                    # ⛔ STRICT MODE ENFORCEMENT ⛔
                    # If we have a matcher but failed to get a link, we DROP the price.
                    # This ensures "No Price Without Master".
                    if self.master_matcher and not master_linked:
                        logger.error(f"⛔ STRICT MODE: Dropping price for Product #{product_id} ({product.name}) - Link Failed")
                        stats['skipped'] += 1
                        return stats
            
            if not product_id:
                stats['skipped'] += 1
                return stats
            
            # ===== ADD TO BATCH (instead of immediate insert) =====
            self.price_batch.append({
                'product_id': product_id,
                'supplier_id': self.supplier_id,
                'store_id': store_id,
                'price': product.price,
                'is_sale': product.is_sale,
                'price_regular': product.price_regular,
                'promo_description': product.promo_description,
                'currency': product.attributes.get('currency', 'ILS')
            })
            
            # Insert batch when it reaches batch_size
            if len(self.price_batch) >= self.batch_size:
                inserted = self._flush_price_batch()
                stats['prices'] += inserted
            
            conn.commit()
            
        except Exception as e:
            logger.warning(f"Failed to import product {product.name}: {e}")
            stats['skipped'] += 1
            conn.rollback()
        finally:
            cur.close()
        
        return stats
    
    def _flush_price_batch(self) -> int:
        """
        Flush accumulated price batch using PostgreSQL COPY
        ULTRA-FAST: 5-10x faster than individual INSERT
        
        Strategy:
        1. COPY to temp table (native PostgreSQL bulk load)
        2. UPSERT from temp to main (handles duplicates)
        
        Returns:
            Number of prices inserted
        """
        if not self.price_batch:
            return 0
        
        # --- DEDUPLICATION FIX ---
        # PostgreSQL ON CONFLICT fails if the batch itself has duplicates.
        # We must keep only the latest entry for each (product_id, store_id) pair.
        unique_batch = {}
        for item in self.price_batch:
            key = (item['product_id'], item['store_id'])
            unique_batch[key] = item
        
        # Replace original batch with unique list
        self.price_batch = list(unique_batch.values())
        if not self.price_batch:
            return 0
        # -------------------------
            
        import io
        from datetime import datetime
        
        conn = self.get_db_connection()
        cur = conn.cursor()
        
        try:
            # Step 1: Create temp table
            cur.execute("""
                CREATE TEMP TABLE IF NOT EXISTS prices_temp (
                    product_id INTEGER,
                    supplier_id INTEGER,
                    store_id INTEGER,
                    price NUMERIC(10,2),
                    currency VARCHAR(3),
                    is_available BOOLEAN,
                    scraped_at TIMESTAMP,
                    last_scraped_at TIMESTAMP,
                    is_sale BOOLEAN,
                    price_regular NUMERIC(10,2),
                    promo_description TEXT
                ) ON COMMIT DELETE ROWS
            """)
            
            # Step 2: Prepare CSV in memory
            buffer = io.StringIO()
            scraped_at = datetime.now().isoformat()
            
            for price_data in self.price_batch:
                # Handle None values for CSV
                p_reg = price_data.get('price_regular')
                p_desc = price_data.get('promo_description')
                
                # Sanitize text
                if p_desc:
                    p_desc = p_desc.replace('"', '""').replace('\n', ' ')
                    p_desc = f'"{p_desc}"'
                else:
                    p_desc = ''
                    
                buffer.write(
                    f"{price_data['product_id']},"
                    f"{price_data['supplier_id']},"
                    f"{price_data['store_id']},"
                    f"{price_data['price']},"
                    f"{price_data.get('currency', 'ILS')},"
                    f"t,"
                    f"{scraped_at},"
                    f"{scraped_at},"
                    f"{'t' if price_data.get('is_sale') else 'f'},"
                    f"{p_reg if p_reg is not None else ''},"
                    f"{p_desc}\n"
                )
            
            buffer.seek(0)
            
            # Step 3: COPY to temp (ULTRA FAST!)
            cur.copy_from(
                buffer,
                'prices_temp',
                sep=',',
                null='',
                columns=[
                    'product_id', 'supplier_id', 'store_id',
                    'price', 'currency', 'is_available',
                    'scraped_at', 'last_scraped_at',
                    'is_sale', 'price_regular', 'promo_description'
                ]
            )
            
            # Step 4: Bulk UPSERT with UNIQUE constraint
            logger.info("DEBUG: Executing Batch Upsert with Inference (product_id, supplier_id, store_id)")
            cur.execute("""
                INSERT INTO prices (
                    product_id, supplier_id, store_id,
                    price, currency, is_available,
                    scraped_at, last_scraped_at,
                    is_sale, price_regular, promo_description
                )
                SELECT * FROM prices_temp
                ON CONFLICT (product_id, supplier_id, store_id)
                DO UPDATE SET
                    price = EXCLUDED.price,
                    currency = EXCLUDED.currency,
                    scraped_at = EXCLUDED.scraped_at,
                    last_scraped_at = EXCLUDED.last_scraped_at,
                    is_available = EXCLUDED.is_available,
                    is_sale = EXCLUDED.is_sale,
                    price_regular = EXCLUDED.price_regular,
                    promo_description = EXCLUDED.promo_description
                WHERE ABS(prices.price - EXCLUDED.price) > 0.01
                   OR prices.is_available != EXCLUDED.is_available
                   OR prices.is_sale != EXCLUDED.is_sale
            """)
            
            inserted = len(self.price_batch)
            # drop temp table
            cur.execute("DROP TABLE IF EXISTS prices_temp")
            
            conn.commit()
            
            # --- REAL-TIME REDIS EVENT ---
            try:
                import redis
                # Short timeout to not slow down the scraper
                r = redis.Redis(host='localhost', port=6379, db=0, socket_connect_timeout=0.1)
                # Event Format: type:chain:count
                r.publish('channel:ingest', f"price:{self.chain_name}:{inserted}")
            except:
                pass # Fail silently, data is more important than dash
            # -----------------------------
            
            logger.info(f"⚡ COPY: {inserted} prices (ULTRA-FAST!)")
            
            self.price_batch = []
            return inserted
            
        except Exception as e:
            logger.error(f"COPY failed: {e}")
            conn.rollback()
            return 0
        finally:
            cur.close()
    
    # ============================================================================
    # File Handling Methods
    # ============================================================================
    
    def decompress_file(self, file_path: Path) -> Path:
        """
        Decompress a file (GZ, BZ2, or ZIP)
        
        Args:
            file_path: Path to compressed file
            
        Returns:
            Path to decompressed file
        """
        suffix = file_path.suffix.lower()
        output_path = file_path.with_suffix('')
        
        # Skip if already decompressed
        if output_path.exists():
            return output_path
        
        try:
            if suffix == '.gz':
                with gzip.open(file_path, 'rb') as f_in:
                    with open(output_path, 'wb') as f_out:
                        f_out.write(f_in.read())
            
            elif suffix == '.bz2':
                with bz2.open(file_path, 'rb') as f_in:
                    with open(output_path, 'wb') as f_out:
                        f_out.write(f_in.read())
            
            elif suffix == '.zip':
                with zipfile.ZipFile(file_path, 'r') as zip_ref:
                    zip_ref.extractall(file_path.parent)
                    # Return first extracted file
                    output_path = file_path.parent / zip_ref.namelist()[0]
            
            else:
                # Not compressed, return as-is
                return file_path
            
            logger.info(f"Decompressed: {file_path.name}")
            return output_path
            
        except Exception as e:
            logger.error(f"Decompression failed for {file_path}: {e}")
            raise
    
    # ============================================================================
    # Main Import Workflow
    # ============================================================================
    
    def import_files(self, file_type: str = 'prices_full', 
                    limit: Optional[int] = None,
                    download_dir: Optional[Path] = None,
                    files: Optional[List[Any]] = None) -> Dict[str, int]:
        """
        Main import workflow
        
        Args:
            file_type: Type of files to import
            limit: Maximum number of files to process
            download_dir: Directory to save downloaded files
            files: Optional pre-fetched list of files
            
        Returns:
            Statistics dict
        """
        logger.info("=" * 80)
        logger.info(f"{self.chain_name} Import - {file_type}")
        logger.info("=" * 80)
        
        # Setup database
        self.ensure_chain_exists()
        
        # Fetch file list if not provided
        if files is None:
            logger.info(f"Fetching file list...")
            files = self.fetch_file_list(file_type=file_type, limit=limit)
            
        logger.info(f"Found {len(files)} files")
        
        if not files:
            logger.warning("No files to process")
            return {'files': 0, 'products': 0, 'prices': 0, 'skipped': 0, 'errors': 0}
        
        # Process files
        total_stats = {'files': 0, 'products': 0, 'prices': 0, 'skipped': 0, 'errors': 0}
        
        # Prepare for processing
        if self.tracker is None:
             try:
                 from file_processing_tracker import FileProcessingTracker
                 self.tracker = FileProcessingTracker(self.get_db_connection())
             except Exception as e:
                 logger.warning(f"Could not init tracker: {e}")

        # Ensure download_dir exists
        if not download_dir:
            download_dir = Path("data") / self.chain_slug
        download_dir.mkdir(parents=True, exist_ok=True)

        # 1. IDENTIFY FILES TO PROCESS
        files_to_process = []
        for file_meta in files:
            if self.tracker:
                if not self.tracker.should_process(file_meta.filename):
                    logger.info(f"Skipping {file_meta.filename} - already processed or processing")
                    continue
                # NEW: One-Pass Daily Per Store
                if not self.tracker.should_process_store_today(file_meta.filename, self.chain_name):
                    continue
            files_to_process.append(file_meta)
            
        if not files_to_process:
            logger.info("No new files to process")
            return total_stats

        logger.info(f"Prepare to process {len(files_to_process)} NEW files")
        
        # 2. PARALLEL DOWNLOADS (Batch of up to 5 concurrent)
        import concurrent.futures
        downloaded_files = {} # filename -> local_path
        
        # 2. PARALLEL PIPELINE (Download -> Process immediately)
        # Using a ThreadPoolExecutor for downloads. 
        # As soon as a download finishes, we process it in the main thread (blocking the main thread, 
        # but allowing background downloads to continue).
        
        # NOTE: Ideally we would use a ProcessPool for parsing, but that requires pickling large objects.
        # For now, "Download in Background, Process in Foreground" is a huge speedup (Overlap I/O).
        
        import concurrent.futures
        
        logger.info("Starting PIPELINED PROCESSING (Parallel Download + Sequential Process)...")
        
        # Start tracking for all files first (to lock them)
        file_log_ids = {}
        for f in files_to_process:
             if self.tracker:
                 file_log_ids[f.filename] = self.tracker.start_processing(f.filename, self.chain_name)

        # Execute downloads
        with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
            # Map future to file_meta
            future_to_file = {
                executor.submit(self.download_file, f, download_dir): f 
                for f in files_to_process
            }
            
            # Iterate AS THEY COMPLETE (Streaming)
            processed_count = 0
            for future in concurrent.futures.as_completed(future_to_file):
                f_meta = future_to_file[future]
                processed_count += 1
                log_id = file_log_ids.get(f_meta.filename)
                
                try:
                    # 1. Get Download Result
                    local_path = future.result()
                    if self.tracker and log_id:
                        self.tracker.update_status(log_id, 'downloaded')
                    logger.info(f"✓ Downloaded {f_meta.filename} ({processed_count}/{len(files_to_process)})")

                    # 2. Process IMMEDIATELY (While other downloads continue in background)
                    logger.info(f"⚡ Processing {f_meta.filename}...")
                    
                    # Decompress if needed
                    if self.tracker and log_id: self.tracker.update_status(log_id, 'extracting')
                    
                    fname = local_path.name.lower()
                    if fname.endswith('.gz') or fname.endswith('.bz2') or fname.endswith('.zip'):
                        local_path = self.decompress_file(local_path)

                    # Parse
                    if self.tracker and log_id: self.tracker.update_status(log_id, 'parsing')
                    metadata, products = self.parse_file(local_path)
                    logger.info(f"🔍 [{f_meta.filename}] Parsed {len(products)} products. Store: {metadata.get('store_id')}")
                    
                    # Store ID
                    store_id = None
                    if metadata.get('store_id'):
                        store_data = ParsedStore(
                            store_id=metadata['store_id'],
                            name=metadata.get('store_name', f"{self.chain_name} - Store {metadata['store_id']}"),
                            city=metadata.get('city'),
                            address=metadata.get('address'),
                            bikoret_no=metadata.get('bikoret_no')
                        )
                        store_id = self.get_or_create_store(store_data)
                    
                    # Import
                    if self.tracker and log_id: self.tracker.update_status(log_id, 'importing')
                    
                    file_stats = {'products': 0, 'prices': 0, 'skipped': 0}
                    for product in products:
                        stats = self.import_product(product, store_id)
                        file_stats['products'] += stats['products']
                        file_stats['prices'] += stats['prices']
                        file_stats['skipped'] += stats['skipped']
                        
                        total_stats['products'] += stats['products']
                        total_stats['prices'] += stats['prices']
                        total_stats['skipped'] += stats['skipped']
                    
                    total_stats['files'] += 1
                    logger.info(f"✓ Imported {len(products)} products from {f_meta.filename}")
                    
                    # Mark complete
                    if self.tracker and log_id: self.tracker.mark_completed(log_id, file_stats)
                    
                except Exception as e:
                    logger.error(f"Failed to process {f_meta.filename}: {e}")
                    total_stats['errors'] += 1
                    if self.tracker and log_id:
                         self.tracker.mark_failed(log_id, e)
        
        # ===== FLUSH FINAL BATCH =====
        if self.price_batch:
            final_inserted = self._flush_price_batch()
            total_stats['prices'] += final_inserted
            logger.info(f"✓ Final batch flush: {final_inserted} prices")
        
        # Summary
        logger.info("\n" + "=" * 80)
        logger.info("IMPORT SUMMARY")
        logger.info("=" * 80)
        logger.info(f"Files processed:  {total_stats['files']}")
        logger.info(f"Products created: {total_stats['products']}")
        logger.info(f"Prices imported:  {total_stats['prices']}")
        logger.info(f"Items skipped:    {total_stats['skipped']}")
        logger.info(f"Errors:           {total_stats['errors']}")
        logger.info("=" * 80)
        
        return total_stats
    
    def close(self):
        """Close database connection"""
        if self.conn and not self.conn.closed:
            self.conn.close()
            logger.info("Database connection closed")

    def run_full_import(self, limit=None):
        """
        Run full import workflow using the robust import_files method
        
        Args:
            limit: Maximum number of files to process
            
        Returns:
            Dict with success, products_count, prices_count
        """
        logger.info(f"Starting full import for {self.chain_name}")
        
        try:
            # Ensure chain exists
            self.ensure_chain_exists()
            
            # Fetch files
            # Note: We pass limit here to fetch_file_list, but import_files also takes limit.
            # Ideally fetch_file_list respects it.
            files = self.fetch_file_list(file_type='prices_full', limit=limit)
            
            if not files:
                logger.warning(f"No files found for {self.chain_name}")
                return {'success': False, 'message': 'No files found'}
            
            logger.info(f"Found {len(files)} files to process")
            
            # Delegate to import_files which handles tracking, downloading, decompression, and parsing
            stats = self.import_files(files=files)
            
            return {
                'success': True,
                'products_count': stats.get('products', 0),
                'prices_count': stats.get('prices', 0),
                'stats': stats
            }
            
        except Exception as e:
            logger.error(f"Import failed: {e}")
            return {'success': False, 'error': str(e)}

    def get_stores(self, limit: int = 5) -> List[ParsedStore]:
        """Convenience method to fetch, download and parse stores"""
        self.ensure_chain_exists()
        files = self.fetch_file_list(file_type='stores', limit=1)
        if not files:
            return []
        
        f = files[0]
        local_path = self.download_file(f)
        if not local_path:
            return []
            
        result = self.parse_file(local_path, f.file_type)
        if isinstance(result, tuple):
             return result[1]
        return result

    def get_prices(self, limit: int = 5) -> List[ParsedProduct]:
        """Convenience method to fetch, download and parse prices"""
        self.ensure_chain_exists()
        # Try full first, then partial
        files = self.fetch_file_list(file_type='prices_full', limit=1)
        if not files:
            files = self.fetch_file_list(file_type='prices', limit=1)
            
        if not files:
            return []
            
        f = files[0]
        local_path = self.download_file(f)
        if not local_path:
            return []
            
        result = self.parse_file(local_path, f.file_type)
        if isinstance(result, tuple):
             return result[1]
        return result
