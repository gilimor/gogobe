# תיעוד מערכת Gogobe - עבודה עם Docker

## תאריך: 21 דצמבר 2025

---

## 📋 סיכום המערכת

### סטטוס נוכחי:
- **מוצרים:** 23,410
- **מחירים:** 1,125,184 (יותר ממיליון!)
- **רשתות:** 10
- **ספקים:** 15
- **סניפים:** 468
- **קטגוריות:** 445

### רשתות פעילות:
1. ✅ Shufersal (שופרסל)
2. ✅ KingStore
3. ✅ Rami Levy (רמי לוי)
4. ✅ Osher Ad (אושר עד)
5. ✅ Yohananof (יוחננוף)
6. ✅ Tiv Taam (טיב טעם)
7. ✅ Keshet Taamim (קשת טעמים)
8. ✅ Mahsanei Hashuk (מחסני השוק)
9. ✅ Stop Market (סטופ מרקט)
10. ✅ Fresh Market (פרש מרקט)

---

## 🐳 עבודה עם Docker - חובה!

### ⚠️ חשוב מאוד!
**כל הפעולות צריכות להתבצע דרך Docker!**

המערכת רצה בשני containers:
- `gogobe-db-1` - PostgreSQL database
- `gogobe-api-1` - FastAPI server

### סיסמת בסיס הנתונים:
- **ב-Docker:** `9152245-Gl!`
- **לא ב-Docker:** `1234` (לא רלוונטי יותר!)

---

## 🚀 פקודות בסיסיות

### הפעלת המערכת:
```bash
docker-compose up -d
```

### עצירת המערכת:
```bash
docker-compose down
```

### אתחול השרת (אחרי שינויים בקוד):
```bash
docker-compose restart api
```

### צפייה בלוגים:
```bash
docker-compose logs -f api
```

### בדיקת סטטוס:
```bash
docker-compose ps
```

---

## 📥 ייבוא נתונים

### ⚠️ כלל זהב: כל הייבוא חייב להיות דרך Docker!

### ייבוא כל הרשתות (מומלץ):
```bash
docker-compose exec -w /app api python backend/run_published_prices_chains.py
```

או הרץ את הקובץ:
```
DOCKER_IMPORT_ALL_CHAINS.bat
```

### ייבוא רשת בודדת (Rami Levy):
```bash
docker-compose exec -w /app api python backend/scrapers/published_prices_scraper.py
```

או הרץ את הקובץ:
```
DOCKER_IMPORT_RAMI_LEVY.bat
```

---

## 🔧 תיקונים שבוצעו

### 1. תיקון שמות טבלאות
**בעיה:** הקוד חיפש `store_chains` אבל הטבלה נקראת `chains`

**תיקון ב:** `backend/scrapers/base_supermarket_scraper.py`
- שורה 231: `INSERT INTO chains` (לא `store_chains`)
- שורה 242: `SELECT id FROM chains` (לא `store_chains`)

### 2. תיקון שמות עמודות
**בעיה:** שמות העמודות לא תאמו את הסכימה

**תיקון:**
- `chain_name` → `name`
- `chain_code` → `chain_id`
- `sub_chain_id` → `subchain_id`

### 3. הוספת endpoint סטטיסטיקות
**קובץ:** `backend/api/main.py`

הוספנו:
```python
@app.get("/api/stats")
async def get_stats():
    # מחזיר סטטיסטיקות כלליות לדשבורד
```

---

## 📁 מבנה הקבצים החשובים

### קבצי Batch לייבוא (חדשים):
- `DOCKER_IMPORT_RAMI_LEVY.bat` - ייבוא רמי לוי
- `DOCKER_IMPORT_ALL_CHAINS.bat` - ייבוא כל הרשתות (אם יצרנו)
- `RESTART_DOCKER.bat` - אתחול Docker container

### קבצי Python:
- `backend/run_published_prices_chains.py` - מריץ ייבוא לכל הרשתות
- `backend/scrapers/base_supermarket_scraper.py` - בסיס לכל הסקרייפרים
- `backend/scrapers/published_prices_scraper.py` - סקרייפר Published Prices

