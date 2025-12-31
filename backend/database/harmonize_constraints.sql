-- Harmonize Uniqueness Logic for Prices
-- Clean up conflicting constraints/indexes and establish a single robustness strategy (COALESCE)

-- 1. Drop existing constraints/indexes
ALTER TABLE prices DROP CONSTRAINT IF EXISTS prices_unique_key;
DROP INDEX IF EXISTS idx_prices_unique_product_supplier_store;
DROP INDEX IF EXISTS prices_unique_idx;

-- 2. Create the robust unique index (Handling NULLs as -1)
CREATE UNIQUE INDEX prices_unique_idx 
ON prices (product_id, supplier_id, COALESCE(store_id, -1));

SELECT 'Constraints harmonized successfully' as result;
