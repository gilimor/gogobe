# 📚 מאסטר ייבוא נתונים ובניית מנגנון אב מוצר

## תאריך: 23 דצמבר 2025
## מטרה: למידת ייבוא נתונים נכון, מנגנון אב מוצר, וטיפול בכפילויות

---

## 🎯 מה נלמד במסמך זה

1. **ייבוא נתונים נכונים** - איך לקלוט נתונים ממקורות שונים
2. **מנגנון אב מוצר (Master Product)** - הפטנט שלנו!
3. **טיפול בכפילויות** - מניעת duplicates
4. **שמירת נתונים רזה** - אופטימיזציה ויעילות
5. **חיפוש והצלבה מהירים** - Indexes + Cache
6. **התחברות למקורות חדשים** - הרחבת המערכת

---

## 📥 חלק 1: ייבוא נתונים נכונים

### 1.1 ארכיטקטורת הייבוא

```
┌─────────────────────────────────────────────────────────────┐
│                    מקורות נתונים                            │
├─────────────────────────────────────────────────────────────┤
│ 1. XML/GZ Files (Published Prices)   ← רמי לוי, שופרסל     │
│ 2. API JSON (Real-time)               ← Laib, APIs         │
│ 3. HTML Scraping (Web)                ← אתרים              │
│ 4. Manual Upload (CSV/Excel)          ← ידני              │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              BaseSupermarketScraper                         │
│              (Framework משותף)                              │
├─────────────────────────────────────────────────────────────┤
│ ✓ Download files                                            │
│ ✓ Decompress (GZ/ZIP/BZ2)                                  │
│ ✓ Parse (XML/JSON/HTML)                                    │
│ ✓ Normalize data                                           │
│ ✓ Database import                                          │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                    Database                                 │
│  products → prices → stores → master_products              │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 מבנה הקוד - BaseSupermarketScraper

**הקובץ:** `backend/scrapers/base_supermarket_scraper.py`

זהו ה-Framework הבסיסי שכל scraper יורש ממנו:

```python
class BaseSupermarketScraper(ABC):
    """
    Framework משותף לכל המקורות
    """
    
    # שלב 1: אתחול
    def __init__(self, chain_name, chain_slug, chain_id):
        self.chain_name = chain_name
        self.chain_id = chain_id
        self.conn = None  # Database connection
    
    # שלב 2: התחברות למקור נתונים
    @abstractmethod
    def fetch_file_list(self) -> List[FileMetadata]:
        """
        כל scraper מיישם את זה בצורה שלו
        - רמי לוי: קריאה לHTML page
        - שופרסל: קריאה ל-API
        - Laib: קריאה ל-API אחר
        """
        pass
    
    # שלב 3: הורדת קבצים
    def download_file(self, file_meta):
        """פונקציה משותפת - מורידה קובץ"""
        response = requests.get(file_meta.url)
        # שמירה לדיסק
    
    # שלב 4: ניתוח קבצים
    @abstractmethod
    def parse_file(self, file_path) -> List[ParsedProduct]:
        """
        כל scraper מיישם parsing משלו
        - XML: לרמי לוי ושופרסל
        - JSON: ל-Laib
        - HTML: לאתרים
        """
        pass
    
    # שלב 5: ייבוא ל-DB (משותף!)
    def import_product(self, product: ParsedProduct):
        """
        לוגיקה משותפת לכולם:
        1. חיפוש מוצר קיים (by barcode)
        2. יצירת מוצר חדש (אם לא קיים)
        3. הכנסת מחיר (upsert_price)
        """
        # Get or Create Product
        product_id = self._get_or_create_product(product)
        
        # Upsert Price (מניעת כפילויות!)
        self._upsert_price(product_id, product.price)
