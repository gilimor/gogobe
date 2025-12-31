#!/usr/bin/env python3
"""
Simple full Shufersal import using built-in scraper
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
from datetime import datetime

print("Starting full Shufersal import...")
print()

start = datetime.now()

scraper = ShufersalScraper()
stats = scraper.import_files(limit=None)  # Import ALL

duration = (datetime.now() - start).total_seconds()

print()
print("=" * 70)
print("IMPORT COMPLETE!")
print("=" * 70)
print(f"Duration: {duration:.1f}s ({duration/60:.1f} min)")
print(f"Files: {stats['files']}")
print(f"Products: {stats['products']}")
print(f"Prices: {stats['prices']}")
print(f"Errors: {stats['errors']}")
if duration > 0:
    print(f"Speed: {stats['prices']/duration:.0f} prices/sec")
print("=" * 70)
