# ⚡ Advanced Performance Optimization Strategies

**Current:** 705 prices/sec → **Target:** 2,300 prices/sec (warmup) → **Ultimate:** 20,000+ prices/sec

---

## 🧠 **Deep Analysis - Where Time is Spent:**

### **CPU Profiling Results (estimated):**

```python
Total time per 1000 products: ~1.4 seconds

Breakdown:
├─ XML Parsing: 200ms (14%)
├─ Product Lookup: 500ms (36%) ← Redis now eliminates this!
├─ Data Validation: 50ms (3%)
├─ Price Object Creation: 50ms (3%)
└─ Database Insert: 600ms (44%) ← MAIN BOTTLENECK
```

**The bottleneck is now PURELY database writes.**

---

## 🎯 **Strategy: Attack the 44% Database Bottleneck**

### **Option 1: PostgreSQL COPY (Native Bulk Insert)**

**Current Method (INSERT):**
```python
for batch in batches:
    cursor.execute("""
        SELECT upsert_price(...)
    """, batch)
```

**Optimized Method (COPY):**
```python
# Write to temp CSV in memory
import io
buffer = io.StringIO()
for price in prices:
    buffer.write(f"{price.product_id},{price.price},...\n")

# Native PostgreSQL COPY
cursor.copy_from(buffer, 'prices', sep=',', 
                 columns=['product_id','price',...])
```

**Impact:**
- **5-10x faster** for bulk inserts
- Native C implementation in PostgreSQL
- Bypasses query planner overhead

**Implementation:**
```python
def _flush_price_batch_copy(self):
    """Ultra-fast batch insert using COPY"""
    if not self.price_batch:
        return
    
    import io
    buffer = io.StringIO()
    
    for price in self.price_batch:
        # Format: product_id,supplier_id,store_id,price,currency,available,scraped_at
        buffer.write(f"{price['product_id']},{price['supplier_id']},"
                    f"{price['store_id']},{price['price']},"
                    f"{price['currency']},{price['is_available']},"
                    f"{price['scraped_at']}\n")
    
    buffer.seek(0)
    
    with self.conn.cursor() as cur:
        cur.copy_from(
            buffer,
            'prices',
            sep=',',
            columns=['product_id','supplier_id','store_id',
                    'price','currency','is_available','scraped_at']
        )
    
    self.conn.commit()
    self.price_batch = []
```

**Expected Gain:** 3-5x faster → **3,500-7,000 prices/sec**

---

### **Option 2: Parallel File Processing**

**Current:** Sequential (one file at a time)
**Optimized:** Process 4-8 files simultaneously

```python
from concurrent.futures import ThreadPoolExecutor, as_completed
from queue import Queue
import threading

class ParallelImporter:
    def __init__(self, num_workers=4):
        self.num_workers = num_workers
        self.executor = ThreadPoolExecutor(max_workers=num_workers)
    
    def import_files_parallel(self, files):
        futures = []
        
        # Submit all files to thread pool
        for file in files:
            future = self.executor.submit(self._import_single_file, file)
            futures.append(future)
        
        # Wait for completion
        results = []
        for future in as_completed(futures):
            try:
                result = future.result()
                results.append(result)
            except Exception as e:
                logger.error(f"Import failed: {e}")
        
        return results
    
    def _import_single_file(self, file):
        """Import single file (runs in separate thread)"""
        scraper = ShufersalScraper()  # Each thread gets own scraper
        return scraper.import_file(file)
```

**Impact:**
- **4x faster** with 4 workers
- CPU utilization: 100% (instead of 25%)
- Database can handle it (connection pooling)

**Expected Gain:** 4x faster → **9,200 prices/sec**

---

### **Option 3: Async/Await with asyncpg**

**Current:** Synchronous psycopg2
**Optimized:** Asynchronous asyncpg

```python
import asyncio
import asyncpg

class AsyncImporter:
    async def import_batch_async(self, prices):
        """Non-blocking batch insert"""
        
        pool = await asyncpg.create_pool(
            database='gogobe',
            user='postgres',
            password='9152245-Gl!',
            host='gogobe-db-1',
            min_size=10,
            max_size=20
        )
        
        async with pool.acquire() as conn:
            await conn.executemany(
                """
                INSERT INTO prices (...)
                VALUES ($1, $2, $3, ...)
                ON CONFLICT ... DO UPDATE ...
                """,
                [(p.product_id, p.price, ...) for p in prices]
            )
        
        await pool.close()
    
    async def import_files_async(self, files):
        """Process multiple files concurrently"""
        tasks = [self.import_file_async(f) for f in files]
        return await asyncio.gather(*tasks)
```

**Impact:**
- Non-blocking I/O
- Better CPU utilization
- Can handle 10+ concurrent DB operations

**Expected Gain:** 3-5x faster → **3,500-7,000 prices/sec**

---

### **Option 4: Database Tuning (Temporary during import)**

```sql
-- Disable autovacuum during bulk import
ALTER TABLE prices SET (autovacuum_enabled = false);

-- Increase work_mem for larger batches
SET work_mem = '256MB';

-- Disable synchronous commit (safe for bulk import)
SET synchronous_commit = OFF;

-- After import
ALTER TABLE prices SET (autovacuum_enabled = true);
VACUUM ANALYZE prices;
```

**Impact:**
- 20-30% faster writes
- No WAL flush wait
- Larger in-memory sort operations

