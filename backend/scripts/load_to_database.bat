@echo off
echo =========================================
echo Gogobe - Load Products to Database
echo =========================================
echo.

set PGPASSWORD=9152245-Gl!
set PGUSER=postgres
set PGHOST=localhost
set PGPORT=5432

set PROCESSED_FOLDER=C:\Users\shake\Limor Shaked Dropbox\LIMOR SHAKED ADVANCED COSMETICS LTD\Gogobe\New prices\processed
set SQL_FILE=%PROCESSED_FOLDER%\ALL_PRODUCTS_COMBINED.sql

echo Checking for combined SQL file...
if not exist "%SQL_FILE%" (
    echo.
    echo ❌ Error: ALL_PRODUCTS_COMBINED.sql not found!
    echo.
    echo Please run process_new_prices.bat first!
    echo.
    pause
    exit /b 1
)

echo ✅ Found: ALL_PRODUCTS_COMBINED.sql
echo.
echo Loading products to database 'gogobe'...
echo.

"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U %PGUSER% -d gogobe -f "%SQL_FILE%"

echo.
echo =========================================
echo Done! Products loaded to database!
echo =========================================
echo.
echo View products:
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U %PGUSER% -d gogobe -c "SELECT COUNT(*) as total_products FROM products;"

echo.
pause









