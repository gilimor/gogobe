
import sys
import logging
from pathlib import Path

# Add backend to path
sys.path.append(str(Path(__file__).parent.parent))

from scrapers.scraper_registry import ScraperRegistry

logging.basicConfig(level=logging.INFO)

def test_new_chains_live():
    registry = ScraperRegistry()
    
    # Test Victory
    print("\n" + "="*50)
    print("Testing Victory Scraper...")
    try:
        victory = registry.get('victory')
        if victory:
            # Try to login (it's part of the init usually, but fetch_file_list calls it)
            # Just check if it initialized
            print(f"Victory Initialized: ID={victory.chain_id}")
            
            # Try valid fetch file list (limit 1)
            print("Fetching 1 file from Victory...")
            files = victory.fetch_file_list(limit=1, file_type='prices')
            print(f"Found {len(files)} files.")
            for f in files:
                print(f" - {f.filename} ({f.url})")
        else:
            print("Failed to get Victory scraper instance")
    except Exception as e:
        print(f"Victory Failed: {e}")

    # Test Tiv Taam
    print("\n" + "="*50)
    print("Testing Tiv Taam Scraper...")
    try:
        tt = registry.get('tiv_taam')
        if tt:
             print(f"Tiv Taam Initialized: ID={tt.chain_id}")
             print("Fetching 1 file from Tiv Taam...")
             files = tt.fetch_file_list(limit=1, file_type='prices')
             print(f"Found {len(files)} files.")
             for f in files:
                print(f" - {f.filename} ({f.url})")
    except Exception as e:
        print(f"Tiv Taam Failed: {e}")

if __name__ == "__main__":
    test_new_chains_live()
