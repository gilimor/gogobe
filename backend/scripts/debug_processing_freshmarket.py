
import sys
import logging
from pathlib import Path

# Add backend to path
sys.path.append(str(Path(__file__).parent.parent))

from scrapers.fresh_market_scraper import FreshMarketScraper
from scrapers.base_supermarket_scraper import FileMetadata

# Setup logging
logging.basicConfig(level=logging.INFO)

class DebugFreshMarketScraper(FreshMarketScraper):
    def fetch_file_list(self, file_type='prices', limit=None):
        print("DEBUG: Returning hardcoded file list...")
        # URL for Price7290876100000-029-202512250900.gz
        # Assuming standard pattern: /file/d/FILENAME
        filename = "Price7290876100000-029-202512250900.gz"
        url = f"https://url.publishedprices.co.il/file/d/{filename}"
        
        return [FileMetadata(
            url=url,
            filename=filename,
            file_type=file_type
        )]

def run():
    print("Running Debug Fresh Market Scraper...")
    scraper = DebugFreshMarketScraper()
    
    # Reset tracker to force process
    filename = "Price7290876100000-029-202512250900.gz"
    print(f"Resetting status for {filename}...")
    try:
        conn = scraper.get_db_connection()
        cur = conn.cursor()
        cur.execute("UPDATE file_processing_log SET status='pending' WHERE filename=%s", (filename,))
        conn.commit()
        conn.close()
    except Exception as e:
        print(f"Failed to reset DB: {e}")

    # Login is needed for download
    scraper.login()
    
    print("Starting import_files...")
    stats = scraper.import_files()
    print(f"Stats: {stats}")

if __name__ == "__main__":
    run()
