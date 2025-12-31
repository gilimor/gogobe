import requests
import re
import html

url = 'https://prices.shufersal.co.il/FileObject/UpdateCategory?catID=5&storeId=0'
print(f"Checking {url}")
try:
    r = requests.get(url, timeout=30)
    if r.status_code == 200:
        links = re.findall(r'href="([^"]+)"', r.text)
        print(f"Found {len(links)} links")
        for l in links:
            print(html.unescape(l))
    else:
        print(f"Status: {r.status_code}")
except Exception as e:
    print(e)
