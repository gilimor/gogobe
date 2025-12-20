@echo off
chcp 65001 >nul

echo ════════════════════════════════════════════════════════════
echo   יצירת Virtual Environment נקי
echo ════════════════════════════════════════════════════════════
echo.

REM השתמש ב-Python 3.9 שיש לך
set PYTHON="C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe"

echo 1️⃣ יוצר venv...
echo.
%PYTHON% -m venv venv

echo.
echo 2️⃣ מפעיל venv...
call venv\Scripts\activate.bat

echo.
echo 3️⃣ משדרג pip...
python -m pip install --upgrade pip

echo.
echo 4️⃣ מתקין חבילות...
pip install fastapi
pip install uvicorn
pip install psycopg2-binary
pip install requests
pip install pandas
pip install lxml

echo.
echo ════════════════════════════════════════════════════════════
echo   ✅ venv מוכן!
echo ════════════════════════════════════════════════════════════
echo.
echo מעכשיו תמיד תשתמש ב: START-VENV.bat
echo.
pause