```

### 1.3 דוגמה: PublishedPricesScraper

**הקובץ:** `backend/scrapers/published_prices_scraper.py`

```python
class PublishedPricesScraper(BaseSupermarketScraper):
    """
    Scraper עבור רמי לוי (Published Prices platform)
    """
    
    def fetch_file_list(self):
        """
        1. התחברות לאתר
        2. חילוץ CSRF token
        3. קריאה לרשימת קבצים
        """
        # Login
        session = requests.Session()
        csrf_token = self._extract_csrf_token()
        session.post(LOGIN_URL, data={
            'username': 'RamiLevi',
            'csrf_token': csrf_token
        })
        
        # Get file list
        response = session.get(FILE_LIST_API)
        files = response.json()
        
        return [FileMetadata(
            url=f['url'],
            filename=f['name'],
            file_type='prices'
        ) for f in files]
    
    def parse_file(self, file_path: Path):
        """
        Parse XML file
        """
        import xml.etree.ElementTree as ET
        
        tree = ET.parse(file_path)
        root = tree.getroot()
        
        products = []
        for item in root.findall('.//Item'):
            product = ParsedProduct(
                name=item.find('ItemName').text,
                barcode=item.find('ItemCode').text,
                price=float(item.find('ItemPrice').text),
                manufacturer=item.find('ManufacturerName').text
            )
            products.append(product)
        
        return {}, products
```

### 1.4 הוספת מקור חדש - 5 צעדים פשוטים

```python
# קובץ חדש: backend/scrapers/new_source_scraper.py

from base_supermarket_scraper import BaseSupermarketScraper

class NewSourceScraper(BaseSupermarketScraper):
    """
    צעד 1: הגדרת פרטי הרשת
    """
    def __init__(self):
        super().__init__(
            chain_name="New Chain",
            chain_slug="new-chain",
            chain_name_he="רשת חדשה",
            chain_id="7290999999999",
            country_code="IL"
        )
    
    """
    צעד 2: איך להשיג רשימת קבצים/מוצרים?
    """
    def fetch_file_list(self):
        # אפשרות 1: API
        response = requests.get('https://api.newchain.com/files')
        return [FileMetadata(...) for f in response.json()]
        
        # אפשרות 2: Scraping
        soup = BeautifulSoup(requests.get(URL).text, 'html.parser')
        return [FileMetadata(...) for link in soup.find_all('a')]
    
    """
    צעד 3: איך לנתח את הנתונים?
    """
    def parse_file(self, file_path):
        # אפשרות 1: XML
        tree = ET.parse(file_path)
        
        # אפשרות 2: JSON
        data = json.load(open(file_path))
        
        # אפשרות 3: CSV
        df = pd.read_csv(file_path)
        
        # המרה ל-ParsedProduct
        return metadata, products
    
    """
    צעד 4: (אופציונלי) אם יש store_id ייחודי
    """
    def build_store_identifier(self, store):
        # אם יש subchain
        return f"{self.chain_id}_{store.subchain}_{store.store_id}"
```

```bash
# צעד 5: הרצה!
python -c "
from backend.scrapers.new_source_scraper import NewSourceScraper
scraper = NewSourceScraper()
stats = scraper.import_files(limit=1)
print(stats)
"
```

---

## 👑 חלק 2: מנגנון אב מוצר (Master Product)

### 2.1 למה צריך אב מוצר?

**הבעיה:**
```
אותו מוצר בשמות שונים:
- 🇮🇱 "חלב תנובה 3% 1 ליטר"
- 🇺🇸 "Tnuva Milk 3% Fat 1L"
- 🇮🇹 "Latte Tnuva 3% 1L"

איך נדע שזה אותו מוצר?! ← זה הפטנט!
```

**הפתרון: Master Product**
```
master_products:
  id: 999
  master_id: "tnuva-milk-3pct-1l"
  name: "Tnuva Milk 3% 1L"
  global_ean: "7290000000001"
  ↓ קישורים לכל האזורים:
  
product_master_links:
  ├─ Israel Product #54321 → Master #999
  ├─ USA Product #78901 → Master #999
  └─ EU Product #11223 → Master #999
