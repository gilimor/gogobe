# הנחיות לעבודה עם הפרויקט

## חוקי קוד חשובים

### 1. אין אמוג'י בשמות קבצים!

**אסור:**
- `🚀 START_WEB.bat`
- `📊 DATABASE.md`
- `🌟 DOWNLOAD.bat`

**מותר:**
```
start-web.bat
database-info.md
download-files.bat
```

**סיבה:** אמוג'י ב-Windows גורם ל:
- בעיות encoding
- באגים ב-PowerShell
- קושי לעבוד עם הקבצים בסקריפטים
- בעיות תאימות

---

### 2. מוסכמות שמות קבצים

#### קבצי BAT:
```bash
download-50.bat           # טוב - kebab-case
process_files.bat         # טוב - snake_case
StartWeb.bat              # לא מומלץ - PascalCase
start-web.bat             # הכי טוב! ✅
```

#### מסמכים:
```bash
README.md                 # טוב
MIGRATION_GUIDE.md        # טוב - SCREAMING_SNAKE_CASE לקבצים חשובים
database-structure.md     # טוב
Database Structure.md     # לא מומלץ - רווחים
```

---

### 3. מבנה תיקיות

```
scripts/
├── supermarket/
│   ├── download/         ← קבצי הורדה
│   ├── process/          ← קבצי עיבוד
│   └── automation/       ← אוטומציה
├── web/                  ← אתר
├── database/             ← DB
└── testing/              ← טסטים
```

**חשוב:** כל דבר במקום הלוגי שלו!

---

### 4. תיעוד

כל תיקייה צריכה `README.md` שמסביר:
- מה נמצא בתיקייה
- איך להשתמש בסקריפטים
- דוגמאות שימוש

---

### 5. קוד נקי

```python
# טוב ✅
def process_kingstore_data(file_path):
    """Process KingStore XML file"""
    pass

# לא טוב ❌
def proc(f):
    pass
```

---

### 6. לוגים

כל סקריפט עם:
```bash
echo ════════════════════════════════════
echo   Processing Files
echo ════════════════════════════════════
echo.
echo Starting process...
```

---

## סיכום חוקים

1. ✅ **אין אמוג'י בשמות קבצים**
2. ✅ **שמות ברורים ותיאוריים**
3. ✅ **kebab-case או snake_case**
4. ✅ **כל דבר בתיקייה הנכונה**
5. ✅ **README בכל תיקייה**
6. ✅ **קוד מתועד**
7. ✅ **לוגים ברורים**

---

עודכן: 20 דצמבר 2025


