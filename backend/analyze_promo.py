#!/usr/bin/env python3
"""
Analyze SuperPharm PromoFull file structure
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.scraper_registry import get_registry
from pathlib import Path
import xml.etree.ElementTree as ET

print("🔍 בדיקת מבנה קובץ PromoFull")
print("=" * 80)
print()

# Get SuperPharm scraper
registry = get_registry()
sp = registry.get('superpharm')

# Get a PromoFull file
files = sp.fetch_file_list(limit=50)
promo_files = [f for f in files if 'Promo' in f.file_type]

if not promo_files:
    print("❌ לא נמצאו קבצי Promo")
    exit(1)

# Download and analyze first promo file
promo_file = promo_files[0]
print(f"📥 מוריד: {promo_file.filename}")

download_dir = Path('data/superpharm')
download_dir.mkdir(parents=True, exist_ok=True)

file_path = sp.download_file(promo_file, download_dir)
print(f"   ✅ הורד ל-{file_path}")
print()

# Decompress if needed
if file_path.suffix == '.gz':
    file_path = sp.decompress_file(file_path)
    print(f"   ✅ פתח ל-{file_path}")
    print()

# Parse XML
print("📄 מבנה XML:")
print()

tree = ET.parse(str(file_path))
root = tree.getroot()

print(f"Root tag: {root.tag}")
print()

# Find structure
def show_structure(element, indent=0):
    """Show XML structure"""
    prefix = "  " * indent
    
    # Show element
    attrs = ', '.join([f"{k}={v}" for k, v in element.attrib.items()][:3])
    if attrs:
        print(f"{prefix}<{element.tag}> [{attrs}]")
    else:
        print(f"{prefix}<{element.tag}>")
    
    # Show text if meaningful
    if element.text and element.text.strip():
        text = element.text.strip()[:50]
        print(f"{prefix}  Text: {text}")
    
    # Show first child of each type
    seen_tags = set()
    for child in element:
        if child.tag not in seen_tags:
            seen_tags.add(child.tag)
            show_structure(child, indent + 1)
    
    if indent < 2:  # Only show first 2 levels deep
        return

print("Structure (first 3 levels):")
show_structure(root)

print()
print("=" * 80)
print()

# Show sample promo item
print("📋 דוגמה של פריט במבצע:")
print()

# Find first promo item
promo_items = root.findall('.//Promotion') or root.findall('.//Item') or root.findall('.//Line')

if promo_items:
    item = promo_items[0]
    print("Fields in promo item:")
    for child in item:
        value = child.text or ""
        if len(value) > 50:
            value = value[:50] + "..."
        print(f"   {child.tag}: {value}")
else:
    print("⚠️ לא נמצאו פריטי מבצע")

print()
print("=" * 80)
