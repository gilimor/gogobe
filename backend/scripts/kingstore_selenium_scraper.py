"""
KingStore Selenium Scraper - Advanced scraper for JavaScript-rendered content
Scrapes Israeli supermarket price data from KingStore website
"""

import sys
import os
from pathlib import Path
from datetime import datetime
from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from bs4 import BeautifulSoup
import time
import requests
import xml.etree.ElementTree as ET
import gzip
import shutil
import zipfile

# Add backend to path
backend_path = Path(__file__).parent.parent
sys.path.insert(0, str(backend_path))

from database.db_connection import get_db_connection

class KingStoreSeleniumScraper:
    def __init__(self):
        self.base_url = "https://kingstore.binaprojects.com/Main.aspx"
        self.driver = None
        self.setup_driver()
        
    def setup_driver(self):
        """Setup Chrome WebDriver with appropriate options"""
        print("[INFO] Setting up Chrome WebDriver...")
        
        chrome_options = Options()
        # chrome_options.add_argument("--headless")  # Run in background (comment for debugging)
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--disable-blink-features=AutomationControlled")
        chrome_options.add_argument("--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
        chrome_options.add_argument("--log-level=3")  # Suppress warnings
        
        # Let Selenium Manager automatically download the correct ChromeDriver
        # This works with Selenium 4.6+ and matches the installed Chrome version
        print("[INFO] Using Selenium Manager to auto-download correct ChromeDriver...")
        self.driver = webdriver.Chrome(options=chrome_options)
        self.driver.implicitly_wait(10)
        print("[OK] WebDriver ready!")
        
    def navigate_to_site(self):
        """Navigate to KingStore main page"""
        print(f"\n🌐 Navigating to: {self.base_url}")
        self.driver.get(self.base_url)
        time.sleep(3)  # Wait for JavaScript to load
        
    def find_xml_links(self):
        """Find all XML file download links on the page"""
        print("\n🔍 Looking for XML file links...")
        
        # Wait for page to fully load
        try:
            WebDriverWait(self.driver, 15).until(
                EC.presence_of_element_located((By.TAG_NAME, "body"))
            )
        except Exception as e:
            print(f"⚠️ Timeout waiting for page: {e}")
        
        # Get page source and parse with BeautifulSoup
        soup = BeautifulSoup(self.driver.page_source, 'html.parser')
        
        # Look for various types of links
        xml_links = []
        
        # Find all links
        all_links = soup.find_all('a', href=True)
        print(f"📎 Found {len(all_links)} total links")
        
        for link in all_links:
            href = link['href']
            text = link.get_text(strip=True)
            
            # Look for XML or ZIP files
            if any(ext in href.lower() for ext in ['.xml', '.zip', '.gz']):
                full_url = href if href.startswith('http') else f"https://kingstore.binaprojects.com/{href.lstrip('/')}"
                xml_links.append({
                    'url': full_url,
                    'text': text,
                    'type': 'xml' if '.xml' in href.lower() else 'archive'
                })
        
        # Also look for buttons or form submissions
        buttons = soup.find_all(['button', 'input'], type=['button', 'submit'])
        print(f"🔘 Found {len(buttons)} buttons")
        
        if not xml_links:
            print("\n[INFO] No direct XML links found. Trying to find download buttons...")
            # Try to find clickable elements
            clickable = self.driver.find_elements(By.XPATH, "//a | //button | //input[@type='button']")
            print(f"[INFO] Found {len(clickable)} clickable elements")
            
            # Find download buttons
            download_buttons = []
            for i, elem in enumerate(clickable):
                try:
                    text = elem.text or elem.get_attribute('value') or elem.get_attribute('id')
                    # Look for download-related text (Hebrew or English)
                    if any(keyword in str(text).lower() for keyword in ['להורדה', 'download', 'הורד']):
                        download_buttons.append((i, elem, text))
                        if len(download_buttons) <= 20:
                            print(f"  [{i}] {elem.tag_name}: {text}")
                except:
                    pass
            
            return download_buttons if download_buttons else xml_links
        
        return xml_links
    
    def download_xml_file(self, url, filename=None):
        """Download XML file from URL"""
        try:
            if not filename:
                filename = f"kingstore_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xml"
            
            download_dir = Path("backend/data/kingstore")
            download_dir.mkdir(parents=True, exist_ok=True)
            
            filepath = download_dir / filename
            
            print(f"\n⬇️ Downloading: {url}")
            response = requests.get(url, timeout=30)
            response.raise_for_status()
            
            with open(filepath, 'wb') as f:
                f.write(response.content)
            
            print(f"✅ Saved to: {filepath}")
            return filepath
            
        except Exception as e:
            print(f"❌ Download failed: {e}")
            return None
    
    def extract_archive(self, archive_filepath):
        """Extract .gz or .zip file and return path to extracted XML"""
        print(f"\n[INFO] Extracting archive: {archive_filepath}")
        
        try:
            # Try to detect file type by reading magic bytes
            with open(archive_filepath, 'rb') as f:
                magic = f.read(2)
            
            # PK = ZIP, 1f 8b = GZIP
            is_zip = (magic == b'PK')
            is_gzip = (magic == b'\x1f\x8b')
            
            if is_zip or archive_filepath.suffix == '.zip':
                print("[INFO] Detected ZIP file")
                extract_dir = archive_filepath.parent
                with zipfile.ZipFile(archive_filepath, 'r') as zip_ref:
                    zip_ref.extractall(extract_dir)
                    # Find extracted XML files
                    xml_files = list(extract_dir.glob("*.xml"))
                    if xml_files:
                        print(f"[OK] Extracted {len(xml_files)} XML file(s)")
                        return xml_files[0]  # Return first XML file
                        
            elif is_gzip:
                print("[INFO] Detected GZIP file")
                xml_filepath = archive_filepath.with_suffix('')  # Remove .gz extension
                
                with gzip.open(archive_filepath, 'rb') as f_in:
                    with open(xml_filepath, 'wb') as f_out:
                        shutil.copyfileobj(f_in, f_out)
                
                print(f"[OK] Extracted to: {xml_filepath}")
                return xml_filepath
            else:
                print(f"[ERROR] Unknown file type (magic bytes: {magic.hex()})")
                return None
            
        except Exception as e:
            print(f"[ERROR] Extraction failed: {e}")
            import traceback
            traceback.print_exc()
            return None
    
    def parse_xml_file(self, filepath):
        """Parse XML file and extract product/price data"""
        print(f"\n[INFO] Parsing XML: {filepath}")
        
        try:
            tree = ET.parse(filepath)
            root = tree.getroot()
            
            products = []
            
            # Try different XML structures (different supermarkets use different formats)
            # Format 1: Standard Israeli supermarket format
            for item in root.findall('.//Item'):
                product = {}
                for child in item:
                    product[child.tag] = child.text
                products.append(product)
            
            # Format 2: Alternative structure
            if not products:
                for product_elem in root.findall('.//Product'):
                    product = {}
                    for child in product_elem:
                        product[child.tag] = child.text
                    products.append(product)
            
            print(f"[OK] Found {len(products)} products in XML")
            
            # Print sample
            if products:
                print("\n[INFO] Sample product:")
                for key, value in list(products[0].items())[:10]:
                    print(f"  {key}: {value}")
            
            return products
            
        except Exception as e:
            print(f"[ERROR] XML parsing failed: {e}")
            return []
    
    def save_to_database(self, products, source_name="KingStore"):
        """Save products to database"""
        print(f"\n💾 Saving {len(products)} products to database...")
        
        conn = get_db_connection()
        cur = conn.cursor()
        
        try:
            # Get or create price source
            cur.execute("SELECT id FROM price_sources WHERE name = %s", (source_name,))
            result = cur.fetchone()
            
            if result:
                source_id = result[0]
                print(f"[INFO] Using existing price source (ID: {source_id})")
            else:
                cur.execute("""
                    INSERT INTO price_sources (name, source_type, base_url, country_code)
                    VALUES (%s, 'xml_feed', %s, 'IL')
                    RETURNING id
                """, (source_name, self.base_url))
                source_id = cur.fetchone()[0]
                print(f"[INFO] Created new price source (ID: {source_id})")
            
            saved_count = 0
            
            # Note: This is a basic implementation
            # You'll need to adapt based on actual XML structure
            for product_data in products[:10]:  # Limit to 10 for testing
                try:
                    # Extract fields (adapt based on actual XML structure)
                    name = product_data.get('ItemName') or product_data.get('Name')
                    barcode = product_data.get('ItemCode') or product_data.get('Barcode')
                    price = product_data.get('ItemPrice') or product_data.get('Price')
                    
                    if not name or not price:
                        continue
                    
                    # Create or get product
                    cur.execute("""
                        INSERT INTO products (name, description, vertical_id)
                        VALUES (%s, %s, 
                            (SELECT id FROM verticals WHERE name = 'Supermarket' LIMIT 1))
                        ON CONFLICT (name, vertical_id) DO UPDATE SET name = EXCLUDED.name
                        RETURNING id
                    """, (name, f"Barcode: {barcode}"))
                    
                    product_id = cur.fetchone()[0]
                    
                    # Create price
                    cur.execute("""
                        INSERT INTO prices (product_id, supplier_id, price, currency)
                        VALUES (%s,
                            (SELECT id FROM suppliers WHERE name = %s LIMIT 1),
                            %s, 'ILS')
                        ON CONFLICT (product_id, supplier_id) 
                        DO UPDATE SET price = EXCLUDED.price, updated_at = CURRENT_TIMESTAMP
                    """, (product_id, source_name, float(price)))
                    
                    saved_count += 1
                    
                except Exception as e:
                    print(f"  ⚠️ Skipped product: {e}")
                    continue
            
            conn.commit()
            print(f"✅ Saved {saved_count} products to database")
            
        except Exception as e:
            conn.rollback()
            print(f"❌ Database error: {e}")
        finally:
            cur.close()
            conn.close()
    
    def close(self):
        """Close the browser"""
        if self.driver:
            self.driver.quit()
            print("\n✅ Browser closed")


def main():
    """Main execution function"""
    print("=" * 60)
    print("🛒 KingStore Selenium Scraper")
    print("=" * 60)
    
    scraper = None
    
    try:
        # Initialize scraper
        scraper = KingStoreSeleniumScraper()
        
        # Navigate to site
        scraper.navigate_to_site()
        
        # Find XML links or download buttons
        results = scraper.find_xml_links()
        
        if results and isinstance(results, list):
            # Check if results are links (dicts) or buttons (tuples)
            if isinstance(results[0], dict):
                # We have direct XML links
                print(f"\n[OK] Found {len(results)} XML/archive links:")
                for i, link in enumerate(results[:5], 1):
                    print(f"  {i}. [{link['type'].upper()}] {link['text']}")
                    print(f"     URL: {link['url']}")
                
                # Download and process first XML file
                first_link = results[0]
                filepath = scraper.download_xml_file(first_link['url'])
                
                if filepath and filepath.suffix == '.xml':
                    products = scraper.parse_xml_file(filepath)
                    if products:
                        scraper.save_to_database(products)
                        
            elif isinstance(results[0], tuple):
                # We have download buttons
                print(f"\n[OK] Found {len(results)} download buttons")
                print(f"[INFO] Attempting to click first button and download file...")
                
                try:
                    # Click the first download button
                    idx, button, text = results[0]
                    print(f"[INFO] Clicking button: {text}")
                    
                    # Setup download directory
                    download_dir = Path("backend/data/kingstore")
                    download_dir.mkdir(parents=True, exist_ok=True)
                    
                    # Configure Chrome to auto-download files
                    prefs = {
                        "download.default_directory": str(download_dir.absolute()),
                        "download.prompt_for_download": False,
                        "directory_upgrade": True
                    }
                    scraper.driver.execute_cdp_cmd("Page.setDownloadBehavior", {
                        "behavior": "allow",
                        "downloadPath": str(download_dir.absolute())
                    })
                    
                    button.click()
                    print("[OK] Button clicked, waiting for download...")
                    time.sleep(5)  # Wait for download to complete
                    
                    # Check for downloaded files
                    downloaded_files = list(download_dir.glob("*.xml")) + list(download_dir.glob("*.zip")) + list(download_dir.glob("*.gz"))
                    if downloaded_files:
                        latest_file = max(downloaded_files, key=lambda p: p.stat().st_mtime)
                        print(f"[OK] Downloaded: {latest_file}")
                        
                        # Handle compressed files
                        if latest_file.suffix in ['.gz', '.zip']:
                            xml_file = scraper.extract_archive(latest_file)
                            if xml_file:
                                products = scraper.parse_xml_file(xml_file)
                                if products:
                                    scraper.save_to_database(products)
                        elif latest_file.suffix == '.xml':
                            products = scraper.parse_xml_file(latest_file)
                            if products:
                                scraper.save_to_database(products)
                        else:
                            print(f"[WARN] Unsupported file type: {latest_file.suffix}")
                    else:
                        print("[WARN] No files downloaded yet")
                        
                except Exception as e:
                    print(f"[ERROR] Failed to click button: {e}")
        else:
            print("\n[WARN] No XML links or download buttons found automatically.")
            print("[INFO] Taking screenshot for manual inspection...")
            screenshot_path = "backend/data/kingstore_screenshot.png"
            scraper.driver.save_screenshot(screenshot_path)
            print(f"[OK] Screenshot saved: {screenshot_path}")
            
            print("\n[INFO] Please check the screenshot and provide direct XML URLs")
        
    except Exception as e:
        print(f"\n❌ Scraper failed: {e}")
        import traceback
        traceback.print_exc()
        
    finally:
        if scraper:
            scraper.close()
    
    print("\n" + "=" * 60)
    print("✅ Scraping completed!")
    print("=" * 60)


if __name__ == "__main__":
    main()

