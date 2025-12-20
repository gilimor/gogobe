# 🛒 אינטגרציה עם מאגר מחירי סופרמרקטים ישראלי

## 🎯 המטרה

להוסיף Vertical חדש למערכת Gogobe:
- **"Supermarkets"** - מחירי מוצרי מזון ופארם בישראל
- עדכונים יומיים מכל הרשתות הגדולות
- מאות אלפי מוצרים
- היסטוריה מלאה של שינויי מחירים

---

## 📊 הרקע החוקי

### תקנות הגנת הצרכן (פרסום מחירים)

**חובת כל רשת שיווק בישראל:**

```yaml
✅ פרסום יומי של:
  - כל מחירי המוצרים
  - מבצעים והנחות
  - מיקום וזמני פתיחה של סניפים
  
📁 פורמט:
  - XML (מבנה מוגדר ע"י משרד הכלכלה)
  - קובץ stores (סניפים)
  - קובץ prices (מחירים)
  - קובץ promos (מבצעים)
  
🔄 תדירות:
  - עדכון תוך 72 שעות מכל שינוי מחיר
  - בפועל: עדכון יומי (לילה)
  
🌐 זמינות:
  - FTP או HTTP פומבי
  - ללא צורך באישור או רישום
```

**קישור רשמי:** https://www.gov.il/he/pages/cpfta_prices_regulations

---

## 🚀 3 דרכים להתחבר

### 🥇 דרך 1: שימוש בשירות מוכן (מומלץ!)

#### **PricezBI** - השירות המקצועי

```yaml
אתר: https://pricezbi.pricez.co.il

יתרונות:
  ✅ API מוכן ומתועד
  ✅ כל הרשתות במקום אחד
  ✅ נתונים נקיים ומסודרים
  ✅ תמיכה טכנית
  ✅ SLA ויציבות

חסרונות:
  💰 מסחרי (עלות לא ידועה)
  📞 צריך ליצור קשר למכירות

התאמה ל-Gogobe:
  🎯 מושלם לייצור (Production)
  🎯 אידיאלי אם רוצים מהירות
  🎯 מתאים לפרויקט רציני
```

**איך להתחיל:**
1. צור קשר: info@pricez.co.il
2. בקש גישה ל-API
3. שאל על מחירים (ייתכן שיש תקופת ניסיון)

---

### 🥈 דרך 2: Python Package (קוד פתוח!)

#### חבילת `israeli-supermarket-scrapers`

```bash
# התקנה
pip install israeli-supermarket-scarpers
```

```python
# שימוש בסיסי
from il_supermarket_scraper import ScraperFactory

# בחר רשת
scraper = ScraperFactory.get_scraper('shufersal')

# הורד מחירים
stores = scraper.get_stores()
prices = scraper.get_prices(store_id='001')

# עיבוד נתונים
for item in prices:
    print(f"{item['name']}: {item['price']} ₪")
```

**יתרונות:**
- ✅ חינמי לחלוטין
- ✅ קוד פתוח (אפשר להתאים)
- ✅ תמיכה ברוב הרשתות
- ✅ קהילה פעילה

**חסרונות:**
- ⚠️ צריך לתחזק (רשתות משנות מבנה)
- ⚠️ עלול להישבר
- ⚠️ אין SLA

**רשתות נתמכות:**
- Shufersal (שופרסל)
- Rami Levy (רמי לוי)
- Victory (ויקטורי)
- Yeinot Bitan (יינות ביתן)
- Mega (מגה)
- Tiv Taam (טיב טעם)
- + עוד

---

### 🥉 דרך 3: גישה ישירה ל-XML (DIY)

#### קרא קבצים ישירות מהרשתות

כל רשת מפרסמת ב-URL ציבורי:

```python
# דוגמה: שופרסל
import requests
import xml.etree.ElementTree as ET

# הורד קובץ מחירים
url = "http://prices.shufersal.co.il/FileObject/UpdatePrice?storeId=362&fileType=2"
response = requests.get(url)

# Parse XML
root = ET.fromstring(response.content)

# חלץ מוצרים
for item in root.findall('.//Item'):
    name = item.find('ItemName').text
    price = item.find('ItemPrice').text
    barcode = item.find('ItemCode').text
    
    print(f"{name}: {price} ₪ (ברקוד: {barcode})")
```

**URLs לדוגמה:**

