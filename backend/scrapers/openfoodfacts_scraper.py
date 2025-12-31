
import logging
import gzip
import json
import requests
from pathlib import Path
from typing import List, Dict, Tuple, Optional, Any
from datetime import datetime

from .base_supermarket_scraper import BaseSupermarketScraper, FileMetadata, ParsedProduct

logger = logging.getLogger(__name__)

class OpenFoodFactsScraper(BaseSupermarketScraper):
    """
    Open Food Facts (OFF) Scraper
    
    Downloads the daily JSONL dump from Open Food Facts.
    This source is used primarily for PRODUCT DISCOVERY and ENRICHMENT, not price comparison.
    
    URL: https://static.openfoodfacts.org/data/openfoodfacts-products.jsonl.gz
    """
    
    DUMP_URL = "https://static.openfoodfacts.org/data/openfoodfacts-products.jsonl.gz"
    
    def __init__(self):
        super().__init__(
            chain_name='Open Food Facts',
            chain_slug='openfoodfacts',
            chain_name_he='Open Food Facts',
            chain_id='OFF_GLOBAL',
            country_code='GLOBAL'
        )

    def fetch_file_list(self, file_type: str = 'products', limit: Optional[int] = None) -> List[FileMetadata]:
        """
        Returns the single massive daily dump file.
        """
        # We use today's date to generate a unique filename for the day
        today_str = datetime.now().strftime('%Y%m%d')
        filename = f"openfoodfacts-products-{today_str}.jsonl.gz"
        
        return [FileMetadata(
            url=self.DUMP_URL,
            filename=filename,
            file_type=file_type,
            store_id="GLOBAL",
            size_bytes=None # Unknown until download
        )]

    def parse_file(self, file_path: Path) -> Tuple[Dict, List[ParsedProduct]]:
        """
        Parses the JSONL.GZ file.
        
        NOTE: This file is HUGE (GBs). We must handle it carefully.
        For the purpose of this project, we might want to filter:
        1. Only products with '729' prefix (Israel)? Or global?
        2. Or we just stream it all.
        
        For now, let's process it as a stream.
        """
        products = []
        
        # Metadata
        metadata = {
            "store_id": "OFF_GLOBAL",
            "store_name": "Open Food Facts Global",
            "chain_id": self.chain_id
        }
        
        # We need to be careful not to explode memory.
        # But BaseSupermarketScraper expects a list of ParsedProduct returned.
        # Ideally, we'd yield, but the base class expects a return.
        # Solution: We will return a partial list (limiting to first N for safety in this version)
        # OR we modify the base class to support generators (too risky now).
        # Let's limit to 5000 items for this POC to avoid crashing the server.
        # In a real heavy-duty version, we'd use a different pipeline.
        
        LIMIT = 5000
        count = 0
        
        try:
            with gzip.open(file_path, 'rt', encoding='utf-8') as f:
                for line in f:
                    if count >= LIMIT:
                        break
                        
                    try:
                        data = json.loads(line)
                        
                        # Extract key fields
                        code = data.get('code', '')
                        if not code:
                            continue
                            
                        # Optional: Filter for Israeli products if desired
                        # if not code.startswith('729'): continue 
                        
                        product_name = data.get('product_name', '') or data.get('product_name_en', '')
                        if not product_name:
                            continue
                            
                        p = ParsedProduct(
                            name=product_name,
                            barcode=code,
                            manufacturer=data.get('brands', ''),
                            price=0.0, # No price in OFF
                            is_weighted=False,
                            attributes={
                                'nutriscore': data.get('nutriscore_grade'),
                                'image_url': data.get('image_url'),
                                'categories': data.get('categories')
                            }
                        )
                        products.append(p)
                        count += 1
                        
                    except json.JSONDecodeError:
                        continue
                        
        except Exception as e:
            logger.error(f"Error parsing OFF dump: {e}")
            
        logger.info(f"Parses {len(products)} products from Open Food Facts dump (Limited to {LIMIT})")
        return metadata, products
