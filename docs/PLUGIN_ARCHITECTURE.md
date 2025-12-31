"""
PLUGIN-BASED SCRAPER ARCHITECTURE
==================================

Each supplier has:
1. Different file download mechanism
2. Different XML/data structure
3. Different file naming conventions
4. Different update frequencies

This base class provides the FRAMEWORK.
Each scraper implements ONLY what's unique to them.
"""

from abc import ABC, abstractmethod
from typing import List, Dict, Optional
from dataclasses import dataclass

@dataclass
class FileMetadata:
    """Generic file metadata - same for all suppliers"""
    filename: str
    url: str
    store_code: str
    file_type: str = 'price'  # price, promo, store, etc.

class SupplierScraperPlugin(ABC):
    """
    Base plugin for supplier scrapers
    
    Each supplier MUST implement:
    - fetch_file_list() - HOW to discover files
    - parse_file() - HOW to extract data from file
    
    Can optionally override:
    - download_file() - if custom download logic needed
    - get_store_name() - if custom store naming
    """
    
    def __init__(self, supplier_name: str):
        self.supplier_name = supplier_name
        self.download_dir = f'data/{supplier_name.lower()}'
    
    @abstractmethod
    def fetch_file_list(self, file_type: str = 'price', limit: int = None) -> List[FileMetadata]:
        """
        MUST IMPLEMENT: How to discover available files
        
        Examples:
        - Shufersal: Scrape https://prices.shufersal.co.il/
        - SuperPharm: Scrape https://prices.super-pharm.co.il/
        - Rami Levy: Login + API call to publishedprices.co.il
        - Victory: FTP server listing
        - Custom Chain: REST API endpoint
        
        Returns list of FileMetadata objects
        """
        pass
    
    @abstractmethod
    def parse_file(self, filepath: str) -> List[Dict]:
        """
        MUST IMPLEMENT: How to parse file and extract products
        
        Each supplier has different structure:
        
        Shufersal XML:
        <Root>
          <Items>
            <Item>ItemCode, ItemName, ItemPrice...</Item>
          </Items>
        </Root>
        
        SuperPharm Price XML:
        <Envelope>
          <Products>
            <Product>Code, Name, Price...</Product>
          </Products>
        </Envelope>
        
        SuperPharm Promo XML:
        <Promotions>
          <Promo>PromoCode, Items, Discount...</Promo>
        </Promotions>
        
        Rami Levy JSON:
        {
          "products": [
            {"id": "...", "name": "...", "price": ...}
          ]
        }
        
        Victory CSV:
        SKU,Name,Price,Category
        123,Product,10.50,Food
        
        Returns list of dicts with standardized fields:
        {
            'item_code': '...',
            'item_name': '...',
            'price': 10.50,
            'manufacturer_item_description': '...',
            # ... other fields
        }
        """
        pass
    
    def download_file(self, file_metadata: FileMetadata) -> str:
        """
        OPTIONAL OVERRIDE: Custom download logic
        
        Default: Simple HTTP GET
        Override for:
        - FTP downloads (Victory)
        - Authenticated downloads (Rami Levy)
        - Special headers/cookies (some suppliers)
        - Azure Blob Storage (if applicable)
        """
        import requests
        import os
        
        response = requests.get(file_metadata.url, timeout=30)
        response.raise_for_status()
        
        filepath = os.path.join(self.download_dir, file_metadata.filename)
        os.makedirs(self.download_dir, exist_ok=True)
        
        with open(filepath, 'wb') as f:
            f.write(response.content)
        
        return filepath
    
    def get_store_name(self, store_code: str) -> str:
        """
        OPTIONAL OVERRIDE: Custom store naming
        
        Default: "{supplier} - Store {code}"
        Override for:
        - Known store mappings
        - API lookup
        - Database of store names
        """
        return f"{self.supplier_name} - Store {store_code}"


# EXAMPLE IMPLEMENTATIONS:
# ========================

