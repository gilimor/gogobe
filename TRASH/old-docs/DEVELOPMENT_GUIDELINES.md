# 📋 קווים מנחים לפיתוח - Gogobe

> דרישות רוחביות חובה לכל שינוי בפרויקט

---

## 🎯 עקרונות יסוד

### 1. **תמיד לחשוב רוחבי (Cross-Cutting Concerns)**
- כל שינוי משפיע על המערכת כולה
- לא לפתור רק את הבעיה המיידית
- לחשוב על תחזוקה עתידית

### 2. **איכות קודם הכל (Quality First)**
- עדיף לקחת יותר זמן ולעשות נכון
- קוד איכותי חוסך זמן בעתיד
- תיעוד = חלק מהקוד

### 3. **עקביות (Consistency)**
- אותו דפוס בכל הפרויקט
- אותו סגנון קידוד
- אותו מבנה תיקיות

---

## 📂 1. מיקום קבצים (File Location)

### ✅ חובה לבדוק לפני יצירת קובץ:

```yaml
שאלות:
  - איזה סוג קובץ זה?
  - איפה המיקום הלוגי שלו?
  - האם יש README בתיקייה?
  - האם השם תואם את המוסכמה?

מיקומים:
  Backend:
    - Python scripts → backend/scripts/{category}/
    - API routes → backend/api/routes/
    - Database → backend/database/
    - Tests → backend/tests/
  
  Frontend:
    - HTML/JS/CSS → frontend/
    - Assets → frontend/assets/
  
  Scripts:
    - BAT files → scripts/{category}/
    - Setup → scripts/setup/
    - Testing → scripts/testing/
  
  Docs:
    - Guides → docs/guides/
    - Technical → docs/technical/
    - Changelog → docs/changelog/
  
  Archive:
    - Old files → archive/old-scripts/
    - Deprecated → archive/deprecated-docs/
```

### ❌ אסור:
- קבצים בשורש (חוץ מ-README, requirements, docker)
- קבצים עם שמות לא ברורים
- קבצים במיקום שלא הגיוני

---

## 🗄️ 2. יעילות מסד נתונים (Database Efficiency)

### ✅ חובה לכל שאילתת SQL:

```sql
-- 1. אינדקסים
-- האם יש אינדקס על השדות ב-WHERE/JOIN?
CREATE INDEX idx_name ON table(column);

-- 2. JOIN יעיל
-- תמיד LEFT JOIN במקום subquery אם אפשר
SELECT ... FROM a LEFT JOIN b ON a.id = b.a_id
-- במקום:
SELECT ... FROM a WHERE id IN (SELECT a_id FROM b)

-- 3. Normalization
-- שמור מידע פעם אחת, הפנה עם FK
-- טבלה נפרדת לכל entity

-- 4. Pagination
-- תמיד עם LIMIT + OFFSET
SELECT ... LIMIT 20 OFFSET 40

-- 5. Aggregate נכון
-- COUNT, SUM, AVG עם GROUP BY
SELECT category, COUNT(*) FROM products GROUP BY category
```

### 📊 בדיקות ביצועים:

```python
# תמיד מדוד זמן ריצה:
import time
start = time.time()
# ... query ...
print(f"Query took {time.time() - start:.2f}s")

# EXPLAIN לשאילתות מורכבות:
EXPLAIN ANALYZE SELECT ...
```

### ❌ אסור:
- SELECT * (תמיד רק השדות הנדרשים)
- N+1 queries (תמיד JOIN)
- ללא אינדקס על foreign keys
- ללא transaction לעדכונים מרובים

---

## 💻 3. פלטפורמה (Platform Awareness)

### Windows (הפלטפורמה הנוכחית):

```batch
REM ✅ נכון - Windows paths
cd "C:\Users\shake\...\Gogobe"
python backend\scripts\file.py

REM ❌ לא נכון - Linux paths
cd /home/user/Gogobe
python backend/scripts/file.py

REM ✅ נכון - multiple commands
cd backend ; python script.py

REM ❌ לא נכון
cd backend && python script.py

REM ✅ נכון - encoding
chcp 65001 >nul
echo "שלום"

REM ✅ נכון - line endings
# CRLF (\r\n) for .bat files
# LF (\n) for .py files with .gitattributes
```

### Python - Platform Independent:

