#!/usr/bin/env python3
"""
Shufersal File Downloader
Automatically downloads price files from Shufersal website
"""

import requests
from bs4 import BeautifulSoup
from pathlib import Path
import logging
from typing import List, Optional
from dataclasses import dataclass
from datetime import datetime
import time

logging.basicConfig(level=logging.INFO, format='[%(asctime)s] %(message)s', datefmt='%H:%M:%S')
logger = logging.getLogger(__name__)


@dataclass
class FileInfo:
    """Information about a downloadable file"""
    filename: str
    url: str
    store_name: str
    file_type: str
    timestamp: str
    size_kb: float


class ShufersalDownloader:
    """Download files from Shufersal transparency website"""
    
    def __init__(self, download_dir: Path = None):
        self.base_url = "https://prices.shufersal.co.il/"
        self.download_dir = download_dir or Path("./data/shufersal")
        self.download_dir.mkdir(parents=True, exist_ok=True)
        
        # Session for maintaining cookies
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
    
    def get_file_list(self, file_type: str = 'prices_full', limit: Optional[int] = None) -> List[FileInfo]:
        """
        Get list of available files from the website
        
        Args:
            file_type: 'stores', 'prices_full', 'prices', 'promos_full', 'promos'
            limit: Maximum number of files to return
            
        Returns:
            List of FileInfo objects
        """
        logger.info(f"Fetching {file_type} file list from {self.base_url}")
        
        # Map file type to category ID
        category_map = {
            'prices': '1',
            'prices_full': '2',
            'promos': '3',
            'promos_full': '4',
            'stores': '5'
        }
        
        category_id = category_map.get(file_type, '2')
        
        try:
            # Fetch the main page
            response = self.session.get(self.base_url, timeout=30)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Find all file rows in the table
            # Note: The actual implementation depends on the page structure
            # This is a simplified version - you may need to use Selenium for dynamic content
            
            files = []
            
            # For now, we'll use a direct approach with known file patterns
            # In production, you'd scrape the actual table or use their API if available
            
            logger.warning("Automatic file discovery not fully implemented")
            logger.info("Please use manual download or provide file URLs directly")
            
            return files
            
        except Exception as e:
            logger.error(f"Failed to fetch file list: {e}")
            return []
    
    def download_file(self, url: str, filename: Optional[str] = None) -> Optional[Path]:
        """
        Download a single file
        
        Args:
            url: URL of the file to download
            filename: Optional custom filename
            
        Returns:
            Path to downloaded file, or None if failed
        """
        if not filename:
            filename = url.split('/')[-1].split('?')[0]
        
        output_path = self.download_dir / filename
        
        # Skip if already exists
        if output_path.exists():
            logger.info(f"File already exists: {filename}")
            return output_path
        
        try:
            logger.info(f"Downloading: {filename}")
            
            response = self.session.get(url, stream=True, timeout=60)
            response.raise_for_status()
            
            # Get file size
            total_size = int(response.headers.get('content-length', 0))
            
            # Download with progress
            downloaded = 0
            with open(output_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    if chunk:
                        f.write(chunk)
                        downloaded += len(chunk)
                        
                        # Progress indicator
                        if total_size > 0:
                            percent = (downloaded / total_size) * 100
                            if downloaded % (100 * 1024) == 0:  # Every 100KB
                                logger.info(f"  Progress: {percent:.1f}%")
            
            logger.info(f"✓ Downloaded: {filename} ({downloaded / 1024:.1f} KB)")
            return output_path
            
        except Exception as e:
            logger.error(f"Failed to download {filename}: {e}")
            if output_path.exists():
                output_path.unlink()  # Remove partial file
            return None
    
    def download_from_browser_downloads(self, browser_download_dir: Path) -> List[Path]:
        """
        Copy files from browser's download directory
        
        Args:
            browser_download_dir: Path to browser's Downloads folder
            
        Returns:
            List of copied file paths
        """
        logger.info(f"Looking for Shufersal files in: {browser_download_dir}")
        
        # Find recent Shufersal files (last 1 hour)
        cutoff_time = time.time() - 3600
        
        shufersal_files = []
        for pattern in ['PriceFull*.gz', 'Price*.gz', 'Stores*.gz', 'Promo*.gz']:
            for file_path in browser_download_dir.glob(pattern):
                # Check if file is recent
                if file_path.stat().st_mtime > cutoff_time:
                    shufersal_files.append(file_path)
        
        if not shufersal_files:
            logger.warning("No recent Shufersal files found in Downloads")
            return []
        
        logger.info(f"Found {len(shufersal_files)} recent files")
        
        # Copy to our data directory
        copied_files = []
        for src_file in shufersal_files:
            dst_file = self.download_dir / src_file.name
            
            if dst_file.exists():
                logger.info(f"  Skipping (exists): {src_file.name}")
                copied_files.append(dst_file)
                continue
            
            try:
                import shutil
                shutil.copy2(src_file, dst_file)
                logger.info(f"  ✓ Copied: {src_file.name}")
                copied_files.append(dst_file)
            except Exception as e:
                logger.error(f"  ✗ Failed to copy {src_file.name}: {e}")
        
        return copied_files


def main():
    """Main entry point"""
    import sys
    import argparse
    
    parser = argparse.ArgumentParser(description='Download Shufersal price files')
    parser.add_argument('--type', default='prices_full',
                       choices=['stores', 'prices_full', 'prices', 'promos_full', 'promos'],
                       help='Type of files to download')
    parser.add_argument('--limit', type=int, help='Maximum number of files')
    parser.add_argument('--output', type=Path, help='Output directory')
    parser.add_argument('--from-browser', type=Path, 
                       help='Copy files from browser Downloads folder')
    
    args = parser.parse_args()
    
    downloader = ShufersalDownloader(download_dir=args.output)
    
    if args.from_browser:
        # Copy from browser downloads
        files = downloader.download_from_browser_downloads(args.from_browser)
        print(f"\n✓ Copied {len(files)} files to {downloader.download_dir}")
        for f in files:
            print(f"  - {f.name}")
    else:
        # Download from website
        files = downloader.get_file_list(file_type=args.type, limit=args.limit)
        
        if not files:
            print("\nNo files found!")
            print("Try using --from-browser to copy from your Downloads folder:")
            print(f"  python download_shufersal.py --from-browser C:\\Users\\{Path.home().name}\\Downloads")
            return
        
        print(f"\nFound {len(files)} files")
        
        for file_info in files:
            downloader.download_file(file_info.url, file_info.filename)


if __name__ == "__main__":
    main()
