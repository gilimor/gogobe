#!/usr/bin/env python3
"""
Test upsert_price - Re-import same file
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper

print("=" * 60)
print("TESTING UPSERT_PRICE - RE-IMPORTING SAME FILE")
print("=" * 60)
print()

scraper = ShufersalScraper()

print("Running import AGAIN (same file)...")
print("If upsert_price works:")
print("  - Same prices → only timestamp update")
print("  - Changed prices → new record")
print()

stats = scraper.import_files(limit=1)

print("\n" + "="*60)
print("RESULTS:")
print("="*60)
print(f"Files: {stats.get('files', 0)}")
print(f"Products: {stats.get('products', 0)}")
print(f"Prices: {stats.get('prices', 0)}")
print()
print("If prices = 0 → upsert_price is working! ✅")
print("If prices > 0 → creating duplicates! ❌")
print("="*60)
