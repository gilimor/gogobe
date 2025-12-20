# 🦷 Dental Price Tracker - התחלה חכמה בנישה

**מערכת מעקב מחירים מיוחדת לציוד דנטלי**

---

## 🎯 למה דנטלי?

```yaml
✅ נישה ספציפית:
  - פחות תחרות (אין CamelCamelCamel לדנטל!)
  - קהל ממוקד ומקצועי
  - מחירים גבוהים = רווחיות
  - מוצרים מוגדרים היטב

📊 השוק:
  - $9.5B/שנה גלובלי
  - 5.4% צמיחה שנתית
  - רופאי שיניים מחפשים מחירים!
  
🎁 היתרון שלך:
  - יש לך כבר טקסונומיה מלאה!
  - יש לך 13 מוצרים לדוגמה!
  - אתה מכיר את התחום!
```

---

## 📋 הקטגוריות שלך (מהמסמכים)

```yaml
1. Cleaning & Prevention:
   - Scalers (מפרקים)
   - Curettes (כפיות)
   - Prophy Angles

2. Diagnostic:
   - Mirrors
   - Explorers
   - Probes

3. Restorative:
   - Composite Instruments
   - Amalgam Carriers
   - Matrix Systems

4. Endodontics:
   - Files
   - Reamers
   - Obturation Tools

5. Surgery:
   - Forceps (מלקחיים)
   - Elevators
   - Scalpels

6. Orthodontics:
   - Brackets
   - Wires
   - Pliers

... ועוד!
```

---

## 🗄️ בסיס הנתונים המותאם

### טבלאות ספציפיות לדנטל

צור: `database/dental_schema.sql`

