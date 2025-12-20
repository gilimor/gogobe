# 🎯 Quick Commands - KingStore Full Import

## יבוא מלא (פקודה אחת!):

```bash
# יבוא כל הקבצים + זיהוי אוטומטי של מוצרים משותפים
scripts\supermarket\import-all-kingstore.bat
```

**זמן:** ~10-15 דקות

**מה זה עושה:**
- מעבד 366 קבצים
- מזהה מוצרים זהים לפי ברקוד **אוטומטית**
- מוצר אחד = מחירים ממספר סניפים ✅

**לא צריך איחוד נוסף!** הכל עובד מהתחלה נכון.

## בדיקה:
```
http://localhost:8000
```

חפש "milk" או "חלב" - תראה מוצרים ממספר סניפים!

---

**מדריך מלא:** [docs/KINGSTORE_FULL_IMPORT_GUIDE.md](docs/KINGSTORE_FULL_IMPORT_GUIDE.md)  
**הסבר התיקון:** [docs/FIX_SHARED_PRODUCTS.md](docs/FIX_SHARED_PRODUCTS.md)

