# Adding a New Supermarket Chain - Developer Guide

## Overview

This guide shows you how to add support for a new supermarket chain in **minutes**, thanks to our generic scraper framework.

## Quick Start (5 Minutes)

### Step 1: Create Your Scraper Class

Create a new file: `backend/scrapers/yourchain_scraper.py`

```python
#!/usr/bin/env python3
from base_supermarket_scraper import (
    BaseSupermarketScraper, FileMetadata, ParsedProduct, logger
)
from typing import List, Dict, Tuple
from pathlib import Path
import xml.etree.ElementTree as ET

class YourChainScraper(BaseSupermarketScraper):
    """Scraper for YourChain supermarket"""
    
    def __init__(self):
        super().__init__(
            chain_name="YourChain",           # English name
            chain_slug="yourchain",           # URL-friendly slug
            chain_name_he="שם הרשת בעברית",   # Hebrew name
            chain_id="7290123456789",         # Official chain ID
            country_code="IL"                 # ISO country code
        )
        self.base_url = "https://prices.yourchain.co.il/"
    
    def fetch_file_list(self, file_type='prices_full', limit=None):
        """Fetch available files from data source"""
        # TODO: Implement file discovery
        # Return list of FileMetadata objects
        return []
    
    def parse_file(self, file_path: Path) -> Tuple[Dict, List[ParsedProduct]]:
        """Parse XML/JSON/CSV file"""
        # Read file
        with open(file_path, 'r', encoding='utf-8') as f:
            tree = ET.parse(f)
        root = tree.getroot()
        
        # Extract metadata
        metadata = {
            'store_id': root.findtext('StoreId'),
            'store_name': root.findtext('StoreName'),
        }
        
        # Parse products
        products = []
        for item in root.findall('.//Item'):
            product = ParsedProduct(
                name=item.findtext('ItemName'),
                barcode=item.findtext('ItemCode'),
                price=float(item.findtext('ItemPrice')),
                manufacturer=item.findtext('ManufacturerName'),
            )
            products.append(product)
        
        return metadata, products
```

**That's it!** The base class handles:
- ✅ Database connections
- ✅ Product deduplication
- ✅ Price import
- ✅ Store management
- ✅ Error handling
- ✅ Logging

### Step 2: Register Your Scraper

Edit `backend/scripts/import_supermarket.py`:

```python
from yourchain_scraper import YourChainScraper

SUPPORTED_CHAINS = {
    'shufersal': ShufersalScraper,
    'yourchain': YourChainScraper,  # Add this line
}
```

### Step 3: Test It

```bash
# Import a single file
python import_supermarket.py --chain yourchain --file /data/prices.xml

# Import from directory
python import_supermarket.py --chain yourchain --dir /data/yourchain --limit 10
```

Done! 🎉

---

## Detailed Guide

### Understanding the Data Flow

```
1. Fetch file list (optional)
   ↓
2. Download files (optional)
   ↓
3. Decompress (automatic: GZ, BZ2, ZIP)
   ↓
4. Parse file → ParsedProduct objects
   ↓
5. Normalize data (automatic)
   ↓
6. Import to database (automatic)
```

**You only need to implement steps 1 and 4!**

---

### Data Structures

#### ParsedProduct

```python
@dataclass
class ParsedProduct:
    name: str                          # Required
    barcode: Optional[str] = None      # Recommended (for deduplication)
    manufacturer: Optional[str] = None
    description: Optional[str] = None
    price: Optional[float] = None      # Required for price import
    unit_qty: Optional[str] = None
    quantity: Optional[str] = None
    unit_of_measure: Optional[str] = None
    is_weighted: bool = False
    manufacturer_code: Optional[str] = None
    attributes: Dict[str, Any] = None  # Any extra fields
```

#### ParsedStore

```python
@dataclass
class ParsedStore:
    store_id: str                      # Required
    name: str                          # Required
    city: Optional[str] = None
    address: Optional[str] = None
    bikoret_no: Optional[str] = None
    attributes: Dict[str, Any] = None
```

---

### Common Patterns

#### Pattern 1: XML Files (Israeli Chains)

Most Israeli chains follow the government transparency law format:

```python
def parse_file(self, file_path: Path):
    with open(file_path, 'r', encoding='utf-8') as f:
        tree = ET.parse(f)
    root = tree.getroot()
    
    metadata = {
        'chain_id': root.findtext('ChainId'),
        'store_id': root.findtext('StoreId'),
        'store_name': root.findtext('StoreName'),
    }
    
    products = []
    for item in root.findall('.//Item'):
        product = ParsedProduct(
            name=item.findtext('ItemNm'),
            barcode=item.findtext('ItemCode'),
            price=self._parse_float(item.findtext('ItemPrice')),
            manufacturer=item.findtext('ManufacturerName'),
        )
        products.append(product)
    
    return metadata, products
```

#### Pattern 2: JSON API (Modern Chains)

```python
import requests

def fetch_file_list(self, file_type='prices_full', limit=None):
    response = requests.get(f"{self.base_url}/api/files")
    data = response.json()
    
    files = []
    for file_info in data['files']:
        files.append(FileMetadata(
            url=file_info['url'],
            filename=file_info['name'],
            file_type=file_type,
        ))
    
    return files[:limit] if limit else files

def parse_file(self, file_path: Path):
    with open(file_path, 'r') as f:
        data = json.load(f)
    
    metadata = data['metadata']
    
    products = []
    for item in data['products']:
        product = ParsedProduct(
            name=item['name'],
            barcode=item['ean'],
            price=item['price'],
        )
        products.append(product)
    
    return metadata, products
```

