# Chains & Stores Management - Complete Implementation

## תיעוד: מערכת ניהול רשתות וסניפים

תאריך: 20/12/2025

---

## 📋 מה נוסף?

### 1. טבלאות חדשות בבסיס הנתונים

#### `chains` - רשתות קמעונאות
```sql
- id: מזהה ייחודי
- name: שם הרשת (אנגלית)
- name_he: שם הרשת (עברית)
- slug: slug לURL
- chain_id: מזהה חיצוני (מXML/API)
- subchain_id: מזהה תת-רשת
- chain_type: סוג רשת (supermarket, pharmacy, etc.)
- store_count: מספר סניפים
- is_active: האם פעילה
```

#### `stores` - סניפים פיזיים
```sql
- id: מזהה ייחודי
- chain_id: קישור לרשת
- store_id: מזהה סניף (מXML)
- bikoret_no: מספר ביקורת
- name: שם הסניף
- name_he: שם בעברית
- city: עיר
- address: כתובת
- phone: טלפון
- opening_hours: שעות פתיחה (JSONB)
- latitude/longitude: קוארדינטות
- is_active: האם פעיל
```

#### `supplier_chains` - קישור ספקים לרשתות
```sql
- supplier_id: מזהה ספק
- chain_id: מזהה רשת
- relationship_type: סוג קשר (owner, franchisee, aggregator)
```

### 2. שדה חדש ב-`prices`
```sql
ALTER TABLE prices ADD COLUMN store_id INTEGER REFERENCES stores(id);
```
כעת כל מחיר מקושר לסניף ספציפי!

---

## 🔧 Functions & Views

### Function: `get_or_create_store()`
```sql
SELECT get_or_create_store(chain_id, store_id, name, city, bikoret_no)
```
מחזירה `store_id` - יוצרת סניף אם לא קיים, מעדכנת אם קיים.

### View: `v_stores_full`
מציג כל סניף עם פרטי הרשת שלו.

### View: `v_store_stats`
סטטיסטיקות לכל סניף (מוצרים, מחירים, ממוצעים).

---

## 📊 נתונים שנוספו

### KingStore Chain & Stores

✅ **רשת**: KingStore (קינגסטור)
- Chain ID: 7290172900007
- Slug: kingstore
- Type: supermarket

✅ **14 סניפים**:
- קינג סטור - סניף 1, 2, 3, 5, 6, 7, 8, 12, 13, 15, 16...
- סה"כ 59,161 מחירים מקושרים לסניפים

**סניפים מובילים:**
1. סניף 2: 1,217 מוצרים, 24,703 מחירים
2. סניף 5: 779 מוצרים, 6,433 מחירים
3. סניף 6: 515 מוצרים, 4,674 מחירים

---

## 🌐 API Endpoints חדשים

### 1. `/api/chains` - רשימת רשתות
```json
{
  "chains": [
    {
      "id": 1,
      "name": "KingStore",
      "name_he": "קינגסטור",
      "slug": "kingstore",
      "chain_type": "supermarket",
      "store_count": 14,
      "active_store_count": 14,
      "product_count": 13280,
      "price_count": 265628
    }
  ]
}
```

### 2. `/api/chains/{chain_id}/stores` - סניפי רשת
```json
{
  "stores": [
    {
      "id": 2,
      "store_id": "2",
      "name": "קינג סטור - סניף 2",
      "city": null,
      "bikoret_no": null,
      "product_count": 1217,
      "price_count": 24703,
      "min_price": 0.01,
      "max_price": 3550.00,
      "last_updated": "2025-12-20T13:46:10.105247"
    }
  ]
}
```

### 3. `/api/stores` - כל הסניפים
מציג את כל הסניפים מכל הרשתות עם סטטיסטיקות.

### 4. `/api/products/search` - עודכן!
```json
{
  "products": [
    {
      "id": 45742,
      "name": "מוצר לדוגמה",
      "store_names": "קינג סטור - סניף 3",    ← חדש!
      "store_count": 1,                          ← חדש!
      "supplier_names": "KingStore",
      "min_price": 12.90
    }
  ]
}
```

---

## 🖥️ Frontend - דף ניהול חדש

### `/stores.html` - מערכת ניהול רשתות וסניפים

**תכונות:**
- 📊 סטטיסטיקות כלליות (רשתות, סניפים, מוצרים, מחירים)
- 🏪 תצוגת כרטיסים של רשתות
- 📋 טבלה מפורטת של כל הסניפים
- 🔍 חיפוש וסינון סניפים
- 📈 סטטיסטיקות לכל סניף (מחירים, מוצרים, טווח מחירים)

