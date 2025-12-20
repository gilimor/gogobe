# ❌ Python שבור - פתרון נדרש

## הבעיה:

יש לך **3 התקנות Python** שמתנגשות:

```
1. C:\Users\shake\AppData\Local\Microsoft\WindowsApps\python.exe (3.14.2)
2. C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe (3.9)
3. C:\Users\shake\AppData\Local\Python\bin\python.exe
```

Python 3.14 מנסה להשתמש בספריות של Python 3.9 וזה יוצר התנגשות.

---

## ⚠️ אי אפשר להפעיל את השרת עד שזה יתוקן!

---

## פתרונות:

### פתרון 1: השתמש ב-Python 3.9 (אם הוא עובד)
```bash
# בדוק אם זה עובד:
"C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe" --version

# אם עובד, השתמש בו:
"C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe" -m pip install fastapi uvicorn psycopg2-binary
```

### פתרון 2: התקן Python 3.11 נקי (מומלץ!)
```
1. הורד Python 3.11.9 מ: https://www.python.org/downloads/release/python-3119/
2. התקן ל: C:\Python311\
3. הוסף ל-PATH
4. הרץ: pip install fastapi uvicorn psycopg2-binary
```

### פתרון 3: הסר Python 3.14 מה-PATH
```
1. Settings → System → About → Advanced system settings
2. Environment Variables
3. ב-PATH מחק את: C:\Users\shake\AppData\Local\Microsoft\WindowsApps
4. הזז את Python 3.9 להיות ראשון
```

---

## מה עשיתי:

יצרתי לך:
- `FIX-PYTHON-39.bat` - ינסה להשתמש ב-Python 3.9
- `TEST-PYTHON.bat` - לבדוק אם זה עובד

---

## מה לעשות עכשיו:

1. **נסה:** `TEST-PYTHON.bat`
2. **אם עובד:** `FIX-PYTHON-39.bat`
3. **אז:** `START.bat`

---

## אם כלום לא עובד:

אתה צריך להתקין Python 3.11 מחדש ולנקות את ה-PATH.

זה **בעיה במערכת**, לא בקוד שלנו.

---

תאריך: 20 דצמבר 2025

