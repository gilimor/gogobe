# 🗺️ מדריך מיפוי קבצים - ישן → חדש

מדריך זה מראה איפה כל קובץ ישן עבר במבנה החדש.

---

## 📋 קבצי BAT

### ✅ הורדה (Download)

| ישן | חדש | הערות |
|-----|-----|-------|
| `🧪 TEST_DOWNLOAD.bat` | `scripts/supermarket/download/download-10-test.bat` | טסט 10 קבצים |
| `🌟 DOWNLOAD_50_FAST.bat` | `scripts/supermarket/download/download-50.bat` | **מומלץ!** |
| `🛒 DOWNLOAD_50_FILES.bat` | `scripts/supermarket/download/download-50.bat` | **כפילות** - מאוחד |
| `🚀 FAST_DOWNLOAD_50.bat` | `scripts/supermarket/download/download-50.bat` | **כפילות** - מאוחד |
| `⚡ ULTRA_FAST_100.bat` | `scripts/supermarket/download/download-100.bat` | 100 קבצים |
| `🔥 DOWNLOAD_ALL_771.bat` | `scripts/supermarket/download/download-all-771.bat` | כל הקבצים |
| `🛒 DOWNLOAD_ALL_KINGSTORE.bat` | `scripts/supermarket/download/download-all-771.bat` | **כפילות** - מאוחד |

### ✅ עיבוד (Process)

| ישן | חדש | הערות |
|-----|-----|-------|
| `⚙️ PROCESS_DOWNLOADED_FILES.bat` | `scripts/supermarket/process/process-files.bat` | עיבוד קבצים |
| `⚡ PARALLEL_50_FILES.bat` | `scripts/supermarket/process/process-parallel-50.bat` | מקבילי 50 |
| `⚡ PARALLEL_AUTO_50.bat` | `scripts/supermarket/process/process-auto-50.bat` | אוטומטי 50 |
| `⚡ SUPER_FAST_50.bat` | `scripts/supermarket/process/process-parallel-50.bat` | **כפילות** |
| `⚡ PARALLEL_SIMPLE.bat` | `archive/old-scripts/` | ישן |
| `⚡ PARALLEL_TEST_10.bat` | `archive/old-scripts/` | ישן |

### ✅ אוטומציה (Automation)

| ישן | חדש | הערות |
|-----|-----|-------|
| `🤖 AUTO_PRICE_MANAGER.bat` | `scripts/supermarket/automation/price-manager.bat` | מנהל מחירים |
| `⏰ START_PRICE_SCHEDULER.bat` | `scripts/supermarket/automation/scheduler.bat` | תזמון |
| `🤖 AUTO_IMPORT_SUPERMARKET.bat` | `scripts/supermarket/automation/auto-import.bat` | ייבוא אוטומטי |
| `🤖 FULL_AUTO_KINGSTORE.bat` | `scripts/supermarket/automation/full-auto.bat` | **כל התהליך!** |
| `🛒 refresh_supermarket_data.bat` | `scripts/supermarket/automation/refresh-data.bat` | רענון נתונים |

### ✅ אתר (Web)

| ישן | חדש | הערות |
|-----|-----|-------|
| `🚀 START_WEB_SIMPLE.bat` | `scripts/web/start-web.bat` | **מומלץ!** |
| `🚀 START_WEB_WORKING.bat` | `scripts/web/start-web.bat` | **כפילות** - מאוחד |
| `🌐 START_WEBSITE.bat` | `scripts/web/start-web.bat` | **כפילות** - מאוחד |
| `start_web.bat` | `scripts/web/start-web.bat` | **כפילות** - מאוחד |
| `start_web_conda.bat` | `archive/old-scripts/` | ישן (Conda) |
| `start_web_conda_fixed.bat` | `archive/old-scripts/` | ישן (Conda) |
| `open_frontend.bat` | `scripts/web/open-browser.bat` | פתיחת דפדפן |
| `open_website.bat` | `scripts/web/open-browser.bat` | **כפילות** |

### ✅ מסד נתונים (Database)

| ישן | חדש | הערות |
|-----|-----|-------|
| `📊 SHOW_KINGSTORE_INFO.bat` | `scripts/database/show-info.bat` | סטטיסטיקות |
| `CLASSIFY_CATEGORIES.bat` | `scripts/database/classify-categories.bat` | סיווג |
| `🔄 UPDATE_PRICES_NOW.bat` | `scripts/database/update-prices.bat` | עדכון מחירים |
| `🔄 REIMPORT_WITH_STORES.bat` | `scripts/database/reimport-data.bat` | ייבוא מחדש |
| `UPDATE_STORE_NAMES.bat` | `scripts/database/update-store-names.bat` | עדכון שמות |

### ✅ התקנה (Setup)

