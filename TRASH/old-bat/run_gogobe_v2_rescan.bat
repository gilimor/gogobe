@echo off
echo ==========================================
echo  Gogobe V2 - FORCE RESCAN
echo ==========================================
echo.
echo This will process ALL PDFs even if already scanned
echo.
pause

cd /d "%~dp0"

set PYTHON=C:\Users\shake\AppData\Local\Programs\Python\Python311\python.exe
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8

"%PYTHON%" backend\scripts\batch_pdf_processor_v2.py "New prices" --force-rescan

set PGPASSWORD=9152245-Gl!
set SQL_FILE=New prices\processed\ALL_PRODUCTS_COMBINED.sql

if exist "%SQL_FILE%" (
    "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d gogobe -f "%SQL_FILE%"
)

pause





