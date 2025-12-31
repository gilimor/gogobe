# 📊 ארכיטקטורת בסיס הנתונים - מדריך מלא

## ✅ מבנה הטבלאות (Database Schema)

### 1. **טבלאות ישויות ראשיות**

#### 🏢 **verticals** - תחומים
```
dental, supermarket, electronics, fashion...
```
- כל מוצר שייך לתחום אחד
- מאפשר התמחות לפי תעשיה

#### 📦 **products** - מוצרים (13,280)
```
id, name, ean, upc, manufacturer_code, attributes...
```
- **מוצר = ישות ייחודית אחת**
- לא משוכפל - אם אותו ברקוד, זה אותו מוצר

#### 💰 **prices** - מחירים (265,628)
```
product_id, supplier_id, store_id, price, currency, scraped_at...
```
- **מחיר = נקודת מדידה אחת**
- מוצר אחד → מחירים רבים (סניפים, תאריכים)

#### 🏪 **chains** - רשתות (1)
```
id, name, name_he, chain_id, chain_type...
```
- KingStore, Shufersal, Rami Levy...

#### 🏬 **stores** - סניפים (14)
```
id, chain_id, store_id, name, city, address...
```
- כל סניף שייך לרשת אחת
- קינג סטור - סניף 1, סניף 2...

#### 🏭 **suppliers** - ספקים (5)
```
id, name, slug, supplier_type...
```
- KingStore, דנטל גרופ...

#### 💱 **currencies** - מטבעות (4)
```
code, name, symbol, exchange_rate...
```
- ILS (₪), USD ($), EUR (€), GBP (£)

---

### 2. **טבלאות קישור**

#### 🔗 **supplier_chains**
```
supplier_id ↔ chain_id
```
- ספק יכול לייצג מספר רשתות

#### 🔗 **product_merges** - איחוד מוצרים (חדש!)
```
master_product_id ← duplicate_product_id
```
- לטיפול במוצרים כפולים עם שמות דומים

---

### 3. **טבלאות תמיכה**

#### 📂 **categories** - קטגוריות (150)
```
id, vertical_id, parent_id, name, level, full_path...
```
- היררכיה: חטיפים → חטיפי שוקולד → שוקולד מריר

#### 🏷️ **brands** - מותגים
```
id, name, country, is_premium...
```
- תנובה, אסם, קוקה קולה...

---

## 🔄 לוגיקת ייבוא (Import Flow)

### שלב 1️⃣: קריאת קובץ XML
```python
metadata, items = parse_xml("Store_2_20251220.xml")
# metadata = {chain_id, store_id, store_name, bikoret_no...}
# items = [{item_code, item_name, price, ...}, ...]
```

### שלב 2️⃣: וידוא קיום רשת
```python
chain_id = get_or_create_chain(
    chain_id='7290172900007',
    name='KingStore',
    name_he='קינגסטור'
)
```
**לוגיקה:**
- חפש לפי `chain_id`
- אם לא קיים → **צור רשת חדשה**
- החזר `chain_id` (מזהה פנימי)

### שלב 3️⃣: וידוא קיום סניף
```python
store_id = get_or_create_store(
    chain_id=chain_id,
    store_id='2',
    name='קינג סטור - סניף 2',
    city=None,
    bikoret_no=None
)
```
**לוגיקה:**
- חפש לפי `chain_id + store_id`
- אם לא קיים → **צור סניף חדש**
- החזר `store_id` (מזהה פנימי)

### שלב 4️⃣: וידוא קיום מטבע
```python
currency_code = get_or_create_currency(
    code='ILS',
    name='Israeli Shekel',
    symbol='₪'
)
```
**לוגיקה:**
- חפש לפי `code`
- אם לא קיים → **צור מטבע חדש**
- החזר `code`

### שלב 5️⃣: חיפוש/יצירת מוצר
```python
product_id = find_product_id(
    ean='7290110563547',
    manufacturer_code='7290110563547',
    name='סטנג גדול - קפואי גדול שטראוס',
    vertical_id=1  # supermarket
)

if not product_id:
    # מוצר לא קיים - צור חדש
    product_id = create_product(...)
```

**לוגיקת חיפוש (לפי סדר עדיפות):**
1. **EAN** (ברקוד אירופאי) ← **עדיפות גבוהה!**
2. **UPC** (ברקוד אמריקאי)
3. **manufacturer_code** (קוד יצרן)
4. **name + vertical_id** (שם מדויק)

**חשוב:** אם מצאנו → לא יוצרים כפילות!

### שלב 6️⃣: יצירת מחיר (תמיד!)
```python
create_price(
    product_id=product_id,
    supplier_id=supplier_id,  # KingStore
    store_id=store_id,        # סניף 2 (אופציונלי)
    price=10.50,
    currency='ILS',
    scraped_at='2025-12-20 15:30:00'
)
```

**חשוב:** מחיר **תמיד נוצר חדש** - זו היסטוריה!

---

## 📐 דוגמת Flow מלאה

