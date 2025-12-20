@echo off
chcp 65001 >nul
REM 🗑️ העברת קבצים ישנים ל-TRASH

echo ════════════════════════════════════════════════════════════
echo   🗑️ מעביר קבצים ישנים ל-TRASH
echo ════════════════════════════════════════════════════════════
echo.

REM יצירת תיקיות אם לא קיימות
if not exist "TRASH" mkdir "TRASH"
if not exist "TRASH\old-bat" mkdir "TRASH\old-bat"
if not exist "TRASH\old-docs" mkdir "TRASH\old-docs"
if not exist "TRASH\temp-files" mkdir "TRASH\temp-files"

echo 📦 מעביר קבצי BAT עם אמוג'י...
for %%f in (*.bat) do (
    echo %%f | findstr /R "🌟 🤖 🛒 🚀 ⚡ 🔥 🔄 🔍 🔎 🧪 🌐 ⏰ 📊 ⚙️" >nul
    if not errorlevel 1 (
        move "%%f" "TRASH\old-bat\" >nul 2>&1
        if not errorlevel 1 echo    ✓ %%f
    )
)

echo.
echo 📦 מעביר קבצי BAT ישנים נוספים...
if exist "run_gogobe*.bat" move "run_gogobe*.bat" "TRASH\old-bat\" >nul 2>&1
if exist "start_web*.bat" move "start_web*.bat" "TRASH\old-bat\" >nul 2>&1
if exist "setup_*.bat" move "setup_*.bat" "TRASH\old-bat\" >nul 2>&1
if exist "open_*.bat" move "open_*.bat" "TRASH\old-bat\" >nul 2>&1
if exist "export_*.bat" move "export_*.bat" "TRASH\old-bat\" >nul 2>&1
if exist "install_*.bat" move "install_*.bat" "TRASH\old-bat\" >nul 2>&1
if exist "start_docker.bat" move "start_docker.bat" "TRASH\old-bat\" >nul 2>&1
if exist "CLASSIFY_*.bat" move "CLASSIFY_*.bat" "TRASH\old-bat\" >nul 2>&1
if exist "UPDATE_*.bat" move "UPDATE_*.bat" "TRASH\old-bat\" >nul 2>&1
if exist "INSTALL_*.bat" move "INSTALL_*.bat" "TRASH\old-bat\" >nul 2>&1
if exist "run_simple_hybrid.bat" move "run_simple_hybrid.bat" "TRASH\old-bat\" >nul 2>&1
if exist "run_gogobe_direct.bat" move "run_gogobe_direct.bat" "TRASH\old-bat\" >nul 2>&1
if exist "refresh_*.bat" move "refresh_*.bat" "TRASH\old-bat\" >nul 2>&1

echo.
echo 📝 מעביר מסמכים עם אמוג'י...
for %%f in (*.md) do (
    echo %%f | findstr /R "🎯 🤖 🛒 🚀 ⚡ 🌐 ☁️ ✅ 🎉 🎊 📊 📋 📌 📚 📝 📥 🔄 🔧" >nul
    if not errorlevel 1 (
        move "%%f" "TRASH\old-docs\" >nul 2>&1
        if not errorlevel 1 echo    ✓ %%f
    )
)

echo.
echo 📝 מעביר מסמכים ישנים נוספים...
if exist "START_HERE.md" move "START_HERE.md" "TRASH\old-docs\" >nul 2>&1
if exist "START-HERE.md" move "START-HERE.md" "TRASH\old-docs\" >nul 2>&1
if exist "AUTOMATION_GUIDE.md" move "AUTOMATION_GUIDE.md" "TRASH\old-docs\" >nul 2>&1
if exist "QUICK_*.md" move "QUICK_*.md" "TRASH\old-docs\" >nul 2>&1
if exist "WORKING_*.md" move "WORKING_*.md" "TRASH\old-docs\" >nul 2>&1
if exist "WHAT_WE_*.md" move "WHAT_WE_*.md" "TRASH\old-docs\" >nul 2>&1
if exist "PDF_*.md" move "PDF_*.md" "TRASH\old-docs\" >nul 2>&1
if exist "RUN_*.md" move "RUN_*.md" "TRASH\old-docs\" >nul 2>&1
if exist "FIX_*.md" move "FIX_*.md" "TRASH\old-docs\" >nul 2>&1
if exist "DEVELOPMENT_*.md" move "DEVELOPMENT_*.md" "TRASH\old-docs\" >nul 2>&1
if exist "START_PDF_*.md" move "START_PDF_*.md" "TRASH\old-docs\" >nul 2>&1

echo.
echo 🗑️ מעביר קבצים זמניים...
if exist "check_kingstore_now.py" move "check_kingstore_now.py" "TRASH\temp-files\" >nul 2>&1
if exist "simple_db_check.py" move "simple_db_check.py" "TRASH\temp-files\" >nul 2>&1
if exist "create_folders.bat" move "create_folders.bat" "TRASH\temp-files\" >nul 2>&1
if exist "cleanup_project.bat" move "cleanup_project.bat" "TRASH\temp-files\" >nul 2>&1
if exist "TREE_*.txt" move "TREE_*.txt" "TRASH\temp-files\" >nul 2>&1

echo.
echo ═══════════════════════════════════════════════════════════
echo   ✅ ההעברה הושלמה!
echo ═══════════════════════════════════════════════════════════
echo.
echo 📂 הקבצים הישנים נמצאים ב:
echo    - TRASH\old-bat\        (קבצי BAT ישנים)
echo    - TRASH\old-docs\       (מסמכים ישנים)
echo    - TRASH\temp-files\     (קבצי זמניים)
echo.
echo 🎯 עכשיו השתמש בסקריפטים החדשים מ:
echo    - scripts\supermarket\
echo    - scripts\web\
echo    - scripts\database\
echo.
echo 💡 אם הכל עובד טוב, אפשר למחוק את תיקיית TRASH
echo    (רק אחרי שבדקת שהכל תקין!)
echo.
pause

