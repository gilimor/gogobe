
import requests
import json

try:
    print("Fetching prices...")
    r = requests.get("http://localhost:8000/api/prices?per_page=5&sort_by=scraped_at_desc", timeout=5)
    print(f"Status: {r.status_code}")
    data = r.json()
    prices = data.get('prices', [])
    print(f"Found {len(prices)} prices.")
    for p in prices:
        print(f"ID: {p.get('price_id')}")
        print(f"  Scraped At: {p.get('scraped_at')}")
        print(f"  Last Scraped At: {p.get('last_scraped_at')}")
        print(f"  Name: {p.get('product_name')}")
        print("---")
except Exception as e:
    print(f"Error: {e}")
