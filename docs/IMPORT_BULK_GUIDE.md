# Gogobe Bulk Parallel Importer 🚀

מערכת יבוא נתונים המונית, מקבילית וחכמה עבור רשתות שיווק.

## תכונות מרכזיות
- **הורדה מקבילית:** שימוש ב-Thread Pool להורדת עשרות קבצים בו-זמנית.
- **יבוא מקבילי:** שימוש ב-Process Pool (Multiprocessing) לניצול כל ליבות המעבד.
- **ללא דיסק:** פריסת קבצי GZ ישירות לזיכרון/tmp לחיסכון בזמן I/O.
- **אוטומציה מלאה:** זיהוי אוטומטי של קבצים חדשים מה-API של הרשת.
- **ניהול חיבורים:** כל תהליך מנהל חיבור DB משלו למניעת התנגשויות.

## ביצועים
- **לפני:** ~5 דקות לקובץ (טורי).
- **אחרי:** ~3-5 שניות ל-20 קבצים במקביל! (תלוי בחומרה)

## שימוש

### שופרסל (Shufersal)
הרץ את הסקריפט האוטומטי:
```bash
scripts\shufersal\download-and-import.bat
```

### הרצה ידנית (למפתחים)
```bash
# הורדה בלבד
python backend/scripts/download_shufersal_latest.py /path/to/data 50

# יבוא בלבד (מקבילי)
python backend/scripts/import_bulk_shufersal.py /path/to/data --workers 10
```

## ארכיטקטורה
המערכת בנויה על גבי `BaseSupermarketScraper` ומעקפת (Bypasses) חלק מהלוגיקה הטורית לטובת ביצועים, תוך שימוש במחלקות המידע (`ParsedProduct`, `ParsedStore`) לשמירה על אחידות הנתונים.

---
**נכתב ע"י:** Antigravity Agent  
**תאריך:** 20 דצמבר 2025
