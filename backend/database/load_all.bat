@echo off
echo =========================================
echo Gogobe - Load ALL CSV Products
echo =========================================
echo.

set PGPASSWORD=9152245-Gl!
set PGUSER=postgres
set PGHOST=localhost
set PGPORT=5432

echo Loading 6 products from CSV...
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U %PGUSER% -d gogobe -f load_all_csv_products.sql

echo.
echo =========================================
echo Done! View products:
echo =========================================
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U %PGUSER% -d gogobe -f view_data.sql

pause









