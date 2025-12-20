# ניתוח קבצים בשורש הפרויקט

## קבצים שצריך להעביר/למחוק

### 1. קבצי SQL ישנים (2015!) - 18MB!

#### Dump20150222.sql (7.9MB)
- **תאריך**: 22 פברואר 2015
- **גודל**: 7.9MB
- **מה זה**: גיבוי DB ישן מאוד (לפני 10 שנים!)
- **פעולה**: **העבר ל-archive/old-database/**

#### Prices20150706.sql (10.4MB)
- **תאריך**: 6 יולי 2015
- **גודל**: 10.4MB
- **מה זה**: גיבוי מחירים ישן (לפני 10 שנים!)
- **פעולה**: **העבר ל-archive/old-database/**

---

### 2. מסמכי ניקיון מיותרים

אלה הם מסמכים שיצרנו היום אבל יש כפילויות:

#### כפילויות להעביר ל-TRASH:
- `CLEANUP_COMPLETE.md` (דומה ל-FINAL_CLEANUP_REPORT)
- `CLEANUP_SUMMARY.md` (דומה ל-FINAL_CLEANUP_REPORT)
- `START_HERE_NEW.md` (יש לנו START_HERE.md)

#### תיעוד נוסף:
- `DATA_ORGANIZATION_PROPOSAL.md` → `docs/technical/`
- `PROJECT_REORGANIZATION_PLAN.md` → `docs/technical/`
- `REORGANIZATION_SUMMARY.md` → `docs/technical/`

---

### 3. הקבצים שצריכים להישאר בשורש

#### חיוניים:
- `README.md` - מדריך ראשי ✅
- `NEW_README.md` - README חדש (בעתיד יחליף את הישן)
- `START_HERE.md` - נקודת התחלה ✅
- `TODO_LIST.md` - משימות ✅
- `MIGRATION_GUIDE.md` - מדריך מעבר ✅
- `CODING_GUIDELINES.md` - חוקי קוד ✅
- `FINAL_CLEANUP_REPORT.md` - סיכום הניקיון ✅

#### תצורה:
- `requirements.txt` - תלויות Python ✅
- `docker-compose.yml` - Docker ✅
- `Dockerfile` - Docker ✅

---

## פעולות מומלצות

### שלב 1: העבר קבצי SQL ישנים

```bash
mkdir archive\old-database
move Dump20150222.sql archive\old-database\
move Prices20150706.sql archive\old-database\
```

**חיסכון: 18MB מהשורש!**

---

### שלב 2: העבר מסמכי כפילויות

```bash
move CLEANUP_COMPLETE.md TRASH\old-docs\
move CLEANUP_SUMMARY.md TRASH\old-docs\
move START_HERE_NEW.md TRASH\old-docs\
```

---

### שלב 3: העבר תיעוד טכני

```bash
move DATA_ORGANIZATION_PROPOSAL.md docs\technical\
move PROJECT_REORGANIZATION_PLAN.md docs\technical\
move REORGANIZATION_SUMMARY.md docs\technical\
```

---

## תוצאה סופית

### השורש יכיל רק:

```
README.md                       (10KB)  - מדריך ראשי
NEW_README.md                   (7.5KB) - README חדש
START_HERE.md                   (3.4KB) - נקודת התחלה
TODO_LIST.md                    (7.4KB) - משימות
MIGRATION_GUIDE.md              (12KB)  - מדריך מעבר
CODING_GUIDELINES.md            (2.6KB) - חוקי קוד
FINAL_CLEANUP_REPORT.md         (3.5KB) - סיכום
requirements.txt                (2KB)   - תלויות
docker-compose.yml              (0.5KB) - Docker
Dockerfile                      (0.5KB) - Docker
```

**סה"כ: 10 קבצים, ~50KB** (במקום 18 קבצים ו-18MB!)

---

## סיכום

### בעיות:
1. ❌ 2 קבצי SQL ענקיים מ-2015 (18MB!)
2. ❌ 3 מסמכים כפולים
3. ❌ 3 מסמכים טכניים שצריכים להיות ב-docs/

### פתרון:
1. ✅ העבר SQL ישנים ל-archive/old-database/
2. ✅ העבר כפילויות ל-TRASH/
3. ✅ העבר תיעוד טכני ל-docs/technical/

### תוצאה:
- השורש נקי ומסודר
- רק 10 קבצים חיוניים
- חיסכון של 18MB

---

תאריך: 20 דצמבר 2025