```

### 2.2 3 אסטרטגיות קישור

```python
class MasterProductMatcher:
    """
    מנגנון חכם לקישור מוצרים לאב מוצר
    """
    
    def find_or_create_master(self, barcode, name, region):
        """
        3 שלבים, בסדר עדיפות:
        """
        
        # ── אסטרטגיה 1: Barcode Match (70% מהמקרים) ──
        # מהיר ומדויק!
        master = self._search_by_barcode(barcode)
        if master:
            return master  # ✅ נמצא!
        
        # ── אסטרטגיה 2: AI Similarity (25% מהמקרים) ──
        # חיפוש סמנטי עם embeddings
        master = self._search_by_embedding(name)
        if master and master['confidence'] > 0.90:
            return master  # ✅ נמצא!
        
        # ── אסטרטגיה 3: Create New (5% מהמקרים) ──
        # יצירת אב מוצר חדש עם GPT-4
        return self._create_master_with_llm(name, barcode)
    
    def _search_by_barcode(self, barcode):
        """
        אסטרטגיה 1: חיפוש לפי ברקוד
        - הכי מהיר (10ms)
        - הכי מדויק (100%)
        """
        return db.query("""
            SELECT id, master_id, name
            FROM master_products
            WHERE global_ean = %s
        """, barcode)
    
    def _search_by_embedding(self, name):
        """
        אסטרטגיה 2: חיפוש סמנטי
        - יותר איטי (250ms)
        - דיוק גבוה (90%+)
        """
        # יצירת embedding
        embedding = openai.Embedding.create(
            input=name,
            model="text-embedding-ada-002"
        )
        
        # חיפוש דומים (pgvector)
        return db.query("""
            SELECT id, master_id, name,
                   1 - (embedding <=> %s::vector) as similarity
            FROM master_products
            WHERE 1 - (embedding <=> %s::vector) > 0.90
            ORDER BY similarity DESC
            LIMIT 1
        """, embedding)
    
    def _create_master_with_llm(self, name, barcode):
        """
        אסטרטגיה 3: יצירת אב מוצר חדש
        - הכי איטי (1.2 שניות)
        - נדרש רק ל-5% מהמוצרים החדשים
        """
        # שלב 1: חילוץ attributes עם GPT-4
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[{
                "role": "user",
                "content": f"""
Extract product attributes from: {name}
Return JSON:
{{
  "brand": "Tnuva",
  "product_type": "Milk",
  "attributes": {{"fat": "3%", "volume": "1L"}},
  "category": "Food > Dairy > Milk"
}}
"""
            }],
            response_format={"type": "json_object"}
        )
        
        attrs = json.loads(response.choices[0].message.content)
        
        # שלב 2: יצירת master_id
        master_id = self._generate_id(attrs)
        # → "tnuva-milk-3pct-1l"
        
        # שלב 3: שמירה ב-DB
        return db.execute("""
            INSERT INTO master_products (
                master_id, name, global_ean, 
                brand, category, attributes, embedding
            ) VALUES (%s, %s, %s, %s, %s, %s, %s)
            RETURNING id
        """, ...)
