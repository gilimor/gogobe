@echo off
chcp 65001 >nul
REM בדיקה מפורטת של מוצרים וסניפים

cd "%~dp0..\..\..\"

echo ════════════════════════════════════════════════════════════
echo   בדיקת מוצרים במספר סניפים
echo ════════════════════════════════════════════════════════════
echo.

python backend\scripts\quick_check_stores.py

echo.
echo הבדיקה הושלמה
echo.
pause

