@echo off
echo ==========================================
echo  Exporting Database to JSON
echo ==========================================
echo.

cd /d "%~dp0"
mkdir data 2>nul

set PGPASSWORD=9152245-Gl!
set PSQL="C:\Program Files\PostgreSQL\18\bin\psql.exe"

echo Exporting products...
%PSQL% -U postgres -d gogobe -t -A -F"," -c "COPY (SELECT row_to_json(t) FROM (SELECT p.id, p.name, p.slug, p.description, c.name as category_name, c.id as category_id, v.name as vertical_name FROM products p LEFT JOIN categories c ON p.category_id = c.id LEFT JOIN verticals v ON p.vertical_id = v.id WHERE p.is_active = TRUE ORDER BY p.id) t) TO STDOUT" > data\products_raw.json

echo Exporting categories...
%PSQL% -U postgres -d gogobe -t -c "SELECT json_agg(t) FROM (SELECT id, name, slug FROM categories WHERE is_active = TRUE) t" -o data\categories.json

echo Exporting suppliers...
%PSQL% -U postgres -d gogobe -t -c "SELECT json_agg(t) FROM (SELECT id, name, slug, country_code FROM suppliers WHERE is_active = TRUE) t" -o data\suppliers.json

echo Exporting stats...
%PSQL% -U postgres -d gogobe -t -c "SELECT json_build_object('total_products', (SELECT COUNT(*) FROM products WHERE is_active=TRUE), 'total_suppliers', (SELECT COUNT(*) FROM suppliers WHERE is_active=TRUE), 'total_prices', (SELECT COUNT(*) FROM prices))" -o data\stats.json

echo.
echo ==========================================
echo  Export Complete!
echo ==========================================
echo.
echo Data saved to: frontend\data\
echo You can now open: index_static.html
echo.
pause






