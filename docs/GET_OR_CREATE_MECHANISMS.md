# 🔍 מנגנוני Get-or-Create - אופטימיזציה לביצועים

## תאריך: 21 דצמבר 2025

---

## 🎯 עיקרון: Cache-First, DB-Second, Create-Last

```
┌─────────────────────────────────────────────────────────────┐
│ Strategy: 3-Tier Lookup                                     │
├─────────────────────────────────────────────────────────────┤
│ 1. Redis Cache    → 99% hit rate, <1ms                     │
│ 2. Database       → 1% miss rate, ~10ms                    │
│ 3. Create New     → 0.1% new items, ~50ms                  │
└─────────────────────────────────────────────────────────────┘
```

---

## 1️⃣ מנגנון: Get-or-Create Chain (רשת)

### Input
```json
{
  "chain_code": "7290027600007",
  "chain_name": "רמי לוי שיקמה"
}
```

### Flow

```go
// services/store-processor/chain_manager.go
package main

import (
    "github.com/go-redis/redis/v8"
    "database/sql"
)

type ChainManager struct {
    redis *redis.Client
    db    *sql.DB
}

func (cm *ChainManager) GetOrCreateChain(chainCode, chainName string) (int64, error) {
    // ═══════════════════════════════════════════════════════════
    // TIER 1: Redis Cache (99% hit rate, <1ms)
    // ═══════════════════════════════════════════════════════════
    cacheKey := "chain:code:" + chainCode
    
    cachedID, err := cm.redis.Get(ctx, cacheKey).Int64()
    if err == nil {
        // ✅ CACHE HIT - return immediately
        log.Printf("✅ Cache HIT: Chain %s → ID %d", chainCode, cachedID)
        return cachedID, nil
    }
    
    log.Printf("⚠️ Cache MISS: Chain %s", chainCode)
    
    // ═══════════════════════════════════════════════════════════
    // TIER 2: Database Lookup (~10ms)
    // ═══════════════════════════════════════════════════════════
    var chainID int64
    err = cm.db.QueryRow(`
        SELECT id 
        FROM store_chains 
        WHERE chain_code = $1
        LIMIT 1
    `, chainCode).Scan(&chainID)
    
    if err == nil {
        // ✅ DB HIT - cache it and return
        log.Printf("✅ DB HIT: Chain %s → ID %d", chainCode, chainID)
        
        // Cache for 7 days (chains rarely change)
        cm.redis.Set(ctx, cacheKey, chainID, 7*24*time.Hour)
        
        return chainID, nil
    }
    
    log.Printf("⚠️ DB MISS: Chain %s - creating new", chainCode)
    
    // ═══════════════════════════════════════════════════════════
    // TIER 3: Create New Chain (~50ms)
    // ═══════════════════════════════════════════════════════════
    err = cm.db.QueryRow(`
        INSERT INTO store_chains (chain_code, name)
        VALUES ($1, $2)
        ON CONFLICT (chain_code) DO UPDATE 
        SET name = EXCLUDED.name
        RETURNING id
    `, chainCode, chainName).Scan(&chainID)
    
    if err != nil {
        return 0, err
    }
    
    log.Printf("✅ CREATED: Chain %s → ID %d", chainCode, chainID)
    
    // Cache the new chain
    cm.redis.Set(ctx, cacheKey, chainID, 7*24*time.Hour)
    
    return chainID, nil
}
```

### Performance
```
┌──────────────────────────────────────────────────────────┐
│ Scenario 1: Existing chain (99% of cases)               │
│ - Cache lookup: 0.5ms                                   │
│ - Total: 0.5ms ⚡                                        │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ Scenario 2: Cache miss, DB hit (0.9% of cases)          │
│ - Cache lookup: 0.5ms                                   │
│ - DB lookup: 10ms                                       │
│ - Cache write: 0.5ms                                    │
│ - Total: 11ms ✅                                        │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ Scenario 3: New chain (0.1% of cases)                   │
│ - Cache lookup: 0.5ms                                   │
│ - DB lookup: 10ms                                       │
│ - DB insert: 50ms                                       │
│ - Cache write: 0.5ms                                    │
│ - Total: 61ms ⚠️ (rare)                                 │
└──────────────────────────────────────────────────────────┘
```

