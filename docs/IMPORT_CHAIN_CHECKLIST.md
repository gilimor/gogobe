# מדריך מלא לייבוא רשת חדשה - Checklist
## עודכן: 21 דצמבר 2025, 22:35

---

## 📋 מה קורה בפועל בייבוא? (בדיקה מעשית)

### ✅ מה שעובד כרגע:

#### 1. **סניפים - יש בדיקת קיום!**
```python
# הקוד בודק אם הסניף קיים:
cur.execute("""
    SELECT id FROM stores
    WHERE chain_id = %s AND store_id = %s
    LIMIT 1
""", (self.chain_db_id, unique_store_code))

# אם קיים - משתמש בו
# אם לא - יוצר חדש עם ON CONFLICT
```

**תוצאה בפועל:**
```
id  | store_id          | name                  | city | latitude | longitude
469 | 7290058140886_011 | Rami Levy - Store 011 |      |          |
```

**בעיות שזוהו:**
- ❌ **אין city** - הקובץ לא מכיל מידע על עיר
- ❌ **אין latitude/longitude** - אין geocoding
- ❌ **store_id הוא מזהה מורכב** - `7290058140886_011` (chain_id + store number)

---

#### 2. **מוצרים - יש בדיקת קיום לפי ברקוד!**
```python
# הקוד בודק אם המוצר קיים לפי ברקוד:
cur.execute("""
    SELECT id FROM products
    WHERE (ean = %s OR manufacturer_code = %s)
    LIMIT 1
""", (product.barcode, product.barcode))

# אם קיים - משתמש בו (אב מוצר!)
# אם לא - יוצר חדש
```

**תוצאה בפועל:**
```
total_prices: 244
unique_products: 244
```

**מה זה אומר:**
- ✅ כל מוצר נוצר פעם אחת (אין כפילויות במוצרים)
- ✅ יש שיוך לאב מוצר (לפי ברקוד)
- ⚠️ אבל: כל המוצרים חדשים (244 מוצרים חדשים)

**דוגמאות מוצרים:**
```
id    | name                      | ean           | manufacturer_code
76182 | בלו נאן כשר מבעבע חצ      | 4022025001752 | 4022025001752
76183 | ערק יהודה 700מל           | 7290014910461 | 7290014910461
```

---

#### 3. **מחירים - יש מנגנון upsert!**
```python
# הקוד משתמש בפונקציה upsert_price:
cur.execute("""
    SELECT upsert_price(
        %s,    -- product_id
        %s,    -- supplier_id
        %s,    -- store_id
        %s,    -- price
        'ILS', -- currency
        TRUE,  -- is_available
        0.01   -- price_tolerance
    )
""", (product_id, self.supplier_id, store_id, product.price))
```

**מה זה עושה:**
- ✅ אם המחיר קיים (אותו מוצר, אותו סניף, מחיר דומה) - מעדכן
- ✅ אם המחיר שונה - יוצר רשומה חדשה
- ✅ שומר היסטוריה של מחירים

**תוצאה:** 244 מחירים יובאו בהצלחה

---

### ❌ מה שלא עובד / חסר:

#### 1. **אין Geocoding**
```sql
SELECT latitude, longitude FROM stores WHERE chain_id = 153;
-- תוצאה: NULL, NULL
```

**למה זה בעיה:**
- מפת הסניפים לא תעבוד
- לא ניתן לחפש סניפים לפי מיקום

**פתרון נדרש:**
```python
# צריך להוסיף סקריפט geocoding:
# backend/scripts/geocode_stores.py
# שישתמש ב-Nominatim או Google Geocoding API
```

---

#### 2. **אין מידע על עיר/כתובת**
```sql
SELECT city, address FROM stores WHERE chain_id = 153;
-- תוצאה: NULL, NULL
```

**למה זה קורה:**
- קבצי **Prices** לא מכילים מידע על סניפים
- צריך לייבא קבצי **Stores** בנפרד!

**פתרון נדרש:**
```python
# הוסף ייבוא של Stores files:
stats_stores = scraper.import_files(file_type='stores', limit=5)
```

---

#### 3. **אין מנגנון מחיקת כפילויות אוטומטי**

