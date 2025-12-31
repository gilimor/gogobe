
import sys
import gzip
from pathlib import Path

# Add backend to path
sys.path.append(str(Path(__file__).parent.parent))

from scrapers.fresh_market_scraper import FreshMarketScraper

def debug_freshmarket():
    print("Initializing Fresh Market Scraper...")
    scraper = FreshMarketScraper()
    
    print("Logging in...")
    if not scraper.login():
        print("Login failed!")
        return

    print("Fetching files...")
    files = scraper.fetch_file_list(limit=1)
    
    if not files:
        print("No files found!")
        return
        
    f = files[0]
    print(f"Downloading {f.filename}...")
    
    # Download
    download_dir = Path("data/debug_freshmarket")
    download_dir.mkdir(parents=True, exist_ok=True)
    local_path = scraper.download_file(f, download_dir)
    
    # Unzip
    print(f"Unzipping {local_path}...")
    with gzip.open(local_path, 'rb') as f_in:
        content = f_in.read()
        
    xml_path = local_path.with_suffix('.xml')
    with open(xml_path, 'wb') as f_out:
        f_out.write(content)
        
    print(f"Reading first 50 lines of {xml_path}...")
    with open(xml_path, 'r', encoding='utf-8') as f:
        for i in range(50):
            print(f.readline().strip())

if __name__ == "__main__":
    debug_freshmarket()
