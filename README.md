# 🎯 Gogobe - מערכת השוואת מחירים

## תאריך: דצמבר 2025

---

## 🚀 הפעלה מהירה

### **אופציה 1: Docker (מומלץ!)**
```bash
RUN.bat
# בחר אופציה 1
```

### **אופציה 2: Python רגיל**
```bash
RUN.bat
# בחר אופציה 2
```

---

## 📊 מה יש במערכת?

- ✅ **~13,000** מוצרים (KingStore)
- ✅ **~120,000** מחירים
- ✅ **23** סניפי KingStore
- ✅ **13** קטגוריות ראשיות + **50** תת-קטגוריות
- ✅ **עברית מושלמת** - UTF-8 encoding

### 🎯 תכונות:
- ✅ **שם חנות מלא** לכל מוצר (עם עיר וכתובת)
- ✅ **קטגוריות היררכיות** (2 רמות)
- ✅ **פרטי מוצר מלאים** (כמות, משקל, יצרן)
- ✅ **ברקודים** (EAN) לכל מוצר
- ✅ **חיפוש ופילטור** מתקדם
- ✅ **דפי ניהול מלאים** - קטגוריות, סניפים, מחירים, מקורות נתונים, שגיאות
- ✅ **עברית מושלמת** - כל הטקסטים תקינים (UTF-8)

### 🔥 חדש! יבוא מלא של KingStore עם קטגוריות
```bash
# יבוא כל 157 קבצי XML עם סיווג אוטומטי
docker exec gogobe-api-1 python /app/backend/scripts/kingstore_simple_import.py
```

**תוצאה:** 
- ✅ 13,000 מוצרים עם עברית תקינה
- ✅ 9,131 מוצרים מסווגים בקטגוריות
- ✅ שם חנות מלא לכל מוצר
- ✅ מבנה קטגוריות היררכי

[📖 מדריך מלא](docs/kingstore/COMPLETE_SUMMARY.md) | [🔧 תיעוד טכני](docs/kingstore/README.md)

---

## 🌐 גישה למערכת

- **אתר**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs
- **Search**: http://localhost:8000/api/products/search?q=חלב
- **Stats**: http://localhost:8000/api/stats

📚 **[מדריך שימוש באתר](docs/user-guides/USAGE_GUIDE.md)** - איך לחפש, לסנן ולהשוות מחירים

---

## 📚 תיעוד מלא

### למשתמשים:
- **[מדריך שימוש](docs/user-guides/USAGE_GUIDE.md)** - איך להשתמש באתר
- **[מבנה קטגוריות](docs/CATEGORY_STRUCTURE.md)** - כל הקטגוריות והתתי-קטגוריות

### למפתחים:
- **[Changelog 20/12/2025](docs/CHANGELOG_20DEC2025.md)** - כל התיקונים האחרונים ⭐
- **[KingStore - סיכום מלא](docs/kingstore/COMPLETE_SUMMARY.md)** - כל מה שנעשה
- **[DOCKER_SUCCESS.md](docs/DOCKER_SUCCESS.md)** - מידע מלא על המערכת
- **[HOW_TO_START.md](docs/setup/HOW_TO_START.md)** - מדריך התחלה טכני

---

## 🐳 פקודות Docker שימושיות

```bash
# צפייה בלוגים
docker-compose logs -f

# עצירה
docker-compose stop

# הפעלה מחדש
docker-compose restart

# כיבוי מלא
docker-compose down

# בנייה מחדש
docker-compose build
docker-compose up -d
```

---

## 📂 מבנה הפרויקט

```
Gogobe/
├── RUN.bat                    ← התחל כאן!
├── START-DOCKER.bat           ← הפעלה עם Docker
├── START.bat                  ← הפעלה רגילה
├── backend/
│   ├── api/                   ← FastAPI server
│   ├── database/              ← DB schema & scripts
│   └── scripts/               ← Python scripts
├── frontend/                  ← HTML/CSS/JS
├── docs/                      ← תיעוד
│   ├── technical/             ← תיעוד טכני
│   └── user/                  ← מדריכי משתמש
└── scripts/                   ← BAT scripts
    ├── database/              ← DB operations
    ├── download/              ← Data downloading
    ├── processing/            ← Data processing
    └── automation/            ← Automation
```

---

## ⚠️ בעיות נפוצות

### Python לא עובד
**פתרון**: השתמש ב-Docker (אופציה 1)

### Port 8000 תפוס
**פתרון**: 
```bash
docker-compose down
docker-compose up -d
```

### השרת לא מגיב
**פתרון**:
```bash
docker-compose logs -f api
```

---

## 🎯 משימה הבאה

**תיקון: מוצרים במספר סניפים**

כרגע כל סניף יוצר מוצרים משלו. צריך:
1. Deduplication script
2. Product matching לפי barcode
3. Normalization של שמות

---

## 💡 טיפים

- **תמיד השתמש ב-Docker** - זה יציב ועובד תמיד
- **לא לשכוח**: `docker-compose down` לפני כיבוי
- **בעיות?**: `docker-compose logs -f`
- **עדכון קוד**: הוא מסונכרן אוטומטית!

---

תאריך: 20 דצמבר 2025  
סטטוס: ✅ **עובד!**  
גרסה: 1.1

---

## 🔄 עדכונים אחרונים (20/12/2025)

### ✅ תיקונים שבוצעו:
1. **תיקון Encoding** - כל הטקסט העברי תקין
2. **שחזור JavaScript** - כל הדפים מציגים תוכן דינמי
3. **שמות סניפים מלאים** - עם עיר וכתובת
4. **Git Repository** - ניהול גרסאות

📖 **[קרא את כל הפרטים](docs/CHANGELOG_20DEC2025.md)**
