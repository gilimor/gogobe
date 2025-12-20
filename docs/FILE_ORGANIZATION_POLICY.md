# 📂 Gogobe - מדיניות ארגון קבצים

## תאריך: 20 דצמבר 2025

---

## 🎯 עקרונות יסוד

### 1. לפי מקור/חנות
כל חנות או מקור נתונים בספרייה נפרדת:
- `kingstore/` - KingStore
- `shufersal/` - שופרסל (עתיד)
- `rami-levi/` - רמי לוי (עתיד)

### 2. לפי תפקיד
הפרדה ברורה:
- `scripts/` - סקריפטים להרצה
- `docs/` - תיעוד ומדריכים
- `data/` - קבצי נתונים

### 3. README בכל תיקייה
כל ספרייה חייבת להכיל `README.md` שמסביר:
- מה יש בתיקייה
- איך להשתמש
- קישורים רלוונטיים

### 4. שורש נקי
רק קבצים חשובים:
- `START.bat`, `RUN.bat` - הפעלה
- `README.md` - מדריך ראשי
- `docker-compose.yml` - הגדרות
- ❌ לא קבצי תיעוד ארוכים
- ❌ לא סקריפטים ספציפיים

---

## 📋 מבנה הארגון

### Scripts:
```
scripts/
  ├── [STORE_NAME]/     ← לכל חנות
  │   ├── import.bat
  │   ├── download.bat
  │   └── README.md
  ├── general/          ← כלים כלליים
  ├── database/         ← DB operations
  └── processing/       ← עיבוד כללי
```

### Docs:
```
docs/
  ├── [STORE_NAME]/     ← תיעוד לכל חנות
  ├── user-guides/      ← מדריכי משתמש
  ├── setup/            ← התקנה
  └── technical/        ← תיעוד טכני
```

### Data:
```
data/
  └── [STORE_NAME]/
      ├── downloads/    ← מקוריים
      ├── processed/    ← מעובדים
      └── archive/      ← גיבויים
```

---

## ✅ חוקים

### DO (עשה):
- ✅ צור תיקייה חדשה לכל חנות/מקור
- ✅ שים קבצים במקום הלוגי שלהם
- ✅ הוסף README לכל תיקייה חדשה
- ✅ שמות תיקיות באנגלית קטנות עם מקף (`kebab-case`)
- ✅ שמור על ההיררכיה

### DON'T (אל תעשה):
- ❌ לא ליצור קבצים בשורש
- ❌ לא לערבב נושאים (KingStore עם Shufersal)
- ❌ לא לשים תיעוד ארוך בשורש
- ❌ לא להשתמש ב-emojis בשמות קבצים
- ❌ לא ליצור ספריות ללא README

---

## 🆕 הוספת חנות/מקור חדש

### תהליך:

1. **צור מבנה בסיסי:**
```bash
mkdir scripts\NEW_STORE
mkdir docs\NEW_STORE
mkdir data\NEW_STORE\downloads
mkdir data\NEW_STORE\processed
mkdir data\NEW_STORE\archive
```

2. **צור README בכל מקום:**
```bash
echo # NEW_STORE Scripts > scripts\NEW_STORE\README.md
echo # NEW_STORE Docs > docs\NEW_STORE\README.md
```

3. **העתק תבנית מ-KingStore:**
- מבנה קבצים
- סגנון תיעוד
- README templates

4. **עדכן README ראשי:**
- הוסף את החנות החדשה
- הוסף קישורים

---

## 📝 דוגמה: הוספת שופרסל

```bash
# 1. צור מבנה
mkdir scripts\shufersal
mkdir docs\shufersal
mkdir data\shufersal\downloads

# 2. צור README
echo # Shufersal Scripts > scripts\shufersal\README.md
echo # Shufersal Documentation > docs\shufersal\README.md

# 3. צור סקריפטים
# scripts\shufersal\import.bat
# scripts\shufersal\download.bat

# 4. צור תיעוד
# docs\shufersal\IMPORT_GUIDE.md
# docs\shufersal\DATA_STRUCTURE.md
```

---

## 🔍 איך לבדוק שארגנת נכון?

### שאל את עצמך:
1. ❓ האם הקובץ שייך לחנות ספציפית? → שים ב-`[STORE]/`
2. ❓ האם זה סקריפט? → `scripts/[STORE]/`
3. ❓ האם זה תיעוד? → `docs/[STORE]/`
4. ❓ האם זה נתונים? → `data/[STORE]/`
5. ❓ האם זה כללי? → `scripts/general/` או `docs/user-guides/`

### דוגמאות:
- ✅ `scripts/kingstore/import.bat` - נכון!
- ❌ `KINGSTORE_IMPORT.bat` - לא בשורש!
- ✅ `docs/kingstore/IMPORT_GUIDE.md` - נכון!
- ❌ `KINGSTORE_GUIDE.md` - לא בשורש!

---

## 💡 טיפים

1. **לפני שיוצרים קובץ** - חשוב איפה הוא שייך
2. **אחרי יצירת ספרייה** - צור README מיד
3. **כל חודש** - בדוק ש-README מעודכן
4. **לפני commit** - וודא שהכל במקומו

---

## 📚 קישורים

- [PROJECT_ORGANIZED.md](PROJECT_ORGANIZED.md) - הסבר המבנה הנוכחי
- [CODING_GUIDELINES.md](../CODING_GUIDELINES.md) - כללי קוד כלליים

---

תאריך: 20 דצמבר 2025  
גרסה: 1.0  
סטטוס: ✅ **מדיניות פעילה**

