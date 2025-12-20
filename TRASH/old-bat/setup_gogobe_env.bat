@echo off
echo ==========================================
echo  Gogobe Environment Setup
echo ==========================================
echo.

cd /d "%~dp0"

echo Checking Python version...
"C:\Users\shake\AppData\Local\Programs\Python\Python311\python.exe" --version
echo.

echo Creating virtual environment...
"C:\Users\shake\AppData\Local\Programs\Python\Python311\python.exe" -m venv venv_gogobe
echo.

echo Activating virtual environment...
call venv_gogobe\Scripts\activate.bat
echo.

echo Installing required packages...
pip install --upgrade pip
pip install pdfplumber pandas openpyxl psycopg2-binary
echo.

echo ==========================================
echo ✅ Setup Complete!
echo ==========================================
echo.
echo To use Gogobe automation:
echo.
echo 1. Activate environment:
echo    venv_gogobe\Scripts\activate.bat
echo.
echo 2. Run batch processor:
echo    cd backend\scripts
echo    python batch_pdf_processor.py "path\to\pdfs"
echo.
echo 3. Or use the shortcut:
echo    run_gogobe.bat
echo.
pause

