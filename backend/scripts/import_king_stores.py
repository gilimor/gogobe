
import os
import sys
import xml.etree.ElementTree as ET
import logging
from pathlib import Path

# Add backend to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from scrapers.bina_projects_scraper import BinaProjectsScraper
from scrapers.base_supermarket_scraper import ParsedStore

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("KingStoreImport")

class KingStoreImporter(BinaProjectsScraper):
    def import_stores_only(self):
        """Fetch and inspect Price header"""
        logger.info("Fetching Price Full file...")
        
        response = self.session.post(f"{self.base_url}/Main.aspx", data={'wFileType': '1', 'Button1': 'חפש'}, verify=False)
        
        # Dump to file
        with open("debug_king.html", "wb") as f:
            f.write(response.content)
            
        print(" dumped debug_king.html ")
        return
        
        if local_path.name.endswith('.gz') or local_path.name.endswith('.zip'):
             local_path = self.decompress_file(local_path)
             
        logger.info(f"Parsing {local_path}...")
        self.parse_and_save_stores(local_path)

    def parse_and_save_stores(self, file_path):
        try:
            tree = ET.parse(file_path)
            root = tree.getroot()
            
            # Navigate structure: Root/SubChains/SubChain/Stores/Store
            # Or sometimes: Root/Stores/Store
            
            stores_found = 0
            
            # Try generic "Store" tag search
            for store_node in root.findall('.//Store'):
                store_id = store_node.findtext('StoreId')
                if not store_id: continue
                
                name = store_node.findtext('StoreName') or store_node.findtext('StoreNm')
                address = store_node.findtext('Address')
                city = store_node.findtext('City')
                zip_code = store_node.findtext('ZipCode')
                
                # Check for messy data
                if name and "סניף" in name and not " - " in name and city:
                    # Pre-format helpful name
                    name = f"{name} - {city}"
                
                parsed = ParsedStore(
                    store_id=store_id,
                    name=name,
                    address=address,
                    city=city,
                    bikoret_no=store_node.findtext('BikoretNo')
                )
                
                logger.info(f"Found: {store_id} | {name} | {city}")
                self.get_or_create_store(parsed)
                stores_found += 1
                
            logger.info(f"Imported {stores_found} stores.")
            
        except Exception as e:
            logger.error(f"Failed to parse: {e}")

if __name__ == "__main__":
    scraper = KingStoreImporter(
        chain_name="King Store",
        chain_slug="kingstore",
        chain_name_he="קינג סטור",
        chain_id="7290172911110",
        subdomain="kingstore"
    )
    scraper.import_stores_only()