**מה קורה עכשיו:**
- פונקציית `upsert_price` מונעת כפילויות **באותו יום**
- אבל אם מריצים את הייבוא פעמיים - יכולות להיווצר כפילויות

**בדיקה:**
```sql
-- בדוק כפילויות:
SELECT product_id, store_id, DATE(scraped_at), COUNT(*) 
FROM prices 
WHERE store_id IN (SELECT id FROM stores WHERE chain_id = 153)
GROUP BY product_id, store_id, DATE(scraped_at)
HAVING COUNT(*) > 1;
```

**פתרון נדרש:**
```sql
-- הרץ אחרי כל ייבוא:
DELETE FROM prices 
WHERE id NOT IN (
    SELECT MIN(id) 
    FROM prices 
    GROUP BY store_id, product_id, DATE(scraped_at)
);
```

---

#### 4. **אין עדכון טבלאות ניהול**

**מה חסר:**
- עדכון `chains` table עם סטטיסטיקות
- עדכון `last_import_date`, `last_import_status`
- עדכון counters (product_count, price_count)

**פתרון נדרש:**
```python
# בסוף הייבוא:
cur.execute("""
    UPDATE chains 
    SET 
        last_import_date = NOW(),
        last_import_status = 'success',
        product_count = (SELECT COUNT(DISTINCT product_id) FROM prices WHERE store_id IN (SELECT id FROM stores WHERE chain_id = %s)),
        price_count = (SELECT COUNT(*) FROM prices WHERE store_id IN (SELECT id FROM stores WHERE chain_id = %s))
    WHERE id = %s
""", (chain_id, chain_id, chain_id))
```

---

#### 5. **אין תמיכה במטבעות שונים**

**מצב נוכחי:**
- הכל ב-ILS (שקלים)
- הקוד hardcoded: `'ILS'`

**למה זה יהיה בעיה:**
- רשתות בחו"ל (EUR, USD, GBP)
- צריך המרת מטבע

**פתרון נדרש:**
```python
# הוסף פרמטר currency לסקריפט:
def __init__(self, ..., currency: str = 'ILS'):
    self.currency = currency

# בייבוא:
cur.execute("""
    SELECT upsert_price(..., %s, ...)  -- currency
""", (..., self.currency, ...))
```

---

## 📝 Checklist לייבוא רשת חדשה

### שלב 1: הכנה (לפני הייבוא)
- [ ] **בדוק אם הרשת קיימת בטבלת chains**
  ```sql
  SELECT * FROM chains WHERE name = 'שם הרשת';
  ```
- [ ] **אם לא קיימת - צור רשת חדשה**
  ```sql
  INSERT INTO chains (name, name_he, chain_id, country_code, is_active)
  VALUES ('Chain Name', 'שם הרשת', 'chain_code', 'IL', TRUE);
  ```
- [ ] **צור supplier אם צריך**
  ```sql
  INSERT INTO suppliers (name, name_he, country_code)
  VALUES ('Supplier Name', 'שם הספק', 'IL');
  ```
- [ ] **הכן פרטי התחברות** (username, password, chain_id)

---

### שלב 2: ייבוא ראשוני (בדיקה)
- [ ] **הרץ עם limit=1** - בדוק שזה עובד
  ```bash
  docker-compose exec -T api python /app/backend/scrapers/published_prices_scraper.py
  ```
- [ ] **בדוק שהסניף נוצר**
  ```sql
  SELECT * FROM stores WHERE chain_id = [chain_id] ORDER BY id DESC LIMIT 1;
  ```
- [ ] **בדוק שהמוצרים נוצרו**
  ```sql
  SELECT COUNT(*) FROM products WHERE id IN (SELECT DISTINCT product_id FROM prices WHERE store_id IN (SELECT id FROM stores WHERE chain_id = [chain_id]));
  ```
- [ ] **בדוק שהמחירים נוצרו**
  ```sql
  SELECT COUNT(*) FROM prices WHERE store_id IN (SELECT id FROM stores WHERE chain_id = [chain_id]);
  ```

---

### שלב 3: ייבוא Stores (מידע על סניפים)
- [ ] **ייבא קבצי Stores**
  ```python
  stats_stores = scraper.import_files(file_type='stores', limit=5)
  ```
