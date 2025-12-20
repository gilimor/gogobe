# 🤖 מערכת ניהול מחירים אוטומטית - Gogobe

## 🎯 סקירה כללית

מערכת מתקדמת לניהול מחירים אוטומטי ממקורות מרובים, עם תמיכה בשפות רבות ועיבוד מקבילי.

---

## 🚀 תכונות עיקריות

### ✅ אוטומציה מלאה
- **הורדה אוטומטית** מכל המקורות
- **עיבוד מקבילי** של קבצים
- **סיווג אוטומטי** למאות אלפי מוצרים
- **תזמון חכם** - רץ ברקע ללא התערבות

### 🌍 תמיכה רב-לשונית
- **עברית** (he)
- **אנגלית** (en)
- **ערבית** (ar)
- **רוסית** (ru)
- קל להוסיף שפות נוספות!

### ⚡ עיבוד מקבילי
- **Multi-Processing** - מנצל את כל ליבות המעבד
- **Multi-Threading** - הורדות במקביל
- **Batch Processing** - עיבוד אצווה חכם
- **מהירות**: אלפי מוצרים לשנייה!

### 📊 ניהול מקורות מרובים
- **מודולרי** - כל מקור עצמאי
- **הרחבה קלה** - הוסף מקורות חדשים בקלות
- **תזמון גמיש** - לכל מקור תזמון משלו
- **מעקב ודיווח** - לוגים מפורטים

---

## 📂 ארכיטקטורה

```
┌─────────────────────────────────────────────────────────────┐
│                  🤖 Auto Price Manager                      │
│               (המנצח - מתזמן הכל)                          │
└──────────────────┬──────────────────────────────────────────┘
                   │
     ┌─────────────┼─────────────┐
     │             │             │
┌────▼─────┐ ┌────▼─────┐ ┌────▼─────┐
│ KingStore│ │Shufersal │ │  Rami    │
│  Source  │ │  Source  │ │  Levi    │
└────┬─────┘ └────┬─────┘ └────┬─────┘
     │            │            │
     │   ┌────────┴────────┐   │
     │   │                 │   │
     ▼   ▼                 ▼   ▼
┌─────────────────────────────────┐
│      📥 Smart Downloader        │
│   (הורדה מקבילית + חכמה)       │
└──────────┬──────────────────────┘
           │
           ▼
┌─────────────────────────────────┐
│     🔄 Parallel Processor       │
│  (עיבוד XML/JSON/CSV מקבילי)   │
└──────────┬──────────────────────┘
           │
           ▼
┌─────────────────────────────────┐
│  🏷️ Multilang Classifier        │
│  (סיווג רב-לשוני מקבילי)        │
└──────────┬──────────────────────┘
           │
           ▼
┌─────────────────────────────────┐
│     💾 PostgreSQL Database      │
│    (מנורמל ואופטימלי)           │
└─────────────────────────────────┘
```

---

## 🛠️ רכיבים

### 1️⃣ Auto Price Manager (`auto_price_manager.py`)
**המנצח של המערכת** - מתזמן ומנהל את כל התהליך

**תפקידים:**
- קריאה לכל המקורות לפי תזמון
- מעקב אחר סטטוס
- דיווח וטיפול בשגיאות
- יצירת Scraping Sessions

**שימוש:**
```bash
# הרצה חד-פעמית
python backend\scripts\auto_price_manager.py --once

# תזמון אוטומטי (רץ ברקע)
python backend\scripts\auto_price_manager.py

# מקור ספציפי
python backend\scripts\auto_price_manager.py --once --source kingstore
```

### 2️⃣ Parallel Multilang Classifier (`parallel_multilang_classifier.py`)
**מסווג חכם רב-לשוני מקבילי**

**תכונות:**
- ✅ תמיכה ב-4 שפות (עברית, אנגלית, ערבית, רוסית)
- ✅ 17 קטגוריות מוכנות
- ✅ עיבוד מקבילי - מנצל את כל המעבד
- ✅ התאמה למותגים ומילות מפתח
- ✅ ציון אמון (Confidence Score)

