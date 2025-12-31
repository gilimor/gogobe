-- Optimize PostgreSQL for high-volume bulk imports
-- Run this before large imports

-- Increase work memory for sorting and hashing
SET work_mem = '256MB';

-- Increase shared buffers (if you have enough RAM)
-- SET shared_buffers = '512MB';

-- Increase maintenance work memory for index operations
SET maintenance_work_mem = '512MB';

-- Disable synchronous commits during bulk import (faster, but less safe)
-- Only use this during bulk imports, then re-enable!
SET synchronous_commit = OFF;

-- Increase checkpoint segments (for large imports)
SET checkpoint_completion_target = 0.9;

-- Disable autovacuum during bulk import (re-enable after!)
-- ALTER TABLE prices SET (autovacuum_enabled = false);
-- ALTER TABLE products SET (autovacuum_enabled = false);

-- After import, re-enable:
-- ALTER TABLE prices SET (autovacuum_enabled = true);
-- ALTER TABLE products SET (autovacuum_enabled = true);
-- SET synchronous_commit = ON;

-- Create optimized index for price lookups (if not exists)
CREATE INDEX IF NOT EXISTS idx_prices_lookup_fast 
ON prices (product_id, supplier_id, COALESCE(store_id, -1), price, currency, is_available)
WHERE is_available = TRUE;

-- Analyze tables after bulk import
-- ANALYZE prices;
-- ANALYZE products;