| ישן | חדש | הערות |
|-----|-----|-------|
| `INSTALL_PYTHON_311.bat` | `scripts/setup/install-python.bat` | התקנת Python |
| `setup_gogobe_env.bat` | `scripts/setup/setup-environment.bat` | הגדרת סביבה |
| `install_web_requirements.bat` | `scripts/setup/install-web.bat` | Web dependencies |
| `install_web_smart.bat` | `scripts/setup/install-web.bat` | **כפילות** |
| `setup_conda_env.bat` | `archive/old-scripts/` | ישן (Conda) |
| `setup_conda_fixed.bat` | `archive/old-scripts/` | ישן (Conda) |
| `setup_direct.bat` | `archive/old-scripts/` | ישן |

### ✅ בדיקות (Testing)

| ישן | חדש | הערות |
|-----|-----|-------|
| `🔎 TEST_VISUAL.bat` | `scripts/testing/test-visual.bat` | טסט ויזואלי |
| `🔍 COUNT_AVAILABLE_FILES.bat` | `scripts/testing/count-files.bat` | ספירת קבצים |
| `🛒 TEST_KINGSTORE_10_FILES.bat` | `scripts/testing/test-kingstore-10.bat` | טסט 10 |
| `🛒 RUN_KINGSTORE_SCRAPER.bat` | `scripts/testing/run-scraper.bat` | הרצת סורק |

### ✅ ישן / לא בשימוש (Deprecated)

| ישן | חדש | הערות |
|-----|-----|-------|
| `run_gogobe.bat` | `archive/old-scripts/` | גרסה ישנה |
| `run_gogobe_v2.bat` | `archive/old-scripts/` | גרסה ישנה |
| `run_gogobe_v2_rescan.bat` | `archive/old-scripts/` | גרסה ישנה |
| `run_gogobe_v3_llm.bat` | `archive/old-scripts/` | גרסה ישנה |
| `run_gogobe_v4_hybrid.bat` | `archive/old-scripts/` | גרסה ישנה |
| `🤖 run_gogobe_v4_hybrid.bat` | `archive/old-scripts/` | **כפילות** |
| `run_gogobe_direct.bat` | `archive/old-scripts/` | גרסה ישנה |
| `run_simple_hybrid.bat` | `archive/old-scripts/` | גרסה ישנה |
| `start_docker.bat` | `archive/old-scripts/` | לא בשימוש |
| `export_to_excel.bat` | `archive/old-scripts/` | ישן |

---

## 📚 קבצי תיעוד (MD)

### ✅ מדריכים (Guides)

| ישן | חדש | הערות |
|-----|-----|-------|
| `🎯 START_HERE.md` | `docs/guides/getting-started.md` | **התחלה!** |
| `START-HERE.md` | `docs/guides/getting-started.md` | **כפילות** |
| `QUICK_RUN.md` | `docs/guides/quick-reference.md` | קיצורי דרך |
| `📌 START_HERE_PDF.md` | `docs/guides/pdf-scanning.md` | PDF |
| `START_PDF_SCANNING.md` | `docs/guides/pdf-scanning.md` | **כפילות** |
| `PDF_SCANNING_READY.md` | `docs/guides/pdf-scanning.md` | **כפילות** |
| `PDF_SCANNER_FILES.md` | `docs/guides/pdf-scanning.md` | **כפילות** |
| `🛒 SUPERMARKET_INTEGRATION.md` | `docs/guides/supermarket-guide.md` | סופרמרקטים |
| `📥 DOWNLOAD_GUIDE.md` | `docs/guides/download-guide.md` | הורדה |
| `📥 MANUAL_DOWNLOAD_GUIDE.md` | `docs/guides/manual-download.md` | הורדה ידנית |
| `🤖 AUTOMATION_GUIDE.md` | `docs/guides/automation-guide.md` | **אוטומציה!** |
| `AUTOMATION_GUIDE.md` | `docs/guides/automation-guide.md` | **כפילות** |
| `🤖 AUTO_START.md` | `docs/guides/automation-guide.md` | **כפילות** |
| `🌐 WEBSITE_GUIDE.md` | `docs/guides/web-guide.md` | אתר |
| `📊 TABLE_VIEW_GUIDE.md` | `docs/guides/web-guide.md` | **כפילות** |
| `RUN_BATCH_IN_COLAB.md` | `docs/guides/colab-batch.md` | Colab |
| `☁️ COLAB_SERVER.md` | `docs/guides/colab-server.md` | Colab Server |

### ✅ התקנה (Setup Guides)

| ישן | חדש | הערות |
|-----|-----|-------|
| `📥 INSTALL_DOCKER.md` | `docs/guides/setup/install-docker.md` | Docker |
| `📥 INSTALL_OLLAMA.md` | `docs/guides/setup/install-ollama.md` | Ollama |
| `FIX_PYTHON.md` | `docs/guides/setup/fix-python.md` | תיקון Python |
| `🚀 PRODUCTION_SETUP.md` | `docs/guides/setup/production.md` | Production |

### ✅ תיעוד טכני (Technical)

