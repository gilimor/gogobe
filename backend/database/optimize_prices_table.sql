-- ============================================
-- Price Table Optimization
-- Add first_scraped_at and last_scraped_at
-- Reduce redundant price records
-- ============================================

-- 1. Add new columns to prices table
ALTER TABLE prices 
    ADD COLUMN IF NOT EXISTS first_scraped_at TIMESTAMP DEFAULT NOW(),
    ADD COLUMN IF NOT EXISTS last_scraped_at TIMESTAMP;

-- 2. Initialize existing records
-- Set first_scraped_at and last_scraped_at to scraped_at for existing records
UPDATE prices 
SET first_scraped_at = scraped_at,
    last_scraped_at = scraped_at
WHERE first_scraped_at IS NULL;

-- 3. Make first_scraped_at NOT NULL (after initialization)
ALTER TABLE prices 
    ALTER COLUMN first_scraped_at SET NOT NULL,
    ALTER COLUMN first_scraped_at SET DEFAULT NOW();

-- 4. Create index for efficient updates
CREATE INDEX IF NOT EXISTS idx_prices_product_store_supplier 
ON prices(product_id, store_id, supplier_id) 
WHERE is_available = TRUE;

-- 5. Create function for smart price insert/update
CREATE OR REPLACE FUNCTION upsert_price(
    p_product_id BIGINT,
    p_supplier_id INTEGER,
    p_store_id INTEGER,
    p_price DECIMAL(12,2),
    p_currency CHAR(3),
    p_is_available BOOLEAN DEFAULT TRUE,
    p_price_tolerance DECIMAL DEFAULT 0.01  -- 1 אגורה
) RETURNS BIGINT AS $$
DECLARE
    v_price_id BIGINT;
    v_existing_price DECIMAL(12,2);
BEGIN
    -- Try to find existing price for this product+store+supplier
    SELECT id, price INTO v_price_id, v_existing_price
    FROM prices
    WHERE product_id = p_product_id
        AND supplier_id = p_supplier_id
        AND (store_id = p_store_id OR (store_id IS NULL AND p_store_id IS NULL))
        AND currency = p_currency
        AND is_available = p_is_available
    ORDER BY last_scraped_at DESC NULLS LAST, scraped_at DESC
    LIMIT 1;
    
    -- If found and price is the same (within tolerance)
    IF v_price_id IS NOT NULL AND 
       ABS(v_existing_price - p_price) <= p_price_tolerance THEN
        
        -- Just update the last_scraped_at
        UPDATE prices
        SET last_scraped_at = NOW(),
            scraped_at = NOW()  -- Keep scraped_at updated too
        WHERE id = v_price_id;
        
        RETURN v_price_id;
    ELSE
        -- Price changed or doesn't exist - create new record
        INSERT INTO prices (
            product_id, 
            supplier_id, 
            store_id, 
            price, 
            currency,
            is_available,
            first_scraped_at,
            last_scraped_at,
            scraped_at
        ) VALUES (
            p_product_id,
            p_supplier_id,
            p_store_id,
            p_price,
            p_currency,
            p_is_available,
            NOW(),
            NOW(),
            NOW()
        )
        RETURNING id INTO v_price_id;
        
        RETURN v_price_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 6. Create view for current prices (most recent per product+store)
CREATE OR REPLACE VIEW v_current_prices AS
SELECT DISTINCT ON (product_id, supplier_id, COALESCE(store_id, -1))
    id,
    product_id,
    supplier_id,
    store_id,
    price,
    currency,
    original_price,
    discount_percentage,
    is_available,
    first_scraped_at,
    last_scraped_at,
    COALESCE(last_scraped_at, scraped_at) as effective_date,
    -- Calculate how long this price has been stable
    EXTRACT(EPOCH FROM (COALESCE(last_scraped_at, scraped_at) - first_scraped_at))/86400 as days_stable
FROM prices
WHERE is_available = TRUE
ORDER BY product_id, supplier_id, COALESCE(store_id, -1), COALESCE(last_scraped_at, scraped_at) DESC;

-- 7. Create view for price changes (only records where price actually changed)
CREATE OR REPLACE VIEW v_price_history AS
SELECT 
    id,
    product_id,
    supplier_id,
    store_id,
    price,
    currency,
    first_scraped_at as price_from,
    COALESCE(last_scraped_at, scraped_at) as price_to,
    COALESCE(last_scraped_at, scraped_at) - first_scraped_at as duration,
    -- Next price (for comparison)
    LEAD(price) OVER (PARTITION BY product_id, supplier_id, store_id ORDER BY first_scraped_at) as next_price,
    -- Price change
    price - LAG(price) OVER (PARTITION BY product_id, supplier_id, store_id ORDER BY first_scraped_at) as price_change,
    -- Percentage change
    CASE 
        WHEN LAG(price) OVER (PARTITION BY product_id, supplier_id, store_id ORDER BY first_scraped_at) > 0 THEN
            ROUND(((price - LAG(price) OVER (PARTITION BY product_id, supplier_id, store_id ORDER BY first_scraped_at)) / 
                   LAG(price) OVER (PARTITION BY product_id, supplier_id, store_id ORDER BY first_scraped_at)) * 100, 2)
        ELSE NULL
    END as price_change_percent
FROM prices
WHERE is_available = TRUE
ORDER BY product_id, first_scraped_at DESC;

-- 8. Statistics view
CREATE OR REPLACE VIEW v_price_compression_stats AS
SELECT 
    COUNT(*) as total_price_records,
    COUNT(DISTINCT (product_id, supplier_id, COALESCE(store_id, -1))) as unique_product_supplier_store,
    ROUND(COUNT(*)::DECIMAL / NULLIF(COUNT(DISTINCT (product_id, supplier_id, COALESCE(store_id, -1))), 0), 2) as avg_records_per_product,
    COUNT(*) FILTER (WHERE last_scraped_at IS NOT NULL) as compressed_records,
    COUNT(*) FILTER (WHERE last_scraped_at IS NULL) as uncompressed_records,
    ROUND(COUNT(*) FILTER (WHERE last_scraped_at IS NOT NULL)::DECIMAL * 100 / COUNT(*), 2) as compression_rate_percent
FROM prices;

COMMENT ON COLUMN prices.first_scraped_at IS 'First time this price was observed';
COMMENT ON COLUMN prices.last_scraped_at IS 'Last time this price was confirmed (if unchanged)';
COMMENT ON FUNCTION upsert_price IS 'Smart insert: updates last_scraped_at if price unchanged, creates new record if changed';
COMMENT ON VIEW v_current_prices IS 'Most recent price per product+supplier+store';
COMMENT ON VIEW v_price_history IS 'Price changes over time with change calculations';

