@echo off
chcp 65001 >nul
REM בדיקת מוצרים וסניפים דרך PostgreSQL

echo ════════════════════════════════════════════════════════════
echo   בדיקת מוצרים במספר סניפים - KingStore
echo ════════════════════════════════════════════════════════════
echo.
echo הערה: דורש psql מותקן (PostgreSQL Client)
echo.

echo 1. כמה מוצרים יש לנו:
psql -U postgres -d gogobe -c "SELECT COUNT(*) as product_count FROM products WHERE vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%%supermarket%%');"
echo.

echo 2. כמה חנויות יש:
psql -U postgres -d gogobe -c "SELECT COUNT(*) as store_count FROM stores;"
echo.

echo 3. מוצרים שנמכרים ביותר מסניף אחד (טופ 10):
psql -U postgres -d gogobe -c "SELECT p.name, COUNT(DISTINCT pr.store_id) as store_count FROM products p JOIN prices pr ON p.id = pr.product_id WHERE p.vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%%supermarket%%') AND pr.store_id IS NOT NULL GROUP BY p.id, p.name HAVING COUNT(DISTINCT pr.store_id) > 1 ORDER BY store_count DESC LIMIT 10;"
echo.

echo 4. חנויות עם הכי הרבה מחירים:
psql -U postgres -d gogobe -c "SELECT s.store_name, s.store_code, COUNT(pr.id) as price_count FROM stores s LEFT JOIN prices pr ON s.id = pr.store_id GROUP BY s.id, s.store_name, s.store_code ORDER BY price_count DESC LIMIT 15;"
echo.

echo 5. סטטיסטיקות מחירים:
psql -U postgres -d gogobe -c "SELECT COUNT(*) as total_prices, COUNT(DISTINCT product_id) as unique_products, COUNT(DISTINCT store_id) as unique_stores FROM prices WHERE store_id IS NOT NULL;"
echo.

echo 6. פילוח - מוצרים לפי כמות סניפים:
psql -U postgres -d gogobe -c "SELECT store_count, COUNT(*) as product_count FROM (SELECT p.id, COUNT(DISTINCT pr.store_id) as store_count FROM products p JOIN prices pr ON p.id = pr.product_id WHERE p.vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%%supermarket%%') AND pr.store_id IS NOT NULL GROUP BY p.id) AS product_stores GROUP BY store_count ORDER BY store_count;"
echo.

echo הבדיקה הושלמה
echo.
pause

