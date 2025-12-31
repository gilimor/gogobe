# 🇮🇱 מאגר מחירים ישראלי - מדריך התחברות

## 📊 רקע

לפי **תקנות שקיפות מחירים (2014)**, כל רשת שיווק בישראל חייבת לפרסם:
- ✅ מחירי כל המוצרים
- ✅ מבצעים
- ✅ מיקום סניפים
- 🔄 **עדכון יומי!**
- 📁 פורמט: XML

---

## 🎯 כיצד להתחבר?

### אופציה 1: גישה ישירה ל-XML Files (הכי טוב!)

כל רשת מפרסמת קבצי XML בשרת FTP או HTTP פומבי.

#### פורמט הנתונים

**קבצים עיקריים:**
1. **Stores.xml** - רשימת סניפים
2. **Prices.xml** - מחירים עדכניים
3. **Promos.xml** - מבצעים

**דוגמת מבנה XML:**

```xml
<?xml version="1.0" encoding="windows-1255"?>
<Root>
  <ChainId>7290027600007</ChainId>
  <SubChainId>001</SubChainId>
  <StoreId>123</StoreId>
  <BikoretNo>12-345678</BikoretNo>
  <Items>
    <Item>
      <PriceUpdateDate>2024-12-19</PriceUpdateDate>
      <ItemCode>7290000000001</ItemCode>
      <ItemType>0</ItemType>
      <ItemName>חלב 3% 1 ליטר</ItemName>
      <ManufacturerName>תנובה</ManufacturerName>
      <ManufactureCountry>ישראל</ManufactureCountry>
      <UnitOfMeasure>ליטר</UnitOfMeasure>
      <Quantity>1</Quantity>
      <UnitPrice>6.90</UnitPrice>
      <AllowDiscount>1</AllowDiscount>
      <ItemStatus>1</ItemStatus>
    </Item>
  </Items>
</Root>
```

---

### אופציה 2: שימוש בפרויקטי קוד פתוח

ישנם פרויקטים קיימים שכבר עושים את העבודה:

#### 1. **IL-Supermarket-Scraper** (GitHub)

```python
# דוגמה פשוטה
from il_supermarket_scraper import ScraperFactory

# צור scraper לרשת ספציפית
scraper = ScraperFactory.get('shufersal')

# הורד מחירים
stores = scraper.get_stores()
prices = scraper.get_prices(store_id='123')

# שמור למאגר
for item in prices:
    save_to_database(item)
```

#### 2. **Cerberus** (Python Package)

מנתח XML של רשתות ישראליות:

```bash
pip install israeli-supermarket-scarpers
```

```python
from israeli_supermarket_scrapers import MainScraperRunner

# הרץ scraper לכל הרשתות
runner = MainScraperRunner()
runner.run()

# קבל DataFrame
df = runner.get_dataframe()
print(f"נמצאו {len(df)} מוצרים")
```

---

### אופציה 3: API צד שלישי

#### **Pricez API** (מסחרי)

```http
GET https://api.pricez.co.il/v1/products
Authorization: Bearer YOUR_API_KEY

Response:
{
  "products": [
    {
      "barcode": "7290000000001",
      "name": "חלב 3%",
      "prices": [
        {
          "chain": "Shufersal",
          "store_id": "123",
          "price": 6.90,
          "date": "2024-12-19"
        }
      ]
    }
  ]
}
```

---

## 🚀 המלצה למערכת Gogobe

### אסטרטגיה מומלצת:

```
1️⃣  התחל עם קוד פתוח
    ↓ השתמש ב-israeli-supermarket-scrapers
    ↓ הורד נתונים מ-2-3 רשתות

2️⃣  בנה Pipeline אוטומטי
    ↓ Scrape יומי (cron/scheduler)
    ↓ Parse XML → JSON
    ↓ Load to PostgreSQL

3️⃣  הרחב בהדרגה
    ↓ הוסף עוד רשתות
    ↓ בנה Vertical: "supermarket"
    ↓ השוואת מחירים היסטורית
```

