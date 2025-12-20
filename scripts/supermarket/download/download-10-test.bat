@echo off
chcp 65001 >nul
REM טסט - הורדת 10 קבצים

cd "%~dp0..\..\..\"

echo ════════════════════════════════════════════════════════════
echo   טסט - הורדת 10 קבצים
echo ════════════════════════════════════════════════════════════
echo.

python backend\scripts\kingstore_smart_downloader.py --limit 10 --parallel 5

echo.
echo הטסט הושלם
echo.
pause