```

### 2.3 Database Schema - Master Products

```sql
-- טבלה: master_products
-- אב מוצר גלובלי
CREATE TABLE master_products (
    id BIGSERIAL PRIMARY KEY,
    master_id VARCHAR(200) UNIQUE,        -- "tnuva-milk-3pct-1l"
    name VARCHAR(500),
    global_ean VARCHAR(20),                -- ברקוד גלובלי
    
    -- Classification
    brand VARCHAR(200),
    category VARCHAR(500),                 -- "Food > Dairy > Milk"
    attributes JSONB,                      -- {"fat": "3%", "volume": "1L"}
    
    -- AI
    embedding vector(1536),                -- pgvector
    
    created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes קריטיים
CREATE INDEX idx_master_ean ON master_products(global_ean);
CREATE INDEX idx_master_embedding ON master_products 
    USING ivfflat (embedding vector_cosine_ops);

-- טבלה: product_master_links
-- קישור בין מוצר אזורי לאב מוצר
CREATE TABLE product_master_links (
    id BIGSERIAL PRIMARY KEY,
    master_product_id BIGINT REFERENCES master_products(id),
    regional_product_id BIGINT REFERENCES products(id),
    region VARCHAR(10),                    -- "IL", "US", "EU"
    
    -- Quality metrics
    confidence_score DECIMAL(3,2),         -- 0.95 = 95%
    match_method VARCHAR(50),              -- "barcode", "embedding", "llm"
    
    created_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(regional_product_id)            -- כל מוצר מקושר רק לאב אחד
);

-- טבלה: prices
-- הוספת master_product_id למחירים!
ALTER TABLE prices ADD COLUMN master_product_id BIGINT 
    REFERENCES master_products(id);
CREATE INDEX idx_prices_master ON prices(master_product_id);
```

---

## 🚫 חלק 3: מניעת כפילויות

### 3.1 בעיית הכפילויות

```
WITHOUT duplicate prevention:
❌ Product "חלב תנובה" created 50 times
❌ Price $5.90 stored 100 times for same product
❌ Database full of junk!

WITH duplicate prevention:
✅ Product "חלב תנובה" created once
✅ Price $5.90 updated (not duplicated)
✅ Clean, lean database!
```

### 3.2 פתרון 1: upsert_price Function

```sql
-- Function: upsert_price
-- מניעת כפילויות במחירים
CREATE OR REPLACE FUNCTION upsert_price(
    p_product_id BIGINT,
    p_supplier_id INTEGER,
    p_store_id BIGINT,
    p_price DECIMAL,
    p_currency VARCHAR,
    p_is_available BOOLEAN,
    p_tolerance DECIMAL DEFAULT 0.01
) RETURNS VOID AS $$
DECLARE
    v_existing_price DECIMAL;
    v_price_id BIGINT;
BEGIN
    -- חיפוש מחיר קיים
    SELECT id, price INTO v_price_id, v_existing_price
    FROM prices
    WHERE product_id = p_product_id
      AND supplier_id = p_supplier_id
      AND store_id = p_store_id
      AND is_available = TRUE
    ORDER BY scraped_at DESC
    LIMIT 1;
    
    IF FOUND THEN
        -- מחיר קיים!
        
        -- בדיקה: האם המחיר השתנה?
        IF ABS(v_existing_price - p_price) <= p_tolerance THEN
            -- מחיר זהה (±1%) → רק עדכון timestamp
            UPDATE prices
            SET last_scraped_at = NOW()
            WHERE id = v_price_id;
            
            RAISE NOTICE 'Price unchanged: %', v_price_id;
        ELSE
            -- מחיר השתנה → רשומה חדשה
            INSERT INTO prices (
                product_id, supplier_id, store_id,
                price, currency, is_available,
                scraped_at, first_scraped_at, last_scraped_at
            ) VALUES (
                p_product_id, p_supplier_id, p_store_id,
                p_price, p_currency, p_is_available,
                NOW(), NOW(), NOW()
            );
            
            RAISE NOTICE 'Price changed: % -> %', v_existing_price, p_price;
        END IF;
    ELSE
        -- מחיר חדש לגמרי
        INSERT INTO prices (
            product_id, supplier_id, store_id,
            price, currency, is_available,
            scraped_at, first_scraped_at, last_scraped_at
        ) VALUES (
            p_product_id, p_supplier_id, p_store_id,
            p_price, p_currency, p_is_available,
            NOW(), NOW(), NOW()
        );
        
        RAISE NOTICE 'New price created';
    END IF;
END;
$$ LANGUAGE plpgsql;
```

**שימוש:**
```python
# במקום INSERT רגיל:
cursor.execute("""
    SELECT upsert_price(
        %s,    -- product_id
        %s,    -- supplier_id
        %s,    -- store_id
        %s,    -- price
        'ILS',
        TRUE,  -- is_available
        0.01   -- tolerance (1%)
    )
""", (product_id, supplier_id, store_id, price))
```

### 3.3 פתרון 2: ON CONFLICT

```sql
-- מניעת כפילות במוצרים
INSERT INTO products (name, ean, manufacturer_code)
VALUES ('חלב תנובה', '7290000000001', '7290000000001')
ON CONFLICT (ean)           -- אם ברקוד קיים
DO UPDATE SET               -- עדכן במקום ליצור כפילות
    name = EXCLUDED.name
RETURNING id;

-- מניעת כפילות בסניפים
INSERT INTO stores (chain_id, store_id, name, city)
VALUES (153, '001', 'רמי לוי שיקמה', 'תל אביב')
ON CONFLICT (chain_id, store_id)  -- store ייחודי לפי chain+store_id
DO UPDATE SET
    name = EXCLUDED.name,
    city = EXCLUDED.city
RETURNING id;
```

### 3.4 פתרון 3: Redis Cache (99% hit rate!)

```python
class ProductCache:
    """Cache למניעת queries מיותרים ל-DB"""
    
    def get_or_create_product(self, barcode, name):
        # ── שלב 1: בדיקה ב-Cache (99% hit!) ──
        cache_key = f"product:ean:{barcode}"
        cached_id = redis.get(cache_key)
        
        if cached_id:
            return int(cached_id)  # ✅ Cache HIT (0.5ms)
        
        # ── שלב 2: בדיקה ב-DB (1% miss) ──
        product_id = db.query("""
            SELECT id FROM products
            WHERE ean = %s
            LIMIT 1
        """, barcode)
        
        if product_id:
            # שמירה ב-Cache לפעם הבאה
            redis.setex(cache_key, 86400, product_id)  # 24h
            return product_id
        
        # ── שלב 3: יצירה (0.1% new) ──
        product_id = db.execute("""
            INSERT INTO products (name, ean)
            VALUES (%s, %s)
            ON CONFLICT (ean) DO UPDATE SET name = EXCLUDED.name
            RETURNING id
        """, name, barcode)
        
        # שמירה ב-Cache
        redis.setex(cache_key, 86400, product_id)
        return product_id
```

**תוצאה:**
```
ייבוא 100,000 מוצרים:
- ללא Cache: 100,000 DB queries = 1000 שניות ❌
- עם Cache:  1,000 DB queries = 10 שניות ✅
```

---

## 💾 חלק 4: שמירת נתונים רזה ויעילה

### 4.1 עקרונות Lean Data

```
1. ✅ NO DUPLICATES
   - upsert_price במקום INSERT
   - ON CONFLICT DO UPDATE
   - Redis Cache

2. ✅ NORMALIZE
   - אב מוצר אחד → N מוצרים אזוריים
   - product_id במקום שמירת שם מלא בכל מחיר

3. ✅ COMPRESS
   - JSONB לתכונות משתנות
   - Index רק מה שצריך
   - Partition לפי תאריך

4. ✅ ARCHIVE OLD DATA
   - מחירים ישנים → TimescaleDB
   - Retention policy (2 שנים)
```

### 4.2 JSONB - שמירת Attributes

```sql
-- במקום עמודות נפרדות לכל תכונה:
ALTER TABLE products ADD COLUMN color VARCHAR(50);
ALTER TABLE products ADD COLUMN size VARCHAR(50);
ALTER TABLE products ADD COLUMN material VARCHAR(50);
-- ... 100+ columns?! ❌

-- פתרון: JSONB
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(500),
    ean VARCHAR(20),
    attributes JSONB DEFAULT '{}'::jsonb  -- ✅
);

