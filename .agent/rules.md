# 🤖 AI Agent Rules - Gogobe Project

## ⚠️ קרא את זה קודם כל!

כשאתה מתחיל לעבוד על הפרויקט הזה, **חובה** לקרוא את המסמכים הבאים:

### 1. 📂 ארגון קבצים
**קובץ:** `docs/FILE_ORGANIZATION_POLICY.md`

**כללים קריטיים:**
- ❌ **אין ליצור קבצים בשורש הפרויקט!**
- ✅ כל קובץ שייך לחנות → `scripts/[STORE_NAME]/` או `docs/[STORE_NAME]/`
- ✅ קבצים כלליים → `scripts/general/` או `docs/user-guides/`
- ✅ כל תיקייה חדשה **חייבת** README.md

**דוגמאות:**
```
✅ CORRECT:
scripts/shufersal/import.bat
docs/shufersal/IMPORT_GUIDE.md
data/shufersal/downloads/

❌ WRONG:
IMPORT-SHUFERSAL.bat (בשורש!)
SHUFERSAL_GUIDE.md (בשורש!)
```

### 2. 📝 כללי קוד
**קובץ:** `CODING_GUIDELINES.md`

**כללים:**
- ❌ **אסור emojis בשמות קבצים!** (בעיות Windows)
- ✅ שמות קבצים: `kebab-case` או `snake_case`
- ✅ שמות תיקיות: `lowercase-with-dashes`
- ✅ קבצי MD חשובים: `SCREAMING_SNAKE_CASE.md`

### 3. 🏗️ מבנה הפרויקט
**קובץ:** `START_HERE.md`

**מבנה:**
```
Gogobe/
├── scripts/
│   ├── kingstore/      ← KingStore scripts
│   ├── shufersal/      ← Shufersal scripts
│   ├── general/        ← כלים כלליים
│   └── database/       ← DB operations
├── docs/
│   ├── kingstore/      ← KingStore docs
│   ├── shufersal/      ← Shufersal docs
│   └── user-guides/    ← מדריכי משתמש
├── backend/
│   ├── scrapers/       ← Scraper classes
│   └── scripts/        ← Python utilities
└── data/
    ├── kingstore/      ← KingStore data
    └── shufersal/      ← Shufersal data
```

---

## 🔍 תהליך עבודה נכון

### לפני שיוצרים קובץ חדש:

1. **שאל את עצמך:**
   - האם זה שייך לחנות ספציפית? → `[STORE]/`
   - האם זה סקריפט? → `scripts/[STORE]/`
   - האם זה תיעוד? → `docs/[STORE]/`
   - האם זה כללי? → `scripts/general/` או `docs/user-guides/`

2. **צור תיקייה אם צריך:**
   ```bash
   mkdir scripts/NEW_STORE
   mkdir docs/NEW_STORE
   mkdir data/NEW_STORE
   ```

3. **צור README מיד:**
   ```bash
   echo "# NEW_STORE Scripts" > scripts/NEW_STORE/README.md
   echo "# NEW_STORE Documentation" > docs/NEW_STORE/README.md
   ```

4. **רק אז** צור את הקבצים בתיקייה הנכונה

### אחרי יצירת קבצים:

1. **בדוק שהכל במקום:**
   ```bash
   # האם יש קבצים בשורש שלא צריכים להיות שם?
   ls *.bat *.md | grep -v "RUN.bat\|START.bat\|README.md"
   ```

2. **בדוק שיש README:**
   ```bash
   # כל תיקייה חדשה צריכה README
   ls scripts/*/README.md
   ls docs/*/README.md
   ```

3. **עדכן README ראשי** אם הוספת תכונה חדשה

---

## 🧪 בדיקות חובה

### לפני Commit:

1. **בדוק encoding:**
   ```bash
   # כל הקבצים צריכים להיות UTF-8
   file -i *.py *.md *.bat
   ```

2. **בדוק שמות קבצים:**
   ```bash
   # אין emojis, אין רווחים מיותרים
   find . -name "*[😀-🙏]*"  # צריך להיות ריק!
   ```

3. **בדוק מבנה:**
   ```bash
   # כל תיקייה חדשה יש לה README
   find scripts/ -type d -exec test -f {}/README.md \; -print
   ```

4. **הרץ את המערכת:**
   ```bash
   # ודא שהכל עובד
   docker-compose up -d
   curl http://localhost:8000
   ```

---

## 📋 Checklist לכל משימה

### תכנון:
- [ ] קראתי את `FILE_ORGANIZATION_POLICY.md`
- [ ] קראתי את `CODING_GUIDELINES.md`
- [ ] הבנתי איפה הקבצים צריכים להיות
- [ ] תכננתי את מבנה התיקיות

