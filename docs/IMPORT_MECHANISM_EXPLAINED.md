# 📚 מדריך מקיף - מנגנון הייבוא במערכת Gogobe

## תאריך: 21 דצמבר 2025

---

## 🎯 סקירה כללית

מסמך זה מסביר את **כל המנגנונים** שפועלים בעת ייבוא נתונים למערכת Gogobe:
- ✅ איך נוצרים/נבדקים סניפים
- ✅ האם יש Geocoding (קואורדינטות GPS)
- ✅ איך מוצרים חדשים מקושרים לאב מוצר (Master Product)
- ✅ מנגנון מניעת כפילויות במחירים
- ✅ תמיכה במטבעות שונים
- ✅ ועוד...

---

## 📍 1. מנגנון ניהול סניפים (Stores)

### 1.1 איך נוצר/נבדק סניף?

**קובץ:** `backend/scrapers/base_supermarket_scraper.py` - פונקציה `get_or_create_store()`

```python
def get_or_create_store(self, store: ParsedStore) -> Optional[int]:
    """
    Get or create store in database
    """
    # בניית מזהה ייחודי לסניף
    unique_store_code = self.build_store_identifier(store)
    
    # בדיקה: האם הסניף כבר קיים?
    SELECT id FROM stores
    WHERE chain_id = %s AND store_id = %s
    
    # אם קיים - מחזיר את ה-ID
    if result:
        return result[0]
    
    # אם לא קיים - יוצר סניף חדש
    INSERT INTO stores (chain_id, store_id, name, city, address, bikoret_no)
    VALUES (...)
    ON CONFLICT (chain_id, store_id) 
    DO UPDATE SET
        name = EXCLUDED.name,
        city = EXCLUDED.city,
        address = EXCLUDED.address,
        bikoret_no = EXCLUDED.bikoret_no
    RETURNING id
```

**תשובה לשאלה:** 
- ✅ **כן, המערכת בודקת אם הסניף קיים לפני יצירה**
- ✅ השימוש ב-`ON CONFLICT` מבטיח שלא ייווצרו כפילויות
- ✅ אם הסניף קיים, המערכת **מעדכנת** את הפרטים (שם, עיר, כתובת)

### 1.2 מבנה מזהה הסניף

**פונקציה:** `build_store_identifier()`

```python
def build_store_identifier(self, store: ParsedStore) -> str:
    """
    Default: {chain_id}_{store_id}
    Examples:
    - Rami Levy: "7290058140886_001"
    - Shufersal: "7290027600007_123"
    """
    return f"{self.chain_id}_{store.store_id}"
```

**למה זה חשוב?**
- מבטיח שסניף מספר 001 של רמי לוי ≠ סניף מספר 001 של שופרסל
- מאפשר לרשתות שונות להשתמש באותם מספרי סניפים

---

## 🌍 2. Geocoding - קואורדינטות GPS

### 2.1 האם לסניפים יש Geocoding?

**תשובה:** ✅ **כן, אבל לא אוטומטי בייבוא!**

**מבנה הטבלה:**
```sql
-- backend/database/add_chains_stores.sql
CREATE TABLE stores (
    id BIGSERIAL PRIMARY KEY,
    chain_id INTEGER REFERENCES store_chains(id),
    store_id VARCHAR(50) NOT NULL,
    name VARCHAR(200),
    city VARCHAR(100),
    address VARCHAR(300),
    latitude DECIMAL(10, 8),      -- ✅ קיים!
    longitude DECIMAL(10, 8),     -- ✅ קיים!
    geom GEOMETRY(Point, 4326),   -- ✅ PostGIS geometry
    ...
);

CREATE INDEX idx_stores_location ON stores(latitude, longitude);
```

### 2.2 איך מתבצע Geocoding?

**קובץ:** `backend/scripts/geocode_stores.py`