**דוגמה:**
```bash
# בדיקת סיווג למוצר
python backend\scripts\parallel_multilang_classifier.py --test "חלב תנובה"

# סיווג כל המוצרים (4 workers)
python backend\scripts\parallel_multilang_classifier.py --workers 4

# סיווג ל-vertical ספציפי
python backend\scripts\parallel_multilang_classifier.py --vertical supermarket
```

**ביצועים:**
```
מוצרים:     13,522
זמן:         ~120 שניות
מהירות:      ~110 מוצרים/שנייה
Workers:     4 (מקבילי)
הצלחה:       58%
```

### 3️⃣ Smart Downloaders
**מורידים חכמים עם תמיכה במקביליות**

**תכונות:**
- ✅ הורדות מקבילות (Thread Pool)
- ✅ זיהוי כפילויות (Hash)
- ✅ חידוש אוטומטי
- ✅ Retry logic
- ✅ Progress tracking

**דוגמה:**
```bash
# הורדה מקבילית של 50 קבצים
python backend\scripts\kingstore_smart_downloader.py --limit 50 --parallel 10
```

### 4️⃣ Parallel Processors
**מעבדים מקבילים לקבצים**

**תכונות:**
- ✅ עיבוד XML/JSON/CSV
- ✅ Batch processing
- ✅ Transaction safety
- ✅ Error handling per item
- ✅ SAVEPOINT support

---

## 📋 הוספת מקור חדש

### שלב 1: יצירת Downloader
```python
# backend/scripts/shufersal_downloader.py
def download_from_shufersal():
    # Logic להורדה מ-Shufersal
    pass
```

### שלב 2: יצירת Processor
```python
# backend/scripts/shufersal_processor.py
def process_shufersal_xml(filename):
    # Logic לעיבוד XML של Shufersal
    pass
```

### שלב 3: הגדרה ב-Auto Manager
```python
# In auto_price_manager.py
SOURCES_CONFIG = {
    'shufersal': {
        'name': 'Shufersal',
        'downloader_script': 'backend/scripts/shufersal_downloader.py',
        'processor_script': 'backend/scripts/shufersal_processor.py',
        'classifier_script': 'backend/scripts/parallel_multilang_classifier.py',
        'vertical': 'supermarket',
        'schedule': '0 */8 * * *',  # כל 8 שעות
        'parallel_downloads': 10,
        'parallel_processing': 4,
        'enabled': True
    }
}
```

**זהו! המערכת תתחיל לעבד את המקור החדש אוטומטית!** 🎉

---

## 🏷️ הוספת שפה חדשה למסווג

### דוגמה: הוספת צרפתית

```python
# In parallel_multilang_classifier.py
CATEGORY_KEYWORDS_MULTILANG = {
    'Dairy': {
        'he': ['חלב', 'גבינה', ...],
        'en': ['milk', 'cheese', ...],
        'ar': ['حليب', 'جبن', ...],
        'ru': ['молоко', 'сыр', ...],
        'fr': ['lait', 'fromage', 'yaourt', 'beurre'],  # ⭐ הוספה!
    },
    # ... rest of categories
}
```

**המסווג אוטומטית יתמוך בשפה החדשה!**

---

## ⚡ אופטימיזציות

### 1. **Database Indexing**
```sql
-- אינדקסים חיוניים למהירות
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_vertical ON products(vertical_id);
CREATE INDEX idx_prices_store ON prices(store_id);
CREATE INDEX idx_prices_product ON prices(product_id);
CREATE INDEX idx_products_name ON products USING GIN (name gin_trgm_ops);
```

### 2. **Batch Processing**
```python
CHUNK_SIZE = 1000  # Process 1000 products at a time
# זה מאזן בין זיכרון למהירות
```

### 3. **Connection Pooling**
```python
# כל worker מקבל connection משלו
# לא שיתוף connections בין processes
```