#### Pattern 3: CSV Files

```python
import csv

def parse_file(self, file_path: Path):
    products = []
    
    with open(file_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            product = ParsedProduct(
                name=row['product_name'],
                barcode=row['barcode'],
                price=float(row['price']),
                manufacturer=row.get('brand'),
            )
            products.append(product)
    
    metadata = {'store_id': 'unknown'}
    return metadata, products
```

---

### Advanced Features

#### Custom Store Mapping

```python
class YourChainScraper(BaseSupermarketScraper):
    STORE_NAMES = {
        '001': 'YourChain - Tel Aviv',
        '002': 'YourChain - Jerusalem',
        # ...
    }
    
    def parse_file(self, file_path):
        # ... parse file ...
        
        store_id = metadata['store_id']
        metadata['store_name'] = self.STORE_NAMES.get(
            store_id, 
            f"{self.chain_name} - Store {store_id}"
        )
        
        return metadata, products
```

#### Category Mapping

```python
CATEGORY_MAP = {
    '1': 'dairy',
    '2': 'meat',
    '3': 'produce',
    # ...
}

def parse_file(self, file_path):
    # ... parse products ...
    
    for item in items:
        category_id = item.findtext('CategoryId')
        product.attributes['category'] = self.CATEGORY_MAP.get(category_id)
```

#### Handling Multiple File Types

```python
def parse_file(self, file_path: Path):
    if 'Store' in file_path.name:
        return self.parse_stores_file(file_path)
    elif 'Price' in file_path.name:
        return self.parse_prices_file(file_path)
    elif 'Promo' in file_path.name:
        return self.parse_promos_file(file_path)
```

---

### Testing Your Scraper

#### 1. Unit Test

```python
def test_parse_file():
    scraper = YourChainScraper()
    metadata, products = scraper.parse_file(Path('test_data.xml'))
    
    assert len(products) > 0
    assert products[0].name is not None
    assert products[0].price is not None
```

#### 2. Integration Test

```bash
# Test with a single file
python import_supermarket.py --chain yourchain --file test_data.xml

# Check database
docker exec gogobe-api-1 psql -U postgres -d gogobe -c \
    "SELECT COUNT(*) FROM products WHERE attributes->>'chain_id' = '7290123456789';"
```

#### 3. Full Import Test

```bash
# Import 10 files
python import_supermarket.py --chain yourchain --dir /data/yourchain --limit 10

# Check results in website
# http://localhost:8000
```

---

### Troubleshooting

#### Problem: Encoding Issues

```python
# Try different encodings
encodings = ['utf-8', 'windows-1255', 'iso-8859-8']
for encoding in encodings:
    try:
        with open(file_path, 'r', encoding=encoding) as f:
            tree = ET.parse(f)
        break
    except UnicodeDecodeError:
        continue
```

#### Problem: Products Not Deduplicating

Make sure you're setting the `barcode` field:

```python
product = ParsedProduct(
    name=item.findtext('ItemName'),
    barcode=item.findtext('ItemCode'),  # This is critical!
    # ...
)
```

#### Problem: Stores Not Linking

Ensure `store_id` matches between metadata and database:

```python
metadata = {
    'store_id': root.findtext('StoreId'),  # Must be exact match
    'store_name': root.findtext('StoreName'),
}
```

---

### Real-World Examples

#### Example 1: Rami Levy

```python
class RamiLevyScraper(BaseSupermarketScraper):
    def __init__(self):
        super().__init__(
            chain_name="Rami Levy",
            chain_slug="rami-levy",
            chain_name_he="רמי לוי",
            chain_id="7290058140886",
            country_code="IL"
        )
    
    # Same parse_file() as Shufersal - they use the same format!
```

#### Example 2: Walmart (US)

```python
class WalmartScraper(BaseSupermarketScraper):
    def __init__(self):
        super().__init__(
            chain_name="Walmart",
            chain_slug="walmart",
            chain_name_he="וולמארט",
            chain_id="US-WALMART",
            country_code="US"
        )
    
    def fetch_file_list(self, file_type='prices_full', limit=None):
        # Use Walmart API
        response = requests.get(
            "https://api.walmart.com/v1/products",
            headers={'Authorization': f'Bearer {self.api_key}'}
        )
        # ... parse response ...
```

---

### Checklist

Before submitting your scraper:

- [ ] Scraper class created
- [ ] `fetch_file_list()` implemented (or documented as manual)
- [ ] `parse_file()` implemented and tested
- [ ] Barcode field populated (for deduplication)
- [ ] Hebrew encoding works correctly
- [ ] Store names are meaningful
- [ ] Tested with 10+ files
- [ ] Added to `SUPPORTED_CHAINS` dict
- [ ] Documentation updated

---

### Getting Help

- Check existing scrapers: `shufersal_scraper.py`, `kingstore_scraper.py`
- Read base class: `base_supermarket_scraper.py`
- Ask in project chat/issues

---

**Happy scraping! 🚀**
