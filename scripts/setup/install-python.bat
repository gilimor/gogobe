@echo off
chcp 65001 >nul
REM התקנת Python 3.11

echo ════════════════════════════════════════════════════════════
echo   התקנת Python 3.11
echo ════════════════════════════════════════════════════════════
echo.

echo מוריד את Python 3.11.9...
echo.

curl -o python-3.11.9-amd64.exe https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe

if errorlevel 1 (
    echo ההורדה נכשלה
    echo.
    echo נסה להוריד ידנית:
    echo https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe
    pause
    exit /b 1
)

echo.
echo Python הורד בהצלחה
echo.
echo עכשיו:
echo    1. הרץ את python-3.11.9-amd64.exe
echo    2. סמן "Add Python to PATH"
echo    3. לחץ "Install Now"
echo.
echo    אחרי ההתקנה:
echo    scripts\setup\setup-environment.bat
echo.
pause