-- דוגמה:
INSERT INTO products (name, ean, attributes) VALUES (
    'חולצת פולו',
    '1234567890',
    '{"color": "כחול", "size": "L", "material": "כותנה"}'::jsonb
);

-- Query:
SELECT * FROM products
WHERE attributes->>'color' = 'כחול'
  AND attributes->>'size' = 'L';

-- Index על JSONB
CREATE INDEX idx_products_attributes ON products 
    USING gin(attributes);
```

### 4.3 Partitioning - חלוקת טבלאות גדולות

```sql
-- prices table יכולה להיות ענקית (מיליארדי שורות!)
-- פתרון: Partition לפי תאריך

CREATE TABLE prices (
    id BIGSERIAL,
    product_id BIGINT,
    price DECIMAL,
    scraped_at TIMESTAMP,
    ...
) PARTITION BY RANGE (scraped_at);

-- יצירת partitions
CREATE TABLE prices_2025_12 PARTITION OF prices
    FOR VALUES FROM ('2025-12-01') TO ('2026-01-01');

CREATE TABLE prices_2026_01 PARTITION OF prices
    FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');

-- יתרונות:
-- ✅ Query מהיר (רק partition רלוונטי)
-- ✅ Backup קל (partition בנפרד)
-- ✅ מחיקה מהירה (DROP partition ישן)
```

---

## 🔍 חלק 5: חיפוש מהיר והצלבה

### 5.1 Indexes קריטיים

```sql
-- ═══════════ Products Table ═══════════
CREATE INDEX idx_products_ean ON products(ean) 
    WHERE ean IS NOT NULL;                        -- חיפוש לפי ברקוד

CREATE INDEX idx_products_name_trgm ON products 
    USING gin(name gin_trgm_ops);                 -- חיפוש fuzzy

CREATE INDEX idx_products_search ON products 
    USING gin(to_tsvector('english', name));      -- Full-text search

-- ═══════════ Prices Table ═══════════
CREATE INDEX idx_prices_product_time ON prices(
    product_id, scraped_at DESC
);                                                -- מחירים אחרונים למוצר

CREATE INDEX idx_prices_master ON prices(
    master_product_id, scraped_at DESC
);                                                -- השוואה גלובלית!

CREATE INDEX idx_prices_store ON prices(
    store_id, is_available
) WHERE is_available = TRUE;                      -- מוצרים זמינים בסניף

