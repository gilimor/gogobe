-- ==========================================
-- SANDBOX Mode Support
-- Flags for test data that can be cleaned up
-- ==========================================

-- Add is_sandbox flag to relevant tables
ALTER TABLE products ADD COLUMN IF NOT EXISTS is_sandbox BOOLEAN DEFAULT FALSE;
ALTER TABLE prices ADD COLUMN IF NOT EXISTS is_sandbox BOOLEAN DEFAULT FALSE;
ALTER TABLE stores ADD COLUMN IF NOT EXISTS is_sandbox BOOLEAN DEFAULT FALSE;

-- Create indexes for fast cleanup
CREATE INDEX IF NOT EXISTS idx_products_sandbox ON products(is_sandbox) WHERE is_sandbox = TRUE;
CREATE INDEX IF NOT EXISTS idx_prices_sandbox ON prices(is_sandbox) WHERE is_sandbox = TRUE;
CREATE INDEX IF NOT EXISTS idx_stores_sandbox ON stores(is_sandbox) WHERE is_sandbox = TRUE;

-- Function to cleanup sandbox data
CREATE OR REPLACE FUNCTION cleanup_sandbox() RETURNS void AS $$
BEGIN
    DELETE FROM prices WHERE is_sandbox = TRUE;
    DELETE FROM products WHERE is_sandbox = TRUE;
    DELETE FROM stores WHERE is_sandbox = TRUE;
    
    RAISE NOTICE 'Sandbox data cleaned up';
END;
$$ LANGUAGE plpgsql;

-- Function to get sandbox stats
CREATE OR REPLACE FUNCTION get_sandbox_stats() RETURNS TABLE(
    table_name TEXT,
    count BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 'products'::TEXT, COUNT(*)::BIGINT FROM products WHERE is_sandbox = TRUE
    UNION ALL
    SELECT 'prices'::TEXT, COUNT(*)::BIGINT FROM prices WHERE is_sandbox = TRUE
    UNION ALL
    SELECT 'stores'::TEXT, COUNT(*)::BIGINT FROM stores WHERE is_sandbox = TRUE;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION cleanup_sandbox() IS 'Deletes all sandbox test data';
COMMENT ON FUNCTION get_sandbox_stats() IS 'Shows count of sandbox records in each table';
