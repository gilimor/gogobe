@echo off
setlocal enabledelayedexpansion

echo ════════════════════════════════════════════════════════════
echo   מעביר מסמכים ישנים ל-TRASH...
echo ════════════════════════════════════════════════════════════
echo.

set count=0

echo מעביר קבצי MD עם אמוג'י וישנים...

REM קבצים שכבר זוהו
move "COLAB_SERVER.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "START_HYBRID.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "START_LOCAL.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "FIXED_AND_WORKING.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "SUCCESS.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "SUPERMARKET_POC_SUCCESS.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "WEBSITE_GUIDE.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "FINAL_SUMMARY.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "WEBSITE_READY.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "FINAL_FINAL_SUMMARY.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "HYBRID_CLASSIFICATION_GUIDE.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "START_HERE.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "DATABASE_STRUCTURE.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "ERROR_MONITOR_GUIDE.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "TABLE_VIEW_GUIDE.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "SOURCE_TRACKING_GUIDE.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "START_HERE_PDF.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "COMPLETE_SUMMARY.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "PARALLEL_GUIDE.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "SUMMARY_FIXES.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "DOWNLOAD_GUIDE.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "INSTALL_DOCKER.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "INSTALL_OLLAMA.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "MANUAL_DOWNLOAD_GUIDE.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "PRODUCTION_SETUP.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "SIMPLE_SOLUTION.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "SUPERMARKET_INTEGRATION.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "AUTOMATION_GUIDE.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "AUTO_START.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1

REM מסמכים נוספים שזוהו בעבר
move "START-HERE.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "DEVELOPMENT_GUIDELINES.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "FIX_PYTHON.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "PDF_SCANNER_FILES.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "PDF_SCANNING_READY.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "QUICK_CHECKLIST.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "QUICK_RUN.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "RUN_BATCH_IN_COLAB.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "START_PDF_SCANNING.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "WORKING_SYSTEM.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1
move "WHAT_WE_BUILT.md" "TRASH\old-docs\" >nul 2>&1 && set /a count+=1

REM העבר גם את הסקריפטים שיצרנו לניקיון
move "move_to_trash.bat" "TRASH\temp-files\" >nul 2>&1
move "CLEANUP_GUIDE.md" "TRASH\temp-files\" >nul 2>&1

echo.
echo ✅ העברתי %count% מסמכים נוספים
echo.
echo הקבצים נמצאים ב-TRASH\old-docs\
echo.
pause

