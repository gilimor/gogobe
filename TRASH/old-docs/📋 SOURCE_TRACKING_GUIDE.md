# 📋 מדריך ניהול מקורות וסריקות

## 🎯 מה זה?

מערכת חכמה למעקב אחר מקורות (PDFs, מגזינים, קטלוגים) שנסרקו:
- **מונעת סריקה כפולה** של אותו קובץ
- **שומרת היסטוריה מלאה** של כל סריקה
- **מזהה duplicates** באמצעות hash של הקובץ
- **מאפשרת re-scan** במידת הצורך

---

## 🚀 התקנה (פעם אחת)

### צעד 1: הוסף טבלת מקורות

```powershell
cd backend\database
.\add_sources_tracking.bat
```

**זה יוצר:**
- טבלה: `scraped_sources`
- Views: `v_source_statistics`, `v_duplicate_sources`
- Function: `is_source_already_scanned()`

---

## 📊 מה הטבלה שומרת?

```yaml
מידע על הקובץ:
  - שם קובץ מקורי
  - Hash (SHA256) - לזיהוי duplicates
  - גודל קובץ
  - נתיב מקורי

פרטי המקור:
  - מפרסם (publisher)
  - תאריך גיליון (issue_date)
  - מספר גיליון (issue_number)
  - שפה ומדינה
  - תגיות (tags)

תוצאות הסריקה:
  - תאריך סריקה
  - זמן עיבוד
  - מספר עמודים
  - מספר מוצרים שנמצאו
  - מספר מוצרים שיובאו
  - נתיבי CSV/SQL

סטטוס:
  - completed / processing / failed / skipped
  - allow_rescan (האם לאפשר סריקה חוזרת)
```

---

## 🎯 שימוש

### אופציה 1: סריקה רגילה (ידלג על duplicates)

```powershell
.\run_gogobe_v2.bat
```

**מה זה עושה:**
1. סורק את התיקייה
2. מחשב hash לכל PDF
3. בודק אם כבר נסרק
4. **מדלג** על PDFs שכבר עובדו
5. מעבד רק קבצים חדשים
6. רושם הכל בדאטהבייס

---

### אופציה 2: סריקה מחדש (force rescan)

```powershell
.\run_gogobe_v2_rescan.bat
```

**מה זה עושה:**
1. מעבד **את כל** הPDFs
2. גם אם כבר נסרקו בעבר
3. עדכן רשומות קיימות

**מתי להשתמש:**
- שיפרת את האלגוריתם
- רוצה לעדכן נתונים ישנים
- מצאת באג ורוצה לסרוק מחדש

---

## 📈 צפייה בנתונים

### סטטיסטיקות כלליות:

```sql
-- בpgAdmin או psql:
SELECT * FROM v_source_statistics;
```

**תוצאה:**
```
source_type | total_sources | total_products_found | avg_scan_duration
------------|---------------|---------------------|------------------
pdf         | 15            | 12000               | 18.5
```

---

### רשימת כל הסריקות:

```sql
SELECT 
    source_name,
    scan_date,
    products_imported,
    scan_duration_seconds,
    scan_status
FROM scraped_sources
ORDER BY scan_date DESC;
```

---

### מציאת duplicates:

```sql
SELECT * FROM v_duplicate_sources;
```

**זה יראה:**
- קבצים שנסרקו יותר מפעם אחת
- מתי כל סריקה בוצעה
- כמה מוצרים נמצאו בכל פעם

---

### בדיקה אם קובץ ספציפי נסרק:

```sql
-- החלף את הHASH בהash האמיתי
SELECT * FROM is_source_already_scanned('abc123...');
```

---

## 🔍 דוגמאות שימוש

### תרחיש 1: סריקה ראשונה

```powershell
# שים 5 PDFs חדשים ב-New prices\
.\run_gogobe_v2.bat
```

**תוצאה:**
```
Found 5 PDF files

Processing: magazine1.pdf
   Calculating hash...
   Hash: a1b2c3d4...
   Extracting text...
   Found 150 products
   Saved!

Processing: magazine2.pdf
   ...

Summary:
  Total: 5
  Processed: 5
  Skipped: 0
  Products: 750
```

---

### תרחיש 2: הוספת קבצים חדשים

```powershell
# הוסף עוד 3 PDFs (2 חדשים, 1 duplicate)
.\run_gogobe_v2.bat
```

**תוצאה:**
```
Found 3 PDF files

Processing: magazine3.pdf (NEW)
   Found 200 products
   
Processing: magazine1.pdf (DUPLICATE)
   SKIPPED: Already scanned on 2024-12-18
   Previous scan found 150 products
   Use --force-rescan to process again
   
Processing: magazine4.pdf (NEW)
   Found 180 products

Summary:
  Total: 3
  Processed: 2
  Skipped: 1
  Products: 380
```

---

### תרחיש 3: שיפרת את הקוד

```powershell
# רוצה לסרוק מחדש עם השיפורים
.\run_gogobe_v2_rescan.bat
```