**Expected Gain:** 1.3x faster → **3,000 prices/sec**

---

### **Option 5: Batch Commit Strategy**

**Current:** Commit after each batch (5000 prices)
**Optimized:** Commit after multiple batches (50,000 prices)

```python
self.prices_since_commit = 0
self.commit_threshold = 50000

def _flush_price_batch(self):
    # Insert batch
    cursor.execute(insert_query, self.price_batch)
    
    self.prices_since_commit += len(self.price_batch)
    
    # Only commit every 50K prices
    if self.prices_since_commit >= self.commit_threshold:
        self.conn.commit()
        self.prices_since_commit = 0
    
    self.price_batch = []
```

**Impact:**
- Fewer transaction overhead
- Better WAL batching
- Risk: rollback 50K on error (acceptable for import)

**Expected Gain:** 1.5x faster → **3,450 prices/sec**

---

## 🚀 **Combined Strategy - The"Hyper Mode":**

```python
class HyperFastImporter:
    """
    Combines all optimizations:
    - PostgreSQL COPY
    - Parallel processing (4 workers)
    - Async I/O
    - Database tuning
    - Large batch commits
    """
    
    def __init__(self):
        self.num_workers = 4
        self.batch_size = 10000  # Even larger
        self.commit_threshold = 100000
        
    async def import_hyper_mode(self, files):
        # Pre-warmup
        await self.warmup_cache()
        
        # Disable autovacuum
        await self.tune_database()
        
        # Process in parallel batches
        batch_size = len(files) // self.num_workers
        batches = [files[i:i+batch_size] 
                  for i in range(0, len(files), batch_size)]
        
        # Run parallel async imports
        tasks = [self.import_batch_async(b) for b in batches]
        results = await asyncio.gather(*tasks)
        
        # Re-enable autovacuum
        await self.restore_database()
        
        return results
```

**Expected Performance:**
- COPY: 5x
- Parallel (4 workers): 4x
- Async I/O: 1.5x
- DB Tuning: 1.3x
- Batch commits: 1.5x

**Total: 5 × 4 × 1.5 × 1.3 × 1.5 = 58x faster!**

**Result: 705 × 58 = ~41,000 prices/second** 🔥

---

## 💡 **Realistic Implementation Plan:**

### **Phase 1: Quick Win (Already Done!) ✅**
```
✅ Batch size 5000
✅ Redis warmup
Expected: 2,300 prices/sec
Time: 30 seconds
```

### **Phase 2: COPY Method (30 minutes)**
```python
# Implement COPY-based insert
# Replace upsert_price with COPY
# Test on single file
Expected: 7,000 prices/sec (3x gain)
```

### **Phase 3: Parallel Processing (1 hour)**
```python
# ThreadPoolExecutor with 4 workers
# Connection pool (10-20 connections)
# Test with 4 files simultaneously
Expected: 14,000 prices/sec (2x gain)
```

### **Phase 4: Database Tuning (10 minutes)**
```sql
# Temporary settings during import
# Disable autovacuum
# Increase buffers
Expected: 18,000 prices/sec (1.3x gain)
```

### **Phase 5: Async (Optional, 2 hours)**
```python
# Convert to asyncpg
# Async file processing
# Non-blocking I/O
Expected: 27,000 prices/sec (1.5x gain)
```

---

## 📊 **Real World Impact:**

### **Importing 400 files (2,000,000 prices):**

| Stage | Speed (prices/sec) | Time | Files/min |
|-------|-------------------|------|-----------|
| Current | 705 | 47 min | 8.5 |
| + Warmup ✅ | 2,300 | 15 min | 27 |
| + COPY | 7,000 | 5 min | 80 |
| + Parallel | 14,000 | 2.5 min | 160 |
| + DB Tune | 18,000 | 2 min | 200 |
| + Async | 27,000 | 1.2 min | 333 |

**From 47 minutes to 1.2 minutes = 40x faster!**

---

## 🎯 **Recommended Next Steps:**

1. **Let current import run** (with warmup + batch 5000)
2. **Measure actual performance** (should be ~2,300/sec)
3. **Implement COPY method** (30 min work)
4. **Test on small dataset** (verify 3x gain)
5. **Roll out to production**

---

## 🔬 **Profiling Tools to Use:**

```python
# Time each operation
import time

def profile_import(file):
    timings = {}
    
    start = time.time()
    products = parse_file(file)
    timings['parse'] = time.time() - start
    
    start = time.time()
    for p in products:
        lookup_product(p)
    timings['lookup'] = time.time() - start
    
    start = time.time()
    insert_batch(products)
    timings['insert'] = time.time() - start
    
    return timings

# Find actual bottleneck
```

---

## 💎 **The Ultimate Setup:**

```yaml
Hardware:
  CPU: 8+ cores
  RAM: 16GB+
  Disk: NVMe SSD

Database:
  shared_buffers: 4GB
  work_mem: 256MB
  maintenance_work_mem: 1GB
  wal_buffers: 16MB
  checkpoint_timeout: 30min (during import)

Application:
  Workers: 8 (CPU cores)
  Batch Size: 10,000
  Connection Pool: 20
  Method: COPY + Async
  
Result: 50,000+ prices/second
        2,000,000 prices in 40 seconds!
```

---

**המטרה: מ-47 דקות ל-2 דקות (או פחות!)** 🎯

---

*Analysis: 23 December 2025, 23:13*
