#!/usr/bin/env python3
"""
Download latest Shufersal files - FAST PARALLEL VERSION
"""

import requests
import re
from pathlib import Path
from datetime import datetime
import logging
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import List, Tuple
import html

logging.basicConfig(level=logging.INFO, format='[%(asctime)s] %(message)s', datefmt='%H:%M:%S')
logger = logging.getLogger(__name__)


def get_real_download_links() -> List[str]:
    """Fetch real download links from Shufersal API"""
    logger.info("Fetching file list from Shufersal API...")
    
    session = requests.Session()
    session.headers.update({
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'X-Requested-With': 'XMLHttpRequest',
        'Referer': 'https://prices.shufersal.co.il/'
    })
    
    try:
        # Loop through categories: 2=PriceFull, 5=Stores
        valid_links = []
        categories = [2, 5]
        
        for cat_id in categories:
            logger.info(f"Scanning category {cat_id}...")
            url = f'https://prices.shufersal.co.il/FileObject/UpdateCategory?catID={cat_id}&storeId=0'
            response = session.get(url, timeout=30)
            
            if response.status_code == 200:
                content = response.text
                links = re.findall(r'href="([^"]+)"', content)
                
                found_count = 0
                for link in links:
                    if (('.gz' in link) and 
                       (('PriceFull' in link) or ('Stores' in link))):
                        clean_link = html.unescape(link)
                        if clean_link not in valid_links:
                            valid_links.append(clean_link)
                            found_count += 1
                logger.info(f"  Found {found_count} files in category {cat_id}")
                
        logger.info(f"✓ Total valid files found: {len(valid_links)}")
        return valid_links
            
    except Exception as e:
        logger.error(f"Failed to fetch links: {e}")
        return []


def download_file(url: str, output_dir: Path) -> Tuple[bool, str, int]:
    """Download single file - returns (success, filename, size)"""
    try:
        # Extract filename from URL (before query params)
        filename = url.split('/')[-1].split('?')[0]
        output_path = output_dir / filename
        
        # Skip if already exists and size matches (approx)
        if output_path.exists():
            # In a real scenario we might check headers for size/date
            pass

        response = requests.get(url, timeout=60, stream=True)
        if response.status_code == 200:
            with open(output_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    if chunk:
                        f.write(chunk)
            
            size = output_path.stat().st_size
            return True, filename, size
            
    except Exception as e:
        logger.error(f"Failed to download {url}: {e}")
        pass
        
    return False, "", 0


def download_latest_files(output_dir: Path, max_stores: int = 50):
    """Download latest PricesFull files - PARALLEL"""
    
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # 1. Get real links
    links = get_real_download_links()
    
    if not links:
        logger.warning("No links found via API")
        return 0
        
    # Limit number of files if needed
    if max_stores > 0:
        links = links[:max_stores]
    
    logger.info(f"Downloading {len(links)} files in parallel...")
    
    # 2. Download in parallel (10 workers)
    downloaded = []
    
    with ThreadPoolExecutor(max_workers=10) as executor:
        futures = {
            executor.submit(download_file, url, output_dir): url
            for url in links
        }
        
        for future in as_completed(futures):
            url = futures[future]
            success, filename, size = future.result()
            
            if success:
                size_kb = size / 1024
                logger.info(f"✓ {filename} ({size_kb:.1f} KB)")
                downloaded.append(filename)
    
    logger.info(f"\n✓ Downloaded {len(downloaded)} files")
    return len(downloaded)


if __name__ == "__main__":
    import sys
    
    output_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else Path('./data/shufersal')
    max_stores = int(sys.argv[2]) if len(sys.argv) > 2 else 0  # 0 = all
    
    logger.info("=" * 60)
    logger.info("Shufersal API Sraper (Parallel)")
    logger.info("=" * 60)
    
    count = download_latest_files(output_dir, max_stores)
    
    if count == 0:
        logger.warning("No files downloaded!")
        sys.exit(1)
