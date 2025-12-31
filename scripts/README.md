# 🔧 סקריפטי הפעלה - Gogobe

כל סקריפטי ה-BAT מסודרים כאן לפי נושאים.

---

## 📁 מבנה תיקיות

```
scripts/
├── setup/           התקנה והגדרות
├── supermarket/     כל מה שקשור לסופרמרקטים
│   ├── download/    הורדת קבצים
│   ├── process/     עיבוד קבצים
│   └── automation/  אוטומציה מלאה
├── pdf/             סריקת PDF
├── web/             אתר Web
├── database/        מסד נתונים
└── testing/         בדיקות
```

---

## 🚀 קיצורי דרך (התחלה מהירה)

### התקנה ראשונית (פעם אחת):
```bash
scripts\setup\install-python.bat      # התקן Python 3.11
scripts\setup\setup-environment.bat   # התקן dependencies
```

### עבודה יומיומית:
```bash
# הורד נתונים
scripts\supermarket\download\download-50.bat

# הפעל אתר
scripts\web\start-web.bat

# ראה סטטיסטיקות
scripts\database\show-info.bat
```

### אוטומציה מלאה:
```bash
# כל התהליך בקליק אחד
scripts\supermarket\automation\full-auto.bat

# תזמון אוטומטי (רץ ברקע)
scripts\supermarket\automation\scheduler.bat
```

---

## 📚 לפי נושאים

### 🛒 סופרמרקטים

**הורדה**:
- `supermarket/download/download-10-test.bat` - טסט (10 קבצים)
- `supermarket/download/download-50.bat` - בינוני (50 קבצים, מומלץ!) ⭐
- `supermarket/download/download-100.bat` - גדול (100 קבצים)
- `supermarket/download/download-all-771.bat` - הכל (771 קבצים, ~15 דקות)

**עיבוד**:
- `supermarket/process/process-files.bat` - עיבוד קבצים שהורדו

**אוטומציה**:
- `supermarket/automation/full-auto.bat` - הכל אוטומטית ⭐
- `supermarket/automation/scheduler.bat` - תזמון (כל שעה)

---

### 🌐 אתר Web

- `web/start-web.bat` - הפעל שרת ⭐
- `web/open-browser.bat` - פתח דפדפן

---

### 🗄️ מסד נתונים

- `database/show-info.bat` - הצג סטטיסטיקות ⭐
- `database/classify-categories.bat` - סיווג אוטומטי

---

### 🔧 התקנה

- `setup/install-python.bat` - התקן Python 3.11
- `setup/setup-environment.bat` - התקן dependencies

---

### 🧪 בדיקות

- `testing/test-kingstore-10.bat` - טסט הורדה קטן
- `testing/count-files.bat` - ספור קבצים זמינים

---

## 💡 טיפים

1. **התחל קטן**: השתמש ב-`download-10-test.bat` קודם
2. **אוטומציה**: אחרי שהכל עובד, השתמש ב-`full-auto.bat`
3. **תזמון**: `scheduler.bat` ירוץ ברקע ויעדכן אוטומטית

---

## 🆘 בעיות?

אם משהו לא עובד:
1. בדוק ש-Python 3.11 מותקן: `python --version`
2. בדוק ש-PostgreSQL רץ
3. הרץ `database/show-info.bat` לראות סטטוס

---

**📖 תיעוד מלא**: `docs/guides/`