```python
def geocode_address(address, city, retry=True):
    """Geocode address using Nominatim (OSM)"""
    base_url = "https://nominatim.openstreetmap.org/search"
    
    # Try full address first
    query = f"{address}, {city}, Israel"
    
    response = requests.get(base_url, params={'q': query, 'format': 'json'})
    if response.status_code == 200:
        data = response.json()
        if data:
            return float(data[0]['lat']), float(data[0]['lon'])
    
    # Fallback to just city
    if retry and address:
        return geocode_address(None, city, retry=False)
```

**תהליך:**
1. הסקריפט מחפש סניפים עם `latitude IS NULL`
2. שולח בקשה ל-OpenStreetMap Nominatim API
3. מעדכן את `latitude`, `longitude`, ו-`geom`
4. ממתין 1.5 שניות בין בקשות (כדי לא לעבור Rate Limit)

**הרצה:**
```bash
docker-compose exec -T api python /app/backend/scripts/geocode_stores.py
```

**חשוב:** 
- ❌ Geocoding **לא מתבצע אוטומטית** בייבוא
- ✅ צריך להריץ את הסקריפט **ידנית** אחרי ייבוא סניפים חדשים
- ✅ השימוש במפה (`/map.html`) דורש Geocoding

---

## 🏷️ 3. מוצרים ואב מוצר (Master Products)

### 3.1 מבנה ההיררכיה

```
Master Product (אב מוצר)
    ├── Product 1 (רמי לוי - חלב תנובה 3%)
    ├── Product 2 (שופרסל - חלב תנובה 3%)
    └── Product 3 (יינות ביתן - חלב תנובה 3%)
```

**טבלאות:**
```sql
-- backend/database/migrations/001_add_master_products.sql

-- 1. טבלת אב מוצרים
CREATE TABLE master_products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    main_image_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 2. טבלת קישורים בין מוצר לאב מוצר
CREATE TABLE product_master_links (
    id BIGSERIAL PRIMARY KEY,
    master_product_id BIGINT REFERENCES master_products(id),
    product_id BIGINT UNIQUE REFERENCES products(id),
    confidence_score DECIMAL(3,2) DEFAULT 1.0,
    match_method VARCHAR(50), -- 'manual', 'llm', 'rule-based'
    created_at TIMESTAMP DEFAULT NOW()
);

-- 3. עמודה בטבלת מחירים
ALTER TABLE prices 
    ADD COLUMN master_product_id BIGINT REFERENCES master_products(id);
```

### 3.2 האם מחירים חדשים מקושרים אוטומטית לאב מוצר?

**תשובה:** ❌ **לא אוטומטי בייבוא!**

**מה קורה בייבוא?**

```python
# backend/scrapers/base_supermarket_scraper.py - import_product()

def import_product(self, product: ParsedProduct, store_id: Optional[int] = None):
    # 1. בדיקה: האם המוצר קיים (לפי ברקוד)?
    SELECT id FROM products
    WHERE (ean = %s OR manufacturer_code = %s)
    
    # 2. אם לא קיים - יצירת מוצר חדש
    if not product_id:
        INSERT INTO products (name, ean, manufacturer_code, ...)
        VALUES (...)
        
    # 3. הוספת מחיר (ללא קישור ל-master_product!)
    SELECT upsert_price(
        product_id,
        supplier_id,
        store_id,
        price,
        'ILS',
        TRUE,
        0.01
    )
```

**למה אין קישור אוטומטי?**
- קישור מוצרים לאב מוצר דורש **לוגיקה חכמה** (AI/LLM או כללים)
- לא כל מוצר צריך אב מוצר (יש מוצרים ייחודיים)
- הקישור צריך להיות **מדויק** כדי לא לקשר מוצרים שונים

**איך לקשר מוצרים לאב מוצר?**
1. **ידני:** דרך ממשק ניהול (טרם מומש)
2. **חצי אוטומטי:** סקריפט שמזהה מוצרים דומים לפי ברקוד/שם
3. **AI/LLM:** שימוש ב-AI לזיהוי מוצרים זהים

