-- ==========================================
-- Product Deduplication Script (Complete)
-- ==========================================

BEGIN;

-- Create mapping
CREATE TEMP TABLE product_duplicates AS
SELECT ean, MIN(id) as keep_id, array_agg(id ORDER BY id) as all_ids, COUNT(*) as cnt
FROM products WHERE ean IS NOT NULL GROUP BY ean HAVING COUNT(*) > 1;

-- Report
SELECT SUM(cnt) - COUNT(*) as will_delete FROM product_duplicates;

-- Delete from all related tables
DELETE FROM matching_feedback WHERE product_id IN (SELECT unnest(all_ids) FROM product_duplicates) AND product_id NOT IN (SELECT keep_id FROM product_duplicates);
DELETE FROM product_master_links WHERE product_id IN (SELECT unnest(all_ids) FROM product_duplicates) AND product_id NOT IN (SELECT keep_id FROM product_duplicates);

-- Update prices
UPDATE prices SET product_id = (SELECT keep_id FROM product_duplicates pd WHERE pd.ean = (SELECT ean FROM products WHERE id = prices.product_id))
WHERE product_id IN (SELECT unnest(all_ids) FROM product_duplicates) AND product_id NOT IN (SELECT keep_id FROM product_duplicates);

-- Delete duplicates
DELETE FROM products WHERE id IN (SELECT unnest(all_ids) FROM product_duplicates) AND id NOT IN (SELECT keep_id FROM product_duplicates);

-- Verify
SELECT COUNT(*) as total, COUNT(DISTINCT ean) as unique FROM products WHERE ean IS NOT NULL;

COMMIT;
