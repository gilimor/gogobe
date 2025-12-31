
import requests
from bs4 import BeautifulSoup

URL = "https://www.shijou-nippo.metro.tokyo.lg.jp/SN/SN_Top.html"

def probe():
    try:
        print(f"Fetching {URL}...")
        r = requests.get(URL, timeout=10)
        r.encoding = r.apparent_encoding
        
        soup = BeautifulSoup(r.text, 'html.parser')
        links = soup.find_all('a')
        print(f"Found {len(links)} links.")
        
        for a in links:
            href = a.get('href')
            text = a.text.strip().replace('\n', '')
            print(f" - {text} -> {href}")
            
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    probe()
