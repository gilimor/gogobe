# 🚀 ביצועים ויעילות - מדריך אופטימיזציה

## 📊 המצב הנוכחי

### גדלי טבלאות:
```
prices:    ~50MB   (265,628 שורות) → צפי: 50GB+ 🔥
products:  ~5MB    (13,280 שורות)
stores:    ~1MB    (14 שורות)
chains:    <1MB    (1 שורה)
```

### האתגר:
- 📈 **גדילה צפויה**: מ-265K ל-10M+ מחירים
- ⏱️ **זמן תגובה**: צריך להישאר מתחת ל-100ms
- 💾 **נפח**: עד 50GB של נתונים
- 🔄 **עדכונים תכופים**: ייבוא יומי/שעתי

---

## 🎯 אסטרטגיות אופטימיזציה

### 1️⃣ **Indexes (אינדקסים) - קריטי!**

#### ✅ אינדקסים קיימים:
```sql
-- Products
idx_products_vertical
idx_products_category
idx_products_brand
idx_products_ean
idx_products_name_trgm (fuzzy search)
idx_products_attributes (JSONB)

-- Prices (החשובים ביותר!)
idx_prices_product_time (product_id, scraped_at DESC)
idx_prices_supplier_time (supplier_id, scraped_at DESC)
idx_prices_product_supplier (product_id, supplier_id, scraped_at)
idx_prices_store (store_id)
```

#### 🆕 אינדקסים נוספים שצריך להוסיף:

```sql
-- 1. Composite index לשאילתות נפוצות
CREATE INDEX idx_prices_product_store_time 
ON prices(product_id, store_id, scraped_at DESC)
WHERE is_available = TRUE;

-- 2. Partial index למחירים עדכניים בלבד (7 ימים אחרונים)
CREATE INDEX idx_prices_recent 
ON prices(product_id, price, scraped_at DESC)
WHERE scraped_at > NOW() - INTERVAL '7 days';

-- 3. Index לחיפוש לפי טווח מחירים
CREATE INDEX idx_prices_range 
ON prices(price, currency, is_available)
WHERE is_available = TRUE;

-- 4. Covering index (כולל את כל השדות הנצרכים)
CREATE INDEX idx_prices_full_covering
ON prices(product_id, supplier_id, store_id, price, currency, scraped_at)
WHERE scraped_at > NOW() - INTERVAL '30 days';
```

---

### 2️⃣ **Table Partitioning (חלוקת טבלאות)**

#### למה צריך?
- טבלת `prices` תגדל ל-10M+ שורות
- שאילתות יהיו **איטיות מאוד** ללא partitioning
- גודל: **50GB+**

#### ✅ Partition לפי חודש:

```sql
-- 1. צור טבלה ראשית כ-partitioned
CREATE TABLE prices_new (
    id BIGSERIAL,
    product_id BIGINT NOT NULL,
    supplier_id INTEGER NOT NULL,
    store_id INTEGER,
    price DECIMAL(12,2) NOT NULL,
    currency CHAR(3) DEFAULT 'ILS',
    original_price DECIMAL(12,2),
    discount_percentage DECIMAL(5,2),
    quantity INTEGER DEFAULT 1,
    unit VARCHAR(50) DEFAULT 'piece',
    is_on_sale BOOLEAN DEFAULT FALSE,
    sale_ends_at TIMESTAMP,
    is_available BOOLEAN DEFAULT TRUE,
    stock_level VARCHAR(50),
    shipping_cost DECIMAL(10,2),
    free_shipping BOOLEAN DEFAULT FALSE,
    source_url VARCHAR(1000),
    scrape_job_id UUID,
    scraped_at TIMESTAMP DEFAULT NOW(),
    is_verified BOOLEAN DEFAULT FALSE,
    CONSTRAINT valid_price CHECK (price >= 0)
) PARTITION BY RANGE (scraped_at);

-- 2. צור partitions לכל חודש
CREATE TABLE prices_2025_12 PARTITION OF prices_new
    FOR VALUES FROM ('2025-12-01') TO ('2026-01-01');

CREATE TABLE prices_2026_01 PARTITION OF prices_new
    FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');

-- ... וכן הלאה

-- 3. העבר נתונים (בזהירות!)
INSERT INTO prices_new SELECT * FROM prices;

-- 4. החלף טבלאות (בזמן maintenance)
ALTER TABLE prices RENAME TO prices_old;
ALTER TABLE prices_new RENAME TO prices;

-- 5. צור indexes על ה-partitions
CREATE INDEX ON prices_2025_12(product_id, scraped_at DESC);
CREATE INDEX ON prices_2025_12(store_id);
-- ... על כל partition
```