---

## 💻 דוגמת קוד מלאה

```python
"""
Gogobe Israeli Supermarket Price Scraper
"""

from israeli_supermarket_scrapers import MainScraperRunner
import psycopg2
from datetime import datetime

DB_CONFIG = {
    'host': 'localhost',
    'database': 'gogobe',
    'user': 'postgres',
    'password': '9152245-Gl!'
}

def scrape_and_save():
    """Scrape Israeli supermarkets and save to Gogobe DB"""
    
    # 1. Create vertical for supermarkets
    conn = psycopg2.connect(**DB_CONFIG)
    cursor = conn.cursor()
    
    cursor.execute("""
        INSERT INTO verticals (name, slug, description)
        VALUES ('Supermarkets', 'supermarket', 'Israeli supermarket prices')
        ON CONFLICT (slug) DO NOTHING
        RETURNING id
    """)
    vertical_id = cursor.fetchone()[0]
    
    # 2. Run scraper
    print("Starting scraper...")
    runner = MainScraperRunner()
    runner.run()
    
    # 3. Get data
    df = runner.get_dataframe()
    print(f"Found {len(df)} products")
    
    # 4. Save to database
    for _, row in df.iterrows():
        # Create or get category
        cursor.execute("""
            INSERT INTO categories (vertical_id, name, slug)
            VALUES (%s, %s, %s)
            ON CONFLICT (slug) DO NOTHING
            RETURNING id
        """, (vertical_id, row['category'], row['category'].lower()))
        
        category_id = cursor.fetchone()[0]
        
        # Create or get supplier (chain + store)
        cursor.execute("""
            INSERT INTO suppliers (name, slug, country_code)
            VALUES (%s, %s, 'IL')
            ON CONFLICT (slug) DO NOTHING
            RETURNING id
        """, (row['chain_name'], row['chain_id']))
        
        supplier_id = cursor.fetchone()[0]
        
        # Create product
        cursor.execute("""
            INSERT INTO products (name, vertical_id, category_id, attributes)
            VALUES (%s, %s, %s, %s)
            ON CONFLICT DO NOTHING
            RETURNING id
        """, (
            row['item_name'],
            vertical_id,
            category_id,
            {
                'barcode': row['item_code'],
                'manufacturer': row['manufacturer_name'],
                'unit': row['unit_of_measure'],
                'quantity': row['quantity']
            }
        ))
        
        result = cursor.fetchone()
        if result:
            product_id = result[0]
            
            # Add price
            cursor.execute("""
                INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
                VALUES (%s, %s, %s, 'ILS', NOW())
            """, (product_id, supplier_id, row['unit_price']))
    
    conn.commit()
    cursor.close()
    conn.close()
    
    print(f"✅ Saved {len(df)} products to Gogobe database!")


if __name__ == "__main__":
    scrape_and_save()
```

---

## 📦 התקנה

```bash
# Install scraper
pip install israeli-supermarket-scrapers

# Run scraper
python backend/scripts/scrape_israeli_supermarkets.py
```

---

## ⚙️ אוטומציה יומית

### Windows Task Scheduler

```batch
@echo off
REM Run daily at 6 AM
cd /d "C:\...\Gogobe"
"C:\Users\shake\AppData\Local\Programs\Python\Python311\python.exe" backend\scripts\scrape_israeli_supermarkets.py
```

### Linux Cron

```bash
# Add to crontab -e
0 6 * * * cd /path/to/gogobe && python3 backend/scripts/scrape_israeli_supermarkets.py
```

---

## 📊 רשתות נתמכות