| ישן | חדש | הערות |
|-----|-----|-------|
| `📊 DATABASE_STRUCTURE.md` | `docs/technical/database-structure.md` | **חשוב!** |
| `📊 ERROR_MONITOR_GUIDE.md` | `docs/technical/error-monitoring.md` | שגיאות |
| `📋 SOURCE_TRACKING_GUIDE.md` | `docs/technical/source-tracking.md` | מעקב מקורות |
| `🎯 HYBRID_CLASSIFICATION_GUIDE.md` | `docs/technical/classification.md` | סיווג |
| `📚 PARALLEL_GUIDE.md` | `docs/technical/parallel-processing.md` | מקבילי |

### ✅ היסטוריה (Changelog)

| ישן | חדש | הערות |
|-----|-----|-------|
| `✅ SUCCESS.md` | `docs/changelog/success-stories.md` | הצלחות |
| `✅ SUPERMARKET_POC_SUCCESS.md` | `docs/changelog/success-stories.md` | **כפילות** |
| `✅ FIXED_AND_WORKING.md` | `docs/changelog/fixes.md` | תיקונים |
| `🔧 FIX_AND_RUN.md` | `docs/changelog/fixes.md` | **כפילות** |
| `📚 COMPLETE_SUMMARY.md` | `docs/changelog/complete-summary.md` | סיכום מלא |
| `🎉 FINAL_SUMMARY.md` | `docs/changelog/final-summary.md` | סיכום סופי |
| `🎊 FINAL_FINAL_SUMMARY.md` | `docs/changelog/final-summary.md` | **כפילות** |
| `📝 SUMMARY_FIXES.md` | `docs/changelog/summary-fixes.md` | סיכום תיקונים |
| `WHAT_WE_BUILT.md` | `docs/changelog/what-we-built.md` | מה בנינו |
| `🎉 WEBSITE_READY.md` | `docs/changelog/website-ready.md` | אתר מוכן |

### ✅ ישן / לא בשימוש

| ישן | חדש | הערות |
|-----|-----|-------|
| `⚡ START_HYBRID.md` | `archive/deprecated-docs/` | ישן |
| `⚡ START_LOCAL.md` | `archive/deprecated-docs/` | ישן |
| `🚀 SIMPLE_SOLUTION.md` | `archive/deprecated-docs/` | ישן |

---

## 📄 קבצים שנשארים בשורש

### ✅ נשאר כמו שהיה (אבל עודכן)

| קובץ | הערות |
|------|-------|
| `README.md` | **עודכן!** - README חדש ומסודר |
| `requirements.txt` | Dependencies - לא משנים |
| `docker-compose.yml` | Docker config - לא משנים |
| `Dockerfile` | Docker image - לא משנים |
| `.gitignore` | Git config - לא משנים |

### ✅ קבצים חדשים שנוספו

| קובץ | מטרה |
|------|------|
| `NEW_README.md` | README חדש (יחליף את הישן) |
| `MIGRATION_GUIDE.md` | המדריך הזה! |
| `PROJECT_REORGANIZATION_PLAN.md` | תוכנית הסידור |
| `create_folders.bat` | סקריפט יצירת תיקיות |

---

## 🎯 סיכום השינויים

### סטטיסטיקות:

```
קבצי BAT בשורש:
  לפני:  60+ קבצים 😱
  אחרי:  0 קבצים ✅
  
קבצי MD בשורש:
  לפני:  35+ קבצים 😱
  אחרי:  5 קבצים ✅ (רק חיוניים)
  
תיקיות חדשות:
  ✅ scripts/     (כל ה-BAT)
  ✅ docs/        (כל התיעוד)
  ✅ archive/     (ישן)
```

### תיקיות שנוצרו:

```
📁 scripts/
   ├── setup/
   ├── supermarket/download/
   ├── supermarket/process/
   ├── supermarket/automation/
   ├── web/
   ├── database/
   └── testing/

📁 docs/
   ├── guides/setup/
   ├── technical/
   └── changelog/

📁 archive/
   ├── old-scripts/
   └── deprecated-docs/
```

---

## 💡 איך להשתמש במדריך?

### אם אתה מחפש קובץ ישן:

1. חפש בטבלאות למעלה את השם הישן
2. ראה איפה הוא עבר
3. השתמש בנתיב החדש

### אם כתבת סקריפט שקורא לקבצים ישנים:

1. עדכן את כל הנתיבים לפי הטבלאות
2. בדוק ש-relative paths נכונים
3. טסט שהכל עובד

### דוגמה:

```batch
REM ישן:
call "🌟 DOWNLOAD_50_FAST.bat"

REM חדש:
call "scripts\supermarket\download\download-50.bat"
```

---

## 🔄 מה לעשות עם הקבצים הישנים?

### אופציה 1: גיבוי והעברה (מומלץ)

```bash
# 1. גבה את הישן
xcopy *.bat archive\old-scripts\ /E /I
xcopy *.md archive\deprecated-docs\ /E /I

# 2. מחק מהשורש (רק אחרי ווידוא!)
del *.bat
del *.md (חוץ מ-README.md ו-NEW_README.md)

# 3. שנה שם ל-README החדש
move NEW_README.md README.md
```

### אופציה 2: מעבר הדרגתי

השאר את הישן, הוסף את החדש, מחק הדרגתי.

---

**📖 שאלות?** פתח issue או ראה `docs/guides/`





