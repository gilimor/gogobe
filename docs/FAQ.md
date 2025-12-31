# ❓ Gogobe - שאלות ותשובות נפוצות (FAQ)

## תאריך: 21 דצמבר 2025

---

## 🎯 שאלות כלליות

### ❓ מה זה Gogobe?
**תשובה:** פלטפורמת השוואת מחירים גלובלית שמאפשרת להשוות מחירים של אותו מוצר בין מדינות וחנויות שונות. המערכת משתמשת במושג "אב מוצר" (Master Product) כדי לזהות שאותו מוצר מופיע בשמות שונים במדינות שונות.

### ❓ מה ההבדל בין Gogobe למערכות השוואת מחירים אחרות?
**תשובה:** 
- **רוב המערכות:** עובדות רק במדינה אחת, לא יכולות לזהות שאותו מוצר = שמות שונים
- **Gogobe:** 
  - השוואה **גלובלית** בין 4 מדינות
  - מערכת חכמה לזיהוי מוצרים (Barcode + AI + LLM)
  - תמיכה במיליוני מחירים
  - בקרת איכות אוטומטית

### ❓ מה זה "אב מוצר" (Master Product)?
**תשובה:** ישות גלובלית שמאחדת את כל הגרסאות האזוריות של אותו מוצר.

**דוגמה:**
```
Master Product: "tnuva-milk-3pct-1l"
├─ 🇮🇱 "חלב תנובה 3% 1 ליטר"
├─ 🇺🇸 "Tnuva Milk 3% Fat 1L"
└─ 🇪🇺 "Lait Tnuva 3% MG 1L"
```

בלי אב מוצר - לא ניתן להשוות מחירים בין מדינות!

---

## 🏗️ שאלות טכניות - ארכיטקטורה

### ❓ איזה טכנולוגיות משתמשים?
**תשובה:**
- **Backend:** FastAPI (Python 3.9+)
- **Database:** PostgreSQL 13+ עם PostGIS
- **Cache:** Redis
- **Frontend:** HTML5 + Vanilla JavaScript
- **Maps:** Leaflet.js + OpenStreetMap
- **Message Queue:** Kafka (תכנון עתידי)

### ❓ למה Python ולא Go?
**תשובה:**
- **כרגע:** Python (FastAPI) - מהיר לפיתוח, אקוסיסטם עשיר
- **עתיד:** Microservices ב-Go לביצועים גבוהים
- **היברידי:** Python ל-LLM/AI, Go ל-Core Processing

### ❓ איך המערכת מטפלת במיליוני מחירים?
**תשובה:**
1. **Batch Processing** - הכנסת 1000 מחירים בבת אחת (פי 100 יותר מהיר!)
2. **Indexes חכמים** - על product_id, store_id, scraped_at
3. **Cache (Redis)** - 95-99% hit rate
4. **Partitioning** - חלוקת טבלת prices לפי חודשים (תכנון)
5. **upsert_price** - פונקציה שמונעת כפילויות

### ❓ מה זה Get-or-Create Pattern?
**תשובה:** תבנית עיצוב שמונעת כפילויות:

```python
def get_or_create_product(ean):
    # 1. בדוק Cache (מהיר!)
    cached = redis.get(f"product:ean:{ean}")
    if cached:
        return cached
    
    # 2. בדוק DB
    product = db.query("SELECT id FROM products WHERE ean=?", ean)
    if product:
        redis.set(f"product:ean:{ean}", product.id)
        return product.id
    
    # 3. צור חדש
    new_id = db.insert("INSERT INTO products (...)")
    redis.set(f"product:ean:{ean}", new_id)
    return new_id
```

**יתרונות:**
- אפס כפילויות
- ביצועים מעולים (Cache)
- קוד נקי וקריא

---

## 👑 שאלות על אב מוצר (Master Product)

### ❓ למה אב מוצר הוא קריטי?
**תשובה:** 
**ללא אב מוצר:**
- ❌ לא ניתן להשוות בין חנויות
- ❌ לא ניתן להשוות בין מדינות
- ❌ המחיר חסר ערך!

