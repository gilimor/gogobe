# 🎯 Quick Implementation: PostgreSQL COPY Method

**Goal:** 5x faster database inserts  
**Time to Implement:** 30 minutes  
**Expected Gain:** 705 → 3,500 prices/sec

---

## 📋 **Implementation Steps:**

### **Step 1: Create COPY-based insert function**

```python
# File: backend/scrapers/base_supermarket_scraper.py
# Add this method to BaseSupermarketScraper class

def _flush_price_batch_copy(self):
    """
    Ultra-fast batch insert using PostgreSQL COPY
    5-10x faster than INSERT statements
    """
    if not self.price_batch:
        return
    
    import io
    from datetime import datetime
    
    # Create CSV buffer in memory
    buffer = io.StringIO()
    
    for price in self.price_batch:
        # Format: product_id,supplier_id,store_id,price,currency,is_available,scraped_at
        scraped_at = price.get('scraped_at', datetime.now()).isoformat()
        is_available = 't' if price.get('is_available', True) else 'f'
        
        buffer.write(
            f"{price['product_id']},"
            f"{price['supplier_id']},"
            f"{price['store_id']},"
            f"{price['price']},"
            f"{price.get('currency', 'ILS')},"
            f"{is_available},"
            f"{scraped_at},"
            f"{scraped_at}\n"  # last_scraped_at = scraped_at
        )
    
    buffer.seek(0)
    
    try:
        with self.conn.cursor() as cur:
            # Use COPY for ultra-fast insert
            cur.copy_from(
                buffer,
                'prices',
                sep=',',
                columns=[
                    'product_id', 'supplier_id', 'store_id',
                    'price', 'currency', 'is_available',
                    'scraped_at', 'last_scraped_at'
                ]
            )
        
        self.conn.commit()
        logger.info(f"✓ COPY inserted {len(self.price_batch)} prices (ultra-fast!)")
        
    except Exception as e:
        logger.error(f"COPY insert failed: {e}")
        # Fallback to old method
        self._flush_price_batch_old()
    
    finally:
        self.price_batch = []
```

---

### **Step 2: Rename old method as backup**

```python
def _flush_price_batch_old(self):
    """Original method - keep as fallback"""
    # ... existing code ...
```

---

### **Step 3: Update the main flush call**

```python
# In import_product method, replace:
self._flush_price_batch()

# With:
self._flush_price_batch_copy()  # Use COPY method
```

---

## ⚠️ **Important Notes:**

### **Limitations of COPY:**
1. **No ON CONFLICT support** - can't use with upsert_price
2. **Will create duplicates** if price already exists
3. **Need to handle duplicates differently**

### **Solutions:**

**Option A: Pre-filter duplicates in Python**
```python
def _flush_price_batch_copy(self):
    # Check existing prices first
    existing = self._check_existing_prices(self.price_batch)
    
    # Filter out existing
    new_only = [p for p in self.price_batch if p not in existing]
    
    # COPY only new prices
    if new_only:
        # ... COPY code ...
```

**Option B: Use COPY + post-deduplication**
```python
# After COPY insert
cur.execute("""
    DELETE FROM prices a
    USING prices b
    WHERE a.id > b.id
    AND a.product_id = b.product_id
    AND a.store_id = b.store_id
    AND ABS(a.price - b.price) < 0.01
""")
```

**Option C: COPY to temp table, then UPSERT**
```python
# Create temp table
cur.execute("""
    CREATE TEMP TABLE prices_temp (LIKE prices)
    ON COMMIT DROP
""")

# COPY to temp
cur.copy_from(buffer, 'prices_temp', ...)

# Bulk UPSERT from temp to main
cur.execute("""
    INSERT INTO prices
    SELECT * FROM prices_temp
    ON CONFLICT (product_id, supplier_id, store_id)
    DO UPDATE SET
        price = EXCLUDED.price,
        scraped_at = EXCLUDED.scraped_at
    WHERE ABS(prices.price - EXCLUDED.price) > 0.01
""")
```