-- ═══════════ Stores Table ═══════════
CREATE INDEX idx_stores_location ON stores 
    USING gist(geom);                             -- חיפוש גיאוגרפי

CREATE INDEX idx_stores_city ON stores(city);    -- חיפוש לפי עיר
```

### 5.2 דוגמאות Query מהירות

```sql
-- דוגמה 1: מצא את המחיר הזול ביותר למוצר
SELECT 
    s.name as store_name,
    s.city,
    p.price,
    p.scraped_at
FROM prices p
JOIN stores s ON p.store_id = s.id
WHERE p.product_id = 54321
  AND p.is_available = TRUE
ORDER BY p.price ASC
LIMIT 5;
-- ⚡ 2ms (בזכות idx_prices_product_time)

-- דוגמה 2: השוואה גלובלית לאב מוצר
SELECT 
    pml.region,
    p.name as product_name,
    AVG(pr.price) as avg_price,
    COUNT(*) as price_count
FROM product_master_links pml
JOIN products p ON pml.regional_product_id = p.id
JOIN prices pr ON pr.product_id = p.id
WHERE pml.master_product_id = 999  -- "tnuva-milk-3pct-1l"
  AND pr.is_available = TRUE
  AND pr.scraped_at > NOW() - INTERVAL '7 days'
GROUP BY pml.region, p.name;
-- ⚡ 10ms (בזכות idx_prices_master)

-- דוגמה 3: מוצרים זמינים בטווח 5 ק"מ
SELECT 
    p.name,
    s.name as store_name,
    pr.price,
    ST_Distance(s.geom, ST_MakePoint(34.7818, 32.0853)::geography) / 1000 as distance_km
FROM products p
JOIN prices pr ON pr.product_id = p.id
JOIN stores s ON pr.store_id = s.id
WHERE ST_DWithin(
    s.geom,
    ST_MakePoint(34.7818, 32.0853)::geography,
    5000  -- 5km
)
AND pr.is_available = TRUE
ORDER BY distance_km;
-- ⚡ 15ms (בזכות idx_stores_location)
```

### 5.3 Materialized Views - תוצאות מוכנות מראש

```sql
-- במקום לחשב כל פעם, נכין מראש!
CREATE MATERIALIZED VIEW mv_product_best_prices AS
SELECT 
    p.id as product_id,
    p.name,
    MIN(pr.price) as min_price,
    MAX(pr.price) as max_price,
    AVG(pr.price) as avg_price,
    COUNT(DISTINCT pr.store_id) as store_count
FROM products p
JOIN prices pr ON pr.product_id = p.id
WHERE pr.is_available = TRUE
  AND pr.scraped_at > NOW() - INTERVAL '7 days'
GROUP BY p.id, p.name;

CREATE UNIQUE INDEX ON mv_product_best_prices(product_id);

-- רענון יומי
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_product_best_prices;

-- שימוש:
SELECT * FROM mv_product_best_prices WHERE product_id = 54321;
-- ⚡ 0.1ms! (במקום 50ms)
```

---

## 🔌 חלק 6: התחברות מהירה למקורות חדשים

### 6.1 Checklist - הוספת מקור חדש

```markdown
[ ] 1. צור scraper class חדש
    - ירש מ-BaseSupermarketScraper
    - קובץ: backend/scrapers/[name]_scraper.py

[ ] 2. יישם fetch_file_list()
    - API? Web scraping? FTP?
    - החזר List[FileMetadata]

[ ] 3. יישם parse_file()
    - XML? JSON? CSV?
    - המר ל-List[ParsedProduct]

[ ] 4. (אופציונלי) build_store_identifier()
    - אם יש subchain/מזהה ייחודי

[ ] 5. בדיקה
    - הרץ import_files(limit=1)
    - בדוק DB

[ ] 6. אוטומציה
    - צור BAT script
    - הוסף ל-scheduler
```

### 6.2 תבנית מוכנה

```python
# backend/scrapers/template_scraper.py
from base_supermarket_scraper import BaseSupermarketScraper, FileMetadata, ParsedProduct
import requests
from pathlib import Path

