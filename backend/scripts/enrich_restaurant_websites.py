import json
import sys
import requests
import time
from bs4 import BeautifulSoup
from urllib.parse import urlparse

# Aggregators to skip (we prefer official sites)
SKIP_DOMAINS = [
    'tripadvisor', 'easy.co.il', 'rest.co.il', 'ontopo', 'wolt', '10bis', 
    'facebook', 'instagram', 'zap', 'mishloha', 'tabit', 't.co', 'youtube'
]

def search_duckduckgo(query):
    try:
        url = "https://html.duckduckgo.com/html/"
        headers = {'User-Agent': 'Mozilla/5.0'}
        data = {'q': query}
        res = requests.post(url, data=data, headers=headers)
        res.raise_for_status()
        
        soup = BeautifulSoup(res.text, 'html.parser')
        results = soup.find_all('a', class_='result__a')
        
        for link in results:
            href = link.get('href')
            if not href: continue
            
            # Simple check to skip aggregators
            domain = urlparse(href).netloc.lower()
            if any(skip in domain for skip in SKIP_DOMAINS):
                continue
                
            return href
            
    except Exception as e:
        print(f"Error searching {query}: {e}")
    return None

def enrich_restaurants(city):
    input_file = f"/app/backend/discovered_{city}.json"
    output_file = f"/app/backend/enriched_{city}.json"
    
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            restaurants = json.load(f)
    except FileNotFoundError:
        print(f"File {input_file} not found.")
        return

    enriched_count = 0
    
    for r in restaurants:
        name = r.get('name')
        if not name: continue
        
        print(f"Searching for: {name}...")
        # Search query: "Name City"
        query = f"{name} {city}"
        url = search_duckduckgo(query)
        
        if url:
            print(f"  Found: {url}")
            r['website'] = url
            enriched_count += 1
        else:
            print("  No suitable website found.")
        
        # Be nice
        time.sleep(1) 

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(restaurants, f, ensure_ascii=False, indent=2)
        
    print(f"Enriched {enriched_count} / {len(restaurants)} items.")
    print(f"Saved to {output_file}")

if __name__ == "__main__":
    city = sys.argv[1] if len(sys.argv) > 1 else "Rehovot"
    enrich_restaurants(city)
