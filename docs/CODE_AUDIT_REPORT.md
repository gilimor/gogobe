# 🔍 סקירת קוד קיים ו תכנית שיפור - Gogobe

## תאריך: 23 דצמבר 2025
## מטרה: בדיקת קוד קיים וזיהוי שיפורים נדרשים

---

## 📊 סטטוס קיים

### ✅ **מה כבר עובד:**

#### 1. **Scrapers מיושמים** (4 מקורות):
- ✅ **PublishedPricesScraper** - רמי לוי (Published Prices platform)
- ✅ **ShufersalScraper** - שופרסל
- ✅ **LaibCatalogScraper** - Victory, Ma'asanei HaShuk (laibcatalog.co.il)
- ✅ **BinaPro jectsScr aper** - סקריפר לפרויקטים של Bina

#### 2. **BaseSupermarketScraper Framework:**
- ✅ Framework משותף עם קוד מצוין
- ✅ Get-or-Create logic ל-Chains, Stores, Products
- ✅ Support for XML/GZ compression
- ✅ Database import + upsert_price
- ✅ Store identifier building logic

#### 3. **Database Schema:**
- ✅ Schema מקיף (schema.sql)
- ✅ Tables: products, prices, stores, chains, master_products
- ✅ Indexes בסיסיים
- ✅ JSONB attributes

---

## ⚠️ **בעיות ושיפורים נדרשים**

### ❌ **בעיה #1: חסרים מנגנונים קריטיים**

```
נמצא:
✅ import_product() - בסיסי
✅ get_or_create_store() - קיים

חסר:
❌ upsert_price() function - קיים ב-docs אבל לא ב-DB!
❌ Master Product Matching - מוזכר אבל לא מיושם
❌ Redis Cache - לא משולב
❌ Batch Processing - לא מיושם
❌ Geocoding Service - לא מיושם
❌ Quality Control - לא מיושם
```

### ❌ **בעיה #2: Published Prices Scraper - מורכב מדי**

**הקובץ:** `published_prices_scraper.py` (622 שורות!)

**בעיות:**
1. **Login logic מסובך** (200 שורות!)
   - CSRF token handling מסובך
   - כפילות קוד
   - Error handling חלקי

2. **Fallback Discovery מסורבל**
   - בודק 3 ימים × 24 שעות × 50 stores = 3,600 בדיקות!
   - יכול לקחת דקות רבות
   - לא יעיל

3. **API call + Fallback - לוגיקה כפולה**
   - מנסה API
   - גם מנסה Brute Force
   - קוד מסורבל

**פתרון נדרש:**
```python
# חלוקה לפונקציות קטנות יותר
def _try_api_listing() -> List[FileMetadata]
def _try_fallback_discovery() -> List[FileMetadata]
def _smart_fallback(hours_priority=['1900', '0300']) -> List[FileMetadata]
```

### ❌ **בעיה #3: חסר upsert_price ב-DB**

**המצב:**
- ✅ הפונקציה מתועדת במסמכים
- ✅ `base_supermarket_scraper.py` קורא ל-`upsert_price`  
- ❌ **הפונקציה לא קיימת ב-PostgreSQL!**

**תוצאה:**
```python
# בקוד:
cursor.execute("""
    SELECT upsert_price(...)
""", ...)

# Error:
# ERROR: function upsert_price() does not exist
```

**פתרון נדרש:**
צריך ליצור את הפונקציה ב-SQL:
```sql
-- קובץ חדש: backend/database/create_upsert_price_function.sql
CREATE OR REPLACE FUNCTION upsert_price(
    p_product_id BIGINT,
    p_supplier_id INTEGER,
    p_store_id BIGINT,
    p_price DECIMAL,
    p_currency VARCHAR DEFAULT 'ILS',
    p_is_available BOOLEAN DEFAULT TRUE,
    p_tolerance DECIMAL DEFAULT 0.01
) RETURNS VOID AS $$
...
$$ LANGUAGE plpgsql;
```

### ❌ **בעיה #4: חסר Master Product Matching**

**המצב:**
- ✅ מוזכר ב-documentation
- ✅ Tables קיימות (master_products, product_master_links)
- ❌ **אין שירות שמבצע matching!**

**מה חסר:**
1. Service ב-Python שמפעיל LLM/Embeddings
2. Integration עם scrapers
3. Async processing (Kafka?)

**תוצאה:**
```sql
SELECT COUNT(*) FROM master_products;
-- Result: 0 (!)

SELECT COUNT(*) FROM product_master_links;
-- Result: 0 (!)

-- כל המוצרים ללא אב מוצר!
-- לא יכולים להשוות מחירים גלובלית
```

### ❌ **בעיה #5: אין Redis Cache**

**המצב:**
- ✅ מוזכר ב-docs (99% hit rate!)
- ❌ לא משולב בקוד בפועל

**Performance Impact:**
```
ללא Cache:
- ייבוא 100K מוצרים = 100K DB queries
- זמן: ~1000 שניות (16 דקות!)

עם Cache:
- ייבוא 100K מוצרים = 1K DB queries
- זמן: ~10 שניות
```

