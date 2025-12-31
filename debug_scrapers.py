import sys
import os
import traceback

# Setup Path
sys.path.append(os.getcwd())

print("--- DEBUGGING SCRAPER REGISTRY ---")

try:
    from backend.scrapers.scraper_registry import get_registry
    registry = get_registry()
    print("Registry loaded successfully.")
    
    print(f"Sources in Registry: {list(registry.scrapers.keys())}")
    
    # Try Explicit Load of Victory
    print("\nAttempting to load Victory...")
    try:
        from backend.scrapers.il.supermarkets.victory import VictoryScraper
        v = VictoryScraper()
        print("SUCCESS: VictoryScraper instantiated.")
    except Exception as e:
        print(f"FAIL: VictoryScraper load error: {e}")
        traceback.print_exc()

    # Try Explicit Load of FreshMarket
    print("\nAttempting to load FreshMarket...")
    try:
        from backend.scrapers.il.supermarkets.fresh_market import FreshMarketScraper
        f = FreshMarketScraper()
        print("SUCCESS: FreshMarketScraper instantiated.")
    except Exception as e:
        print(f"FAIL: FreshMarketScraper load error: {e}")
        traceback.print_exc()

except Exception as e:
    print(f"CRITICAL REGISTRY FAIL: {e}")
    traceback.print_exc()
