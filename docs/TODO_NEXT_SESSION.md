# משימות לשיחה הבאה - 21 דצמבר 2025
## עודכן: 22:32

---

## ✅ הושלם היום

### תיקון ייבוא Published Prices (רמי לוי)
- ✅ תוקן CSRF token handling
- ✅ תוקן HEAD vs GET issue
- ✅ תוקנו שמות עמודות בטבלת stores
- ✅ שופר Fallback mechanism
- ✅ **244 מחירים יובאו בהצלחה מרמי לוי!**

---

## 🎯 משימות דחופות - הפעלה הבאה

### 1. ייבוא מלא של רמי לוי (עדיפות: גבוהה מאוד)
```bash
# שנה את limit מ-1 ל-50 בקובץ:
# backend/scrapers/published_prices_scraper.py - שורה 481
stats = scraper.import_files(file_type='prices', limit=50, download_dir=None)

# הרץ:
docker-compose exec -T api python /app/backend/scrapers/published_prices_scraper.py
```

**מטרה:** לפחות 10 סניפים עם 10,000+ מחירים

---

### 2. ייבוא Stores files (עדיפות: גבוהה)
```python
# הוסף בסוף הקובץ published_prices_scraper.py:
# ייבוא Stores
stats_stores = scraper.import_files(file_type='stores', limit=5, download_dir=None)
logger.info(f"Stores import completed: {stats_stores}")
```

**למה זה חשוב:** 
- קבצי Stores מכילים מידע על הסניפים (כתובת, עיר, וכו')
- בלי זה אין לנו מידע מלא על הסניפים

---

### 3. ייבוא רשת נוספת - Osher Ad (עדיפות: בינונית)
```python
# צור קובץ חדש: test_osher_ad.py
scraper = PublishedPricesScraper(
    chain_name="Osher Ad",
    chain_slug="osher_ad",
    chain_name_he="אושר עד",
    chain_id="7290103152017",
    platform_user="osherad"
)
stats = scraper.import_files(file_type='prices', limit=10, download_dir=None)
```

**תעד:** כל בעיה חדשה שתמצא!

---

### 4. Geocoding לסניפים (עדיפות: בינונית)
```python
# צור קובץ: backend/scripts/geocode_stores.py
# השתמש ב-Nominatim (חינמי) או Google Geocoding API
# עדכן latitude/longitude בטבלת stores
```

**למה:** כדי שמפת הסניפים תעבוד

---

### 5. ניקוי כפילויות (עדיפות: נמוכה - אבל חשוב!)
```sql
-- מחק מחירים כפולים (אותו מוצר, אותו סניף, אותו יום)
DELETE FROM prices 
WHERE id NOT IN (
    SELECT MIN(id) 
    FROM prices 
    GROUP BY store_id, product_id, DATE(scraped_at)
);
```

---

## 📚 לקחים שנלמדו - יש לעדכן אחרי כל רשת!

### רמי לוי (Published Prices):
1. ✅ HEAD request משקר - תמיד השתמש ב-GET
2. ✅ CSRF token צריך להיות מדף /file, לא מדף login
3. ✅ שמות עמודות: `store_id` (לא `store_code`), `name` (לא `store_name`)
4. ✅ Fallback חיוני - ה-API לא עובד
5. ⚠️ **עדיין לא בדקנו:** Stores files, PriceFull files, Promo files

### הבא: Osher Ad
- [ ] לבדוק אם אותן בעיות
- [ ] לתעד הבדלים
- [ ] לעדכן את הקובץ הזה!

### הבא: Yohananof
- [ ] לבדוק אם אותן בעיות
- [ ] לתעד הבדלים
- [ ] לעדכן את הקובץ הזה!

---

## 🐛 בעיות ידועות שצריך לטפל בהן

### 1. ה-API לא עובד (CSRF fails)
**סטטוס:** לא נפתר - משתמשים ב-Fallback  
**פתרון אפשרי:** לנסות Selenium/Playwright במקום requests

### 2. אין Stores files
**סטטוס:** לא טופל עדיין  
**משימה:** להוסיף ייבוא של Stores files

### 3. אין geocoding
**סטטוס:** לא טופל עדיין  
**משימה:** להוסיף סקריפט geocoding

### 4. כפילויות במחירים
**סטטוס:** לא טופל עדיין  
**משימה:** להוסיף ניקוי אוטומטי

---

## 📊 יעדים למדידה

### יעד מינימלי (הצלחה):
- ✅ 1 רשת עובדת (רמי לוי) - **הושג!**
- [ ] 5+ סניפים עם נתונים
- [ ] 10,000+ מחירים

### יעד רצוי:
- [ ] 3 רשתות עובדות (רמי לוי, אושר עד, יוחננוף)
- [ ] 20+ סניפים עם נתונים
- [ ] 50,000+ מחירים
- [ ] כל סניף עם latitude/longitude

### יעד אידיאלי:
- [ ] 5+ רשתות עובדות
- [ ] 50+ סניפים עם נתונים
- [ ] 200,000+ מחירים
- [ ] מפה עובדת עם כל הסניפים
- [ ] ניקוי כפילויות אוטומטי

---

## 🔄 תהליך עבודה מומלץ

### לכל רשת חדשה:
1. **הכן סקריפט בדיקה** - test_[chain_name].py
2. **הרץ עם limit=1** - בדוק שזה עובד
3. **תעד בעיות** - עדכן את PUBLISHED_PRICES_FIX_SUMMARY.md
4. **תקן בעיות** - עדכן את הקוד
5. **הרץ עם limit=10** - ייבא יותר נתונים
6. **בדוק תוצאות** - SQL queries
7. **עדכן TODO** - הוסף לקחים חדשים

### בדיקות SQL שימושיות:
```sql
-- כמה מחירים לכל רשת?
SELECT c.name, COUNT(p.id) as price_count
FROM chains c
LEFT JOIN stores s ON s.chain_id = c.id
LEFT JOIN prices p ON p.store_id = s.id
GROUP BY c.name
ORDER BY price_count DESC;

-- כמה סניפים לכל רשת?
SELECT c.name, COUNT(s.id) as store_count
FROM chains c
LEFT JOIN stores s ON s.chain_id = c.id
GROUP BY c.name
ORDER BY store_count DESC;

-- סניפים ללא geocoding
SELECT COUNT(*) FROM stores WHERE latitude IS NULL OR longitude IS NULL;
```

---

## 📝 הערות חשובות

1. **תמיד עבוד דרך Docker** - זה יציב ועובד
2. **תמיד תעד בעיות** - זה יחסוך זמן בעתיד
3. **תמיד בדוק תוצאות** - אל תסמוך על "Success"
4. **תמיד גבה לפני שינויים גדולים** - docker-compose exec db pg_dump...

---

**הבא בתור:** ייבוא מלא של רמי לוי (50 קבצים) + Stores files
