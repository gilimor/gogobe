# איך להריץ יבוא לכל סניפי שופרסל

## אופציה 1: הכי פשוט - BAT File (מומלץ!)

### שלב 1: הורד קבצים מהאתר
1. פתח: https://prices.shufersal.co.il/
2. בחר "PricesFull" מהתפריט
3. לחץ על כל הקבצים שאתה רוצה להוריד (או Ctrl+A לבחירת הכל)
4. הקבצים יורדו ל-`C:\Users\shake\Downloads`

### שלב 2: העבר קבצים לתיקיית הפרויקט
```batch
# הרץ את זה מ-PowerShell או CMD
xcopy "C:\Users\shake\Downloads\PriceFull*.gz" "c:\Users\shake\Limor Shaked Dropbox\LIMOR SHAKED ADVANCED COSMETICS LTD\Gogobe\data\shufersal\" /Y
```

### שלב 3: הרץ יבוא
```batch
# לחץ כפול על:
IMPORT-ALL-SHUFERSAL.bat
```

**זהו!** הסקריפט יעשה הכל אוטומטית:
- יפרוס את כל קבצי ה-GZ
- יייבא כל קובץ בזה אחר זה
- יציג סיכום בסוף

---

## אופציה 2: הורדה אוטומטית (מתקדם)

### שלב 1: צור קובץ עם URLs
צור קובץ: `shufersal_urls.txt` בתיקיית הפרויקט

```
# הוסף URL לכל קובץ שאתה רוצה להוריד (שורה אחת לכל קובץ)
https://pricesprodpublic.blob.core.windows.net/pricefull/PriceFull7290027600007-001-202512200300.gz?sv=...
https://pricesprodpublic.blob.core.windows.net/pricefull/PriceFull7290027600007-002-202512200300.gz?sv=...
https://pricesprodpublic.blob.core.windows.net/pricefull/PriceFull7290027600007-003-202512200300.gz?sv=...
# ... המשך לכל הסניפים
```

**איך לקבל את ה-URLs:**
1. פתח https://prices.shufersal.co.il/
2. בחר "PricesFull"
3. לחץ ימני על קובץ → "Copy link address"
4. הדבק ב-`shufersal_urls.txt`

### שלב 2: הרץ הורדה
```bash
docker exec gogobe-api-1 python /app/backend/scripts/download_all_shufersal.py \
    --urls /app/shufersal_urls.txt \
    --output /app/data/shufersal \
    --workers 10
```

### שלב 3: הרץ יבוא
```bash
IMPORT-ALL-SHUFERSAL.bat
```

---

## אופציה 3: פקודה אחת (אם הקבצים כבר הורדו)

```bash
# פרוס את כל קבצי ה-GZ
docker exec gogobe-api-1 bash -c "cd /app/data/shufersal && gunzip -k *.gz && mv PriceFull* *.xml 2>/dev/null; for f in PriceFull*; do [ -f \"\$f\" ] && mv \"\$f\" \"\$f.xml\"; done"

# יבוא כל הקבצים
docker exec gogobe-api-1 bash -c "
for file in /app/data/shufersal/*.xml; do
    echo 'Importing: '\$file
    python /app/backend/scripts/import_supermarket.py --chain shufersal --file \"\$file\"
done
"
```

---

## כמה זמן זה לוקח?

| סניפים | זמן הורדה | זמן יבוא | סה"כ |
|--------|-----------|----------|------|
| 10 | ~2 דקות | ~5 דקות | **~7 דקות** |
| 50 | ~10 דקות | ~25 דקות | **~35 דקות** |
| 100 | ~20 דקות | ~50 דקות | **~70 דקות** |
| כולם (~200) | ~40 דקות | ~100 דקות | **~2.5 שעות** |

**טיפ:** התחל עם 10-20 סניפים לבדיקה, ואז הרץ על הכל.

---

## בדיקת התוצאות

### באתר
```
http://localhost:8000
```
חפש מוצר והשווה מחירים בין סניפים.

### במסד הנתונים
```sql
-- כמה סניפים יובאו
SELECT COUNT(*) FROM stores WHERE chain_id = (SELECT id FROM chains WHERE slug = 'shufersal');

-- כמה מוצרים לכל סניף
SELECT s.name, COUNT(*) as prices
FROM prices p
JOIN stores s ON p.store_id = s.id
WHERE s.chain_id = (SELECT id FROM chains WHERE slug = 'shufersal')
GROUP BY s.name
ORDER BY prices DESC;

-- סה"כ
SELECT 
    COUNT(DISTINCT product_id) as products,
    COUNT(*) as prices
FROM prices
WHERE supplier_id = (SELECT id FROM suppliers WHERE slug = 'shufersal');
```

---

## פתרון בעיות

### "No files found"
- ודא שהקבצים ב-`data/shufersal/`
- ודא שיש להם סיומת `.xml` (לא רק `.gz`)

### "Failed to parse"
- ודא encoding UTF-8
- בדוק שהקובץ לא פגום

### "Duplicate key"
- זה OK - המערכת מדלגת על מוצרים קיימים

### "Too slow"
- הגבל ל-10-20 קבצים בכל פעם
- הרץ בלילה

---

## המלצה שלי

**להתחלה (עכשיו):**
1. הורד 10 קבצים מהאתר
2. הרץ `IMPORT-ALL-SHUFERSAL.bat`
3. בדוק שהכל עובד

**אחר כך (אם מרוצה):**
1. הורד את כל הקבצים (200+)
2. הרץ שוב את הסקריפט
3. תן לזה לרוץ ברקע

**בעתיד:**
- אוטומציה יומית (cron job)
- התרעות על מחירים חדשים
- השוואת מחירים בין סניפים

---

**בהצלחה! 🚀**
