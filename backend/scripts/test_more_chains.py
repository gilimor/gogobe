
import sys
import logging
from pathlib import Path

# Add backend to path
sys.path.append(str(Path(__file__).parent.parent))

from scrapers.scraper_registry import ScraperRegistry

logging.basicConfig(level=logging.INFO)

def test_chains():
    registry = ScraperRegistry()
    
    # Test Tiv Taam (Verified)
    print("\n" + "="*50)
    print("Verifying Tiv Taam connectivity...")
    try:
        s = registry.get('tiv_taam')
        if s:
             print(f"Scraper: {s.chain_name}")
             s.login() # Should work
             print("Tiv Taam Login OK")
    except Exception as e:
        print(f"Tiv Taam Failed: {e}")

    # Test Yohananof (New)
    print("\n" + "="*50)
    print("Testing Yohananof Scraper...")
    try:
        s = registry.get('yohananof')
        if s:
             print(f"Scraper: {s.chain_name}")
             s.login()
             print("Yohananof Login OK")
    except Exception as e:
        print(f"Yohananof Failed: {e}")

if __name__ == "__main__":
    test_chains()
