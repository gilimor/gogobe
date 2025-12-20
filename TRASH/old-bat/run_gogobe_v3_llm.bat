@echo off
chcp 65001 > nul
echo ==========================================
echo 🤖 Gogobe - Auto PDF Processor V3 (LLM)
echo ==========================================

set PYTHON_EXE="C:\Users\shake\AppData\Local\Programs\Python\Python311\python.exe"
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%
set PDF_INPUT_DIR=%PROJECT_ROOT%New prices
set PGPASSWORD=9152245-Gl!
set PGUSER=postgres
set PGHOST=localhost
set PGPORT=5432
set PSQL_EXE="C:\Program Files\PostgreSQL\18\bin\psql.exe"

REM ===== CHECK FOR OPENAI API KEY =====
echo.
if "%OPENAI_API_KEY%"=="" (
    echo ⚠️  OPENAI_API_KEY not set!
    echo.
    echo Without API key:
    echo   ✅ Will still work
    echo   ❌ Will use keyword-based classification (less accurate)
    echo.
    echo To use LLM classification (recommended):
    echo   1. Get API key from: https://platform.openai.com/api-keys
    echo   2. Run: set OPENAI_API_KEY=sk-your-key-here
    echo   3. Re-run this script
    echo.
    echo Press any key to continue with keyword-based classification...
    pause > nul
) else (
    echo ✅ OPENAI_API_KEY found!
    echo 🤖 Using LLM-based vertical classification
)

echo.
echo ==========================================
echo Running batch PDF processor V3...
echo ==========================================
echo.

REM Set Python environment variables
set PYTHONIOENCODING=utf-8
set PYTHONPATH=
set PYTHONHOME=

%PYTHON_EXE% "%SCRIPT_DIR%backend\scripts\batch_pdf_processor_v3.py" "%PDF_INPUT_DIR%"

if %errorlevel% neq 0 (
    echo.
    echo ❌ PDF processing failed!
    echo.
    pause
    exit /b %errorlevel%
)

echo.
echo ==========================================
echo Loading processed data into PostgreSQL...
echo ==========================================
echo.

%PSQL_EXE% -U %PGUSER% -d gogobe -f "%PDF_INPUT_DIR%\processed\ALL_PRODUCTS_COMBINED.sql"

if %errorlevel% neq 0 (
    echo.
    echo ❌ Database loading failed!
    echo.
    pause
    exit /b %errorlevel%
)

echo.
echo ==========================================
echo 🎉 Gogobe Automation Complete!
echo ==========================================
echo.
echo ✅ All PDFs processed with intelligent classification!
echo 📊 Check your 'gogobe' database for new products
echo 📁 Output files are in: %PDF_INPUT_DIR%\processed
echo.
pause





