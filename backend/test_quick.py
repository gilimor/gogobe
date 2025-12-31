#!/usr/bin/env python3
"""
Quick 3-file import test
"""
import sys
sys.path.insert(0, '/app/backend')

print("Starting import...")
from scrapers.shufersal_scraper import ShufersalScraper

scraper = ShufersalScraper()
print("Scraper initialized")

stats = scraper.import_files(limit=3)
print(f"Done! Stats: {stats}")
