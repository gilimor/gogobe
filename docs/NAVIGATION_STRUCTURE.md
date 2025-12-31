# 🧭 מבנה הניווט - Gogobe

## תאריך: 21 דצמבר 2025

---

## 📋 סקירה כללית

יש **שני קבצי ניווט שונים** במערכת:

1. **`frontend/nav.js`** - התפריט הראשי של האתר (הירוק)
2. **`frontend/static/nav.js`** - תפריט ישן (לא בשימוש!)

---

## ✅ התפריט הראשי הפעיל

**קובץ:** `frontend/nav.js`

**איפה משתמשים בו:**
- כל דפי האתר (dashboard, index, prices, categories, stores, וכו')
- נטען דרך: `<script src="/static/nav.js"></script>`
- מוצג כ: `<main-nav></main-nav>`

### רשימת הקישורים (לפי סדר):

```
🏠 דף הבית              → /dashboard.html
📦 חיפוש מוצרים          → /
💰 מחירים                → /prices.html
👑 אבות מוצר             → /admin/master-management.html
📂 קטגוריות              → /categories.html
🏪 רשתות                 → /stores.html
🗺️ מפה                  → /map.html
📥 מקורות               → /sources.html
✅ מטלות                → /tasks.html
👨‍💼 ניהול               → /admin.html
📖 תיעוד טכני            → /docs/ (חדש! סגול)
```

---

## 🎨 עיצוב התפריט

### צבעים:
- **רקע:** `linear-gradient(135deg, #10b981 0%, #059669 100%)` (ירוק)
- **קישורים רגילים:** לבן
- **קישור פעיל:** `background: rgba(255, 255, 255, 0.3)`
- **תיעוד טכני:** `background: linear-gradient(135deg, #7c3aed 0%, #5b21b6 100%)` (סגול)

### מיקום:
- **Sticky top** - נשאר למעלה בגלילה
- **z-index: 100** - מעל כל התוכן

---

## 🗂️ מבנה הקוד

```javascript
// frontend/nav.js
class MainNav extends HTMLElement {
    connectedCallback() {
        const currentPath = window.location.pathname;
        
        this.innerHTML = `
        <nav class="main-nav">
            <div class="nav-container">
                <div class="nav-content">
                    <a href="/dashboard.html" class="nav-brand">
                        <span>🛒</span>
                        <span>Gogobe</span>
                    </a>
                    <div class="nav-links">
                        <!-- כל הקישורים כאן -->
                    </div>
                </div>
            </div>
        </nav>
        `;
    }
}

customElements.define('main-nav', MainNav);
```

---

## 🚫 קבצים שלא בשימוש

### `frontend/static/nav.js` - לא פעיל!

**למה לא בשימוש:**
- זה תפריט ישן שנוצר בתחילת הפרויקט
- לא נטען באף דף
- יש בו קישורים שונים (API, מפת חנויות)

**המלצה:** אפשר למחוק או להשאיר כגיבוי

---

## 📖 מערכת התיעוד

### מיקום:
- **קובץ ראשי:** `backend/docs/index.html`
- **URL:** `http://localhost:8000/docs/`

### ניווט דו-כיווני:

#### מהאתר למערכת התיעוד:
1. **תפריט ראשי:** לחץ על "📖 תיעוד טכני" (סגול)
2. **Dashboard:** כרטיס סגול "📖 תיעוד טכני"

#### ממערכת התיעוד לאתר:
1. **לוגו:** לחץ על "🚀 Gogobe" בתפריט הצדדי
2. **כפתור:** "🏠 חזרה לאתר" בכותרת

---

## 🔧 איך להוסיף קישור חדש

### שלב 1: ערוך את `frontend/nav.js`

```javascript
// הוסף שורה חדשה בתוך <div class="nav-links">
<a href="/new-page.html" class="nav-link ${currentPath.includes('new-page') ? 'active' : ''}">
    🆕 שם הדף
</a>
```

### שלב 2: Refresh הדפדפן
- לחץ F5 או Ctrl+R
- אם לא עובד, עשה Ctrl+Shift+R (hard refresh)

---

## 📊 סטטיסטיקה

- **סה"כ קישורים בתפריט:** 11
- **דפים פעילים:** 11
- **קישורים חיצוניים:** 1 (תיעוד טכני - נפתח בטאב חדש)

---

## ⚠️ כללים חשובים

### ✅ עשה:
1. **תמיד ערוך את `frontend/nav.js`** (לא `frontend/static/nav.js`)
2. **שמור עקביות** בסדר הקישורים
3. **השתמש באימוג'י** לפני כל קישור
4. **בדוק ש-currentPath** מזהה נכון את הדף הפעיל

### ❌ אל תעשה:
1. **אל תערוך את `frontend/static/nav.js`** - הוא לא בשימוש!
2. **אל תשנה את המבנה** של ה-HTML בלי לעדכן את ה-CSS
3. **אל תוסיף קישורים** ללא אימוג'י

---

## 🎯 סיכום

### התפריט הראשי:
- **קובץ:** `frontend/nav.js`
- **11 קישורים** כולל "תיעוד טכני"
- **צבע:** ירוק (תיעוד טכני בסגול)

### מערכת התיעוד:
- **URL:** `/docs/`
- **ניווט דו-כיווני** מלא
- **22 מסמכים טכניים**

**הכל מתועד ומסודר!** ✅

---

תאריך עדכון: 21 דצמבר 2025, 23:52
