-- Fix View to point to 'prices' (Partitioned) instead of 'prices_old'
-- Also verified logical correctness for partitioning support.

CREATE OR REPLACE VIEW v_products_unified_master AS
WITH master_stats AS (
    SELECT 
        l.master_product_id,
        min(pr.price) AS min_price,
        max(pr.price) AS max_price,
        avg(pr.price) AS avg_price,
        count(DISTINCT pr.store_id) AS store_count,
        count(DISTINCT pr.product_id) AS variant_count,
        max(pr.scraped_at) AS last_updated,
        mode() WITHIN GROUP (ORDER BY p.category_id) AS major_category_id,
        mode() WITHIN GROUP (ORDER BY p.brand_id) AS major_brand_id
    FROM product_master_links l
    JOIN products p ON l.product_id = p.id
    -- UPDATED: references 'prices', not 'prices_old'
    LEFT JOIN prices pr ON l.product_id = pr.product_id
    LEFT JOIN stores s ON pr.store_id = s.id
    WHERE p.is_active = true 
      AND (s.id IS NULL OR s.is_active = true) 
      AND (pr.id IS NULL OR pr.is_suspicious = false)
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
        min(pr.price) AS min_price,
        max(pr.price) AS max_price,
        avg(pr.price) AS avg_price,
        count(DISTINCT pr.store_id) AS store_count,
        1 AS variant_count,
        max(pr.scraped_at) AS last_updated
    FROM products p
    LEFT JOIN product_master_links l ON p.id = l.product_id
    -- UPDATED: references 'prices', not 'prices_old'
    LEFT JOIN prices pr ON p.id = pr.product_id
    LEFT JOIN stores s ON pr.store_id = s.id
    WHERE l.master_product_id IS NULL 
      AND p.is_active = true 
      AND (s.id IS NULL OR s.is_active = true) 
      AND (pr.id IS NULL OR pr.is_suspicious = false)
    GROUP BY p.id, p.name, p.category_id, p.brand_id, p.ean, p.upc, p.is_active
)
SELECT 
    'master'::text AS type,
    m.id,
    m.name,
    ms.major_category_id AS category_id,
    ms.major_brand_id AS brand_id,
    NULL::character varying AS ean,
    NULL::character varying AS upc,
    m.is_active,
    ms.min_price,
    ms.max_price,
    ms.avg_price,
    ms.store_count,
    ms.variant_count,
    ms.last_updated,
    c.name AS category_name,
    b.name AS brand_name
FROM master_products m
JOIN master_stats ms ON m.id = ms.master_product_id
LEFT JOIN categories c ON ms.major_category_id = c.id
LEFT JOIN brands b ON ms.major_brand_id = b.id

UNION ALL

SELECT 
    'orphan'::text AS type,
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
    c.name AS category_name,
    b.name AS brand_name
FROM orphan_products o
LEFT JOIN categories c ON o.category_id = c.id
LEFT JOIN brands b ON o.brand_id = b.id;
