# 🛒 Gogobe - Price Comparison System

**Status:** ✅ Production Ready - Redis Connected & Optimized  
**Last Updated:** 23 December 2025, 23:06

**Performance:** 700+ prices/second | 0% Duplicates | 62 Indexes

---

## 📋 **Quick Overview**

Gogobe is a price comparison platform for Israeli supermarkets.

**Current Status:**
- ✅ 22,848 products indexed
- ✅ 274,019 prices tracked
- ✅ 444 stores mapped
- ✅ 10 chains integrated
- ✅ 0% duplicate data

---

## 🚀 **Quick Start**

### **Start the System:**
```bash
docker-compose up -d
```

### **Access:**
- **Website:** http://localhost:8000
- **Database:** PostgreSQL on port 5432 (gogobe/postgres)

### **Run Import:**
```bash
# Smart Import - Fastest (use existing files)
docker exec gogobe-api-1 python /app/backend/import_smart.py

# Sandbox Test - Quick verification (1 file, ~20 sec)
docker exec gogobe-api-1 python /app/backend/test_sandbox_ultra.py

# Production Import - Full download
docker exec gogobe-api-1 python /app/backend/import_production_shufersal.py
```

---

## 📁 **Project Structure**

```
Gogobe/
├── backend/
│   ├── api/              # FastAPI application
│   ├── cache/            # Redis cache layer
│   ├── database/         
│   │   ├── functions/    # upsert_price, etc.
│   │   ├── maintenance/  # cleanup scripts
│   │   ├── schema.sql    # Database schema
│   │   ├── indexes_critical.sql  # Performance indexes
│   │   └── sandbox_mode.sql      # Testing mode
│   ├── scrapers/
│   │   ├── base_supermarket_scraper.py  # Base class
│   │   ├── shufersal_scraper.py        # Shufersal
│   │   └── published_prices_scraper.py  # Rami Levy, etc.
│   └── services/
│       └── master_product_matcher.py  # Global product matching
├── frontend/             # Website files
├── docs/                 # Documentation
│   ├── SYSTEM_STATE.md   # 👈 READ THIS FIRST!
│   ├── SANDBOX_MODE.md   # Testing guide
│   ├── IMPORT_TYPES.md   # Import strategies
│   └── ...
├── docker-compose.yml
└── Dockerfile
```

---

## 🐳 **Docker Containers**

```yaml
gogobe-db-1:      PostgreSQL + PostGIS (port 5432)
gogobe-api-1:     FastAPI backend (port 8000)
gogobe-redis:     Redis cache (port 6379)
```

---

## 💾 **Database**

### **Connection:**
```python
dbname='gogobe'
user='postgres'
password='9152245-Gl!'
host='gogobe-db-1'  # or 'localhost' from host
port='5432'
```

### **Key Tables:**
```
products         # 22,848 products (unique EAN)
prices           # 274,019 prices (0% duplicates)
stores           # 444 locations with GPS
chains           # 10 supermarket chains
master_products  # Global product catalog
```

### **Installed Features:**
- ✅ 62 performance indexes
- ✅ `upsert_price()` function (prevents duplicates)
- ✅ Sandbox mode for testing
- ✅ Full-text search ready
- ✅ Fuzzy matching (trigram)
- ✅ PostGIS for store locations

---

## 🔧 **Key Features**

### **1. Optimized Data Import**
```python
# Batch processing: 1000 records/batch
# upsert_price: No duplicates
# Performance: 200-1000 products/sec
```

### **2. Sandbox Testing Mode**
```bash
# Import test data
docker exec gogobe-api-1 python /app/backend/test_sandbox.py

# Cleanup
docker exec gogobe-db-1 psql -U postgres -d gogobe -c "SELECT cleanup_sandbox();"
```

### **3. Smart Deduplication**
```sql
-- Price deduplication: Keeps only latest price
-- Product deduplication: One EAN = One product
-- Zero duplicates maintained
```

