# 📊 מדריך Error Monitor - מעקב שגיאות

## 🎯 מה זה?

**מערכת ניטור שגיאות מתקדמת** שאוספת ומציגה:
- ✅ שגיאות מהשרת (Backend)
- ✅ שגיאות מהדפדפן (Frontend)
- ✅ היסטוריה של 100 השגיאות האחרונות
- ✅ פילטור וחיפוש
- ✅ Stack traces מפורטים

---

## 🚀 איך לגשת?

### דרך 1: מהאתר הראשי

בתחתית האתר יש קישור:
```
🔍 Error Monitor
```

### דרך 2: ישירות

פתח בדפדפן:
```
frontend/errors.html
```

או:
```
http://localhost:8000/docs
```
(וחפש את `/api/errors`)

---

## 📊 מה תראה?

### סטטיסטיקות:

```yaml
סה"כ שגיאות: 15
  ├─ שגיאות שרת: 3 (אדום)
  └─ שגיאות קליינט: 12 (כתום)
```

### רשימת שגיאות:

כל שגיאה מכילה:
```yaml
כותרת:
  - סוג (שרת/קליינט)
  - סוג השגיאה (TypeError, ValueError, וכו')
  - הודעה קצרה
  - זמן

פירוט (לחץ להרחבה):
  - הודעת שגיאה מלאה
  - נתיב/URL
  - שורה ועמודה (קליינט)
  - Stack trace מלא
```

---

## 🔍 סוגי שגיאות

### 1. שגיאות שרת (Server Errors)

**צבע: אדום 🔴**

**מה נתפס:**
- שגיאות Python
- שגיאות Database
- Exceptions לא צפויים
- HTTP 500 errors

**דוגמאות:**
```python
# Database connection error
psycopg2.OperationalError: could not connect to server

# Missing data
KeyError: 'product_id'

# Invalid query
ValueError: invalid literal for int()
```

---

### 2. שגיאות קליינט (Client Errors)

**צבע: כתום 🟠**

**מה נתפס:**
- JavaScript errors
- Uncaught exceptions
- Unhandled promise rejections
- Network errors

**דוגמאות:**
```javascript
// Undefined variable
ReferenceError: product is not defined

// Null pointer
TypeError: Cannot read property 'name' of null

// Failed fetch
TypeError: Failed to fetch
```

---

## 🛠️ פעולות זמינות

### 1. סינון לפי סוג

```
Dropdown "סינון" → בחר:
  - הכל
  - שגיאות שרת
  - שגיאות קליינט
```

---

### 2. רענון

```
כפתור "🔄 רענן"
  → טוען שגיאות חדשות
  → רענון אוטומטי כל 30 שניות
```

---

### 3. ניקוי

```
כפתור "🗑️ נקה הכל"
  → מוחק את כל השגיאות
  → דורש אישור
```

---

### 4. הרחבת פרטים

```
לחץ על כותרת השגיאה
  → מראה Stack trace מלא
  → כל הפרטים הטכניים
```

---

## 📈 דוגמאות שימוש

### תרחיש 1: בדיקת בעיות

```yaml
בעיה: המשתמשים מדווחים שהאתר לא עובד

פתרון:
  1. פתח Error Monitor
  2. ראה את השגיאות האחרונות
  3. מזהה: "Database connection failed"
  4. מתקן את החיבור לDB
  5. בודק שאין עוד שגיאות
```

---

### תרחיש 2: ניפוי באגים

```yaml
בעיה: חיפוש מסוים מקריס את האתר

פתרון:
  1. נסה את החיפוש
  2. פתח Error Monitor
  3. ראה שגיאה חדשה:
     "TypeError: Cannot read property 'price'"
  4. Stack trace מראה בדיוק איפה
  5. מתקן את הקוד
```

---

### תרחיש 3: מעקב ביצועים

```yaml
מטרה: וידוא שהמערכת יציבה

שימוש:
  1. בדוק Error Monitor מידי יום
  2. אם 0 שגיאות = 🎉 מצוין!
  3. אם יש שגיאות חוזרות = חקור
  4. אם יש עלייה פתאומית = התראה
```

---

## 🔧 API Endpoints

### קבלת שגיאות:

```http
GET /api/errors?limit=50&error_type=server

Response:
{
  "total": 10,
  "errors": [
    {
      "timestamp": "2024-12-19T10:30:00",
      "type": "server",
      "error_type": "ValueError",
      "message": "Invalid product ID",
      "path": "/api/products/abc",
      "traceback": "..."
    }
  ]
}
```

