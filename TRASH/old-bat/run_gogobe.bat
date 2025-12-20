@echo off
echo ==========================================
echo  🦷 Gogobe - Auto PDF Processor
echo ==========================================
echo.

cd /d "%~dp0"

REM Check if venv exists
if not exist "venv_gogobe\Scripts\activate.bat" (
    echo ❌ Virtual environment not found!
    echo.
    echo Please run: setup_gogobe_env.bat first
    echo.
    pause
    exit /b 1
)

REM Activate venv
call venv_gogobe\Scripts\activate.bat

REM Run batch processor
echo.
echo Processing PDFs in "New prices" folder...
echo.

python backend\scripts\batch_pdf_processor.py "New prices"

REM Check if successful
if errorlevel 1 (
    echo.
    echo ❌ Processing failed!
    echo.
    pause
    exit /b 1
)

REM Load to database
echo.
echo ==========================================
echo Loading to database...
echo ==========================================
echo.

set PGPASSWORD=9152245-Gl!
set PGUSER=postgres
set PGHOST=localhost
set PGPORT=5432

set SQL_FILE=New prices\processed\ALL_PRODUCTS_COMBINED.sql

if not exist "%SQL_FILE%" (
    echo ❌ SQL file not found!
    echo Processing may have failed.
    pause
    exit /b 1
)

"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U %PGUSER% -d gogobe -f "%SQL_FILE%"

echo.
echo ==========================================
echo  🎉 ALL DONE!
echo ==========================================
echo.
echo Check results:
echo  📁 New prices\processed\
echo  🗄️ PostgreSQL database 'gogobe'
echo.

REM Show count
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U %PGUSER% -d gogobe -c "SELECT COUNT(*) as total_products FROM products;"

echo.
pause





