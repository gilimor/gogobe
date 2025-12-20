"""
KingStore Full Scraper - Advanced multi-store price management
Downloads ALL files from KingStore and manages them with proper tracking
"""

import sys
import os
from pathlib import Path
from datetime import datetime
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from bs4 import BeautifulSoup
import time
import hashlib
import zipfile
import gzip
import shutil
import xml.etree.ElementTree as ET
import re
import json

# Add backend to path
backend_path = Path(__file__).parent.parent
sys.path.insert(0, str(backend_path))

from database.db_connection import get_db_connection


class KingStoreFullScraper:
    def __init__(self, download_limit=None, file_types=None):
        """
        Initialize scraper
        
        Args:
            download_limit: Maximum number of files to download (None = all)
            file_types: List of file types to download (e.g., ['Prices', 'PricesFull'])
        """
        self.base_url = "https://kingstore.binaprojects.com/Main.aspx"
        self.driver = None
        self.download_dir = Path("backend/data/kingstore")
        self.download_dir.mkdir(parents=True, exist_ok=True)
        
        self.download_limit = download_limit
        self.file_types = file_types or ['Prices', 'PricesFull', 'Promos', 'PromosFull']
        
        self.session_id = None
        self.price_source_id = None
        self.stats = {
            'files_found': 0,
            'files_downloaded': 0,
            'files_skipped': 0,
            'files_processed': 0,
            'files_failed': 0,
            'total_products': 0,
            'total_prices': 0
        }
        
    def setup_driver(self):
        """Setup Chrome WebDriver"""
        print("[INFO] Setting up Chrome WebDriver...")
        
        # Ensure download directory exists
        self.download_dir.mkdir(parents=True, exist_ok=True)
        print(f"[INFO] Download directory: {self.download_dir.absolute()}")
        
        chrome_options = Options()
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--disable-blink-features=AutomationControlled")
        chrome_options.add_argument("--log-level=3")
        
        # Configure auto-download
        prefs = {
            "download.default_directory": str(self.download_dir.absolute()),
            "download.prompt_for_download": False,
            "download.directory_upgrade": True,
            "safebrowsing.enabled": False,
            "safebrowsing.disable_download_protection": True,
            "profile.default_content_settings.popups": 0,
            "profile.content_settings.exceptions.automatic_downloads.*.setting": 1
        }
        chrome_options.add_experimental_option("prefs", prefs)
        
        self.driver = webdriver.Chrome(options=chrome_options)
        self.driver.implicitly_wait(10)
        
        # Enable downloads via CDP
        self.driver.execute_cdp_cmd("Browser.setDownloadBehavior", {
            "behavior": "allow",
            "downloadPath": str(self.download_dir.absolute())
        })
        
        print("[OK] WebDriver ready!")
        
    def create_session(self):
        """Create scraping session in database"""
        conn = get_db_connection()
        cur = conn.cursor()
        
        try:
            # Get price source
            cur.execute("SELECT id FROM price_sources WHERE name LIKE '%KingStore%' LIMIT 1")
            result = cur.fetchone()
            
            if result:
                self.price_source_id = result[0]
            else:
                # Create price source
                cur.execute("""
                    INSERT INTO price_sources (name, source_type, base_url, country_code)
                    VALUES ('KingStore', 'website', %s, 'IL')
                    RETURNING id
                """, (self.base_url,))
                self.price_source_id = cur.fetchone()[0]
            
            # Create session
            cur.execute("""
                INSERT INTO scraping_sessions (session_name, price_source_id, status)
                VALUES (%s, %s, 'running')
                RETURNING id
            """, (f"KingStore Full Scrape {datetime.now().strftime('%Y-%m-%d %H:%M')}", self.price_source_id))
            
            self.session_id = cur.fetchone()[0]
            conn.commit()
            
            print(f"[OK] Created scraping session (ID: {self.session_id})")
            
        except Exception as e:
            print(f"[ERROR] Failed to create session: {e}")
            conn.rollback()
        finally:
            cur.close()
            conn.close()
    
    def update_session(self, status='running'):
        """Update session statistics"""
        if not self.session_id:
            return
            
        conn = get_db_connection()
        cur = conn.cursor()
        
        try:
            duration = None
            completed_at = None
            
            if status in ['completed', 'failed', 'partial']:
                completed_at = datetime.now()
            
            cur.execute("""
                UPDATE scraping_sessions
                SET status = %s,
                    files_found = %s,
                    files_downloaded = %s,
                    files_processed = %s,
                    files_failed = %s,
                    total_products_imported = %s,
                    total_prices_imported = %s,
                    completed_at = %s
                WHERE id = %s
            """, (
                status,
                self.stats['files_found'],
                self.stats['files_downloaded'],
                self.stats['files_processed'],
                self.stats['files_failed'],
                self.stats['total_products'],
                self.stats['total_prices'],
                completed_at,
                self.session_id
            ))
            
            conn.commit()
            
        except Exception as e:
            print(f"[WARN] Failed to update session: {e}")
            conn.rollback()
        finally:
            cur.close()
            conn.close()
    
    def navigate_to_site(self):
        """Navigate to KingStore"""
        print(f"\n[INFO] Navigating to: {self.base_url}")
        self.driver.get(self.base_url)
        time.sleep(3)
        
    def find_all_download_buttons(self):
        """Find all download buttons on the page"""
        print("\n[INFO] Finding download buttons...")
        
        try:
            # Wait for page load
            WebDriverWait(self.driver, 15).until(
                EC.presence_of_element_located((By.TAG_NAME, "body"))
            )
            
            # Find all download buttons
            buttons = self.driver.find_elements(By.XPATH, "//a | //button | //input[@type='button']")
            
            download_buttons = []
            for button in buttons:
                try:
                    text = button.text or button.get_attribute('value') or ''
                    
                    # Look for download-related text
                    if 'להורדה' in text or 'download' in text.lower():
                        # Try to extract file info from nearby elements
                        parent = button.find_element(By.XPATH, "./..")
                        context_text = parent.text
                        
                        download_buttons.append({
                            'element': button,
                            'text': text,
                            'context': context_text
                        })
                except:
                    continue
            
            print(f"[OK] Found {len(download_buttons)} download buttons")
            self.stats['files_found'] = len(download_buttons)
            
            return download_buttons
            
        except Exception as e:
            print(f"[ERROR] Failed to find buttons: {e}")
            return []
    
    def calculate_file_hash(self, filepath):
        """Calculate SHA256 hash of file"""
        sha256_hash = hashlib.sha256()
        with open(filepath, "rb") as f:
            for byte_block in iter(lambda: f.read(4096), b""):
                sha256_hash.update(byte_block)
        return sha256_hash.hexdigest()
    
    def parse_filename(self, filename):
        """Extract metadata from filename"""
        # Example: Price7290058108879-340-202512191522.gz
        # Format: [Type][ChainCode]-[StoreCode]-[Timestamp].gz
        
        metadata = {
            'file_type': None,
            'chain_code': None,
            'store_code': None,
            'timestamp': None
        }
        
        try:
            # Extract file type (check for variations)
            filename_upper = filename.upper()
            if 'PRICESFULL' in filename_upper:
                metadata['file_type'] = 'PricesFull'
            elif 'PRICE' in filename_upper:
                metadata['file_type'] = 'Prices'
            elif 'PROMOSFULL' in filename_upper:
                metadata['file_type'] = 'PromosFull'
            elif 'PROMO' in filename_upper:
                metadata['file_type'] = 'Promos'
            elif 'STORE' in filename_upper:
                metadata['file_type'] = 'Stores'
            
            # Extract chain code (13 digits)
            chain_match = re.search(r'(\d{13})', filename)
            if chain_match:
                metadata['chain_code'] = chain_match.group(1)
            
            # Extract store code (3 digits after dash before timestamp)
            # Pattern: -XXX-YYYYMMDDHHMMSS
            store_match = re.search(r'-(\d{1,3})-\d{12}', filename)
            if store_match:
                metadata['store_code'] = store_match.group(1)
            
            # Extract timestamp (12 digits: YYYYMMDDHHmm before .gz)
            timestamp_match = re.search(r'(\d{12})\.', filename)
            if timestamp_match:
                ts_str = timestamp_match.group(1)
                # Format: YYYYMMDDHHmm -> datetime
                try:
                    metadata['timestamp'] = datetime.strptime(ts_str, '%Y%m%d%H%M')
                except ValueError as ve:
                    print(f"[WARN] Failed to parse timestamp '{ts_str}': {ve}")
            
            print(f"     [DEBUG] Parsed: type={metadata['file_type']}, chain={metadata['chain_code']}, store={metadata['store_code']}, timestamp={metadata['timestamp']}")
            
        except Exception as e:
            print(f"[WARN] Failed to parse filename: {e}")
        
        return metadata
    
    def is_file_already_downloaded(self, filename, file_hash):
        """Check if file already exists in database"""
        conn = get_db_connection()
        cur = conn.cursor()
        
        try:
            # Check by filename or hash
            cur.execute("""
                SELECT id FROM downloaded_files
                WHERE (filename = %s AND price_source_id = %s)
                   OR file_hash = %s
            """, (filename, self.price_source_id, file_hash))
            
            result = cur.fetchone()
            return result is not None
            
        except Exception as e:
            print(f"[WARN] Error checking file: {e}")
            return False
        finally:
            cur.close()
            conn.close()
    
    def register_downloaded_file(self, filepath, metadata):
        """Register file in downloaded_files table"""
        conn = get_db_connection()
        cur = conn.cursor()
        
        try:
            file_hash = self.calculate_file_hash(filepath)
            file_size = filepath.stat().st_size
            
            cur.execute("""
                INSERT INTO downloaded_files (
                    filename, file_hash, file_size,
                    price_source_id, file_type, file_timestamp,
                    local_path, processing_status,
                    file_metadata
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, 'pending', %s::jsonb)
                ON CONFLICT (filename, price_source_id) DO UPDATE
                SET file_hash = EXCLUDED.file_hash,
                    downloaded_at = NOW()
                RETURNING id
            """, (
                filepath.name,
                file_hash,
                file_size,
                self.price_source_id,
                metadata['file_type'],
                metadata['timestamp'],
                str(filepath),
                json.dumps(metadata)  # Convert dict to JSON string
            ))
            
            file_id = cur.fetchone()[0]
            conn.commit()
            
            return file_id
            
        except Exception as e:
            print(f"[ERROR] Failed to register file: {e}")
            conn.rollback()
            return None
        finally:
            cur.close()
            conn.close()
    
    def download_file(self, button_info, index):
        """Download a single file by clicking button"""
        try:
            button = button_info['element']
            context = button_info['context']
            
            print(f"\n[{index}] Clicking download button...")
            print(f"     Context: {context[:100]}...")
            
            # Get current file count
            files_before = set(self.download_dir.glob("*"))
            
            # Click button
            button.click()
            
            # Wait for download to start and complete (check every second for up to 15 seconds)
            new_file = None
            for i in range(15):
                time.sleep(1)
                files_after = set(self.download_dir.glob("*"))
                new_files = files_after - files_before
                
                # Remove temporary/partial files
                new_files = {f for f in new_files if not f.name.endswith('.crdownload') and not f.name.endswith('.tmp')}
                
                if new_files:
                    new_file = list(new_files)[0]
                    print(f"     [OK] Downloaded: {new_file.name} (after {i+1}s)")
                    break
            
            # Find new file
            files_after = set(self.download_dir.glob("*"))
            new_files = files_after - files_before
            new_files = {f for f in new_files if not f.name.endswith('.crdownload') and not f.name.endswith('.tmp')}
            
            if not new_file or not new_files:
                print(f"     [WARN] No file downloaded after 15 seconds")
                return None
            
            # Parse filename
            metadata = self.parse_filename(new_file.name)
            
            # Check if already processed
            file_hash = self.calculate_file_hash(new_file)
            if self.is_file_already_downloaded(new_file.name, file_hash):
                print(f"     [SKIP] File already processed")
                self.stats['files_skipped'] += 1
                return None
            
            # Register file
            file_id = self.register_downloaded_file(new_file, metadata)
            self.stats['files_downloaded'] += 1
            
            return {
                'path': new_file,
                'metadata': metadata,
                'file_id': file_id
            }
                
        except Exception as e:
            print(f"     [ERROR] Download failed: {e}")
            self.stats['files_failed'] += 1
            return None
    
    def run(self):
        """Main scraping logic"""
        print("=" * 60)
        print("     KINGSTORE FULL SCRAPER")
        print("=" * 60)
        
        try:
            # Setup
            self.setup_driver()
            self.create_session()
            self.navigate_to_site()
            
            # Find all buttons
            buttons = self.find_all_download_buttons()
            
            if not buttons:
                print("[ERROR] No download buttons found!")
                self.update_session('failed')
                return
            
            # Download files
            download_count = min(len(buttons), self.download_limit) if self.download_limit else len(buttons)
            print(f"\n[INFO] Will download {download_count} files...")
            
            for i, button_info in enumerate(buttons[:download_count], 1):
                print(f"\n--- File {i}/{download_count} ---")
                self.download_file(button_info, i)
                
                # Update session periodically
                if i % 10 == 0:
                    self.update_session()
                    print(f"\n[INFO] Progress: {i}/{download_count} files processed")
                    print(f"       Downloaded: {self.stats['files_downloaded']}, Skipped: {self.stats['files_skipped']}, Failed: {self.stats['files_failed']}")
                
                time.sleep(2)  # Rate limiting - give browser time to process
            
            # Final update
            self.update_session('completed')
            
            # Print summary
            print("\n" + "=" * 60)
            print("     SCRAPING COMPLETED!")
            print("=" * 60)
            print(f"Files found:      {self.stats['files_found']}")
            print(f"Files downloaded: {self.stats['files_downloaded']}")
            print(f"Files skipped:    {self.stats['files_skipped']}")
            print(f"Files failed:     {self.stats['files_failed']}")
            print("=" * 60)
            
        except Exception as e:
            print(f"\n[ERROR] Scraper failed: {e}")
            import traceback
            traceback.print_exc()
            self.update_session('failed')
            
        finally:
            if self.driver:
                self.driver.quit()
                print("\n[OK] Browser closed")


def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(description='KingStore Full Scraper')
    parser.add_argument('--limit', type=int, help='Limit number of files to download')
    parser.add_argument('--types', nargs='+', help='File types to download (Prices, Promos, etc.)')
    
    args = parser.parse_args()
    
    scraper = KingStoreFullScraper(
        download_limit=args.limit,
        file_types=args.types
    )
    
    scraper.run()


if __name__ == "__main__":
    main()

