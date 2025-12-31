#!/usr/bin/env python3
"""
Login test WITH CSRF token
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

# Step 2: Login WITH CSRF token in cookie
print("\nStep 2: Setting CSRF cookie and attempting login...")

# Set the CSRF token as a cookie
if csrf_token:
    session.cookies.set('csrftoken', csrf_token, domain='url.publishedprices.co.il', path='/')
    print(f"Set csrftoken cookie: {csrf_token}")

data = {
    'username': 'RamiLevi',
    'password': '',
    'r': '/file'  # Redirect target after login
}

headers = {
    'Referer': f"{base_url}/login",
    'Origin': base_url,
    'Content-Type': 'application/x-www-form-urlencoded',
}

response = session.post(
    f"{base_url}/login/user",
    data=data,
    headers=headers,
    verify=False,
    allow_redirects=True
)

print(f"Response URL: {response.url}")
print(f"Status: {response.status_code}")

# Check cookies
print(f"\nCookies after login:")
for cookie in session.cookies:
    print(f"  {cookie.name} = {cookie.value[:50]}...")

# Check if logged in
soup = BeautifulSoup(response.content, 'html.parser')
logged_in_indicator = soup.find(string=lambda text: text and 'Not currently logged in' in text)

if logged_in_indicator:
    print("\n❌ Login FAILED - Still not logged in")
    
    # Check for error messages
    error_div = soup.find('div', class_='alert-danger')
    if error_div:
        print(f"Error message: {error_div.get_text(strip=True)}")
else:
    print("\n✅ Login might have succeeded!")
    
# Step 3: Try accessing /file
print("\nStep 3: Trying to access /file...")
response = session.get(f"{base_url}/file", verify=False)
print(f"File page status: {response.status_code}")
print(f"File page URL: {response.url}")

if '/file' in response.url and '/login' not in response.url:
    print("✅ Successfully accessed file manager!")
else:
    print("❌ Still redirected to login")
