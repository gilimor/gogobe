# 🔍 Gogobe - מערכת השוואת מחירים חכמה

> מערכת מתקדמת להשוואת מחירים ממקורות מרובים, עם אוטומציה מלאה ועיבוד מקבילי

[![Python 3.11+](https://img.shields.io/badge/python-3.11+-blue.svg)](https://www.python.org/downloads/)
[![PostgreSQL](https://img.shields.io/badge/postgresql-13+-316192.svg)](https://www.postgresql.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.109-009688.svg)](https://fastapi.tiangolo.com/)

---

## ✨ תכונות

- 🤖 **אוטומציה מלאה** - רץ ללא התערבות אנושית
- ⚡ **מהיר** - עיבוד מקבילי של אלפי מוצרים
- 🌍 **רב-לשוני** - תמיכה בעברית, אנגלית, ערבית, רוסית
- 🏷️ **סיווג חכם** - קטגוריזציה אוטומטית ללא AI יקר
- 📊 **מנורמל** - מסד נתונים אופטימלי (חיסכון 92%)
- 📦 **מודולרי** - קל להוסיף מקורות חדשים

---

## 🚀 התחלה מהירה (5 דקות)

### 1. התקנה

```bash
# התקן Python 3.11
scripts\setup\install-python.bat

# התקן dependencies
scripts\setup\setup-environment.bat
```

### 2. הורד נתונים

```bash
# הורד 50 קבצים מ-KingStore (מומלץ להתחלה!)
scripts\supermarket\download\download-50.bat
```

### 3. הפעל אתר

```bash
# הפעל שרת Web
scripts\web\start-web.bat

# פתח דפדפן: http://localhost:8000
```

**זהו! יש לך אתר השוואת מחירים עובד! 🎉**

---

## 📊 מה המערכת עושה?

### תחום סופרמרקטים 🛒
```
הורדה → עיבוד → סיווג → הצגה
  ↓         ↓        ↓        ↓
771      XML→DB   17 קטגוריות  Web UI
קבצים  אוטומטי  רב-לשוניות   מהיר
```

**נתונים נוכחיים**:
- ✅ 14,527 מוצרים פעילים
- ✅ 13,458 מחירים
- ✅ 27 חנויות/סניפים
- ✅ 17 קטגוריות
- ✅ 60% מסווגים אוטומטית

### תחום דנטלי 🦷
```
PDF → סריקה → חילוץ → DB
 ↓       ↓        ↓      ↓
מגזין  טקסט  מוצרים  מחירים
```

**כלי**: Google Colab Notebook (חינמי!)

---

## 📂 מבנה הפרויקט

```
Gogobe/
├── 📚 docs/              # כל התיעוד
│   ├── guides/           # מדריכי שימוש
│   ├── technical/        # תיעוד טכני
│   └── changelog/        # היסטוריה
│
├── 🔧 scripts/           # סקריפטי הפעלה
│   ├── setup/            # התקנה
│   ├── supermarket/      # סופרמרקטים
│   ├── web/              # אתר
│   ├── database/         # DB
│   └── testing/          # בדיקות
│
├── 🗄️ backend/           # Backend
│   ├── api/              # FastAPI
│   ├── scripts/          # Python scripts
│   ├── database/         # SQL schemas
│   └── data/             # נתונים
│
└── 🌐 frontend/          # Frontend
    ├── index.html
    ├── app.js
    └── styles.css
```

📖 **למידע מפורט**: [`docs/README.md`](docs/README.md)

---

## 🎯 קיצורי דרך

### התקנה ראשונית (פעם אחת)
```bash
scripts\setup\install-python.bat
scripts\setup\setup-environment.bat
```

### סופרמרקטים
```bash
# הורדה
scripts\supermarket\download\download-50.bat          # 50 קבצים (מומלץ)
scripts\supermarket\download\download-all-771.bat     # הכל

# אוטומציה מלאה
scripts\supermarket\automation\full-auto.bat          # הכל בקליק אחד
scripts\supermarket\automation\scheduler.bat          # תזמון אוטומטי
```

### אתר
```bash
scripts\web\start-web.bat        # הפעל שרת
scripts\web\open-browser.bat     # פתח דפדפן
```

### מסד נתונים
```bash
scripts\database\show-info.bat            # סטטיסטיקות
scripts\database\classify-categories.bat  # סיווג אוטומטי
```

---

## 🌟 תכונות מתקדמות

### 🤖 אוטומציה מלאה
- הורדה אוטומטית ממקורות מרובים
- עיבוד מקבילי (Multi-Processing)
- סיווג רב-לשוני
- תזמון חכם

### ⚡ ביצועים
```
הורדה:  50 קבצים ב-2 דקות
עיבוד:  ~3 דקות (15,000 מוצרים)
סיווג:  ~110 מוצרים/שנייה
DB:      52 MB (מנורמל!)
```

### 🌍 תמיכה רב-לשונית
```python
'Dairy': {
    'he': ['חלב', 'גבינה', 'יוגורט'],
    'en': ['milk', 'cheese', 'yogurt'],
    'ar': ['حليب', 'جبن'],
    'ru': ['молоко', 'сыр'],
    'brands': ['תנובה', 'tnuva', 'שטראוס']
}
```

---

## 📖 תיעוד

| מסמך | תיאור |
|------|-------|
| [`docs/guides/getting-started.md`](docs/guides/getting-started.md) | התחלה מהירה ⭐ |
| [`docs/guides/supermarket-guide.md`](docs/guides/supermarket-guide.md) | מדריך סופרמרקטים |
| [`docs/technical/database-structure.md`](docs/technical/database-structure.md) | מבנה DB |
| [`docs/guides/automation-guide.md`](docs/guides/automation-guide.md) | אוטומציה |
| [`scripts/README.md`](scripts/README.md) | סקריפטים |

**📚 כל התיעוד**: [`docs/`](docs/)

---

## 🔧 דרישות מערכת

- **Python**: 3.11+
- **PostgreSQL**: 13+
- **RAM**: 4GB (מינימום)
- **CPU**: Multi-core (מומלץ)
- **OS**: Windows 10/11

---

## 🆘 בעיות נפוצות

### Python לא עובד?
```bash
python --version  # צריך להדפיס 3.11.x
```
👉 ראה: `docs/guides/setup/install-python.md`

### PostgreSQL לא מחובר?
```bash
scripts\database\show-info.bat  # בדוק חיבור
```
👉 ראה: `docs/technical/database-structure.md`

### האתר לא נפתח?
```bash
# וודא שה-API רץ:
scripts\web\start-web.bat
```
👉 ראה: `docs/guides/web-guide.md`

---

## 🛠️ טכנולוגיות

- **Backend**: Python 3.11, FastAPI, PostgreSQL
- **Frontend**: HTML5, CSS3, Vanilla JS
- **Processing**: Multi-Processing, Multi-Threading
- **Classification**: Keyword-based (4 languages)
- **Data**: XML, JSON, CSV, PDF

---

## 📈 Roadmap

### ✅ Done
- [x] מבנה DB מנורמל
- [x] API מלא
- [x] Frontend נקי
- [x] סיווג אוטומטי
- [x] עיבוד מקבילי
- [x] תזמון אוטומטי
- [x] תמיכה רב-לשונית

### 🚧 בעבודה
- [ ] Dashboard ניהול
- [ ] Grafana monitoring
- [ ] Docker support

### 💡 עתיד
- [ ] LLM classification (Ollama)
- [ ] Price predictions
- [ ] Alert system
- [ ] Mobile app

---

## 🤝 תרומה

אנחנו מזמינים תרומות! ראה [`CONTRIBUTING.md`](CONTRIBUTING.md)

---

## 📜 רישיון

MIT License - ראה [`LICENSE`](LICENSE)

---

## 🙏 תודות

תודה לכל הספריות והכלים:
- FastAPI, PostgreSQL, psycopg2, pdfplumber, pandas

---

<div align="center">

**⭐ אם המערכת עזרה לך, תן כוכב ב-GitHub! ⭐**

Made with ❤️ in Israel

[תיעוד](docs/) · [סקריפטים](scripts/) · [API Docs](http://localhost:8000/docs)

</div>

