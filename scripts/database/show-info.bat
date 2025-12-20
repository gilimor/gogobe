@echo off
chcp 65001 >nul
REM הצגת מידע על הנתונים ב-DB

echo ════════════════════════════════════════════════════════════
echo   מידע על מסד הנתונים
echo ════════════════════════════════════════════════════════════
echo.

REM עבור לתיקיית השורש של הפרויקט
cd "%~dp0..\.."

REM הרץ את הסקריפט
python backend\scripts\generate_status_report.py

echo.
pause

