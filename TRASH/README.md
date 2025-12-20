# 🗑️ TRASH - קבצים ישנים

תיקייה זו מכילה קבצים שהוחלפו במבנה הפרויקט החדש.

## 📂 מה נמצא כאן?

### `old-bat/` - 51 קבצי BAT ישנים

קבצי BAT שהיו בשורש הפרויקט לפני הארגון מחדש.

**הוחלפו ב:** `scripts/supermarket/`, `scripts/web/`, `scripts/database/`

**דוגמאות:**
- `🌟 DOWNLOAD_50_FAST.bat` → `scripts/supermarket/download/download-50.bat`
- `🤖 FULL_AUTO_KINGSTORE.bat` → `scripts/supermarket/automation/full-auto.bat`
- `🌐 START_WEBSITE.bat` → `scripts/web/start-web.bat`
- `📊 SHOW_KINGSTORE_INFO.bat` → `scripts/database/show-info.bat`

---

### `old-docs/` - 29+ מסמכים ישנים

מסמכי תיעוד ישנים, רבים עם אמוג'י בשמות.

**הוחלפו ב:** `docs/guides/`, `docs/technical/`

**דוגמאות:**
- `🎯 START_HERE.md` → `START_HERE_NEW.md`
- `📊 DATABASE_STRUCTURE.md` → מועבר ל-`docs/technical/`
- `🚀 PRODUCTION_SETUP.md` → מסמכים חדשים ב-`docs/guides/setup/`
- `🛒 SUPERMARKET_INTEGRATION.md` → תיעוד מעודכן

---

### `temp-files/` - קבצי זמניים

קבצים שנוצרו במהלך תהליך הניקיון:
- `create_folders.bat` - סקריפט שיצר את התיקיות החדשות
- `cleanup_*.bat` - סקריפטי הניקיון
- `check_*.py` - סקריפטי בדיקה זמניים
- `TREE_*.txt` - פלט של עצי תיקיות

---

## 🎯 למה קבצים אלה כאן?

במקום למחוק אותם ישירות, העברנו אותם לכאן כדי:
1. ✅ **גיבוי** - אפשר לחזור אליהם במקרה הצורך
2. ✅ **בדיקה** - לוודא שהקבצים החדשים עובדים
3. ✅ **מעבר הדרגתי** - לא לאבד כלום בטעות

---

## 🧹 מתי למחוק?

אחרי שוידאת ש:
1. ✅ הסקריפטים החדשים ב-`scripts/` עובדים
2. ✅ האתר רץ תקין
3. ✅ כל התהליכים פועלים כראוי

**אז אפשר למחוק את תיקיית TRASH כולה:**

```bash
# Windows
rmdir /s /q TRASH

# PowerShell
Remove-Item -Recurse -Force TRASH
```

---

## 📖 מדריך מעבר מלא

ראה: `MIGRATION_GUIDE.md` בשורש הפרויקט

---

📅 **נוצר**: 20 דצמבר 2025  
🗂️ **קבצים**: 51 BAT + 29 MD + 8 זמניים = 88 קבצים  
📦 **גודל**: ~500KB מסמכי טקסט


