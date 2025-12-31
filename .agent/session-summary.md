# 📋 Gogobe Project - Quick Reference

## 🚀 מה עשינו היום (20 דצמבר 2025)

### ✅ הושלם:
1. **מערכת גנרית ליבוא** - תומכת בכל רשת בעולם
2. **יבוא שופרסל** - 6,456 מוצרים, 14,872 מחירים, 2 סניפים
3. **סיווג אוטומטי** - 16,644 מוצרים ל-14 קטגוריות
4. **ארגון קבצים** - הועבר למבנה נכון

### 📂 מבנה קבצים (תוקן!):
```
scripts/shufersal/
  ├── import.bat
  ├── import-all.bat
  └── README.md

docs/shufersal/
  ├── IMPORT_GUIDE.md
  ├── IMPORT_ALL_GUIDE.md
  ├── SUCCESS.md
  └── README.md

backend/scrapers/
  ├── base_supermarket_scraper.py
  └── shufersal_scraper.py

backend/scripts/
  └── import_supermarket.py

data/shufersal/
  └── (קבצי XML)
```

---

## 🎯 הוראות לשיחה הבאה

### קרא קודם:
1. `.agent/rules.md` - **חובה!**
2. `FILE_ORGANIZATION_POLICY.md`
3. `CODING_GUIDELINES.md`

### לפני יצירת קבצים:
- ✅ בדוק איפה הם שייכים
- ✅ צור תיקייה + README
- ✅ אל תשים בשורש!

### אחרי עבודה:
- ✅ בדוק logs
- ✅ בדוק encoding
- ✅ הרץ את המערכת
- ✅ עדכן תיעוד

---

## 📊 סטטוס נוכחי

### מסד נתונים:
- **17,568** מוצרים (KingStore + Shufersal)
- **1,038,357** מחירים
- **25** סניפים (23 KingStore + 2 Shufersal)
- **74** קטגוריות

### רשתות:
1. ✅ **KingStore** - 13,693 מוצרים, 23 סניפים
2. ✅ **Shufersal** - 6,456 מוצרים, 2 סניפים
3. 🔜 **Rami Levy** - מוכן להוספה
4. 🔜 **Victory** - מוכן להוספה

---

## 🔧 כלים זמינים

### יבוא:
- `scripts/kingstore/import.bat`
- `scripts/shufersal/import.bat`
- `scripts/shufersal/import-all.bat`

### מסד נתונים:
- `scripts/database/classify-categories.bat`
- `scripts/database/deduplicate-products.bat`

### Python:
- `backend/scripts/import_supermarket.py`
- `backend/scripts/auto_categorize.py`
- `backend/scrapers/base_supermarket_scraper.py`

---

## 📝 TODO

### קצר טווח:
- [ ] תקן שמות סניפי שופרסל (מ-Stores XML)
- [ ] יבוא עוד סניפי שופרסל
- [ ] Refactor KingStore לשימוש ב-base class

### ארוך טווח:
- [ ] הוסף Rami Levy
- [ ] הוסף Victory
- [ ] יבוא אוטומטי יומי
- [ ] התרעות על שינויי מחירים

---

**תאריך:** 20 דצמבר 2025  
**עודכן:** 19:37