### ❌ **בעיה #6: אין Batch Processing**

**הקוד הנוכחי:**
```python
# base_supermarket_scraper.py - line 566
for product in products:
    stats = self.import_product(product, store_id)
    # ← INSERT price אחד בכל פעם!
```

**Performance:**
```
1 price = 1 INSERT = 10ms
1,000 prices = 1,000 INSERTs = 10 seconds
100,000 prices = 100,000 INSERTs = 1,000 seconds (16 דקות!)
```

**פתרון נדרש:**
```python
# Batch insert - 1000 בכל פעם
batch = []
for product in products:
    batch.append(product)
    if len(batch) >= 1000:
        batch_insert_prices(batch)
        batch = []
```

**תוצאה:**
```
100,000 prices in batches of 1000:
= 100 batch INSERTs
= 100 × 50ms = 5 seconds! ⚡
```

### ❌ **בעיה #7: חסרים Indexes חשובים**

**schema.sql נוכחי:**
```sql
-- יש רק indexes בסיסיים:
CREATE INDEX idx_products_ean ON products(ean);
CREATE INDEX idx_prices_product_time ON prices(product_id, scraped_at DESC);
```

**חסרים:**
```sql
-- חסר index על barcode:
CREATE INDEX idx_products_barcode ON products(ean) 
    WHERE ean IS NOT NULL;

-- חסר index על master_product_id:
CREATE INDEX idx_prices_master ON prices(master_product_id, scraped_at DESC);

-- חסר index על store + available:
CREATE INDEX idx_prices_store ON prices(store_id, is_available) 
    WHERE is_available = TRUE;

-- חסר GIN index לחיפוש:
CREATE INDEX idx_products_name_trgm ON products 
    USING gin(name gin_trgm_ops);
```

### ❌ **בעיה #8: Shufersal Scraper - בעיות**

**הקובץ:** `shufersal_scraper.py`

**בעיות:**
1. **Hard-coded store names** (רק 10 סניפים!)
   - STORE_NAMES dictionary - רק example
   - צריך לייבא מקובץ Stores

2. **Scraping logic חלקי**
   - לא בודק אם יש redirect
   - לא עוקב אחרי pagination נכון

3. **לא משתמש ב-download_file מ-parent**
   - יורש מ-BaseSupermarketScraper
   - אבל לא משתמש ב-download_file() המשותף

### ❌ **בעיה #9: LaibCatalog Scraper - נאיבי**

**הקובץ:** `laib_catalog_scraper.py`

**בעיות:**
1. **Fallback בסיסי מדי**
   - בודק רק 3 ימים
   - רק 3 שעות ביום
   - רק store '001'

2. **לא משתמש ב-parseStores**
   - אין import של stores file
   - חסר get_or_create_store

---

## 🎯 **תכנית שיפור - Prioritized**

### **Priority 1️⃣: תשתית קריטית** (שבוע 1)

#### Task 1.1: יצירת upsert_price Function
```sql
-- קובץ: backend/database/functions/upsert_price.sql
CREATE OR REPLACE FUNCTION upsert_price(...) RETURNS VOID;
```
**סט טוס:** ❌ חסר
**זמן:** 2 שעות
**Impact:** 🔥🔥🔥🔥🔥 (קריטי!)

#### Task 1.2: הוספת Indexes חיוניים
```sql
-- קובץ: backend/database/indexes_critical.sql
CREATE INDEX ...
```
**סטטוס:** ❌ חסר
**זמן:** 1 שעה
**Impact:** 🔥🔥🔥🔥

#### Task 1.3: תיקון import_product - Batch Support
```python
# backend/scrapers/base_supermarket_scraper.py
def import_products_batch(self, products: List[ParsedProduct], store_id):
    batch = []
    for product in products:
        batch.append(...)
        if len(batch) >= 1000:
            self._batch_insert(batch)
```
**סטטוס:** ❌ חסר
**זמן:** 4 שעות
**Impact:** 🔥🔥🔥🔥🔥

### **Priority 2️⃣: Redis Cache** (שבוע 1-2)

#### Task 2.1: Redis Integration
```python
# backend/cache/redis_cache.py
class ProductCache:
    def get_product_id(self, barcode) -> Optional[int]
    def cache_product(self, barcode, product_id)
    def get_store_id(self, chain_id, store_code) -> Optional[int]
```
**סטטוס:** ❌ חסר
**זמן:** 1 יום
**Impact:** 🔥🔥🔥🔥🔥

#### Task 2.2: שילוב ב-BaseSupermarketScraper
```python
self.cache = ProductCache()

def get_or_create_product(self, barcode):
    # Try cache first
    cached = self.cache.get_product_id(barcode)
    if cached:
        return cached
    ...
```
**סטטוס:** ❌ חסר
**זמן:** 3 שעות
**Impact:** 🔥🔥🔥🔥

### **Priority 3️⃣: Master Product Matching** (שבוע 2-3)

