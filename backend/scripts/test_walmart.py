
import sys
import logging
from pathlib import Path

# Add backend to path
sys.path.append(str(Path(__file__).parent.parent))

from scrapers.scraper_registry import ScraperRegistry

logging.basicConfig(level=logging.INFO)

def test_walmart():
    registry = ScraperRegistry()
    
    print("\n" + "="*50)
    print("Testing Walmart Scraper (Simulation)...")
    try:
        # 1. Get Instance
        wm = registry.get('walmart')
        if not wm:
            print("Failed to get Walmart scraper")
            return

        print(f"Scraper: {wm.chain_name} ({wm.chain_slug})")
        
        # 2. Login (Mock)
        wm.login()
        
        # 3. Fetch Files (Categories)
        print("Fetching 'Files' (Categories)...")
        files = wm.fetch_file_list(limit=2, file_type='prices')
        for f in files:
            print(f" - Found: {f.filename} ({f.url})")
            
        # 4. Download & Parse 1 file
        if files:
            print("Downloading first category...")
            # Use /app path inside docker
            path = wm.download_file(files[0], Path('/app/backend/data/walmart_temp'))
            print(f"Downloaded to: {path}")
            
            print("Parsing...")
            meta, products = wm.parse_file(path)
            print(f"Parsed {len(products)} products from Walmart {meta.get('category')}!")
            if products:
                print(f"Sample: {products[0].name} - ${products[0].price} (UPC: {products[0].barcode})")

    except Exception as e:
        print(f"Walmart Test Failed: {e}")

if __name__ == "__main__":
    test_walmart()
