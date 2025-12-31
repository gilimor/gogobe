#!/usr/bin/env python3
"""
Test import after fixing UNIQUE constraint
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper

print("Testing import after fix...")
print()

scraper = ShufersalScraper()
stats = scraper.import_files(limit=1)

print("\nIf no warnings → Fixed! ✅")
print(f"Files: {stats.get('files', 0)}")
print(f"Products: {stats.get('products', 0)}")
print(f"Prices: {stats.get('prices', 0)}")
print(f"Skipped: {stats.get('skipped', 0)}")
print()
print("Check above - should be 0 product warnings!")
