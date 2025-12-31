# Adding New Retail Chains - Quick Guide

## How to Add a New Chain (5 minutes!)

### Step 1: Create Scraper (Copy Template)
```bash
cp backend/scrapers/superpharm_scraper.py backend/scrapers/NEWCHAIN_scraper.py
```

### Step 2: Update Chain Info (3 changes)
```python
class NewChainScraper(BaseSupermarketScraper):
    def __init__(self):
        super().__init__(
            chain_name='NewChain',           # ← Change
            chain_slug='newchain',           # ← Change
            chain_name_he='חנות-חדשה',      # ← Change
            chain_id='7290123456789',        # ← Change (official ID)
            country_code='IL'
        )
        
        self.download_dir = 'data/newchain'  # ← Change
        self.base_url = 'https://prices.newchain.co.il/'  # ← Change
```

### Step 3: Update fetch_file_list()
Only if file structure is different from government standard:
```python
def fetch_file_list(self, limit=None):
    # Custom logic here
    # Or use super().fetch_file_list() if standard format
    pass
```

### Step 4: Register in Universal Importer
```python
# backend/import_universal.py
from scrapers.newchain_scraper import NewChainScraper

AV AILABLE_SCRAPERS = {
    'shufersal': ShufersalScraper,
    'superpharm': SuperPharmScraper,
    'newchain': NewChainScraper,  # ← Add here
}
```

### Step 5: Run Distributed Import
```bash
# Create orchestrator (copy template)
cp backend/import_superpharm.py backend/import_newchain.py

# Update source_id in the file:
# source_id='superpharm' → source_id='newchain'

# Run it
docker exec gogobe-api-1 python /app/backend/import_newchain.py

# Start workers (automatic - reuses same workers!)
# Workers automatically handle ALL chains
```

## That's It! 🎉

**The new chain now uses:**
- ✅ Redis Streams (parallel pipeline)  
- ✅ COPY method (10,000 batch inserts)
- ✅ Redis caching
- ✅ Geocoding support (automatic)
- ✅ Worker pool (shared across all chains)
- ✅ Error recovery
- ✅ Progress tracking

**Expected performance:**
- First chain: 15,000-20,000 prices/second
- Each additional chain: +5,000 prices/second (reuses workers)

## Advanced: Custom Parsing

If XML format is different:

```python
def parse_file(self, filepath: str) -> List[Dict]:
    """Custom XML parser"""
    import xml.etree.ElementTree as ET
    tree = ET.parse(filepath)
    root = tree.getroot()
    
    products = []
    for item in root.findall('.//Product'):  # ← Adjust path
        product = {
            'item_code': item.find('ItemCode').text,  # ← Field names
            'item_name': item.find('ItemName').text,
            'price': float(item.find('Price').text),
            # ... map other fields
        }
        products.append(product)
    
    return products
```

## Monitoring

```bash
# Check queue status
docker exec gogobe-redis-1 redis-cli XINFO STREAMS

# Check workers
docker ps | grep gogobe-api

# View logs
docker logs gogobe-api-1 --tail 100
```

## Performance Tuning

```python
# Adjust workers per chain
# backend/import_newchain.py

# Light chains (< 100 files):
#   Parsers: 5, Processors: 5

# Heavy chains (> 500 files):  
#   Parsers: 15, Processors: 15

# Super heavy (> 1000 files):
#   Parsers: 25, Processors: 25
```

---

**Total time to add new chain: ~10 minutes including testing!**
