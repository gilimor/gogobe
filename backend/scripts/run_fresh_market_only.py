
import sys
import logging
from pathlib import Path

# Add backend to path
sys.path.append(str(Path(__file__).parent.parent))

from scrapers.scraper_registry import ScraperRegistry

# Setup logging
logging.basicConfig(level=logging.INFO)

def run():
    print("Running Fresh Market Scraper ONLY...")
    registry = ScraperRegistry()
    scraper = registry.get('fresh_market')
    
    if not scraper:
        print("Fresh Market scraper not found!")
        return

    # Run logic
    print("Fetching files...")
    # This will check DB for pending/new files.
    # Since I reset one file to 'pending', it should pick it up.
    stats = scraper.import_files()
    print(f"Stats: {stats}")

if __name__ == "__main__":
    run()
