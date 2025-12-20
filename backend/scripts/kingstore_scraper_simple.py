"""
KingStore Scraper - Simple Version (no BeautifulSoup)
Downloads XML files from https://kingstore.binaprojects.com

Uses only requests and regex - no external HTML parsing libraries needed.
"""

import requests
import re
from pathlib import Path
from datetime import datetime
import gzip
import xml.etree.ElementTree as ET
import json

class KingStoreScraper:
    """Simple scraper for KingStore supermarket data"""
    
    BASE_URL = "https://kingstore.binaprojects.com"
    
    def __init__(self, output_dir="kingstore_data"):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 Gogobe Price Scraper'
        })
    
    def list_files_simple(self):
        """List files using simple regex parsing"""
        print(f"Fetching from {self.BASE_URL}/Main.aspx...")
        
        try:
            response = self.session.get(f"{self.BASE_URL}/Main.aspx", timeout=30)
            response.raise_for_status()
            
            html = response.text
            
            # Find all links to .xml or .gz files using regex
            # Patterns: href="File.aspx?...xyz.xml" or download links
            file_patterns = [
                r'href=["\'](File\.aspx\?[^"\']*\.(?:xml|gz))["\']',
                r'href=["\'](/Files/[^"\']*\.(?:xml|gz))["\']',
                r'href=["\'](download[^"\']*\.(?:xml|gz))["\']'
            ]
            
            files = []
            for pattern in file_patterns:
                matches = re.findall(pattern, html, re.IGNORECASE)
                for match in matches:
                    url = match if match.startswith('http') else f"{self.BASE_URL}/{match}"
                    files.append({
                        'url': url,
                        'name': match.split('/')[-1].split('?')[-1]
                    })
            
            # Remove duplicates
            seen = set()
            unique_files = []
            for f in files:
                if f['url'] not in seen:
                    seen.add(f['url'])
                    unique_files.append(f)
            
            print(f"Found {len(unique_files)} potential files")
            return unique_files
            
        except Exception as e:
            print(f"Error: {e}")
            return []
    
    def download_file(self, url, filename):
        """Download file"""
        output_path = self.output_dir / filename
        
        print(f"  Downloading: {filename}")
        
        try:
            response = self.session.get(url, timeout=60, stream=True)
            response.raise_for_status()
            
            with open(output_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            
            file_size = output_path.stat().st_size
            print(f"    ✅ Downloaded: {file_size:,} bytes")
            return output_path
            
        except Exception as e:
            print(f"    ❌ Error: {e}")
            return None
    
    def parse_xml_prices(self, xml_path):
        """Parse supermarket prices XML"""
        print(f"  Parsing: {xml_path.name}")
        
        try:
            tree = ET.parse(xml_path, )
            root = tree.getroot()
            
            products = []
            
            # Find all Item elements
            for item in root.findall('.//Item'):
                try:
                    # Get item details
                    code = item.find('ItemCode')
                    name = item.find('ItemName')
                    price = item.find('ItemPrice')
                    
                    if code is not None and name is not None and price is not None:
                        products.append({
                            'barcode': code.text,
                            'name': name.text,
                            'price': float(price.text),
                            'currency': 'ILS'
                        })
                except:
                    continue
            
            print(f"    ✅ Found {len(products)} products")
            return products
            
        except Exception as e:
            print(f"    ❌ Parse error: {e}")
            return []
    
    def scrape_demo(self):
        """Demo scrape - try to get some data"""
        print("="*60)
        print("KingStore Simple Scraper - DEMO")
        print("="*60)
        print()
        
        # Try to list files
        files = self.list_files_simple()
        
        if not files:
            print("\n⚠️  Could not find file links")
            print("The website may require:")
            print("  1. JavaScript to load")
            print("  2. Form submission to access files")
            print("  3. Cookies/session")
            print()
            print("Manual inspection recommended:")
            print(f"  Visit: {self.BASE_URL}/Main.aspx")
            return []
        
        print(f"\nFound {len(files)} files. Trying first one...")
        
        # Try first file
        if files:
            first_file = files[0]
            print(f"\nTrying: {first_file['url']}")
            
            downloaded = self.download_file(first_file['url'], first_file['name'])
            
            if downloaded:
                if 'price' in downloaded.name.lower():
                    products = self.parse_xml_prices(downloaded)
                    return products
        
        return []


def main():
    """Run demo scraper"""
    scraper = KingStoreScraper()
    products = scraper.scrape_demo()
    
    if products:
        print(f"\n🎉 Success! Scraped {len(products)} products")
        print("\nFirst 5 products:")
        for p in products[:5]:
            print(f"  {p['name']}: {p['price']} ₪")
    else:
        print("\n📋 Next steps:")
        print("  1. Visit the website manually")
        print("  2. Find direct download links")
        print("  3. Update scraper with correct URLs")


if __name__ == "__main__":
    main()






