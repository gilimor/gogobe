# 🏠 התקנה מקומית - Setup על המחשב שלך

**מדריך התקנה מלא לפיתוח מקומי על Windows**

---

## 🎯 מטרה

להקים על המחשב שלך:
- ✅ PostgreSQL + TimescaleDB
- ✅ Python + FastAPI
- ✅ כלי פיתוח
- ✅ בסיס נתונים ראשון
- ✅ API פועל

**זמן: 2-3 שעות**

---

## 📦 חלק 1: התקנת כלים בסיסיים

### 1. Python 3.11+

```powershell
# בדוק אם Python מותקן
python --version

# אם לא מותקן, הורד מכאן:
# https://www.python.org/downloads/
# סמן "Add Python to PATH" בהתקנה!
```

### 2. PostgreSQL 15

```powershell
# הורד PostgreSQL 15 מכאן:
# https://www.postgresql.org/download/windows/

# הרץ את ההתקנה
# שמור את הסיסמה ש-you תגדיר ל-postgres user!

# אחרי ההתקנה, בדוק:
psql --version
```

### 3. Git

```powershell
# בדוק אם Git מותקן
git --version

# אם לא, הורד מכאן:
# https://git-scm.com/download/win
```

### 4. VS Code (עורך קוד)

```powershell
# הורד מכאן:
# https://code.visualstudio.com/

# Extensions מומלצים:
# - Python
# - PostgreSQL
# - REST Client
```

---

## 🗄️ חלק 2: הקמת בסיס נתונים

### יצירת Database

```powershell
# פתח PowerShell והתחבר ל-PostgreSQL
psql -U postgres

# בתוך psql:
CREATE DATABASE pricetracker;
\c pricetracker

# יצירת extension ל-TimescaleDB (אם מותקן)
CREATE EXTENSION IF NOT EXISTS timescaledb;

# יצירת extension לחיפוש טקסט
CREATE EXTENSION IF NOT EXISTS pg_trgm;

# יצירת extension ל-UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

# בדיקה
\dx

# יציאה
\q
```

### יצירת טבלאות ראשונות

צור קובץ: `database/schema_v1.sql`

```sql
-- טבלת מוצרים
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    
    -- מזהים חיצוניים
    asin VARCHAR(10),  -- Amazon ID
    ean VARCHAR(13),
    
    -- תמונות
    image_url VARCHAR(500),
    
    -- מטה-דאטה
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- אינדקסים
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_products_asin ON products(asin) WHERE asin IS NOT NULL;

-- טבלת ספקים
CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    website VARCHAR(500),
    country_code CHAR(2) DEFAULT 'US',
    
    created_at TIMESTAMP DEFAULT NOW()
);

-- טבלת מחירים (פשוטה לעכשיו)
CREATE TABLE prices (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    supplier_id INTEGER REFERENCES suppliers(id),
    
    price DECIMAL(12,2) NOT NULL,
    currency CHAR(3) DEFAULT 'USD',
    
    is_available BOOLEAN DEFAULT TRUE,
    
    scraped_at TIMESTAMP DEFAULT NOW()
);

-- אינדקסים
CREATE INDEX idx_prices_product ON prices(product_id, scraped_at DESC);
CREATE INDEX idx_prices_supplier ON prices(supplier_id);

-- נתוני טסט
INSERT INTO suppliers (name, website, country_code) VALUES
    ('Amazon US', 'https://amazon.com', 'US'),
    ('eBay', 'https://ebay.com', 'US'),
    ('Walmart', 'https://walmart.com', 'US');

-- מוצר לדוגמה
INSERT INTO products (name, description, asin, image_url) VALUES
    ('iPhone 15 Pro 256GB', 'Latest iPhone model', 'B0CHX1W1XY', 'https://example.com/iphone.jpg');

-- מחיר לדוגמה
INSERT INTO prices (product_id, supplier_id, price, currency) 
VALUES (1, 1, 999.99, 'USD');
```

הרץ:

```powershell
psql -U postgres -d pricetracker -f database/schema_v1.sql
```

---

## 🐍 חלק 3: פרויקט Python + FastAPI

### יצירת פרויקט

```powershell
# צור תיקייה לפרויקט
mkdir pricetracker-backend
cd pricetracker-backend

# צור virtual environment
python -m venv venv

# הפעל את ה-venv
.\venv\Scripts\Activate

# התקן חבילות
pip install fastapi uvicorn psycopg2-binary python-dotenv pydantic
```

### מבנה הפרויקט

```
pricetracker-backend/
├── venv/                  # Virtual environment
├── .env                   # הגדרות סביבה
├── main.py               # קובץ ראשי
├── database.py           # חיבור ל-DB
├── models.py             # מודלים
├── requirements.txt      # רשימת חבילות
└── README.md
```

### קובץ `.env`

```env
DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/pricetracker
```

**⚠️ החלף YOUR_PASSWORD בסיסמה שלך!**

### קובץ `database.py`

```python
import os
import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

def get_db_connection():
    """יוצר חיבור לבסיס הנתונים"""
    conn = psycopg2.connect(DATABASE_URL, cursor_factory=RealDictCursor)
    return conn

def test_connection():
    """בודק חיבור לבסיס נתונים"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT version();")
        version = cursor.fetchone()
        print(f"✅ Connected to PostgreSQL!")
        print(f"Version: {version['version']}")
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        print(f"❌ Connection failed: {e}")
        return False

if __name__ == "__main__":
    test_connection()
```

בדיקה:

```powershell
python database.py
```

### קובץ `models.py`

