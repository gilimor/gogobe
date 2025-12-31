
import logging
import requests
import json
import re
from pathlib import Path
from typing import List, Dict, Tuple, Optional, Any
from datetime import datetime
from bs4 import BeautifulSoup

# Try relative import first (for scripts), then absolute (for package)
try:
    from .base_supermarket_scraper import BaseSupermarketScraper, FileMetadata, ParsedProduct, ParsedStore
except ImportError:
    from base_supermarket_scraper import BaseSupermarketScraper, FileMetadata, ParsedProduct, ParsedStore

logger = logging.getLogger(__name__)

class LKLtdScraper(BaseSupermarketScraper):
    """
    Scraper for L.K. LTD (lkltd.co.il)
    Uses their internal JSON API.
    """
    
    BASE_URL = "https://www.lkltd.co.il"
    API_URL = "https://www.lkltd.co.il/pages_products/search?languageid=1"
    
    def __init__(self):
        super().__init__(
            chain_name='L.K. Ltd',
            chain_slug='lkltd',
            chain_name_he='ל.כ. בע"מ',
            chain_id='LKLTD001', # Custom ID
            country_code='IL'
        )
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'X-Requested-With': 'XMLHttpRequest',
            'Content-Type': 'application/json;charset=UTF-8',
            'Referer': self.BASE_URL
        })

    def fetch_file_list(self, file_type: str = 'prices', limit: Optional[int] = None) -> List[FileMetadata]:
        """
        Discover categories to scrape.
        Returns 'Virtual Files' where each file represents a Category.
        """
        files = []
        
        # 1. Fetch Homepage to get Categories
        # We look for links in the main menu
        try:
            logger.info("Fetching categories from homepage...")
            # Use a fresh session for the homepage to get cookies
            hp_session = requests.Session()
            hp_session.headers.update({'User-Agent': self.session.headers['User-Agent']})
            res = hp_session.get(self.BASE_URL, timeout=30)
            
            # Copy cookies to main session
            self.session.cookies.update(hp_session.cookies)
            
            soup = BeautifulSoup(res.content, 'html.parser')
            
            # Find category links (usually in a specific menu container)
            # Based on inspection: links with class that looks like menu items
            # or just all links under the side menu wrapper
            category_links = []
            
            # Selector for sidebar menu
            links = soup.select('a.cats_menu_list_main_link, a.cats_menu_list_sub_link')
            
            # If no links found via specific class, try broader search in the right container (usually sidebar)
            if not links:
                sidebar = soup.select_one('.right_content_inner, .right_menu, #right_menu')
                if sidebar:
                     links = sidebar.find_all('a', href=True)
            
            # Fallback List (Hardcoded Main Categories)
            fallback_urls = [
                f"{self.BASE_URL}/כלי-עבודה-ידניים-כלי-יד", # Hand Tools
                f"{self.BASE_URL}/כלי-עבודה-חשמליים",     # Power Tools
                f"{self.BASE_URL}/ציוד-קמפינג-ושטח"         # Camping
            ]
            
            # Add hardcoded fallback if automatic discovery is weak
            if len(links) < 5:
                logger.info("Automatic discovery weak, adding fallback categories")
                for fb in fallback_urls:
                    # Create dummy tag object to reuse logic
                    dummy = soup.new_tag('a', href=fb)
                    dummy.string = fb.split('/')[-1]
                    links.append(dummy)

            seen_ids = set()
            
            for a in links:
                href = a.get('href', '')
                if not href: continue
                
                # Normalize URL
                if href.startswith('http'):
                    full_url = href
                else:
                    full_url = self.BASE_URL + href if href.startswith('/') else f"{self.BASE_URL}/{href}"
                
                # Filter out obvious non-category pages
                if any(x in full_url for x in ['login', 'register', 'contact', 'cart', 'about', 'takanon', 'הרשמה', 'יצירת-קשר']):
                    continue
                    
                # Setup filename
                name = a.get_text(strip=True)
                if not name:
                     name = href.split('/')[-1]
                     
                safe_name = re.sub(r'[\\/*?:"<>|]', "", name)
                if not safe_name: safe_name = "Category"
                
                virtual_filename = f"LKLtd_{safe_name}_{datetime.now().strftime('%Y%m%d')}.json"
                
                if full_url in seen_ids: continue
                seen_ids.add(full_url)
                
                files.append(FileMetadata(
                    url=full_url,
                    filename=virtual_filename,
                    file_type=file_type,
                    store_id="ONLINE",
                    size_bytes=0
                ))
                
                if limit and len(files) >= limit:
                    break
            
            logger.info(f"Found {len(files)} potential categories")
            
        except Exception as e:
            logger.error(f"Failed to fetch category list: {e}")
            
        return files

    def download_file(self, file_meta: FileMetadata, download_dir: Path) -> Path:
        """
        'Download' a category by scraping its API
        """
        output_path = download_dir / file_meta.filename
        if output_path.exists():
            return output_path

        logger.info(f"Scraping category: {file_meta.url}")
        
        all_products = []
        
        try:
            # 1. Get PageID from the HTML page
            res = self.session.get(file_meta.url, timeout=30)
            if res.status_code != 200:
                logger.warning(f"Failed to load page {file_meta.url}: {res.status_code}")
                return output_path # Return empty or fail?
            
            # Extract PageID (Category ID)
            # Methods found by deep inspection:
            # 1. var G_PageID='46691'
            # 2. <img data-pageid="46691">
            # 3. ng-init="...start(46691)..."
            
            page_id = None
            text = res.text
            
            # Method 1: G_PageID (Most reliable)
            match = re.search(r"var G_PageID\s*=\s*'(\d+)'", text)
            if match:
                page_id = int(match.group(1))
            
            if not page_id:
                # Method 2: data-pageid attribute
                soup = BeautifulSoup(res.content, 'html.parser')
                elem = soup.find(attrs={"data-pageid": True})
                if elem:
                    val = elem["data-pageid"]
                    if val and val.isdigit():
                        page_id = int(val)
            
            if not page_id:
                # Method 3: start(ID) in ng-init or script
                match = re.search(r"start\s*\(\s*(\d+)\s*\)", text)
                if match:
                    page_id = int(match.group(1))
            
            if not page_id:
                # Method 4: Generic pageid regex
                match = re.search(r'pageid["\s:]+([0-9]+)', text, re.IGNORECASE)
                if match:
                    page_id = int(match.group(1))
            
            if not page_id:
                logger.warning(f"Could not find PageID for {file_meta.url}")
                # Create empty file to avoid re-scrape
                with open(output_path, 'w', encoding='utf-8') as f:
                    json.dump([], f)
                return output_path

            logger.info(f"Found PageID: {page_id}")
            
            # 2. Iterate pages via API
            page_num = 1
            batch_size = 36
            
            while True:
                payload = {
                    "brands": [],
                    "pages": [],
                    "AndPages": {"One": [], "Two": [], "Three": []},
                    "features": [],
                    "Qwerys": [],
                    "pageid": page_id,
                    "tagid": [],
                    "pagenumber": page_num,
                    "top": batch_size
                }
                
                api_res = self.session.post(self.API_URL, json=payload, timeout=30)
                
                if api_res.status_code != 200:
                    logger.warning(f"API Error page {page_num}: {api_res.status_code}")
                    break
                    
                data = api_res.json()
                
                if not data or not isinstance(data, list):
                    break
                    
                logger.info(f"Fetched page {page_num}: {len(data)} items")
                all_products.extend(data)
                
                if len(data) < batch_size:
                    break # Last page
                    
                page_num += 1
                # Safety break
                if page_num > 50: break

            # Save to JSON
            with open(output_path, 'w', encoding='utf-8') as f:
                json.dump(all_products, f, indent=2, ensure_ascii=False)
                
        except Exception as e:
            logger.error(f"Failed to scrape category {file_meta.url}: {e}")
            # Save empty on error to handle "done" state
            if not output_path.exists():
                 with open(output_path, 'w', encoding='utf-8') as f:
                    json.dump([], f)
                    
        return output_path

    def parse_file(self, file_path: Path) -> Tuple[Dict, List[ParsedProduct]]:
        """
        Parse the JSON file from the API
        """
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        products = []
        for item in data:
            try:
                # Structure based on subagent findings:
                # {
                #   "id": 47251,
                #   "itemcode": "1020501",
                #   "name": "...",
                #   "image1": "...",
                #   "prod": [{ "price": 207, "vatprice": 207, "stock": 126 }]
                # }
                
                price = None
                if item.get('prod') and len(item['prod']) > 0:
                    sku_data = item['prod'][0]
                    price = sku_data.get('vatprice') or sku_data.get('price')
                
                # Skip if price is effectively zero or missing, UNLESS we want to catalog it
                # For now, let's include it but price might be None
                
                p = ParsedProduct(
                    name=item.get('name'),
                    barcode=item.get('itemcode'), # Using itemcode as barcode/sku
                    manufacturer=None, # Not explicitly in basic data
                    price=float(price) if price else 0.0,
                    is_weighted=False,
                    attributes={
                        'internal_id': item.get('id'),
                        'image_url': f"{self.BASE_URL}{item.get('image1')}" if item.get('image1') else None,
                        'url': f"{self.BASE_URL}{item.get('urlpath')}" if item.get('urlpath') else None
                    }
                )
                products.append(p)
                
            except Exception as e:
                logger.warning(f"Failed to parse item: {e}")
                
        metadata = {
            "store_id": "LKLTD_ONLINE",
            "store_name": "L.K. Ltd Online",
            "chain_id": self.chain_id
        }
        
        return metadata, products