#### יתרונות:
- ⚡ **שאילתות מהירות פי 10-100** (רק על חודש רלוונטי)
- 🗑️ **מחיקה מהירה** של נתונים ישנים (`DROP TABLE prices_2024_01`)
- 📦 **ניהול קל** - כל חודש בטבלה נפרדת

---

### 3️⃣ **Archiving Strategy (ארכיון)**

#### בעיה:
- מחירים מלפני 6 חודשים **לא רלוונטיים** לרוב השאילתות
- תופסים **מקום יקר** ומאטים queries

#### ✅ פתרון:

```sql
-- 1. טבלת ארכיון
CREATE TABLE prices_archive (
    LIKE prices INCLUDING ALL
) PARTITION BY RANGE (scraped_at);

-- 2. העבר נתונים ישנים (חודשית/שבועית)
INSERT INTO prices_archive 
SELECT * FROM prices 
WHERE scraped_at < NOW() - INTERVAL '6 months';

DELETE FROM prices 
WHERE scraped_at < NOW() - INTERVAL '6 months';

-- 3. או: העבר partition שלם (מהיר!)
ALTER TABLE prices DETACH PARTITION prices_2025_01;
ALTER TABLE prices_archive ATTACH PARTITION prices_2025_01
    FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');
```

#### תוצאה:
- 📉 טבלת `prices` קטנה פי 2-3
- ⚡ שאילתות מהירות פי 5-10
- 💾 ארכיון זמין לניתוחים היסטוריים

---

### 4️⃣ **Materialized Views (תצוגות ממומשות)**

#### למה?
- חישובים כבדים (MIN, MAX, AVG) על מיליוני שורות
- צריך תוצאות **מהירות** (לא לחשב כל פעם)

#### ✅ דוגמאות:

```sql
-- 1. מחיר מינימלי/מקסימלי עדכני לכל מוצר
CREATE MATERIALIZED VIEW mv_product_current_prices AS
SELECT 
    product_id,
    MIN(price) as current_min_price,
    MAX(price) as current_max_price,
    AVG(price) as current_avg_price,
    COUNT(*) as price_count,
    COUNT(DISTINCT store_id) as store_count,
    MAX(scraped_at) as last_updated
FROM prices
WHERE scraped_at > NOW() - INTERVAL '7 days'
    AND is_available = TRUE
GROUP BY product_id;

CREATE UNIQUE INDEX ON mv_product_current_prices(product_id);

-- 2. סטטיסטיקות לסניף
CREATE MATERIALIZED VIEW mv_store_statistics AS
SELECT 
    s.id as store_id,
    s.name,
    COUNT(DISTINCT pr.product_id) as product_count,
    COUNT(pr.id) as price_count,
    MIN(pr.price) as min_price,
    MAX(pr.price) as max_price,
    AVG(pr.price) as avg_price,
    MAX(pr.scraped_at) as last_updated
FROM stores s
LEFT JOIN prices pr ON pr.store_id = s.id
WHERE pr.scraped_at > NOW() - INTERVAL '30 days'
GROUP BY s.id, s.name;

CREATE UNIQUE INDEX ON mv_store_statistics(store_id);

-- 3. רענן (כל שעה/יום)
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_product_current_prices;
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_store_statistics;
```

#### יתרונות:
- ⚡ **מהירות פי 1000** - קריאה מטבלה במקום חישוב
- 🔄 **רענון מבוקר** - פעם ביום/שעה (לא כל query)
- 💰 **חיסכון ב-CPU** - חישוב פעם אחת לכולם

---

### 5️⃣ **Query Optimization (אופטימיזציה)**

#### ❌ שאילתה גרועה:
```sql
-- בעיה: סורק את כל הטבלה (265K+ שורות)
SELECT * FROM prices 
WHERE product_id IN (
    SELECT id FROM products WHERE name LIKE '%חלב%'
);
```

#### ✅ שאילתה מיטבית:
```sql
-- פתרון 1: JOIN במקום subquery
SELECT pr.* 
FROM prices pr
JOIN products p ON pr.product_id = p.id
WHERE p.name LIKE '%חלב%'
    AND pr.scraped_at > NOW() - INTERVAL '7 days';  -- מגביל טווח!

-- פתרון 2: שימוש ב-materialized view
SELECT p.*, mv.current_min_price, mv.current_max_price
FROM products p
JOIN mv_product_current_prices mv ON p.id = mv.product_id
WHERE p.name LIKE '%חלב%';
```