#### Task 3.1: Python Service
```python
# backend/services/master_product_matcher.py
class MasterProductMatcher:
    def find_or_create_master(self, barcode, name, region)
    def _search_by_barcode(self, barcode)
    def _search_by_embedding(self, name)
    def _create_with_llm(self, name, barcode)
```
**סטטוס:** ❌ חסר
**זמן:** 3 ימים
**Impact:** 🔥🔥🔥🔥🔥 (הפטנט!)

#### Task 3.2: Integration עם Import
```python
# לאחר import_product:
if not product_has_master:
    master_id = matcher.find_or_create_master(...)
    link_product_to_master(product_id, master_id)
```
**סטטוס:** ❌ חסר
**זמן:** 1 יום
**Impact:** 🔥🔥🔥🔥🔥

### **Priority 4️⃣: שיפור Scrapers** (שבוע 3-4)

#### Task 4.1: רפקטור PublishedPricesScraper
```python
# חלוקה לפונקציות קטנות
def _extract_csrf_token(self, soup)
def _post_login(self, csrf_token)
def _verify_login(self)
def _fetch_via_api(self, file_type, limit)
def _fetch_via_fallback(self, file_type, limit)
```
**סטטוס:** ⚠️ עובד אבל מסורבל
**זמן:** 1 יום
**Impact:** 🔥🔥🔥

#### Task 4.2: שיפור ShufersalScraper
```python
# 1. ייבוא store names מקובץ Stores
def _load_stores_from_file(self, stores_file)

# 2. שימוש ב-download_file המשותף
# 3. Pagination נכון
```
**סטטוס:** ⚠️ חלקי
**זמן:** 4 שעות
**Impact:** 🔥🔥🔥

#### Task 4.3: שיפור LaibCatalogScraper
```python
# 1. חיפוש חכם יותר
# 2. Support למספר stores
# 3. Import stores file
```
**סטטוס:** ⚠️ בסיסי
**זמן:** 3 שעות
**Impact:** 🔥🔥

---

## 📝 **Checklist - הצעדים הבאים**

### שבוע 1: Critical Fixes
```markdown
[ ] 1.1 - יצירת upsert_price function ב-SQL
[ ] 1.2 - הוספת indexes קריטיים
[ ] 1.3 - Batch processing ב-import_product
[ ] 2.1 - Redis Cache class
[ ] 2.2 - שילוב Cache ב-scrapers
[ ] TEST - ייבוא 10K products + מדידת ביצועים
```

### שבוע 2: Master Product
```markdown
[ ] 3.1 - MasterProductMatcher service (Python)
[ ] 3.2 - Integration עם import flow
[ ] 3.3 - OpenAI API setup + embeddings
[ ] 3.4 - pgvector extension ב-PostgreSQL
[ ] TEST - יצירת 100 master products + קישור
```

### שבוע 3-4: Scrapers Optimization
```markdown
[ ] 4.1 - רפקטור PublishedPricesScraper
[ ] 4.2 - שיפור ShufersalScraper
[ ] 4.3 - שיפור LaibCatalogScraper
[ ] 4.4 - תיעוד + examples
[ ] TEST - full import מכל המקורות
```

---

## 📊 **מדדי הצלחה**

### ביצועים:
```
Target מינימום:
✅ 100K products imported in < 60 seconds
✅ Cache hit rate > 95%
✅ DB queries < 5000 per 100K products
✅ אפס duplicates

Target אידיאלי:
⭐ 100K products in < 30 seconds
⭐ Cache hit rate > 99%
⭐ DB queries < 1000 per 100K products
```

### איכות:
```
✅ כל product עם barcode תקין
✅ כל product מקושר ל-master_product (תוך 1 שעה)
✅ כל price עם timestamp מדויק
✅ כל store עם GPS coordinates (תוך 24h)
```

---

## 🎯 **סיכום - מה חייבים לעשות עכשיו**

### **TOP 3 Priorities:**

1.  **יצירת upsert_price function** 
    - ללא זה, יש duplicates בלתי פוסקים
    - זמן: 2 שעות
    - Impact: קריטי

2. **Batch Processing**
    - ללא זה, ייבוא איטי פי 100
    - זמן: 4 שעות  
    - Impact: קריטי

3. **Redis Cache**
    - ללא זה, מיליוני queries מיותרים
    - זמן: 1 יום
    - Impact: קריטי

### **אחרי זה:**
4. Master Product Matching - הפטנט!
5. Scrapers optimization
6. Geocoding
7. Quality Control

---

## 💡 **המלצות נוספות**

### שיפורים ארכיטקטוניים:
1. **Kafka** - לAsync processing של Master Product Matching
2. **TimescaleDB** - להיסטוריית מחירים
3. **Docker Compose** - לסביבת dev מלאה
4. **CI/CD** - automated testing

### תיעוד:
1. API documentation (Swagger)
2. Code comments (בעברית למקומות קריטיים)
3. Examples בכל scraper
4. Video tutorials?

---

**תאריך הבא לסקירה:** 30 דצמבר 2025

**נוצר על ידי:** Antigravity AI
**גרסה:** 1.0