```
┌─────────────────────────────────────────────┐
│ XML: Store_2_20251220.xml                  │
└─────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│ Parse XML                                   │
│ ├─ chain_id: 7290172900007                 │
│ ├─ store_id: 2                             │
│ └─ items: 1000 מוצרים                      │
└─────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│ וידוא רשת: KingStore                       │
│ → קיים? ✓ → chain_id = 1                   │
└─────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│ וידוא סניף: קינג סטור - סניף 2            │
│ → קיים? ✓ → store_id = 2                   │
└─────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│ עבור כל מוצר בקובץ:                        │
│                                             │
│ מוצר: "גבינת עמק 28%"                      │
│ ├─ EAN: 7290110563547                      │
│ ├─ price: 52.30                            │
│ └─ currency: ILS                           │
└─────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│ חיפוש מוצר לפי EAN                         │
│ → SELECT id FROM products                  │
│   WHERE ean = '7290110563547'              │
│ → מצא! product_id = 42507                  │
└─────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│ יצירת מחיר חדש                             │
│ INSERT INTO prices                         │
│ ├─ product_id: 42507                       │
│ ├─ supplier_id: 5 (KingStore)             │
│ ├─ store_id: 2 (סניף 2)                   │
│ ├─ price: 52.30                            │
│ ├─ currency: ILS                           │
│ └─ scraped_at: 2025-12-20 15:30:00        │
└─────────────────────────────────────────────┘
              │
              ▼
         ✅ הושלם!
```

---

## 🎯 כללי ייבוא חשובים

### ✅ DO (לעשות):
1. **תמיד בדוק קיום** לפני יצירה
2. **השתמש ב-EAN כעדיפות ראשונה** - זה הכי אמין
3. **צור רשת/סניף/מטבע אוטומטית** אם חסרים
4. **צור מחיר חדש תמיד** - זו היסטוריה
5. **שמור metadata** ב-`attributes` (JSONB)

### ❌ DON'T (לא לעשות):
1. **אל תשכפל מוצרים** - אם יש EAN, זה אותו מוצר
2. **אל תעדכן מחירים ישנים** - תמיד צור חדש
3. **אל תתעלם משגיאות** - לוג ותדלג
4. **אל תיצור מטבע ללא validation**

---

## 📊 יחסים (Relationships)

```
verticals (1) ──→ (∞) products
products  (1) ──→ (∞) prices
chains    (1) ──→ (∞) stores
suppliers (∞) ←──→ (∞) chains (via supplier_chains)
stores    (1) ──→ (∞) prices
currencies(1) ──→ (∞) prices
```

---

## ⚡ Performance Optimization (Dec 2025)

To support scaling to billions of records, we implemented several optimizations:

### 1. Composite Indexes
We added specialized indexes to the `prices` table that match common API query patterns:
```sql
-- For default sorting "Latest Prices"
CREATE INDEX idx_prices_default_sort ON prices (scraped_at DESC, price ASC);
-- For filtering by store
CREATE INDEX idx_prices_store_sort ON prices (store_id, scraped_at DESC);
-- For product history
CREATE INDEX idx_prices_product_sort ON prices (product_id, scraped_at DESC);
```

### 2. Smart Count Queries
The API (`main.py`) logic for counting total records was optimized:
*   **No Filters:** Uses PostgreSQL table statistics (`reltuples`) for an instant estimate 0ms vs 5s).
*   **With Filters:** Removes unnecessary `LEFT JOIN`s (e.g. to `prices` table) when filtering only by product properties, resulting in 95% faster queries.

---

## 🌍 Geospatial Support (PostGIS)

We migrated to `postgis/postgis` image to enable advanced mapping features.

### Stores Table Schema Update
*   **Added:** `latitude` (Numeric), `longitude` (Numeric)
*   **Added:** `geom` (Geometry Point, SRID 4326)
*   **Index:** Spatial index (GIST) on `geom` column for fast proximity searches.

This enables future features like "Stores near me" using:
```sql
SELECT * FROM stores 
ORDER BY geom <-> ST_SetSRID(ST_MakePoint(lon, lat), 4326) 
LIMIT 5;
```

---

## 🔮 תכנון עתידי

### 1. **product_merges** - איחוד כפילויות
```sql
-- דוגמה: "חלב תנובה 1L" = "חלב תנובה ליטר"
INSERT INTO product_merges 
(master_product_id, duplicate_product_id, merge_reason)
VALUES (1234, 5678, 'Same product, different name');
```

**שימוש:**
```sql
-- כל שאילתה תשתמש ב-view המאוחד
SELECT * FROM v_products_unified;
-- מחזיר מוצרים עם הפניה לאב
```

### 2. **price_alerts** - התרעות מחיר
```sql
CREATE TABLE price_alerts (
    user_id INT,
    product_id BIGINT,
    target_price DECIMAL,
    alert_when TEXT  -- 'below', 'above'
);
```

### 3. **user_favorites** - מוצרים מועדפים
```sql
CREATE TABLE user_favorites (
    user_id INT,
    product_id BIGINT,
    added_at TIMESTAMP
);
```

---

## 📈 סטטיסטיקות

```sql
SELECT * FROM v_import_statistics;
```

| entity    | total   | active  | added_today |
|-----------|---------|---------|-------------|
| products  | 13,280  | 13,280  | 13,280      |
| prices    | 265,628 | 265,628 | 265,628     |
| chains    | 1       | 1       | 1           |
| stores    | 14      | 14      | 14          |
| suppliers | 5       | 5       | 5           |

---

## ✅ סיכום

**המערכת מבוססת על:**
1. ✅ **הפרדה ברורה**: מוצר ≠ מחיר
2. ✅ **חיפוש חכם**: EAN > UPC > Code > Name
3. ✅ **יצירה אוטומטית**: רשתות/סניפים/מטבעות
4. ✅ **היסטוריה מלאה**: כל מחיר = רשומה
5. ✅ **גמישות**: JSONB attributes
6. ✅ **איחוד עתידי**: product_merges

**האם הבנתי נכון? 🎯**

