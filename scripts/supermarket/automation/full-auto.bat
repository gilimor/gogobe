@echo off
chcp 65001 >nul
REM אוטומציה מלאה - הורדה + עיבוד + סיווג

cd "%~dp0..\..\..\"

echo ════════════════════════════════════════════════════════════
echo   אוטומציה מלאה - כל התהליך
echo ════════════════════════════════════════════════════════════
echo.

python backend\scripts\auto_price_manager.py --once --source kingstore

echo.
echo כל התהליך הושלם
echo.
echo צפה בתוצאות:
echo    scripts\web\start-web.bat
echo.
pause