```python
import os
from pathlib import Path

# ✅ נכון - cross-platform
BASE_DIR = Path(__file__).parent
data_file = BASE_DIR / "data" / "file.txt"

# ❌ לא נכון - hard-coded paths
data_file = "C:\\data\\file.txt"

# ✅ נכון - check platform
if os.name == 'nt':  # Windows
    # Windows-specific code
elif os.name == 'posix':  # Linux/Mac
    # Unix-specific code
```

---

## 📝 4. קוד מסודר ומתועד (Clean & Documented Code)

### Python:

```python
"""
Module docstring - מה המודול עושה
"""

import logging
from typing import List, Dict, Optional

logger = logging.getLogger(__name__)


def process_products(products: List[Dict], batch_size: int = 1000) -> int:
    """
    מעבד רשימת מוצרים ומעדכן את מסד הנתונים.
    
    Args:
        products: רשימת מוצרים לעיבוד
        batch_size: גודל אצווה לעיבוד מקבילי (ברירת מחדל: 1000)
    
    Returns:
        int: מספר המוצרים שעובדו בהצלחה
    
    Raises:
        ValueError: אם הרשימה ריקה
        DatabaseError: אם יש בעיה בחיבור למסד הנתונים
    
    Example:
        >>> products = [{'name': 'Product 1', 'price': 10.5}]
        >>> count = process_products(products)
        >>> print(f"Processed {count} products")
    """
    # Validation
    if not products:
        raise ValueError("Products list cannot be empty")
    
    # Constants
    MAX_RETRIES = 3
    
    # Processing logic
    processed_count = 0
    
    try:
        # Process in batches
        for i in range(0, len(products), batch_size):
            batch = products[i:i + batch_size]
            # ... processing logic ...
            processed_count += len(batch)
            logger.info(f"Processed batch {i//batch_size + 1}, total: {processed_count}")
    
    except Exception as e:
        logger.error(f"Error processing products: {e}", exc_info=True)
        raise
    
    return processed_count


# ✅ Variable naming
user_count = 10        # snake_case
MAX_CONNECTIONS = 100  # UPPER_CASE for constants
UserProfile = {}       # PascalCase for classes

# ❌ Bad naming
x = 10
cnt = 100
temp = {}
```

### SQL:

```sql
-- ✅ נכון - מתועד וקריא
-- Purpose: Get top 10 products by price from active stores
-- Created: 2025-12-20
-- Author: Developer Name
SELECT 
    p.id,
    p.name,
    p.price,
    s.store_name,
    c.name AS category_name
FROM products p
    INNER JOIN stores s ON p.store_id = s.id
    LEFT JOIN categories c ON p.category_id = c.id
WHERE 
    p.is_active = TRUE
    AND s.is_active = TRUE
    AND p.price > 0
ORDER BY p.price DESC
LIMIT 10;

-- ❌ לא נכון - לא קריא
select * from products p,stores s where p.store_id=s.id limit 10
```

---

## 📊 5. לוגים (Logging)

### Python Logging:

```python
import logging
from datetime import datetime

# ✅ Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/app.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

# ✅ שימוש נכון
def download_file(url: str) -> bool:
    """Download a file from URL"""
    logger.info(f"Starting download from {url}")
    
    try:
        # ... download logic ...
        logger.info(f"Download completed successfully: {url}")
        return True
    
    except ConnectionError as e:
        logger.error(f"Connection failed for {url}: {e}")
        return False
    
    except Exception as e:
        logger.critical(f"Unexpected error downloading {url}: {e}", exc_info=True)
        return False


# רמות לוג:
logger.debug("Detailed debugging info")      # Development only
logger.info("General information")           # Important events
logger.warning("Warning - might be problem") # Potential issues
logger.error("Error occurred")               # Errors that were handled
logger.critical("Critical failure")          # System failure
```

### BAT Logging:

```batch
@echo off
REM ✅ Logging in BAT files

echo [%date% %time%] Starting process... >> logs\process.log
echo ════════════════════════════════════════
echo   📊 Process Name
echo ════════════════════════════════════════

python script.py 2>&1 | tee -a logs\process.log

if errorlevel 1 (
    echo [%date% %time%] ERROR: Process failed >> logs\process.log
    exit /b 1
) else (
    echo [%date% %time%] SUCCESS: Process completed >> logs\process.log
)
```

---

## ⚠️ 6. טיפול בשגיאות (Error Handling)

### Python:

