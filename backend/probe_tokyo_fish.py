
import requests
from bs4 import BeautifulSoup

# Correct URL construction
# Base: https://www.shijou-nippo.metro.tokyo.lg.jp/SN/
# Rel: 202512/20251226/Sui/SN_Sui_Zen_index.html
URL = "https://www.shijou-nippo.metro.tokyo.lg.jp/SN/202512/20251226/Sui/SN_Sui_Zen_index.html"

def probe_page():
    try:
        print(f"Fetching {URL}...")
        r = requests.get(URL, timeout=10)
        r.encoding = r.apparent_encoding
        
        soup = BeautifulSoup(r.text, 'html.parser')
        
        # Look for CSV links?
        links = soup.find_all('a')
        print(f"Found {len(links)} links on Fish Page.")
        
        for a in links:
            href = a.get('href')
            text = a.text.strip()
            print(f"LINK: {text} -> {href}")
        
        # Look for Tables?
        tables = soup.find_all('table')
        print(f"Found {len(tables)} tables.")
        if tables:
            # Check headers in Table 2 or 3?
            # Usually Table 1 is metadata. Table 2 is data.
            for i, tbl in enumerate(tables):
                print(f"\n--- Table {i+1} ---")
                rows = tbl.find_all('tr')
                for row in rows[:5]:
                    cells = [c.text.strip().replace('\n', '') for c in row.find_all(['td', 'th'])]
                    print(cells)

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    probe_page()
