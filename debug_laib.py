
import requests
from bs4 import BeautifulSoup

def debug_laib():
    url = "https://laibcatalog.co.il/"
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }
    
    try:
        print(f"Fetching {url}...")
        response = requests.get(url, headers=headers, timeout=30)
        print(f"Status: {response.status_code}")
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        view_state = soup.find('input', id='__VIEWSTATE')
        event_validation = soup.find('input', id='__EVENTVALIDATION')
        
        print(f"ViewState found: {bool(view_state)}")
        print(f"EventValidation found: {bool(event_validation)}")
        
        if not view_state:
            print("Inputs found on page:")
            for inp in soup.find_all('input'):
                print(f"  {inp.get('id')} / {inp.get('name')}")
                
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    debug_laib()
