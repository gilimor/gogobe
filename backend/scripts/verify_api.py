import requests
try:
    # Test 592 (Guerlain)
    r1 = requests.get('http://localhost:8000/api/products/search?master_id=592&limit=5')
    print(f"Master 592: Status {r1.status_code}")
    if r1.status_code == 200:
        data = r1.json()
        print(f"  Found {len(data.get('products', []))} products")
        if len(data.get('products', [])) > 0:
            print(f"  First: {data['products'][0]['name']}")

    # Test 586 (User Screenshot)
    r2 = requests.get('http://localhost:8000/api/products/search?master_id=586&limit=5')
    print(f"Master 586: Status {r2.status_code}")
    if r2.status_code == 200:
        data = r2.json()
        print(f"  Found {len(data.get('products', []))} products")
except Exception as e:
    print(f"Error: {e}")
