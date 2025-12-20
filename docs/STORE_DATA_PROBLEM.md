# 🏪 Store Data Problem & Solutions

## 🚨 הבעיה

**בקבצי XML של KingStore אין מידע על סניפים ספציפיים!**

### מה יש ב-XML:
```xml
<Item>
  <ItemCode>7290000000001</ItemCode>
  <ItemNm>חלב תנובה</ItemNm>
  <ItemPrice>5.90</ItemPrice>
  <!-- אין StoreId, StoreName, City, Address! -->
</Item>
```

### מה חסר:
- ❌ שם סניף
- ❌ עיר
- ❌ כתובת
- ❌ טלפון
- ❌ שעות פתיחה

**הקבצים הם "Pricefull" (מחירון מלא) - לכל הרשת, לא לסניף מסוים!**

---

## ✅ פתרונות

### Solution 1: **GOV.IL API** (מומלץ!)

משרד הכלכלה מפרסם API עם **כל הסניפים של כל הרשתות**:

```
https://prices.gov.il/api/stores
```

**יתרונות:**
- ✅ מידע רשמי ומעודכן
- ✅ כולל כל הפרטים (שם, עיר, כתובת, טלפון)
- ✅ חינמי
- ✅ כל הרשתות (לא רק KingStore)

**איך להשתמש:**
```python
import requests

response = requests.get('https://prices.gov.il/api/stores')
stores = response.json()

for store in stores:
    if store['ChainName'] == 'קינג סטור':
        print(f"סניף {store['StoreId']}: {store['StoreName']}")
        print(f"  עיר: {store['City']}")
        print(f"  כתובת: {store['Address']}")
```

---

### Solution 2: **Shufersal Stores XML**

ל-Shufersal (ורשתות אחרות) יש XML נפרד של סניפים:

```
Stores7290027600007-{date}.xml
```

**מבנה:**
```xml
<Store>
  <StoreId>15</StoreId>
  <BikoretNo>123456</BikoretNo>
  <StoreName>סניף רמת גן</StoreName>
  <Address>רחוב משה לוי 15</Address>
  <City>רמת גן</City>
</Store>
```

---

### Solution 3: **ייבוא ידני/CSV**

קובץ CSV עם נתוני סניפים:

```csv
chain_name,store_id,store_name,city,address,phone
KingStore,15,קינג סטור רמת גן,רמת גן,משה לוי 15,03-1234567
KingStore,20,קינג סטור תל אביב,תל אביב,דיזנגוף 100,03-7654321
```

---

## 🎯 המלצה: GOV.IL API

**צור סקריפט חדש:**

`backend/scripts/import_govil_stores.py`

```python
"""
Import store data from GOV.IL API
https://prices.gov.il/api/stores
"""

import requests
import psycopg2

def import_stores():
    # 1. Get stores from API
    response = requests.get('https://prices.gov.il/api/stores')
    stores = response.json()
    
    # 2. Connect to DB
    conn = psycopg2.connect(...)
    
    # 3. Insert/Update stores
    for store in stores:
        cur.execute("""
            INSERT INTO stores 
            (chain_id, store_id, name, city, address, phone, bikoret_no)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (chain_id, store_id) 
            DO UPDATE SET
                name = EXCLUDED.name,
                city = EXCLUDED.city,
                address = EXCLUDED.address
        """, (...))
```

---

## 📊 סטטוס נוכחי

| רשת | יש סניפים? | יש כתובות? | מקור |
|-----|------------|-----------|------|
| KingStore | ✅ (מזהים בלבד) | ❌ | אין ב-XML |
| Shufersal | 🔮 עתיד | 🔮 עתיד | יש Stores XML |
| Rami Levi | 🔮 עתיד | 🔮 עתיד | יש Stores XML |

---

## 🚀 Action Items

1. [ ] צור סקריפט `import_govil_stores.py`
2. [ ] הרץ ייבוא ראשוני מ-GOV.IL API
3. [ ] הגדר cron job לעדכון שבועי
4. [ ] עדכן תיעוד ב-README

---

## 📝 Quick Fix (זמני)

עד שנייבא מהAPI, אפשר להוסיף ידנית:

```sql
UPDATE stores 
SET 
  city = 'רמת גן',
  address = 'משה לוי 15'
WHERE store_id = '15' AND chain_id = (SELECT id FROM chains WHERE slug = 'kingstore');
```

---

**Bottom Line:** המידע **לא קיים ב-XML** שאנחנו מייבאים. צריך מקור נתונים חיצוני!