| רשת | Chain ID | עדכונים | איכות נתונים |
|-----|----------|----------|---------------|
| שופרסל | 7290027600007 | ✅ יומי | ⭐⭐⭐⭐⭐ |
| רמי לוי | 7290058140886 | ✅ יומי | ⭐⭐⭐⭐ |
| ויקטורי | 7290696200003 | ✅ יומי | ⭐⭐⭐⭐ |
| יינות ביתן | 7290633800006 | ✅ יומי | ⭐⭐⭐ |
| מגה | 7290055755557 | ✅ יומי | ⭐⭐⭐ |
| חצי חינם | 7290700100008 | ⚠️ חלקי | ⭐⭐ |
| טיב טעם | 7290873255550 | ✅ יומי | ⭐⭐⭐⭐ |
| מחסני השוק | 7290661400001 | ✅ יומי | ⭐⭐⭐ |

---

## 🔮 עתיד: מאגר ממשלתי

**הרשות להגנת הצרכן + Amazon** בנו מאגר מרכזי:
- 🎯 כל הרשתות במקום אחד
- ⚡ API מהיר
- 📊 Analytics מובנים
- ❌ **לא נגיש עדיין לציבור**

**מתי יהיה זמין?** לא ידוע.

**מה לעשות בינתיים?**
1. השתמש בפרויקטי קוד פתוח
2. בנה Pipeline משלך
3. המתן למאגר הממשלתי

---

## 💡 יתרונות להוסיף Supermarket Vertical

### 1. **נפח עצום של נתונים**
- 🏪 מאות אלפי מוצרים
- 📅 עדכונים יומיים
- 🇮🇱 כיסוי ארצי מלא

### 2. **תחרות גבוהה**
- מחירים משתנים כל הזמן
- מבצעים שבועיים
- השוואות בין רשתות

### 3. **User Engagement**
- כולם קונים בסופר!
- רלוונטי לציבור רחב
- פוטנציאל למיליוני משתמשים

### 4. **מונטיזציה**
- Affiliate links לרשתות
- Premium features
- B2B API למחקרים

---

## 🚀 Action Items

### שלב 1: POC (Proof of Concept)
```bash
# התקן
pip install israeli-supermarket-scrapers

# הרץ test
python -c "from israeli_supermarket_scrapers import MainScraperRunner; r = MainScraperRunner(); r.run(); print(r.get_dataframe().head())"
```

### שלב 2: Integration
- [ ] צור vertical חדש: "supermarket"
- [ ] צור categories: "Dairy", "Bread", "Meat", etc.
- [ ] צור suppliers: "Shufersal-Tel-Aviv", etc.
- [ ] הרץ scraper ראשון

### שלב 3: Automation
- [ ] Schedule יומי
- [ ] Email alerts על טעויות
- [ ] Dashboard לניטור

### שלב 4: Features
- [ ] Price history graphs
- [ ] Lowest price alerts
- [ ] Basket comparison tool
- [ ] Mobile app

---

## 📚 קישורים שימושיים

### קוד פתוח:
- **GitHub:** https://github.com/topics/israeli-supermarkets
- **PyPI:** https://pypi.org/search/?q=israeli+supermarket

### מידע רשמי:
- **רשות הגנת הצרכן:** https://www.gov.il/he/departments/consumer_protection_and_fair_trade
- **תקנות שקיפות מחירים:** חפש "תקנות הגנת הצרכן (פרסום מחירים למוצרים ולשירותים)"
- **הלמ"ס:** https://www.cbs.gov.il

### כלים קיימים:
- **Zol:** אפליקציית השוואת מחירים
- **MyCoSa:** מחשבון סל קניות
- **Prices.co.il:** אתר השוואת מחירים

---

## ✅ סיכום

**יש מאגר מחירים ישראלי מעולה!**

**הדרך המומלצת:**
1. ✅ השתמש ב-`israeli-supermarket-scrapers`
2. ✅ הורד נתונים יומית
3. ✅ שמור ב-Gogobe DB
4. ✅ בנה features מגניבים!

**זה יהיה vertical אדיר לפרויקט Gogobe!** 🚀