---

## 2️⃣ מנגנון: Get-or-Create Store (סניף)

### Input
```json
{
  "chain_id": 153,
  "store_code": "001",
  "name": "רמי לוי שיקמה",
  "city": "תל אביב",
  "address": "דרך מנחם בגין 132"
}
```

### Flow

```go
// services/store-processor/store_manager.go
package main

type StoreManager struct {
    redis *redis.Client
    db    *sql.DB
}

func (sm *StoreManager) GetOrCreateStore(
    chainID int64,
    storeCode string,
    name, city, address string,
) (int64, bool, error) {
    
    // Build unique identifier
    storeIdentifier := fmt.Sprintf("%d_%s", chainID, storeCode)
    
    // ═══════════════════════════════════════════════════════════
    // TIER 1: Redis Cache (95% hit rate for stores)
    // ═══════════════════════════════════════════════════════════
    cacheKey := "store:id:" + storeIdentifier
    
    cachedID, err := sm.redis.Get(ctx, cacheKey).Int64()
    if err == nil {
        log.Printf("✅ Cache HIT: Store %s → ID %d", storeIdentifier, cachedID)
        return cachedID, false, nil  // false = not new
    }
    
    // ═══════════════════════════════════════════════════════════
    // TIER 2: Database Lookup
    // ═══════════════════════════════════════════════════════════
    var storeID int64
    var lat, lon sql.NullFloat64
    
    err = sm.db.QueryRow(`
        SELECT id, latitude, longitude
        FROM stores 
        WHERE chain_id = $1 AND store_id = $2
        LIMIT 1
    `, chainID, storeCode).Scan(&storeID, &lat, &lon)
    
    if err == nil {
        // ✅ DB HIT - cache it
        log.Printf("✅ DB HIT: Store %s → ID %d", storeIdentifier, storeID)
        
        // Cache for 24 hours
        sm.redis.Set(ctx, cacheKey, storeID, 24*time.Hour)
        
        // Check if needs geocoding
        needsGeocoding := !lat.Valid || !lon.Valid
        
        return storeID, needsGeocoding, nil
    }
    
    // ═══════════════════════════════════════════════════════════
    // TIER 3: Create New Store
    // ═══════════════════════════════════════════════════════════
    log.Printf("⚠️ DB MISS: Store %s - creating new", storeIdentifier)
    
    err = sm.db.QueryRow(`
        INSERT INTO stores (
            chain_id, store_id, name, city, address
        )
        VALUES ($1, $2, $3, $4, $5)
        ON CONFLICT (chain_id, store_id) 
        DO UPDATE SET
            name = EXCLUDED.name,
            city = EXCLUDED.city,
            address = EXCLUDED.address
        RETURNING id
    `, chainID, storeCode, name, city, address).Scan(&storeID)
    
    if err != nil {
        return 0, false, err
    }
    
    log.Printf("✅ CREATED: Store %s → ID %d", storeIdentifier, storeID)
    
    // Cache the new store
    sm.redis.Set(ctx, cacheKey, storeID, 24*time.Hour)
    
    // New stores always need geocoding
    return storeID, true, nil  // true = needs geocoding
}
```

### Usage

```go
storeID, needsGeocoding, err := storeManager.GetOrCreateStore(
    153,                          // chain_id
    "001",                        // store_code
    "רמי לוי שיקמה",              // name
    "תל אביב",                    // city
    "דרך מנחם בגין 132",          // address
)

if needsGeocoding {
    // Send async event to Geocoding Service
    sendToGeocodingService(storeID, city, address)
}
```

---

## 3️⃣ מנגנון: Get-or-Create Product (מוצר)

### Input
```json
{
  "barcode": "7290000000001",
  "name": "חלב תנובה 3% 1 ליטר",
  "manufacturer": "תנובה"
}
```

### Flow