#### עקרונות:
1. **תמיד הגבל טווח תאריכים** - `scraped_at > NOW() - INTERVAL '7 days'`
2. **השתמש ב-indexes** - `WHERE ean = '...'` (יש index)
3. **LIMIT תמיד** - `LIMIT 100` אם לא צריך הכל
4. **JOIN > Subquery** - בדרך כלל מהיר יותר
5. **Covering indexes** - כולל את כל השדות שצריך

---

### 6️⃣ **Caching (מטמון)**

#### שכבות Cache:

```python
# 1. Redis - לשאילתות נפוצות
import redis
r = redis.Redis(host='redis', port=6379)

def get_product_prices(product_id):
    # Try cache first
    cache_key = f"product:{product_id}:prices"
    cached = r.get(cache_key)
    
    if cached:
        return json.loads(cached)
    
    # Query DB
    prices = db.query(...)
    
    # Cache for 5 minutes
    r.setex(cache_key, 300, json.dumps(prices))
    
    return prices

# 2. Application-level cache (in-memory)
from functools import lru_cache

@lru_cache(maxsize=1000)
def get_store_name(store_id):
    # פונקציה שנקראת הרבה - cache ב-memory
    return db.query("SELECT name FROM stores WHERE id = %s", store_id)
```

#### אסטרטגיה:
- 🔥 **Hot data** (7 ימים אחרונים) → Redis (5-10 דקות)
- ❄️ **Cold data** (3-6 חודשים) → DB עם indexes
- 🧊 **Frozen data** (6+ חודשים) → Archive table

---

### 7️⃣ **Connection Pooling**

```python
# ❌ רע: פתיחת connection חדש כל פעם
def query():
    conn = psycopg2.connect(...)
    # ... query
    conn.close()

# ✅ טוב: Pool של connections
from psycopg2 import pool

connection_pool = pool.SimpleConnectionPool(
    minconn=5,
    maxconn=20,
    host='db',
    database='gogobe',
    user='postgres',
    password='...'
)

def query():
    conn = connection_pool.getconn()
    try:
        # ... query
        return result
    finally:
        connection_pool.putconn(conn)
```

---

### 8️⃣ **Batch Operations (קבוצות)**

```python
# ❌ רע: INSERT אחד אחד (איטי!)
for item in items:  # 10,000 items
    cursor.execute(
        "INSERT INTO prices (...) VALUES (%s, %s, ...)",
        (item['price'], item['product_id'])
    )
    conn.commit()  # 10,000 commits! 🐌

# ✅ טוב: Batch INSERT
values = []
for item in items:
    values.append((item['price'], item['product_id'], ...))

# INSERT 1000 בבת אחת
execute_values(
    cursor,
    "INSERT INTO prices (...) VALUES %s",
    values,
    page_size=1000
)
conn.commit()  # רק commit אחד! ⚡
```

---

## 📊 השוואת ביצועים (לדוגמה)

| אופטימיזציה | לפני | אחרי | שיפור |
|--------------|------|------|-------|
| Index על prices | 2000ms | 50ms | **×40** |
| Partitioning (חודשי) | 1000ms | 30ms | **×33** |
| Materialized View | 500ms | 5ms | **×100** |
| Caching (Redis) | 50ms | 2ms | **×25** |
| Batch INSERT (1000) | 10s | 0.5s | **×20** |

---

## ✅ תוכנית פעולה

### Phase 1: קריטי (עכשיו)
1. ✅ **Indexes** - הוסף missing indexes
2. ✅ **Connection Pool** - במקום connections בודדים
3. ✅ **Batch operations** - בייבוא

### Phase 2: חשוב (חודש)
4. ⏳ **Partitioning** - חלק את `prices` לפי חודש
5. ⏳ **Materialized Views** - לשאילתות נפוצות
6. ⏳ **Redis Cache** - למחירים עדכניים

### Phase 3: אופציונלי (3 חודשים)
7. 🔮 **Archiving** - העבר נתונים ישנים
8. 🔮 **Read Replicas** - DB נפרד לקריאה
9. 🔮 **CDN** - לתמונות ותוכן סטטי

---

## 🎯 מדדי הצלחה

- ⚡ **זמן תגובה ממוצע**: <100ms
- 📊 **שאילתות מורכבות**: <500ms
- 💾 **גודל טבלת prices**: <10GB (עם ארכיון)
- 🔄 **זמן ייבוא**: <5 דקות ל-10K מוצרים
- 🎯 **זמינות**: 99.9%

---

**האם זה עונה על הדרישות? 🚀**