**עם אב מוצר:**
- ✅ השוואה גלובלית
- ✅ מעקב אחר טרנדים
- ✅ המלצות חכמות
- ✅ ערך אמיתי למשתמש!

### ❓ איך המערכת מזהה שאותו מוצר = שמות שונים?
**תשובה:** 3 אסטרטגיות:

**1. Barcode Matching (70%)**
```
אם יש ברקוד זהה → אותו מוצר!
מהיר ומדויק: 10ms
```

**2. AI Embeddings (25%)**
```
יצירת וקטור סמנטי מהשם
חיפוש דמיון: cosine_similarity > 0.90
זמן: 100ms
```

**3. LLM Creation (5%)**
```
GPT-4 מנתח את המוצר
מחלץ attributes: brand, type, size...
יוצר אב מוצר חדש
זמן: 2s
```

### ❓ מה קורה אם הקישור לאב מוצר שגוי?
**תשובה:** יש מנגנון בקרת איכות אוטומטי (Microservice #20):

1. **זיהוי שגיאות:**
   - מוצרים עם ברקוד זהה מקושרים לאבות שונים
   - הבדלי מחיר חריגים (>50%)
   - מוצרים יתומים (ללא אב מוצר)

2. **תיקון אוטומטי:**
   - ניתוק קישורים שגויים
   - קישור מחדש לאב מוצר נכון
   - מיזוג אבות מוצר כפולים

3. **דוחות:**
   - דוח יומי על איכות הקישורים
   - מדדי איכות (95%+ accuracy)

### ❓ מתי מתבצע הקישור לאב מוצר?
**תשובה:** **חובה לפני הכנסת המחיר!**

```
✅ נכון:  Product → Master Product → Price
❌ שגוי:  Product → Price → Master Product (async)
```

**Timeline:**
```
0ms:    XML התקבל
15ms:   Store created
20ms:   Product created
250ms:  👑 Master Product linked
1s:     Price inserted (עם master_product_id!)
```

**כלל ברזל:** אסור להכניס מחיר ללא master_product_id!

---

## 🔄 שאלות על Data Flow

### ❓ איך מחיר מגיע מקובץ XML למערכת?
**תשובה:** תהליך של 7 שלבים:

```
1. Download XML (FTP/HTTP)
   ↓
2. Parse XML → Extract data
   ↓
3. Get/Create Store (Cache → DB)
   ↓
4. Get/Create Product (Cache → DB)
   ↓
5. 👑 Link to Master Product (250ms)
   ↓
6. Batch Insert Prices (1000 at a time)
   ↓
7. Async Enrichment (Geocoding, Currency)
```

**זמן כולל:** 1 שנייה למחיר שימושי!

### ❓ מה זה Batch Processing ולמה זה חשוב?
**תשובה:**

**ללא Batch (איטי):**
```python
for price in prices:  # 100,000 prices
    db.execute("INSERT INTO prices (...) VALUES (...)")
    # זמן: 100,000 × 10ms = 1,000 שניות (16 דקות!)
```

**עם Batch (מהיר):**
```python
queue = []
for price in prices:
    queue.append(price)
    if len(queue) >= 1000:
        db.executemany("INSERT INTO prices (...) VALUES (...)", queue)
        queue = []
# זמן: 100,000 ÷ 1000 × 100ms = 10 שניות!
```

**שיפור:** פי 100 יותר מהיר! 🚀

### ❓ מה זה upsert_price?
**תשובה:** פונקציה חכמה ב-PostgreSQL שמונעת כפילויות:

```sql
-- אם מחיר קיים ושווה (±1%) → עדכן timestamp
-- אם מחיר קיים ושונה → הכנס רשומה חדשה
-- אם מחיר לא קיים → הכנס רשומה חדשה
```

**יתרונות:**
- אפס כפילויות
- היסטוריית מחירים מדויקת
- ביצועים מעולים

---

## 📊 שאלות על ביצועים

### ❓ כמה זמן לוקח לעבד 100,000 מחירים?
**תשובה:** 
- **עם אופטימיזציה:** 60 שניות
- **ללא אופטימיזציה:** 16 דקות

**סוד הביצועים:**
1. Cache (Redis) - 95-99% hit rate
2. Batch Processing - 1000 מחירים בבת אחת
3. Indexes - על כל העמודות החשובות
4. upsert_price - מונע כפילויות

### ❓ מה ה-Cache Hit Rate ולמה זה חשוב?
**תשובה:**

**Cache Hit Rate = אחוז הפעמים שהמידע נמצא ב-Cache**

**דוגמה:**
```
100 בקשות למוצר
├─ 99 נמצאו ב-Cache (1ms כל אחת)
└─ 1 נמצא ב-DB (10ms)

Cache Hit Rate = 99%
זמן ממוצע = (99×1ms + 1×10ms) / 100 = 1.09ms

ללא Cache:
זמן ממוצע = 100×10ms / 100 = 10ms

שיפור: פי 9 יותר מהיר!
```

**ב-Gogobe:**
- Products: 99% hit rate
- Stores: 95% hit rate
- Prices: 80% hit rate

### ❓ איך המערכת מטפלת ב-50GB+ של נתונים?
**תשובה:**

**1. Indexes חכמים:**
```sql
-- מחירים לפי מוצר וזמן
CREATE INDEX idx_prices_product_time 
ON prices(product_id, scraped_at DESC);

-- מחירים לפי אב מוצר
CREATE INDEX idx_prices_master 
ON prices(master_product_id);

-- חיפוש גיאוגרפי
CREATE INDEX idx_stores_geom 
ON stores USING gist(geom);
```

**2. Partitioning (תכנון):**
```sql
-- חלוקה לפי חודשים
CREATE TABLE prices_2025_12 PARTITION OF prices
FOR VALUES FROM ('2025-12-01') TO ('2026-01-01');
```

**3. Materialized Views:**
```sql
-- סיכומים מוכנים מראש
CREATE MATERIALIZED VIEW price_summary AS
SELECT product_id, 
       MIN(price) as min_price,
       AVG(price) as avg_price
FROM prices
GROUP BY product_id;
```

---

## 🗺️ שאלות על Geocoding

### ❓ מה זה Geocoding?
**תשובה:** המרת כתובת טקסט ל-GPS coordinates (lat/long).

**דוגמה:**
```
Input:  "דרך מנחם בגין 132, תל אביב"
Output: lat: 32.0668, lon: 34.7913
```

**למה צריך:**
- מפת סניפים
- "סניפים קרובים אליי"
- ניתוח גיאוגרפי

### ❓ איך Geocoding עובד?
**תשובה:**

```
1. Build query
   "דרך מנחם בגין 132, תל אביב, Israel"
   
2. Check Cache (Redis)
   key = "geo:address_hash"
   ├─ HIT (99.9%) → Return cached coordinates
   └─ MISS → Continue
   
3. Call OSM Nominatim API
   https://nominatim.openstreetmap.org/search?q=...
   
4. Parse response
   {"lat": "32.0668", "lon": "34.7913"}
   
5. Cache for 1 year
   Redis: SET key "32.0668,34.7913" EX 31536000
   
6. Update Database
   UPDATE stores SET latitude=32.0668, longitude=34.7913
```

**Fallback Strategies:**
```
Try 1: Full address
Try 2: Store name + city
Try 3: City only
Try 4: Country center
```

### ❓ למה Geocoding לוקח 5 דקות?
**תשובה:**
- **Rate Limiting:** OSM מאפשר 1 request/second
- **464 סניפים:** 464 seconds ≈ 8 דקות
- **Cache:** רוב הסניפים כבר ב-Cache (99.9% hit rate!)
- **Async:** לא חוסם את הכנסת המחירים

**חשוב:** Geocoding הוא **async** - לא משפיע על זמן הכנסת המחיר!

---

## 💱 שאלות על Currency Conversion

### ❓ למה צריך המרת מטבעות?
**תשובה:** כדי להשוות מחירים בין מדינות!

**דוגמה:**
```
🇮🇱 חלב תנובה: ₪5.90
🇺🇸 Tnuva Milk: $2.99

איזה יותר זול?
→ צריך להמיר ל-USD:
   ₪5.90 × 0.274 = $1.62

תשובה: בישראל יותר זול!
```

### ❓ איך המרת מטבעות עובדת?
**תשובה:**

```
1. Get Exchange Rate (from Cache/API)
   ILS → USD: 0.274
   
2. Convert
   5.90 ILS × 0.274 = 1.62 USD
   
3. Store in global_prices table
   INSERT INTO global_prices (
     master_product_id, region,
     price_local, currency_local,
     price_usd, exchange_rate
   )
```

**Cache Strategy:**
- Exchange rates: 1 hour TTL
- Historical rates: permanent

---

## 🔍 שאלות על Scrapers

### ❓ מה זה Scraper?
**תשובה:** תוכנה שמורידה ומעבדת נתונים מאתרי אינטרנט או קבצים.

**סוגי Scrapers ב-Gogobe:**
1. **Published Prices** - רמי לוי (XML)
2. **Shufersal** - שופרסל (XML.GZ)
3. **KingStore** - Custom scraper
4. **Laib Catalog** - Catalog import

### ❓ איך Published Prices Scraper עובד?
**תשובה:**

```
1. Login לאתר
   ├─ Extract CSRF token
   ├─ Send credentials
   └─ Get session cookie
   
2. Search for files
   ├─ Try direct URL (by date)
   └─ Fallback: API search
   
3. Download files
   ├─ Prices XML
   └─ Stores XML
   
4. Parse XML
   ├─ Extract products
   └─ Extract stores
   
5. Import to DB
   ├─ Get/Create stores
   ├─ Get/Create products
   ├─ Link to master products
   └─ Insert prices
```

**אתגרים:**
- CSRF tokens
- Session management
- Cookie handling
- Fallback strategies

### ❓ למה יש Fallback File Discovery?
**תשובה:** לפעמים הקבצים לא זמינים בשעה המדויקת.

**Fallback Strategy:**
```
1. Try exact time (23:00)
2. Try ±1 hour (22:00, 00:00)
3. Try ±2 hours (21:00, 01:00)
4. Try yesterday
5. Try different store numbers
```

**דוגמה:**
```
Looking for: PriceFull7290027600007-001-202512211800.xml

Try:
├─ 1800 (6 PM)
├─ 1700 (5 PM)
├─ 1900 (7 PM)
├─ 2000 (8 PM)
└─ Store 002, 003...
```

---

## 🐛 שאלות על Debugging

### ❓ איך לבדוק אם המערכת עובדת?
**תשובה:**

**1. Health Check:**
```bash
curl http://localhost:8000/api/health
```

**2. Check Stats:**
```bash
curl http://localhost:8000/api/stats
```

**3. Check Logs:**
```bash
docker-compose logs -f api
```

**4. Check Database:**
```sql
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM prices;
SELECT COUNT(*) FROM stores;
```

### ❓ מה לעשות אם Python לא עובד?
**תשובה:**

**אופציה 1: השתמש ב-Docker (מומלץ!)**
```bash
RUN.bat
# בחר אופציה 1
```

**אופציה 2: תקן את Python**
```bash
# בדוק גרסה
python --version  # צריך 3.9+

# התקן dependencies
pip install -r requirements.txt

# בדוק psycopg2
python -c "import psycopg2"
```

### ❓ מה לעשות אם Port 8000 תפוס?
**תשובה:**

```bash
# עצור את Docker
docker-compose down

# הפעל מחדש
docker-compose up -d

# בדוק status
docker-compose ps
```

### ❓ איך לבדוק שהעברית תקינה?
**תשובה:**

**1. בדוק Encoding:**
```sql
SHOW client_encoding;  -- צריך להיות UTF8
```

**2. בדוק קובץ:**
```python
# כל הקבצים צריכים להיות UTF-8
# בדוק ב-VS Code: תחתית מימין
```

**3. בדוק Browser:**
```html
<!-- צריך להיות בכל HTML -->
<meta charset="UTF-8">
```

---

## 🚀 שאלות על Deployment

### ❓ איך להפעיל את המערכת?
**תשובה:**

**אופציה 1: Docker (מומלץ!)**
```bash
RUN.bat
# בחר אופציה 1
```

**אופציה 2: Python רגיל**
```bash
RUN.bat
# בחר אופציה 2
```

**אופציה 3: ידני**
```bash
# Start PostgreSQL
docker-compose up -d db

# Start API
cd backend/api
python main.py

# Open browser
http://localhost:8000
```

### ❓ איך לעצור את המערכת?
**תשובה:**

```bash
# עצירה
docker-compose stop

# עצירה + מחיקה
docker-compose down

# עצירה + מחיקת volumes
docker-compose down -v
```

### ❓ איך לראות logs?
**תשובה:**

```bash
# כל הlogs
docker-compose logs -f

# רק API
docker-compose logs -f api

# רק DB
docker-compose logs -f db

# 100 שורות אחרונות
docker-compose logs --tail=100 api
```

---

## 📚 שאלות על תיעוד

### ❓ איפה התיעוד?
**תשובה:**

**Markdown Files:**
- `LEARNING_SUMMARY.md` - סיכום מקיף
- `QUICK_REFERENCE.md` - מדריך מהיר
- `VISUAL_DIAGRAMS.md` - תרשימים
- `PROJECT_UNDERSTANDING.md` - הבנת הפרויקט
- `PRICE_INGESTION_FLOW.md` - תרשים זרימה

**HTML Documentation:**
```
file:///c:/Users/shake/Limor%20Shaked%20Dropbox/LIMOR%20SHAKED%20ADVANCED%20COSMETICS%20LTD/Gogobe/backend/docs/index.html
```

### ❓ איזה מסמך לקרוא קודם?
**תשובה:**

**למתחיל:**
1. `QUICK_REFERENCE.md` - מדריך מהיר (5 דקות)
2. `PROJECT_UNDERSTANDING.md` - הבנה כללית (15 דקות)
3. `VISUAL_DIAGRAMS.md` - תרשימים (10 דקות)

**למפתח:**
1. `LEARNING_SUMMARY.md` - סיכום מקיף (30 דקות)
2. `PRICE_INGESTION_FLOW.md` - זרימת נתונים (20 דקות)
3. `backend/api/main.py` - קוד API (60 דקות)
4. `backend/database/schema.sql` - DB schema (30 דקות)

---

## 💡 שאלות מתקדמות

### ❓ איך להוסיף רשת חדשה?
**תשובה:**

**1. צור Scraper:**
```python
class NewChainScraper(BaseSupermarketScraper):
    def scrape(self):
        # Download data
        # Parse data
        # Return products, stores, prices
```

**2. הוסף Chain ל-DB:**
```sql
INSERT INTO store_chains (name, chain_code, country)
VALUES ('New Chain', '1234567890123', 'IL');
```

**3. הרץ Scraper:**
```python
scraper = NewChainScraper()
scraper.scrape()
```

### ❓ איך להוסיף מדינה חדשה?
**תשובה:**

**1. הוסף Region:**
```python
REGIONS = ['IL', 'US', 'EU', 'ASIA', 'NEW_COUNTRY']
```

**2. הוסף Currency:**
```sql
INSERT INTO currencies (code, name, symbol)
VALUES ('XXX', 'New Currency', 'X');
```

**3. הוסף Exchange Rate:**
```sql
INSERT INTO exchange_rates (from_currency, to_currency, rate)
VALUES ('XXX', 'USD', 0.5);
```

**4. עדכן Scrapers:**
```python
# Add region parameter
scraper = NewScraper(region='NEW_COUNTRY')
```

### ❓ איך לשפר ביצועים?
**תשובה:**

**1. הוסף Indexes:**
```sql
CREATE INDEX idx_custom ON table(column);
```

**2. הגדל Cache:**
```python
# Redis config
maxmemory 4gb
maxmemory-policy allkeys-lru
```

**3. Optimize Queries:**
```sql
-- Use EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT ...;

-- Add LIMIT
SELECT ... LIMIT 1000;

-- Use indexes
WHERE indexed_column = value
```

**4. Batch Processing:**
```python
# Process in batches of 1000
for i in range(0, len(items), 1000):
    batch = items[i:i+1000]
    process_batch(batch)
```

---

**🎉 יש עוד שאלות? תוסיף אותן כאן!**

תאריך: 21 דצמבר 2025
גרסה: 1.0
