@echo off
chcp 65001 >nul

echo ════════════════════════════════════════════════════════════
echo   📥 Universal Data Importer
echo ════════════════════════════════════════════════════════════
echo.
echo יבוא נתונים ממקורות שונים:
echo   • CSV Files
echo   • JSON Files
echo   • API Endpoints
echo.

cd /d "%~dp0\..\.."

echo מריץ את המייבא...
echo.

python scripts\processing\universal_data_importer.py

echo.
echo ════════════════════════════════════════════════════════════
pause

