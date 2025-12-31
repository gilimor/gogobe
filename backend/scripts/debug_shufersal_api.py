
import requests
import re
import sys

print('Analyzing Shufersal API...')

session = requests.Session()
session.headers.update({
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
    'X-Requested-With': 'XMLHttpRequest',
    'Referer': 'https://prices.shufersal.co.il/'
})

try:
    # URL that returns the table rows for "PricesFull" category
    url = 'https://prices.shufersal.co.il/FileObject/UpdateCategory?catID=2&storeId=0'
    response = session.get(url, timeout=30)
    
    if response.status_code == 200:
        content = response.text
        if 'PriceFull' in content:
            print('✓ Found PriceFull files!')
            # Extract links using regex
            links = re.findall(r'href="([^"]+)"', content)
            print(f'Found {len(links)} links total.')
            
            # Filter for PriceFull .gz files
            price_links = [l for l in links if 'PriceFull' in l and '.gz' in l]
            print(f'Found {len(price_links)} valid PriceFull .gz files.')
            
            print('First 5 links:')
            for link in price_links[:5]:
                print(f'  - {link}')
        else:
            print('✗ No PriceFull files found in response')
            print(content[:500])
    else:
        print(f'Error: Status code {response.status_code}')

except Exception as e:
    print(f'Error: {e}')