### קבצי הגדרות:
- `docker-compose.yml` - הגדרות Docker
- `.env` - משתני סביבה (אם קיים)

---

## 🌐 גישה למערכת

### דפים זמינים:
- **דשבורד:** http://localhost:8000/dashboard.html
- **חיפוש מוצרים:** http://localhost:8000/
- **מחירים:** http://localhost:8000/prices.html
- **אבות מוצר:** http://localhost:8000/admin/master-management.html
- **ניהול מקורות:** http://localhost:8000/sources.html
- **מטלות:** http://localhost:8000/tasks.html

### API Endpoints:
- **סטטיסטיקות:** http://localhost:8000/api/stats
- **רשתות:** http://localhost:8000/api/chains
- **מוצרים:** http://localhost:8000/api/products/search
- **תיעוד API:** http://localhost:8000/docs

---

## ⚡ פתרון בעיות נפוצות

### הדשבורד מציג 0 בכל מקום:
**פתרון:** אתחל את השרת
```bash
docker-compose restart api
```

### השרת לא עולה:
**פתרון:** בדוק לוגים
```bash
docker-compose logs api
```

### בסיס הנתונים לא מגיב:
**פתרון:** אתחל הכל
```bash
docker-compose down
docker-compose up -d
```

### ייבוא נכשל:
**וודא:**
1. רץ דרך Docker (לא ישירות!)
2. השתמשת ב-`-w /app` בפקודה
3. הקובץ נמצא ב-volume של Docker

---

## 📝 הערות חשובות

### ✅ עשה:
- תמיד הרץ ייבוא דרך Docker
- השתמש ב-`docker-compose exec -w /app api`
- אתחל את השרת אחרי שינויים בקוד
- בדוק את הלוגים אם משהו לא עובד

### ❌ אל תעשה:
- לא להריץ סקריפטים ישירות (מחוץ ל-Docker)
- לא להשתמש בסיסמה `1234` (זה רק מחוץ ל-Docker)
- לא לשנות קוד בלי לאתחל את השרת
- לא לשכוח את ה-`-w /app` בפקודות

---

## 🔄 תהליך עבודה מומלץ

### ייבוא נתונים חדשים:
1. וודא ש-Docker רץ: `docker-compose ps`
2. הרץ ייבוא: `DOCKER_IMPORT_ALL_CHAINS.bat`
3. המתן לסיום (כמה דקות)
4. רענן את הדשבורד

### שינוי קוד:
1. ערוך את הקוד
2. אתחל את השרת: `docker-compose restart api`
3. בדוק את השינויים

### בדיקת נתונים:
1. פתח דשבורד: http://localhost:8000/dashboard.html
2. או בדוק API: `curl http://localhost:8000/api/stats`

---

## 📊 סכימת בסיס הנתונים

### טבלה: chains
```sql
- id (PK)
- name (UNIQUE) - שם הרשת באנגלית
- name_he - שם הרשת בעברית
- chain_id - מזהה רשת רשמי
- subchain_id - מזהה תת-רשת
- is_active - האם פעילה
```

### טבלה: suppliers
```sql
- id (PK)
- name - שם הספק
- slug (UNIQUE) - מזהה ייחודי
- country_code - קוד מדינה
```

### טבלה: products
```sql
- id (PK)
- name - שם המוצר
- ean - ברקוד
- category_id - קטגוריה
```

### טבלה: prices
```sql
- id (PK)
- product_id (FK)
- store_id (FK)
- supplier_id (FK)
- price - מחיר
- scraped_at - תאריך
```

---

## 🎯 יעדים עתידיים

### לשיחה הבאה:
- [ ] הוסף עוד רשתות (Victory, H. Cohen מ-Laib Catalog)
- [ ] שפר את דף ניהול המקורות
- [ ] הוסף אוטומציה לייבוא יומי
- [ ] שפר את חיפוש המוצרים

---

**עודכן לאחרונה:** 21 דצמבר 2025, 22:00
**גרסה:** 1.0
**סטטוס:** ✅ פעיל ועובד
