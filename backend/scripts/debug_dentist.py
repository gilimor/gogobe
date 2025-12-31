import requests
from bs4 import BeautifulSoup
import re

url = "https://www.arcespacedentaire.fr/"
# url = "https://www.doctolib.fr/dentiste/paris/leo-pierre-ruffino"

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Accept-Language': 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7'
}

print(f"Fetching {url}")
try:
    res = requests.get(url, headers=headers, timeout=10)
    print(f"Status: {res.status_code}")
    text = BeautifulSoup(res.text, 'html.parser').get_text()
    print(f"Text Length: {len(text)}")

    # Fixed Regex (Digit + Commas)
    regex = re.compile(r'([₪$€£฿])?\s*(\d[\d,]*\.?\d{0,2})\s*([₪$€£฿])?')
    found = regex.findall(text)
    print(f"Matches: {len(found)}")
    for f in found[:5]:
        print(f)
except Exception as e:
    print(f"Error: {e}")
