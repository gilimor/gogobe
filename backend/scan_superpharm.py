#!/usr/bin/env python3
"""Scan ALL pages of SuperPharm website"""
import requests
from bs4 import BeautifulSoup
import re

base_url = 'https://prices.super-pharm.co.il/'

print("🔍 Scanning ALL SuperPharm pages...")
print("=" * 80)

all_files = []
page = 1

while True:
    try:
        url = f"{base_url}?page={page}"
        print(f"📄 Scanning page {page}...")
        
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')
        
        page_files = []
        
        for link in soup.find_all('a', href=True):
            href = link['href']
            
            if '/Download/' not in href:
                continue
            
            filename = href.split('/')[-1].split('?')[0]
            
            # Extract file info
            if 'Price' in filename:
                match = re.search(r'(Price(?:Full)?)\d+-(\d+)-', filename)
                if match:
                    file_type = match.group(1)
                    store_code = match.group(2)
                    page_files.append({
                        'filename': filename,
                        'type': file_type,
                        'store': store_code,
                        'url': href
                    })
            elif 'Promo' in filename:
                match = re.search(r'(Promo(?:Full)?)\d+-(\d+)-', filename)
                if match:
                    file_type = match.group(1)
                    store_code = match.group(2)
                    page_files.append({
                        'filename': filename,
                        'type': file_type,
                        'store': store_code,
                        'url': href
                    })
        
        if not page_files:
            print(f"   No more files on page {page}")
            break
        
        print(f"   Found {len(page_files)} files")
        all_files.extend(page_files)
        page += 1
        
        # Safety limit
        if page > 50:
            print("   Reached safety limit of 50 pages")
            break
            
    except Exception as e:
        print(f"   Error on page {page}: {e}")
        break

print()
print("=" * 80)
print(f"📊 TOTAL RESULTS:")
print(f"   Total files found: {len(all_files)}")
print()

# Group by type
by_type = {}
by_store = {}

for f in all_files:
    file_type = f['type']
    store = f['store']
    
    if file_type not in by_type:
        by_type[file_type] = []
    by_type[file_type].append(f)
    
    if store not in by_store:
        by_store[store] = []
    by_store[store].append(f)

print("📁 BY FILE TYPE:")
for ftype, files in sorted(by_type.items()):
    print(f"   {ftype}: {len(files)} files")

print()
print("🏪 BY STORE:")
print(f"   Total stores: {len(by_store)}")

# Show sample stores
for store in sorted(by_store.keys())[:10]:
    files = by_store[store]
    types = set(f['type'] for f in files)
    print(f"   Store {store}: {len(files)} files ({', '.join(sorted(types))})")

print()
print("=" * 80)
print()
print("✅ READY TO IMPORT:")
print(f"   {len(all_files)} files total")
print(f"   {len(by_store)} stores")
print(f"   File types: {', '.join(sorted(by_type.keys()))}")