```sql
-- קטגוריות דנטליות
CREATE TABLE dental_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    parent_id INTEGER REFERENCES dental_categories(id),
    
    -- היררכיה: Surgical > Forceps > Extraction Forceps
    path VARCHAR(500),
    
    created_at TIMESTAMP DEFAULT NOW()
);

-- מותגים דנטליים מובילים
CREATE TABLE dental_brands (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    country VARCHAR(50),
    is_premium BOOLEAN DEFAULT FALSE,
    
    -- SklarLite, Hu-Friedy, etc.
    specialty VARCHAR(100),
    
    created_at TIMESTAMP DEFAULT NOW()
);

-- מוצרים דנטליים
CREATE TABLE dental_products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    category_id INTEGER REFERENCES dental_categories(id),
    brand_id INTEGER REFERENCES dental_brands(id),
    
    -- פרטים ספציפיים
    model_number VARCHAR(100),
    material VARCHAR(100), -- Stainless Steel, Tungsten Carbide, etc.
    is_autoclavable BOOLEAN DEFAULT TRUE,
    is_reusable BOOLEAN DEFAULT TRUE,
    
    -- מפרטים
    length_mm INTEGER,
    tip_type VARCHAR(100),
    handle_type VARCHAR(100),
    
    -- תיאור
    description TEXT,
    specifications JSONB,
    
    -- תמונות
    image_url VARCHAR(500),
    
    -- קבצי PDF (קטלוגים)
    catalog_pdf_url VARCHAR(500),
    
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ספקים דנטליים
CREATE TABLE dental_suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    website VARCHAR(500),
    country_code CHAR(2),
    
    -- סוגי ספקים
    supplier_type VARCHAR(50), -- 'manufacturer', 'distributor', 'retailer'
    
    -- התמחות
    specializes_in TEXT[],
    
    -- יצרן/מפיץ
    is_manufacturer BOOLEAN DEFAULT FALSE,
    is_authorized_dealer BOOLEAN DEFAULT FALSE,
    
    -- משלוח
    ships_internationally BOOLEAN DEFAULT FALSE,
    minimum_order DECIMAL(10,2),
    
    created_at TIMESTAMP DEFAULT NOW()
);

-- מחירים (TimescaleDB אחר כך)
CREATE TABLE dental_prices (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES dental_products(id),
    supplier_id INTEGER REFERENCES dental_suppliers(id),
    
    price DECIMAL(12,2) NOT NULL,
    currency CHAR(3) DEFAULT 'USD',
    
    -- מידע נוסף
    quantity INTEGER DEFAULT 1, -- כמה ביחידה
    is_bulk BOOLEAN DEFAULT FALSE,
    bulk_discount_percentage INTEGER,
    
    -- זמינות
    is_available BOOLEAN DEFAULT TRUE,
    stock_level VARCHAR(50), -- 'in_stock', 'low_stock', 'backorder'
    lead_time_days INTEGER,
    
    -- מבצעים
    is_on_sale BOOLEAN DEFAULT FALSE,
    original_price DECIMAL(12,2),
    sale_ends_at TIMESTAMP,
    
    -- מקור
    source_url VARCHAR(1000),
    scraped_at TIMESTAMP DEFAULT NOW()
);

-- אינדקסים
CREATE INDEX idx_dental_products_category ON dental_products(category_id);
CREATE INDEX idx_dental_products_brand ON dental_products(brand_id);
CREATE INDEX idx_dental_products_material ON dental_products(material);
CREATE INDEX idx_dental_prices_product ON dental_prices(product_id, scraped_at DESC);
CREATE INDEX idx_dental_prices_supplier ON dental_prices(supplier_id);

-- נתוני seed מהקבצים שלך
INSERT INTO dental_categories (name, path) VALUES
    ('Cleaning & Prevention', 'cleaning'),
    ('Diagnostic', 'diagnostic'),
    ('Restorative', 'restorative'),
    ('Endodontics', 'endodontics'),
    ('Surgery', 'surgery'),
    ('Orthodontics', 'orthodontics'),
    ('Prosthodontics', 'prosthodontics'),
    ('Periodontics', 'periodontics');

INSERT INTO dental_brands (name, country, is_premium) VALUES
    ('Hu-Friedy', 'USA', TRUE),
    ('Dentsply Sirona', 'USA', TRUE),
    ('KaVo Kerr', 'Germany', TRUE),
    ('NSK', 'Japan', TRUE),
    ('Sklar', 'USA', FALSE),
    ('Integra Miltex', 'USA', FALSE);

-- דוגמה ממסמך dentistry_prices_june2024.csv
INSERT INTO dental_products (name, category_id, description, model_number)
VALUES 
    ('Optima E+ Portable X-Ray Unit', 
     (SELECT id FROM dental_categories WHERE name = 'Diagnostic'),
     'Portable dental X-ray with 60kV, battery operated',
     'OPTIMA-E+');

INSERT INTO dental_suppliers (name, website, country_code, supplier_type)
VALUES 
    ('B.A. International', 'https://www.bainternational.com', 'GB', 'manufacturer'),
    ('Henry Schein', 'https://www.henryschein.com', 'US', 'distributor'),
    ('Patterson Dental', 'https://www.pattersondental.com', 'US', 'distributor'),
    ('Dental Directory', 'https://www.dentaldirectory.co.uk', 'GB', 'retailer');

-- מחיר לדוגמה (מהמסמך שלך - £995)
INSERT INTO dental_prices (product_id, supplier_id, price, currency, source_url)
VALUES 
    (1, 1, 995.00, 'GBP', 'https://example.com/product');
```

---

## 🕷️ Scrapers לאתרים דנטליים

### Scraper 1: Henry Schein

צור: `scrapers/henry_schein_scraper.py`

