-- ==========================================
-- Product Deduplication Script (Fixed)
-- Merges duplicate products (same EAN)
-- ==========================================

BEGIN;

-- Step 1: Create mapping table
CREATE TEMP TABLE product_duplicates AS
SELECT 
    ean,
    MIN(id) as keep_id,
    array_agg(id ORDER BY id) as all_ids,
    COUNT(*) as duplicate_count
FROM products 
WHERE ean IS NOT NULL 
GROUP BY ean 
HAVING COUNT(*) > 1;

-- Show what we found
SELECT 
    COUNT(*) as total_duplicate_groups,
    SUM(duplicate_count) as total_duplicate_products,
    SUM(duplicate_count - 1) as products_to_delete
FROM product_duplicates;

-- Step 2: DELETE conflicting product_master_links (will be recreated)
DELETE FROM product_master_links
WHERE product_id IN (
    SELECT unnest(all_ids) 
    FROM product_duplicates
)
AND product_id NOT IN (
    SELECT keep_id 
    FROM product_duplicates
);

-- Step 3: Update prices to point to the kept product
UPDATE prices p
SET product_id = (
    SELECT keep_id 
    FROM product_duplicates pd 
    WHERE pd.ean = (SELECT ean FROM products WHERE id = p.product_id)
)
WHERE product_id IN (
    SELECT unnest(all_ids) 
    FROM product_duplicates
)
AND product_id NOT IN (
    SELECT keep_id 
    FROM product_duplicates
);

-- Step 4: Delete duplicate products
DELETE FROM products
WHERE id IN (
    SELECT unnest(all_ids) 
    FROM product_duplicates
)
AND id NOT IN (
    SELECT keep_id 
    FROM product_duplicates
);

-- Step 5: Verify results
SELECT 
    'FINAL RESULT:' as status,
    COUNT(*) as total_products,
    COUNT(DISTINCT ean) as unique_eans,
    COUNT(*) - COUNT(DISTINCT ean) as remaining_duplicates
FROM products 
WHERE ean IS NOT NULL;

COMMIT;

-- ==========================================
-- Done!
-- ==========================================