class ShufersalPlugin(SupplierScraperPlugin):
    """Shufersal implementation"""
    
    def __init__(self):
        super().__init__('Shufersal')
        self.base_url = 'https://prices.shufersal.co.il/'
    
    def fetch_file_list(self, file_type='price', limit=None):
        """Scrape Shufersal website for files"""
        # Implementation already exists
        pass
    
    def parse_file(self, filepath):
        """Parse Shufersal XML with their structure"""
        # Uses government-standard XML format
        # Implementation already exists
        pass


class SuperPharmPlugin(SupplierScraperPlugin):
    """SuperPharm implementation"""
    
    def __init__(self):
        super().__init__('SuperPharm')
        self.base_url = 'https://prices.super-pharm.co.il/'
    
    def fetch_file_list(self, file_type='price', limit=None):
        """Scrape SuperPharm website"""
        # Different page structure than Shufersal
        pass
    
    def parse_file(self, filepath):
        """Parse SuperPharm files - DIFFERENT for Price vs Promo!"""
        if 'Promo' in filepath:
            return self._parse_promo(filepath)
        else:
            return self._parse_price(filepath)
    
    def _parse_price(self, filepath):
        """Price XML - similar to government standard"""
        pass
    
    def _parse_promo(self, filepath):
        """Promo XML - DIFFERENT STRUCTURE!"""
        pass


class RamiLevyPlugin(SupplierScraperPlugin):
    """Rami Levy via Published Prices"""
    
    def __init__(self):
        super().__init__('RamiLevy')
        self.api_url = 'https://publishedprices.co.il/login'
    
    def fetch_file_list(self, file_type='price', limit=None):
        """API-based file discovery with authentication"""
        # 1. Login to get session
        # 2. Call API to list files
        # 3. Return FileMetadata list
        pass
    
    def download_file(self, file_metadata):
        """OVERRIDE: Needs authenticated session"""
        # Use saved session cookies
        # Download with authentication
        pass
    
    def parse_file(self, filepath):
        """Parse Rami Levy format (might be JSON instead of XML)"""
       pass


class VictoryPlugin(SupplierScraperPlugin):
    """Victory via FTP"""
    
    def __init__(self):
        super().__init__('Victory')
        self.ftp_host = 'ftp.victory.co.il'
    
    def fetch_file_list(self, file_type='price', limit=None):
        """FTP directory listing"""
        import ftplib
        # Connect to FTP
        # List files
        # Return FileMetadata
        pass
    
    def download_file(self, file_metadata):
        """OVERRIDE: FTP download instead of HTTP"""
        import ftplib
        # FTP download logic
        pass
    
    def parse_file(self, filepath):
        """Parse Victory format (might be CSV)"""
        import csv
        # CSV parsing
        pass


# PLUGIN REGISTRY:
# ================

SUPPLIER_PLUGINS = {
    'shufersal': ShufersalPlugin,
    'superpharm': SuperPharmPlugin,
    'rami_levy': RamiLevyPlugin,
    'victory': VictoryPlugin,
    # Easy to add more!
}

def get_supplier_plugin(supplier_name: str):
    """Factory method to get supplier plugin"""
    plugin_class = SUPPLIER_PLUGINS.get(supplier_name.lower())
    if not plugin_class:
        raise ValueError(f"Unknown supplier: {supplier_name}")
    return plugin_class()


# USAGE:
# ======

"""
# Import from any supplier:
plugin = get_supplier_plugin('shufersal')
files = plugin.fetch_file_list(limit=10)

for file_meta in files:
    filepath = plugin.download_file(file_meta)
    products = plugin.parse_file(filepath)
    # ... import to database

# Add new supplier:
# 1. Create class inheriting SupplierScraperPlugin
# 2. Implement fetch_file_list() and parse_file()
# 3. Override download_file() if needed
# 4. Add to SUPPLIER_PLUGINS registry
# 5. Done! Now works with all infrastructure
"""
