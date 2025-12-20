# 📥 מדריך הורדה והתקנה - Python 3.11

## 🎯 מה צריך לעשות (5 דקות)

---

## שלב 1: הורד את הקובץ

### נפתח לך דף ההורדה, או לחץ כאן:
```
https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe
```

**הורדה תתחיל אוטומטית** (קובץ של ~27 MB)

**⏱️ זמן הורדה: 30 שניות**

---

## שלב 2: התקן

### 2.1 הרץ את הקובץ שהורדת

לחץ פעמיים על: `python-3.11.9-amd64.exe`

---

### 2.2 חשוב מאוד! ⚠️

**בחלון הראשון של ההתקנה:**

```
┌─────────────────────────────────────────┐
│  Install Python 3.11.9                  │
├─────────────────────────────────────────┤
│                                         │
│  ⬜ Install launcher for all users     │
│  ☑️ Add python.exe to PATH  ← ⭐ חשוב!│
│                                         │
│  [ Install Now ]                        │
│  [ Customize installation ]             │
│                                         │
└─────────────────────────────────────────┘
```

**✅ סמן:** "Add python.exe to PATH"

**לחץ:** "Install Now"

---

### 2.3 אישור UAC

יופיע חלון אישור (User Account Control):

```
האם אתה רוצה לאפשר לאפליקציה זו
לבצע שינויים במכשיר?
```

**לחץ:** "Yes" / "כן"

---

### 2.4 המתן להתקנה

```
Setup Progress
████████████████░░░░ 75%

Installing...
```

**⏱️ זמן: 2-3 דקות**

---

### 2.5 סיום

```
┌─────────────────────────────────────────┐
│  Setup was successful                   │
├─────────────────────────────────────────┤
│  ✅ Python 3.11.9 installed             │
│                                         │
│  [ Close ]                              │
└─────────────────────────────────────────┘
```

**לחץ:** "Close"

---

## שלב 3: אימות

### 3.1 סגור את PowerShell הנוכחי

**חשוב!** חייב לפתוח חלון חדש

---

### 3.2 פתח PowerShell חדש

לחץ **Win + X** ובחר "Windows PowerShell"

או חפש "PowerShell" בתפריט Start

---

### 3.3 בדוק את הגרסה

```powershell
python --version
```

**אמור להדפיס:**
```
Python 3.11.9
```

✅ **אם רואה 3.11.9 - מעולה!**

❌ **אם רואה 3.14 או 3.9:**
- סגור את PowerShell
- פתח חדש
- נסה שוב

---

### 3.4 בדיקה נוספת

```powershell
python -c "import sys; print(sys.version)"
```

**אמור להדפיס משהו כמו:**
```
3.11.9 (tags/v3.11.9:..., Oct  2 2023, ...)
```

---

## שלב 4: הגדר את Gogobe

```powershell
cd "C:\Users\shake\Limor Shaked Dropbox\LIMOR SHAKED ADVANCED COSMETICS LTD\Gogobe"

.\setup_gogobe_env.bat
```

**זה ייקח 3 דקות ויתקין:**
- pdfplumber (לקריאת PDFs)
- pandas (לעיבוד נתונים)
- openpyxl (ל-Excel)
- psycopg2 (ל-PostgreSQL)

**⏱️ זמן: 3 דקות**

---

## שלב 5: הרץ! 🚀

```powershell
.\run_gogobe.bat
```

**זהו! האוטומציה תעבוד!**

---

## 🎉 סיימת!

```yaml
✅ Python 3.11 מותקן
✅ סביבה וירטואלית מוכנה
✅ כל הספריות מותקנות
✅ מוכן להריץ!

זמן כולל: 10 דקות
תוצאה: אוטומציה מלאה עובדת!
```

---

## 🔧 פתרון בעיות

### Python עדיין מראה 3.14?

**אופציה 1: תיקון PATH**

```powershell
# בדוק היכן Python 3.11:
where.exe python
```

אמור להראות משהו כמו:
```
C:\Users\shake\AppData\Local\Programs\Python\Python311\python.exe
C:\Users\shake\AppData\Local\Programs\Python\Python314\python.exe
```

**Python 3.11 צריך להיות ראשון!**

---

**אופציה 2: השתמש בנתיב מלא**

במקום `python` השתמש ב:
```powershell
C:\Users\shake\AppData\Local\Programs\Python\Python311\python.exe --version
```

---

**אופציה 3: הסר Python 3.14**

Settings → Apps → Apps & features
חפש "Python 3.14"
לחץ "Uninstall"

---

### ההתקנה נכשלה?

**נסה להריץ כמנהל מערכת:**

1. לחץ ימני על `python-3.11.9-amd64.exe`
2. "Run as administrator"
3. המשך עם ההתקנה

---

### pip לא עובד?

```powershell
python -m ensurepip --upgrade
python -m pip install --upgrade pip
```

---

## 📞 זקוק לעזרה?

**בדוק את:**
- 🔧 FIX_AND_RUN.md (מדריך מלא)
- AUTOMATION_GUIDE.md (תיעוד כללי)

---

## 🎯 מה הלאה?

אחרי שPython 3.11 עובד:

```
1. setup_gogobe_env.bat   (פעם אחת)
2. run_gogobe.bat         (כל פעם)
```

**ואז:**
```
PDFs → קליק → מוצרים בדאטהבייס! 🎉
```

---

# 🚀 מוכן? תתחיל!

1. הורד: python-3.11.9-amd64.exe
2. התקן: סמן "Add to PATH"
3. אמת: python --version
4. הגדר: setup_gogobe_env.bat
5. הרץ: run_gogobe.bat

**10 דקות → אוטומציה מלאה!** 💪