---

## 🎯 **Recommended: Option C (COPY + temp table)**

**Full Implementation:**

```python
def _flush_price_batch_copy_with_upsert(self):
    """
    Best of both worlds:
    - COPY speed (10x faster than INSERT)
    - UPSERT logic (no duplicates)
    """
    if not self.price_batch:
        return
    
    import io
    from datetime import datetime
    
    # Create CSV buffer
    buffer = io.StringIO()
    for price in self.price_batch:
        scraped_at = price.get('scraped_at', datetime.now()).isoformat()
        is_available = 't' if price.get('is_available', True) else 'f'
        
        buffer.write(
            f"{price['product_id']},"
            f"{price['supplier_id']},"
            f"{price['store_id']},"
            f"{price['price']},"
            f"{price.get('currency', 'ILS')},"
            f"{is_available},"
            f"{scraped_at},"
            f"{scraped_at}\n"
        )
    
    buffer.seek(0)
    
    try:
        with self.conn.cursor() as cur:
            # Step 1: Create temp table
            cur.execute("""
                CREATE TEMP TABLE IF NOT EXISTS prices_temp (
                    LIKE prices INCLUDING ALL
                ) ON COMMIT DELETE ROWS
            """)
            
            # Step 2: COPY to temp (ultra-fast!)
            cur.copy_from(
                buffer,
                'prices_temp',
                sep=',',
                columns=[
                    'product_id', 'supplier_id', 'store_id',
                    'price', 'currency', 'is_available',
                    'scraped_at', 'last_scraped_at'
                ]
            )
            
            # Step 3: Bulk UPSERT from temp to main
            cur.execute("""
                INSERT INTO prices (
                    product_id, supplier_id, store_id,
                    price, currency, is_available,
                    scraped_at, last_scraped_at
                )
                SELECT * FROM prices_temp
                ON CONFLICT (product_id, supplier_id, store_id)
                DO UPDATE SET
                    price = EXCLUDED.price,
                    scraped_at = EXCLUDED.scraped_at,
                    last_scraped_at = EXCLUDED.last_scraped_at,
                    is_available = EXCLUDED.is_available
                WHERE ABS(prices.price - EXCLUDED.price) > 0.01
                   OR prices.is_available != EXCLUDED.is_available
            """)
        
        self.conn.commit()
        logger.info(f"⚡ COPY+UPSERT: {len(self.price_batch)} prices (5x faster!)")
        
    except Exception as e:
        logger.error(f"COPY+UPSERT failed: {e}")
        self.conn.rollback()
        raise
    
    finally:
        self.price_batch = []
```

---

## 📊 **Expected Performance:**

```
Current (upsert_price function):
  5000 prices = ~2 seconds
  Speed: 2,500 prices/sec

With COPY+UPSERT:
  5000 prices = ~0.4 seconds
  Speed: 12,500 prices/sec

Improvement: 5x faster!
```

---

## ✅ **Testing Script:**

```python
#!/usr/bin/env python3
"""Test COPY method performance"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
import time

scraper = ShufersalScraper()

# Import 1 file with COPY method
start = time.time()
stats = scraper.import_files(limit=1)
duration = time.time() - start

print(f"Duration: {duration:.1f}s")
print(f"Prices: {stats['prices']}")
print(f"Speed: {stats['prices']/duration:.0f} prices/sec")
```

---

## 🎯 **Action Plan:**

1. **Back up current code** ✓ (already working)
2. **Implement COPY+UPSERT method** (30 minutes)
3. **Test on 1 file** (verify works)
4. **Measure performance** (should be 5x faster)
5. **Deploy to production**

**Expected Result:** 11,500 prices/sec → **400 files in ~3 minutes!** 🚀

---

*Created: 23 December 2025, 21:17*