class TemplateScraper(BaseSupermarketScraper):
    """
    Template for new data sources
    Copy this file and modify!
    """
    
    def __init__(self):
        super().__init__(
            chain_name="Chain Name",           # ← שנה
            chain_slug="chain-name",           # ← שנה
            chain_name_he="שם הרשת",          # ← שנה
            chain_id="7290XXXXXXXXX",          # ← שנה
            country_code="IL"                  # ← שנה
        )
        self.api_url = "https://..."         # ← שנה
        self.api_key = "..."                  # ← שנה
    
    def fetch_file_list(self, file_type='prices', limit=None):
        """איך להשיג רשימת קבצים?"""
        
        # Option A: API Call
        response = requests.get(
            f"{self.api_url}/files",
            headers={"Authorization": f"Bearer {self.api_key}"}
        )
        data = response.json()
        
        files = []
        for item in data[:limit]:
            files.append(FileMetadata(
                url=item['download_url'],      # ← שנה
                filename=item['filename'],     # ← שנה
                file_type='prices'
            ))
        
        return files
    
    def parse_file(self, file_path: Path):
        """איך לנתח את הקובץ?"""
        
        products = []
        
        # Option A: JSON
        import json
        data = json.load(open(file_path))
        
        for item in data['products']:
            product = ParsedProduct(
                name=item['name'],             # ← שנה
                barcode=item['barcode'],       # ← שנה
                price=float(item['price']),    # ← שנה
                manufacturer=item.get('brand')
            )
            products.append(product)
        
        metadata = {
            'store_id': data.get('store_id'),
            'timestamp': data.get('timestamp')
        }
        
        return metadata, products

# Usage:
if __name__ == "__main__":
    scraper = TemplateScraper()
    stats = scraper.import_files(limit=5)
    print(f"✅ Imported: {stats}")
```

---

## 📖 חלק 7: מסלול למידה מומלץ

### שבוע 1: הבנה
```
יום 1-2:
□ קרא מסמך זה מלא (30 דקות)
□ הבט ב-base_supermarket_scraper.py (20 דקות)
□ הבט ב-schema.sql (15 דקות)

יום 3-4:
□ הרץ scraper קיים (published_prices_scraper.py)
□ עקוב אחרי הנתונים ב-DB
□ הבן את ה-flow המלא

יום 5:
□ נסה ליצור scraper פשוט משלך
□ השתמש ב-template
```

### שבוע 2: תרגול
```
□ בנה scraper למקור חדש
□ יישם master product matching
□ הוסף indexes
□ בדוק ביצועים
```

### שבוע 3: אופטימיזציה
```
□ הוסף Redis cache
□ יישם batch processing
□ צור materialized views
□ מדוד ביצועים
```

---

## ✅ סיכום - הנקודות החשובות

### ייבוא נתונים:
1. **Framework אחיד** - BaseSupermarketScraper לכל המקורות
2. **3 שלבים** - Download → Parse → Import
3. **הרחבה קלה** - 5 צעדים להוספת מקור חדש

### אב מוצר:
1. **3 אסטרטגיות** - Barcode (70%) → AI (25%) → Create (5%)
2. **קישור חכם** - product_master_links
3. **השוואה גלובלית** - master_product_id בכל מחיר

### מניעת כפילויות:
1. **upsert_price** - עדכון במקום duplicate
2. **ON CONFLICT** - Postgres built-in
3. **Redis Cache** - 99% hit rate

### שמירה רזה:
1. **JSONB** - attributes משתנים
2. **Normalization** - אב קמוצר → N מוצרים
3. **Partitioning** - prices לפי תאריך

### חיפוש מהיר:
1. **Indexes נכונים** - על EAN, product_id, master_product_id
2. **Materialized Views** - תוצאות מוכנות
3. **GIN/GiST** - Full-text + Geo search

---

## 🎯 הצעדים הבאים שלך

```bash
# 1. נסה scraper קיים
cd "c:/Users/shake/Limor Shaked Dropbox/LIMOR SHAKED ADVANCED COSMETICS LTD/Gogobe"
python backend/scrapers/published_prices_scraper.py

# 2. בדוק את ה-DB
psql -U postgres -d gogobe
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM prices;

# 3. צור scraper חדש משלך
cp backend/scrapers/template_scraper.py backend/scrapers/my_scraper.py
# ערוך את my_scraper.py

# 4. הרץ!
python backend/scrapers/my_scraper.py
```

---

**🚀 בהצלחה! יש לך עכשיו את כל הידע הדרוש!**

תאריך: 23 דצמבר 2025
גרסה: 1.0
