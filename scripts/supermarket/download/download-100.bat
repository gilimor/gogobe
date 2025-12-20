@echo off
chcp 65001 >nul
REM הורדת 100 קבצים

cd "%~dp0..\..\..\"

echo ════════════════════════════════════════════════════════════
echo   הורדת 100 קבצים
echo ════════════════════════════════════════════════════════════
echo.

python backend\scripts\kingstore_smart_downloader.py --limit 100 --parallel 15

echo.
echo ההורדה הושלמה
echo    זמן משוער: ~5-7 דקות
echo.
echo הצעד הבא:
echo    scripts\supermarket\process\process-files.bat
echo.
pause