```python
from typing import Optional
import psycopg2
from psycopg2 import OperationalError, IntegrityError

def connect_db() -> Optional[psycopg2.connection]:
    """
    יצירת חיבור למסד נתונים עם error handling מלא
    """
    MAX_RETRIES = 3
    RETRY_DELAY = 2
    
    for attempt in range(MAX_RETRIES):
        try:
            conn = psycopg2.connect(
                dbname='gogobe',
                user='postgres',
                password='***',
                host='localhost'
            )
            logger.info(f"Database connection established (attempt {attempt + 1})")
            return conn
        
        except OperationalError as e:
            logger.warning(f"Connection attempt {attempt + 1} failed: {e}")
            if attempt < MAX_RETRIES - 1:
                time.sleep(RETRY_DELAY)
            else:
                logger.error("All connection attempts failed")
                return None
        
        except Exception as e:
            logger.critical(f"Unexpected error connecting to DB: {e}", exc_info=True)
            return None


def process_with_transaction(conn, items: List[Dict]) -> bool:
    """
    עיבוד עם transaction - או הכל או כלום
    """
    cursor = conn.cursor()
    
    try:
        # Start transaction
        for item in items:
            cursor.execute(
                "INSERT INTO products (name, price) VALUES (%s, %s)",
                (item['name'], item['price'])
            )
        
        # Commit if all successful
        conn.commit()
        logger.info(f"Successfully processed {len(items)} items")
        return True
    
    except IntegrityError as e:
        # Rollback on constraint violation
        conn.rollback()
        logger.error(f"Integrity error: {e}")
        return False
    
    except Exception as e:
        # Rollback on any error
        conn.rollback()
        logger.error(f"Transaction failed: {e}", exc_info=True)
        return False
    
    finally:
        # Always close cursor
        cursor.close()
```

### טיפול בשגיאות - Best Practices:

```python
# ✅ נכון - specific exceptions
try:
    result = risky_operation()
except ValueError as e:
    handle_value_error(e)
except KeyError as e:
    handle_key_error(e)
except Exception as e:
    logger.error(f"Unexpected error: {e}")

# ❌ לא נכון - catch all
try:
    result = risky_operation()
except:
    pass  # Silent failure!

# ✅ נכון - graceful degradation
def get_product_price(product_id: int) -> Optional[float]:
    """Get price, return None if not found"""
    try:
        price = fetch_from_db(product_id)
        return price
    except NotFoundError:
        logger.warning(f"Product {product_id} not found")
        return None  # Graceful degradation

# ✅ נכון - user-friendly errors
try:
    process_file(filename)
except FileNotFoundError:
    print(f"❌ Error: File '{filename}' not found")
    print("💡 Tip: Check the file path and try again")
except PermissionError:
    print(f"❌ Error: No permission to read '{filename}'")
    print("💡 Tip: Run as administrator")
```

---

## 🧪 7. בדיקות (Testing)

### Unit Tests:

```python
# tests/test_classifier.py
import unittest
from backend.scripts.parallel_multilang_classifier import classify_product

class TestClassifier(unittest.TestCase):
    """Unit tests for product classification"""
    
    def setUp(self):
        """Setup before each test"""
        self.test_products = [
            {'name': 'חלב תנובה 3%', 'expected': 'Dairy'},
            {'name': 'לחם פרוס', 'expected': 'Bakery'},
            {'name': 'עגבניות', 'expected': 'Vegetables'},
        ]
    
    def test_classify_dairy(self):
        """Test dairy product classification"""
        result = classify_product('חלב תנובה 3%')
        self.assertEqual(result, 'Dairy')
    
    def test_classify_bakery(self):
        """Test bakery product classification"""
        result = classify_product('לחם פרוס')
        self.assertEqual(result, 'Bakery')
    
    def test_classify_unknown(self):
        """Test unknown product returns None"""
        result = classify_product('xyz123')
        self.assertIsNone(result)
    
    def test_empty_input(self):
        """Test empty input raises ValueError"""
        with self.assertRaises(ValueError):
            classify_product('')
    
    def tearDown(self):
        """Cleanup after each test"""
        pass


if __name__ == '__main__':
    unittest.main()
```

### E2E Tests:

