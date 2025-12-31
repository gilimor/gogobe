
import os
import sys
import logging
import psycopg2
from datetime import datetime

# Add backend to path
sys.path.append(os.path.join(os.getcwd(), 'backend'))

try:
    from backend.scrapers.laib_catalog_scraper import LaibCatalogScraper
except ImportError:
    sys.path.append(os.path.join(os.getcwd(), 'backend', 'scrapers'))
    from laib_catalog_scraper import LaibCatalogScraper

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger("LaibImportRunner")

def clean_database():
    """Remove incorrectly registered chains"""
    try:
        conn = psycopg2.connect(
            dbname=os.getenv('DB_NAME', 'gogobe'),
            user=os.getenv('DB_USER', 'postgres'),
            password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
            host=os.getenv('DB_HOST', 'localhost'),
            port=os.getenv('DB_PORT', '5432')
        )
        cur = conn.cursor()
        
        # Remove Stop Market if it has Rami Levy's ID (or just remove it to be safe)
        cur.execute("DELETE FROM store_chains WHERE chain_name LIKE '%סטופ מרקט%'")
        deleted = cur.rowcount
        conn.commit()
        conn.close()
        
        if deleted > 0:
            logger.info(f"Cleaned up {deleted} incorrect chain registrations")
            
    except Exception as e:
        logger.error(f"Cleanup failed: {e}")

def run_scraper(name, name_he, slug, chain_id):
    logger.info(f"Starting import for {name}...")
    try:
        scraper = LaibCatalogScraper(
            chain_name=name,
            chain_slug=slug,
            chain_name_he=name_he,
            chain_id=chain_id
        )
        
        # Run import
        # Limit to 1 file for testing/demo purposes
        stats = scraper.import_files(file_type='prices_full', limit=1, download_dir=None)
        
        scraper.close()
        logger.info(f"Finished {name}: {stats}")
        return True
        
    except Exception as e:
        logger.error(f"Failed to run {name}: {e}")
        return False

def main():
    clean_database()
    
    chains = [
        # (Name, Hebrew Name, Slug, ID)
        ("Victory", "ויקטורי", "victory", "7290696200003"),
        ("Mahsanei HaShuk", "מחסני השוק", "mahsanei_hashuk", "7290661400001"),
        ("H. Cohen", "ח. כהן", "h_cohen", "7290455000004")
    ]
    
    success_count = 0
    for name, name_he, slug, chain_id in chains:
        if run_scraper(name, name_he, slug, chain_id):
            success_count += 1
            
    logger.info(f"Completed run. Successful: {success_count}/{len(chains)}")

if __name__ == "__main__":
    main()
