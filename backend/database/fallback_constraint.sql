-- Fallback to standard constraint to fix ON CONFLICT issues
-- We assume store_id is practically NOT NULL for all scraped prices

ALTER TABLE prices DROP CONSTRAINT IF EXISTS prices_unique_key;

-- Standard Unique Constraint (implicit index)
ALTER TABLE prices ADD CONSTRAINT prices_unique_key 
UNIQUE (product_id, supplier_id, store_id);

SELECT 'Standard constraint applied' as result;