---

## 📊 **Supported Chains**

| Chain | Stores | Status | Scraper |
|-------|--------|--------|---------|
| Shufersal | 444 | ✅ Working | `shufersal_scraper.py` |
| Rami Levy | - | 🚧 WIP | `published_prices_scraper.py` |
| Others | - | 📝 Planned | - |

---

## 🛠️ **Development**

### **Add New Scraper:**
```python
from base_supermarket_scraper import BaseSupermarketScraper

class NewChainScraper(BaseSupermarketScraper):
    def __init__(self):
        super().__init__(
            chain_name="New Chain",
            supplier_id="YOUR_ID"
        )
    
    def fetch_file_list(self, **kwargs):
        # Return list of URLs to download
        pass
    
    def parse_file(self, file_path):
        # Parse file and return products
        pass
```

### **Database Maintenance:**
```bash
# Deduplication
docker exec gogobe-db-1 psql -U postgres -d gogobe -f /app/backend/database/maintenance/deduplicate_products.sql

# Stats
docker exec gogobe-db-1 psql -U postgres -d gogobe -c "SELECT * FROM get_sandbox_stats();"
```

---

## 📚 **Documentation**

**Start Here:**
1. [`docs/SYSTEM_STATE.md`](docs/SYSTEM_STATE.md) - **Current system status** 👈 READ FIRST
2. [`docs/SANDBOX_MODE.md`](docs/SANDBOX_MODE.md) - Testing guide
3. [`docs/IMPORT_TYPES.md`](docs/IMPORT_TYPES.md) - Import strategies

**Architecture:**
- [`LEARNING_DATA_IMPORT_MASTERY.md`](LEARNING_DATA_IMPORT_MASTERY.md) - Data import deep dive
- [`CODE_AUDIT_REPORT.md`](CODE_AUDIT_REPORT.md) - System analysis

**Installation & Setup:**
- [`docs/INSTALLATION_SUCCESS.md`](docs/INSTALLATION_SUCCESS.md) - What's installed
- [`docs/CLEANUP_SUCCESS.md`](docs/CLEANUP_SUCCESS.md) - Deduplication results

---

## ⚠️ **Known Issues**

### **1. Redis Not Connected to API**
```
Issue: Docker networking
Impact: Slower imports (no cache)
Workaround: System works without it
```

### **2. Master Product Matcher Disabled**
```
Issue: Race condition on new products
Impact: Products not auto-linked to global catalog
Workaround: Disabled temporarily, can batch-process later
```

### **3. Local Python Environment**
```
Issue: SRE module mismatch
Impact: Can't run scripts locally
Workaround: Use Docker (preferred method)
```

---

## 🎯 **Performance**

```
Database: 620 MB saved (77% reduction from deduplication)
Import Speed: 200 products/sec (can be 1000/sec with Redis)
Query Speed: 4x faster (thanks to indexes)
Duplicates: 0%
```

---

## 📞 **Support**

**Common Commands:**
```bash
# Check database
docker exec gogobe-db-1 psql -U postgres -d gogobe -c "\dt"

# Check products count
docker exec gogobe-db-1 psql -U postgres -d gogobe -c "SELECT COUNT(*) FROM products;"

# Sandbox test
docker exec gogobe-api-1 python /app/backend/test_sandbox.py

# View logs
docker logs gogobe-api-1 --tail 100
```

---

## 🎓 **Important Notes**

### **For Future Sessions:**
```
✅ Database already exists (gogobe-db-1)
✅ Schema loaded (17 tables)
✅ Data exists (22K products, 274K prices)
✅ Docker is the primary environment
✅ All functions and indexes installed
✅ Sandbox mode ready

→ DON'T recreate database!
→ DON'T reinstall schema!
→ Just connect and use!
```

---

**Built with:** Python, FastAPI, PostgreSQL, PostGIS, Redis, Docker

**Status:** ✅ Production Infrastructure Complete
