#!/usr/bin/env python3
"""
Test if we can access files without login by checking the actual file structure
"""
import requests
import urllib3
urllib3.disable_warnings()

base_url = "https://url.publishedprices.co.il"
chain_id = "7290058140886"  # Rami Levy

# Try accessing the JSON API without login
api_url = f"{base_url}/file/json/dir"

session = requests.Session()
session.headers.update({
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
})

print("Trying to access API without login...")
print(f"URL: {api_url}")

try:
    response = session.post(api_url, data={'cd': '/', 'iDisplayLength': 100}, verify=False, timeout=10)
    print(f"Status: {response.status_code}")
    print(f"Response: {response.text[:500]}")
except Exception as e:
    print(f"Error: {e}")

print("\n" + "="*80)
print("Trying direct file access...")
print("="*80)

# Try accessing a file directly
test_file = f"Stores{chain_id}-202512211900.gz"
file_url = f"{base_url}/file/d/{test_file}"

print(f"\nTrying: {file_url}")
try:
    response = session.get(file_url, verify=False, timeout=10, allow_redirects=False)
    print(f"Status: {response.status_code}")
    if response.status_code == 302:
        print(f"Redirected to: {response.headers.get('Location', 'Unknown')}")
    elif response.status_code == 200:
        print(f"SUCCESS! File size: {len(response.content)} bytes")
except Exception as e:
    print(f"Error: {e}")
