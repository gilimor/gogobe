import requests
from bs4 import BeautifulSoup
import re

bina_subdomains = [
    ("King Store", "kingstore"),
]

print("--- Debugging BinaProjects Chain IDs ---")
for name, sub in bina_subdomains:
    url = f"https://{sub}.binaprojects.com/Main.aspx"
    print(f"Checking {url}...")
    try:
        res = requests.get(url, timeout=15)
        soup = BeautifulSoup(res.content, 'html.parser')
        
        links = soup.find_all('a')
        print(f"Found {len(links)} links.")
        for l in links[:10]: # Print first 10
            print(f" - {l.text.strip()} -> {l.get('href')}")
            
    except Exception as e:
        print(f"Error: {e}")
