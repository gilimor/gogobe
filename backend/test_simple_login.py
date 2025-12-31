#!/usr/bin/env python3
"""
Simple login test - trying different approaches
"""
import requests
from bs4 import BeautifulSoup
import urllib3
urllib3.disable_warnings()

base_url = "https://url.publishedprices.co.il"

session = requests.Session()
session.headers.update({
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
})

# Step 1: Get login page
print("Step 1: Getting login page...")
response = session.get(f"{base_url}/login", verify=False)
soup = BeautifulSoup(response.content, 'html.parser')

# Extract CSRF token
csrf_meta = soup.find('meta', {'name': 'csrftoken'})
csrf_token = csrf_meta.get('content') if csrf_meta else None
print(f"CSRF Token: {csrf_token}")

# Step 2: Try login WITHOUT any CSRF handling
print("\nStep 2: Attempting simple login (no CSRF)...")
data = {
    'username': 'RamiLevi',
    'password': ''
}

response = session.post(
    f"{base_url}/login/user",
    data=data,
    verify=False,
    allow_redirects=True
)

print(f"Response URL: {response.url}")
print(f"Status: {response.status_code}")

# Check if logged in
soup = BeautifulSoup(response.content, 'html.parser')
logged_in_indicator = soup.find(string=lambda text: text and 'Not currently logged in' in text)

if logged_in_indicator:
    print("❌ Login FAILED - Still not logged in")
else:
    print("✅ Login might have succeeded!")
    
# Step 3: Try accessing /file
print("\nStep 3: Trying to access /file...")
response = session.get(f"{base_url}/file", verify=False)
print(f"File page status: {response.status_code}")
print(f"File page URL: {response.url}")

# Check if we're on the file manager page
if '/file' in response.url and '/login' not in response.url:
    print("✅ Successfully accessed file manager!")
    
    # Try to find file manager div
    soup = BeautifulSoup(response.content, 'html.parser')
    file_manager = soup.find('div', {'id': 'filemanager'})
    if file_manager:
        print("✅ Found file manager div!")
    else:
        print("⚠️  No file manager div found")
        # Save for inspection
        with open('/app/backend/file_page_after_login.html', 'w', encoding='utf-8') as f:
            f.write(response.text)
        print("Saved HTML to /app/backend/file_page_after_login.html")
else:
    print("❌ Redirected back to login")