```yaml
Shufersal:
  stores: http://prices.shufersal.co.il/FileObject/UpdatePrice?storeId=0&fileType=1
  prices: http://prices.shufersal.co.il/FileObject/UpdatePrice?storeId={id}&fileType=2
  promos: http://prices.shufersal.co.il/FileObject/UpdatePrice?storeId={id}&fileType=3

Rami Levy:
  base: http://publishprice.rami-levy.co.il/
  
Victory:
  base: http://matrixcatalog.co.il/NBCompetitionRegulations/
```

**יתרונות:**
- ✅ חינמי 100%
- ✅ שליטה מלאה
- ✅ לא תלוי בצד ג'

**חסרונות:**
- ❌ צריך לבנות parser לכל רשת
- ❌ צריך לטפל בשינויים
- ❌ הרבה עבודת פיתוח

---

## 🎯 המלצה למערכת Gogobe

### שלב 1: POC (1-2 שבועות)

```
🎯 מטרה: להוכיח שזה עובד

1️⃣ השתמש ב-PricezBI (בקש גישת ניסיון)
   או
   השתמש ב-israeli-supermarket-scrapers

2️⃣ צור Vertical חדש: "Supermarkets"

3️⃣ הורד מחירים מ-2-3 רשתות

4️⃣ טען ל-PostgreSQL

5️⃣ הצג באתר

תוצאה: 
  ✅ אפשר לראות מחירי סופר באתר Gogobe
  ✅ השוואת מחירים בין רשתות
  ✅ גרף היסטוריה
```

---

### שלב 2: MVP (1 חודש)

```
🎯 מטרה: מערכת עובדת למשתמשים אמיתיים

1️⃣ כל הרשתות הגדולות (8-10)

2️⃣ עדכון אוטומטי יומי (cron)

3️⃣ Features:
   - חיפוש מוצר
   - השוואת מחירים
   - מעקב אחר מוצר (alerts)
   - "סל קניות" - איפה הכי זול?

4️⃣ Mobile responsive

תוצאה:
  ✅ אפליקציה שימושית
  ✅ ערך אמיתי למשתמשים
  ✅ קהל יעד גדול (כל הישראלים)
```

---

### שלב 3: Scale (3-6 חודשים)

```
🎯 מטרה: להפוך למקור המידע המוביל

1️⃣ כל הרשתות (כולל קטנות)

2️⃣ ניתוח מתקדם:
   - זיהוי מגמות מחירים
   - חיזוי מבצעים
   - המלצות חכמות

3️⃣ Monetization:
   - Premium features
   - B2B API
   - Affiliate

4️⃣ Marketing

תוצאה:
  🚀 פלטפורמה מובילה
  💰 הכנסות
  📊 Big Data value
```

---

## 💻 קוד לדוגמה - Integration מלא