```python
# tests/test_e2e_download_process.py
import unittest
import os
from pathlib import Path

class TestDownloadProcess(unittest.TestCase):
    """End-to-end test for download and process flow"""
    
    def test_full_workflow(self):
        """Test complete download → process → classify workflow"""
        
        # 1. Download
        from backend.scripts import kingstore_smart_downloader
        downloaded = kingstore_smart_downloader.download(limit=5)
        self.assertGreater(len(downloaded), 0, "Should download files")
        
        # 2. Process
        from backend.scripts import kingstore_xml_processor
        processed = kingstore_xml_processor.process_files(downloaded)
        self.assertGreater(processed['products'], 0, "Should process products")
        
        # 3. Classify
        from backend.scripts import parallel_multilang_classifier
        classified = parallel_multilang_classifier.classify_all()
        self.assertGreater(classified, 0, "Should classify products")
        
        # 4. Verify in DB
        from backend.database import check_db
        count = check_db.count_products()
        self.assertGreater(count, 0, "Should have products in DB")
```

### Integration Tests:

```python
# tests/test_integration_api.py
import unittest
from fastapi.testclient import TestClient
from backend.api.main import app

class TestAPIIntegration(unittest.TestCase):
    """Integration tests for API"""
    
    def setUp(self):
        self.client = TestClient(app)
    
    def test_get_products(self):
        """Test /api/products/search endpoint"""
        response = self.client.get("/api/products/search?q=milk")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertIn('products', data)
        self.assertIsInstance(data['products'], list)
    
    def test_get_stats(self):
        """Test /api/stats endpoint"""
        response = self.client.get("/api/stats")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertIn('total_products', data)
        self.assertGreater(data['total_products'], 0)
```

---

## ⚡ 8. ביצועים (Performance)

### Parallel Processing:

```python
from multiprocessing import Pool, cpu_count
from concurrent.futures import ThreadPoolExecutor
import time

# ✅ נכון - Multi-Processing לעבודות CPU-intensive
def parallel_classify(products: List[Dict]) -> List[Dict]:
    """
    סיווג מקבילי של מוצרים
    """
    MAX_WORKERS = min(cpu_count(), 8)
    
    with Pool(processes=MAX_WORKERS) as pool:
        results = pool.map(classify_product, products)
    
    return results

# ✅ נכון - Multi-Threading לעבודות I/O-intensive
def parallel_download(urls: List[str]) -> List[str]:
    """
    הורדה מקבילית של קבצים
    """
    MAX_WORKERS = 10
    
    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        results = list(executor.map(download_file, urls))
    
    return results

# ✅ נכון - Batch Processing
def batch_insert(conn, items: List[Dict], batch_size: int = 1000):
    """
    הכנסה אצווית למסד נתונים
    """
    cursor = conn.cursor()
    
    for i in range(0, len(items), batch_size):
        batch = items[i:i + batch_size]
        
        # Prepare batch insert
        values = [(item['name'], item['price']) for item in batch]
        
        # Execute batch
        cursor.executemany(
            "INSERT INTO products (name, price) VALUES (%s, %s)",
            values
        )
        
        conn.commit()
        logger.info(f"Inserted batch {i//batch_size + 1}, total: {i + len(batch)}")
```

### Caching:

```python
from functools import lru_cache
import redis

# ✅ נכון - Memory cache לפונקציות
@lru_cache(maxsize=1000)
def get_category_id(category_name: str) -> int:
    """
    Get category ID with caching
    """
    # This will be called only once per unique category_name
    return fetch_from_db(category_name)

# ✅ נכון - Redis cache
redis_client = redis.Redis(host='localhost', port=6379, db=0)

def get_product_cached(product_id: int) -> Dict:
    """
    Get product with Redis caching
    """
    cache_key = f"product:{product_id}"
    
    # Try cache first
    cached = redis_client.get(cache_key)
    if cached:
        return json.loads(cached)
    
    # Fetch from DB
    product = fetch_from_db(product_id)
    
    # Cache for 1 hour
    redis_client.setex(cache_key, 3600, json.dumps(product))
    
    return product
```

---

## 🔒 9. אבטחה (Security)

### SQL Injection Prevention:

