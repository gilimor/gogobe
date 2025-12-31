
import sys
import logging
from pathlib import Path

# Add backend to path
sys.path.append(str(Path(__file__).parent.parent))

from scrapers.scraper_registry import ScraperRegistry

logging.basicConfig(level=logging.INFO)

def test_new_chains():
    registry = ScraperRegistry()
    
    # Test Victory
    print("\n" + "="*50)
    print("Testing Victory...")
    try:
        victory = registry.get('victory')
        if victory:
            # Manually inject details if not fully set by Config logic
            # (The config logic in get_instance usually handles this if arguments match init)
            # PublishedPricesScraper requires: chain_name, chain_slug, chain_name_he, chain_id, platform_user
            
            # The Registry Config 'credentials' are passed as **kwargs, 
            # but PublishedPricesScraper.__init__ expects specific named args.
            # We might need to adjust the Registry instantiation logic or the Config.
            # Let's see if it works or if we need to fix scraper_registry.py
            
            # Actually, ScraperRegistry.py lines 55: self._instance = scraper_cls(**self.credentials)
            # But PublishedPricesScraper.__init__ takes: chain_name, chain_slug, ...
            # We didn't provide those in 'credentials' dict in the registry!
            # We only provided username/password.
            # This will fail. I anticipate this failure.
            pass
    except Exception as e:
        print(f"Instatiation failed as expected: {e}")

    # Fix: We need to update ScraperRegistry content to pass ALL init args in 'credentials' 
    # OR create specific subclasses for Victory/TivTaam like we did for FreshMarket.
    
    print("Conclusion: Need to create specific subclasses or update registry config.")

if __name__ == "__main__":
    test_new_chains()
