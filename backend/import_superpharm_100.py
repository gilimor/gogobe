#!/usr/bin/env python3
"""
Import more SuperPharm data - only PriceFull files
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.scraper_registry import get_registry
from datetime import datetime

print("💊 SuperPharm Import - PriceFull Only")
print("=" * 80)
print()

registry = get_registry()

superpharm = registry.get('superpharm')
if superpharm:
    start = datetime.now()
    
    # Get all files
    all_files = superpharm.fetch_file_list(limit=None)
    
    # Filter only PriceFull files (not Promo)
    price_files = [f for f in all_files if 'Price' in f.file_type and 'Promo' not in f.file_type]
    
    print(f"📋 Found {len(price_files)} PriceFull files out of {len(all_files)} total")
    print(f"   Importing first 100...")
    print()
    
    # Import first 100 PriceFull files
    result = superpharm.import_files(limit=100)
    
    duration = (datetime.now() - start).total_seconds() / 60
    
    print()
    print("=" * 80)
    print("📊 RESULTS:")
    print(f"   Files processed: {result.get('files_processed', result.get('files', 0))}")
    print(f"   Products created: {result.get('products_created', result.get('products', 0))}")
    print(f"   Prices imported: {result.get('prices_imported', result.get('prices', 0))}")
    print(f"   Errors: {result.get('errors', 0)}")
    print(f"   Duration: {duration:.1f} minutes")
    
    if result.get('prices_imported', result.get('prices', 0)) > 0:
        rate = result.get('prices_imported', result.get('prices', 0)) / (duration or 0.01)
        print(f"   Speed: {rate:,.0f} prices/minute")
    
    print("=" * 80)
else:
    print("❌ SuperPharm not available")
