@echo off
echo ==========================================
echo  Gogobe Direct Setup (No venv)
echo ==========================================
echo.

cd /d "%~dp0"

set PYTHON=C:\Users\shake\AppData\Local\Programs\Python\Python311\python.exe
set PYTHONPATH=
set PYTHONHOME=

echo Using Python 3.11 directly...
"%PYTHON%" --version
echo.

echo Installing packages to Python 3.11...
"%PYTHON%" -m pip install --upgrade pip
"%PYTHON%" -m pip install pdfplumber pandas openpyxl psycopg2-binary
echo.

echo ==========================================
echo ✅ Setup Complete!
echo ==========================================
echo.
echo Python 3.11 is ready with all packages!
echo.
echo To run Gogobe automation:
echo    run_gogobe_direct.bat
echo.
pause





