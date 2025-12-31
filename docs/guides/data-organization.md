# מדריך ארגון קבצי נתונים

## הבעיה

כרגע כל קבצי ה-XML של KingStore (366 קבצים) נמצאים בתיקייה אחת:

```
backend/data/kingstore/
├── Price7290058108879-001-202512180922.xml
├── Price7290058108879-001-202512181622.xml
├── Price7290058108879-002-202512180922.xml
└── ... (363 קבצים נוספים)
```

**בעיות:**
- קשה למצוא קבצים
- קשה לנקות קבצים ישנים
- קשה לעקוב אחרי עדכונים לכל חנות
- אין הפרדה בין חנויות

---

## הפתרון המוצע

### מבנה היררכי:

```
backend/data/supermarkets/kingstore/
└── chain-7290058108879/
    ├── stores/
    │   ├── 001/
    │   │   ├── prices/
    │   │   │   ├── 2025-12/
    │   │   │   │   ├── 2025-12-20-0922.xml
    │   │   │   │   ├── 2025-12-19-1222.xml
    │   │   │   │   └── 2025-12-18-1622.xml
    │   │   │   ├── 2025-11/
    │   │   │   └── latest.xml -> 2025-12-20-0922.xml
    │   │   └── promos/
    │   │       └── 2025-12/
    │   ├── 002/
    │   │   └── prices/
    │   │       └── 2025-12/
    │   └── 003/
    │       └── prices/
    │           └── 2025-12/
    └── metadata/
        ├── stores.json          <- מידע על כל החנויות
        └── chain-info.json      <- מידע על הרשת
```

### יתרונות:

1. **ארגון ברור**: כל חנות בתיקייה נפרדת
2. **קל לנקות**: מחק חודשים ישנים
3. **קל לגשת**: `stores/001/prices/latest.xml`
4. **metadata**: מידע מרוכז על החנויות
5. **מדרגי**: קל להוסיף רשתות נוספות

---

## איך לבצע

### שלב 1: גיבוי

```bash
xcopy "backend\data\kingstore" "backend\data\kingstore_backup_20251220" /E /I /Y
```

### שלב 2: הרצת ארגון (DRY RUN)

```bash
scripts\data\reorganize-kingstore-data.bat
```

זה יציג מה יקרה **ללא ביצוע בפועל**.

### שלב 3: ביצוע בפועל

אם הכל נראה טוב, יצור גרסה שמבצעת את השינויים.

---

## דוגמא לפענוח שם קובץ

**שם מקורי:**
```
Price7290058108879-001-202512180922.xml
```

**פענוח:**
- `Price` = סוג קובץ (מחירים)
- `7290058108879` = Chain ID
- `001` = Store ID
- `202512180922` = 2025-12-18 09:22
- `.xml` = פורמט

**שם חדש:**
```
2025-12-18-0922.xml
```

**מיקום חדש:**
```
supermarkets/kingstore/chain-7290058108879/stores/001/prices/2025-12/2025-12-18-0922.xml
```

---

## Metadata Files

### stores.json

```json
{
  "001": {
    "store_id": "001",
    "chain_id": "7290058108879",
    "price_files": 15,
    "promo_files": 3,
    "last_update": "2025-12-20"
  },
  "002": {
    "store_id": "002",
    "chain_id": "7290058108879",
    "price_files": 12,
    "promo_files": 2,
    "last_update": "2025-12-20"
  }
}
```

### chain-info.json

```json
{
  "chain_id": "7290058108879",
  "chain_name": "KingStore",
  "total_stores": 20,
  "active_stores": 18,
  "last_update": "2025-12-20"
}
```

---

## עדכון הסקריפטים

אחרי הארגון מחדש, צריך לעדכן את:

### 1. המעבד (processor)

```python
# backend/scripts/kingstore_xml_processor.py

# במקום:
XML_DIR = "backend/data/kingstore"

# יהיה:
XML_DIR = "backend/data/supermarkets/kingstore/chain-*/stores/*/prices/"
```

### 2. המוריד (downloader)

```python
# backend/scripts/kingstore_downloader.py

def save_file(file_data, chain_id, store_id, date):
    """Save to organized structure"""
    target_dir = Path(
        "backend/data/supermarkets/kingstore" /
        f"chain-{chain_id}" /
        "stores" /
        store_id /
        "prices" /
        date[:7]  # 2025-12
    )
    target_dir.mkdir(parents=True, exist_ok=True)
    # ...
```

---

## מתי לנקות קבצים ישנים

```bash
# מחק קבצים מעל 30 יום
scripts\data\cleanup-old-data.bat --days 30

# מחק חודשים ישנים
rmdir /s /q "backend\data\supermarkets\kingstore\chain-*\stores\*\prices\2025-10"
```

---

## סיכום

### לפני:
```
366 קבצים בתיקייה אחת
קשה למצוא, קשה לנקות
```

### אחרי:
```
מבנה מסודר:
  - לפי רשת
  - לפי חנות
  - לפי תאריך
  - metadata מרוכז
```

---

האם לבצע את הארגון?

תאריך: 20 דצמבר 2025