---

## 🔄 4. מנגנון מניעת כפילויות במחירים

### 4.1 הפונקציה החכמה: `upsert_price()`

**קובץ:** `backend/database/optimize_prices_table.sql`

```sql
CREATE OR REPLACE FUNCTION upsert_price(
    p_product_id BIGINT,
    p_supplier_id INTEGER,
    p_store_id INTEGER,
    p_price DECIMAL(12,2),
    p_currency CHAR(3),
    p_is_available BOOLEAN DEFAULT TRUE,
    p_price_tolerance DECIMAL DEFAULT 0.01  -- סובלנות: 1 אגורה
) RETURNS BIGINT AS $$
DECLARE
    v_price_id BIGINT;
    v_existing_price DECIMAL(12,2);
BEGIN
    -- חיפוש מחיר קיים
    SELECT id, price INTO v_price_id, v_existing_price
    FROM prices
    WHERE product_id = p_product_id
        AND supplier_id = p_supplier_id
        AND (store_id = p_store_id OR (store_id IS NULL AND p_store_id IS NULL))
        AND currency = p_currency
        AND is_available = p_is_available
    ORDER BY last_scraped_at DESC NULLS LAST, scraped_at DESC
    LIMIT 1;
    
    -- אם המחיר זהה (בתוך סובלנות של 1 אגורה)
    IF v_price_id IS NOT NULL AND 
       ABS(v_existing_price - p_price) <= p_price_tolerance THEN
        
        -- ✅ רק עדכון last_scraped_at (לא יוצר רשומה חדשה!)
        UPDATE prices
        SET last_scraped_at = NOW(),
            scraped_at = NOW()
        WHERE id = v_price_id;
        
        RETURN v_price_id;
    ELSE
        -- ✅ המחיר השתנה - יצירת רשומה חדשה
        INSERT INTO prices (
            product_id, supplier_id, store_id, price, currency,
            is_available, first_scraped_at, last_scraped_at, scraped_at
        ) VALUES (
            p_product_id, p_supplier_id, p_store_id, p_price, p_currency,
            p_is_available, NOW(), NOW(), NOW()
        )
        RETURNING id INTO v_price_id;
        
        RETURN v_price_id;
    END IF;
END;
$$ LANGUAGE plpgsql;
```

### 4.2 איך זה עובד?

**תרחיש 1: מחיר לא השתנה**
```
יום 1: חלב תנובה - 5.90 ₪ → רשומה חדשה (ID: 1)
יום 2: חלב תנובה - 5.90 ₪ → עדכון last_scraped_at (ID: 1) ✅
יום 3: חלב תנובה - 5.91 ₪ → עדכון last_scraped_at (ID: 1) ✅ (בתוך סובלנות!)
```

**תרחיש 2: מחיר השתנה**
```
יום 1: חלב תנובה - 5.90 ₪ → רשומה חדשה (ID: 1)
יום 2: חלב תנובה - 5.90 ₪ → עדכון (ID: 1)
יום 3: חלב תנובה - 6.50 ₪ → רשומה חדשה (ID: 2) ✅ (שינוי מעל סובלנות!)
```

**יתרונות:**
- ✅ **חוסך מקום:** לא יוצר מיליוני רשומות זהות
- ✅ **שומר היסטוריה:** רואים מתי המחיר השתנה
- ✅ **מהיר:** אינדקס מותאם לחיפוש מהיר

### 4.3 עמודות מיוחדות

```sql
ALTER TABLE prices 
    ADD COLUMN first_scraped_at TIMESTAMP DEFAULT NOW(),  -- מתי נראה לראשונה
    ADD COLUMN last_scraped_at TIMESTAMP;                 -- מתי אושר לאחרונה
```

