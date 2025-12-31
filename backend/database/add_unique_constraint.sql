-- Clean duplicates and add UNIQUE constraint for COPY method

-- Step 1: Remove duplicates (keep latest by scraped_at)
DELETE FROM prices a USING prices b
WHERE a.id < b.id 
AND a.product_id = b.product_id
AND a.supplier_id = b.supplier_id
AND a.store_id = b.store_id;

-- Step 2: Create UNIQUE constraint
ALTER TABLE prices ADD CONSTRAINT prices_unique_key 
  UNIQUE (product_id, supplier_id, store_id);

-- Verify
SELECT 
  COUNT(*) as total_prices,
  COUNT(DISTINCT (product_id, supplier_id, store_id)) as unique_combinations
FROM prices;
