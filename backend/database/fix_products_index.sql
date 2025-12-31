-- Fix Products EAN Index to be UNIQUE
-- This allows ON CONFLICT to work

DROP INDEX IF EXISTS idx_products_ean;

-- Create correct UNIQUE index
CREATE UNIQUE INDEX idx_products_ean ON products(ean) WHERE ean IS NOT NULL;

SELECT 'Products EAN index made UNIQUE' as result;