### ביצוע:
- [ ] יצרתי תיקיות במבנה הנכון
- [ ] יצרתי README לכל תיקייה חדשה
- [ ] הקבצים במקומות הנכונים (לא בשורש!)
- [ ] שמות קבצים ללא emojis
- [ ] encoding UTF-8 לכל הקבצים

### בדיקה:
- [ ] הרצתי את המערכת - עובדת
- [ ] בדקתי logs - אין שגיאות
- [ ] בדקתי encoding - עברית תקינה
- [ ] בדקתי מבנה - הכל מסודר

### תיעוד:
- [ ] עדכנתי README ראשי אם צריך
- [ ] יצרתי/עדכנתי README בתיקיות חדשות
- [ ] הוספתי הערות בקוד
- [ ] יצרתי walkthrough אם צריך

---

## 🚨 שגיאות נפוצות - אל תעשה!

### ❌ יצירת קבצים בשורש:
```
❌ IMPORT-SHUFERSAL.bat
❌ SHUFERSAL_GUIDE.md
❌ download_shufersal.py
```

**תיקון:**
```
✅ scripts/shufersal/import.bat
✅ docs/shufersal/IMPORT_GUIDE.md
✅ backend/scripts/download_shufersal.py
```

### ❌ ערבוב נושאים:
```
❌ scripts/kingstore_and_shufersal_import.py
```

**תיקון:**
```
✅ scripts/kingstore/import.py
✅ scripts/shufersal/import.py
✅ backend/scripts/import_supermarket.py (כללי)
```

### ❌ תיקיות ללא README:
```
❌ scripts/shufersal/
    ├── import.bat
    └── (אין README!)
```

**תיקון:**
```
✅ scripts/shufersal/
    ├── README.md
    └── import.bat
```

---

## 📚 מסמכים חשובים

קרא את כל אלה לפני שמתחיל:

1. **`START_HERE.md`** - נקודת התחלה
2. **`FILE_ORGANIZATION_POLICY.md`** - כללי ארגון קבצים
3. **`CODING_GUIDELINES.md`** - כללי קוד
4. **`README.md`** - סקירה כללית
5. **`docs/ARCHITECTURE_UNDERSTANDING.md`** - ארכיטקטורה
6. **`docs/DATABASE_ARCHITECTURE.md`** - מבנה DB

---

## 🎯 תזכורת אחרונה

**לפני שיוצרים קובץ - שאל:**
1. איפה הוא שייך?
2. האם התיקייה קיימת?
3. האם יש README בתיקייה?
4. האם השם תקין (ללא emojis)?

**אחרי יצירת קבצים - בדוק:**
1. הכל במקום הנכון?
2. יש README בכל תיקייה חדשה?
3. המערכת עובדת?
4. Logs נקיים?

---

## 💎 איכות קוד - Best Practices

### אתה המתכנת הטוב בעולם!

**עקרונות:**
1. **קוד נקי וקריא** - כל מתכנת יבין מה עשית
2. **תיעוד מלא** - docstrings, comments, type hints
3. **טיפול בשגיאות** - try/except עם הודעות ברורות
4. **לוגים מפורטים** - INFO, WARNING, ERROR ברמות נכונות
5. **בדיקות** - כל פונקציה נבדקת לפני שימוש

### Python Code Standards:

```python
#!/usr/bin/env python3
"""
Module description - מה הקובץ עושה
"""

import logging
from typing import List, Dict, Optional
from dataclasses import dataclass

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='[%(asctime)s] %(levelname)s: %(message)s',
    datefmt='%H:%M:%S'
)
logger = logging.getLogger(__name__)


@dataclass
class Product:
    """Product data structure with type hints"""
    name: str
    barcode: str
    price: float
    category_id: Optional[int] = None


def process_products(products: List[Product]) -> Dict[str, int]:
    """
    Process products and return statistics
    
    Args:
        products: List of Product objects to process
        
    Returns:
        Dict with processing statistics
        
    Raises:
        ValueError: If products list is empty
    """
    if not products:
        raise ValueError("Products list cannot be empty")
    
    logger.info(f"Processing {len(products)} products...")
    
    stats = {'processed': 0, 'errors': 0}
    
    try:
        for product in products:
            # Process each product
            logger.debug(f"Processing: {product.name}")
            stats['processed'] += 1
            
    except Exception as e:
        logger.error(f"Failed to process products: {e}")
        stats['errors'] += 1
        raise
    
    logger.info(f"✓ Processed {stats['processed']} products")
    return stats
```

