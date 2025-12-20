"""
KingStore Smart Downloader
Uses the direct download URL pattern discovered by user
"""

import sys
from pathlib import Path
from datetime import datetime
import requests
import time
import re
import hashlib
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from bs4 import BeautifulSoup

# Add backend to path
backend_path = Path(__file__).parent.parent
sys.path.insert(0, str(backend_path))

from database.db_connection import get_db_connection


class KingStoreSmartDownloader:
    def __init__(self, download_limit=None):
        self.base_url = "https://kingstore.binaprojects.com"
        self.download_base = f"{self.base_url}/Download/"
        self.main_page = f"{self.base_url}/Main.aspx"
        
        self.download_dir = Path("backend/data/kingstore")
        self.download_dir.mkdir(parents=True, exist_ok=True)
        
        self.download_limit = download_limit
        
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
        
        self.stats = {
            'files_found': 0,
            'files_downloaded': 0,
            'files_skipped': 0,
            'files_failed': 0
        }
        
        self.price_source_id = None
    
    def log(self, message):
        timestamp = datetime.now().strftime('%H:%M:%S')
        print(f"[{timestamp}] {message}")
    
    def get_file_list_from_page(self):
        """Use Selenium to get file list from page source"""
        self.log("Opening KingStore with browser to find files...")
        
        chrome_options = Options()
        chrome_options.add_argument("--headless")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--log-level=3")
        
        driver = webdriver.Chrome(options=chrome_options)
        
        try:
            driver.get(self.main_page)
            time.sleep(5)
            
            # Get page source
            page_source = driver.page_source
            
            # Parse with BeautifulSoup
            soup = BeautifulSoup(page_source, 'html.parser')
            
            # Look for download buttons and extract filenames from context
            filenames = []
            
            # Method 1: Look in button text/attributes
            for element in soup.find_all(['a', 'button', 'input']):
                # Check onclick, href, data attributes
                for attr in ['onclick', 'href', 'data-file', 'data-url']:
                    value = element.get(attr, '')
                    if 'Price' in value or '.gz' in value:
                        # Extract filename
                        match = re.search(r'(Price\w*\d+-\d+-\d+\.gz)', value)
                        if match:
                            filenames.append(match.group(1))
            
            # Method 2: Look in nearby text
            download_buttons = driver.find_elements(By.XPATH, "//*[contains(text(), 'להורדה')]")
            
            for button in download_buttons:
                try:
                    # Get parent element
                    parent = button.find_element(By.XPATH, "..")
                    text = parent.text
                    
                    # Try to extract filename pattern
                    # Look for patterns like: Price7290058108879-339-202512191522
                    match = re.search(r'(Price\w*\d{13}-\d+-\d{12})', text)
                    if match:
                        filename = match.group(1) + '.gz'
                        filenames.append(filename)
                except:
                    continue
            
            # Remove duplicates
            filenames = list(set(filenames))
            
            self.log(f"Found {len(filenames)} filenames from page")
            
            return filenames
            
        finally:
            driver.quit()
    
    def download_file_direct(self, filename):
        """Download file using direct URL"""
        url = self.download_base + filename
        
        try:
            self.log(f"Downloading: {filename}")
            
            response = self.session.get(url, stream=True, timeout=60)
            
            if response.status_code == 404:
                self.log(f"  [ERROR] File not found (404)")
                return False
            
            response.raise_for_status()
            
            filepath = self.download_dir / filename
            
            with open(filepath, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    if chunk:
                        f.write(chunk)
            
            file_size = filepath.stat().st_size
            self.log(f"  [OK] Downloaded {file_size:,} bytes")
            
            self.stats['files_downloaded'] += 1
            
            # Register in database
            self.register_file(filepath)
            
            return True
            
        except Exception as e:
            self.log(f"  [ERROR] {e}")
            self.stats['files_failed'] += 1
            return False
    
    def register_file(self, filepath):
        """Register downloaded file"""
        conn = get_db_connection()
        cur = conn.cursor()
        
        try:
            # Get price source
            if not self.price_source_id:
                cur.execute("SELECT id FROM price_sources WHERE name LIKE '%KingStore%' LIMIT 1")
                result = cur.fetchone()
                if result:
                    self.price_source_id = result[0]
            
            if not self.price_source_id:
                return
            
            # Calculate hash
            sha256_hash = hashlib.sha256()
            with open(filepath, "rb") as f:
                for byte_block in iter(lambda: f.read(4096), b""):
                    sha256_hash.update(byte_block)
            file_hash = sha256_hash.hexdigest()
            
            file_size = filepath.stat().st_size
            
            cur.execute("""
                INSERT INTO downloaded_files (
                    filename, file_hash, file_size,
                    price_source_id, local_path, processing_status
                )
                VALUES (%s, %s, %s, %s, %s, 'pending')
                ON CONFLICT (filename, price_source_id) DO NOTHING
            """, (filepath.name, file_hash, file_size, self.price_source_id, str(filepath)))
            
            conn.commit()
            
        except Exception as e:
            self.log(f"  [WARN] Failed to register: {e}")
            conn.rollback()
        finally:
            cur.close()
            conn.close()
    
    def run(self):
        """Main process"""
        print("=" * 70)
        print("     KINGSTORE SMART DOWNLOADER")
        print("=" * 70)
        print("  Strategy: Find filenames → Download directly")
        print("=" * 70)
        print()
        
        try:
            # Get file list from page
            filenames = self.get_file_list_from_page()
            
            if not filenames:
                self.log("[ERROR] No files found!")
                self.log("")
                self.log("Tip: You can also provide direct URLs:")
                self.log("  Example: https://kingstore.binaprojects.com/Download/Price7290058108879-339-202512191522.gz")
                return
            
            self.stats['files_found'] = len(filenames)
            
            # Limit if needed
            download_count = min(len(filenames), self.download_limit) if self.download_limit else len(filenames)
            self.log(f"Will download {download_count} files")
            print()
            
            # Download each file
            for i, filename in enumerate(filenames[:download_count], 1):
                self.log(f"--- File {i}/{download_count} ---")
                self.download_file_direct(filename)
                time.sleep(0.5)
                print()
            
            # Summary
            print("=" * 70)
            print("     DOWNLOAD COMPLETED!")
            print("=" * 70)
            print(f"Files found:      {self.stats['files_found']}")
            print(f"Files downloaded: {self.stats['files_downloaded']}")
            print(f"Files failed:     {self.stats['files_failed']}")
            print("=" * 70)
            
        except Exception as e:
            self.log(f"[ERROR] Process failed: {e}")
            import traceback
            traceback.print_exc()


def main():
    import argparse
    
    parser = argparse.ArgumentParser(description='KingStore Smart Downloader')
    parser.add_argument('--limit', type=int, help='Limit number of files')
    parser.add_argument('--url', help='Single file URL to download')
    
    args = parser.parse_args()
    
    downloader = KingStoreSmartDownloader(download_limit=args.limit)
    
    if args.url:
        # Download single file from URL
        filename = args.url.split('/')[-1]
        print(f"Downloading single file: {filename}")
        downloader.download_file_direct(filename)
    else:
        # Full process
        downloader.run()


if __name__ == "__main__":
    main()





