@echo off
chcp 65001 >nul
REM הורדת כל הקבצים הזמינים

cd "%~dp0..\..\..\"

echo ════════════════════════════════════════════════════════════
echo   הורדת כל הקבצים הזמינים (771)
echo ════════════════════════════════════════════════════════════
echo.
echo אזהרה: זה יקח ~15-20 דקות
echo.
choice /C YN /M "האם להמשיך"
if errorlevel 2 exit /b

python backend\scripts\kingstore_smart_downloader.py --parallel 20

echo.
echo כל הקבצים הורדו
echo    סה"כ צפוי: ~230,000 מוצרים
echo.
echo הצעד הבא:
echo    scripts\supermarket\process\process-files.bat
echo.
pause

