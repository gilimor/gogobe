@echo off
chcp 65001 > nul
echo ======================================
echo  Gogobe - Simple Hybrid Classification
echo ======================================

cd /d "%~dp0"

set PYTHON=C:\Users\shake\AppData\Local\Programs\Python\Python311\python.exe
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8

echo.
echo Processing PDFs with keyword classification...
echo.

"%PYTHON%" backend\scripts\batch_pdf_processor_simple_hybrid.py "New prices"

if errorlevel 1 (
    echo.
    echo Failed!
    pause
    exit /b 1
)

echo.
echo ======================================
echo Loading to database...
echo ======================================

set PGPASSWORD=9152245-Gl!

"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d gogobe -f "New prices\processed\ALL_PRODUCTS_COMBINED.sql"

echo.
echo ======================================
echo  Done! Check results:
echo ======================================
echo.

"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d gogobe -c "SELECT v.name, COUNT(p.id) as count FROM verticals v LEFT JOIN products p ON v.id = p.vertical_id GROUP BY v.name ORDER BY count DESC;"

echo.
pause





