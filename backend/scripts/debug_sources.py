import logging
import sys
import os
# Configure path to allow imports from parent directory (backend)
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from scrapers.scraper_registry import get_registry

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def debug_sources():
    registry = get_registry()
    sources_to_debug = ['king_store']
    
    print(f"\n========================================")
    print(f"DEBUGGING SOURCES: {sources_to_debug}")
    print(f"========================================")

    for source_id in sources_to_debug:
        print(f"\n[*] Source: {source_id}")
        scraper = registry.get(source_id)
        if not scraper:
            print(f"    [!] Scraper not found in registry")
            continue

        print(f"    Class: {scraper.__class__.__name__}")
        
        # Test 1: Fetch Prices
        print("    Fetching PRICES list (default view)...")
        try:
            files = scraper.fetch_file_list(file_type='prices_full', limit=10)
            print(f"    Found {len(files)} files.")
            for f in files:
                print(f"    - {f.filename} | URL: {f.url}")
        except Exception as e:
            print(f"    [!] Error fetching prices: {e}")

        # Test 2: Fetch Stores
        print("    Fetching STORES list...")
        try:
            files = scraper.fetch_file_list(file_type='stores', limit=5)
            print(f"    Found {len(files)} files.")
            for f in files:
                print(f"    - {f.filename} | URL: {f.url}")
        except Exception as e:
            print(f"    [!] Error fetching stores: {e}")

if __name__ == "__main__":
    # Add parent dir to path to allow imports
    sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    debug_sources()
