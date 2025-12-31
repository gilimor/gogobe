# 🔄 תרשים זרימה: קליטת מחיר/מחירון

## תאריך: 21 דצמבר 2025

---

## 📥 3 מקורות קלט

### 1️⃣ **מחירון מספק** (XML/GZ מ-FTP)
### 2️⃣ **מחיר ידני מלקוח** (API/Web Form)
### 3️⃣ **Scraping** (אתרי אינטרנט)

---

## 🔄 תרשים זרימה מלא

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ INPUT SOURCES (מקורות קלט)                                                  │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│ 1. FTP/HTTP      │  │ 2. API Request   │  │ 3. Web Scraper   │
│ (XML/GZ file)    │  │ (JSON)           │  │ (HTML parsing)   │
│                  │  │                  │  │                  │
│ Example:         │  │ Example:         │  │ Example:         │
│ prices.xml.gz    │  │ POST /api/price  │  │ Walmart.com      │
│ from Rami Levy   │  │ {barcode, price} │  │ scraper          │
└────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘
         │                     │                     │
         └─────────────────────┼─────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ MICROSERVICE #1: Import Service (Go)                                        │
│ תפקיד: קבלת נתונים גולמיים והמרה לפורמט אחיד                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│ Process:                                                     │
│ 1. ✅ Parse file (XML/JSON/HTML)                            │
│ 2. ✅ Validate data (required fields)                       │
│ 3. ✅ Extract:                                               │
│    - Chain ID / Supplier                                    │
│    - Store info (name, city, address)                       │
│    - Products (barcode, name, price)                        │
│ 4. ✅ Normalize data (trim, lowercase, etc.)                │
│ 5. ✅ Send events to Kafka                                  │
└──────────────────────────────────────────────────────────────┘

                               │
                               ▼
                    ┌──────────────────┐
                    │ Kafka Topics:    │
                    │ - stores.raw     │
                    │ - products.raw   │
                    │ - prices.raw     │
                    └──────────────────┘
                               │
         ┌─────────────────────┼─────────────────────┐
         │                     │                     │
         ▼                     ▼                     ▼

┌────────────────────┐ ┌────────────────────┐ ┌────────────────────┐
│ MICROSERVICE #2:   │ │ MICROSERVICE #3:   │ │ MICROSERVICE #4:   │
│ Store Processor    │ │ Product Processor  │ │ Price Processor    │
│ (Go)               │ │ (Go)               │ │ (Go)               │
└────────────────────┘ └────────────────────┘ └────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ MICROSERVICE #2: Store Processor (Go)                                       │
│ תפקיד: ניהול סניפים - Get or Create                                        │
└─────────────────────────────────────────────────────────────────────────────┘

Input Event:
{
  "type": "stores.raw",
  "region": "IL",
  "chain_id": "7290027600007",
  "store_id": "001",
  "name": "רמי לוי שיקמה",
  "city": "תל אביב",
  "address": "דרך מנחם בגין 132",
  "bikoret_no": "12345"
}

Process:
┌──────────────────────────────────────────────────────────────┐
│ 1. ✅ Get Chain ID from DB/Cache                            │
│    Query: SELECT id FROM store_chains                       │
│           WHERE chain_code = '7290027600007'                │
│    Result: chain_id = 153                                   │
│                                                              │
│ 2. ✅ Build Store Identifier                                │
│    store_identifier = "7290027600007_001"                   │
│                                                              │
│ 3. ✅ Check if store exists (Cache first)                   │
│    Redis: GET "store:IL:7290027600007_001"                  │
│    If not in cache → Query DB                               │
│                                                              │
│ 4. ✅ Insert or Update Store                                │
│    INSERT INTO stores (chain_id, store_id, name, ...)       │
│    ON CONFLICT (chain_id, store_id)                         │
│    DO UPDATE SET name = EXCLUDED.name, ...                  │
│    RETURNING id                                             │
│                                                              │
│ 5. ✅ Cache Store ID                                        │
│    Redis: SET "store:IL:7290027600007_001" "12345"          │
│    TTL: 24 hours                                            │
│                                                              │
│ 6. ✅ Check if needs Geocoding                              │
│    Query: SELECT latitude FROM stores WHERE id = 12345      │
│    If latitude IS NULL → Send to Geocoding Service          │
└──────────────────────────────────────────────────────────────┘

Output Event (if needs geocoding):
{
  "type": "geocoding.request",
  "store_id": 12345,
  "name": "רמי לוי שיקמה",
  "city": "תל אביב",
  "address": "דרך מנחם בגין 132",
  "country": "Israel"
}
         │
         ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ MICROSERVICE #5: Geocoding Service (Go)                                     │
