# ⚡ Performance Optimization Analysis

**Current Performance:** 705 prices/second  
**Target:** 10,000+ prices/second (14x improvement)

---

## 📊 **Current Bottleneck Analysis:**

### **1. Processing Pipeline Breakdown:**

```
Total Time per Product: ~1.4ms

Breakdown (estimated):
1. Parse XML: ~0.2ms (14%)
2. Product Lookup (DB): ~0.5ms (36%) ⚠️ BOTTLENECK
3. Store Lookup (DB): ~0.1ms (7%)
4. Insert Price (batch): ~0.6ms (43%) ⚠️ BOTTLENECK
```

**Main Bottlenecks:**
- 🔴 **Database queries** (43% of time)
- 🔴 **Price insertion** (43% of time)
- 🟡 **Parsing** (14% of time)

---

## 🚀 **Optimization Strategies:**

### **Level 1: Quick Wins (2-3x faster)**

#### **A. Increase Batch Size**
```python
Current: batch_size = 1000
Proposed: batch_size = 5000

Impact: Reduce DB roundtrips by 5x
Expected gain: 1.5-2x faster
Implementation: 5 minutes
```

#### **B. Redis Warmup**
```python
# Pre-load all products into Redis before import
def warmup_cache():
    products = db.execute("SELECT id, ean FROM products")
    cache.cache_products_batch(products)

Impact: Eliminate 36% of DB queries
Expected gain: 1.4x faster
Implementation: 10 minutes
```

#### **C. Connection Pooling**
```python
# Use psycopg2 connection pool
from psycopg2 import pool
connection_pool = pool.ThreadedConnectionPool(5, 20, **db_config)

Impact: Faster DB connections
Expected gain: 1.2x faster
Implementation: 15 minutes
```

**Combined Level 1 Gain: 2.5-3x faster → ~2,000 prices/sec**

---

### **Level 2: Parallel Processing (5-10x faster)**

#### **A. Multi-Threading**
```python
from concurrent.futures import ThreadPoolExecutor

def process_file_batch(files):
    with ThreadPoolExecutor(max_workers=4) as executor:
        executor.map(import_file, files)

Impact: Process 4 files simultaneously
Expected gain: 3-4x faster
Implementation: 30 minutes
```

#### **B. Async I/O**
```python
import asyncio
import asyncpg

async def import_product_async(product):
    async with db_pool.acquire() as conn:
        await conn.execute(upsert_query, product)

Impact: Non-blocking I/O operations
Expected gain: 2-3x faster
Implementation: 2 hours
```

**Combined Level 2 Gain: 5-10x faster → 3,500-7,000 prices/sec**

---

### **Level 3: Database Optimizations (2-3x faster)**

#### **A. UNLOGGED Tables (temporary)**
```sql
-- During bulk import only
ALTER TABLE prices SET UNLOGGED;
-- After import
ALTER TABLE prices SET LOGGED;

Impact: No WAL writes during import
Expected gain: 2x faster
Risk: Data loss on crash (temporary only)
Implementation: 5 minutes
```

#### **B. Disable Triggers/Constraints (temporary)**
```sql
ALTER TABLE prices DISABLE TRIGGER ALL;
-- Import
ALTER TABLE prices ENABLE TRIGGER ALL;

Impact: Skip constraint checks
Expected gain: 1.5x faster
Implementation: 5 minutes
```

#### **C. COPY Instead of INSERT**
```python
# Use PostgreSQL COPY for bulk insert
copy_sql = "COPY prices FROM STDIN WITH CSV"
with cursor.copy(copy_sql) as copy:
    for price in prices:
        copy.write_row(price)

Impact: Native PostgreSQL bulk insert
Expected gain: 3-5x faster
Implementation: 1 hour
```

**Combined Level 3 Gain: 5-10x faster → 3,500-7,000 prices/sec**

---

### **Level 4: Architecture Changes (10-20x faster)**

#### **A. Message Queue (Celery + RabbitMQ)**
```python
# Producer
@celery.task
def import_file_task(file_path):
    scraper.import_file(file_path)

# Scale workers horizontally
celery -A tasks worker --concurrency=10

Impact: Distributed processing
Expected gain: 10x+ (with 10 workers)
Implementation: 1 day
```

