
import sys
import logging
from pathlib import Path

# Add backend to path
sys.path.append(str(Path(__file__).parent.parent))

from scrapers.scraper_registry import ScraperRegistry

logging.basicConfig(level=logging.INFO)

def test_off():
    registry = ScraperRegistry()
    
    print("\n" + "="*50)
    print("Testing Open Food Facts Scraper...")
    try:
        # 1. Get Instance
        off = registry.get('openfoodfacts')
        if not off:
            print("Failed to get Open Food Facts scraper")
            return

        print(f"Scraper: {off.chain_name} ({off.chain_slug})")
        
        # 2. Fetch Files (Categories)
        print("Fetching 'Files' (Data Dump URL)...")
        files = off.fetch_file_list(limit=1, file_type='products')
        for f in files:
            print(f" - Found: {f.filename} ({f.url})")
            
        # 3. Download & Parse specific sample (Mock vs Real)
        # We probably DON'T want to download 4GB in this test script.
        # So we will interpret the code, but maybe skip real download?
        # Or I can manually create a small GZ file to test parsing.
        
        print("\nCreating mock GZ file for parser test...")
        import gzip
        import json
        mock_path = Path('/app/backend/data/off_test.jsonl.gz')
        mock_path.parent.mkdir(parents=True, exist_ok=True)
        
        with gzip.open(mock_path, 'wt', encoding='utf-8') as f:
            # Write 3 lines
            json.dump({'code': '72912345', 'product_name': 'Israeli Bamba', 'brands': 'Osem', 'nutriscore_grade': 'd'}, f)
            f.write('\n')
            json.dump({'code': '3017620422003', 'product_name': 'Nutella', 'brands': 'Ferrero', 'nutriscore_grade': 'e'}, f)
            f.write('\n')
            json.dump({'code': '', 'product_name': 'Invalid'}, f)
            f.write('\n')

        print("Parsing mock file...")
        meta, products = off.parse_file(mock_path)
        print(f"Parsed {len(products)} products from OFF dump!")
        for p in products:
            print(f" - {p.name} (Barcode: {p.barcode}, Brand: {p.manufacturer})")

    except Exception as e:
        print(f"OFF Test Failed: {e}")

if __name__ == "__main__":
    test_off()