```python
from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from decimal import Decimal

class Product(BaseModel):
    id: Optional[int] = None
    name: str
    description: Optional[str] = None
    asin: Optional[str] = None
    ean: Optional[str] = None
    image_url: Optional[str] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

class Supplier(BaseModel):
    id: Optional[int] = None
    name: str
    website: Optional[str] = None
    country_code: str = "US"
    created_at: Optional[datetime] = None

class Price(BaseModel):
    id: Optional[int] = None
    product_id: int
    supplier_id: int
    price: Decimal
    currency: str = "USD"
    is_available: bool = True
    scraped_at: Optional[datetime] = None

class ProductWithPrice(BaseModel):
    """מוצר + המחיר האחרון שלו"""
    id: int
    name: str
    description: Optional[str]
    image_url: Optional[str]
    latest_price: Optional[Decimal]
    supplier_name: Optional[str]
```

### קובץ `main.py`

```python
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from typing import List
import database
from models import Product, ProductWithPrice

app = FastAPI(
    title="Price Tracker API",
    description="API למעקב אחרי מחירים",
    version="0.1.0"
)

# CORS (לאפשר גישה מהדפדפן)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    """בדיקה שה-API עובד"""
    return {
        "message": "Price Tracker API is running! 🚀",
        "version": "0.1.0",
        "docs": "/docs"
    }

@app.get("/health")
def health_check():
    """בדיקת בריאות המערכת"""
    db_ok = database.test_connection()
    return {
        "status": "healthy" if db_ok else "unhealthy",
        "database": "connected" if db_ok else "disconnected"
    }

@app.get("/api/v1/products", response_model=List[ProductWithPrice])
def get_products(limit: int = 10):
    """מחזיר רשימת מוצרים עם המחיר האחרון"""
    conn = database.get_db_connection()
    cursor = conn.cursor()
    
    query = """
        SELECT 
            p.id,
            p.name,
            p.description,
            p.image_url,
            pr.price as latest_price,
            s.name as supplier_name
        FROM products p
        LEFT JOIN LATERAL (
            SELECT price, supplier_id
            FROM prices
            WHERE product_id = p.id
            ORDER BY scraped_at DESC
            LIMIT 1
        ) pr ON TRUE
        LEFT JOIN suppliers s ON pr.supplier_id = s.id
        ORDER BY p.id
        LIMIT %s
    """
    
    cursor.execute(query, (limit,))
    products = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return products

@app.get("/api/v1/products/{product_id}")
def get_product(product_id: int):
    """מחזיר מוצר בודד לפי ID"""
    conn = database.get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute("SELECT * FROM products WHERE id = %s", (product_id,))
    product = cursor.fetchone()
    
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    
    # מחירים אחרונים
    cursor.execute("""
        SELECT pr.*, s.name as supplier_name
        FROM prices pr
        JOIN suppliers s ON pr.supplier_id = s.id
        WHERE pr.product_id = %s
        ORDER BY pr.scraped_at DESC
        LIMIT 10
    """, (product_id,))
    
    prices = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return {
        "product": product,
        "recent_prices": prices
    }

@app.post("/api/v1/products")
def create_product(product: Product):
    """יוצר מוצר חדש"""
    conn = database.get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute("""
        INSERT INTO products (name, description, asin, ean, image_url)
        VALUES (%s, %s, %s, %s, %s)
        RETURNING id
    """, (product.name, product.description, product.asin, product.ean, product.image_url))
    
    new_id = cursor.fetchone()['id']
    
    conn.commit()
    cursor.close()
    conn.close()
    
    return {"id": new_id, "message": "Product created successfully"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
```

### קובץ `requirements.txt`

```txt
fastapi==0.104.1
uvicorn[standard]==0.24.0
psycopg2-binary==2.9.9
python-dotenv==1.0.0
pydantic==2.5.0
```

---

## 🚀 חלק 4: הפעלה והרצה!

### הרץ את השרת

```powershell
# ודא שה-venv פעיל
.\venv\Scripts\Activate

# הרץ את השרת
python main.py
```

או:

```powershell
uvicorn main:app --reload --host 127.0.0.1 --port 8000
```

### בדוק שזה עובד!

פתח דפדפן וגש ל:

```
http://127.0.0.1:8000
```

תראה:
```json
{
  "message": "Price Tracker API is running! 🚀",
  "version": "0.1.0",
  "docs": "/docs"
}
```

### תיעוד אוטומטי (Swagger)

```
http://127.0.0.1:8000/docs
```

תראה ממשק אינטראקטיבי לבדיקת כל ה-API!

---

## ✅ בדיקות

### 1. בדוק בריאות

```powershell
curl http://127.0.0.1:8000/health
```

### 2. קבל רשימת מוצרים

```powershell
curl http://127.0.0.1:8000/api/v1/products
```

### 3. קבל מוצר בודד

```powershell
curl http://127.0.0.1:8000/api/v1/products/1
```

### 4. צור מוצר חדש

```powershell
curl -X POST http://127.0.0.1:8000/api/v1/products `
  -H "Content-Type: application/json" `
  -d '{
    "name": "Samsung Galaxy S24",
    "description": "Latest Samsung flagship",
    "image_url": "https://example.com/galaxy.jpg"
  }'
```

---

## 🎉 סיימת!

יש לך עכשיו:
- ✅ PostgreSQL עובד מקומית
- ✅ FastAPI server רץ
- ✅ בסיס נתונים עם טבלאות
- ✅ API endpoints עובדים
- ✅ נתוני טסט

---

## 📚 הצעד הבא

עבור ל: `02-FIRST-SCRAPER.md`

נבנה scraper ראשון שיאסוף מוצרים אמיתיים!

---

**נוצר:** 18 בדצמבר 2025  
**סטטוס:** ✅ Ready to use  
**זמן:** 2-3 שעות






