
import requests
from bs4 import BeautifulSoup

# URL: Toyosu Fish Index
# Base: https://www.shijou-nippo.metro.tokyo.lg.jp/SN/
# Rel: 202512/20251226/Sui/SN_Sui_Toyosu_index.html
URL = "https://www.shijou-nippo.metro.tokyo.lg.jp/SN/202512/20251226/Sui/SN_Sui_Toyosu_index.html"

def probe_toyosu():
    try:
        print(f"Fetching {URL}...")
        r = requests.get(URL, timeout=10)
        r.encoding = r.apparent_encoding
        
        soup = BeautifulSoup(r.text, 'html.parser')
        
        # Look for CSV links
        links = soup.find_all('a')
        print(f"Found {len(links)} links on Toyosu Page.")
        
        for a in links:
            href = a.get('href')
            text = a.text.strip()
            if href and ('csv' in href.lower() or 'xls' in href.lower()):
                print(f"FILE MATCH: {text} -> {href}")
        
        # Look for Tables (Price?)
        tables = soup.find_all('table')
        print(f"Found {len(tables)} tables.")
        if tables:
            for i, tbl in enumerate(tables):
                print(f"\n--- Table {i+1} ---")
                rows = tbl.find_all('tr')
                # Headers
                headers = [c.text.strip().replace('\n', '') for c in rows[0].find_all(['td', 'th'])]
                print(headers)
                # First Data Row
                if len(rows) > 1:
                     drow = [c.text.strip().replace('\n', '') for c in rows[1].find_all(['td', 'th'])]
                     print(drow)

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    probe_toyosu()
