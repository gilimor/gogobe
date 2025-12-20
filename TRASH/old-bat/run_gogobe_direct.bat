@echo off
echo ==========================================
echo  🦷 Gogobe - Auto PDF Processor
echo ==========================================
echo.

cd /d "%~dp0"

set PYTHON=C:\Users\shake\AppData\Local\Programs\Python\Python311\python.exe
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8

REM Check if Python 3.11 exists
if not exist "%PYTHON%" (
    echo ❌ Python 3.11 not found!
    echo.
    echo Please run: setup_direct.bat first
    echo.
    pause
    exit /b 1
)

REM Run batch processor
echo.
echo Processing PDFs in "New prices" folder...
echo.

"%PYTHON%" backend\scripts\batch_pdf_processor.py "New prices"

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

