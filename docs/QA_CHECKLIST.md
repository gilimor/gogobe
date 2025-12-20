# 🛡️ Quality Assurance Checklist

## 📋 לפני כל PR/שינוי

### 1. **Pre-Flight Checklist**
כשמוסיפים דף/פיצ'ר חדש:

- [ ] התפריט עודכן ב-**כל** הדפים הקיימים
- [ ] הקובץ נוסף ל-`main.py` (route)
- [ ] הקובץ מוזכר ב-`README.md`
- [ ] יש בדיקת QA אוטומטית
- [ ] הרצת בדיקות לפני commit

---

## 🔍 QA Scripts

### Navigation Consistency Check
```bash
# Windows (PowerShell)
.\scripts\qa\check_navigation.ps1

# מה זה בודק:
# - כל דף HTML יש תפריט
# - כל דף HTML יש את כל הקישורים
# - אין קישורים שבורים
```

### API Routes Check
```bash
# בדיקה שכל דף HTML יש route ב-API
python scripts/qa/check_routes.py
```

---

## 🎯 סוגי בדיקות

### A. **Structural Tests** (מבנה)
```
✓ כל HTML עם <nav class="main-nav">
✓ כל nav עם 6 קישורים (או מספר קבוע)
✓ כל דף עם active על הכפתור הנכון
```

### B. **Functional Tests** (פונקציונליות)
```
✓ כל קישור עובד (200 OK)
✓ כל API endpoint עובד
✓ כל דף טוען נתונים
```

### C. **Content Tests** (תוכן)
```
✓ אין טקסט placeholder
✓ אין TODO בקוד production
✓ כל תמונה/asset קיימת
```

---

## 🚨 Red Flags (דגלים אדומים)

אם רואים את זה - **STOP!**

1. ❌ **"אני עושה רק שינוי קטן"** → עדיין תריץ QA
2. ❌ **"זה עובד אצלי"** → צריך לבדוק בסביבת production
3. ❌ **"אני לא זוכר אם..."** → תבדוק!
4. ❌ **"אני מיישם מהר"** → מהירות < איכות

---

## 📝 רשימת קבצים לעדכון

### כשמוסיפים דף חדש:

#### Frontend:
```
✓ frontend/new-page.html (הדף החדש)
✓ frontend/index.html (תפריט)
✓ frontend/dashboard.html (תפריט)
✓ frontend/categories.html (תפריט)
✓ frontend/stores.html (תפריט)
✓ frontend/prices.html (תפריט)
✓ frontend/errors.html (תפריט)
```

#### Backend:
```
✓ backend/api/main.py (route חדש)
✓ backend/api/main.py (API endpoint אם צריך)
```

#### Docs:
```
✓ README.md (הוסף בתיעוד)
✓ docs/PAGES.md (רשימת דפים)
```

---

## 🔧 כלים לשיפור

### 1. Component Reuse (עתיד)
במקום לשכפל תפריט ב-6 מקומות:

```html
<!-- Option A: JavaScript -->
<div id="main-nav"></div>
<script src="/static/common-nav.js"></script>

<!-- Option B: Server-side include -->
{% include 'nav.html' %}

<!-- Option C: Web Component -->
<gogobe-nav></gogobe-nav>
```

### 2. Automated Tests
```python
# tests/test_navigation.py
def test_all_pages_have_navigation():
    html_files = get_all_html_files()
    for file in html_files:
        assert '<nav class="main-nav">' in file.read()
        assert 'prices.html' in file.read()
```

### 3. Pre-commit Hook
```bash
# .git/hooks/pre-commit
#!/bin/bash
echo "Running QA checks..."
python scripts/qa/check_all.py
if [ $? -ne 0 ]; then
    echo "QA checks failed!"
    exit 1
fi
```

---

## 📊 Process Flow

```
שינוי חדש
    ↓
1. עשה את השינוי
    ↓
2. רשום ב-CHECKLIST
    ↓
3. הרץ QA אוטומטי
    ↓
4. בדיקה ידנית (smoke test)
    ↓
5. תיעוד
    ↓
6. Commit & Push
```

---

## ✅ Success Criteria

לפני שאומרים "סיימתי":

1. ✅ כל הבדיקות עברו
2. ✅ Checklist מלא
3. ✅ אין warnings בקונסול
4. ✅ Hard refresh עובד
5. ✅ תיעוד מעודכן

---

## 🎓 Lessons Learned

מהטעות הזו למדנו:
- **Consistency is key** - תפריט צריך להיות אחיד
- **Automate checks** - אל תסמוך על זיכרון
- **Component reuse** - DRY (Don't Repeat Yourself)
- **Test before deliver** - תמיד QA לפני משלוח