```python
import requests
from bs4 import BeautifulSoup
import time
import random
import psycopg2
from urllib.parse import urljoin

class HenryScheinScraper:
    """Scraper לאתר Henry Schein (ספק דנטלי מוביל)"""
    
    def __init__(self, db_conn):
        self.base_url = "https://www.henryschein.com"
        self.db_conn = db_conn
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (compatible; DentalPriceBot/1.0; +https://yoursite.com/bot)',
            'Accept': 'text/html,application/xhtml+xml',
            'Accept-Language': 'en-US,en;q=0.9',
        }
        
        # ספק Henry Schein ב-DB
        self.supplier_id = self._get_or_create_supplier()
    
    def _get_or_create_supplier(self):
        """מוצא או יוצר את הספק ב-DB"""
        cursor = self.db_conn.cursor()
        
        cursor.execute("""
            SELECT id FROM dental_suppliers 
            WHERE name = 'Henry Schein'
        """)
        
        result = cursor.fetchone()
        
        if result:
            return result[0]
        else:
            cursor.execute("""
                INSERT INTO dental_suppliers 
                (name, website, country_code, supplier_type)
                VALUES ('Henry Schein', %s, 'US', 'distributor')
                RETURNING id
            """, (self.base_url,))
            
            supplier_id = cursor.fetchone()[0]
            self.db_conn.commit()
            return supplier_id
        
        cursor.close()
    
    def scrape_product(self, product_url):
        """סורק מוצר בודד"""
        try:
            response = requests.get(product_url, headers=self.headers, timeout=10)
            
            if response.status_code != 200:
                print(f"❌ Failed: {response.status_code}")
                return None
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # שם המוצר
            title_elem = soup.select_one('h1.product-title')
            title = title_elem.text.strip() if title_elem else None
            
            # מק"ט/דגם
            sku_elem = soup.select_one('.product-sku')
            sku = sku_elem.text.strip() if sku_elem else None
            
            # מחיר
            price_elem = soup.select_one('.product-price .price-value')
            if price_elem:
                price_text = price_elem.text.strip()
                price = float(price_text.replace('$', '').replace(',', ''))
            else:
                price = None
            
            # תמונה
            image_elem = soup.select_one('.product-image img')
            image_url = image_elem['src'] if image_elem else None
            if image_url and not image_url.startswith('http'):
                image_url = urljoin(self.base_url, image_url)
            
            # תיאור
            desc_elem = soup.select_one('.product-description')
            description = desc_elem.text.strip() if desc_elem else None
            
            # זמינות
            stock_elem = soup.select_one('.stock-status')
            is_available = 'in stock' in stock_elem.text.lower() if stock_elem else True
            
            print(f"✅ Found: {title[:50]}... - ${price}")
            
            return {
                'name': title,
                'model_number': sku,
                'description': description,
                'image_url': image_url,
                'price': price,
                'is_available': is_available,
                'source_url': product_url
            }
            
        except Exception as e:
            print(f"❌ Error scraping {product_url}: {e}")
            return None
    
    def save_product(self, product_data):
        """שומר מוצר ומחיר ב-DB"""
        cursor = self.db_conn.cursor()
        
        try:
            # בדוק אם המוצר קיים (לפי דגם)
            cursor.execute("""
                SELECT id FROM dental_products 
                WHERE model_number = %s
            """, (product_data['model_number'],))
            
            existing = cursor.fetchone()
            
            if existing:
                product_id = existing[0]
                print(f"   Product exists, ID: {product_id}")
            else:
                # צור מוצר חדש
                cursor.execute("""
                    INSERT INTO dental_products 
                    (name, model_number, description, image_url)
                    VALUES (%s, %s, %s, %s)
                    RETURNING id
                """, (
                    product_data['name'],
                    product_data['model_number'],
                    product_data['description'],
                    product_data['image_url']
                ))
                
                product_id = cursor.fetchone()[0]
                print(f"   Created product, ID: {product_id}")
            
            # שמור מחיר (תמיד)
            if product_data['price']:
                cursor.execute("""
                    INSERT INTO dental_prices 
                    (product_id, supplier_id, price, currency, is_available, source_url)
                    VALUES (%s, %s, %s, 'USD', %s, %s)
                """, (
                    product_id,
                    self.supplier_id,
                    product_data['price'],
                    product_data['is_available'],
                    product_data['source_url']
                ))
                
                print(f"   Saved price: ${product_data['price']}")
            
            self.db_conn.commit()
            
        except Exception as e:
            print(f"   ❌ Error saving to DB: {e}")
            self.db_conn.rollback()
        
        finally:
            cursor.close()
    
    def scrape_category(self, category_url, max_products=10):
        """סורק קטגוריה שלמה"""
        print(f"\n🔍 Scraping category: {category_url}\n")
        
        try:
            response = requests.get(category_url, headers=self.headers, timeout=10)
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # מצא לינקים למוצרים
            product_links = soup.select('.product-item a.product-link')
            
            print(f"Found {len(product_links)} products")
            
            for i, link in enumerate(product_links[:max_products], 1):
                product_url = link['href']
                if not product_url.startswith('http'):
                    product_url = urljoin(self.base_url, product_url)
                
                print(f"\n[{i}/{min(max_products, len(product_links))}] {product_url}")
                
                product_data = self.scrape_product(product_url)
                
                if product_data:
                    self.save_product(product_data)
                
                # המתן בין requests
                if i < max_products:
                    delay = random.uniform(3, 5)
                    print(f"   Waiting {delay:.1f}s...")
                    time.sleep(delay)
            
            print(f"\n✅ Done scraping category!")
            
        except Exception as e:
            print(f"❌ Error scraping category: {e}")


# שימוש
if __name__ == "__main__":
    # חיבור ל-DB
    conn = psycopg2.connect(
        dbname="pricetracker",
        user="postgres",
        password="YOUR_PASSWORD",
        host="localhost"
    )
    
    scraper = HenryScheinScraper(conn)
    
    # סרוק קטגוריה (דוגמה)
    # שנה את ה-URL לקטגוריה אמיתית
    scraper.scrape_category(
        "https://www.henryschein.com/us-en/dental/c/surgical-instruments",
        max_products=10
    )
    
    conn.close()
    
    print("\n✅ All done! Check your database:")
    print("SELECT * FROM dental_products;")
    print("SELECT * FROM dental_prices;")
```

