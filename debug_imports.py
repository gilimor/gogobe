from backend.scrapers.base_supermarket_scraper import BaseSupermarketScraper
import inspect
import os

print(f"BaseSupermarketScraper loaded from: {inspect.getfile(BaseSupermarketScraper)}")

import backend.scrapers.base_supermarket_scraper
print(f"Module file: {backend.scrapers.base_supermarket_scraper.__file__}")

with open(backend.scrapers.base_supermarket_scraper.__file__, 'r') as f:
    content = f.read()
    if "DEBUG: Executing Batch Upsert" in content:
        print(" -> File CONTENT CONFIRMED: Has Debug Print")
    else:
        print(" -> File CONTENT MISMATCH: Misses Debug Print")
