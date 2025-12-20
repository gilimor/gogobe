-- Add store_id column to prices table
-- This allows tracking which store each price is from

ALTER TABLE prices 
ADD COLUMN IF NOT EXISTS store_id INTEGER REFERENCES stores(id);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_prices_store_id ON prices(store_id);

-- Create composite index for store + product lookups
CREATE INDEX IF NOT EXISTS idx_prices_store_product ON prices(store_id, product_id);

COMMENT ON COLUMN prices.store_id IS 'The specific store where this price was found';





