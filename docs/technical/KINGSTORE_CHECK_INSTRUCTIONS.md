# 🔍 מה צריך לבדוק - KingStore

## ❓ השאלה שלך

> במוצרים שעשינו יבוא ל-KINGSTORE לא ראיתי שיש אותו מוצר שנמכר בכמה סניפים שלהם וזה נראה לי מוזר  
> בנוסף לא ייבאנו את כל החנויות שלהם מהאתר ...

---

## ✅ הקוד בעצם נכון!

בדקתי את `backend/scripts/kingstore_xml_processor.py` והקוד **כן** יוצר מחיר נפרד לכל סניף:

```python
# שורות 324-329
INSERT INTO prices (product_id, supplier_id, store_id, price, currency, scraped_at)
VALUES (%s, %s, %s, %s, 'ILS', NOW())
```

הקוד שומר את ה-`store_id` עבור כל מחיר, אז אותו מוצר **אמור** להופיע עם מחירים שונים בסניפים שונים.

---

## 🔍 מה צריך לבדוק?

### אופציה 1: דרך ממשק האתר (Frontend)

1. **פתח את האתר**:
   ```
   scripts\web\start-web.bat
   ```

2. **חפש מוצר**  
   לדוגמא: "חלב" או "לחם" או כל מוצר סופרמרקט

3. **בדוק אם יש לו מחירים מסניפים שונים**

---

### אופציה 2: דרך Database (PgAdmin/DBeaver)

הרץ את השאילתה הזו:

```sql
-- בדיקה: מוצרים שנמכרים ביותר מסניף אחד
SELECT 
    p.name as "שם המוצר",
    COUNT(DISTINCT pr.store_id) as "מספר סניפים"
FROM products p
    JOIN prices pr ON p.id = pr.product_id
WHERE 
    p.vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%supermarket%')
    AND pr.store_id IS NOT NULL
GROUP BY p.id, p.name
HAVING COUNT(DISTINCT pr.store_id) > 1
ORDER BY COUNT(DISTINCT pr.store_id) DESC
LIMIT 20;
```

**אם תקבל תוצאות** - הכל תקין! ✅  
**אם לא** - יש בעיה ביבוא ❌

---

### אופציה 3: בדיקה מהירה - כמה סניפים יש

```sql
-- כמה חנויות יש סה"כ?
SELECT COUNT(*) as "סה״כ חנויות" FROM stores;

-- כמה חנויות עם מחירים?
SELECT COUNT(DISTINCT store_id) as "חנויות עם מחירים"
FROM prices
WHERE store_id IS NOT NULL;
```

---

## 🎯 מה התוצאה המצופה?

### תרחיש תקין ✅:

```
מוצר "חלב תנובה 3%" נמכר ב-12 סניפים:
  - סניף רמת השרון: ₪5.90
  - סניף תל אביב: ₪5.95
  - סניף חיפה: ₪6.10
  - וכו'...
```

### תרחיש בעייתי ❌:

```
מוצר "חלב תנובה 3%" נמכר ב-1 סניף בלבד:
  - סניף רמת השרון: ₪5.90
```

---

## 📋 לגבי החנויות החסרות

השאלה: **איך אנחנו מייבאים חנויות?**

**התשובה**: המערכת יוצרת חנות **רק כשיש לה קובץ XML עם מחירים**.

אם ב-KingStore יש:
- 50 סניפים פיזיים באתר
- אבל רק 27 קבצי XML זמינים

**אז יובאו רק 27 החנויות שיש להן מחירים.**

---

## ⚡ פתרון אפשרי

אם רוצים את **כל** החנויות (גם בלי מחירים):

1. **סקריפט שסורק את כל הסניפים מהאתר**:
   ```python
   # backend/scripts/kingstore_scrape_all_stores.py
   def scrape_all_stores():
       """Scrape complete store list from KingStore website"""
       url = "https://kingstore.binaprojects.com/stores"
       # Parse HTML -> Extract all stores -> Import to DB
   ```

2. **יבוא רשימת חנויות סטטית** (אם יש CSV/JSON):
   ```sql
   INSERT INTO stores (store_name, store_code, chain_id)
   VALUES 
       ('סניף רמת השרון', '001', 1),
       ('סניף תל אביב', '002', 1),
       -- כל הסניפים...
   ON CONFLICT DO NOTHING;
   ```

---

## 🎬 הצעד הבא

**תבדוק בבקשה**:

1. הרץ שאילתה אחת מלמעלה (PgAdmin/DBeaver)
2. או פתח את האתר וחפש מוצר

**ותספר לי מה אתה רואה** - אז אדע מה צריך לתקן! 👍

---

📅 **Created**: 2025-12-20  
🔧 **File**: `docs/technical/KINGSTORE_CHECK_INSTRUCTIONS.md`





