# מבנה תיקיות נתונים מוצע

## הבעיה הנוכחית

```
backend/data/kingstore/
├── Price7290058108879-001-202512180922.xml
├── Price7290058108879-001-202512181622.xml
├── Price7290058108879-002-202512180922.xml
├── Price7290058108879-003-202512180922.xml
└── ... (366 קבצים מעורבבים!)
```

**בעיות:**
- כל הקבצים בתיקייה אחת
- קשה לזהות מאיזו חנות
- קשה לנקות קבצים ישנים
- קשה לעקוב אחרי עדכונים

---

## המבנה המוצע

### אופציה 1: לפי חנות ותאריך

```
backend/data/
├── kingstore/
│   ├── store-001/
│   │   ├── 2025-12/
│   │   │   ├── prices/
│   │   │   │   ├── Price-7290058108879-001-20251218-0922.xml
│   │   │   │   ├── Price-7290058108879-001-20251218-1622.xml
│   │   │   │   └── Price-7290058108879-001-20251219-1222.xml
│   │   │   └── promos/
│   │   │       └── Promo-7290058108879-001-20251218-0922.xml
│   │   └── 2025-11/
│   │       └── prices/
│   ├── store-002/
│   │   └── 2025-12/
│   │       └── prices/
│   ├── store-003/
│   └── README.md
│
└── other-sources/
    ├── shufersal/
    ├── rami-levy/
    └── ...
```

### אופציה 2: לפי תאריך וחנות (אם יש עדכון יומי)

```
backend/data/
├── kingstore/
│   ├── 2025-12-20/
│   │   ├── store-001/
│   │   │   ├── prices.xml
│   │   │   └── promos.xml
│   │   ├── store-002/
│   │   ├── store-003/
│   │   └── metadata.json
│   ├── 2025-12-19/
│   │   ├── store-001/
│   │   ├── store-002/
│   │   └── ...
│   └── latest/          <- symlink לתיקיית היום
│       ├── store-001/
│       └── ...
```

### אופציה 3: לפי מקור > חנות > סוג

```
backend/data/
├── supermarkets/
│   ├── kingstore/
│   │   ├── chain-7290058108879/
│   │   │   ├── stores/
│   │   │   │   ├── 001/
│   │   │   │   │   ├── prices/
│   │   │   │   │   │   ├── 2025-12-20.xml
│   │   │   │   │   │   ├── 2025-12-19.xml
│   │   │   │   │   │   └── latest.xml -> 2025-12-20.xml
│   │   │   │   │   └── promos/
│   │   │   │   ├── 002/
│   │   │   │   └── 003/
│   │   │   └── metadata/
│   │   │       ├── stores.json
│   │   │       └── chain-info.json
│   │   ├── shufersal/
│   │   └── rami-levy/
│   └── dental/
│       └── suppliers/
```

---

## המלצה: אופציה 3 (הכי מסודר)

### יתרונות:
1. **היררכיה ברורה**: מקור > רשת > חנות > סוג
2. **קל להוסיף מקורות**: כל מקור בתיקייה נפרדת
3. **קל לנקות**: מחק תיקייות ישנות
4. **metadata מרוכז**: כל המידע על החנויות במקום אחד
5. **symlinks ל-latest**: קל לגשת לנתונים העדכניים

### מבנה הקבצים:

```
stores/001/prices/2025-12-20.xml
              └─ ChainId: 7290058108879
                 StoreId: 001
                 Date: 2025-12-20
                 Type: Prices
```

---

## סקריפט ארגון מחדש

```python
# backend/scripts/reorganize_data.py

from pathlib import Path
import re
from datetime import datetime
import shutil

def parse_filename(filename):
    """
    Parse: Price7290058108879-001-202512180922.xml
    Returns: (type, chain_id, store_id, date, time)
    """
    pattern = r'(Price|Promo)(\d+)-(\d+)-(\d{12})\.(xml|gz)'
    match = re.match(pattern, filename)
    
    if match:
        file_type, chain_id, store_id, datetime_str, ext = match.groups()
        
        # Parse date: 202512180922 = 2025-12-18 09:22
        year = datetime_str[:4]
        month = datetime_str[4:6]
        day = datetime_str[6:8]
        hour = datetime_str[8:10]
        minute = datetime_str[10:12]
        
        return {
            'type': file_type.lower(),
            'chain_id': chain_id,
            'store_id': store_id.zfill(3),  # 001, 002, etc.
            'date': f"{year}-{month}-{day}",
            'time': f"{hour}{minute}",
            'ext': ext
        }
    return None

def reorganize_kingstore_data(source_dir, target_dir):
    """
    Reorganize KingStore data files
    """
    source_path = Path(source_dir)
    target_path = Path(target_dir)
    
    moved_count = 0
    skipped_count = 0
    
    for file in source_path.glob("*.xml"):
        info = parse_filename(file.name)
        
        if not info:
            print(f"Skipping: {file.name}")
            skipped_count += 1
            continue
        
        # Create target directory structure
        new_dir = (
            target_path / 
            "supermarkets" / 
            "kingstore" / 
            f"chain-{info['chain_id']}" / 
            "stores" / 
            info['store_id'] / 
            f"{info['type']}s"
        )
        
        new_dir.mkdir(parents=True, exist_ok=True)
        
        # New filename: 2025-12-20-0922.xml
        new_name = f"{info['date']}-{info['time']}.{info['ext']}"
        new_path = new_dir / new_name
        
        # Move file
        shutil.move(str(file), str(new_path))
        print(f"Moved: {file.name} -> {new_path}")
        moved_count += 1
        
        # Create 'latest' symlink
        latest_link = new_dir / f"latest.{info['ext']}"
        if latest_link.exists():
            latest_link.unlink()
        # Windows: copy instead of symlink
        shutil.copy(str(new_path), str(latest_link))
    
    print(f"\nMoved: {moved_count}")
    print(f"Skipped: {skipped_count}")

if __name__ == "__main__":
    source = "backend/data/kingstore"
    target = "backend/data"
    reorganize_kingstore_data(source, target)
```

---

## שימוש:

```bash
# 1. גיבוי הנתונים
xcopy "backend\data\kingstore" "backend\data\kingstore_backup" /E /I

# 2. הרץ ארגון מחדש
python backend\scripts\reorganize_data.py

# 3. בדוק שהכל תקין
dir backend\data\supermarkets\kingstore\chain-*\stores\
```

---

## תוצאה:

### לפני:
```
366 קבצים בתיקייה אחת
קשה למצוא משהו
```

### אחרי:
```
backend/data/supermarkets/kingstore/
└── chain-7290058108879/
    ├── stores/
    │   ├── 001/
    │   │   └── prices/
    │   │       ├── 2025-12-20-0922.xml
    │   │       ├── 2025-12-19-1222.xml
    │   │       └── latest.xml
    │   ├── 002/
    │   └── ...
    └── metadata/
        └── stores.json
```

**מסודר, נקי, קל למצוא!**

---

האם לבצע את הארגון מחדש?

