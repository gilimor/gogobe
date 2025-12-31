-- ==========================================
-- View your data in Gogobe
-- ==========================================

\echo '========================================='
\echo 'GOGOBE DATABASE - CURRENT DATA'
\echo '========================================='
\echo ''

-- Products
\echo '📦 PRODUCTS:'
\echo '-----------------------------------------'
SELECT 
    p.id,
    p.name,
    c.name as category,
    p.model_number as model
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
ORDER BY p.id;

\echo ''
\echo '💰 PRICES:'
\echo '-----------------------------------------'
SELECT 
    pr.name as product,
    s.name as supplier,
    p.price,
    p.currency,
    p.is_on_sale,
    p.scraped_at::date as date
FROM prices p
JOIN products pr ON p.product_id = pr.id
JOIN suppliers s ON p.supplier_id = s.id
ORDER BY p.price DESC;

\echo ''
\echo '🏢 SUPPLIERS:'
\echo '-----------------------------------------'
SELECT 
    name,
    country_code,
    supplier_type,
    product_count
FROM suppliers
WHERE 'dental' = ANY(verticals)
ORDER BY name;

\echo ''
\echo '📊 SUMMARY:'
\echo '-----------------------------------------'
SELECT 'Products' as item, COUNT(*)::text as count FROM products
UNION ALL
SELECT 'Prices', COUNT(*)::text FROM prices
UNION ALL
SELECT 'Suppliers', COUNT(*)::text FROM suppliers WHERE 'dental' = ANY(verticals)
UNION ALL
SELECT 'Categories', COUNT(*)::text FROM categories WHERE vertical_id = (SELECT id FROM verticals WHERE slug = 'dental');

\echo ''
\echo '✅ Database ready for 50GB!'
\echo '========================================='