**תוצאה:**
```
Force rescan: ENABLED

Processing: magazine1.pdf
   Re-scanning (previous: 2024-12-18)
   Found 165 products (vs 150 before)
   
...

Summary:
  All files re-scanned
  Updated database
```

---

## 🛠️ שאילתות שימושיות

### מציאת הסריקה האחרונה:

```sql
SELECT source_name, scan_date, products_imported
FROM scraped_sources
ORDER BY scan_date DESC
LIMIT 10;
```

---

### כמה מוצרים לפי מקור:

```sql
SELECT 
    source_name,
    products_imported,
    scan_date
FROM scraped_sources
WHERE scan_status = 'completed'
ORDER BY products_imported DESC;
```

---

### סריקות שנכשלו:

```sql
SELECT 
    source_name,
    scan_date,
    notes
FROM scraped_sources
WHERE scan_status = 'failed';
```

---

### מוצרים לפי חודש:

```sql
SELECT 
    DATE_TRUNC('month', scan_date) as month,
    COUNT(*) as scans,
    SUM(products_imported) as total_products
FROM scraped_sources
WHERE scan_status = 'completed'
GROUP BY month
ORDER BY month DESC;
```

---

## 📝 עדכון פרטי מקור ידנית

אם רוצה להוסיף פרטים על מגזין:

```sql
UPDATE scraped_sources
SET 
    publisher = 'Dentistry Magazine',
    issue_date = '2024-06-01',
    issue_number = 'June 2024',
    language = 'en',
    country_code = 'GB',
    tags = ARRAY['dental', 'uk', '2024', 'equipment']
WHERE source_name = 'catalogue.pdf';
```

---

## 🎯 תכונות מתקדמות

### אפשר סריקה חוזרת לקובץ ספציפי:

```sql
UPDATE scraped_sources
SET allow_rescan = TRUE
WHERE source_name = 'old_catalog.pdf';
```

**עכשיו** `run_gogobe_v2.bat` יעבד אותו מחדש (אפילו בלי --force-rescan)

---

### הוסף תגיות:

```sql
UPDATE scraped_sources
SET tags = tags || ARRAY['premium', 'surgical']
WHERE source_name LIKE '%surgical%';
```

---

### חפש לפי תגיות:

```sql
SELECT source_name, products_imported
FROM scraped_sources
WHERE tags && ARRAY['dental', 'uk'];
```

---

## 📊 דוחות

### דוח חודשי:

```sql
SELECT 
    TO_CHAR(scan_date, 'YYYY-MM') as month,
    COUNT(*) as sources_scanned,
    SUM(total_pages) as pages_processed,
    SUM(products_imported) as products_added,
    ROUND(AVG(scan_duration_seconds), 2) as avg_duration
FROM scraped_sources
WHERE scan_status = 'completed'
    AND scan_date >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY month
ORDER BY month DESC;
```

---

### דוח יעילות:

```sql
SELECT 
    source_name,
    total_pages,
    products_imported,
    ROUND(products_imported::numeric / NULLIF(total_pages, 0), 2) as products_per_page,
    scan_duration_seconds
FROM scraped_sources
WHERE scan_status = 'completed'
ORDER BY products_per_page DESC
LIMIT 20;
```

---

## 🔧 תחזוקה

### מחק סריקות ישנות (יותר משנה):

```sql
DELETE FROM scraped_sources
WHERE scan_date < CURRENT_DATE - INTERVAL '1 year'
    AND scan_status = 'failed';
```

---

### נקה duplicates (שמור רק האחרון):

```sql
WITH ranked AS (
    SELECT 
        id,
        ROW_NUMBER() OVER (
            PARTITION BY file_hash 
            ORDER BY scan_date DESC
        ) as rn
    FROM scraped_sources
    WHERE file_hash IS NOT NULL
)
UPDATE scraped_sources
SET is_active = FALSE
WHERE id IN (
    SELECT id FROM ranked WHERE rn > 1
);
```

---

## ✅ סיכום

```yaml
יתרונות:
  ✅ לא סורק אותו קובץ פעמיים
  ✅ שומר היסטוריה מלאה
  ✅ מזהה duplicates אוטומטית
  ✅ מאפשר re-scan במידת הצורך
  ✅ סטטיסטיקות מפורטות
  ✅ דוחות ומעקב

שימוש:
  ⚡ run_gogobe_v2.bat - רגיל
  🔄 run_gogobe_v2_rescan.bat - מחדש

טבלאות:
  📊 scraped_sources - הטבלה הראשית
  📈 v_source_statistics - סטטיסטיקות
  🔍 v_duplicate_sources - duplicates
```

---

## 🚀 הצעד הבא

```powershell
# 1. הוסף את הטבלה
cd backend\database
.\add_sources_tracking.bat

# 2. הרץ עם מעקב
cd ..\..
.\run_gogobe_v2.bat

# 3. צפה בתוצאות
# בpgAdmin:
SELECT * FROM scraped_sources;
```

---

**עכשיו יש לך מעקב מלא אחר כל המקורות! 🎉**





