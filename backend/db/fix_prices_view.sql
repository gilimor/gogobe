-- Fix: Add is_suspicious column and update View to filter inactive/bad data

-- 1. Add is_suspicious column
ALTER TABLE prices ADD COLUMN IF NOT EXISTS is_suspicious BOOLEAN DEFAULT FALSE;
CREATE INDEX IF NOT EXISTS idx_prices_suspicious ON prices(is_suspicious);

-- 2. Drop old view
DROP VIEW IF EXISTS v_products_unified_master;

-- 3. Recreate View with STRICTER filtering
CREATE OR REPLACE VIEW v_products_unified_master AS
WITH master_stats AS (
    SELECT 
        l.master_product_id,
        MIN(pr.price) as min_price,
        MAX(pr.price) as max_price,
        AVG(pr.price) as avg_price,
        COUNT(DISTINCT pr.store_id) as store_count,
        COUNT(DISTINCT pr.product_id) as variant_count,
        MAX(pr.scraped_at) as last_updated,
        MODE() WITHIN GROUP (ORDER BY p.category_id) as major_category_id,
        MODE() WITHIN GROUP (ORDER BY p.brand_id) as major_brand_id
    FROM product_master_links l
    JOIN products p ON l.product_id = p.id
    LEFT JOIN prices pr ON l.product_id = pr.product_id
    LEFT JOIN stores s ON pr.store_id = s.id
    WHERE 
        p.is_active = TRUE 
        AND (s.id IS NULL OR s.is_active = TRUE) -- If price exists, store must be active
        AND (pr.id IS NULL OR pr.is_suspicious = FALSE) -- If price exists, must not be suspicious
    GROUP BY l.master_product_id
),
orphan_products AS (
    SELECT 
        p.id,
        p.name,
        p.category_id,
        p.brand_id,
        p.ean,
        p.upc,
        p.is_active,
        MIN(pr.price) as min_price,
        MAX(pr.price) as max_price,
        AVG(pr.price) as avg_price,
        COUNT(DISTINCT pr.store_id) as store_count,
        1 as variant_count,
        MAX(pr.scraped_at) as last_updated
    FROM products p
    LEFT JOIN product_master_links l ON p.id = l.product_id
    LEFT JOIN prices pr ON p.id = pr.product_id
    LEFT JOIN stores s ON pr.store_id = s.id
    WHERE 
        l.master_product_id IS NULL 
        AND p.is_active = TRUE
        AND (s.id IS NULL OR s.is_active = TRUE)
        AND (pr.id IS NULL OR pr.is_suspicious = FALSE)
    GROUP BY p.id, p.name, p.category_id, p.brand_id, p.ean, p.upc, p.is_active
)
SELECT 
    'master' as type,
    m.id,
    m.name,
    ms.major_category_id as category_id,
    ms.major_brand_id as brand_id,
    NULL::VARCHAR as ean,
    NULL::VARCHAR as upc,
    m.is_active,
    ms.min_price,
    ms.max_price,
    ms.avg_price,
    ms.store_count,
    ms.variant_count,
    ms.last_updated,
    c.name as category_name,
    b.name as brand_name
FROM master_products m
JOIN master_stats ms ON m.id = ms.master_product_id
LEFT JOIN categories c ON ms.major_category_id = c.id
LEFT JOIN brands b ON ms.major_brand_id = b.id

UNION ALL

SELECT 
    'orphan' as type,
    o.id,
    o.name,
    o.category_id,
    o.brand_id,
    o.ean,
    o.upc,
    o.is_active,
    o.min_price,
    o.max_price,
    o.avg_price,
    o.store_count,
    o.variant_count,
    o.last_updated,
    c.name as category_name,
    b.name as brand_name
FROM orphan_products o
LEFT JOIN categories c ON o.category_id = c.id
LEFT JOIN brands b ON o.brand_id = b.id;
