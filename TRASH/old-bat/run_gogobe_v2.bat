@echo off
echo ==========================================
echo  Gogobe V2 - With Source Tracking
echo ==========================================
echo.

cd /d "%~dp0"

set PYTHON=C:\Users\shake\AppData\Local\Programs\Python\Python311\python.exe
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8

REM Check if Python 3.11 exists
if not exist "%PYTHON%" (
    echo Error: Python 3.11 not found!
    pause
    exit /b 1
)

REM Run V2 batch processor with source tracking
echo Processing PDFs with duplicate detection...
echo.

"%PYTHON%" backend\scripts\batch_pdf_processor_v2.py "New prices"

if errorlevel 1 (
    echo.
    echo Processing failed!
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
set SQL_FILE=New prices\processed\ALL_PRODUCTS_COMBINED.sql

if exist "%SQL_FILE%" (
    "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d gogobe -f "%SQL_FILE%"
    
    echo.
    echo ==========================================
    echo  Done!
    echo ==========================================
    echo.
    
    REM Show stats
    "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d gogobe -c "SELECT COUNT(*) as total_products FROM products; SELECT COUNT(*) as total_sources, SUM(products_imported) as total_imported FROM scraped_sources WHERE is_active=TRUE;"
) else (
    echo No SQL file found to load.
)

echo.
pause