**טאבים:**
1. **רשתות** - תצוגת grid של כל הרשתות
2. **כל הסניפים** - טבלה מפורטת עם חיפוש

---

## 📝 Scripts שנוצרו

### 1. `backend/database/add_chains_stores.sql`
Migration script שיוצר:
- טבלאות `chains`, `stores`, `supplier_chains`
- Indexes מותאמים
- Functions & Views
- Seed data ל-KingStore

### 2. `backend/scripts/populate_stores_from_attributes.py`
Script שמאכלס את הסניפים מהנתונים הקיימים:
- מחלץ store_id, store_name, bikoret_no מ-`products.attributes`
- יוצר רשומות סניפים ב-`stores`
- מקשר `prices.store_id` לסניפים הנכונים
- מציג סטטיסטיקות

**תוצאות הרצה:**
```
✅ Created/Updated 14 stores
✅ Updated 59,161 price records with store_ids
```

---

## 🔄 שינויים ב-API (`backend/api/main.py`)

### שאילתת `/api/products/search` עודכנה:
```sql
-- הוספת JOIN לטבלת stores
LEFT JOIN stores st ON pr.store_id = st.id

-- הוספת שדות חדשים
STRING_AGG(DISTINCT st.name, ', ') as store_names,
COUNT(DISTINCT st.id) as store_count,
```

### API endpoints חדשים:
- `GET /api/chains` - רשימת רשתות
- `GET /api/chains/{chain_id}/stores` - סניפי רשת
- `GET /api/stores` - כל הסניפים

---

## 🎨 Frontend Updates

### `frontend/app.js`
עודכן להציג שמות סניפים:
```javascript
if (product.store_names) {
    stores = product.store_names;  // "קינג סטור - סניף 2"
} else if (product.supplier_names) {
    stores = product.supplier_names;  // "KingStore"
}
```

### `frontend/stores.html` - דף חדש!
מערכת ניהול מלאה לרשתות וסניפים.

---

## 📊 שימוש למפתחים

### יצירת סניף חדש:
```sql
SELECT get_or_create_store(
    1,                  -- chain_id (KingStore)
    '17',               -- store_id
    'קינג סטור - סניף 17',  -- name
    'תל אביב',          -- city
    '123456'            -- bikoret_no
);
```

### שאילתת סניפי רשת:
```sql
SELECT * FROM v_stores_full 
WHERE chain_name_he = 'קינגסטור';
```

### סטטיסטיקות סניף:
```sql
SELECT * FROM v_store_stats 
WHERE store_id = 2;
```

---

## 🚀 העדכונים בפעולה

### לפני:
```
חנויות: "אחר" או "KingStore"
```

### אחרי:
```
חנויות: "קינג סטור - סניף 2" (עם מס' ביקורת ועיר)
```

---

## 🔮 מה הלאה?

### תכונות עתידיות:
1. **מיפוי גיאוגרפי** - מפה של סניפים
2. **השוואת מחירים בין סניפים** - מוצר זהה, סניפים שונים
3. **ניתוח תחרות** - איזה סניפים בתחרות ישירה
4. **מעקב מלאי** - זמינות מוצרים בסניפים
5. **שעות פתיחה** - מתי הסניף פתוח
6. **ניווט** - הכוונה לסניף הקרוב ביותר

### רשתות נוספות (עתידי):
- שופרסל (Shufersal)
- רמי לוי (Rami Levy)
- יינות ביתן (Yeinot Bitan)
- ויקטורי (Victory)

---

## ✅ Checklist השלמות

- [x] יצירת טבלאות chains, stores, supplier_chains
- [x] Migration script מלא
- [x] Seed data ל-KingStore
- [x] Population script מנתונים קיימים
- [x] עדכון 59,161 מחירים עם store_id
- [x] API endpoints לרשתות וסניפים
- [x] עדכון `/api/products/search` עם store_names
- [x] Frontend - דף ניהול רשתות וסניפים
- [x] תיעוד מלא

---

## 📞 Support

לבעיות או שאלות:
1. בדוק logs: `docker logs gogobe-api-1`
2. בדוק DB: `docker exec gogobe-db-1 psql -U postgres -d gogobe`
3. בדוק API: `http://localhost:8000/docs`

---

**תאריך עדכון אחרון:** 20 דצמבר 2025  
**גרסה:** 2.0 - Chains & Stores Management

