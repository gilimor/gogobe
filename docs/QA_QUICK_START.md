# Quality Assurance - Quick Start

## 🚀 מניעת טעויות בעתיד

### הבעיה שהייתה:
✅ יצרתי דף מחירים חדש
❌ שכחתי לעדכן תפריט ב-3 דפים אחרים

### הפתרון:

## 1️⃣ **QA Scripts אוטומטיים**

### בדיקת ניווט:
```powershell
.\scripts\qa\check_navigation.ps1
```
**מה זה בודק:**
- ✓ כל דף HTML יש תפריט
- ✓ כל תפריט עם כל הקישורים
- ✓ רק כפתור אחד active
- ✓ כיוון RTL

### בדיקת routes:
```bash
docker exec gogobe-api-1 python /app/scripts/qa/check_routes.py
```
**מה זה בודק:**
- ✓ כל HTML יש route ב-main.py
- ✓ אין routes יתומים
- ✓ consistency בין frontend ו-backend

---

## 2️⃣ **Checklist לכל שינוי**

📄 ראה: `docs/QA_CHECKLIST.md`

**כשמוסיפים דף חדש:**
1. ✅ יצירת הקובץ
2. ✅ הוספת route ב-main.py
3. ✅ עדכון תפריט ב-**כל** הדפים (7 קבצים!)
4. ✅ הרצת QA אוטומטי
5. ✅ בדיקה ידנית
6. ✅ עדכון תיעוד

---

## 3️⃣ **רשימת דפים**

📄 ראה: `docs/PAGES.md`

**6 דפים פעילים:**
- index.html
- dashboard.html
- prices.html
- categories.html
- stores.html
- errors.html

**חוק:** כל שינוי בתפריט → עדכון ב-**6 דפים**!

---

## 4️⃣ **תהליך עבודה**

```
שינוי → TODO List → עשייה → QA Script → Manual Test → Commit
```

**לפני כל commit:**
```powershell
# הרץ את זה!
.\scripts\qa\check_navigation.ps1
docker exec gogobe-api-1 python /app/scripts/qa/check_routes.py
```

אם יש שגיאות → **אל תמשיך!**

---

## 5️⃣ **למה זה חשוב?**

| ללא QA | עם QA |
|--------|-------|
| 😰 "שכחתי..." | ✅ הסקריפט מזכיר |
| 🐛 באגים בproduction | 🛡️ תופס לפני deployment |
| ⏰ זמן תיקון: שעות | ⚡ זמן מניעה: דקות |
| 😡 לקוח עצבני | 😊 לקוח מרוצה |

---

## 📚 קבצים חשובים:

- `docs/QA_CHECKLIST.md` - checklist מפורט
- `docs/PAGES.md` - רשימת כל הדפים
- `scripts/qa/check_navigation.ps1` - בדיקת תפריט
- `scripts/qa/check_routes.py` - בדיקת routes

---

## 🎯 Bottom Line

**מעכשיו - לפני כל PR:**
```powershell
.\scripts\qa\check_navigation.ps1
```

**אם עובר ✅ → OK**  
**אם נכשל ❌ → תקן ושוב**

**זה חוסך זמן, כסף, ועצבים!**

