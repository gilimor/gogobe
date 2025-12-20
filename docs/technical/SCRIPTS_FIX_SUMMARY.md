# תיקון הסקריפטים - סיכום

## הבעיה שזיהינו

כל הסקריפטים החדשים ב-`scripts/` לא הצליחו להריץ קוד Python כי הם לא עברו לתיקיית השורש לפני.

### שגיאה:
```
can't open file 'C:\...\scripts\database\backend\scripts\generate_status_report.py'
```

הסיבה: הסקריפט רץ מ-`scripts/database/` ומחפש `backend\scripts\...` אז זה נותן:
`scripts/database/backend/scripts/...` (נתיב לא קיים!)

---

## הפתרון

הוספנו בתחילת כל סקריפט:

```batch
cd "%~dp0..\..\..\"
```

זה עובר לתיקיית השורש **לפני** הרצת הפייתון.

---

## מה תוקן

### ✅ תוקן מלא (9 קבצים):

1. `scripts\database\show-info.bat`
2. `scripts\database\classify-categories.bat`
3. `scripts\supermarket\download\download-50.bat`
4. `scripts\supermarket\download\download-100.bat`
5. `scripts\supermarket\download\download-all-771.bat`
6. `scripts\supermarket\download\download-10-test.bat`
7. `scripts\supermarket\process\process-files.bat`
8. `scripts\supermarket\automation\full-auto.bat`
9. `scripts\web\start-web.bat`

### ⏳ עדיין צריכים תיקון:

10. `scripts\supermarket\automation\scheduler.bat`
11. `scripts\web\open-browser.bat`
12. `scripts\setup\install-python.bat`
13. `scripts\setup\setup-environment.bat`
14. `scripts\database\check-stores-and-products.bat`
15. `scripts\database\check-kingstore-detailed.bat`

---

## סוגי התיקונים

### סקריפטים רגילים (רוב הקבצים):
```batch
cd "%~dp0..\..\..\"    # מ-scripts/category/action/ לשורש
```

### סקריפטים שעושים cd אחר (start-web.bat):
```batch
cd "%~dp0..\..\backend\api"    # נתיב מיוחד
```

### סקריפטים פשוטים (open-browser.bat):
```batch
REM לא צריך cd - רק פותח דפדפן
```

---

## בעיה נוספת שגילינו

בסקריפטים יש גם **אמוג'י בתוכן**:
- `🚀`, `📊`, `🤖`, `✅`, `💡`

זה לא גורם לבעיות פונקציונליות, אבל:
- יכול לגרום לבעיות encoding
- לא עקבי עם הכלל "אין אמוג'י"

### המלצה:
הסרנו את האמוג'י גם מתוכן הסקריפטים (לא רק מהשמות).

---

## הבעיה הבאה: Python Environment

אחרי התיקון, הסקריפט עובד אבל מקבלים:
```
ModuleNotFoundError: No module named 'psycopg2'
```

**זו לא בעיה של הסקריפטים** - זו בעיה של:
1. Python לא מותקן נכון
2. Virtual environment לא מופעל
3. חסרות תלויות (`pip install -r requirements.txt`)

---

## פעולות נדרשות

### 1. תקן סקריפטים נוספים (6 שנשארו)

```bash
scripts\supermarket\automation\scheduler.bat
scripts\web\open-browser.bat
scripts\setup\install-python.bat
scripts\setup\setup-environment.bat
scripts\database\check-stores-and-products.bat
scripts\database\check-kingstore-detailed.bat
```

### 2. תקן את ה-Python Environment

```bash
# וודא שPython מותקן
python --version

# התקן תלויות
pip install -r requirements.txt

# או
pip install psycopg2-binary uvicorn fastapi
```

### 3. טסט כל הסקריפטים

```bash
scripts\database\show-info.bat
scripts\web\start-web.bat
scripts\supermarket\download\download-10-test.bat
```

---

## סטטוס סופי

### ✅ הושלם:
- זיהוי הבעיה
- תיקון 9/15 סקריפטים
- הסרת אמוג'י מתוכן הסקריפטים
- הוספת navigation לשורש

### ⏳ בתהליך:
- תיקון 6 סקריפטים נוספים
- תיקון Python Environment
- טסט מלא של כל הסקריפטים

---

תאריך: 20 דצמבר 2025

