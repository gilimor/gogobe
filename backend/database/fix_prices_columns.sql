-- Align prices table with scraper requirements

-- 1. Rename columns to match scraper (is_sale, price_regular)
-- Check if columns exist before renaming to avoid errors if run multiple times
DO $$
BEGIN
  IF EXISTS(SELECT * FROM information_schema.columns WHERE table_name='prices' AND column_name='is_on_sale') THEN
      ALTER TABLE prices RENAME COLUMN is_on_sale TO is_sale;
  END IF;
  
  IF EXISTS(SELECT * FROM information_schema.columns WHERE table_name='prices' AND column_name='original_price') THEN
      ALTER TABLE prices RENAME COLUMN original_price TO price_regular;
  END IF;
END $$;

-- 2. Add properties that are missing
ALTER TABLE prices ADD COLUMN IF NOT EXISTS promo_description TEXT;
ALTER TABLE prices ADD COLUMN IF NOT EXISTS is_sale BOOLEAN DEFAULT FALSE; -- In case rename didn't happen because it didn't exist
ALTER TABLE prices ADD COLUMN IF NOT EXISTS price_regular NUMERIC(10,2); -- In case rename didn't happen

SELECT 'Prices table columns aligned' as result;