```python
"""
Gogobe Israeli Supermarket Integration
"""

import requests
from datetime import datetime
import psycopg2
from xml.etree import ElementTree as ET

class SupermarketIntegrator:
    """Integrate Israeli supermarket prices into Gogobe"""
    
    def __init__(self, db_config):
        self.db_config = db_config
        self.conn = None
        
    def connect_db(self):
        """Connect to Gogobe database"""
        self.conn = psycopg2.connect(**self.db_config)
        
    def create_supermarket_vertical(self):
        """Create or get Supermarket vertical"""
        cursor = self.conn.cursor()
        
        cursor.execute("""
            INSERT INTO verticals (name, slug, description, icon)
            VALUES ('Supermarkets', 'supermarket', 
                    'Israeli supermarket prices - daily updates', '🛒')
            ON CONFLICT (slug) 
            DO UPDATE SET description = EXCLUDED.description
            RETURNING id
        """)
        
        vertical_id = cursor.fetchone()[0]
        self.conn.commit()
        cursor.close()
        
        return vertical_id
    
    def scrape_shufersal(self, vertical_id):
        """Example: Scrape Shufersal prices"""
        
        print("Downloading Shufersal prices...")
        
        # Get stores
        stores_url = "http://prices.shufersal.co.il/FileObject/UpdatePrice?storeId=0&fileType=1"
        stores_response = requests.get(stores_url, timeout=30)
        
        if stores_response.status_code != 200:
            print(f"Failed to download stores: {stores_response.status_code}")
            return
        
        # Parse stores XML
        stores_root = ET.fromstring(stores_response.content)
        
        cursor = self.conn.cursor()
        
        # Process each store
        for store in stores_root.findall('.//Store')[:3]:  # Limit to 3 for testing
            store_id = store.find('StoreId').text
            store_name = store.find('StoreName').text
            
            print(f"\nProcessing store: {store_name} (ID: {store_id})")
            
            # Create supplier for this store
            cursor.execute("""
                INSERT INTO suppliers (name, slug, country_code, attributes)
                VALUES (%s, %s, 'IL', %s)
                ON CONFLICT (slug) DO NOTHING
                RETURNING id
            """, (
                f"Shufersal - {store_name}",
                f"shufersal-{store_id}",
                {'store_id': store_id, 'chain': 'Shufersal'}
            ))
            
            result = cursor.fetchone()
            if result:
                supplier_id = result[0]
            else:
                cursor.execute(
                    "SELECT id FROM suppliers WHERE slug = %s",
                    (f"shufersal-{store_id}",)
                )
                supplier_id = cursor.fetchone()[0]
            
            # Get prices for this store
            prices_url = f"http://prices.shufersal.co.il/FileObject/UpdatePrice?storeId={store_id}&fileType=2"
            
            try:
                prices_response = requests.get(prices_url, timeout=30)
                
                if prices_response.status_code == 200:
                    prices_root = ET.fromstring(prices_response.content)
                    
                    # Process items
                    items = prices_root.findall('.//Item')[:50]  # Limit for testing
                    
                    for item in items:
                        item_name = item.find('ItemName').text
                        item_price = float(item.find('ItemPrice').text)
                        item_code = item.find('ItemCode').text
                        manufacturer = item.find('ManufacturerName')
                        manufacturer_name = manufacturer.text if manufacturer is not None else 'Unknown'
                        
                        # Create product
                        cursor.execute("""
                            INSERT INTO products (name, vertical_id, attributes)
                            VALUES (%s, %s, %s)
                            ON CONFLICT (name, vertical_id) DO NOTHING
                            RETURNING id
                        """, (
                            item_name,
                            vertical_id,
                            {
                                'barcode': item_code,
                                'manufacturer': manufacturer_name
                            }
                        ))
                        
                        result = cursor.fetchone()
                        if result:
                            product_id = result[0]
                            
                            # Add price
                            cursor.execute("""
                                INSERT INTO prices 
                                (product_id, supplier_id, price, currency, scraped_at)
                                VALUES (%s, %s, %s, 'ILS', NOW())
                            """, (product_id, supplier_id, item_price))
                    
                    print(f"  ✅ Added {len(items)} products")
                    
            except Exception as e:
                print(f"  ❌ Error processing store {store_id}: {e}")
                continue
        
        self.conn.commit()
        cursor.close()
        
        print("\n✅ Shufersal scraping complete!")
    
    def run(self):
        """Main integration flow"""
        print("="*60)
        print("Gogobe Supermarket Integration")
        print("="*60)
        
        # Connect to DB
        self.connect_db()
        
        # Create vertical
        vertical_id = self.create_supermarket_vertical()
        print(f"✅ Supermarket vertical ready (ID: {vertical_id})")
        
        # Scrape data
        self.scrape_shufersal(vertical_id)
        
        # Close connection
        self.conn.close()
        
        print("\n" + "="*60)
        print("Integration complete!")
        print("="*60)


if __name__ == "__main__":
    DB_CONFIG = {
        'host': 'localhost',
        'port': 5432,
        'database': 'gogobe',
        'user': 'postgres',
        'password': '9152245-Gl!'
    }
    
    integrator = SupermarketIntegrator(DB_CONFIG)
    integrator.run()
```

---

## 📊 מבנה המאגר המומלץ

```sql
-- Vertical: Supermarkets
INSERT INTO verticals (name, slug, icon) 
VALUES ('Supermarkets', 'supermarket', '🛒');

-- Categories (דוגמאות)
INSERT INTO categories (vertical_id, name, slug) VALUES
  (supermarket_id, 'Dairy', 'dairy'),
  (supermarket_id, 'Meat & Fish', 'meat-fish'),
  (supermarket_id, 'Fruits & Vegetables', 'fruits-vegetables'),
  (supermarket_id, 'Bakery', 'bakery'),
  (supermarket_id, 'Beverages', 'beverages'),
  (supermarket_id, 'Personal Care', 'personal-care'),
  (supermarket_id, 'Household', 'household');

-- Suppliers = Chains + Stores
-- דוגמה: "Shufersal - Ramat Aviv", "Rami Levy - Jerusalem"

-- Products
-- attributes = {barcode, manufacturer, unit, quantity}

-- Prices
-- regular prices table with scraped_at timestamp
```

---

## ⚙️ אוטומציה - Cron Daily

```batch
REM run_supermarket_scraper.bat
@echo off
cd /d "C:\...\Gogobe"

set PYTHON=C:\Users\shake\AppData\Local\Programs\Python\Python311\python.exe

echo Starting daily supermarket price update...
%PYTHON% backend\scripts\supermarket_integrator.py

if errorlevel 1 (
    echo Failed! Sending alert...
    REM TODO: Send email/SMS alert
) else (
    echo Success! Database updated.
)
```