**חובה:**
- ✅ Type hints לכל פונקציה
- ✅ Docstrings בפורמט Google/NumPy
- ✅ Logging ברמות נכונות (DEBUG, INFO, WARNING, ERROR)
- ✅ Error handling עם הודעות ברורות
- ✅ Progress indicators למשימות ארוכות
- ✅ Return values מתועדים
- ✅ Validation של input

---

## ⚡ ביצועים ויעילות

### אתה מומחה ביצועים!

**עקרונות:**
1. **חשוב על Big O** - כל לולאה, כל query
2. **Batch operations** - לא אחד אחד!
3. **Caching** - אל תחשב פעמיים
4. **Lazy loading** - טען רק מה שצריך
5. **Async where possible** - parallel > serial

### Database Performance:

```python
# ❌ BAD - N+1 queries
for product_id in product_ids:
    cur.execute("SELECT * FROM products WHERE id = %s", (product_id,))
    product = cur.fetchone()
    # Process...

# ✅ GOOD - Single query with IN
cur.execute("""
    SELECT * FROM products 
    WHERE id = ANY(%s)
""", (product_ids,))
products = cur.fetchall()

# ✅ BETTER - Batch insert
cur.executemany("""
    INSERT INTO prices (product_id, price, supplier_id)
    VALUES (%s, %s, %s)
""", [(p.id, p.price, supplier_id) for p in products])

# ✅ BEST - COPY for bulk insert (10x faster!)
from io import StringIO
import csv

buffer = StringIO()
writer = csv.writer(buffer)
for product in products:
    writer.writerow([product.id, product.price, supplier_id])

buffer.seek(0)
cur.copy_from(buffer, 'prices', columns=['product_id', 'price', 'supplier_id'])
```

### Python Performance:

```python
# ❌ BAD - Slow
results = []
for item in large_list:
    if item.price > 100:
        results.append(item.name)

# ✅ GOOD - List comprehension (faster)
results = [item.name for item in large_list if item.price > 100]

# ✅ BETTER - Generator (memory efficient)
results = (item.name for item in large_list if item.price > 100)

# ✅ BEST - Use built-in functions
from operator import attrgetter
results = map(attrgetter('name'), filter(lambda x: x.price > 100, large_list))
```

### Parallel Processing:

```python
from concurrent.futures import ThreadPoolExecutor, as_completed

def process_file(file_path):
    """Process single file"""
    # ... processing logic
    return stats

# ✅ Process files in parallel
with ThreadPoolExecutor(max_workers=4) as executor:
    futures = {executor.submit(process_file, f): f for f in files}
    
    for future in as_completed(futures):
        file = futures[future]
        try:
            stats = future.result()
            logger.info(f"✓ {file}: {stats}")
        except Exception as e:
            logger.error(f"✗ {file}: {e}")
```

**חובה:**
- ✅ Batch operations (100-1000 items)
- ✅ Connection pooling
- ✅ Prepared statements
- ✅ Indexes על columns מחיפוש
- ✅ EXPLAIN ANALYZE לכל query איטי
- ✅ Progress bars למשימות ארוכות
- ✅ Memory profiling לזיהוי leaks

---

## 🗄️ Database Best Practices

### אתה DBA מומחה!

**עקרונות:**
1. **Indexes חכמים** - לא יותר מדי, לא פחות מדי
2. **Normalization** - אבל לא יותר מדי
3. **Constraints** - תן ל-DB לעבוד בשבילך
4. **Transactions** - ACID או כלום
5. **Query optimization** - EXPLAIN הוא החבר שלך

### Index Strategy:

```sql
-- ✅ Index על columns שמחפשים לפיהם
CREATE INDEX idx_products_barcode ON products(ean);
CREATE INDEX idx_prices_product ON prices(product_id);
CREATE INDEX idx_prices_supplier ON prices(supplier_id);

-- ✅ Composite index לשאילתות מורכבות
CREATE INDEX idx_prices_product_supplier ON prices(product_id, supplier_id);

-- ✅ Partial index לחיסכון במקום
CREATE INDEX idx_active_products ON products(id) WHERE is_active = TRUE;

-- ✅ Index על JSONB
CREATE INDEX idx_products_attrs ON products USING GIN (attributes);

-- ❌ אל תיצור index על כל column!
-- ❌ אל תשכפל indexes (product_id כבר ב-composite)
```

### Query Optimization:

