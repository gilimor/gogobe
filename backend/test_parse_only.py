#!/usr/bin/env python3
"""
SANDBOX - Parse file locally without database
Test parsing speed only
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
from datetime import datetime
import os

print("=" * 70)
print("🧪 SANDBOX - Parse Test (No DB)")
print("=" * 70)
print()

# Find existing files
data_dir = '/app/data/shufersal/prices_full'
if os.path.exists(data_dir):
    files = [f for f in os.listdir(data_dir) if f.endswith('.gz')][:3]
    print(f"Found {len(files)} existing files in {data_dir}")
else:
    print(f"Directory not found: {data_dir}")
    files = []

if files:
    scraper = ShufersalScraper()
    
    for i, filename in enumerate(files, 1):
        filepath = os.path.join(data_dir, filename)
        print(f"\n[{i}/{len(files)}] Parsing: {filename}")
        
        start = datetime.now()
        products = scraper.parse_file(filepath)
        duration = (datetime.now() - start).total_seconds()
        
        print(f"   Parsed {len(products)} products in {duration:.2f}s")
        print(f"   Speed: {len(products)/duration:.0f} products/sec")
        
        if i == 1 and len(products) > 0:
            print(f"\n   Sample product:")
            sample = products[0]
            print(f"   - Name: {sample.get('name', 'N/A')[:50]}")
            print(f"   - EAN: {sample.get('ean', 'N/A')}")
            print(f"   - Price: {sample.get('price', 'N/A')}")
else:
    print("\n⚠️  No files found!")
    print("   The scraper hasn't downloaded any files yet.")
    print()
    print("To download files:")
    print("   docker exec gogobe-api-1 python /app/backend/scrapers/shufersal_scraper.py")

print()
print("=" * 70)
