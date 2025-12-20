# 📝 Changelog - 20 דצמבר 2025

## 🔧 תיקונים ושיפורים אחרונים

### ✅ תיקון בעיות Encoding בעברית

**בעיה**: טקסט עברי הוצג כ-gibberish (גיבריש) בדפדפן Edge ובחלק מהדפים.

**פתרון**:
- ✅ תוקן encoding בכל קבצי ה-HTML
- ✅ הוסף `charset=utf-8` ב-Content-Type headers ב-API
- ✅ תוקן encoding בבסיס הנתונים (קטגוריה ID 151)
- ✅ נוצר סקריפט `fix_category_151.py` לתיקון encoding בקטגוריות

**קבצים שנערכו**:
- `frontend/index.html`
- `frontend/dashboard.html`
- `frontend/categories.html`
- `frontend/stores.html`
- `frontend/prices.html`
- `frontend/data-sources.html`
- `frontend/errors.html`
- `backend/api/main.py` - הוספת UTF-8 headers
- `backend/scripts/fix_category_151.py` - סקריפט תיקון encoding

---

### ✅ שחזור JavaScript ותוכן דינמי

**בעיה**: כל הדפים לא הציגו תוכן - רק "טוען..." ללא נתונים.

**פתרון**:
- ✅ שוחזר JavaScript מלא לכל הדפים
- ✅ כל דף טוען נתונים מה-API
- ✅ נוספו פונקציות עזר (formatPrice, formatDate, escapeHtml)

**דפים שתוקנו**:
1. **categories.html** - טוען קטגוריות מ-`/api/categories`
2. **stores.html** - טוען רשתות וסניפים מ-`/api/chains` ו-`/api/chains/{id}/stores`
3. **prices.html** - טוען מחירים מ-`/api/prices` עם pagination
4. **data-sources.html** - טוען מקורות נתונים מ-`/api/data-sources/stats`
5. **errors.html** - טוען שגיאות מ-`/api/errors` עם auto-refresh

**תכונות נוספות**:
- Pagination בדף המחירים
- Auto-refresh בדף השגיאות (כל 30 שניות)
- תצוגה משופרת עם עיצוב מודרני

---

### ✅ תיקון שמות סניפים - שמות מלאים במקום מספרים

**בעיה**: סניפים הוצגו רק כמספרים ("קינג סטור - סניף 15") במקום שמות מלאים.

**פתרון**:
- ✅ עודכן המיפוי ב-`kingstore_simple_import.py` עם שמות מלאים מהאתר
- ✅ נוצר סקריפט `update_store_names_from_website.py` לעדכון שמות בבסיס הנתונים
- ✅ עודכן ה-API להחזיר `store_name_he`, `city`, `address`
- ✅ עודכנה התצוגה להציג שם + עיר + כתובת

**שמות סניפים מעודכנים**:
- `31` → "צים סנטר נוף הגליל"
- `200` → "ירושליים"
- `334` → "דיר חנא זכיינות"
- `336` → "דוכאן קלנסווה"
- `338` → "דוכאן חי אלוורוד"
- `339` → "יפו תלאביב מכללה"
- `340` → "מיני קינג סח'נין"

**קבצים שנערכו**:
- `backend/scripts/kingstore_simple_import.py` - עדכון STORE_NAMES mapping
- `backend/scripts/update_store_names_from_website.py` - סקריפט עדכון שמות
- `backend/api/main.py` - עדכון `/api/prices` להחזיר store_name_he, city, address
- `frontend/stores.html` - תצוגה משופרת עם עיר וכתובת
- `frontend/prices.html` - תצוגה משופרת עם עיר וכתובת

---

### ✅ Git Repository

**שינוי**: אותחל Git repository לניהול גרסאות.

**פעולות**:
- ✅ יצירת `.gitignore` עם כל הקבצים הרלוונטיים
- ✅ Commit ראשוני עם כל הקבצים
- ✅ Commit עם כל התיקונים האחרונים

---

## 📊 סטטיסטיקות

### לפני התיקונים:
- ❌ טקסט עברי מקולקל (gibberish)
- ❌ דפים ריקים ללא תוכן
- ❌ שמות סניפים רק כמספרים

### אחרי התיקונים:
- ✅ כל הטקסט העברי תקין
- ✅ כל הדפים מציגים תוכן דינמי
- ✅ שמות סניפים מלאים עם עיר וכתובת
- ✅ תצוגה משופרת בכל הדפים

---

## 🔄 איך להפעיל את התיקונים

### 1. עדכון שמות סניפים:
```bash
docker exec gogobe-api-1 python /app/backend/scripts/update_store_names_from_website.py
```

### 2. תיקון encoding בקטגוריות:
```bash
docker exec gogobe-api-1 python /app/backend/scripts/fix_category_151.py
```

### 3. הפעלה מחדש של ה-API:
```bash
docker restart gogobe-api-1
```

---

## 📝 הערות טכניות

### Encoding:
- כל הקבצים משתמשים ב-UTF-8
- ה-API מחזיר `Content-Type: text/html; charset=utf-8`
- בסיס הנתונים מוגדר ל-`client_encoding='UTF8'`

### JavaScript:
- כל הדפים משתמשים ב-`const API_BASE = ''` (relative path)
- פונקציות עזר משותפות: `escapeHtml`, `formatPrice`, `formatDate`
- Error handling מלא בכל הדפים

### API Endpoints:
- `/api/categories` - רשימת קטגוריות
- `/api/chains` - רשימת רשתות
- `/api/chains/{id}/stores` - סניפים של רשת
- `/api/prices` - מחירים עם pagination
- `/api/data-sources/stats` - סטטיסטיקות מקורות נתונים
- `/api/errors` - רשימת שגיאות

---

## 🎯 מה הלאה?

### שיפורים מומלצים:
1. **GOV.IL API Integration** - לקבלת כתובות מלאות של סניפים
2. **Auto-scraping** - עדכון אוטומטי של שמות סניפים מהאתר
3. **Store Details Page** - דף פרטים מלא לכל סניף
4. **Map Integration** - מפה עם מיקום הסניפים

---

**תאריך**: 20 דצמבר 2025  
**גרסה**: 1.1  
**סטטוס**: ✅ כל התיקונים הושלמו בהצלחה

