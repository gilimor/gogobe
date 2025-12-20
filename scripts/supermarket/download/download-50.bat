@echo off
chcp 65001 >nul
REM הורדת 50 קבצים מ-KingStore

echo ════════════════════════════════════════════════════════════
echo   הורדת 50 קבצים מ-KingStore
echo ════════════════════════════════════════════════════════════
echo.

REM עבור לתיקיית השורש
cd "%~dp0..\..\..\"

python backend\scripts\kingstore_smart_downloader.py --limit 50 --parallel 10

echo.
echo הורדה הושלמה
echo.
echo הצעד הבא:
echo    scripts\supermarket\process\process-files.bat
echo.
pause

