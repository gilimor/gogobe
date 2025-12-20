# 📊 מבנה בסיס הנתונים - Gogobe

## ✅ המבנה הנוכחי (מנורמל ואופטימלי)

### 🎯 עקרונות התכנון

בסיס הנתונים בנוי על פי **Database Normalization** - כל מידע נשמר פעם אחת במקום מרכזי.

### 📋 הטבלאות העיקריות

```
┌─────────────────────────────────────────────────────────────┐
│                    מוצרים ומחירים                            │
└─────────────────────────────────────────────────────────────┘

products (מוצרים)
├── id, name, description
├── vertical_id → verticals (תחום: דנטלי, סופרמרקט, אופנה)
├── category_id → categories (קטגוריה: משחת שיניים, חלב, נעליים)
├── brand_id → brands (מותג: קולגייט, תנובה, נייקי)
├── ean, upc, model_number (מזהים)
└── attributes, specifications (JSON)

prices (מחירים)
├── id
├── product_id → products (איזה מוצר)
├── supplier_id → suppliers (ספק: KingStore, Shufersal)
├── store_id → stores (חנות ספציפית: סניף 200, סניף 13)
├── price, currency (מחיר ומטבע)
├── scraped_at (מתי נסרק)
└── is_available, stock_level

┌─────────────────────────────────────────────────────────────┐
│                 חנויות ורשתות                                │
└─────────────────────────────────────────────────────────────┘

stores (חנויות)
├── id
├── store_name (שם: "KingStore סניף רמת השרון")
├── store_code (קוד מהמערכת: "200")
├── chain_id → store_chains
├── city, address
└── is_active

store_chains (רשתות)
├── id
├── chain_name ("KingStore", "Shufersal")
├── chain_code (קוד רשמי)
├── price_source_id → price_sources
└── country_code

price_sources (מקורות מחירים)
├── id
├── name ("KingStore")
├── url ("https://kingstore.binaprojects.com")
├── source_type ("supermarket")
└── is_active, last_check_at

┌─────────────────────────────────────────────────────────────┐
│               מעקב אחר סריקות                                │
└─────────────────────────────────────────────────────────────┘

downloaded_files (קבצים שהורדו)
├── filename, file_hash (למנוע כפילויות)
├── store_id → stores
├── processing_status (pending/processing/completed/failed)
├── products_imported, prices_imported
└── downloaded_at, processing_completed_at

scraping_sessions (סשנים של סריקה)
├── session_name
├── price_source_id → price_sources
├── files_found, files_downloaded, files_processed
├── total_products_imported, total_prices_imported
└── started_at, completed_at, duration_seconds

┌─────────────────────────────────────────────────────────────┐
│               טבלאות עזר                                     │
└─────────────────────────────────────────────────────────────┘

suppliers (ספקים)
├── id, name, slug
├── country_code, website
└── is_active

categories (קטגוריות)
├── id, name, slug
├── vertical_id → verticals
└── parent_id (לקטגוריות מקוננות)

verticals (תחומים)
├── id, name, slug
└── description

brands (מותגים)
├── id, name, slug
└── country_code
```

## 🎯 היתרונות של המבנה הזה

### 1️⃣ **חיסכון במקום אחסון**
- שם חנות נשמר **פעם אחת** בטבלת `stores`
- לא חוזר על עצמו בכל `price` (מאות אלפי פעמים!)
- במקום שם, רק `store_id` (מספר שלם = 4 bytes במקום עשרות תווים)

**דוגמה:**
```sql
-- ❌ לא יעיל (חזרה על נתונים)
prices: 
  product_id | store_name                      | city          | price
  123        | KingStore סניף רמת השרון       | רמת השרון     | 10.50
  456        | KingStore סניף רמת השרון       | רמת השרון     | 15.00
  789        | KingStore סניף רמת השרון       | רמת השרון     | 20.00
  
-- ✅ יעיל (מנורמל)
stores:
  id | store_name                      | city          
  1  | KingStore סניף רמת השרון       | רמת השרון     

prices:
  product_id | store_id | price
  123        | 1        | 10.50
  456        | 1        | 15.00
  789        | 1        | 20.00
```

