#!/usr/bin/env python3
"""
PublishedPrices Platform Scraper
Generic scraper for chains using the publishedprices.co.il platform
(Rami Levy, Osher Ad, Yohananof, Tiv Taam, etc.)
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


class PublishedPricesScraper(BaseSupermarketScraper):
    """
    Scraper for chains hosted on url.publishedprices.co.il
    """
    
    def __init__(self, chain_name: str, chain_slug: str, chain_name_he: str, 
                 chain_id: str, platform_user: str, platform_pass: str = "",
                 base_domain: str = "url.publishedprices.co.il"):
        super().__init__(
            chain_name=chain_name,
            chain_slug=chain_slug,
            chain_name_he=chain_name_he,
            chain_id=chain_id
        )
        self.platform_user = platform_user
        self.platform_pass = platform_pass
        self.base_url = f"https://{base_domain}"
        self.session = requests.Session()
        self.session.cookies.clear() # Ensure clean state
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        })

    def login(self) -> bool:
        """Login to the platform"""
        logger.info(f"Logging in to {self.base_url} as {self.platform_user}")
        try:
            # First get the login page to get CSRF tokens
            login_url = f"{self.base_url}/login"
            
            # Initial headers for the GET request
            self.session.headers.update({
                'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
                'Accept-Language': 'he-IL,he;q=0.9,en-US;q=0.8,en;q=0.7',
                'Connection': 'keep-alive',
                'Upgrade-Insecure-Requests': '1',
                'Sec-Ch-Ua': '"Not/A)Brand";v="99", "Google Chrome";v="115", "Chromium";v="115"',
                'Sec-Ch-Ua-Mobile': '?0',
                'Sec-Ch-Ua-Platform': '"Windows"',
                'Sec-Fetch-Dest': 'document',
                'Sec-Fetch-Mode': 'navigate',
                'Sec-Fetch-Site': 'none',
                'Sec-Fetch-User': '?1'
            })
            
            response = self.session.get(login_url, timeout=30, verify=False)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Extract CSRF token if present
            # Strategy 1: Look for meta tag (seen in login_fail.html)
            csrf_token = None
            meta_csrf = soup.find('meta', attrs={'name': 'csrftoken'})
            if meta_csrf:
                csrf_token = meta_csrf.get('content')
                logger.debug(f"Found CSRF token in meta tag: {csrf_token}")
            
            # Strategy 2: Look for input field if meta tag not found
            if not csrf_token:
                csrf_input = soup.find('input', attrs={'name': re.compile(r'csrf|token|__RequestVerificationToken', re.I)})
                if csrf_input:
                    csrf_token = csrf_input.get('value')
                    logger.debug(f"Found CSRF token in input field: {csrf_token}")

            # Post credentials
            # Note: For Rami Levy, password can be empty
            data = {
                'username': self.platform_user,
                'password': self.platform_pass if self.platform_pass else ""
            }
            
            # If we found a CSRF token, we need to know what field name to send it as.
            # Usually it's in a hidden input. If we found it in a meta tag, we might need to guess the field name 
            # OR logic dictates if it's in meta, it might be a header.
            # But looking at form inspection, there might be hidden inputs we missed or the server expects it in header.
            # Let's try adding it to data if we found an input, or header if meta.
            
            if csrf_token and not meta_csrf and csrf_input:
                 data[csrf_input.get('name')] = csrf_token
            
            # IMPORTANT: The HTML inspection showed a hidden input check? 
            # Actually browsersubagent found: name='csrftoken' (Contains a CSRF security token)
            # So likely we need to send 'csrftoken': token in body OR cookie.
            # Let's try sending it as a cookie too if it's not already there.
            
            if csrf_token:
                self.session.cookies.set('csrftoken', csrf_token)
                # Also try sending as data just in case
                data['csrftoken'] = csrf_token

            # Update headers for login POST
            headers = {
                'Origin': self.base_url,
                'Referer': login_url,
                'Content-Type': 'application/x-www-form-urlencoded',
                'Cache-Control': 'max-age=0',
                'Sec-Fetch-Dest': 'document',
                'Sec-Fetch-Mode': 'navigate',
                'Sec-Fetch-Site': 'same-origin',
                'Sec-Fetch-User': '?1',
                'Upgrade-Insecure-Requests': '1',
                 'User-Agent': self.session.headers['User-Agent']
            }
            
            # Add X-CSRFToken header if we have one (common pattern)
            if csrf_token:
                headers['X-CSRFToken'] = csrf_token

            # IMPORTANT: The form action is /login/user, not /login
            post_url = f"{self.base_url}/login/user"
            post_response = self.session.post(post_url, data=data, headers=headers, timeout=30, verify=False, allow_redirects=True)
            post_response.raise_for_status()
            
            # Store CSRF token for subsequent requests BEFORE checking login success
            if csrf_token:
                self.csrf_token = csrf_token
                logger.debug(f"Stored CSRF token for future requests")
            
            # Check if login worked - usually it redirects to /file or similar
            # If we are redirected to /, it means success (File Manager)
            if post_response.url.strip('/') == self.base_url.strip('/') or "/file" in post_response.url:
                 logger.info("Login successful - Redirected to root/file page")
                 
                 # Get a fresh CSRF token from the /file page for API requests
                 file_response = self.session.get(f"{self.base_url}/file", timeout=30, verify=False)
                 if file_response.status_code == 200:
                     file_soup = BeautifulSoup(file_response.content, 'html.parser')
                     file_csrf_meta = file_soup.find('meta', {'name': 'csrftoken'})
                     if file_csrf_meta:
                         fresh_token = file_csrf_meta.get('content')
                         if fresh_token:
                             self.csrf_token = fresh_token
                             # Remove ALL old csrftoken cookies to avoid duplicates
                             for cookie in list(self.session.cookies):
                                 if cookie.name == 'csrftoken':
                                     self.session.cookies.clear(cookie.domain, cookie.path, cookie.name)
                             self.session.cookies.set('csrftoken', fresh_token, domain='url.publishedprices.co.il', path='/')
                             logger.info(f"Updated CSRF token from /file page")
                 
                 return True

            if "login" in post_response.url.lower() and post_response.status_code != 302:
                # Still on login page, try visiting /file directly to see if session is active
                test_response = self.session.get(f"{self.base_url}/file", timeout=30, verify=False)
                if test_response.status_code == 200 and "login" not in test_response.url.lower():
                    logger.info("Login verified (session active via /file)")
                    
                    # Get CSRF token from the file page
                    file_soup = BeautifulSoup(test_response.content, 'html.parser')
                    file_csrf_meta = file_soup.find('meta', {'name': 'csrftoken'})
                    if file_csrf_meta:
                        fresh_token = file_csrf_meta.get('content')
                        if fresh_token:
                            self.csrf_token = fresh_token
                            # Remove ALL old csrftoken cookies to avoid duplicates
                            for cookie in list(self.session.cookies):
                                if cookie.name == 'csrftoken':
                                    self.session.cookies.clear(cookie.domain, cookie.path, cookie.name)
                            self.session.cookies.set('csrftoken', fresh_token, domain='url.publishedprices.co.il', path='/')
                            logger.info(f"Updated CSRF token from /file page")
                    
                    return True
                
                # Try to detect if there is an error message
                error_div = soup.find('div', class_='validation-summary-errors')
                if error_div:
                     logger.error(f"Login failed message: {error_div.get_text(strip=True)}")
                
                logger.error(f"Login failed (still on login page or redirected back to {post_response.url})")
                return False
                
            logger.info(f"Login successful - Redirected to: {post_response.url}")
            return True

        except Exception as e:
            logger.error(f"Login error: {e}")
            import traceback
            logger.error(traceback.format_exc())
            return False

    def fetch_file_list(self, file_type: str = 'prices_full', 
                       limit: Optional[int] = None) -> List[FileMetadata]:
        """Fetch available files from the server using JSON API"""
        # Recursively fetch multiple types if 'all' is requested
        if file_type == 'all':
            all_files = []
            # Priority: Stores first, then Prices
            for ftype in ['stores', 'prices_full']:
                try:
                    # Distribute limit if exists (e.g., 50% stores, 50% prices)
                    sub_limit = limit // 2 if limit else None
                    files = self.fetch_file_list(file_type=ftype, limit=sub_limit)
                    all_files.extend(files)
                except Exception as e:
                    logger.warning(f"Failed to fetch {ftype}: {e}")
            return all_files

        if not self.login():
            return []
            
        # API Endpoint
        api_url = f"{self.base_url}/file/json/dir"
        
        # Strategy: Use the session directly after login.
        # Ensure X-CSRFToken matches the cookie.
        
        try:
            # Sync: Get the current cookie value
            cookie_token = self.session.cookies.get('csrftoken')
            
            # Use the most recent token we have
            token_to_use = cookie_token if cookie_token else (getattr(self, 'csrf_token', None))
            
            # Map gogobe file types to platform naming conventions
            pattern_map = {
                'prices_full': r'^PriceFull',
                'prices': r'^Price\d', # Price729... but not PriceFull
                'stores': r'^Stores',
                'promos': r'^Promo'
            }
            pattern = pattern_map.get(file_type, r'^Price')
            
            # Payload
            payload = {
                'cd': '/',
                'iDisplayLength': 1000,
                'sEcho': 1
            }
            
            # Headers - Mimic Modern Browser (Chrome 120+)
            # Often missing Sec-Fetch headers cause CSRF failures in strict environments
            headers = {
                 'Accept': 'application/json, text/javascript, */*; q=0.01',
                 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                 'X-Requested-With': 'XMLHttpRequest',
                 'Referer': f"{self.base_url}/file",
                 'Origin': self.base_url,
                 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                 'Sec-Ch-Ua': '"Not_A Brand";v="8", "Chromium";v="120", "Google Chrome";v="120"',
                 'Sec-Ch-Ua-Mobile': '?0',
                 'Sec-Ch-Ua-Platform': '"Windows"',
                 'Sec-Fetch-Dest': 'empty',
                 'Sec-Fetch-Mode': 'cors',
                 'Sec-Fetch-Site': 'same-origin'
            }
            
            # Add CSRF token to headers if we have one
            if token_to_use:
                headers['X-CSRFToken'] = token_to_use
                headers['X-XSRF-TOKEN'] = token_to_use # Some frameworks check this
                headers['Csrf-Token'] = token_to_use
                # Also add to payload
                payload['csrfmiddlewaretoken'] = token_to_use # Django default
                payload['csrftoken'] = token_to_use 
                logger.debug(f"Using CSRF token: {token_to_use[:20]}...")
            
            logger.debug(f"API request to: {api_url}")
            logger.debug(f"Cookies: {list(self.session.cookies.keys())}")
            
            response = self.session.post(api_url, data=payload, headers=headers, timeout=30, verify=False)
            
            # Check for success
            data = {}
            if response.status_code == 200:
                try:
                    data = response.json()
                except:
                    data = {}
                    
                if 'error' in data:
                     logger.warning(f"API Error: {data['error']}")
            
            # FALLBACK: If API failed or returned 0 items, try Brute Force Discovery
            files = []
            
            if response.status_code != 200 or 'error' in data or not data.get('aaData'):
                logger.warning(f"API failed to list files for {file_type}. Attempting Fallback.")
                
                import datetime
                now = datetime.datetime.now()
                
                # Determine file prefix based on type
                if file_type == 'stores':
                    file_prefix = "Stores"
                    # Stores files don't have store numbers, just: Stores{chain_id}-{datetime}.gz
                    # Check last 3 days
                    for d in range(3):
                        check_time = now - datetime.timedelta(days=d)
                        date_str = check_time.strftime("%Y%m%d")
                        
                        # Try ALL hours for current day, and key hours for previous days
                        if d == 0:
                            hours_to_try = [f"{h:02d}00" for h in range(24)]
                        else:
                            # For previous days, check likely upload times
                            hours_to_try = ['0000', '0100', '0200', '0300', '0400', '0500', '0600', '0700', '0800', '0900', '1900', '2000', '2100']

                        for hour in hours_to_try:
                            filename = f"{file_prefix}{self.chain_id}-{date_str}{hour}.gz"
                            file_url = f"{self.base_url}/file/d/{filename}"
                            try:
                                check_resp = self.session.get(file_url, verify=False, timeout=5, allow_redirects=False, stream=True)
                                if check_resp.status_code == 200:
                                    logger.info(f"[Fallback] Found file: {filename}")
                                    files.append(FileMetadata(url=file_url, filename=filename, file_type=file_type))
                                    check_resp.close()
                                    if limit and len(files) >= limit: break
                            except: pass
                        if limit and len(files) >= limit: break
                        
                elif file_type in ['prices', 'prices_full']:
                    # Price files: Price{chain_id}-{store}-{datetime}.gz
                    common_hours = ['0600', '0900'] # Reduced set for fallback
                    for d in range(1): # Only today
                        date_str = now.strftime("%Y%m%d")
                        for hour in common_hours:
                            time_str = f"{date_str}{hour}"
                            stores_to_check = [f"{i:03d}" for i in range(1, 20)] # Check first 20 stores
                            for store in stores_to_check:
                                filename = f"Price{self.chain_id}-{store}-{time_str}.gz"
                                file_url = f"{self.base_url}/file/d/{filename}"
                                try:
                                    check_resp = self.session.get(file_url, verify=False, timeout=5, allow_redirects=False, stream=True)
                                    if check_resp.status_code == 200:
                                        logger.info(f"[Fallback] Found file: {filename}")
                                        files.append(FileMetadata(url=file_url, filename=filename, file_type=file_type))
                                        check_resp.close()
                                        if limit and len(files) >= limit: break
                                except: pass
                                if limit and len(files) >= limit: break
                            if limit and len(files) >= limit: break

            # Process API listing if it worked
            if 'aaData' in data:
                logger.info(f"API returned {len(data['aaData'])} items")
                for item in data['aaData']:
                    raw_name = item.get('fname', '') or item.get('name', '')
                    if '<a' in raw_name:
                         match = re.search(r'>([^<]+)</a>', raw_name)
                         filename = match.group(1).strip() if match else raw_name
                    else:
                        filename = raw_name
                    
                    filename = filename.replace('&nbsp;', '').strip()
                    
                    if "NULL" in filename: continue

                    if re.match(pattern, filename):
                        file_url = f"{self.base_url}/file/d/{filename}"
                        files.append(FileMetadata(
                            url=file_url,
                            filename=filename,
                            file_type=file_type
                        ))
            
            files.sort(key=lambda x: x.filename, reverse=True)
            if limit: files = files[:limit]
            
            logger.info(f"Found {len(files)} matching files for {file_type}")
            return files
            
        except Exception as e:
            logger.error(f"Failed to fetch file list: {e}")
            import traceback
            logger.error(traceback.format_exc())
            return []

    def download_file(self, file_meta: FileMetadata, download_dir: Path = None) -> Path:
        """Download a specific file"""
        if download_dir is None:
             import tempfile
             download_dir = Path(tempfile.gettempdir())
             
        output_path = download_dir / file_meta.filename
        
        if output_path.exists():
            logger.info(f"File already exists: {file_meta.filename}")
            return output_path
            
        logger.info(f"Downloading {file_meta.filename}...")
        logger.debug(f"Download URL: {file_meta.url}")
        try:
            response = self.session.get(file_meta.url, stream=True, timeout=60, verify=False, allow_redirects=True)
            logger.debug(f"Response status: {response.status_code}, URL after redirects: {response.url}")
            
            # Check if we were redirected to login page
            if 'login' in response.url.lower():
                logger.error("Session expired - redirected to login page")
                # Try to re-login
                if self.login():
                    logger.info("Re-logged in, retrying download...")
                    response = self.session.get(file_meta.url, stream=True, timeout=60, verify=False, allow_redirects=True)
                else:
                    raise Exception("Failed to re-login")
            
            response.raise_for_status()
            
            with open(output_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
                    
            logger.info(f"Downloaded: {file_meta.filename}")
            return output_path
        except Exception as e:
            logger.error(f"Download failed: {e}")
            raise

    def parse_file(self, file_path: Path, file_type: str = "") -> Tuple[Dict[str, Any], List[ParsedProduct]]:
        """Parse the supermarket XML file (Prices or Stores)"""
        try:
            # XML parsing logic (common across most Israeli chains)
            tree = ET.parse(file_path)
            root = tree.getroot()
            
            # Detect file type by root element or filename
            filename = file_path.name.lower()
            is_stores_file = 'stores' in filename or root.tag == 'Stores' or root.find('Store') is not None
            
            if is_stores_file:
                # Parse Stores file
                return self._parse_stores_file(root)
            else:
                # Parse Prices file
                return self._parse_prices_file(root)
                
        except Exception as e:
            logger.error(f"Failed to parse XML {file_path}: {e}")
            return {}, []
    
    def _parse_stores_file(self, root) -> Tuple[Dict[str, Any], List[ParsedProduct]]:
        """Parse Stores XML file"""
        
        # Helper to get text case-insensitive
        def get_text(elem, tags):
            for tag in tags:
                val = elem.findtext(tag)
                if val: return val
                # Try uppercase too
                val = elem.findtext(tag.upper())
                if val: return val
            return None

        # Helper to deep find all Store tags
        def find_stores(elem):
            stores = []
            # Check direct children
            for child in elem:
                if child.tag == 'Store' or child.tag == 'STORE':
                     stores.append(child)
                else:
                     stores.extend(find_stores(child))
            return stores

        # Find all Store elements recursively
        store_nodes = find_stores(root)
        logger.info(f"   Found {len(store_nodes)} store nodes in XML (Deep Search)")

        count = 0 
        all_parsed_stores = [] 
        for store_elem in store_nodes:
            store_id = get_text(store_elem, ['StoreId', 'StoreID', 'STOREID'])
            if not store_id:
                continue
            
            # Extract store information
            store_name = get_text(store_elem, ['StoreName', 'STORENAME', 'Name'])
            address = get_text(store_elem, ['Address', 'ADDRESS'])
            city = get_text(store_elem, ['City', 'CITY'])
            bikoret_no = get_text(store_elem, ['BikoretNo', 'BIKORETNO'])
            
            # Create ParsedStore object
            from scrapers.base_supermarket_scraper import ParsedStore
            store = ParsedStore(
                store_id=store_id,
                name=store_name or f"{self.chain_name} - {city}" if city else f"{self.chain_name} - Store {store_id}",
                city=city,
                address=address,
                bikoret_no=bikoret_no
            )
            
            # Accumulate parsed stores
            all_parsed_stores.append(store)
            
            # Ensure chain exists before trying to save
            if not getattr(self, 'chain_db_id', None):
                try:
                    self.ensure_chain_exists()
                except Exception as e:
                    logger.warning(f"Could not ensure chain context: {e}")

            # Import store to database (Best Effort)
            try:
                store_db_id = self.get_or_create_store(store)
                if store_db_id:
                    count += 1
                    logger.info(f"✓ Imported store: {store.name} (ID: {store_id})")
            except Exception as e:
                logger.error(f"DB Save failed for {store_id}: {e}")
        
        logger.info(f"Total stores imported: {count}")
        return {'file_type': 'stores'}, all_parsed_stores
    
    def _parse_prices_file(self, root) -> Tuple[Dict[str, Any], List[ParsedProduct]]:
        """Parse Prices XML file"""
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
            # Handle different field names used by various vendors
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

if __name__ == "__main__":
    # Import Rami Levy
    scraper = PublishedPricesScraper(
        chain_name="Rami Levy",
        chain_slug="rami_levy",
        chain_name_he="רמי לוי",
        chain_id="7290058140886",
        platform_user="RamiLevi",
        platform_pass=""  # Empty password as requested
    )
    
    # First import Stores to get store information (name, address, city)
    logger.info("="*80)
    logger.info("Step 1: Importing Stores files...")
    logger.info("="*80)
    stats_stores = scraper.import_files(file_type='stores', limit=5, download_dir=None)
    logger.info(f"Stores import completed: {stats_stores}")
    
    # Then import Prices
    logger.info("\n" + "="*80)
    logger.info("Step 2: Importing Prices files...")
    logger.info("="*80)
    stats_prices = scraper.import_files(file_type='prices', limit=50, download_dir=None)
    logger.info(f"Prices import completed: {stats_prices}")
    
    # Summary
    logger.info("\n" + "="*80)
    logger.info("FINAL SUMMARY")
    logger.info("="*80)
    logger.info(f"Stores: {stats_stores}")
    logger.info(f"Prices: {stats_prices}")
    logger.info("="*80)
    
    # scraper.close() # Base class doesn't have close, removed to avoid error
