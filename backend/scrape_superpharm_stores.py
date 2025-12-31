#!/usr/bin/env python3
"""
Get SuperPharm store names from download page
"""
import requests
from bs4 import BeautifulSoup
import re

print("🏥 שליפת שמות סניפי SuperPharm מדף ההורדה")
print("=" * 80)
print()

base_url = 'https://prices.super-pharm.co.il/'

stores_data = {}

print("📡 סורק את דף ההורדות...")

# Scan multiple pages to get all stores
for page in range(1, 20):  # First 20 pages should be enough
    try:
        url = f"{base_url}?page={page}"
        response = requests.get(url, timeout=30)
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Find all rows in the table
        # The page has columns: מספר, שם, קטגוריה, תאריך, הורדה
        rows = soup.find_all('tr')
        
        page_stores = 0
        for row in rows:
            cells = row.find_all('td')
            if len(cells) >= 4:
                # Second column (index 1) should be the store name
                store_name_cell = cells[1]
                store_name = store_name_cell.get_text(strip=True)
                
                # Fourth column has the filename with store code
                filename_cell = cells[4] if len(cells) > 4 else cells[3]
                link = filename_cell.find('a')
                if link and 'href' in link.attrs:
                    filename = link['href'].split('/')[-1].split('?')[0]
                    
                    # Extract store code from filename
                    match = re.search(r'(?:Price|Promo)(?:Full)?\d+-(\d+)-', filename)
                    if match:
                        store_code = match.group(1)
                        
                        # Save store name
                        if store_code not in stores_data:
                            stores_data[store_code] = store_name
                            page_stores += 1
        
        if page_stores == 0:
            # No more stores found
            break
        
        print(f"   📄 עמוד {page}: נמצאו {page_stores} חנויות")
        
    except Exception as e:
        print(f"   ⚠️ שגיאה בעמוד {page}: {e}")
        break

print()
print(f"✅ סה\"כ נמצאו {len(stores_data)} חנויות SuperPharm")
print()

# Show first 10
print("דוגמאות:")
for i, (code, name) in enumerate(list(stores_data.items())[:10], 1):
    print(f"   {i}. קוד {code}: {name}")

print()

# Save to file for later use
import json
with open('/app/backend/superpharm_stores.json', 'w', encoding='utf-8') as f:
    json.dump(stores_data, f, ensure_ascii=False, indent=2)

print(f"💾 נשמר ל-superpharm_stores.json")
print()
print("=" * 80)