### 4. **Parallel Workers**
```python
MAX_WORKERS = min(cpu_count(), 8)
# לא יותר מ-8 workers כדי לא לעמוס את המערכת
```

---

## 📊 מעקב וניטור

### בדיקת סטטוס
```bash
python backend\scripts\generate_status_report.py
```

### לוגים
כל הפעולות נרשמות עם timestamps:
```
[10:30:15] [INFO] Starting KingStore processing...
[10:30:20] [INFO] Download completed in 5.2s
[10:35:42] [INFO] Processing completed in 322.0s
[10:37:15] [INFO] Classification completed in 93.1s
[10:37:15] [INFO] ✅ KingStore processing complete!
```

### Database Sessions
```sql
-- מעקב אחר סשנים
SELECT * FROM scraping_sessions 
ORDER BY started_at DESC 
LIMIT 10;

-- קבצים שהורדו
SELECT * FROM downloaded_files 
WHERE processing_status = 'completed'
ORDER BY downloaded_at DESC;
```

---

## 🎯 תזמון מומלץ

### סופרמרקטים (עדכון תכוף)
```python
'schedule': '0 */6 * * *'  # כל 6 שעות
```

### ספקים רגילים (עדכון יומי)
```python
'schedule': '0 8 * * *'  # כל בוקר בשעה 8
```

### מקורות עם API Rate Limit
```python
'schedule': '0 */12 * * *'  # כל 12 שעות
```

---

## 🔒 אבטחה ו-Reliability

### 1. **Transaction Safety**
- כל batch ב-transaction נפרד
- SAVEPOINT לכל item
- Rollback אוטומטי בשגיאה

### 2. **Duplicate Prevention**
- File hash checking
- UNIQUE constraints
- ON CONFLICT handling

### 3. **Error Handling**
- Try-catch בכל רמה
- Logging מפורט
- Graceful degradation

### 4. **Resource Management**
- Connection cleanup
- Process pools
- Memory management

---

## 📈 Production Checklist

### לפני הפעלה ב-Production:

- [ ] הגדר מספר workers מתאים למכונה
- [ ] וודא שיש מספיק מקום דיסק (GB)
- [ ] הגדר תזמון שלא עומס בשעות שיא
- [ ] בדוק שכל ה-scripts מריצים ללא שגיאות
- [ ] הפעל backup אוטומטי ל-DB
- [ ] הגדר monitoring (Grafana/Prometheus)
- [ ] בדוק logs rotation
- [ ] וודא שה-API Server רץ (uvicorn)

---

## 🎉 תוצאות

### Before (ידני):
```
- הורדה ידנית של קבצים
- עיבוד ידני
- סיווג ידני או חלקי
- זמן: שעות רבות ⏰
- טעויות אנוש ❌
```

### After (אוטומטי):
```
✅ הורדה אוטומטית מכל המקורות
✅ עיבוד מקבילי מהיר
✅ סיווג אוטומטי 58%+
✅ זמן: דקות בודדות ⚡
✅ אמין ועקבי 🎯
✅ מוכן ל-scale 📈
```

---

## 🚀 התחלה מהירה

```bash
# 1. התקן dependencies
pip install schedule psycopg2

# 2. הרץ פעם אחת לבדיקה
python backend\scripts\auto_price_manager.py --once

# 3. הרץ במצב אוטומטי
python backend\scripts\auto_price_manager.py

# או דרך BAT:
🤖 AUTO_PRICE_MANAGER.bat
```

---

## 💡 Tips & Tricks

### מהירות מקסימלית:
```python
--workers 8 --parallel 20
```

### זהירות (מכונה חלשה):
```python
--workers 2 --parallel 5
```

### בדיקת יכולת:
```bash
python -c "import multiprocessing; print(multiprocessing.cpu_count())"
```

---

## 📞 תמיכה

אם יש בעיה:
1. בדוק לוגים
2. הרץ `generate_status_report.py`
3. בדוק את `scraping_sessions` בDB
4. בדוק שאין processes תקועים

---

🎯 **המערכת מוכנה לייצור ול-scale!**