│ תפקיד: המרת כתובת ל-GPS (Lat/Long)                                         │
└─────────────────────────────────────────────────────────────────────────────┘

Input:
{
  "store_id": 12345,
  "name": "רמי לוי שיקמה",
  "city": "תל אביב",
  "address": "דרך מנחם בגין 132",
  "country": "Israel"
}

Process:
┌──────────────────────────────────────────────────────────────┐
│ 1. ✅ Build search query                                    │
│    query = "דרך מנחם בגין 132, תל אביב, Israel"            │
│                                                              │
│ 2. ✅ Check Cache (Redis)                                   │
│    key = "geo:דרך מנחם בגין 132:תל אביב:Israel"            │
│    Redis: GET key                                           │
│    If found → use cached lat/long                           │
│                                                              │
│ 3. ✅ Call OSM Nominatim API (if not cached)                │
│    URL: https://nominatim.openstreetmap.org/search          │
│    Params:                                                  │
│      - q: "דרך מנחם בגין 132, תל אביב, Israel"             │
│      - format: json                                         │
│      - limit: 1                                             │
│                                                              │
│    Response:                                                │
│    [{                                                       │
│      "lat": "32.0668",                                      │
│      "lon": "34.7913",                                      │
│      "display_name": "..."                                  │
│    }]                                                       │
│                                                              │
│ 4. ✅ Fallback strategies (if no result)                    │
│    Try 1: "רמי לוי שיקמה, תל אביב, Israel"                 │
│    Try 2: "תל אביב, Israel"                                │
│    Try 3: "Israel" (country center)                         │
│                                                              │
│ 5. ✅ Cache result (1 year)                                 │
│    Redis: SET key "32.0668,34.7913" EX 31536000             │
│                                                              │
│ 6. ✅ Update Database                                       │
│    UPDATE stores                                            │
│    SET latitude = 32.0668,                                  │
│        longitude = 34.7913,                                 │
│        geom = ST_SetSRID(ST_MakePoint(34.7913, 32.0668), 4326)│
│    WHERE id = 12345                                         │
│                                                              │
│ 7. ✅ Rate Limiting                                         │
│    Sleep 1 second between requests (OSM policy)             │
└──────────────────────────────────────────────────────────────┘

Output:
Store #12345 now has GPS coordinates! ✅

┌─────────────────────────────────────────────────────────────────────────────┐
│ MICROSERVICE #3: Product Processor (Go)                                     │
│ תפקיד: ניהול מוצרים - Get or Create                                        │
└─────────────────────────────────────────────────────────────────────────────┘

Input Event:
{
  "type": "products.raw",
  "region": "IL",
  "barcode": "7290000000001",
  "name": "חלב תנובה 3% 1 ליטר",
  "manufacturer": "תנובה",
  "category": "חלב ומוצריו"
}

Process:
┌──────────────────────────────────────────────────────────────┐
│ 1. ✅ Check Cache (Redis) - 99% hit rate!                   │
│    key = "product:ean:7290000000001"                        │
│    Redis: GET key                                           │
│    If found → product_id = 54321                            │
│                                                              │
│ 2. ✅ Check Database (if not in cache)                      │
│    SELECT id FROM products                                  │
│    WHERE ean = '7290000000001'                              │
│       OR manufacturer_code = '7290000000001'                │
│    LIMIT 1                                                  │
│                                                              │
│ 3. ✅ Create Product (if not exists)                        │
│    INSERT INTO products (                                   │
│      name, ean, manufacturer, vertical_id                   │
│    ) VALUES (                                               │
│      'חלב תנובה 3% 1 ליטר',                                │
│      '7290000000001',                                       │
│      'תנובה',                                               │
│      1  -- Food & Beverages                                 │
│    )                                                        │
│    ON CONFLICT (ean) DO NOTHING                             │
│    RETURNING id                                             │
│                                                              │
│ 4. ✅ Cache Product ID (24 hours)                           │
│    Redis: SET "product:ean:7290000000001" "54321"           │
│    TTL: 86400 seconds                                       │
│                                                              │
│ 5. ✅ Send to Master Product Matching (async)               │
│    Event: {                                                 │
│      "type": "product.match.request",                       │
│      "product_id": 54321,                                   │
│      "region": "IL",                                        │
│      "barcode": "7290000000001",                            │
│      "name": "חלב תנובה 3% 1 ליטר"                         │
│    }                                                        │
│    → Kafka topic: "product.matching.requests"               │
└──────────────────────────────────────────────────────────────┘

Output:
- product_id = 54321 (cached for future use)
- Event sent to Master Product Matching

┌─────────────────────────────────────────────────────────────────────────────┐
│ MICROSERVICE #4: Price Processor (Go)                                       │
│ תפקיד: עיבוד מחירים - Batch Insert עם upsert_price                        │
└─────────────────────────────────────────────────────────────────────────────┘

