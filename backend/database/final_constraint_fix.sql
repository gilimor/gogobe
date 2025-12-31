-- Clean up and establish the FINAL Correct Constraint
-- Using UNIQUE NULLS NOT DISTINCT (Supported by PG 15+)

-- 1. Drop old indices/constraints
DROP INDEX IF EXISTS prices_unique_idx;
DROP INDEX IF EXISTS idx_prices_unique_product_supplier_store;
ALTER TABLE prices DROP CONSTRAINT IF EXISTS prices_unique_key;

-- 2. Create the Clean Constraint
ALTER TABLE prices ADD CONSTRAINT prices_unique_key 
UNIQUE NULLS NOT DISTINCT (product_id, supplier_id, store_id);

SELECT 'Final constraint applied: UNIQUE NULLS NOT DISTINCT' as result;
