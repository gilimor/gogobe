# 🚀 הוראות הרצה - KingStore Import

## תאריך: 20 דצמבר 2025

---

## ⚠️ לפני שמתחילים:

### 1. ודא ש-Docker רץ:
```bash
docker ps
```

אם מקבל שגיאה:
```bash
START-DOCKER.bat
# המתן 30 שניות
```

---

## 🎯 הרצה:

### הכי פשוט:
```bash
IMPORT-KINGSTORE.bat
```

לחץ Enter ותן לזה לרוץ 10-15 דקות.

---

## 🔍 בדיקת תוצאות:

### דרך האתר:
```
http://localhost:8000
```

חפש "milk" או "חלב" - תראה מוצרים ממספר סניפים!

### דרך הטרמינל:
```bash
# בדוק כמה חנויות יש
docker exec gogobe-api-1 python -c "import psycopg2; conn = psycopg2.connect(dbname='gogobe', user='postgres', password='9152245-Gl!', host='host.docker.internal'); cur = conn.cursor(); cur.execute('SELECT COUNT(*) FROM stores'); print('Stores:', cur.fetchone()[0]); cur.execute('SELECT COUNT(*) FROM products'); print('Products:', cur.fetchone()[0]); cur.execute('SELECT COUNT(*) FROM prices'); print('Prices:', cur.fetchone()[0])"
```

---

## ❌ בעיות אפשריות:

### "Docker לא רץ"
**פתרון:**
```bash
START-DOCKER.bat
```
חכה 30 שניות והרץ שוב.

### "Container not found"
**פתרון:**
```bash
docker-compose up -d
```

### "הסקריפט נסגר מיד"
**פתרון:**
הרץ באופן ידני:

1. פתח PowerShell
2. ```bash
   cd "C:\Users\shake\Limor Shaked Dropbox\LIMOR SHAKED ADVANCED COSMETICS LTD\Gogobe"
   docker cp backend\scripts\kingstore_xml_processor.py gogobe-api-1:/app/processor.py
   docker exec -it gogobe-api-1 python /app/processor.py /app/backend/data/kingstore
   ```

---

## 📊 מה אמור לקרות:

```
[00:01] Processing file 1/366...
[00:02] Processing file 2/366...
[00:03] Processing file 3/366...
...
[12:45] Processing file 366/366...

Summary:
Files processed: 366
Products found: ~15,000
Products imported: ~8,000 (unique by barcode)
Prices imported: ~13,000
Stores created: 27
```

---

## ✅ אחרי שמסיים:

פתח:
```
http://localhost:8000
```

חפש מוצר → תראה אותו במספר סניפים! 🎉

---

תאריך: 20 דצמבר 2025

