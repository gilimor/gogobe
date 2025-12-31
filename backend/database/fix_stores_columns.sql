-- Fix Stores Table Columns to match Scraper Logic
-- Map existing columns to new names and add missing ones

-- 1. Rename columns if they exist with old names
DO $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='stores' AND column_name='store_name') THEN
        ALTER TABLE stores RENAME COLUMN store_name TO name;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='stores' AND column_name='store_code') THEN
        ALTER TABLE stores RENAME COLUMN store_code TO store_id;
    END IF;
END $$;

-- 2. Add missing columns
ALTER TABLE stores ADD COLUMN IF NOT EXISTS latitude DECIMAL(10, 8);
ALTER TABLE stores ADD COLUMN IF NOT EXISTS longitude DECIMAL(11, 8);
ALTER TABLE stores ADD COLUMN IF NOT EXISTS name_he VARCHAR(200);

-- 3. Ensure store_id constraint (might have been store_code before)
-- We need to drop old constraints if they exist, but safer to just add unique index
CREATE UNIQUE INDEX IF NOT EXISTS idx_stores_chain_store_id ON stores(chain_id, store_id);

SELECT 'Stores table fixed successfully' as result;
