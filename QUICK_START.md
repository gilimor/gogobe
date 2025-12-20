# 🎯 Quick Start Guide

## להפעלה מהירה:

### Windows:
```bash
# הרץ את התפריט
RUN.bat

# או ישירות עם Docker:
START-DOCKER.bat
```

## 🏪 יבוא מלא KingStore (חדש!):
```bash
# שלב 1: יבוא כל הקבצים
scripts\supermarket\import-all-kingstore.bat

# שלב 2: איחוד מוצרים
scripts\database\auto-deduplicate.bat

# תוצאה: מוצרים משותפים! 🎉
```

[📖 מדריך מלא](docs/KINGSTORE_FULL_IMPORT_GUIDE.md)

## לצפייה באתר:
```
http://localhost:8000
```

## כלים שימושיים:

### איחוד מוצרים כפולים:
```bash
scripts\database\deduplicate-products.bat
```

### יבוא נתונים חדשים:
```bash
scripts\processing\import-data.bat
```

### בדיקת סטטוס:
```bash
docker-compose ps
docker-compose logs -f
```

## תיעוד מלא:
- [README.md](README.md) - מדריך ראשי
- [docs/FINAL_SUMMARY.md](docs/FINAL_SUMMARY.md) - סיכום מלא
- [docs/HOW_TO_VIEW_WEBSITE.md](docs/HOW_TO_VIEW_WEBSITE.md) - מדריך האתר

---

**המערכת מוכנה!** 🚀