```go
// services/product-processor/product_manager.go
package main

type ProductManager struct {
    redis *redis.Client
    db    *sql.DB
}

func (pm *ProductManager) GetOrCreateProduct(
    barcode, name, manufacturer string,
) (int64, bool, error) {
    
    // ═══════════════════════════════════════════════════════════
    // TIER 1: Redis Cache (99% hit rate!)
    // ═══════════════════════════════════════════════════════════
    cacheKey := "product:ean:" + barcode
    
    cachedID, err := pm.redis.Get(ctx, cacheKey).Int64()
    if err == nil {
        log.Printf("✅ Cache HIT: Product %s → ID %d", barcode, cachedID)
        return cachedID, false, nil  // false = not new
    }
    
    // ═══════════════════════════════════════════════════════════
    // TIER 2: Database Lookup
    // ═══════════════════════════════════════════════════════════
    var productID int64
    var masterProductID sql.NullInt64
    
    err = pm.db.QueryRow(`
        SELECT p.id, pml.master_product_id
        FROM products p
        LEFT JOIN product_master_links pml 
          ON pml.regional_product_id = p.id
        WHERE p.ean = $1 OR p.manufacturer_code = $1
        LIMIT 1
    `, barcode).Scan(&productID, &masterProductID)
    
    if err == nil {
        // ✅ DB HIT - cache it
        log.Printf("✅ DB HIT: Product %s → ID %d", barcode, productID)
        
        // Cache for 24 hours
        pm.redis.Set(ctx, cacheKey, productID, 24*time.Hour)
        
        // Check if needs master product matching
        needsMatching := !masterProductID.Valid
        
        return productID, needsMatching, nil
    }
    
    // ═══════════════════════════════════════════════════════════
    // TIER 3: Create New Product
    // ═══════════════════════════════════════════════════════════
    log.Printf("⚠️ DB MISS: Product %s - creating new", barcode)
    
    err = pm.db.QueryRow(`
        INSERT INTO products (
            name, ean, manufacturer, vertical_id
        )
        VALUES ($1, $2, $3, 1)
        ON CONFLICT (ean) DO UPDATE 
        SET name = EXCLUDED.name
        RETURNING id
    `, name, barcode, manufacturer).Scan(&productID)
    
    if err != nil {
        return 0, false, err
    }
    
    log.Printf("✅ CREATED: Product %s → ID %d", barcode, productID)
    
    // Cache the new product
    pm.redis.Set(ctx, cacheKey, productID, 24*time.Hour)
    
    // New products always need master matching
    return productID, true, nil  // true = needs matching
}
```

---

## 4️⃣ מנגנון: Find-or-Create Master Product (אב מוצר)

### Input
```json
{
  "barcode": "7290000000001",
  "name": "חלב תנובה 3% 1 ליטר",
  "region": "IL",
  "product_id": 54321
}
```

### Flow - 3 שלבים

