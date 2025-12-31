import requests
from bs4 import BeautifulSoup
import re
import json

URL = "https://bilu.co.il/"
HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
}

def clean_price(text):
    # Extract digits
    match = re.search(r'(\d+)', text)
    if match:
        return float(match.group(1))
    return None

def scrape_bilu():
    print(f"Fetching {URL}...")
    try:
        res = requests.get(URL, headers=HEADERS, timeout=15)
        print(f"Status: {res.status_code}")
        if res.status_code != 200:
            print("Failed to fetch.")
            return

        soup = BeautifulSoup(res.text, 'html.parser')
        
        # Strategy 1: Look for "Menu Item" classes (Elementor/General)
        # Common classes: elementor-menu-anchor, price-list, menu-item
        
        items = []
        
        # Test: Find generic containers with price pattern inside
        # Iterate all elements that contain a number
        # This is slow, better: Find lowest-level elements with digits
        
        potential_prices = soup.find_all(string=re.compile(r'\d+'))
        print(f"Found {len(potential_prices)} text nodes with numbers.")
        
        for p_text in potential_prices:
            val = clean_price(p_text)
            if not val or val < 10 or val > 500: continue
            
            # This node is a price candidate.
            # Look at its parent. DOM Proximity!
            parent = p_text.parent
            
            # Name should be close (Previous text sibling, or sibling element)
            # 1. Check Previous Sibling Text
            name_candidate = None
            
            # Traverse siblings backwards
            prev = parent.find_previous_sibling()
            if prev:
                name_candidate = prev.get_text(strip=True)
            else:
                # Check text usage in same parent (if complex structure)
                # Or check parent's previous sibling
                parent_prev = parent.parent.find_previous_sibling()
                if parent_prev:
                    name_candidate = parent_prev.get_text(strip=True)
            
            if name_candidate and len(name_candidate) > 2 and len(name_candidate) < 100:
                # Exclude garbage
                if any(x in name_candidate for x in ['Street', 'Tel', 'sz']): continue
                
                print(f"Candidate: {name_candidate} - {val} ILS")
                items.append((name_candidate, val))
                
        print(f"Total Items Found: {len(items)}")
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    scrape_bilu()
