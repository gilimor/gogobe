# 🧹 מדריך ניקיון הפרויקט

## 📋 מה צריך לעשות?

יש לך **2 סטים** של קבצים:
1. ✅ **חדש ומסודר** - ב-`scripts/` (תקין!)
2. ❌ **ישן ומבולגן** - בשורש (צריך לסדר)

---

## 🎯 אופציה 1: ניקיון אוטומטי (מומלץ!) ⭐

### צעד 1: גיבוי (אם רוצה)

```bash
# אופציונלי - גבה הכל לפני
xcopy *.bat archive\backup-%date:~-4,4%%date:~-7,2%%date:~-10,2%\ /Y
```

### צעד 2: הרץ ניקיון אוטומטי

```bash
cleanup_project.bat
```

**זה יעשה:**
- ✅ יעביר את כל קבצי ה-BAT הישנים ל-`archive/old-scripts/`
- ✅ יעביר מסמכים ישנים ל-`archive/deprecated-docs/`
- ✅ ימחק קבצי זמניים
- ✅ השורש יהיה **נקי!**

---

## 🎯 אופציה 2: ניקיון ידני (יותר שליטה)

### מה למחוק/להעביר:

#### 1. קבצי BAT ישנים (60+ קבצים):
```
🌟 DOWNLOAD_50_FAST.bat
🤖 AUTO_PRICE_MANAGER.bat
🛒 DOWNLOAD_ALL_KINGSTORE.bat
🚀 FAST_DOWNLOAD_50.bat
⚡ PARALLEL_*.bat
🔥 DOWNLOAD_ALL_771.bat
🔄 REIMPORT_WITH_STORES.bat
🔍 COUNT_AVAILABLE_FILES.bat
🔎 TEST_VISUAL.bat
🧪 TEST_DOWNLOAD.bat
🌐 START_WEBSITE.bat
⏰ START_PRICE_SCHEDULER.bat
📊 SHOW_KINGSTORE_INFO.bat
run_gogobe*.bat
start_web*.bat
setup_*.bat
open_*.bat
export_*.bat
CLASSIFY_*.bat
UPDATE_*.bat
```

**היעד**: `archive/old-scripts/`

#### 2. מסמכים ישנים (35+ קבצים):
```
🎯 START_HERE.md
🤖 AUTOMATION_GUIDE.md
🛒 SUPERMARKET_INTEGRATION.md
🚀 PRODUCTION_SETUP.md
⚡ PARALLEL_GUIDE.md
🌐 WEBSITE_GUIDE.md
☁️ COLAB_SERVER.md
✅ SUCCESS.md
🎉 FINAL_SUMMARY.md
📊 ERROR_MONITOR_GUIDE.md
📋 SOURCE_TRACKING_GUIDE.md
📚 COMPLETE_SUMMARY.md
📝 SUMMARY_FIXES.md
📥 DOWNLOAD_GUIDE.md
START_HERE.md
START-HERE.md
QUICK_*.md
WORKING_*.md
PDF_*.md
```

**היעד**: `archive/deprecated-docs/`

#### 3. קבצים זמניים:
```
check_kingstore_now.py
simple_db_check.py
create_folders.bat
TREE_SCRIPTS.txt
TREE_DOCS.txt
```

**פעולה**: מחיקה (`del`)

---

## 🎯 אופציה 3: שמירה זמנית (לא מומלץ)

אם אתה לא בטוח, אפשר להשאיר הכל כרגע ו:
- **השתמש רק בסקריפטים מ-`scripts/`**
- נקה אחר כך כשתהיה בטוח

---

## ✅ אחרי הניקיון

### השורש יכיל רק:

```
📁 Gogobe/
├── README.md                     ← ראשי
├── NEW_README.md                 ← חדש (לעתיד: שנה שם ל-README.md)
├── MIGRATION_GUIDE.md            ← מדריך מעבר
├── START_HERE_NEW.md             ← התחלה
├── TODO_LIST.md                  ← רשימת משימות
├── requirements.txt              ← תלויות
├── docker-compose.yml            ← Docker
├── Dockerfile
│
├── backend/                      ← קוד Backend
├── frontend/                     ← קוד Frontend
├── scripts/                      ← ✅ סקריפטים מסודרים!
├── docs/                         ← ✅ תיעוד מסודר!
├── archive/                      ← קבצים ישנים
│   ├── old-scripts/
│   └── deprecated-docs/
│
├── Doc/                          ← מסמכים חיצוניים
├── Research/                     ← מחקרים
└── (תיקיות נתונים)
```

---

## 🚀 הסקריפטים החדשים שתשתמש בהם

### במקום:
```bash
🌟 DOWNLOAD_50_FAST.bat
```
### השתמש:
```bash
scripts\supermarket\download\download-50.bat
```

---

### במקום:
```bash
🤖 FULL_AUTO_KINGSTORE.bat
```
### השתמש:
```bash
scripts\supermarket\automation\full-auto.bat
```

---

### במקום:
```bash
🌐 START_WEBSITE.bat
```
### השתמש:
```bash
scripts\web\start-web.bat
```

---

### במקום:
```bash
📊 SHOW_KINGSTORE_INFO.bat
```
### השתמש:
```bash
scripts\database\show-info.bat
```

---

## 📖 תיעוד מלא

ראה `MIGRATION_GUIDE.md` לטבלת מעבר מלאה של כל 55 הקבצים!

---

## 🎬 בוא נעשה את זה!

### צעד 1: הרץ ניקיון
```bash
cleanup_project.bat
```

### צעד 2: טסט שהכל עובד
```bash
scripts\database\show-info.bat
```

### צעד 3: התחל לעבוד עם המבנה החדש!
```bash
scripts\web\start-web.bat
```

---

**🎉 הפרויקט שלך יהיה נקי, מסודר, ומקצועי!**

📅 **תאריך**: 20 דצמבר 2025