```python
# services/master-product-service/matcher.py
from typing import Optional, Dict
import openai
import redis
import psycopg2

class MasterProductMatcher:
    
    def __init__(self):
        self.redis = redis.Redis(host='redis', port=6379)
        self.db = psycopg2.connect("postgresql://...")
        self.openai = openai
    
    def find_or_create_master(
        self, 
        barcode: str, 
        name: str, 
        region: str,
        product_id: int
    ) -> Dict:
        """
        3-step process:
        1. Search by barcode (exact match)
        2. Search by embedding similarity (fuzzy match)
        3. Create new master product (if no match)
        """
        
        # ═══════════════════════════════════════════════════════
        # STEP 1: Search by Barcode (exact match)
        # ═══════════════════════════════════════════════════════
        master = self._search_by_barcode(barcode)
        if master:
            print(f"✅ Found by barcode: {barcode} → {master['id']}")
            return {
                'master_id': master['id'],
                'method': 'barcode',
                'confidence': 1.0,
                'is_new': False
            }
        
        # ═══════════════════════════════════════════════════════
        # STEP 2: Search by Embedding Similarity (fuzzy match)
        # ═══════════════════════════════════════════════════════
        master = self._search_by_embedding(name, barcode)
        if master and master['confidence'] > 0.90:
            print(f"✅ Found by similarity: {name} → {master['id']} ({master['confidence']:.2%})")
            return {
                'master_id': master['id'],
                'method': 'embedding',
                'confidence': master['confidence'],
                'is_new': False
            }
        
        # ═══════════════════════════════════════════════════════
        # STEP 3: Create New Master Product (LLM extraction)
        # ═══════════════════════════════════════════════════════
        print(f"⚠️ No match found - creating new master for: {name}")
        master = self._create_master_product(name, barcode, region)
        
        return {
            'master_id': master['id'],
            'method': 'created',
            'confidence': 1.0,
            'is_new': True
        }
    
    def _search_by_barcode(self, barcode: str) -> Optional[Dict]:
        """
        Search master products by global barcode
        """
        cur = self.db.cursor()
        cur.execute("""
            SELECT id, master_id, name
            FROM master_products
            WHERE global_ean = %s
            LIMIT 1
        """, (barcode,))
        
        row = cur.fetchone()
        if row:
            return {
                'id': row[0],
                'master_id': row[1],
                'name': row[2]
            }
        return None
    
    def _search_by_embedding(self, name: str, barcode: str) -> Optional[Dict]:
        """
        Search by semantic similarity using embeddings
        
        Process:
        1. Generate embedding for input name
        2. Search similar embeddings in cache/DB
        3. Return best match if confidence > 90%
        """
        
        # Check cache first
        cache_key = f"embedding:{barcode}"
        cached = self.redis.get(cache_key)
        if cached:
            return json.loads(cached)
        
        # Generate embedding
        response = openai.Embedding.create(
            input=name,
            model="text-embedding-ada-002"
        )
        embedding = response['data'][0]['embedding']
        
        # Search in database (using pgvector extension)
        cur = self.db.cursor()
        cur.execute("""
            SELECT 
                id, 
                master_id, 
                name,
                1 - (embedding <=> %s::vector) as similarity
            FROM master_products
            WHERE 1 - (embedding <=> %s::vector) > 0.90
            ORDER BY similarity DESC
            LIMIT 1
        """, (embedding, embedding))
        
        row = cur.fetchone()
        if row:
            result = {
                'id': row[0],
                'master_id': row[1],
                'name': row[2],
                'confidence': row[3]
            }
            
            # Cache for 1 hour
            self.redis.setex(cache_key, 3600, json.dumps(result))
            
            return result
        
        return None
    
    def _create_master_product(
        self, 
        name: str, 
        barcode: str, 
        region: str
    ) -> Dict:
        """
        Create new master product using LLM to extract attributes
        
        Process:
        1. Extract attributes using GPT-4
        2. Generate master_id
        3. Insert into master_products
        4. Generate and store embedding
        """
        
        # ═══════════════════════════════════════════════════════
        # Extract attributes using LLM
        # ═══════════════════════════════════════════════════════
        prompt = f"""
Extract structured product attributes from this name:
Product: {name}
Barcode: {barcode}
Region: {region}

Return JSON with:
- brand: manufacturer/brand name (English)
- product_type: category (e.g., "Milk", "Smartphone")
- attributes: dict of key attributes (e.g., {{"fat": "3%", "volume": "1L"}})
- category: full category path (e.g., "Food & Beverages > Dairy > Milk")

Be consistent and use standardized names.
"""
        
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a product data expert."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.1,
            response_format={"type": "json_object"}
        )
        
        attributes = json.loads(response.choices[0].message.content)
        
        # ═══════════════════════════════════════════════════════
        # Generate master_id
        # ═══════════════════════════════════════════════════════
        master_id = self._generate_master_id(attributes)
        
        # ═══════════════════════════════════════════════════════
        # Generate embedding
        # ═══════════════════════════════════════════════════════
        embedding_response = openai.Embedding.create(
            input=name,
            model="text-embedding-ada-002"
        )
        embedding = embedding_response['data'][0]['embedding']
        
        # ═══════════════════════════════════════════════════════
        # Insert into database
        # ═══════════════════════════════════════════════════════
        cur = self.db.cursor()
        cur.execute("""
            INSERT INTO master_products (
                master_id,
                name,
                global_ean,
                brand,
                category,
                attributes,
                embedding
            ) VALUES (
                %s, %s, %s, %s, %s, %s, %s::vector
            )
            ON CONFLICT (global_ean) DO UPDATE
            SET name = EXCLUDED.name
            RETURNING id
        """, (
            master_id,
            name,
            barcode,
            attributes.get('brand'),
            attributes.get('category'),
            json.dumps(attributes.get('attributes', {})),
            embedding
        ))
        
        new_id = cur.fetchone()[0]
        self.db.commit()
        
        print(f"✅ Created master product: {master_id} (ID: {new_id})")
        
        return {
            'id': new_id,
            'master_id': master_id,
            'attributes': attributes
        }
    
    def _generate_master_id(self, attributes: Dict) -> str:
        """
        Generate unique master_id from attributes
        
        Example:
        {"brand": "Tnuva", "product_type": "Milk", "attributes": {"fat": "3%", "volume": "1L"}}
        → "tnuva-milk-3pct-1l"
        """
        parts = []
        
        if attributes.get('brand'):
            parts.append(attributes['brand'].lower().replace(' ', '-'))
        
        if attributes.get('product_type'):
            parts.append(attributes['product_type'].lower().replace(' ', '-'))
        
        # Add key attributes
        attrs = attributes.get('attributes', {})
        for key in ['fat', 'storage', 'volume', 'size']:
            if key in attrs:
                val = attrs[key].lower().replace(' ', '').replace('%', 'pct')
                parts.append(val)
        
        return '-'.join(parts)
```

