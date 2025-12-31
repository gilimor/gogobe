@echo off
chcp 65001 >nul

set PYTHON39="C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe"

echo ════════════════════════════════════════════════════════════
echo   מתקין חבילות עם Python 3.9
echo ════════════════════════════════════════════════════════════
echo.

%PYTHON39% -m pip install --upgrade pip
%PYTHON39% -m pip install fastapi
%PYTHON39% -m pip install uvicorn
%PYTHON39% -m pip install psycopg2-binary
%PYTHON39% -m pip install requests
%PYTHON39% -m pip install pandas

echo.
echo ════════════════════════════════════════════════════════════
echo   ✅ הותקן!
echo ════════════════════════════════════════════════════════════
pause





