
import requests
import logging
import sys
import os

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def debug_superpharm_download():
    # URL from the logs or similar structure
    # Based on scraper code, base_url is https://prices.super-pharm.co.il/
    # We'll try to fetch the main page first to get a real file link
    
    base_url = 'https://prices.super-pharm.co.il/'
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.5',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1',
    }

    session = requests.Session()
    session.headers.update(headers)

    logger.info(f"Fetching main page: {base_url}")
    try:
        resp = session.get(base_url, verify=False, timeout=30)
        logger.info(f"Main page status: {resp.status_code}")
        
        from bs4 import BeautifulSoup
        soup = BeautifulSoup(resp.text, 'html.parser')
        
        logger.info(f"Page Title: {soup.title.string if soup.title else 'No Title'}")
        
        table = soup.find('table')
        if not table:
             logger.error("No table found!")
             logger.info(f"Page content snippet: {resp.text[:500]}")
             return

        rows = table.find_all('tr')
        logger.info(f"Found {len(rows)} rows")
        
        if len(rows) < 2:
             logger.error("Not enough rows")
             return

        # Iterate rows to find one with data
        target_row = None
        for i, row in enumerate(rows):
            cells = row.find_all('td')
            logger.info(f"Row {i}: {len(cells)} cells")
            if len(cells) >= 6:
                target_row = row
                logger.info(f"Found valid row at index {i}")
                
                # Debug cell content
                for j, c in enumerate(cells):
                     logger.info(f"  Col {j}: {c.get_text(strip=True)[:20]}...")
                
                break
        
        if not target_row:
             logger.error("No valid data row found")
             return

        cells = target_row.find_all('td')
        link = cells[5].find('a', href=True)
        if not link:
            logger.error("Could not find a file link on main page")
            return

        file_url = link['href']
        if not file_url.startswith('http'):
            file_url = base_url.rstrip('/') + '/' + file_url.lstrip('/')
            
        logger.info(f"Attempting to download: {file_url}")
        
        # Try download
        file_resp = session.get(file_url, stream=True, verify=False, timeout=60)
        logger.info(f"Download status: {file_resp.status_code}")
        logger.info(f"Download headers: {file_resp.headers}")
        
        content_sample = list(file_resp.iter_content(chunk_size=1024))[0]
        logger.info(f"First 1024 bytes length: {len(content_sample)}")
        logger.info(f"First 100 bytes content: {content_sample[:100]}")
        
        if b'<html' in content_sample.lower() or b'<!doctype html' in content_sample.lower():
            logger.warning("CONTENT LOOKS LIKE HTML (Error Page?)")
        else:
            logger.info("Content seems to be binary (likely GZ/ZIP)")

    except Exception as e:
        logger.error(f"Error: {e}")

if __name__ == "__main__":
    debug_superpharm_download()
