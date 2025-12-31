-- Fix Prices Constraint for Upsert Support

-- 1. Truncate prices (safe since we have few or none valid ones from recent runs)
-- TRUNCATE prices CASCADE; 
-- Actually, let's not truncate if we don't have to.

-- 2. Add Unique Constraint
-- We need a constraint named 'prices_unique_key'
-- It should cover product_id, supplier_id, and store_id.
-- Note: store_id can be NULL for some suppliers, but for supermarkets it is usually set.
-- Standard Postgres Unique Constraint treats NULLs as distinct (no conflict).
-- However, for ON CONFLICT to work, we usually need a unique index inference or named constraint.
-- If store_id is NULL, we might legitimateley have multiple prices? No.

-- If existing data violates, we delete duplicates (keep latest).
DELETE FROM prices a USING prices b
WHERE a.id < b.id
  AND a.product_id = b.product_id
  AND a.supplier_id = b.supplier_id
  AND (a.store_id = b.store_id OR (a.store_id IS NULL AND b.store_id IS NULL));

-- Now add constraint
ALTER TABLE prices DROP CONSTRAINT IF EXISTS prices_unique_key;

-- We use coalesce to handle nulls in index? No, ON CONFLICT constraint must be simple columns.
-- But if code uses `ON CONSTRAINT prices_unique_key`, it must match a partial index? No, must be a constraint.
-- The only way to support NULLs in unique constraint as "equal" is `NULLS NOT DISTINCT` (Postgres 15+).
-- Gogobe is running Postgres 18? No, version check said 18.1 (Wait, is that possible? Maybe 16 or 17. 18 is not out). 
-- "PostgreSQL 18.1 on x86_64-windows" - Ah, from `test_connection` output. That's very new (or dev version). 
-- If so, `NULLS NOT DISTINCT` works.

ALTER TABLE prices ADD CONSTRAINT prices_unique_key 
UNIQUE NULLS NOT DISTINCT (product_id, supplier_id, store_id);

SELECT 'Prices constraint added successfully' as result;
