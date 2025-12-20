"""
KingStore Scraper - Israeli Supermarket Price Data
Downloads XML files from https://kingstore.binaprojects.com

This is a public repository of supermarket price files
mandated by Israeli price transparency law.
"""

import requests
from bs4 import BeautifulSoup
import re
from pathlib import Path
from datetime import datetime
import gzip
import xml.etree.ElementTree as ET

class KingStoreScraper:
    """Scrape supermarket XML files from KingStore"""
    
    BASE_URL = "https://kingstore.binaprojects.com"
    
    def __init__(self, output_dir="kingstore_data"):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Gogobe Price Scraper'
        })
    
    def list_available_files(self, max_files=10):
        """List available XML files from KingStore"""
        print(f"Fetching file list from {self.BASE_URL}/Main.aspx...")
        
        try:
            response = self.session.get(f"{self.BASE_URL}/Main.aspx", timeout=30)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Find all file links (typically in a table or list)
            files = []
            
            # Look for links to XML or GZ files
            for link in soup.find_all('a', href=True):
                href = link['href']
                if any(ext in href.lower() for ext in ['.xml', '.gz']):
                    file_info = {
                        'url': href if href.startswith('http') else f"{self.BASE_URL}/{href}",
                        'name': link.get_text(strip=True) or href.split('/')[-1],
                        'href': href
                    }
                    files.append(file_info)
            
            print(f"Found {len(files)} files")
            
            # Return first N files
            return files[:max_files]
            
        except Exception as e:
            print(f"Error fetching file list: {e}")
            return []
    
    def download_file(self, url, filename=None):
        """Download a file from KingStore"""
        
        if not filename:
            filename = url.split('/')[-1]
        
        output_path = self.output_dir / filename
        
        print(f"  Downloading: {filename}")
        
        try:
            response = self.session.get(url, timeout=60, stream=True)
            response.raise_for_status()
            
            # Save file
            with open(output_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            
            print(f"    ✅ Saved: {output_path}")
            return output_path
            
        except Exception as e:
            print(f"    ❌ Error: {e}")
            return None
    
    def extract_gz(self, gz_path):
        """Extract .gz file"""
        xml_path = gz_path.with_suffix('')
        
        try:
            with gzip.open(gz_path, 'rb') as f_in:
                with open(xml_path, 'wb') as f_out:
                    f_out.write(f_in.read())
            
            print(f"    ✅ Extracted: {xml_path}")
            return xml_path
            
        except Exception as e:
            print(f"    ❌ Extract error: {e}")
            return None
    
    def parse_prices_xml(self, xml_path):
        """Parse Israeli supermarket Prices XML"""
        print(f"  Parsing: {xml_path.name}")
        
        try:
            tree = ET.parse(xml_path)
            root = tree.getroot()
            
            products = []
            
            # Common XML structure for Israeli supermarkets
            for item in root.findall('.//Item'):
                try:
                    item_code = item.find('ItemCode')
                    item_name = item.find('ItemName')
                    item_price = item.find('ItemPrice')
                    manufacturer = item.find('ManufacturerName')
                    
                    if all([item_code is not None, item_name is not None, item_price is not None]):
                        products.append({
                            'barcode': item_code.text,
                            'name': item_name.text,
                            'price': float(item_price.text),
                            'manufacturer': manufacturer.text if manufacturer is not None else ''
                        })
                except (ValueError, AttributeError):
                    continue
            
            print(f"    ✅ Found {len(products)} products")
            return products
            
        except ET.ParseError as e:
            print(f"    ❌ XML Parse Error: {e}")
            return []
        except Exception as e:
            print(f"    ❌ Error: {e}")
            return []
    
    def scrape_latest(self, max_files=5):
        """Scrape latest files from KingStore"""
        print("="*60)
        print("KingStore Scraper")
        print("="*60)
        
        # List files
        files = self.list_available_files(max_files=max_files)
        
        if not files:
            print("No files found")
            return []
        
        all_products = []
        
        for file_info in files:
            print(f"\nProcessing: {file_info['name']}")
            
            # Download
            downloaded = self.download_file(file_info['url'], file_info['name'])
            
            if not downloaded:
                continue
            
            # Extract if .gz
            xml_file = downloaded
            if downloaded.suffix == '.gz':
                xml_file = self.extract_gz(downloaded)
                if not xml_file:
                    continue
            
            # Parse if it's a prices file
            if 'price' in xml_file.name.lower():
                products = self.parse_prices_xml(xml_file)
                all_products.extend(products)
        
        print("\n" + "="*60)
        print(f"Total products scraped: {len(all_products)}")
        print("="*60)
        
        return all_products


def main():
    """Demo: Scrape KingStore"""
    scraper = KingStoreScraper()
    
    # Try to scrape first 5 files
    products = scraper.scrape_latest(max_files=5)
    
    if products:
        print(f"\n✅ Successfully scraped {len(products)} products!")
        print("\nSample products:")
        for product in products[:5]:
            print(f"  - {product['name']}: {product['price']} ₪")
    else:
        print("\n⚠️  No products found. The website structure may have changed.")
        print("    Manual inspection needed.")


if __name__ == "__main__":
    main()






