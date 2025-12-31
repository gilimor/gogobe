import requests
import time

PRODUCT_ID = 78383
URL = f"http://localhost:8000/api/products/{PRODUCT_ID}"

print(f"Testing API speed for Product {PRODUCT_ID}...")
start = time.time()
try:
    res = requests.get(URL)
    duration = time.time() - start
    
    if res.status_code == 200:
        data = res.json()
        print(f"✅ Success! Time: {duration:.4f}s")
        print(f"Chain Stats: {len(data.get('chain_stats', []))}")
        print(f"Regional Stats: {len(data.get('regional_stats', []))}")
        print(f"Similar Products: {len(data.get('similar_products', []))}")
    else:
        print(f"❌ Failed: {res.status_code}")
        print(res.text)

except Exception as e:
    print(f"❌ Error: {e}")