Input Event:
{
  "type": "prices.raw",
  "region": "IL",
  "product_id": 54321,
  "store_id": 12345,
  "price": 5.90,
  "currency": "ILS",
  "timestamp": "2025-12-21T23:00:00Z"
}

Process:
┌──────────────────────────────────────────────────────────────┐
│ 1. ✅ Add to Batch Queue                                    │
│    priceQueue.append({                                      │
│      product_id: 54321,                                     │
│      store_id: 12345,                                       │
│      price: 5.90,                                           │
│      currency: "ILS"                                        │
│    })                                                       │
│                                                              │
│ 2. ✅ Check Queue Size                                      │
│    if len(priceQueue) >= 1000:                              │
│      → Execute Batch Insert                                 │
│                                                              │
│ 3. ✅ Batch Insert (every 1000 prices)                      │
│    BEGIN TRANSACTION;                                       │
│                                                              │
│    FOR EACH price IN priceQueue:                            │
│      SELECT upsert_price(                                   │
│        54321,    -- product_id                              │
│        153,      -- supplier_id (chain)                     │
│        12345,    -- store_id                                │
│        5.90,     -- price                                   │
│        'ILS',    -- currency                                │
│        TRUE,     -- is_available                            │
│        0.01      -- price_tolerance (1%)                    │
│      );                                                     │
│                                                              │
│    COMMIT;                                                  │
│                                                              │
│ 4. ✅ upsert_price Logic (PostgreSQL function)              │
│    - Check if price exists for this product+store           │
│    - If exists AND price is same (±1%):                     │
│      → UPDATE last_scraped_at = NOW()                       │
│    - If exists AND price is different:                      │
│      → INSERT new price record                              │
│    - If not exists:                                         │
│      → INSERT new price record                              │
│                                                              │
│ 5. ✅ Clear Queue                                           │
│    priceQueue = []                                          │
│                                                              │
│ 6. ✅ Update Cache (latest price)                           │
│    Redis: SET "price:54321:12345" "5.90:ILS"                │
│    TTL: 1 hour                                              │
│                                                              │
│ 7. ✅ Send to Analytics (async)                             │
│    Event: {                                                 │
│      "type": "price.updated",                               │
│      "product_id": 54321,                                   │
│      "store_id": 12345,                                     │
│      "old_price": 5.80,                                     │
│      "new_price": 5.90,                                     │
│      "change_pct": 1.72                                     │
│    }                                                        │
│    → Kafka topic: "price.changes"                           │
└──────────────────────────────────────────────────────────────┘

Output:
- Price stored in DB (with deduplication)
- Cache updated
- Analytics event sent

┌─────────────────────────────────────────────────────────────────────────────┐
│ MICROSERVICE #6: Master Product Matching (Python + LLM)                     │
│ תפקיד: קישור מוצרים לאב מוצר גלובלי (async)                               │
└─────────────────────────────────────────────────────────────────────────────┘

Input Event:
{
  "type": "product.match.request",
  "product_id": 54321,
  "region": "IL",
  "barcode": "7290000000001",
  "name": "חלב תנובה 3% 1 ליטר"
}

Process:
┌──────────────────────────────────────────────────────────────┐
│ 1. ✅ Check if already matched                              │
│    SELECT master_product_id                                 │
│    FROM product_master_links                                │
│    WHERE regional_product_id = 54321                        │
│      AND region = 'IL'                                      │
│                                                              │
│ 2. ✅ Search existing master products (by barcode)          │
│    SELECT id FROM master_products                           │
│    WHERE global_ean = '7290000000001'                       │
│    LIMIT 1                                                  │
│                                                              │
│ 3. ✅ If not found → LLM Matching                           │
│    - Extract attributes using GPT-4:                        │
│      {                                                      │
│        "brand": "Tnuva",                                    │
│        "product_type": "Milk",                              │
│        "fat_content": "3%",                                 │
│        "volume": "1L",                                      │
│        "category": "Dairy"                                  │
│      }                                                      │
│                                                              │
│    - Generate master_id:                                    │
│      "tnuva-milk-3pct-1l"                                   │
│                                                              │
│    - Search similar masters (embedding similarity)          │
│    - If match found (>90% confidence):                      │
│      → Link to existing master                              │
│    - Else:                                                  │
│      → Create new master product                            │
│                                                              │
│ 4. ✅ Create/Update Link                                    │
│    INSERT INTO product_master_links (                       │
│      master_product_id,                                     │
│      region,                                                │
│      regional_product_id,                                   │
│      confidence_score,                                      │
│      match_method                                           │
│    ) VALUES (                                               │
│      999,      -- master_product_id                         │
│      'IL',                                                  │
│      54321,                                                 │
│      0.98,     -- 98% confidence                            │
│      'llm'                                                  │
│    )                                                        │
│                                                              │
│ 5. ✅ Update prices table                                   │
│    UPDATE prices                                            │
│    SET master_product_id = 999                              │
│    WHERE product_id = 54321                                 │
└──────────────────────────────────────────────────────────────┘