```python
# ✅ נכון - Prepared statements
cursor.execute(
    "SELECT * FROM products WHERE name = %s",
    (user_input,)  # Tuple with parameters
)

# ❌ לא נכון - String interpolation
cursor.execute(
    f"SELECT * FROM products WHERE name = '{user_input}'"
)  # SQL INJECTION RISK!

# ✅ נכון - Validation
def validate_product_name(name: str) -> bool:
    """Validate product name"""
    if not name or len(name) > 500:
        return False
    
    # Only alphanumeric and spaces
    if not name.replace(' ', '').isalnum():
        return False
    
    return True

# Use validation
if validate_product_name(user_input):
    cursor.execute("INSERT INTO products (name) VALUES (%s)", (user_input,))
else:
    raise ValueError("Invalid product name")
```

### Password & Secrets:

```python
import os
from dotenv import load_dotenv

# ✅ נכון - Environment variables
load_dotenv()

DB_CONFIG = {
    'password': os.getenv('DB_PASSWORD'),
    'api_key': os.getenv('API_KEY')
}

# ❌ לא נכון - Hard-coded secrets
DB_CONFIG = {
    'password': '9152245-Gl!',  # NEVER DO THIS!
    'api_key': 'sk-1234567890'
}

# ✅ נכון - .env file (NOT in git)
# .env:
# DB_PASSWORD=your_password_here
# API_KEY=your_api_key_here

# .gitignore:
# .env
# *.pyc
# __pycache__/
```

---

## 📚 10. תיעוד (Documentation)

### README Files:

```markdown
# Component Name

## Purpose
What this component does (1-2 sentences)

## Usage
How to use it (with examples)

## Dependencies
What it needs to work

## Examples
Concrete usage examples

## Troubleshooting
Common problems and solutions
```

### Code Comments:

```python
# ✅ נכון - Explain WHY, not WHAT
# Using batch size of 1000 because larger batches cause memory issues
BATCH_SIZE = 1000

# Calculate hash to prevent duplicate processing
file_hash = hashlib.sha256(content).hexdigest()

# ❌ לא נכון - States the obvious
# Set batch size to 1000
BATCH_SIZE = 1000

# Get the hash
file_hash = hashlib.sha256(content).hexdigest()
```

---

## ✅ Checklist לפני Commit

```yaml
לפני כל commit, בדוק:

מיקום קבצים:
  - [ ] קובץ במיקום הנכון?
  - [ ] יש README בתיקייה?
  - [ ] שם קובץ תואם מוסכמה?

קוד:
  - [ ] יש docstrings?
  - [ ] יש type hints?
  - [ ] יש logging?
  - [ ] יש error handling?
  - [ ] שמות משתנים ברורים?

Database:
  - [ ] שאילתות עם prepared statements?
  - [ ] יש אינדקסים?
  - [ ] יש transactions?
  - [ ] JOIN במקום subquery?

ביצועים:
  - [ ] parallel processing כשאפשר?
  - [ ] batch operations?
  - [ ] resource management?

בדיקות:
  - [ ] יש unit tests?
  - [ ] יש integration tests?
  - [ ] הכל עובר?

תיעוד:
  - [ ] README עודכן?
  - [ ] הערות בקוד?
  - [ ] changelog עודכן?

פלטפורמה:
  - [ ] Windows paths?
  - [ ] UTF-8 encoding?
  - [ ] CRLF line endings ל-BAT?

אבטחה:
  - [ ] אין secrets בקוד?
  - [ ] יש validation?
  - [ ] prepared statements?
```

---

## 🚀 שיפור מתמיד

### תהליך שיפור:

```yaml
כל שבוע:
  - סקור קוד שנכתב
  - זהה דפוסים חוזרים
  - עדכן GUIDELINES
  - הוסף לchecklist

כל חודש:
  - בדוק ביצועים
  - סקור לוגים
  - נתח שגיאות
  - שפר תהליכים

כל רבעון:
  - בדוק dependencies
  - עדכן תיעוד
  - סקור ארכיטקטורה
  - תכנן שיפורים
```

---

## 📖 לסיכום

**עקרונות הזהב:**

1. 🎯 **תכנן לפני שכותב** - חשוב על ההשלכות
2. 📝 **תעד תוך כדי** - לא אחרי
3. 🧪 **בדוק מיד** - לא בסוף
4. 🔍 **סקור תמיד** - איכות קודם הכל
5. 📚 **למד מטעויות** - שפר מתמיד

**הקווים המנחים האלה חיים - עדכן אותם!**

---

📅 **Created**: 2025-12-20  
✍️ **Maintained by**: Development Team  
🔄 **Last Updated**: 2025-12-20  

**Version**: 1.0.0