### Performance

```
┌──────────────────────────────────────────────────────────┐
│ Scenario 1: Barcode match (70% of cases)                │
│ - DB query: 10ms                                        │
│ - Total: 10ms ⚡                                         │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ Scenario 2: Embedding match (25% of cases)              │
│ - Embedding generation: 200ms                           │
│ - Vector search: 50ms                                   │
│ - Total: 250ms ✅                                       │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ Scenario 3: Create new (5% of cases)                    │
│ - LLM extraction: 1000ms                                │
│ - Embedding generation: 200ms                           │
│ - DB insert: 50ms                                       │
│ - Total: 1250ms ⚠️ (acceptable for new products)       │
└──────────────────────────────────────────────────────────┘
```

---

## 5️⃣ מנגנון: Link Product to Master (קישור)

```python
def link_product_to_master(
    product_id: int,
    region: str,
    master_product_id: int,
    confidence: float,
    method: str
):
    """
    Link regional product to master product
    """
    cur = db.cursor()
    
    # Insert link
    cur.execute("""
        INSERT INTO product_master_links (
            master_product_id,
            region,
            regional_product_id,
            confidence_score,
            match_method
        ) VALUES (%s, %s, %s, %s, %s)
        ON CONFLICT (region, regional_product_id)
        DO UPDATE SET
            master_product_id = EXCLUDED.master_product_id,
            confidence_score = EXCLUDED.confidence_score,
            match_method = EXCLUDED.match_method
    """, (master_product_id, region, product_id, confidence, method))
    
    # Update all prices for this product
    cur.execute("""
        UPDATE prices
        SET master_product_id = %s
        WHERE product_id = %s
    """, (master_product_id, product_id))
    
    db.commit()
    
    print(f"✅ Linked product {product_id} → master {master_product_id}")
```

---

## 📊 סיכום: ביצועים מקבילים

### אסטרטגיה: **Async Processing**

```
┌─────────────────────────────────────────────────────────────┐
│ Critical Path (blocking):                                   │
│ 1. Get Chain        → 0.5ms  (cache)                       │
│ 2. Get Store        → 0.5ms  (cache)                       │
│ 3. Get Product      → 0.5ms  (cache)                       │
│ 4. Insert Price     → 1ms    (batch)                       │
│ TOTAL: 2.5ms ⚡⚡⚡                                          │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Async Processing (non-blocking):                            │
│ 5. Geocoding        → 5 min   (async, Kafka)               │
│ 6. Master Matching  → 10 min  (async, Kafka)               │
│ 7. Currency Convert → 15 min  (async, Kafka)               │
└─────────────────────────────────────────────────────────────┘
```

**המחיר זמין לשימוש תוך 2.5ms!** ⚡

**העשרה מלאה תוך 15 דקות** ✅

---

## ✅ Best Practices

1. **Cache Everything** - Redis לכל lookup
2. **Batch Inserts** - 1000 prices בבת אחת
3. **Async Enrichment** - Geocoding/Matching לא חוסמים
4. **ON CONFLICT** - מניעת race conditions
5. **Idempotent** - ניתן להריץ שוב בלי בעיות

**זה המנגנון האופטימלי!** 🚀
