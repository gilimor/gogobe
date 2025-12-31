
import requests
import re
from bs4 import BeautifulSoup

URL = "https://www.shijou.metro.tokyo.lg.jp/torihiki/"

def explore():
    try:
        print(f"Fetching {URL}...")
        r = requests.get(URL, timeout=10)
        r.encoding = r.apparent_encoding
        
        soup = BeautifulSoup(r.text, 'html.parser')
        
        links = soup.find_all('a')
        print(f"Total links: {len(links)}")
        
        for a in links:
            href = a.get('href')
            text = a.text.strip().replace('\n', '')
            if href and ('shikyo' in href or 'csv' in href or 'xls' in href or 'daily' in text or '市況' in text):
                print(f"Match: {text} -> {href}")

    except Exception as e:
        print(f"Error: {e}")
            
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    explore()
