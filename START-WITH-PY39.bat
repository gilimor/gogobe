@echo off
chcp 65001 >nul

set PYTHON39="C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe"

echo ════════════════════════════════════════════════════════════
echo   Gogobe - עם Python 3.9
echo ════════════════════════════════════════════════════════════
echo.

echo בודק Python 3.9...
%PYTHON39% --version

echo.
echo מפעיל את השרת...
echo   http://localhost:8000
echo.
echo לעצירה: Ctrl+C
echo ════════════════════════════════════════════════════════════
echo.

start /B cmd /c "timeout /t 5 >nul && start http://localhost:8000"

cd backend\api
%PYTHON39% -m uvicorn main:app --reload --host 0.0.0.0 --port 8000