- [ ] **בדוק שיש city/address**
  ```sql
  SELECT store_id, name, city, address FROM stores WHERE chain_id = [chain_id];
  ```

---

### שלב 4: Geocoding
- [ ] **הרץ geocoding על הסניפים**
  ```bash
  docker-compose exec -T api python /app/backend/scripts/geocode_stores.py --chain-id=[chain_id]
  ```
- [ ] **בדוק שיש latitude/longitude**
  ```sql
  SELECT COUNT(*) FROM stores WHERE chain_id = [chain_id] AND latitude IS NOT NULL;
  ```

---

### שלב 5: ייבוא מלא
- [ ] **הרץ עם limit גבוה** (50-100)
  ```python
  stats = scraper.import_files(file_type='prices', limit=50)
  ```
- [ ] **בדוק סטטיסטיקות**
  ```sql
  SELECT 
      COUNT(DISTINCT s.id) as stores,
      COUNT(DISTINCT p.product_id) as products,
      COUNT(p.id) as prices
  FROM stores s
  LEFT JOIN prices p ON p.store_id = s.id
  WHERE s.chain_id = [chain_id];
  ```

---

### שלב 6: ניקוי וטיוב
- [ ] **מחק כפילויות**
  ```sql
  DELETE FROM prices 
  WHERE id NOT IN (
      SELECT MIN(id) 
      FROM prices 
      GROUP BY store_id, product_id, DATE(scraped_at)
  );
  ```
- [ ] **עדכן טבלאות ניהול**
  ```sql
  UPDATE chains 
  SET 
      last_import_date = NOW(),
      last_import_status = 'success',
      product_count = (SELECT COUNT(DISTINCT product_id) FROM prices WHERE store_id IN (SELECT id FROM stores WHERE chain_id = [chain_id])),
      price_count = (SELECT COUNT(*) FROM prices WHERE store_id IN (SELECT id FROM stores WHERE chain_id = [chain_id]))
  WHERE id = [chain_id];
  ```
- [ ] **עדכן counters בטבלת stores**
  ```sql
  UPDATE stores s
  SET 
      product_count = (SELECT COUNT(DISTINCT product_id) FROM prices WHERE store_id = s.id),
      price_count = (SELECT COUNT(*) FROM prices WHERE store_id = s.id),
      last_updated = NOW()
  WHERE chain_id = [chain_id];
  ```

---

### שלב 7: תיעוד
- [ ] **תעד בעיות שנמצאו** - עדכן PUBLISHED_PRICES_FIX_SUMMARY.md
- [ ] **תעד הגדרות ספציפיות** - username, chain_id, וכו'
- [ ] **עדכן TODO_NEXT_SESSION.md** - הוסף לקחים חדשים

---

## 🔧 סקריפטים שצריך ליצור

### 1. `backend/scripts/geocode_stores.py`
```python
#!/usr/bin/env python3
"""
Geocode stores - add latitude/longitude
"""
import requests
import time
from backend.database.connection import get_db_connection

def geocode_address(address, city):
    """Use Nominatim to geocode address"""
    url = "https://nominatim.openstreetmap.org/search"
    params = {
        'q': f"{address}, {city}, Israel",
        'format': 'json',
        'limit': 1
    }
    headers = {'User-Agent': 'Gogobe/1.0'}
    
    response = requests.get(url, params=params, headers=headers)
    if response.status_code == 200:
        data = response.json()
        if data:
            return float(data[0]['lat']), float(data[0]['lon'])
    return None, None

def main(chain_id=None):
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Get stores without geocoding
    query = "SELECT id, address, city FROM stores WHERE latitude IS NULL"
    if chain_id:
        query += f" AND chain_id = {chain_id}"
    
    cur.execute(query)
    stores = cur.fetchall()
    
    for store_id, address, city in stores:
        if not address or not city:
            continue
            
        lat, lon = geocode_address(address, city)
        if lat and lon:
            cur.execute("""
                UPDATE stores 
                SET latitude = %s, longitude = %s
                WHERE id = %s
            """, (lat, lon, store_id))
            conn.commit()
            print(f"✓ Geocoded store {store_id}: {lat}, {lon}")
        
        time.sleep(1)  # Rate limiting
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    import sys
    chain_id = int(sys.argv[1]) if len(sys.argv) > 1 else None
    main(chain_id)
```