**Windows Task Scheduler:**
- זמן: 02:00 AM (בלילה, אחרי שהרשתות מעדכנות)
- תדירות: יומי
- פעולה: הרץ `run_supermarket_scraper.bat`

---

## 💡 Features מומלצים

### 1. **Price History Graph**
```javascript
// Show price changes over time
const priceHistory = await fetch(`/api/products/${id}/price-history`);
// Display with Recharts
```

### 2. **Lowest Price Alert**
```sql
-- Identify lowest price across all stores
SELECT 
    p.name,
    s.name as store,
    pr.price,
    RANK() OVER (PARTITION BY p.id ORDER BY pr.price) as rank
FROM products p
JOIN prices pr ON p.id = pr.product_id
JOIN suppliers s ON pr.supplier_id = s.id
WHERE rank = 1;
```

### 3. **Shopping Basket Comparison**
```
User creates basket:
  - Milk 3% (1L)
  - Bread
  - Eggs (12)
  
System calculates total at each chain:
  - Shufersal: 45.80 ₪
  - Rami Levy: 42.50 ₪ ✅ CHEAPEST
  - Victory: 47.20 ₪
```

### 4. **Price Drop Notifications**
```
User follows "Nutella 750g"

System detects:
  - Was: 22.90 ₪
  - Now: 18.90 ₪ (-17%)
  
→ Send email/push notification
```

---

## 📈 פוטנציאל עסקי

### Target Audience
- 🇮🇱 **כל הישראלים** (9M אנשים)
- 👨‍👩‍👧‍👦 משפחות המחפשות לחסוך
- 💼 עסקים קטנים
- 📊 חוקרים ואנליסטים

### Monetization
```
1️⃣ Freemium
   - חינם: חיפוש בסיסי
   - Premium: alerts, analytics, basket comparison
   
2️⃣ B2B API
   - מכירת גישה למידע לעסקים
   - $100-500/חודש לכל לקוח
   
3️⃣ Affiliate
   - קישורים לקניה אונליין
   - עמלה על כל הזמנה
   
4️⃣ Data Licensing
   - מכירת datasets למחקר
   - $1000+ לחוקרים/אוניברסיטאות
```

### תחרות
- **Zol** - אפליקציה פופולרית
- **Prices.co.il** - אתר ותיק
- **CHP** - השוואת מחירים

**היתרון שלנו:**
- ✅ Multi-vertical (לא רק סופרים!)
- ✅ היסטוריה ארוכה
- ✅ AI-powered insights
- ✅ Global platform (לא רק ישראל)

---

## ✅ Action Plan

### השבוע הקרוב:
- [ ] בדוק את PricezBI (בקש גישה)
- [ ] התקן `pip install israeli-supermarket-scrapers`
- [ ] הרץ POC - הורד מחירים מרשת אחת
- [ ] טען למאגר Gogobe
- [ ] הצג באתר

### השבועיים הבאים:
- [ ] הוסף 3-5 רשתות נוספות
- [ ] בנה UI מיוחד ל-Supermarket vertical
- [ ] הוסף השוואת מחירים
- [ ] Schedule עדכון יומי

### החודש הבא:
- [ ] כל הרשתות הגדולות
- [ ] Price alerts
- [ ] Basket comparison
- [ ] Mobile app (PWA)

---

## 📚 משאבים

### תיעוד רשמי:
- **תקנות:** https://www.gov.il/he/pages/cpfta_prices_regulations
- **משרד הכלכלה:** https://www.gov.il/he/departments/economy

### שירותים קיימים:
- **PricezBI:** https://pricezbi.pricez.co.il
- **CHP:** https://chp.co.il
- **Zol:** https://www.zol.co.il

### קוד פתוח:
- חפש ב-GitHub: "israeli supermarket scraper"
- PyPI: "israeli-supermarket"

---

## 🎉 סיכום

✅ **יש מאגר מחירים ישראלי מעולה!**

✅ **3 דרכים להתחבר:**
1. PricezBI (API מסחרי מוכן)
2. Python packages (קוד פתוח חינמי)
3. גישה ישירה ל-XML (DIY)

✅ **זה יכול להיות Vertical מדהים למערכת Gogobe!**

**המלצה:** התחל עם Python package, עבור ל-PricezBI אם זה עובד טוב.

**אני מוכן לעזור בכל שלב!** 🚀





