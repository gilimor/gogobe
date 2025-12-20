-- 🔍 בדיקת מוצרים וסניפים - KingStore
-- Run this in PostgreSQL (PgAdmin, DBeaver, etc.)

\echo ''
\echo '============================================================'
\echo '  בדיקת מוצרים וסניפים - KingStore'
\echo '============================================================'
\echo ''

\echo '1️⃣  כמה מוצרים יש לנו:'
SELECT COUNT(*) as "מספר מוצרים"
FROM products
WHERE vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%supermarket%');

\echo ''
\echo '2️⃣  כמה חנויות יש:'
SELECT COUNT(*) as "מספר חנויות"
FROM stores;

\echo ''
\echo '3️⃣  חנויות עם מחירים:'
SELECT COUNT(DISTINCT store_id) as "חנויות עם מחירים"
FROM prices
WHERE store_id IS NOT NULL;

\echo ''
\echo '4️⃣  מוצרים שנמכרים ביותר מסניף אחד (טופ 10):'
SELECT 
    LEFT(p.name, 60) as "שם המוצר",
    COUNT(DISTINCT pr.store_id) as "מספר סניפים"
FROM products p
    JOIN prices pr ON p.id = pr.product_id
WHERE 
    p.vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%supermarket%')
    AND pr.store_id IS NOT NULL
GROUP BY p.id, p.name
HAVING COUNT(DISTINCT pr.store_id) > 1
ORDER BY COUNT(DISTINCT pr.store_id) DESC
LIMIT 10;

\echo ''
\echo '5️⃣  חנויות עם הכי הרבה מחירים:'
SELECT 
    s.store_name as "שם החנות",
    s.store_code as "קוד",
    s.city as "עיר",
    COUNT(pr.id) as "מספר מחירים"
FROM stores s
    LEFT JOIN prices pr ON s.id = pr.store_id
GROUP BY s.id, s.store_name, s.store_code, s.city
ORDER BY COUNT(pr.id) DESC
LIMIT 15;

\echo ''
\echo '6️⃣  סטטיסטיקות מחירים:'
SELECT 
    COUNT(*) as "סה״כ מחירים",
    COUNT(DISTINCT product_id) as "מוצרים ייחודיים",
    COUNT(DISTINCT store_id) as "סניפים ייחודיים"
FROM prices
WHERE store_id IS NOT NULL;

\echo ''
\echo '7️⃣  פילוח - מוצרים לפי כמות סניפים:'
SELECT 
    store_count as "מספר סניפים",
    COUNT(*) as "כמות מוצרים"
FROM (
    SELECT 
        p.id,
        COUNT(DISTINCT pr.store_id) as store_count
    FROM products p
        JOIN prices pr ON p.id = pr.product_id
    WHERE 
        p.vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%supermarket%')
        AND pr.store_id IS NOT NULL
    GROUP BY p.id
) AS product_stores
GROUP BY store_count
ORDER BY store_count;

\echo ''
\echo '8️⃣  דוגמא - מוצר אקראי עם כל המחירים שלו:'
WITH random_product AS (
    SELECT id, name
    FROM products
    WHERE vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%supermarket%')
        AND id IN (
            SELECT DISTINCT product_id 
            FROM prices 
            WHERE store_id IS NOT NULL
        )
    ORDER BY RANDOM()
    LIMIT 1
)
SELECT 
    LEFT(rp.name, 50) as "שם המוצר",
    s.store_name as "חנות",
    s.store_code as "קוד סניף",
    s.city as "עיר",
    pr.price as "מחיר (₪)"
FROM random_product rp
    JOIN prices pr ON rp.id = pr.product_id
    JOIN stores s ON pr.store_id = s.id
ORDER BY pr.price;

\echo ''
\echo '✅ הבדיקה הושלמה!'
\echo ''


