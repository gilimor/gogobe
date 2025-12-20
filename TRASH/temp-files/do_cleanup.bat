@echo off
setlocal enabledelayedexpansion

echo ════════════════════════════════════════════════════════════
echo   מעביר קבצים ל-TRASH...
echo ════════════════════════════════════════════════════════════
echo.

set count=0

REM העברת כל קבצי BAT בשורש (חוץ מהסקריפט הזה)
echo מעביר קבצי BAT...
for %%f in (*.bat) do (
    if not "%%f"=="do_cleanup.bat" (
        if not "%%f"=="move_to_trash.bat" (
            echo    %%f
            move "%%f" "TRASH\old-bat\" >nul 2>&1
            set /a count+=1
        )
    )
)

echo.
echo מעביר קבצי MD ישנים...

REM רשימה מפורשת של קבצים
move "START_HERE.md" "TRASH\old-docs\" >nul 2>&1
move "START-HERE.md" "TRASH\old-docs\" >nul 2>&1
move "AUTOMATION_GUIDE.md" "TRASH\old-docs\" >nul 2>&1
move "DEVELOPMENT_GUIDELINES.md" "TRASH\old-docs\" >nul 2>&1
move "FIX_PYTHON.md" "TRASH\old-docs\" >nul 2>&1
move "PDF_SCANNER_FILES.md" "TRASH\old-docs\" >nul 2>&1
move "PDF_SCANNING_READY.md" "TRASH\old-docs\" >nul 2>&1
move "QUICK_CHECKLIST.md" "TRASH\old-docs\" >nul 2>&1
move "QUICK_RUN.md" "TRASH\old-docs\" >nul 2>&1
move "RUN_BATCH_IN_COLAB.md" "TRASH\old-docs\" >nul 2>&1
move "START_PDF_SCANNING.md" "TRASH\old-docs\" >nul 2>&1
move "WORKING_SYSTEM.md" "TRASH\old-docs\" >nul 2>&1
move "WHAT_WE_BUILT.md" "TRASH\old-docs\" >nul 2>&1

REM קבצים זמניים
move "check_kingstore_now.py" "TRASH\temp-files\" >nul 2>&1
move "simple_db_check.py" "TRASH\temp-files\" >nul 2>&1
move "create_folders.bat" "TRASH\temp-files\" >nul 2>&1
move "cleanup_project.bat" "TRASH\temp-files\" >nul 2>&1
move "TREE_SCRIPTS.txt" "TRASH\temp-files\" >nul 2>&1
move "TREE_DOCS.txt" "TRASH\temp-files\" >nul 2>&1

echo.
echo ✅ הושלם! העברתי %count% קבצים
echo.
echo הקבצים נמצאים ב-TRASH\
echo אם הכל עובד טוב - אפשר למחוק את TRASH
echo.
pause

