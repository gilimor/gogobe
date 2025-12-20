@echo off
chcp 65001 >nul
REM הגדרת סביבת עבודה

cd "%~dp0..\..\..\"

echo ════════════════════════════════════════════════════════════
echo   מגדיר סביבת עבודה
echo ════════════════════════════════════════════════════════════
echo.

echo מתקין dependencies...
echo.

pip install --upgrade pip
pip install -r requirements.txt

if errorlevel 1 (
    echo.
    echo ההתקנה נכשלה
    echo    בדוק שPython 3.11 מותקן נכון
    pause
    exit /b 1
)

echo.
echo כל ה-Dependencies מותקנים
echo.
echo הצעד הבא:
echo    scripts\web\start-web.bat
echo.
pause

