@echo off
echo =========================================
echo Loading Dental Products
echo =========================================
echo.

set PGPASSWORD=9152245-Gl!
set PGUSER=postgres

echo Loading products into database...
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U %PGUSER% -d gogobe -f load_dental_data.sql

echo.
echo =========================================
echo Done! Products loaded!
echo =========================================
pause









