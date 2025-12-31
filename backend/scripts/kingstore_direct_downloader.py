"""
KingStore Direct Downloader - Using direct download URLs
Much faster and more reliable than Selenium!
"""

import sys
from pathlib import Path
from datetime import datetime
import requests
from bs4 import BeautifulSoup
import time
import re
import hashlib

# Add backend to path
backend_path = Path(__file__).parent.parent
sys.path.insert(0, str(backend_path))

from database.db_connection import get_db_connection


class KingStoreDirectDownloader:
    def __init__(self, download_limit=None, file_types=None):
        """
        Initialize direct downloader
        
        Args:
            download_limit: Max files to download
            file_types: List of file types (e.g., ['Prices', 'PricesFull'])
        """
        self.base_url = "https://kingstore.binaprojects.com"
        self.main_page = f"{self.base_url}/Main.aspx"
        self.download_base = f"{self.base_url}/Download/"
        
        self.download_dir = Path("/app/data/kingstore/downloads")
        self.download_dir.mkdir(parents=True, exist_ok=True)
        
        self.download_limit = download_limit
        self.file_types = file_types or ['Price', 'PricesFull']  # Focus on prices
        
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
        
        self.stats = {
            'files_found': 0,
            'files_downloaded': 0,
            'files_skipped': 0,
            'files_failed': 0,
            'total_bytes': 0
        }
        
        self.session_id = None
        self.price_source_id = None
    
    def log(self, message):
        """Print timestamped log"""
        timestamp = datetime.now().strftime('%H:%M:%S')
        print(f"[{timestamp}] {message}")
    
    def create_session(self):
        """Create scraping session"""
        # Skip database session tracking for now
        self.session_id = None
        self.log("Starting download session (no DB tracking)")
    
    def parse_filename(self, filename):
        """Extract metadata from filename"""
        metadata = {
            'file_type': None,
            'chain_code': None,
            'store_code': None,
            'timestamp': None
        }
        
        try:
            # Extract file type
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
            
            # Extract store code
            store_match = re.search(r'-(\d{1,3})-\d{12}', filename)
            if store_match:
                metadata['store_code'] = store_match.group(1)
            
            # Extract timestamp
            timestamp_match = re.search(r'(\d{12})\.', filename)
            if timestamp_match:
                ts_str = timestamp_match.group(1)
                try:
                    metadata['timestamp'] = datetime.strptime(ts_str, '%Y%m%d%H%M')
                except:
                    pass
            
        except Exception as e:
            self.log(f"[WARN] Failed to parse filename: {e}")
        
        return metadata
    
    def calculate_file_hash(self, filepath):
        """Calculate SHA256 hash"""
        sha256_hash = hashlib.sha256()
        with open(filepath, "rb") as f:
            for byte_block in iter(lambda: f.read(4096), b""):
                sha256_hash.update(byte_block)
        return sha256_hash.hexdigest()
    
    def is_file_already_downloaded(self, filename, file_hash):
        """Check if file already exists"""
        # Check if file exists locally
        filepath = self.download_dir / filename
        return filepath.exists()
    
    def register_downloaded_file(self, filepath, metadata):
        """Register file in database"""
        # Skip database registration for now
        return True
    
    def find_all_files(self):
        """Scrape main page to find all file links"""
        self.log("Fetching file list from KingStore...")
        
        try:
            response = self.session.get(self.main_page, timeout=30)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Find all links that look like download links
            file_links = []
            
            # Method 1: Look for direct download links
            for link in soup.find_all('a', href=True):
                href = link['href']
                if 'Download/' in href or any(ft in href for ft in ['Price', 'Promo', 'Store']):
                    if href.startswith('/'):
                        href = self.base_url + href
                    elif not href.startswith('http'):
                        href = self.download_base + href
                    
                    filename = href.split('/')[-1]
                    
                    # Filter by file type
                    if self.file_types:
                        if not any(ft in filename for ft in self.file_types):
                            continue
                    
                    file_links.append({
                        'url': href,
                        'filename': filename
                    })
            
            # Method 2: Look in onclick attributes
            for element in soup.find_all(['a', 'button', 'input']):
                onclick = element.get('onclick', '')
                if 'Download/' in onclick:
                    # Extract filename from onclick
                    match = re.search(r"Download/([^'\"]+\.gz)", onclick)
                    if match:
                        filename = match.group(1)
                        
                        # Filter by file type
                        if self.file_types:
                            if not any(ft in filename for ft in self.file_types):
                                continue
                        
                        file_links.append({
                            'url': self.download_base + filename,
                            'filename': filename
                        })
            
            # Remove duplicates
            seen = set()
            unique_links = []
            for link in file_links:
                if link['filename'] not in seen:
                    seen.add(link['filename'])
                    unique_links.append(link)
            
            self.log(f"Found {len(unique_links)} files to download")
            self.stats['files_found'] = len(unique_links)
            
            return unique_links
            
        except Exception as e:
            self.log(f"[ERROR] Failed to fetch file list: {e}")
            import traceback
            traceback.print_exc()
            return []
    
    def download_file(self, file_info):
        """Download a single file using requests"""
        url = file_info['url']
        filename = file_info['filename']
        
        try:
            self.log(f"Downloading: {filename}")
            
            # Download with streaming
            response = self.session.get(url, stream=True, timeout=60)
            response.raise_for_status()
            
            # Save to file
            filepath = self.download_dir / filename
            
            with open(filepath, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    if chunk:
                        f.write(chunk)
            
            file_size = filepath.stat().st_size
            self.log(f"  Downloaded {file_size:,} bytes")
            
            # Parse metadata
            metadata = self.parse_filename(filename)
            
            # Check if already processed
            file_hash = self.calculate_file_hash(filepath)
            if self.is_file_already_downloaded(filename, file_hash):
                self.log(f"  [SKIP] Already processed")
                filepath.unlink()  # Delete duplicate
                self.stats['files_skipped'] += 1
                return False
            
            # Register in database
            self.register_downloaded_file(filepath, metadata)
            
            self.stats['files_downloaded'] += 1
            self.stats['total_bytes'] += file_size
            
            return True
            
        except Exception as e:
            self.log(f"  [ERROR] Download failed: {e}")
            self.stats['files_failed'] += 1
            return False
    
    def update_session(self, status='completed'):
        """Update session in database"""
        # Skip database update for now
        pass
    
    def run(self):
        """Main download process"""
        print("=" * 70)
        print("     KINGSTORE DIRECT DOWNLOADER")
        print("=" * 70)
        print(f"  Method: Direct HTTP downloads (no Selenium!)")
        print(f"  File types: {', '.join(self.file_types)}")
        print("=" * 70)
        print()
        
        try:
            # Create session
            self.create_session()
            
            # Find all files
            files = self.find_all_files()
            
            if not files:
                self.log("[ERROR] No files found!")
                return
            
            # Limit if needed
            download_count = min(len(files), self.download_limit) if self.download_limit else len(files)
            self.log(f"Will download {download_count} files")
            print()
            
            # Download files
            for i, file_info in enumerate(files[:download_count], 1):
                self.log(f"--- File {i}/{download_count} ---")
                self.download_file(file_info)
                
                # Progress update
                if i % 10 == 0:
                    self.update_session('running')
                    mb_downloaded = self.stats['total_bytes'] / 1024 / 1024
                    self.log(f"Progress: {i}/{download_count} files, {mb_downloaded:.1f} MB")
                
                time.sleep(0.5)  # Rate limiting
                print()
            
            # Final update
            self.update_session('completed')
            
            # Print summary
            print("=" * 70)
            print("     DOWNLOAD COMPLETED!")
            print("=" * 70)
            print(f"Files found:      {self.stats['files_found']}")
            print(f"Files downloaded: {self.stats['files_downloaded']}")
            print(f"Files skipped:    {self.stats['files_skipped']}")
            print(f"Files failed:     {self.stats['files_failed']}")
            print(f"Total size:       {self.stats['total_bytes'] / 1024 / 1024:.1f} MB")
            print("=" * 70)
            
        except Exception as e:
            self.log(f"[ERROR] Download process failed: {e}")
            import traceback
            traceback.print_exc()
            self.update_session('failed')


def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(description='KingStore Direct Downloader')
    parser.add_argument('--limit', type=int, help='Limit number of files')
    parser.add_argument('--types', nargs='+', default=['Price', 'PricesFull'],
                       help='File types to download')
    
    args = parser.parse_args()
    
    downloader = KingStoreDirectDownloader(
        download_limit=args.limit,
        file_types=args.types
    )
    
    downloader.run()


if __name__ == "__main__":
    main()







