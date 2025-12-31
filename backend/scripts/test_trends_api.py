import requests
import json

try:
    resp = requests.get("http://localhost:8000/api/products/trends/analyze?days_back=2&min_change_pct=1")
    data = resp.json()
    print(f"Drops Count: {len(data.get('drops', []))}")
    print(f"Hikes Count: {len(data.get('hikes', []))}")
    if data.get('drops'):
        print(f"Sample Drop: {data['drops'][0]}")
except Exception as e:
    print(e)
