-- Partition Fix Script
-- Problem: Data is from Dec 2025, but partitions were for Jan 2025.
-- Solution: Create Dec 2025 partition and move data.

BEGIN;

-- 1. Detach the default partition (which currently holds all 4.8M rows)
ALTER TABLE prices DETACH PARTITION prices_default;
ALTER TABLE prices_default RENAME TO prices_unsorted;

-- 2. Create the Correct Partitions for CURRENT TIME (Dec 2025)
CREATE TABLE prices_2025_10 PARTITION OF prices FOR VALUES FROM ('2025-10-01') TO ('2025-11-01');
CREATE TABLE prices_2025_11 PARTITION OF prices FOR VALUES FROM ('2025-11-01') TO ('2025-12-01');
CREATE TABLE prices_2025_12 PARTITION OF prices FOR VALUES FROM ('2025-12-01') TO ('2026-01-01');

-- Future
CREATE TABLE prices_2026_01 PARTITION OF prices FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');

-- 3. Re-create a fresh, empty default partition
CREATE TABLE prices_default PARTITION OF prices DEFAULT;

-- 4. Move data from Unsorted to the Main Table (Routes to correct partition)
INSERT INTO prices SELECT * FROM prices_unsorted;

-- 5. Cleanup
DROP TABLE prices_unsorted;

COMMIT;
