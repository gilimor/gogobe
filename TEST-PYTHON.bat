@echo off
chcp 65001 >nul

echo ════════════════════════════════════════════════════════════
echo   בדיקת Python 3.9
echo ════════════════════════════════════════════════════════════
echo.

set PYTHON39="C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe"

echo מנסה Python 3.9...
echo.

%PYTHON39% --version 2>nul

if errorlevel 1 (
    echo ❌ Python 3.9 לא עובד
    goto :END
)

echo.
echo ✅ Python 3.9 עובד!
echo.
echo בודק אם יש uvicorn...
%PYTHON39% -c "import uvicorn" 2>nul

if errorlevel 1 (
    echo ❌ uvicorn לא מותקן
    echo.
    echo רוצה להתקין? (כן/לא)
    choice /C YN /M "התקן"
    if errorlevel 2 goto :END
    
    echo מתקין...
    %PYTHON39% -m pip install fastapi uvicorn psycopg2-binary
)

echo.
echo ✅ הכל מוכן!
echo.

:END
pause





