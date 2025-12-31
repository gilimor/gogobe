#!/usr/bin/env python3
import sys
sys.path.insert(0, '/app/backend')

from scrapers.superpharm_scraper import SuperPharmScraper

s = SuperPharmScraper()
print("Fetching ALL files...")
files = s.fetch_file_list(limit=None)

print(f"\nTotal files: {len(files)}")

price_full = [f for f in files if f.file_type == 'PriceFull']
promo_full = [f for f in files if f.file_type == 'PromoFull']
price = [f for f in files if f.file_type == 'Price']
promo = [f for f in files if f.file_type == 'Promo']

print(f"PriceFull: {len(price_full)}")
print(f"PromoFull: {len(promo_full)}")
print(f"Price: {len(price)}")
print(f"Promo: {len(promo)}")
