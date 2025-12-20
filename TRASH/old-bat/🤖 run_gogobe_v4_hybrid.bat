@echo off
chcp 65001 > nul
echo ============================================================
echo 🤖 Gogobe V4 - HYBRID CLASSIFICATION SYSTEM
echo ============================================================
echo.
echo 🎯 Strategy:
echo   1️⃣  Search Database (FREE, instant)
echo   2️⃣  Local LLM via Ollama (FREE, ~2 sec)
echo   3️⃣  OpenAI GPT (PAID, only if needed)
echo.
echo This minimizes costs by using free methods first!
echo ============================================================

set PYTHON_EXE="C:\Users\shake\AppData\Local\Programs\Python\Python311\python.exe"
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%
set PDF_INPUT_DIR=%PROJECT_ROOT%New prices
set PGPASSWORD=9152245-Gl!
set PGUSER=postgres
set PGHOST=localhost
set PGPORT=5432
set PSQL_EXE="C:\Program Files\PostgreSQL\18\bin\psql.exe"

REM ===== CHECK COMPONENTS =====
echo.
echo 🔍 Checking components...
echo.

REM Check Python
%PYTHON_EXE% --version > nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python not found!
    pause
    exit /b 1
)
echo ✅ Python OK

REM Check Ollama (optional)
ollama --version > nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Ollama not installed (will skip Tier 2)
    echo    To install: see 📥 INSTALL_OLLAMA.md
    set OLLAMA_AVAILABLE=0
) else (
    echo ✅ Ollama OK (Local LLM available!)
    set OLLAMA_AVAILABLE=1
)

REM Check OpenAI API Key (optional)
if "%OPENAI_API_KEY%"=="" (
    echo ⚠️  OPENAI_API_KEY not set (will skip Tier 3)
    echo    To use: set OPENAI_API_KEY=sk-your-key-here
    set OPENAI_AVAILABLE=0
) else (
    echo ✅ OpenAI API Key found
    set OPENAI_AVAILABLE=1
)

REM Check PostgreSQL
%PSQL_EXE% --version > nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ PostgreSQL not found!
    pause
    exit /b 1
)
echo ✅ PostgreSQL OK

echo.
echo ============================================================
echo 🚀 Starting Hybrid PDF Processing...
echo ============================================================
echo.

REM Set Python environment
set PYTHONIOENCODING=utf-8
set PYTHONPATH=
set PYTHONHOME=

%PYTHON_EXE% "%SCRIPT_DIR%backend\scripts\batch_pdf_processor_v4.py" "%PDF_INPUT_DIR%"

if %errorlevel% neq 0 (
    echo.
    echo ❌ PDF processing failed!
    echo.
    pause
    exit /b %errorlevel%
)

echo.
echo ============================================================
echo 💾 Loading data into PostgreSQL...
echo ============================================================
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
echo ============================================================
echo 🎉 HYBRID CLASSIFICATION COMPLETE!
echo ============================================================
echo.
echo ✅ All PDFs processed with intelligent classification!
echo 📊 Check your 'gogobe' database for new products
echo 📁 Output files: %PDF_INPUT_DIR%\processed
echo.
echo 💡 TIP: Run the script again to see detailed statistics
echo          about which tier was used for each classification!
echo.
pause





