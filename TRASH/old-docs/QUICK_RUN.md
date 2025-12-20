# ⚡ הכי מהיר! (2 דקות)

## פתרון זריז לcatalogue.pdf

---

## 🚀 צעדים:

### 1. גש ל-Colab
```
https://colab.research.google.com
```

### 2. העלה את הNotebook הקיים
```
File → Upload notebook

בחר:
backend/scripts/PDF_Magazine_Scanner.ipynb
```

### 3. הרץ!
```
Shift+Enter בכל תא

כשמבקש להעלות PDF:
→ העלה את: New prices\catalogue.pdf
```

### 4. הורד תוצאות
```
✅ catalogue_products.csv
✅ catalogue_products.sql
```

### 5. טען לדאטהבייס
```powershell
cd backend\database
$env:PGPASSWORD="9152245-Gl!"
& "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d gogobe -f "C:\path\to\catalogue_products.sql"
```

---

## זהו! ⚡

**זמן: 5 דקות**
**תוצאה: 100+ מוצרים בדאטהבייס!**

---

## רוצה עוד PDFs?

פשוט הרץ שוב:
1. העלה PDF אחר
2. קבל CSV + SQL
3. טען לDB
4. חזור על זה!

---

## אוטומציה מלאה?

אחרי שתתקן את Python:
```powershell
cd backend\scripts
.\auto_process_all.bat
```

**או:**

השתמש ב-Colab עם הקוד ב:
**`RUN_BATCH_IN_COLAB.md`**

---

# 🎯 התחל עכשיו!

1. **https://colab.research.google.com**
2. **Upload: PDF_Magazine_Scanner.ipynb**
3. **Run!** ▶️

**5 דקות → 100+ מוצרים!** 🚀





