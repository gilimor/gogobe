@echo off
chcp 65001 >nul
REM 🧹 סקריפט לניקיון - מעביר קבצים ישנים ל-archive

echo ════════════════════════════════════════════════════════════
echo   🧹 ניקיון הפרויקט - העברת קבצים ישנים
echo ════════════════════════════════════════════════════════════
echo.
echo מעביר קבצי BAT ישנים מהשורש ל-archive\old-scripts\
echo.

REM יצירת תיקייה אם לא קיימת
if not exist "archive\old-scripts" mkdir "archive\old-scripts"
if not exist "archive\deprecated-docs" mkdir "archive\deprecated-docs"

echo 📦 מעביר קבצי BAT...
move "🌟*.bat" "archive\old-scripts\" 2>nul
move "🤖*.bat" "archive\old-scripts\" 2>nul
move "🛒*.bat" "archive\old-scripts\" 2>nul
move "🚀*.bat" "archive\old-scripts\" 2>nul
move "⚡*.bat" "archive\old-scripts\" 2>nul
move "🔥*.bat" "archive\old-scripts\" 2>nul
move "🔄*.bat" "archive\old-scripts\" 2>nul
move "🔍*.bat" "archive\old-scripts\" 2>nul
move "🔎*.bat" "archive\old-scripts\" 2>nul
move "🧪*.bat" "archive\old-scripts\" 2>nul
move "🌐*.bat" "archive\old-scripts\" 2>nul
move "⏰*.bat" "archive\old-scripts\" 2>nul
move "📊*.bat" "archive\old-scripts\" 2>nul

REM עוד BAT ישנים
move "run_gogobe*.bat" "archive\old-scripts\" 2>nul
move "start_web*.bat" "archive\old-scripts\" 2>nul
move "setup_*.bat" "archive\old-scripts\" 2>nul
move "open_*.bat" "archive\old-scripts\" 2>nul
move "export_*.bat" "archive\old-scripts\" 2>nul
move "CLASSIFY_*.bat" "archive\old-scripts\" 2>nul
move "UPDATE_*.bat" "archive\old-scripts\" 2>nul

echo.
echo 📝 מעביר מסמכים ישנים...
move "🎯*.md" "archive\deprecated-docs\" 2>nul
move "🤖*.md" "archive\deprecated-docs\" 2>nul
move "🛒*.md" "archive\deprecated-docs\" 2>nul
move "🚀*.md" "archive\deprecated-docs\" 2>nul
move "⚡*.md" "archive\deprecated-docs\" 2>nul
move "🌐*.md" "archive\deprecated-docs\" 2>nul
move "☁️*.md" "archive\deprecated-docs\" 2>nul
move "✅*.md" "archive\deprecated-docs\" 2>nul
move "🎉*.md" "archive\deprecated-docs\" 2>nul
move "🎊*.md" "archive\deprecated-docs\" 2>nul
move "📊*.md" "archive\deprecated-docs\" 2>nul
move "📋*.md" "archive\deprecated-docs\" 2>nul
move "📌*.md" "archive\deprecated-docs\" 2>nul
move "📚*.md" "archive\deprecated-docs\" 2>nul
move "📝*.md" "archive\deprecated-docs\" 2>nul
move "📥*.md" "archive\deprecated-docs\" 2>nul
move "🔄*.md" "archive\deprecated-docs\" 2>nul
move "🔧*.md" "archive\deprecated-docs\" 2>nul

REM מסמכים נוספים
move "START_HERE.md" "archive\deprecated-docs\" 2>nul
move "START-HERE.md" "archive\deprecated-docs\" 2>nul
move "AUTOMATION_GUIDE.md" "archive\deprecated-docs\" 2>nul
move "QUICK_*.md" "archive\deprecated-docs\" 2>nul
move "WORKING_*.md" "archive\deprecated-docs\" 2>nul
move "WHAT_WE_*.md" "archive\deprecated-docs\" 2>nul
move "PDF_*.md" "archive\deprecated-docs\" 2>nul
move "RUN_*.md" "archive\deprecated-docs\" 2>nul
move "FIX_*.md" "archive\deprecated-docs\" 2>nul
move "DEVELOPMENT_*.md" "archive\deprecated-docs\" 2>nul

echo.
echo 🗑️  מסירים קבצי זמניים...
del check_kingstore_now.py 2>nul
del simple_db_check.py 2>nul
del create_folders.bat 2>nul
del TREE_*.txt 2>nul

echo.
echo ✅ ניקיון הושלם!
echo.
echo 📂 הקבצים הישנים נמצאים ב:
echo    - archive\old-scripts\     (BAT ישנים)
echo    - archive\deprecated-docs\ (מסמכים ישנים)
echo.
echo 🎯 עכשיו השתמש בסקריפטים החדשים מ:
echo    - scripts\supermarket\
echo    - scripts\web\
echo    - scripts\database\
echo.
pause

