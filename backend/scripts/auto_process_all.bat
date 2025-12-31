@echo off
echo ==========================================
echo  🦷 Gogobe - FULL AUTO PROCESSOR
echo ==========================================
echo.
echo This will:
echo  1. Scan all PDFs in "New prices" folder
echo  2. Extract products and prices
echo  3. Generate CSV + SQL files
echo  4. Load everything to database
echo.
echo ==========================================
pause

cd /d "%~dp0"

REM Step 1: Process PDFs
echo.
echo ==========================================
echo STEP 1: Processing PDFs...
echo ==========================================
echo.

python batch_pdf_processor.py "C:\Users\shake\Limor Shaked Dropbox\LIMOR SHAKED ADVANCED COSMETICS LTD\Gogobe\New prices"

if errorlevel 1 (
    echo.
    echo ❌ Error processing PDFs!
    pause
    exit /b 1
)

REM Step 2: Load to database
echo.
echo ==========================================
echo STEP 2: Loading to database...
echo ==========================================
echo.

call load_to_database.bat

echo.
echo ==========================================
echo  🎉 ALL DONE!
echo ==========================================
echo.
echo ✅ PDFs processed
echo ✅ Products extracted
echo ✅ Database updated
echo.
echo Check results in:
echo  📁 New prices\processed\
echo  🗄️ PostgreSQL database 'gogobe'
echo.

pause









