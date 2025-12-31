#!/usr/bin/env python3
"""Test SuperPharm with store names"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.scraper_registry import get_registry

print("🧪 Testing SuperPharm Store Names")
print("=" * 80)
print()

registry = get_registry()
sp = registry.get('superpharm')

# Test fetch_file_list
print("1️⃣  Testing fetch_file_list...")
files = sp.fetch_file_list(limit=10)

print(f"\n   Found {len(files)} files")
print(f"   Store registry: {len(sp.store_registry)} stores")
print()

# Show sample
print("   Sample files:")
for f in files[:5]:
    print(f"      • {f.filename[:40]:40s} | {f.store_name}")

print()

# Show store registry
print("   Sample store registry:")
for code, info in list(sp.store_registry.items())[:5]:
    print(f"      Code {code}: {info['name']} | City: {info['city'] or 'N/A'}")

print()
print("=" * 80)
