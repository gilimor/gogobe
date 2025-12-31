#!/usr/bin/env python3
"""
Test SuperPharm Price file structure
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.superpharm_scraper import SuperPharmScraper
from pathlib import Path

scraper = SuperPharmScraper()

# Get all files
files = scraper.fetch_file_list()

print(f"\n📊 SuperPharm Files Analysis:")
print(f"=" * 60)
print(f"Total files: {len(files)}")

price_files = [f for f in files if f.file_type == 'Price']
promo_files = [f for f in files if f.file_type == 'Promo']

print(f"Price files: {len(price_files)}")
print(f"Promo files: {len(promo_files)}")
print()

if price_files:
    print("Price files:")
    for f in price_files:
        print(f"  - {f.filename} (Store: {f.store_code})")
    
    # Try to download and inspect first Price file
    print(f"\n📥 Downloading Price file...")
    price_file = price_files[0]
    
    filepath = scraper.download_file(price_file, Path(scraper.download_dir))
    if filepath:
        print(f"✓ Download to: {filepath}")
        
        # Decompress
        from pathlib import Path
        if Path(filepath).suffix in ['.gz']:
            filepath_decompressed = scraper.decompress_file(Path(filepath))
            print(f"✓ Decompressed to: {filepath_decompressed}")
            
            # Try to parse
            print(f"\n📄 Attempting to parse...")
            try:
                metadata, products = scraper.parse_file(filepath_decompressed)
                print(f"✅ SUCCESS!")
                print(f"   Metadata: {metadata}")
                print(f"   Products found: {len(products)}")
                
                if products:
                    print(f"\n📦 Sample product:")
                    print(f"   {products[0]}")
                    
                    # Check unique stores
                    stores = set()
                    for p in products[:100]:  # Check first 100
                        if 'store_id' in p:
                            stores.add(p['store_id'])
                    
                    if stores:
                        print(f"\n🏪 Stores in file: {len(stores)}")
                        print(f"   Sample stores: {list(stores)[:10]}")
                    
            except Exception as e:
                print(f"❌ Parse failed: {e}")
                import traceback
                traceback.print_exc()

print()
print("=" * 60)
