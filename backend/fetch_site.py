
import requests
import sys

url = "https://cezar.co.il/business-menu/"
headers = {'User-Agent': 'Mozilla/5.0'}

try:
    print(f"Fetching {url}...")
    res = requests.get(url, headers=headers)
    res.raise_for_status()
    
    output_path = '/app/backend/cezar_raw.html'
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(res.text)
    
    print(f"Saved {len(res.text)} bytes to {output_path}")
    
    # Simple peek
    print("\nPreview:")
    print(res.text[:500])
    
except Exception as e:
    print(f"Error: {e}")
