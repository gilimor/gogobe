#!/usr/bin/env python3
"""
SIMPLE DIRECT IMPORT - NO REDIS STREAMS
Just import directly from scrapers
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.scraper_registry import get_registry
from datetime import datetime

print("🚀 DIRECT IMPORT - SuperPharm + Shufersal")
print("=" * 80)
print()

registry = get_registry()

# SuperPharm
print("1️⃣  SuperPharm Import...")
superpharm = registry.get('superpharm')
if superpharm:
    start = datetime.now()
    result = superpharm.import_files(limit=30)
    duration = (datetime.now() - start).total_seconds() / 60
    
    print(f"   ✅ Complete!")
    print(f"   Files processed: {result.get('files_processed', 0)}")
    print(f"   Products: {result.get('products_created', 0)}")
    print(f"   Prices: {result.get('prices_imported', 0)}")
    print(f"   Duration: {duration:.1f} min")
else:
    print("   ❌ SuperPharm not available")

print()

# Shufersal
print("2️⃣  Shufersal Import...")
shufersal = registry.get('shufersal')
if shufersal:
    start = datetime.now()
    result = shufersal.import_files(limit=50)
    duration = (datetime.now() - start).total_seconds() / 60
    
    print(f"   ✅ Complete!")
    print(f"   Files processed: {result.get('files_processed', 0)}")
    print(f"   Products: {result.get('products_created', 0)}")
    print(f"   Prices: {result.get('prices_imported', 0)}")
    print(f"   Duration: {duration:.1f} min")
else:
    print("   ❌ Shufersal not available")

print()
print("=" * 80)
print("✅ IMPORT COMPLETE!")
print("=" * 80)
