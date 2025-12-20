# ============================================
# מבנה הטבלאות במערכת - Architecture
# ============================================

## ✅ הטבלאות הקיימות:

1. **products** - טבלת מוצרים (ייחודיים)
2. **prices** - טבלת מחירים (רב-ממדית)
3. **stores** - טבלת סניפים
4. **chains** - טבלת רשתות
5. **suppliers** - טבלת ספקים
6. **supplier_chains** - קישור בין ספקים לרשתות
7. **categories** - קטגוריות
8. **brands** - מותגים
9. **verticals** - תחומים (supermarket, dental, etc.)

---

## 📊 לוגיקת ייבוא נכונה:

### שלב 1: בדיקת קיום מוצר
```python
# בדוק אם מוצר קיים לפי:
1. ברקוד (EAN/UPC) - העדיפות הגבוהה ביותר
2. manufacturer_code - אם אין ברקוד
3. שם מנורמל - אם אין מזהים
```

### שלב 2: וידוא קיום רשת/סניף
```python
# אם הרשת לא קיימת - צור אותה
chain_id = get_or_create_chain(chain_data)

# אם הסניף לא קיים - צור אותו
store_id = get_or_create_store(chain_id, store_data)
```

### שלב 3: וידוא קיום מטבע
```python
# אם המטבע לא קיים - צור אותו
currency_code = ensure_currency_exists(currency_data)
```

### שלב 4: יצירת/עדכון מוצר
```python
if product_exists:
    # רק עדכן תאריך עדכון
    product_id = existing_product_id
else:
    # צור מוצר חדש
    product_id = create_product(product_data)
```

### שלב 5: יצירת מחיר
```python
# תמיד צור מחיר חדש
create_price(
    product_id=product_id,
    supplier_id=supplier_id,
    store_id=store_id,  # אופציונלי
    chain_id=chain_id,  # אופציונלי
    price=price,
    currency=currency,
    scraped_at=now()
)
```

---

## 🔄 דוגמת Flow:

```
XML File: "Store_2_20251220.xml"
├── קרא metadata: chain_id=7290172900007, store_id=2
│
├── וידוא רשת:
│   ├── חפש chain_id=7290172900007
│   └── אם לא קיים → צור KingStore
│
├── וידוא סניף:
│   ├── חפש store_id=2 תחת chain
│   └── אם לא קיים → צור "קינג סטור - סניף 2"
│
├── עבור כל מוצר:
│   ├── בדוק אם קיים (לפי EAN: 7290110563547)
│   │   ├── אם כן → השתמש ב-product_id קיים
│   │   └── אם לא → צור מוצר חדש
│   │
│   └── צור מחיר:
│       ├── product_id: 42507
│       ├── supplier_id: 5 (KingStore)
│       ├── store_id: 2 (סניף 2)
│       ├── price: 0.10
│       ├── currency: ILS
│       └── scraped_at: 2025-12-20 15:30:00
```

---

## ⚠️ בעיות בקוד הנוכחי:

### 1. **מחירים ישנים ללא store_id**
- **בעיה**: 206K מחירים ישנים ללא קישור לסניף
- **סיבה**: יובאו לפני שהוספנו את הטבלה
- **פתרון**: לא לתקן רטרואקטיבית (זה OK)

### 2. **אין טבלת מטבעות**
- **בעיה**: `currency` הוא רק שדה טקסט (CHAR(3))
- **צריך**: טבלה נפרדת עם שערי המרה

### 3. **ייבוא לא עקבי**
- **בעיה**: לפעמים מייבאים בשם, לפעמים בברקוד
- **צריך**: לוגיקה אחידה

---

## 🎯 מה צריך לעשות:

### 1. ✅ טבלת מטבעות (חסרה!)
```sql
CREATE TABLE currencies (
    code CHAR(3) PRIMARY KEY,  -- ILS, USD, EUR
    name VARCHAR(100),          -- Israeli Shekel
    symbol VARCHAR(10),         -- ₪
    exchange_rate_to_usd DECIMAL(10,4),
    last_updated TIMESTAMP
);
```

### 2. ✅ שיפור לוגיקת הייבוא
```python
def import_product():
    # 1. וידוא רשת/סניף/מטבע
    # 2. בדיקת קיום מוצר (EAN > code > name)
    # 3. יצירת מחיר עם כל ההתייחסויות
```

### 3. ✅ טבלת איחוד מוצרים (עתידי)
```sql
CREATE TABLE product_merges (
    master_product_id BIGINT,    -- המוצר הראשי
    duplicate_product_id BIGINT,  -- המוצר הכפול
    merge_reason TEXT,            -- למה איחדנו
    merged_at TIMESTAMP
);
```

---

## 📋 האם אני מבין נכון?

### הלוגיקה:
1. ✅ **בדיקת קיום** - לפני כל דבר
2. ✅ **יצירה אוטומטית** - רשתות/סניפים/מטבעות אם חסרים
3. ✅ **הפרדה ברורה** - מוצר (1) ← → מחירים (רבים)
4. ✅ **היסטוריה מלאה** - כל מחיר = רשומה נפרדת
5. ✅ **איחוד עתידי** - טיפול בכפילויות

### האם זה נכון? 🎯

