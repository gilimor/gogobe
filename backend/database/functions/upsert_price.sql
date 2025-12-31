-- ==========================================
-- upsert_price Function
-- Prevents duplicate prices in the database
-- ==========================================
-- Purpose: Smart price insertion/update
-- - Checks if price already exists for product+supplier+store
-- - If exists and price changed → insert new record
-- - If exists and price unchanged → update timestamp only
-- - If not exists → insert new record
-- ==========================================

CREATE OR REPLACE FUNCTION upsert_price(
    p_product_id BIGINT,
    p_supplier_id INTEGER,
    p_store_id BIGINT,
    p_price DECIMAL(12,2),
    p_currency VARCHAR(3) DEFAULT 'ILS',
    p_is_available BOOLEAN DEFAULT TRUE,
    p_tolerance DECIMAL DEFAULT 0.01  -- Price tolerance (1% default)
) RETURNS BIGINT AS $$
DECLARE
    v_existing_price_id BIGINT;
    v_existing_price DECIMAL(12,2);
    v_price_changed BOOLEAN;
    v_new_price_id BIGINT;
BEGIN
    -- ==========================================
    -- Step 1: Check if price record exists
    -- ==========================================
    SELECT id, price 
    INTO v_existing_price_id, v_existing_price
    FROM prices
    WHERE product_id = p_product_id
      AND supplier_id = p_supplier_id
      AND store_id = p_store_id
      AND is_available = TRUE
    ORDER BY scraped_at DESC
    LIMIT 1;
    
    -- ==========================================
    -- Step 2: If exists, check if price changed
    -- ==========================================
    IF FOUND THEN
        -- Calculate if price changed significantly (beyond tolerance)
        v_price_changed := ABS(v_existing_price - p_price) > p_tolerance;
        
        IF v_price_changed THEN
            -- Price changed → Insert new record
            INSERT INTO prices (
                product_id,
                supplier_id,
                store_id,
                price,
                currency,
                is_available,
                scraped_at
            ) VALUES (
                p_product_id,
                p_supplier_id,
                p_store_id,
                p_price,
                p_currency,
                p_is_available,
                NOW()
            ) RETURNING id INTO v_new_price_id;
            
            RAISE DEBUG 'Price changed: % → % (inserted new record ID: %)', 
                v_existing_price, p_price, v_new_price_id;
            
            RETURN v_new_price_id;
        ELSE
            -- Price unchanged → Update timestamp only
            UPDATE prices
            SET scraped_at = NOW()
            WHERE id = v_existing_price_id;
            
            RAISE DEBUG 'Price unchanged: % (updated timestamp for ID: %)', 
                v_existing_price, v_existing_price_id;
            
            RETURN v_existing_price_id;
        END IF;
    ELSE
        -- ==========================================
        -- Step 3: No existing price → Insert new
        -- ==========================================
        INSERT INTO prices (
            product_id,
            supplier_id,
            store_id,
            price,
            currency,
            is_available,
            scraped_at
        ) VALUES (
            p_product_id,
            p_supplier_id,
            p_store_id,
            p_price,
            p_currency,
            p_is_available,
            NOW()
        ) RETURNING id INTO v_new_price_id;
        
        RAISE DEBUG 'New price created: % (ID: %)', p_price, v_new_price_id;
        
        RETURN v_new_price_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- Create batch version for better performance
-- ==========================================
CREATE OR REPLACE FUNCTION upsert_price_batch(
    p_prices JSONB  -- Array of price objects
) RETURNS TABLE(
    row_num INTEGER,
    price_id BIGINT,
    action VARCHAR(10)
) AS $$
DECLARE
    v_price JSONB;
    v_result_id BIGINT;
    v_counter INTEGER := 0;
BEGIN
    -- Loop through each price in the batch
    FOR v_price IN SELECT * FROM jsonb_array_elements(p_prices)
    LOOP
        v_counter := v_counter + 1;
        
        -- Call single upsert for each price
        SELECT upsert_price(
            (v_price->>'product_id')::BIGINT,
            (v_price->>'supplier_id')::INTEGER,
            (v_price->>'store_id')::BIGINT,
            (v_price->>'price')::DECIMAL,
            COALESCE(v_price->>'currency', 'ILS'),
            COALESCE((v_price->>'is_available')::BOOLEAN, TRUE),
            COALESCE((v_price->>'tolerance')::DECIMAL, 0.01)
        ) INTO v_result_id;
        
        -- Return result
        row_num := v_counter;
        price_id := v_result_id;
        action := 'upserted';
        RETURN NEXT;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- Usage Examples
-- ==========================================

-- Example 1: Single price insert
-- SELECT upsert_price(
--     12345,      -- product_id
--     1,          -- supplier_id
--     100,        -- store_id
--     5.90,       -- price
--     'ILS',      -- currency
--     TRUE,       -- is_available
--     0.01        -- tolerance (1%)
-- );

-- Example 2: Batch insert
-- SELECT * FROM upsert_price_batch('[
--     {"product_id": 12345, "supplier_id": 1, "store_id": 100, "price": 5.90},
--     {"product_id": 12346, "supplier_id": 1, "store_id": 100, "price": 7.50}
-- ]'::jsonb);

-- ==========================================
-- Performance Notes
-- ==========================================
-- Indexes required for optimal performance:
-- CREATE INDEX idx_prices_lookup ON prices(product_id, supplier_id, store_id, is_available, scraped_at DESC);
-- CREATE INDEX idx_prices_product_supplier ON prices(product_id, supplier_id) WHERE is_available = TRUE;