**דוגמה:**
```
ID | product_id | price | first_scraped_at | last_scraped_at | days_stable
1  | 123        | 5.90  | 2025-12-01       | 2025-12-15      | 14 ימים
2  | 123        | 6.50  | 2025-12-16       | 2025-12-21      | 5 ימים
```

---

## 💰 5. תמיכה במטבעות שונים

### 5.1 מבנה הטבלה

```sql
CREATE TABLE prices (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES products(id),
    price DECIMAL(12,2) NOT NULL,
    currency CHAR(3) DEFAULT 'ILS',  -- ✅ תמיכה במטבעות!
    ...
);
```

### 5.2 מטבעות נתמכים

**כרגע:**
- ✅ `ILS` - שקל ישראלי (ברירת מחדל)
- ✅ `USD` - דולר אמריקאי
- ✅ `EUR` - יורו
- ✅ כל מטבע ISO 4217 (3 תווים)

**בייבוא:**
```python
# backend/scrapers/base_supermarket_scraper.py
SELECT upsert_price(
    product_id,
    supplier_id,
    store_id,
    price,
    'ILS',  # ✅ כרגע קבוע ל-ILS
    TRUE,
    0.01
)
```

**כדי לתמוך במטבעות נוספים:**
1. שנה את הסקריפט לקבל `currency` כפרמטר
2. הוסף המרת מטבע (API חיצוני או טבלת שערים)
3. עדכן את הממשק להציג מחירים במטבע המקומי

---

## 🧹 6. מנגנון ניקוי כפילויות במוצרים

### 6.1 הבעיה

```
product_id | name                  | ean
1          | חלב תנובה 3%          | 7290000000001
2          | חלב תנובה 3 אחוז      | 7290000000001  ← כפילות!
3          | Tnuva Milk 3%         | 7290000000001  ← כפילות!
```

### 6.2 הפתרון: `deduplicate_products.py`

**קובץ:** `scripts/database/deduplicate_products.py`

```python
def find_duplicates(conn):
    """Find potential duplicate products"""
    
    # 1. מוצרים עם אותו ברקוד
    SELECT ean, COUNT(*) as product_count, array_agg(id) as product_ids
    FROM products
    WHERE ean IS NOT NULL
    GROUP BY ean
    HAVING COUNT(*) > 1
    
    # 2. מוצרים עם שמות דומים (85%+ דמיון)
    for row in products:
        ratio = similarity_ratio(name1, name2)
        if ratio > 0.85:
            similar_products.append(...)

def merge_products(conn, master_id, duplicate_ids, dry_run=True):
    """Merge duplicate products into one master product"""
    
    # 1. העבר את כל המחירים למוצר הראשי
    UPDATE prices
    SET product_id = master_id
    WHERE product_id IN (duplicate_ids)
    
    # 2. מחק את המוצרים הכפולים
    DELETE FROM products
    WHERE id IN (duplicate_ids)
```

**הרצה:**
```bash
# Dry Run - רק תצוגה
cd scripts/database
python deduplicate_products.py
# בחר אפשרות 1

# ביצוע אמיתי
python deduplicate_products.py
# בחר אפשרות 2 → הקלד "yes"
```

**תוצאה:**
```
🔍 מחפש מוצרים כפולים...
   נמצאו 15 ברקודים כפולים
   
🔀 איחוד אוטומטי לפי ברקוד
   מוצר ראשי: 1
   מוצרים לאיחוד: [2, 3]
   ✓ הועברו 244 מחירים ממוצר 2
   ✓ הועברו 189 מחירים ממוצר 3
   ✓ נמחקו 2 מוצרים כפולים
   ✅ האיחוד הושלם!
```

---

## 📊 7. סטטיסטיקות ותצוגות (Views)

### 7.1 מחירים נוכחיים