---

## 🌐 אתרים דנטליים לסריקה

### אתרים מובילים

```yaml
ארה"ב:
  ✅ Henry Schein: henryschein.com
  ✅ Patterson Dental: pattersondental.com
  ✅ Benco Dental: benco.com
  ✅ Darby Dental: darbydental.com
  ✅ Net32: net32.com

בריטניה:
  ✅ Dental Directory: dentaldirectory.co.uk
  ✅ Optident: optident.co.uk
  ✅ Blackwell Supplies: blackwellsupplies.co.uk

גרמניה:
  ✅ Pluradent: pluradent.de
  ✅ Henry Schein DE: henryschein.de

ישראל:
  ✅ דנטל-פארם: dental-pharm.co.il
  ✅ דניור: denior.co.il
  ✅ אקרום-דנטל: acrum-dental.co.il
```

---

## 📊 טעינת הנתונים הקיימים שלך

### קובץ: `scripts/load_existing_data.py`

```python
import pandas as pd
import psycopg2
from datetime import datetime

# קרא את ה-CSV שיש לך
df = pd.read_csv('../Doc/dentistry_prices_june2024.csv')

# חיבור ל-DB
conn = psycopg2.connect(
    dbname="pricetracker",
    user="postgres",
    password="YOUR_PASSWORD",
    host="localhost"
)

cursor = conn.cursor()

for _, row in df.iterrows():
    # צור מוצר
    cursor.execute("""
        INSERT INTO dental_products (name, description)
        VALUES (%s, %s)
        ON CONFLICT DO NOTHING
        RETURNING id
    """, (row['Product_Name'], row['Description']))
    
    result = cursor.fetchone()
    if result:
        product_id = result[0]
        
        # מצא/צור ספק
        cursor.execute("""
            INSERT INTO dental_suppliers (name, website)
            VALUES (%s, %s)
            ON CONFLICT DO NOTHING
            RETURNING id
        """, (row['Supplier'], row['Contact_Website']))
        
        supplier_result = cursor.fetchone()
        if supplier_result:
            supplier_id = supplier_result[0]
            
            # הוסף מחיר
            cursor.execute("""
                INSERT INTO dental_prices 
                (product_id, supplier_id, price, currency)
                VALUES (%s, %s, %s, 'GBP')
            """, (product_id, supplier_id, float(row['Price_GBP'])))
            
            print(f"✅ Added: {row['Product_Name']} - £{row['Price_GBP']}")

conn.commit()
conn.close()

print("\n✅ Done loading your existing data!")
```

