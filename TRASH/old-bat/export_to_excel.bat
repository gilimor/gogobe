@echo off
echo ==========================================
echo  Export Gogobe Data to Excel
echo ==========================================
echo.

set PGPASSWORD=9152245-Gl!
set PSQL="C:\Program Files\PostgreSQL\18\bin\psql.exe"
set OUTPUT_FILE=C:\temp\gogobe_products.csv

REM Create temp directory
if not exist "C:\temp" mkdir "C:\temp"

echo Exporting all products with prices...
echo Output: %OUTPUT_FILE%
echo.

%PSQL% -U postgres -d gogobe -c "\copy (SELECT p.name as product_name, c.name as category, v.name as vertical, MIN(pr.price) as min_price, MAX(pr.price) as max_price, ROUND(AVG(pr.price)::numeric, 2) as avg_price, COUNT(DISTINCT pr.supplier_id) as number_of_suppliers, pr.currency, MAX(pr.scraped_at)::date as last_updated FROM products p LEFT JOIN categories c ON p.category_id = c.id LEFT JOIN verticals v ON p.vertical_id = v.id LEFT JOIN prices pr ON p.id = pr.product_id WHERE p.is_active = TRUE GROUP BY p.id, p.name, c.name, v.name, pr.currency ORDER BY min_price ASC NULLS LAST) TO '%OUTPUT_FILE%' WITH CSV HEADER"

if %errorlevel% equ 0 (
    echo.
    echo ==========================================
    echo  Export Successful!
    echo ==========================================
    echo.
    echo File saved to:
    echo %OUTPUT_FILE%
    echo.
    echo You can now:
    echo 1. Open it in Excel
    echo 2. Use filters and sorting
    echo 3. Create pivot tables
    echo 4. Make charts
    echo.
    
    REM Try to open the file
    start "" "%OUTPUT_FILE%"
) else (
    echo.
    echo Export failed!
    echo Check that PostgreSQL is running.
)

echo.
pause