---

### 2. `backend/scripts/cleanup_duplicates.py`
```python
#!/usr/bin/env python3
"""
Clean up duplicate prices
"""
from backend.database.connection import get_db_connection

def main():
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Delete duplicates
    cur.execute("""
        DELETE FROM prices 
        WHERE id NOT IN (
            SELECT MIN(id) 
            FROM prices 
            GROUP BY store_id, product_id, DATE(scraped_at)
        )
    """)
    
    deleted = cur.rowcount
    conn.commit()
    print(f"✓ Deleted {deleted} duplicate prices")
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
```

---

### 3. `backend/scripts/update_chain_stats.py`
```python
#!/usr/bin/env python3
"""
Update chain statistics
"""
from backend.database.connection import get_db_connection

def main(chain_id):
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Update chain stats
    cur.execute("""
        UPDATE chains 
        SET 
            last_import_date = NOW(),
            last_import_status = 'success',
            product_count = (
                SELECT COUNT(DISTINCT product_id) 
                FROM prices 
                WHERE store_id IN (SELECT id FROM stores WHERE chain_id = %s)
            ),
            price_count = (
                SELECT COUNT(*) 
                FROM prices 
                WHERE store_id IN (SELECT id FROM stores WHERE chain_id = %s)
            )
        WHERE id = %s
    """, (chain_id, chain_id, chain_id))
    
    # Update store stats
    cur.execute("""
        UPDATE stores s
        SET 
            product_count = (SELECT COUNT(DISTINCT product_id) FROM prices WHERE store_id = s.id),
            price_count = (SELECT COUNT(*) FROM prices WHERE store_id = s.id),
            last_updated = NOW()
        WHERE chain_id = %s
    """, (chain_id,))
    
    conn.commit()
    print(f"✓ Updated stats for chain {chain_id}")
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    import sys
    chain_id = int(sys.argv[1])
    main(chain_id)
```

---

## 📊 בדיקות SQL שימושיות

### בדיקת מצב רשת:
```sql
-- סטטיסטיקות כלליות
SELECT 
    c.name,
    COUNT(DISTINCT s.id) as stores,
    COUNT(DISTINCT p.product_id) as products,
    COUNT(p.id) as prices,
    c.last_import_date
FROM chains c
LEFT JOIN stores s ON s.chain_id = c.id
LEFT JOIN prices p ON p.store_id = s.id
WHERE c.id = [chain_id]
GROUP BY c.id, c.name, c.last_import_date;

-- סניפים ללא geocoding
SELECT COUNT(*) 
FROM stores 
WHERE chain_id = [chain_id] 
AND (latitude IS NULL OR longitude IS NULL);

-- סניפים ללא מידע
SELECT COUNT(*) 
FROM stores 
WHERE chain_id = [chain_id] 
AND (city IS NULL OR address IS NULL);

-- כפילויות במחירים
SELECT product_id, store_id, DATE(scraped_at), COUNT(*) as duplicates
FROM prices 
WHERE store_id IN (SELECT id FROM stores WHERE chain_id = [chain_id])
GROUP BY product_id, store_id, DATE(scraped_at)
HAVING COUNT(*) > 1;
```

---

## 🎯 סיכום - מה צריך לעשות לכל רשת חדשה

1. ✅ **הכן את הרשת** - chains, suppliers
2. ✅ **ייבא Prices** - קבצי מחירים
3. ⚠️ **ייבא Stores** - קבצי סניפים (חסר!)
4. ❌ **Geocoding** - הוסף latitude/longitude (חסר!)
5. ❌ **ניקוי כפילויות** - הרץ cleanup (חסר!)
6. ❌ **עדכן סטטיסטיקות** - chains, stores counters (חסר!)
7. ✅ **תעד** - הוסף ללקחים

---

**הבא בתור:** ליצור את 3 הסקריפטים החסרים ולהריץ אותם על רמי לוי!
