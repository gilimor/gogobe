@echo off
echo ============================================================
echo 🤖 AUTO IMPORT - Israeli Supermarket Prices
echo ============================================================
echo.
echo This will automatically:
echo   1. Try to download real data from supermarkets
echo   2. If fails, create demo data
echo   3. Import to Gogobe database
echo.
echo Press Ctrl+C to cancel, or
pause

cd /d "%~dp0"

set PYTHON=C:\Users\shake\miniconda3\python.exe

echo.
echo ============================================================
echo Step 1: Trying real scraper...
echo ============================================================
echo.

"%PYTHON%" backend\scripts\israeli_supermarket_scraper.py

if errorlevel 1 (
    echo.
    echo Real scraper failed. Using demo data instead...
    echo.
    "%PYTHON%" backend\scripts\supermarket_demo_data.py
)

echo.
echo ============================================================
echo ✅ Import Complete!
echo ============================================================
echo.
echo Check your database:
echo   psql -U postgres -d gogobe
echo   SELECT COUNT(*) FROM products WHERE vertical_id = 10;
echo.
pause





