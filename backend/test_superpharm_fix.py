#!/usr/bin/env python3
"""Test SuperPharm import after fix"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.scraper_registry import get_registry
from datetime import datetime

print("🧪 Testing SuperPharm Import (after store_cache fix)")
print("=" * 70)
print()

registry = get_registry()

superpharm = registry.get('superpharm')
if superpharm:
    start = datetime.now()
    
    # Import only PriceFull files (limit 10 for quick test)
    result = superpharm.import_files(limit=10)
    
    duration = (datetime.now() - start).total_seconds()
    
    print()
    print("=" * 70)
    print("📊 RESULTS:")
    print(f"   Files processed: {result.get('files_processed', 0)}")
    print(f"   Products created: {result.get('products_created', 0)}")
    print(f"   Prices imported: {result.get('prices_imported', 0)}")
    print(f"   Errors: {result.get('errors', 0)}")
    print(f"   Duration: {duration:.1f}s")
    print("=" * 70)
else:
    print("❌ SuperPharm not available")
