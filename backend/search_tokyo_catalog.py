
import requests
from bs4 import BeautifulSoup

# Search URL for "Central Wholesale Market"
SEARCH_URL = "https://catalog.data.metro.tokyo.lg.jp/dataset?q=%E4%B8%AD%E5%A4%AE%E5%8D%B8%E5%A3%B2%E5%B8%82%E5%A0%B4" # "Central Wholesale Market" in Japanese

def search():
    try:
        print(f"Searching {SEARCH_URL}...")
        r = requests.get(SEARCH_URL, timeout=10)
        soup = BeautifulSoup(r.text, 'html.parser')
        
        # Find dataset links
        datasets = soup.find_all('h2', class_='dataset-heading')
        print(f"Found {len(datasets)} datasets.")
        
        for ds in datasets:
            a = ds.find('a')
            if a:
                title = a.text.strip()
                link = "https://catalog.data.metro.tokyo.lg.jp" + a.get('href')
                print(f"Dataset: {title} -> {link}")
                
                # Visit the dataset to find resources (CSVs)
                r_ds = requests.get(link, timeout=10)
                soup_ds = BeautifulSoup(r_ds.text, 'html.parser')
                resources = soup_ds.find_all('li', class_='resource-item')
                for res in resources:
                    res_a = res.find('a', class_='heading')
                    if res_a:
                        res_title = res_a.text.strip()
                        # Resource page
                        res_link = "https://catalog.data.metro.tokyo.lg.jp" + res_a.get('href')
                        # Find download button
                        # Usually /download/ in url
                        print(f"  - Resource: {res_title} -> {res_link}")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    search()
