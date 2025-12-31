# יבוא מחירים משופרסל - מדריך מהיר

## סקירה כללית

המערכת תומכת כעת בייבוא מחירים מרשת **שופרסל** בנוסף ל-KingStore הקיימת.

---

## 🚀 התחלה מהירה

### שלב 1: הורדת קבצים מהאתר

1. פתח את אתר שקיפות המחירים של שופרסל:  
   **https://prices.shufersal.co.il/**

2. בחר קטגוריה:
   - **Stores** - רשימת סניפים (הרץ פעם אחת בהתחלה)
   - **PricesFull** - מחירים מלאים (מומלץ!)
   - **Prices** - עדכוני מחירים חלקיים

3. לחץ על קבצים להורדה ושמור אותם בתיקייה (למשל: `C:\data\shufersal`)

### שלב 2: יבוא הנתונים

#### אופציה 1: שימוש ב-BAT File (הכי קל!)

```batch
# הפעל את הקובץ
IMPORT-SHUFERSAL.bat

# בחר אופציה:
# 1 - יבוא סניפים (פעם ראשונה)
# 2 - יבוא קובץ בודד
# 3 - יבוא 10 קבצים
# 4 - יבוא כל הקבצים
```

#### אופציה 2: שורת פקודה ישירה

```bash
# יבוא סניפים
docker exec gogobe-api-1 python /app/backend/scripts/import_supermarket.py \
    --chain shufersal \
    --type stores \
    --file /data/shufersal/Stores7290027600007-000-202512200300.xml

# יבוא מחירים - קובץ בודד
docker exec gogobe-api-1 python /app/backend/scripts/import_supermarket.py \
    --chain shufersal \
    --file /data/shufersal/PriceFull7290027600007-001-202512200300.xml

# יבוא מחירים - 10 קבצים
docker exec gogobe-api-1 python /app/backend/scripts/import_supermarket.py \
    --chain shufersal \
    --type prices_full \
    --dir /data/shufersal \
    --limit 10
```

---

## 📊 מה קורה ביבוא?

### 1. יבוא סניפים (Stores)
- יוצר רשת "שופרסל" במערכת
- מייבא את כל הסניפים עם שמות, כתובות ועיר
- צריך להריץ **פעם אחת** לפני יבוא מחירים

### 2. יבוא מחירים (PricesFull)
- מייבא מוצרים חדשים או מקשר לקיימים (לפי ברקוד)
- יוצר מחירים לכל מוצר
- מקשר למוצרים קיימים מ-KingStore אם יש ברקוד זהה
- שומר היסטוריית מחירים

---

## 🔍 בדיקת התוצאות

### באתר
1. פתח: http://localhost:8000
2. חפש מוצר (למשל: "חלב")
3. סנן לפי רשת: "שופרסל"
4. השווה מחירים בין שופרסל ל-KingStore

### במסד הנתונים
```sql
-- ספירת מוצרים משופרסל
SELECT COUNT(*) FROM products 
WHERE attributes->>'chain_id' = '7290027600007';

-- ספירת מחירים משופרסל
SELECT COUNT(*) FROM prices p
JOIN suppliers s ON p.supplier_id = s.id
WHERE s.slug = 'shufersal';

-- סניפי שופרסל
SELECT * FROM stores 
WHERE chain_id = (SELECT id FROM chains WHERE slug = 'shufersal');
```

---

## 💡 טיפים

### יבוא יעיל
1. **התחל עם סניפים** - הרץ יבוא Stores לפני הכל
2. **התחל קטן** - נסה 10 קבצים קודם
3. **בדוק תוצאות** - ודא שהכל עובד לפני יבוא מלא
4. **השתמש ב-PricesFull** - זה מכיל את כל המוצרים

### איחוד מוצרים
אחרי היבוא, הרץ:
```bash
scripts\database\deduplicate-products.bat
```
זה יאחד מוצרים זהים משופרסל ו-KingStore.

### ביצועים
- קובץ אחד = ~1,000-5,000 מוצרים
- זמן עיבוד: ~30 שניות לקובץ
- 10 קבצים = ~5 דקות
- 100 קבצים = ~50 דקות

---

## ⚠️ בעיות נפוצות

### בעיה: "Chain not found"
**פתרון**: הרץ יבוא Stores קודם

### בעיה: "File not found"
**פתרון**: ודא שהנתיב מלא ונכון, למשל:
```
C:\data\shufersal\PriceFull7290027600007-001-202512200300.xml
```

### בעיה: "Encoding error"
**פתרון**: הקבצים צריכים להיות UTF-8. אם יש בעיה, נסה לפתוח ב-Notepad++ ולשמור כ-UTF-8.

### בעיה: מוצרים כפולים
**פתרון**: הרץ את כלי ה-deduplication:
```bash
scripts\database\deduplicate-products.bat
```

---

## 📈 סטטיסטיקות

אחרי יבוא מוצלח, תראה:

```
========================================
  IMPORT SUMMARY
========================================
Files processed:  10
Products created: 8,234
Prices imported:  8,234
Items skipped:    156
Errors:           0
========================================
```

---

## 🎯 המשך

### הוספת רשתות נוספות
המערכת תומכת בהוספת רשתות נוספות בקלות:
- רמי לוי
- ויקטורי
- יינות ביתן
- וכל רשת אחרת!

ראה: [ADDING_NEW_CHAIN.md](ADDING_NEW_CHAIN.md)

### אוטומציה
ניתן להגדיר יבוא אוטומטי יומי:
```bash
# TODO: הוסף task scheduler
```

---

## 📞 עזרה

- **מדריך מפתחים**: [ADDING_NEW_CHAIN.md](ADDING_NEW_CHAIN.md)
- **תיעוד API**: http://localhost:8000/docs
- **README ראשי**: [README.md](../README.md)

---

**בהצלחה! 🎉**
