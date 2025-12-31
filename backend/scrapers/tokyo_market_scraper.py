
import logging
import requests
import re
from bs4 import BeautifulSoup
from pathlib import Path
from typing import List, Dict, Tuple, Any, Optional
from datetime import datetime
import hashlib

from .base_supermarket_scraper import BaseSupermarketScraper, FileMetadata, ParsedProduct, ParsedStore

logger = logging.getLogger(__name__)

class TokyoMarketScraper(BaseSupermarketScraper):
    """
    Scraper for Tokyo Central Wholesale Market (Toyosu).
    Source: https://www.shijou-nippo.metro.tokyo.lg.jp/
    """
    
    BASE_URL = "https://www.shijou-nippo.metro.tokyo.lg.jp/SN"
    
    def __init__(self):
        super().__init__(
            chain_name='Tokyo Wholesale Market',
            chain_slug='tokyo_wholesale',
            chain_name_he='השוק הסיטונאי טוקיו',
            chain_id='JP_TOKYO_MARKET',
            country_code='JP'
        )
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }

    def fetch_file_list(self, file_type: str = 'prices', limit: Optional[int] = None) -> List[FileMetadata]:
        # We target "Today"
        now = datetime.now()
        yyyymm = now.strftime("%Y%m")
        yyyymmdd = now.strftime("%Y%m%d")
        
        # Categories: Sui (Fish), Sei (Veg/Fruit), Kak (Flower), Nik (Meat)
        # We start with Fish (Sui) and Veg (Sei)
        categories = ['Sui', 'Sei']
        files = []
        
        for cat in categories:
            # URL: .../202512/20251226/Sui/SN_Sui_Toyosu_index.html
            market = "Toyosu" # Main market
            # For Seika, check if Toyosu exists? Yes, Toyosu Market has both.
            
            url = f"{self.BASE_URL}/{yyyymm}/{yyyymmdd}/{cat}/SN_{cat}_{market}_index.html"
            filename = f"tokyo_{cat}_{market}_{yyyymmdd}.html"
            
            files.append(FileMetadata(
                url=url,
                filename=filename,
                file_type='html',
                size_bytes=0,
                store_id=f"TOKYO_{cat.upper()}_{market.upper()}"
            ))
            
        return files

    def download_file(self, file_metadata: FileMetadata, download_dir: Path) -> Optional[Path]:
        local_path = download_dir / file_metadata.filename
        try:
            logger.info(f"Downloading {file_metadata.url}")
            r = requests.get(file_metadata.url, headers=self.headers, timeout=30)
            if r.status_code == 404:
                 logger.warning(f"Data not found for URL (Holiday?): {file_metadata.url}")
                 return None
            r.raise_for_status()
            
            # Save raw content (encoding issues might arise if saved as utf-8 without conversion, 
            # but usually python write handles string. We decode shift_jis then write utf-8)
            r.encoding = r.apparent_encoding
            content = r.text
            
            with open(local_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            return local_path
        except Exception as e:
            logger.error(f"Failed to download {file_metadata.url}: {e}")
            return None

    def parse_file(self, file_path: Path) -> Tuple[Dict, List[ParsedProduct]]:
        """
        Parse HTML Tables.
        """
        logger.info(f"Parsing Tokyo Data: {file_path}")
        self.ensure_chain_exists()
        
        # Determine Category
        # tokyo_Sui_Toyosu_...
        try:
            cat = file_path.stem.split('_')[1]
        except:
            cat = "Unknown"
        
        # We Treat "Toyosu Market" as a single Store
        store_code = f"TOKYO_TOYOSU_MARKET"
        store = ParsedStore(
            store_id=store_code,
            name="Toyosu Market (Tokyo)",
            address="6-6-1 Toyosu, Koto City, Tokyo",
            city="Tokyo",
            latitude=35.646564,
            longitude=139.787640,
            attributes={'market_type': 'Wholesale'}
        )
        store_db_id = self.get_or_create_store(store)
        
        with open(file_path, 'r', encoding='utf-8') as f:
            html = f.read()
            
        soup = BeautifulSoup(html, 'html.parser')
        tables = soup.find_all('table')
        
        cnt_prices = 0
        seen_entries = set() # Deduplication set
        
        for tbl in tables:
            rows = tbl.find_all('tr')
            if not rows: continue
            
            # Check Headers to confirm it's a Price table
            # Must check all header rows (sometimes stacked)
            headers_text = ""
            for r in rows[:3]:
                headers_text += r.text
            
            if "高値" not in headers_text or "安値" not in headers_text:
                continue
                
            # Process Data Rows
            # Need to handle rowspan for Item Name
            last_item_name = ""
            
            # Find data start (skip headers)
            # Heuristic: Find row with number or "High/Mid/Low" data
            start_idx = 1
            # Usually row 0 is headers.
            
            for row in rows[start_idx:]:
                cells = row.find_all(['td', 'th'])
                if not cells: continue
                
                texts = [c.text.strip() for c in cells]
                # Filter empty rows
                if not any(texts): continue
                
                # Handling logic depends on columns count
                # Expected: [Name, TotalQty, Method, Qty, Origin, Brand, High, Mid, Low] (9 cols)
                # But if Name is rowspanned, first col might be missing in subsequent rows.
                
                # Check for item name
                # If row has class or style indicating sub-row?
                # or just count columns.
                
                current_item = last_item_name
                offset = 0
                
                # Heuristic: If col 0 looks like a number (Qty) or Method, then Name is omitted (continuation).
                # Item names are usually strings, not numbers.
                # Qty is usually numeric (with commas).
                
                # Toyosu table usually has 9 cols full.
                # If 8 cols, name might be missing.
                
                if len(texts) >= 9:
                    # Likely full row
                     candidate_name = texts[0]
                     # If candidate name is empty or "-", use last?
                     if candidate_name and candidate_name != "−":
                         current_item = candidate_name
                         last_item_name = current_item
                     offset = 0
                elif len(texts) < 9:
                    # Likely continuation
                    offset = 9 - len(texts) # e.g. if 8, offset 1 (Name missing)
                
                # Map columns (adjusting for offset)
                # 0: Name (if offset=0)
                # 1-offset: TotalQty
                # 2-offset: Method
                # 3-offset: Qty
                # 4-offset: Origin
                # 5-offset: Brand
                # 6-offset: High
                # 7-offset: Mid
                # 8-offset: Low
                
                try:
                    origin = texts[4-offset] if (4-offset) >= 0 else ""
                    brand = texts[5-offset] if (5-offset) >= 0 else ""
                    high_str = texts[6-offset] if (6-offset) >= 0 else ""
                    mid_str = texts[7-offset] if (7-offset) >= 0 else ""
                    low_str = texts[8-offset] if (8-offset) >= 0 else ""
                except:
                    continue
                
                # Parse Price
                # Prefer Mid, fall back to High or Low
                price = self._parse_price(mid_str)
                if not price:
                    price = self._parse_price(high_str)
                if not price:
                     price = self._parse_price(low_str)
                     
                if not price:
                    continue
                    
                # Create Product
                name_parts = [current_item]
                if brand and brand != "−": name_parts.append(brand)
                if origin and origin != "−": name_parts.append(f"({origin})")
                
                full_name = " ".join(name_parts)
                
                # Barcode: Generate stable ID from Name/Origin/Brand/Category
                slug = self._make_slug(full_name)
                barcode = f"JP_{cat}_{slug}"[:20] # Limit length
                
                # Deduplicate
                dedup_key = (store_db_id, barcode)
                if dedup_key in seen_entries:
                    continue
                seen_entries.add(dedup_key)
                
                p = ParsedProduct(
                    name=full_name,
                    barcode=barcode,
                    price=price,
                    attributes={
                        'currency': 'JPY',
                        'high_price': self._parse_price(high_str),
                        'low_price': self._parse_price(low_str),
                        'origin': origin,
                        'brand': brand,
                        'category_code': cat
                    }
                )
                
                self.import_product(p, store_id=store_db_id)
                cnt_prices += 1
                
        self._flush_price_batch()
        logger.info(f"Parsed {cnt_prices} prices.")
        return {"store_id": "TOKYO_DONE", "chain_id": self.chain_db_id}, []

    def _parse_price(self, p_str):
        if not p_str or p_str == "−": return 0.0
        # Remove commas
        clean = p_str.replace(',', '').replace('円', '').strip()
        try:
            return float(clean)
        except:
            return 0.0

    def _make_slug(self, text):
        # Very specific slugify for Japanese?
        # Just hash it to be safe and consistent
        import hashlib
        h = hashlib.md5(text.encode('utf-8')).hexdigest()[:10].upper()
        return h