---

## 🎯 תוכנית שלב-אחר-שלב לדנטל

### שבוע 1: בסיס

```yaml
יום 1-2:
  ✅ Setup PostgreSQL
  ✅ צור dental schema
  ✅ טען 13 מוצרים קיימים שלך

יום 3-4:
  ✅ Scraper ראשון (Henry Schein)
  ✅ 20 מוצרים נוספים

יום 5-7:
  ✅ UI פשוט
  ✅ רואים 30+ מוצרים
  ✅ חיפוש לפי קטגוריה
```

### שבוע 2-3: הרחבה

```yaml
✅ 3-4 scrapers נוספים
✅ 200-500 מוצרים
✅ קטגוריות מלאות
✅ השוואת מחירים
```

### שבוע 4-8: רציני

```yaml
✅ 1,000-5,000 מוצרים
✅ כל הקטגוריות
✅ התראות מחיר
✅ היסטוריית מחירים
```

---

## 💡 תכונות ייחודיות לדנטל

### מה לבנות שרק רופאי שיניים צריכים

```yaml
1. השוואת מחירים לפי כמות:
   - מחיר ליחידה
   - מחיר ל-10 יחידות
   - מחיר ל-100 יחידות

2. סינון לפי מפרטים:
   - חומר (Stainless Steel, Tungsten Carbide)
   - אורך
   - סוג קצה
   - ניתן לעיקור

3. מחירי משלוח:
   - למרפאה
   - בינלאומי

4. זמינות:
   - במלאי
   - זמן אספקה
   - חלופות

5. אישורי תקן:
   - FDA approved
   - CE marked
   - ISO certified
```

---

## 🎯 מודל עסקי מותאם

### מי ישלם?

```yaml
רופאי שיניים:
  - Premium: $19.99/חודש
  - התראות על מוצרים שהם קונים
  - חיסכון: $1000+/שנה (ROI מעולה!)

קליניקות:
  - Business: $49.99/חודש
  - ניהול מלאי
  - התראות לכמויות
  - דוחות

מעבדות דנטליות:
  - Enterprise: $199/חודש
  - API access
  - Bulk pricing
  - ניתוח מגמות
```

---

## 📈 פוטנציאל השוק

```yaml
ארה"ב בלבד:
  - 200,000 רופאי שיניים
  - 1% conversion = 2,000 משתמשים
  - $19.99/חודש × 2,000 = $40K/חודש
  - = $480K/שנה!

גלובלי:
  - 1.5M רופאי שיניים
  - 0.5% conversion = 7,500 משתמשים
  - = $150K/חודש
  - = $1.8M/שנה!

זה רק מנויים!
+ B2B partnerships
+ Affiliate commissions
```

---

## ✅ Checklist להתחלה בדנטל

```yaml
⬜ קרא את DENTAL-START.md (הקובץ הזה)
⬜ צור dental_schema.sql
⬜ הרץ את הסכמה ב-PostgreSQL
⬜ טען את 13 המוצרים שלך
⬜ צור scraper ראשון
⬜ אסוף 20 מוצרים נוספים
⬜ בנה UI פשוט
⬜ רואים את כל המוצרים

→ יש לך MVP לדנטל! 🦷
```

---

## 🚀 הצעד הבא

```bash
1. צור את בסיס הנתונים:
   psql -U postgres -d pricetracker -f database/dental_schema.sql

2. טען את המוצרים שלך:
   python scripts/load_existing_data.py

3. התחל לסרוק:
   python scrapers/henry_schein_scraper.py

4. בנה UI פשוט

5. פרסם ל-10 רופאי שיניים שאתה מכיר!
```

---

**יש לך נישה מנצחת! בואו נתחיל! 🦷💪✨**






