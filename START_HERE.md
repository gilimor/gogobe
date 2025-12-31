# התחל כאן - הפרויקט המסודר

## הפרויקט עכשיו נקי ומסודר!

### השורש מכיל רק 15 קבצים חשובים
```
README.md                      <- מדריך ראשי
NEW_README.md                  <- README חדש ומקצועי
START_HERE_NEW.md              <- המסמך הזה
MIGRATION_GUIDE.md             <- מדריך מעבר
TODO_LIST.md                   <- משימות
CODING_GUIDELINES.md           <- חוקי קוד (חשוב!)
requirements.txt               <- תלויות Python
docker-compose.yml             <- Docker
Dockerfile
+ קבצים נוספים
```

---

## הסקריפטים החשובים

### סופרמרקטים
```bash
scripts\supermarket\download\download-50.bat          # הורדה מהירה
scripts\supermarket\process\process-files.bat         # עיבוד קבצים
scripts\supermarket\automation\full-auto.bat          # אוטומציה מלאה
```

### אתר
```bash
scripts\web\start-web.bat                             # הפעלת שרת
scripts\web\open-browser.bat                          # פתיחת דפדפן
```

### מסד נתונים
```bash
scripts\database\show-info.bat                        # סטטיסטיקות
scripts\database\classify-categories.bat              # סיווג אוטומטי
```

---

## חוק חשוב: אין אמוג'י!

כל הקבצים החדשים **ללא אמוג'י**!

למה? כי אמוג'י גורם ל:
- בעיות encoding ב-Windows
- באגים ב-PowerShell  
- קושי לעבוד עם סקריפטים

ראה: `CODING_GUIDELINES.md`

---

## מבנה התיקיות

```
Gogobe/
├── backend/              <- קוד Backend (Python)
├── frontend/             <- קוד Frontend (HTML/CSS/JS)
├── scripts/              <- סקריפטי BAT מסודרים
│   ├── supermarket/
│   ├── web/
│   ├── database/
│   └── README.md
├── docs/                 <- תיעוד
│   ├── guides/
│   └── technical/
├── TRASH/                <- קבצים ישנים (אפשר למחוק)
└── (תיקיות נתונים)
```

---

## מה ב-TRASH?

105 קבצים ישנים עם אמוג'י שהועברו לשם.

**אחרי שתבדוק שהכל עובד - אפשר למחוק:**
```bash
rmdir /s /q TRASH
```

---

## צעד ראשון - הפעל את האתר!

### הכי פשוט:
```
לחץ כפול על: START.bat
```

זה יפעיל הכל והדפדפן יפתח אוטומטית.

### או דרך סקריפטים:
```bash
# בדוק DB
scripts\database\show-info.bat

# הפעל את האתר
scripts\web\start-web.bat
```

---

## מדריכים חשובים

1. `CODING_GUIDELINES.md` - חוקי קוד (קרא קודם!)
2. `scripts/README.md` - הסבר כל הסקריפטים
### 3. ממשקי ניהול (Web Interfaces)
המערכת כוללת פורטל מרכזי המאגד את כל הכלים:

*   **כתובת ראשית (Portal):** `http://localhost:8000/`
    *   משם ניתן להגיע לכל המערכות (דשבורד, מפה, ניהול מוצרים).

*   **דשבורד ראשי (Mission Control):** `http://localhost:8000/dashboard.html`
*   **מפת מחירים (Geo Intel):** `http://localhost:8000/map.html`
*   **תיעוד API (Swagger):** `http://localhost:8000/docs`

> **הערה חשובה:** הניווט בין הדפים הוא אוטומטי באמצעות ה-Navbar העליון.

### 4. פרוטוקול עבודה יומי (Daily Routine)
1.  הפעלת המנוע: `RUN_ORCHESTRA.bat`
2.  פתיחת ה-Portal בדפדפן.
3.  בדיקת סטטוס ב-Dashboard (וידוא שכל ה-"Chips" בטבלת הצי ירוקים).

---

## תקלות נפוצות

### הסקריפט לא עובד?
1. בדוק שאתה בתיקיית השורש
2. הרץ: `cd "C:\Users\shake\Limor Shaked Dropbox\LIMOR SHAKED ADVANCED COSMETICS LTD\Gogobe"`

### לא מוצא קובץ ישן?
ראה `MIGRATION_GUIDE.md` - טבלאות מעבר מלאות

---

## סיכום

- הפרויקט מסודר
- השורש נקי
- כל דבר במקום הנכון
- אין אמוג'י!
- הכל עובד

**בהצלחה!**

---

תאריך: 20 דצמבר 2025