### 2️⃣ **עדכון קל וזריז**
- שם חנות השתנה? עדכון **במקום אחד** בלבד
- לא צריך לעדכן מאות אלפי רשומות

```sql
-- עדכון במקום אחד בלבד
UPDATE stores 
SET store_name = 'KingStore - רמת השרון (מעודכן)'
WHERE id = 1;

-- כל המחירים אוטומטית מצביעים על השם המעודכן!
```

### 3️⃣ **שלמות נתונים (Data Integrity)**
- אי אפשר להוסיף מחיר לחנות שלא קיימת (Foreign Key)
- אי אפשר למחוק חנות עם מחירים (מוגן)

```sql
-- ❌ זה יכשל - חנות 999 לא קיימת
INSERT INTO prices (product_id, store_id, price)
VALUES (123, 999, 10.50);
-- ERROR: violates foreign key constraint
```

### 4️⃣ **שאילתות מהירות**
- אינדקסים על `store_id` מאפשרים JOIN מהיר
- PostgreSQL מבצע JOIN ביעילות רבה

```sql
-- שאילתה מהירה עם JOIN
SELECT p.name, pr.price, s.store_name, s.city
FROM products p
JOIN prices pr ON p.id = pr.product_id
JOIN stores s ON pr.store_id = s.id
WHERE s.city = 'תל אביב'
ORDER BY pr.price;

-- ⚡ מהיר בזכות אינדקסים על המפתחות הזרים
```

### 5️⃣ **גמישות למידע נוסף**
- רוצים להוסיף טלפון לחנות? עמודה אחת בלבד
- רוצים לעקוב אחר שעות פתיחה? נוסיף ל-`stores`

```sql
-- הוספת מידע נוסף קלה
ALTER TABLE stores 
ADD COLUMN phone VARCHAR(20),
ADD COLUMN opening_hours JSONB;
```

## 📊 דוגמת שאילתא מורכבת

```sql
-- מצא את המחיר הזול ביותר לכל מוצר בתל אביב
SELECT 
    p.name AS product_name,
    MIN(pr.price) AS best_price,
    s.store_name,
    s.city,
    s.address
FROM products p
JOIN prices pr ON p.id = pr.product_id
JOIN stores s ON pr.store_id = s.id
WHERE s.city = 'תל אביב'
    AND pr.is_available = true
    AND pr.scraped_at > NOW() - INTERVAL '7 days'
GROUP BY p.id, p.name, s.store_name, s.city, s.address
ORDER BY p.name, best_price;
```

## 🔍 בדיקת שלמות הנתונים

```sql
-- כמה מחירים יש בלי חנות?
SELECT COUNT(*) 
FROM prices 
WHERE store_id IS NULL;

-- כמה מחירים לכל חנות?
SELECT 
    s.store_name,
    COUNT(pr.id) AS price_count
FROM stores s
LEFT JOIN prices pr ON s.id = pr.store_id
GROUP BY s.id, s.store_name
ORDER BY price_count DESC;

-- חנויות ללא מחירים (אולי צריך לסרוק שוב?)
SELECT s.* 
FROM stores s
LEFT JOIN prices pr ON s.id = pr.store_id
WHERE pr.id IS NULL;
```

## 🎓 לסיכום

המבנה כבר **אופטימלי ומנורמל** ✅
- כל מידע במקום אחד
- קשרים ברורים בין טבלאות
- חיסכון במקום ובזיכרון
- שאילתות מהירות
- עדכונים פשוטים

**הבעיה הייתה רק ב-API** - לא עשינו JOIN נכון עם `stores`.
עכשיו תוקן! 🎉

