# 🔧 תיקון בעיית Python

## הבעיה

```
AssertionError: SRE module mismatch
```

יש לך 2 גרסאות Python שמתנגשות:
- WinPython 3.9.10
- Python 3.14

---

## 🎯 3 פתרונות:

### פתרון 1: השתמש בAnaconda (מומלץ!) ⭐

```powershell
# הורד Anaconda:
# https://www.anaconda.com/download

# התקן ופתח Anaconda Prompt

# צור סביבה חדשה:
conda create -n gogobe python=3.11

# הפעל:
conda activate gogobe

# התקן:
pip install pdfplumber pandas openpyxl psycopg2

# הרץ:
cd "C:\Users\shake\Limor Shaked Dropbox\LIMOR SHAKED ADVANCED COSMETICS LTD\Gogobe\backend\scripts"
python batch_pdf_processor.py "C:\Users\shake\Limor Shaked Dropbox\LIMOR SHAKED ADVANCED COSMETICS LTD\Gogobe\New prices"
```

---

### פתרון 2: Python נקי (ללא WinPython)

```powershell
# הסר WinPython או הורד Python רגיל:
# https://www.python.org/downloads/release/python-3119/

# התקן Python 3.11 (לא 3.14!)
# ✅ בחר: "Add Python to PATH"

# לאחר התקנה, פתח PowerShell חדש:
python --version  # אמור להיות 3.11.x

# התקן:
pip install pdfplumber pandas openpyxl

# הרץ:
python batch_pdf_processor.py "..."
```

---

### פתרון 3: Google Colab (הכי קל!)

```
גש ל: RUN_BATCH_IN_COLAB.md
```

**אין צורך בPython מקומי!**

---

## 🎯 מה מומלץ?

```yaml
יש לך זמן 30 דקות:
  → Anaconda

יש לך זמן 10 דקות:
  → Google Colab ⭐

רוצה מקומי לטווח ארוך:
  → Python 3.11 נקי
```

---

## ✅ בדיקה שעובד:

```powershell
python --version
# Python 3.11.x

python -c "import pdfplumber; print('OK')"
# OK
```

**אם רואה "OK" - אתה מוכן! 🎉**





