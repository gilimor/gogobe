@echo off
chcp 65001 >nul
REM עיבוד קבצים שהורדו

cd "%~dp0..\..\..\"

echo ════════════════════════════════════════════════════════════
echo   עיבוד קבצים מהורדים
echo ════════════════════════════════════════════════════════════
echo.

python backend\scripts\kingstore_xml_processor.py

echo.
echo העיבוד הושלם
echo.
echo הצעד הבא:
echo    scripts\database\classify-categories.bat (סיווג אוטומטי)
echo    scripts\web\start-web.bat (צפה באתר)
echo.
pause