```sql
-- backend/database/optimize_prices_table.sql
CREATE VIEW v_current_prices AS
SELECT DISTINCT ON (product_id, supplier_id, COALESCE(store_id, -1))
    id, product_id, price, currency,
    first_scraped_at,
    last_scraped_at,
    -- כמה זמן המחיר יציב?
    EXTRACT(EPOCH FROM (last_scraped_at - first_scraped_at))/86400 as days_stable
FROM prices
WHERE is_available = TRUE
ORDER BY product_id, supplier_id, store_id, last_scraped_at DESC;
```

**שימוש:**
```sql
-- מחיר נוכחי של מוצר 123 בסניף 456
SELECT * FROM v_current_prices
WHERE product_id = 123 AND store_id = 456;
```

### 7.2 היסטוריית מחירים

```sql
CREATE VIEW v_price_history AS
SELECT 
    product_id, price,
    first_scraped_at as price_from,
    last_scraped_at as price_to,
    -- שינוי מחיר
    price - LAG(price) OVER (...) as price_change,
    -- אחוז שינוי
    ROUND(((price - LAG(price)) / LAG(price)) * 100, 2) as price_change_percent
FROM prices
ORDER BY product_id, first_scraped_at DESC;
```

**שימוש:**
```sql
-- היסטוריית מחירים של חלב תנובה
SELECT * FROM v_price_history
WHERE product_id = 123
ORDER BY price_from DESC;
```

### 7.3 סטטיסטיקות דחיסה

```sql
CREATE VIEW v_price_compression_stats AS
SELECT 
    COUNT(*) as total_price_records,
    COUNT(DISTINCT (product_id, supplier_id, store_id)) as unique_combinations,
    COUNT(*) FILTER (WHERE last_scraped_at IS NOT NULL) as compressed_records,
    ROUND(COUNT(*) FILTER (WHERE last_scraped_at IS NOT NULL) * 100.0 / COUNT(*), 2) 
        as compression_rate_percent
FROM prices;
```

**תוצאה:**
```
total_price_records | unique_combinations | compressed_records | compression_rate_percent
10,000             | 3,500               | 6,500              | 65.00%
```

**פירוש:** 65% מהרשומות הן עדכוני `last_scraped_at` (לא רשומות חדשות!)

---

## 🔍 8. שאלות ותשובות נפוצות

### ש: האם ביבוא נוצר סניף חדש או נבדק שיש כבר סניף כזה?

**ת:** ✅ **נבדק תמיד!** המערכת משתמשת ב-`ON CONFLICT` כדי למנוע כפילויות.
```sql
INSERT INTO stores (chain_id, store_id, name, ...)
VALUES (...)
ON CONFLICT (chain_id, store_id) 
DO UPDATE SET name = EXCLUDED.name, ...
```

---

### ש: האם לסניף יש Geocoding?

**ת:** ✅ **כן, אבל לא אוטומטי!**
- הטבלה תומכת ב-`latitude`, `longitude`, `geom`
- צריך להריץ `backend/scripts/geocode_stores.py` ידנית
- משתמש ב-OpenStreetMap Nominatim API (חינם)

---

### ש: האם מחירים חדשים הגיעו ויש להם שיוך לאב מוצר?

**ת:** ❌ **לא אוטומטי!**
- הטבלאות קיימות (`master_products`, `product_master_links`)
- הקישור צריך להיעשות **ידנית** או דרך **סקריפט חכם**
- כרגע: כל מוצר עומד בפני עצמו

---

### ש: האם יש מנגנון מחיקת כפילויות?

**ת:** ✅ **כן, בשני רמות:**

1. **מחירים:** `upsert_price()` מונע כפילויות אוטומטית
2. **מוצרים:** `scripts/database/deduplicate_products.py` (ידני)

---

### ש: האם יש תמיכה במטבע אחר?

**ת:** ✅ **כן, הטבלה תומכת!**
- עמודה: `currency CHAR(3)` (ISO 4217)
- כרגע: הסקריפטים משתמשים רק ב-`ILS`
- כדי להוסיף: שנה את הסקריפט + הוסף המרת מטבע

