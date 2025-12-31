
import requests
import re
import logging
import psycopg2
import os
import sys
from pathlib import Path

# Add backend to path
sys.path.append(os.path.join(os.getcwd(), 'backend'))

# Import Scrapers
try:
    from backend.scrapers.published_prices_scraper import PublishedPricesScraper
except ImportError as e:
    print(f"Import Error: {e}")
    # Handle direct import if needed
    sys.path.append(os.path.join(os.getcwd(), 'backend', 'scrapers'))
    from published_prices_scraper import PublishedPricesScraper

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger("ChainOnboarder")

class ChainOnboarder:
    def __init__(self):
        self.conn = psycopg2.connect(
            dbname=os.getenv('DB_NAME', 'gogobe'),
            user=os.getenv('DB_USER', 'postgres'),
            password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
            host=os.getenv('DB_HOST', 'localhost'),
            port=os.getenv('DB_PORT', '5432')
        )
        
    def close(self):
        if self.conn:
            self.conn.close()

    def discover_published_id(self, username, password):
        """Discover Chain ID using PublishedPricesScraper logic"""
        logger.info(f"Discovering ID for {username}...")
        
        # Use a dummy ID initially
        scraper = PublishedPricesScraper(
            chain_name="Temp",
            chain_slug="temp",
            chain_name_he="Temp",
            chain_id="0000000000000",
            platform_user=username,
            platform_pass=password
        )
        
        # Handle special base URLs
        if "Stop_Market" in username:
            scraper.base_url = "https://url.retail.publishedprices.co.il"
        elif "yuda" in username:
            scraper.base_url = "https://publishedprices.co.il"
            
        try:
            # Login
            if not scraper.login():
                logger.error(f"Login failed for {username}")
                return None
                
            # List files
            files = scraper.fetch_file_list(file_type='prices_full', limit=50)
            
            for file_meta in files:
                # Extract ID from filename: Price[ID]-...
                match = re.search(r'Price(\d{10,14})', file_meta.filename)
                if match:
                    chain_id = match.group(1)
                    logger.info(f"Found ID for {username}: {chain_id}")
                    return chain_id
                    
            logger.warning(f"No ID found in {len(files)} files for {username}")
            return None
            
        except Exception as e:
            logger.error(f"Error discovering {username}: {e}")
            return None

    def register_chain(self, name, name_he, chain_code, scraper_type, params):
        """Register chain in database"""
        if not chain_code:
            logger.warning(f"Skipping {name} - No Chain Code")
            return
            
        try:
            cur = self.conn.cursor()
            
            # Upsert into store_chains
            cur.execute("""
                INSERT INTO store_chains (chain_name, chain_code, is_active, country_code)
                VALUES (%s, %s, TRUE, 'IL')
                ON CONFLICT (chain_code) DO UPDATE 
                SET chain_name = EXCLUDED.chain_name
                RETURNING id;
            """, (name_he, chain_code))
            
            chain_id = cur.fetchone()[0]
            self.conn.commit()
            cur.close()
            
            logger.info(f"Registered {name} (ID: {chain_id}, Code: {chain_code})")
            return chain_id
            
        except Exception as e:
            logger.error(f"Failed to register {name}: {e}")
            self.conn.rollback()

def main():
    onboarder = ChainOnboarder()
    
    # 1. PublishedPrices Chains
    pp_candidates = [
        ("Dor Alon", "דור אלון", "doralon", ""),
        ("Tiv Taam", "טיב טעם", "TivTaam", ""),
        ("Yohananof", "יוחננוף", "yohananof", ""),
        ("Osher Ad", "אושר עד", "osherad", ""),
        ("Fresh Market", "פרש מרקט", "freshmarket", ""),
        ("Keshet Teamim", "קשת טעמים", "Keshet", ""),
        ("Stop Market", "סטופ מרקט", "Stop_Market", ""),
        # "Politzer", "פוליצר", "politzer", ""
        # "Super Yuda", "סופר יודה", "yuda_ho", "Yud@147"
    ]
    
    print("\n--- Onboarding PublishedPrices Chains ---")
    for name, name_he, user, password in pp_candidates:
        chain_code = onboarder.discover_published_id(user, password)
        if chain_code:
            onboarder.register_chain(name, name_he, chain_code, "published_prices", {"user": user, "pass": password})

    # 2. LaibCatalog Chains (Fixed IDs)
    laib_candidates = [
        ("Victory", "ויקטורי", "7290696200003"),
        ("Mahsanei HaShuk", "מחסני השוק", "7290661400001"),
        ("H. Cohen", "ח. כהן", "7290455000004"),
    ]
    
    print("\n--- Onboarding LaibCatalog Chains ---")
    for name, name_he, code in laib_candidates:
        onboarder.register_chain(name, name_he, code, "laib_catalog", {})

    onboarder.close()

if __name__ == "__main__":
    main()
