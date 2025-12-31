#!/usr/bin/env python3
"""
Test direct HTML scraping of file list
"""
import requests
from bs4 import BeautifulSoup
import urllib3
urllib3.disable_warnings()

base_url = "https://url.publishedprices.co.il"
chain_id = "7290058140886"  # Rami Levy

# Create session
session = requests.Session()
session.headers.update({
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
})

# Login
login_url = f"{base_url}/login"
print(f"Getting login page: {login_url}")
response = session.get(login_url, verify=False)
print(f"Login page status: {response.status_code}")

# Post login
data = {
    'username': 'RamiLevi',
    'password': ''
}
post_url = f"{base_url}/login/user"
print(f"\nPosting to: {post_url}")
response = session.post(post_url, data=data, verify=False, allow_redirects=True)
print(f"Login response status: {response.status_code}")
print(f"Final URL: {response.url}")

# Get file listing page
file_url = f"{base_url}/file"
print(f"\nGetting file page: {file_url}")
response = session.get(file_url, verify=False)
print(f"File page status: {response.status_code}")

# Parse HTML
soup = BeautifulSoup(response.content, 'html.parser')

# Look for file links
print("\n" + "="*80)
print("Looking for files containing chain ID:", chain_id)
print("="*80)

# Find all links
links = soup.find_all('a', href=True)
matching_files = []

for link in links:
    href = link.get('href', '')
    text = link.get_text(strip=True)
    
    # Look for files with our chain ID
    if chain_id in href or chain_id in text:
        matching_files.append({
            'href': href,
            'text': text
        })
        print(f"\nFound: {text}")
        print(f"  URL: {href}")

print(f"\n{'='*80}")
print(f"Total matching files found: {len(matching_files)}")
print(f"{'='*80}")

# Try to find the file manager div
file_manager = soup.find('div', {'id': 'filemanager'})
if file_manager:
    print("\nFound file manager div!")
    print(f"Content preview: {str(file_manager)[:500]}...")
else:
    print("\nNo file manager div found")
    
# Save HTML for inspection
with open('/app/backend/file_page.html', 'w', encoding='utf-8') as f:
    f.write(response.text)
print("\nSaved HTML to /app/backend/file_page.html")
