@echo off
chcp 65001 >nul
REM סיווג אוטומטי של מוצרים

cd "%~dp0..\..\..\"

echo ════════════════════════════════════════════════════════════
echo   סיווג אוטומטי - 17 קטגוריות
echo ════════════════════════════════════════════════════════════
echo.
echo הסיווג יעבד את כל המוצרים ללא קטגוריה
echo זמן משוער: 2-3 דקות
echo.

python backend\scripts\parallel_multilang_classifier.py --vertical supermarket --workers 4

echo.
echo הסיווג הושלם
echo.
pause