---

### רישום שגיאת קליינט:

```http
POST /api/errors/client

Body:
{
  "type": "TypeError",
  "message": "Cannot read property...",
  "stack": "at loadProducts...",
  "url": "http://localhost/index.html",
  "line": 150,
  "column": 20
}

Response:
{
  "status": "logged"
}
```

---

### מחיקת שגיאות:

```http
DELETE /api/errors

Response:
{
  "status": "cleared",
  "message": "All errors cleared"
}
```

---

## 🎨 עיצוב

### צבעים:

```yaml
שגיאות שרת:
  - Badge: אדום בהיר
  - Border: אדום כהה
  - אייקון: 🔴

שגיאות קליינט:
  - Badge: כתום בהיר
  - Border: כתום כהה
  - אייקון: 🟠

סטטוס טוב:
  - צבע: ירוק
  - אייקון: ✅
```

---

## 💡 טיפים מתקדמים

### טיפ 1: ניטור רציף

```javascript
// בקונסול הדפדפן:
setInterval(() => {
  fetch('http://localhost:8000/api/errors?limit=1')
    .then(r => r.json())
    .then(d => console.log('Errors:', d.total));
}, 5000);
```

---

### טיפ 2: התראות

הוסף ל-app.js:
```javascript
async function checkNewErrors() {
  const response = await fetch(`${API_BASE}/api/errors?limit=5`);
  const data = await response.json();
  
  if (data.total > lastErrorCount) {
    alert(`⚠️ שגיאה חדשה זוהתה!`);
  }
  lastErrorCount = data.total;
}

// בדוק כל דקה
setInterval(checkNewErrors, 60000);
```

---

### טיפ 3: Export לקובץ

```javascript
// הורד שגיאות כJSON
async function exportErrors() {
  const response = await fetch('http://localhost:8000/api/errors?limit=1000');
  const data = await response.json();
  
  const blob = new Blob([JSON.stringify(data, null, 2)], {
    type: 'application/json'
  });
  
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `errors-${Date.now()}.json`;
  a.click();
}
```

---

## 🐛 Debugging Tips

### שגיאה לא מופיעה?

```yaml
בדיקות:
  1. השרת רץ? → בדוק http://localhost:8000/api/health
  2. רענן את Error Monitor → כפתור 🔄
  3. בדוק Console של הדפדפן → F12
  4. השגיאה נתפסה? → try/catch עלול לבלוע
```

---

### שגיאות ישנות?

```yaml
פתרון:
  1. לחץ "🗑️ נקה הכל"
  2. רענן את השרת (Ctrl+C + הרץ מחדש)
  3. error_log נמחק
```

---

### Stack trace לא מפורט?

```yaml
JavaScript:
  - Source maps? הוסף ב-build
  - Minified? השתמש ב-dev version

Python:
  - logging.DEBUG → יותר מידע
  - traceback.format_exc() → מפורט יותר
```

---

## 📊 סטטיסטיקות

```yaml
מה נשמר:
  - 100 השגיאות האחרונות
  - בזיכרון (RAM)
  - לא נשמר לדיסק

מה קורה ב-Restart:
  - השגיאות נמחקות
  - מתחיל מחדש
```

---

## ✅ Best Practices

```yaml
יומי:
  ✅ פתח Error Monitor
  ✅ בדוק שאין שגיאות חדשות
  ✅ תקן בעיות קריטיות

שבועי:
  ✅ סקור שגיאות חוזרות
  ✅ תעדוף לתיקון
  ✅ נקה שגיאות ישנות

חודשי:
  ✅ נתח טרנדים
  ✅ שפר error handling
  ✅ הוסף logging נוסף
```

---

## 🎯 סיכום

```yaml
מה בנינו:
  ✅ דף Error Monitor
  ✅ איסוף שגיאות אוטומטי
  ✅ תצוגה יפה ומפורטת
  ✅ API endpoints
  ✅ Client error tracking
  ✅ Server error tracking

איך להשתמש:
  1. פתח errors.html
  2. ראה שגיאות
  3. לחץ להרחבה
  4. תקן בעיות
  5. נקה ורענן

יתרונות:
  🎯 ניפוי באגים מהיר
  🎯 מעקב אחר בעיות
  🎯 שיפור איכות הקוד
  🎯 ניטור ביצועים
```

---

**🔍 Error Monitor - כלי חיוני למפתח!** 🚀

**פתח errors.html ותתחיל לעקוב אחרי השגיאות!**