```sql
-- ❌ BAD - Full table scan
SELECT * FROM products WHERE LOWER(name) LIKE '%חלב%';

-- ✅ GOOD - Use index
SELECT * FROM products WHERE name ILIKE '%חלב%';

-- ✅ BETTER - Full text search
CREATE INDEX idx_products_name_fts ON products USING GIN (to_tsvector('hebrew', name));
SELECT * FROM products WHERE to_tsvector('hebrew', name) @@ to_tsquery('hebrew', 'חלב');

-- ✅ BEST - Materialized view for complex queries
CREATE MATERIALIZED VIEW product_stats AS
SELECT 
    p.id,
    p.name,
    COUNT(pr.id) as price_count,
    AVG(pr.price) as avg_price,
    MIN(pr.price) as min_price
FROM products p
LEFT JOIN prices pr ON p.id = pr.product_id
GROUP BY p.id, p.name;

CREATE INDEX idx_product_stats_id ON product_stats(id);
REFRESH MATERIALIZED VIEW CONCURRENTLY product_stats;
```

### Transaction Management:

```python
# ✅ GOOD - Proper transaction handling
conn = get_db_connection()
cur = conn.cursor()

try:
    # Start transaction (implicit)
    cur.execute("INSERT INTO products (...) VALUES (...)")
    cur.execute("INSERT INTO prices (...) VALUES (...)")
    
    # Commit if all succeeded
    conn.commit()
    logger.info("✓ Transaction committed")
    
except Exception as e:
    # Rollback on error
    conn.rollback()
    logger.error(f"✗ Transaction rolled back: {e}")
    raise
    
finally:
    cur.close()

# ✅ BETTER - Context manager
from contextlib import contextmanager

@contextmanager
def transaction(conn):
    """Transaction context manager"""
    cur = conn.cursor()
    try:
        yield cur
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        cur.close()

# Usage
with transaction(conn) as cur:
    cur.execute("INSERT INTO products ...")
    cur.execute("INSERT INTO prices ...")
```

### Connection Pooling:

```python
from psycopg2 import pool

# ✅ Create connection pool (reuse connections)
db_pool = pool.ThreadedConnectionPool(
    minconn=1,
    maxconn=10,
    dbname='gogobe',
    user='postgres',
    password='...',
    host='db',
    port='5432'
)

def get_db_connection():
    """Get connection from pool"""
    return db_pool.getconn()

def release_db_connection(conn):
    """Return connection to pool"""
    db_pool.putconn(conn)

# Usage
conn = get_db_connection()
try:
    # Use connection
    cur = conn.cursor()
    cur.execute("SELECT ...")
finally:
    release_db_connection(conn)
```

**חובה:**
- ✅ EXPLAIN ANALYZE לכל query חדש
- ✅ Indexes על foreign keys
- ✅ Constraints (NOT NULL, UNIQUE, CHECK)
- ✅ Transactions לכל write operation
- ✅ Connection pooling
- ✅ Prepared statements (SQL injection prevention)
- ✅ Regular VACUUM ANALYZE
- ✅ Monitor slow queries (pg_stat_statements)

---

## 📊 Monitoring & Logging

### Logging Levels:

```python
# DEBUG - פרטים טכניים למפתחים
logger.debug(f"Processing item {i}/{total}: {item.name}")

# INFO - התקדמות רגילה
logger.info(f"✓ Imported {count} products")

# WARNING - משהו לא צפוי אבל לא קריטי
logger.warning(f"Product {barcode} has no category, using default")

# ERROR - שגיאה שמונעת פעולה
logger.error(f"Failed to import file {filename}: {error}")

# CRITICAL - שגיאה קריטית שמפילה את המערכת
logger.critical(f"Database connection lost!")
```

### Progress Tracking:

```python
from tqdm import tqdm

# ✅ Progress bar
for item in tqdm(items, desc="Processing"):
    process(item)

# ✅ Manual progress
total = len(items)
for i, item in enumerate(items, 1):
    process(item)
    if i % 100 == 0:
        logger.info(f"Progress: {i}/{total} ({i/total*100:.1f}%)")
```

---

## ✅ Pre-Commit Checklist

לפני כל commit:

### Code Quality:
- [ ] יש type hints לכל פונקציה
- [ ] יש docstrings לכל פונקציה/class
- [ ] יש error handling מתאים
- [ ] יש logging ברמות נכונות
- [ ] הקוד עובר pylint/flake8

### Performance:
- [ ] אין N+1 queries
- [ ] יש batch operations
- [ ] יש indexes על columns מחיפוש
- [ ] בדקתי EXPLAIN ANALYZE
- [ ] אין memory leaks

### Database:
- [ ] יש indexes מתאימים
- [ ] יש constraints
- [ ] יש transactions
- [ ] בדקתי query performance
- [ ] עדכנתי schema docs

### Testing:
- [ ] הרצתי את הקוד
- [ ] בדקתי logs - אין errors
- [ ] בדקתי performance - מהיר
- [ ] בדקתי encoding - עברית תקינה
- [ ] בדקתי edge cases

---

**תאריך:** 20 דצמבר 2025  
**גרסה:** 2.0  
**סטטוס:** ✅ **חובה לקרוא!**
