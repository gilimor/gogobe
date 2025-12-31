#!/usr/bin/env python3
"""
Test direct file access without login
"""
import requests
from datetime import datetime, timedelta

# Try to access files directly without login
base_url = "https://url.publishedprices.co.il"

# Rami Levy chain ID
chain_id = "7290058140886"

# Try to build file URLs directly
# Pattern: /file/d/{filename}
# Example filename: Price7290058140886-001-202512211900.gz

# Try today and yesterday
for days_ago in range(2):
    date = datetime.now() - timedelta(days=days_ago)
    date_str = date.strftime('%Y%m%d')
    
    # Try different hours
    for hour in ['1900', '0300', '2100']:
        # Try Stores file
        stores_filename = f"Stores{chain_id}-{date_str}{hour}.gz"
        stores_url = f"{base_url}/file/d/{stores_filename}"
        
        print(f"\nTrying: {stores_url}")
        try:
            response = requests.head(stores_url, timeout=5, verify=False)
            print(f"  Status: {response.status_code}")
            if response.status_code == 200:
                print(f"  ✅ FOUND! {stores_filename}")
                print(f"  Size: {response.headers.get('Content-Length', 'unknown')}")
                break
        except Exception as e:
            print(f"  Error: {e}")
    
    # Try Price file
    for store_num in ['001', '002', '003']:
        price_filename = f"Price{chain_id}-{store_num}-{date_str}{hour}.gz"
        price_url = f"{base_url}/file/d/{price_filename}"
        
        print(f"\nTrying: {price_url}")
        try:
            response = requests.head(price_url, timeout=5, verify=False)
            print(f"  Status: {response.status_code}")
            if response.status_code == 200:
                print(f"  ✅ FOUND! {price_filename}")
                print(f"  Size: {response.headers.get('Content-Length', 'unknown')}")
        except Exception as e:
            print(f"  Error: {e}")

print("\n" + "="*80)
print("If files are found with status 200, we can download them directly!")
print("="*80)