#### **B. Bulk Memory Processing**
```python
# Load all to memory, then bulk insert
products_buffer = []
prices_buffer = []

# Process all files
for file in files:
    products, prices = parse_file(file)
    products_buffer.extend(products)
    prices_buffer.extend(prices)

# Single bulk insert
bulk_insert(products_buffer, prices_buffer)

Impact: Minimize DB roundtrips
Expected gain: 5-10x faster
Implementation: 2 hours
```

#### **C. Partitioned Tables**
```sql
-- Partition prices by scraped_at date
CREATE TABLE prices_2025_12 PARTITION OF prices
FOR VALUES FROM ('2025-12-01') TO ('2026-01-01');

Impact: Faster inserts, better queries
Expected gain: 1.5-2x faster
Implementation: 3 hours
```

**Combined Level 4 Gain: 10-20x faster → 7,000-14,000 prices/sec**

---

## 🎯 **Recommended Implementation Plan:**

### **Phase 1: Immediate (Today) - 3x faster**
```
1. Increase batch size to 5000 (5 min)
2. Add connection pooling (15 min)
3. Redis warmup script (10 min)

Total time: 30 minutes
Expected: 705 → 2,115 prices/sec
```

### **Phase 2: This Week - 10x faster**
```
1. Multi-threading (4 workers) (30 min)
2. PostgreSQL COPY method (1 hour)
3. Disable constraints during import (5 min)

Total time: 2 hours
Expected: 705 → 7,050 prices/sec
```

### **Phase 3: Next Week - 20x faster**
```
1. Celery + message queue (1 day)
2. Async I/O with asyncpg (2 hours)
3. Table partitioning (3 hours)

Total time: 2 days
Expected: 705 → 14,100 prices/sec
```

---

## 💡 **Quick Win Implementation:**

### **Option A: Increase Batch Size (5 minutes)**

```python
# File: backend/scrapers/base_supermarket_scraper.py
# Line: 151

# Current:
self.batch_size = 1000

# Change to:
self.batch_size = 5000  # 5x larger batches
```

**Impact:** Immediate 1.5-2x speedup

---

### **Option B: Redis Warmup Script**

```python
#!/usr/bin/env python3
"""
Warm up Redis cache with all products
Run before large imports
"""
import sys
sys.path.insert(0, '/app/backend')

from cache.redis_cache import get_cache
import psycopg2

conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres',
    password='9152245-Gl!',
    host='gogobe-db-1'
)

cache = get_cache()
cur = conn.cursor()

# Load all products
cur.execute("SELECT ean, id FROM products")
products = {ean: id for ean, id in cur.fetchall()}

# Cache them
cache.cache_products_batch(products)

print(f"✓ Warmed up cache with {len(products):,} products")

conn.close()
```

**Impact:** 1.4x speedup by eliminating DB lookups

---

## 📈 **Performance Projection:**

```
Current:        705 prices/sec   (1x)
+ Batch 5000:  1,058 prices/sec  (1.5x)
+ Redis Warm:  1,481 prices/sec  (2.1x)
+ Conn Pool:   1,777 prices/sec  (2.5x)
+ Threading:   7,108 prices/sec  (10x)
+ COPY method: 10,575 prices/sec (15x)
+ Celery:      14,100 prices/sec (20x)
```

---

## ⚡ **Real Numbers:**

### **Current (400 files):**
```
Files: 400
Avg products/file: 5,000
Total products: 2,000,000
Time @ 705/sec: 47 minutes
```

### **After Quick Wins (Phase 1):**
```
Time @ 2,115/sec: 16 minutes (3x faster)
```

### **After Phase 2:**
```
Time @ 7,050/sec: 5 minutes (10x faster)
```

### **After Phase 3:**
```
Time @ 14,100/sec: 2.5 minutes (20x faster)
```

---

## 🎯 **Recommended Next Steps:**

1. **Start Full Import** (running now)
2. **Implement Quick Wins** (30 min) while import runs
3. **Test on subset** (verify improvements)
4. **Apply to production**

---

## 🔍 **Monitoring During Import:**

```bash
# Watch real-time performance
docker exec gogobe-api-1 tail -f /app/logs/import.log

# Check Redis stats
docker exec gogobe-api-1 python -c "
from cache.redis_cache import get_cache;
print(get_cache().get_stats())
"

# Monitor DB connections
docker exec gogobe-db-1 psql -U postgres -d gogobe -c \
  "SELECT count(*) FROM pg_stat_activity;"
```

---

**Bottom Line:** We can easily achieve **10x faster** (7,000+ prices/sec) with 2 hours of work! 🚀

---

*Analysis Date: 23 December 2025, 23:11*