---

## 🚀 9. תהליך ייבוא מלא - צעד אחר צעד

### שלב 1: ייבוא נתונים
```bash
# ייבוא רמי לוי (Stores + Prices)
docker-compose exec -T api python /app/backend/scrapers/published_prices_scraper.py
```

**מה קורה:**
1. ✅ התחברות לפלטפורמה
2. ✅ הורדת קבצים (Stores + Prices)
3. ✅ יצירת/עדכון סניפים (אם קיימים)
4. ✅ יצירת מוצרים חדשים (אם לא קיימים)
5. ✅ הוספת מחירים (עם מניעת כפילויות)

### שלב 2: Geocoding
```bash
# הוספת קואורדינטות GPS לסניפים
docker-compose exec -T api python /app/backend/scripts/geocode_stores.py
```

**מה קורה:**
1. ✅ חיפוש סניפים ללא `latitude`
2. ✅ שליחת בקשה ל-OpenStreetMap
3. ✅ עדכון `latitude`, `longitude`, `geom`

### שלב 3: ניקוי כפילויות (אופציונלי)
```bash
# איחוד מוצרים כפולים
cd scripts/database
python deduplicate_products.py
```

**מה קורה:**
1. ✅ זיהוי מוצרים עם אותו ברקוד
2. ✅ זיהוי מוצרים עם שמות דומים
3. ✅ איחוד מוצרים (העברת מחירים + מחיקת כפילויות)

### שלב 4: בדיקת תוצאות
```sql
-- כמה סניפים יובאו?
SELECT COUNT(*) FROM stores WHERE chain_id = (
    SELECT id FROM store_chains WHERE name = 'Rami Levy'
);

-- כמה מוצרים?
SELECT COUNT(*) FROM products;

-- כמה מחירים?
SELECT COUNT(*) FROM prices;

-- אחוז דחיסה?
SELECT * FROM v_price_compression_stats;
```

---

## 📝 10. סיכום

### מה עובד אוטומטית? ✅
1. ✅ בדיקת קיום סניפים (מניעת כפילויות)
2. ✅ בדיקת קיום מוצרים (לפי ברקוד)
3. ✅ מניעת כפילויות במחירים (`upsert_price`)
4. ✅ עדכון פרטי סניפים (שם, כתובת)

### מה דורש פעולה ידנית? ⚠️
1. ⚠️ Geocoding (הרצת סקריפט)
2. ⚠️ קישור לאב מוצר (טרם מומש)
3. ⚠️ ניקוי כפילויות במוצרים (סקריפט ידני)
4. ⚠️ המרת מטבעות (טרם מומש)

### מה חסר? ❌
1. ❌ קישור אוטומטי לאב מוצר (צריך AI/LLM)
2. ❌ Geocoding אוטומטי בייבוא
3. ❌ המרת מטבעות בזמן אמת
4. ❌ ממשק ניהול לאב מוצרים

---

## 📚 קבצים רלוונטיים

### סקריפטים
- `backend/scrapers/base_supermarket_scraper.py` - מנגנון ייבוא בסיסי
- `backend/scrapers/published_prices_scraper.py` - ייבוא מ-PublishedPrices
- `backend/scripts/geocode_stores.py` - Geocoding
- `scripts/database/deduplicate_products.py` - ניקוי כפילויות

### SQL
- `backend/database/add_chains_stores.sql` - מבנה טבלאות
- `backend/database/optimize_prices_table.sql` - פונקציית `upsert_price`
- `backend/database/migrations/001_add_master_products.sql` - אב מוצרים

### תיעוד
- `PUBLISHED_PRICES_FIX_SUMMARY.md` - תיקונים אחרונים
- `IMPORT_CHAIN_CHECKLIST.md` - צ'קליסט ייבוא רשת חדשה

---

**עודכן לאחרונה:** 21 דצמבר 2025
**גרסה:** 1.0