Output:
- Product linked to master product
- Global price comparison now possible!

┌─────────────────────────────────────────────────────────────────────────────┐
│ MICROSERVICE #7: Currency Conversion (Go)                                   │
│ תפקיד: המרת מטבעות לUSD (base currency)                                    │
└─────────────────────────────────────────────────────────────────────────────┘

Input:
{
  "price": 5.90,
  "currency": "ILS"
}

Process:
┌──────────────────────────────────────────────────────────────┐
│ 1. ✅ Check Cache (Redis)                                   │
│    key = "rate:ILS:USD"                                     │
│    Redis: GET key                                           │
│    If found → rate = 0.274                                  │
│                                                              │
│ 2. ✅ Fetch from API (if not cached)                        │
│    URL: https://api.exchangerate-api.com/v4/latest/ILS      │
│    Response: {                                              │
│      "rates": {                                             │
│        "USD": 0.274,                                        │
│        "EUR": 0.252,                                        │
│        ...                                                  │
│      }                                                      │
│    }                                                        │
│                                                              │
│ 3. ✅ Cache rate (1 hour)                                   │
│    Redis: SET "rate:ILS:USD" "0.274" EX 3600                │
│                                                              │
│ 4. ✅ Convert                                               │
│    price_usd = 5.90 * 0.274 = 1.62                          │
│                                                              │
│ 5. ✅ Store in global_prices table                          │
│    INSERT INTO global_prices (                              │
│      time, master_product_id, region,                       │
│      price_local, currency_local,                           │
│      price_usd, exchange_rate                               │
│    ) VALUES (                                               │
│      NOW(), 999, 'IL',                                      │
│      5.90, 'ILS',                                           │
│      1.62, 0.274                                            │
│    )                                                        │
└──────────────────────────────────────────────────────────────┘

Output:
- Price stored in USD for global comparison
- Historical exchange rate preserved

```

---

## 📊 סיכום: Microservices נדרשים

| # | Microservice | תפקיד | Input | Output | שפה |
|---|--------------|-------|-------|--------|-----|
| 1 | **Import Service** | קבלת קבצים ו-parsing | XML/JSON/HTML | Kafka events | Go |
| 2 | **Store Processor** | ניהול סניפים | stores.raw | store_id | Go |
| 3 | **Product Processor** | ניהול מוצרים | products.raw | product_id | Go |
| 4 | **Price Processor** | עיבוד מחירים | prices.raw | DB insert | Go |
| 5 | **Geocoding Service** | GPS coordinates | address | lat/long | Go |
| 6 | **Master Product Matching** | קישור לאב מוצר | product info | master_id | Python+LLM |
| 7 | **Currency Conversion** | המרת מטבעות | price+currency | price_usd | Go |

---

## ⏱️ Timeline לעיבוד מחיר אחד

```
0ms    │ קובץ XML התקבל
       │
10ms   │ Import Service: Parse XML
       │ → Send to Kafka
       │
15ms   │ Store Processor: Get/Create store
       │ → store_id = 12345
       │
20ms   │ Product Processor: Get/Create product (from cache!)
       │ → product_id = 54321
       │
25ms   │ Price Processor: Add to batch queue
       │
1000ms │ Price Processor: Batch insert (1000 prices)
       │ → DB write complete
       │
       │ === PRICE IS NOW AVAILABLE ===
       │
5min   │ Geocoding Service: Get GPS (async, not blocking)
       │ → lat/long updated
       │
10min  │ Master Product Matching: LLM matching (async)
       │ → master_product_id linked
       │
15min  │ Currency Conversion: Convert to USD
       │ → global_prices updated
```

**Total time to usable price: ~1 second** ⚡
**Total time to full enrichment: ~15 minutes** 🎯

---

## ✅ Success Metrics

### ביצועים:
- ✅ 1 מחיר → זמין ב-DB תוך 1 שנייה
- ✅ 100,000 מחירים → זמינים תוך 60 שניות
- ✅ Cache hit rate: >95%
- ✅ אפס כפילויות

### איכות:
- ✅ כל סניף עם GPS (תוך 24 שעות)
- ✅ כל מוצר מקושר לאב מוצר (תוך שעה)
- ✅ כל מחיר עם USD conversion
- ✅ היסטוריית מחירים מלאה

**זה התהליך המלא!** 🚀
