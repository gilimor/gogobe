#!/usr/bin/env python3
"""
Quick Shufersal Import Test - 1 File
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper

print("Initializing Shufersal scraper...")
scraper = ShufersalScraper()

print(f"✓ Cache: {scraper.cache is not None}")
print(f"✓ Master Matcher: {scraper.master_matcher is not None}")
print(f"✓ Batch size: {scraper.batch_size}")

print("\nRunning import (1 file)...")
stats = scraper.import_files(limit=1)

print("\n" + "="*50)
print("IMPORT RESULTS:")
print("="*50)
print(f"Files: {stats.get('files', 0)}")
print(f"Products: {stats.get('products', 0)}")
print(f"Prices: {stats.get('prices', 0)}")
print(f"Cached: {stats.get('cached', 0)}")
print("="*50)
