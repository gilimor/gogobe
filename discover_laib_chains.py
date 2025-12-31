
import requests
from bs4 import BeautifulSoup

def discover_laib_chains():
    url = "https://laibcatalog.co.il/"
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }
    
    try:
        response = requests.get(url, headers=headers, timeout=30)
        soup = BeautifulSoup(response.content, 'html.parser')
        
        chain_select = soup.find('select', id='MainContent_chain')
        if not chain_select:
            print("Could not find chain selection dropdown")
            return
            
        with open("discover_laib_chains.txt", "w", encoding="utf-8") as f:
            f.write("Available LaibCatalog Chains:\n")
            f.write("-----------------------------\n")
            for option in chain_select.find_all('option'):
                name = option.get_text(strip=True)
                value = option.get('value')
                if value and value != '0':
                    f.write(f"Chain: {name}, ID: {value}\n")
        print("Written to discover_laib_chains.txt")
                
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    discover_laib_chains()
