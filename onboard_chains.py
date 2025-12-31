
import requests
import re
import logging
import psycopg2
import os
from datetime import datetime
from bs4 import BeautifulSoup
from urllib.parse import urlparse

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
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
        })
        
    def close(self):
        if self.conn:
            self.conn.close()

    def discover_bina_id(self, subdomain):
        """Discover Chain ID from BinaProjects subdomain"""
        url = f"https://{subdomain}.binaprojects.com/Main.aspx"
        logger.info(f"Discovering ID for {subdomain} at {url}...")
        try:
            response = self.session.get(url, timeout=30)
            if response.status_code != 200:
                logger.error(f"Failed to reach {url}: {response.status_code}")
                return None
                
            # Look for file links regex: Price(\d+)-...
            # Example: Price7290172911110-001-...
            match = re.search(r'Price(\d{10,14})-', response.text)
            if match:
                chain_id = match.group(1)
                logger.info(f"Found ID for {subdomain}: {chain_id}")
                return chain_id
            
            # Fallback: look for generic xml/gz links and try to parse
            soup = BeautifulSoup(response.content, 'html.parser')
            for a in soup.find_all('a', href=True):
                href = a['href']
                match = re.search(r'Price(\d{10,14})-', href)
                if match:
                    chain_id = match.group(1)
                    logger.info(f"Found ID for {subdomain}: {chain_id}")
                    return chain_id
                    
            logger.warning(f"No ID found for {subdomain}")
            return None
        except Exception as e:
            logger.error(f"Error discovering {subdomain}: {e}")
            return None

    def discover_published_id(self, username, password=""):
        """Discover Chain ID from PublishedPrices login"""
        base_url = "https://url.publishedprices.co.il"
        # Special cases for different base URLs
        if "Stop_Market" in username:
            base_url = "https://url.retail.publishedprices.co.il"
        elif "yuda" in username:
            base_url = "https://publishedprices.co.il"
            
        logger.info(f"Discovering ID for {username} at {base_url}...")
        
        try:
            # Login
            login_url = f"{base_url}/login"
            self.session.cookies.clear()
            
            # 1. GET login for CSRF/Cookies
            self.session.get(login_url, verify=False, timeout=30)
            
            # 2. POST login
            payload = {'username': username, 'password': password}
            # Add some common CSRF logic if needed, but simple usually works for discovery
            # The working scraper uses specific headers, let's mimic them minimally
            headers = {
                'Origin': base_url,
                'Referer': login_url
            }
            res = self.session.post(login_url, data=payload, headers=headers, verify=False, allow_redirects=True)
            
            if res.status_code != 200:
                logger.error(f"Login failed: {res.status_code}")
                return None
                
            # 3. List files via API
            api_url = f"{base_url}/file/json/dir"
            api_payload = {'cd': '/', 'iDisplayLength': 50, 'sEcho': 1}
            api_headers = {
                'X-Requested-With': 'XMLHttpRequest',
                'Referer': f"{base_url}/file"
            }
            
            res = self.session.post(api_url, data=api_payload, headers=api_headers, verify=False)
            data = res.json()
            
            if 'aaData' in data:
                # Look for Price file
                for item in data['aaData']:
                    name = item.get('name', '') or item.get('fname', '')
                    match = re.search(r'Price(\d{10,14})-', name)
                    if match:
                         chain_id = match.group(1)
                         logger.info(f"Found ID for {username}: {chain_id}")
                         return chain_id
            
            logger.warning(f"No files/ID found for {username}")
            return None
            
        except Exception as e:
             logger.error(f"Error discovering {username}: {e}")
             return None

    def register_chain(self, name, name_he, chain_code, scraper_type, params):
        """Register chain in database"""
        if not chain_code:
            logger.warning(f"Skipping registration for {name} - No Chain Code")
            return
            
        try:
            cur = self.conn.cursor()
            
            # Insert into store_chains
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
            
            logger.info(f"Registered {name} (ID: {chain_id})")
            
            # Prepare scraper run command/script
            # We can print it out for now
            return chain_id
            
        except Exception as e:
            logger.error(f"Failed to register {name}: {e}")
            self.conn.rollback()

def main():
    onboarder = ChainOnboarder()
    
    # 1. BinaProjects Chains
    bina_candidates = [
        ("King Store", "קינג סטור", "kingstore"),
        ("Maayan 2000", "מעיין 2000", "maayan2000"),
        ("Good Pharm", "גוד פארם", "goodpharm"),
        ("Super Sapir", "סופר ספיר", "supersapir"),
        ("Super Bareket", "סופר ברקת", "superbareket"),
        ("Shuk HaIr", "שוק העיר", "shuk-hayir"),
        # "City Market": "citymarketkiryatgat", # might be store specific
        # "Shefa Birkat Hashem": "shefabirkathashem",
    ]
    
    print("\n--- Onboarding BinaProjects Chains ---")
    for name, name_he, subdomain in bina_candidates:
        chain_code = onboarder.discover_bina_id(subdomain)
        if chain_code:
            onboarder.register_chain(name, name_he, chain_code, "bina_projects", {"subdomain": subdomain})
            
    # 2. PublishedPrices Chains
    # (Simplified list for first pass)
    pp_candidates = [
        ("Dor Alon", "דור אלון", "doralon", ""),
        ("Tiv Taam", "טיב טעם", "TivTaam", ""),
        ("Yohananof", "יוחננוף", "yohananof", ""),
        ("Osher Ad", "אושר עד", "osherad", ""),
        ("Fresh Market", "פרש מרקט", "freshmarket", ""),
        ("Keshet Teamim", "קשת טעמים", "Keshet", ""),
        ("Rami Levy", "רמי לוי", "RamiLevi", ""), # Already have, but good to re-verify
    ]
    
    print("\n--- Onboarding PublishedPrices Chains ---")
    import urllib3
    urllib3.disable_warnings() 
    
    for name, name_he, user, password in pp_candidates:
        chain_code = onboarder.discover_published_id(user, password)
        if chain_code:
            onboarder.register_chain(name, name_he, chain_code, "published_prices", {"user": user, "pass": password})

    # 3. LaibCatalog Chains (Known IDs)
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
