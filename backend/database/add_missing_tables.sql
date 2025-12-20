-- ============================================
-- Missing Tables & Improvements
-- ============================================

-- ============================================
-- CURRENCIES Table
-- ============================================
CREATE TABLE IF NOT EXISTS currencies (
    code CHAR(3) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    name_he VARCHAR(100),
    symbol VARCHAR(10),
    exchange_rate_to_usd DECIMAL(10,6),
    exchange_rate_to_ils DECIMAL(10,6),
    last_updated TIMESTAMP DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_currencies_active ON currencies(is_active) WHERE is_active = TRUE;

-- Seed common currencies
INSERT INTO currencies (code, name, name_he, symbol, exchange_rate_to_usd, exchange_rate_to_ils, is_active) VALUES
    ('ILS', 'Israeli Shekel', 'שקל ישראלי', '₪', 0.27, 1.00, TRUE),
    ('USD', 'US Dollar', 'דולר אמריקאי', '$', 1.00, 3.70, TRUE),
    ('EUR', 'Euro', 'יורו', '€', 1.08, 4.00, TRUE),
    ('GBP', 'British Pound', 'לירה סטרלינג', '£', 1.27, 4.70, TRUE)
ON CONFLICT (code) DO UPDATE SET
    exchange_rate_to_usd = EXCLUDED.exchange_rate_to_usd,
    exchange_rate_to_ils = EXCLUDED.exchange_rate_to_ils,
    last_updated = NOW();

-- ============================================
-- PRODUCT MERGES Table (for future deduplication)
-- ============================================
CREATE TABLE IF NOT EXISTS product_merges (
    id SERIAL PRIMARY KEY,
    
    -- The master product (the one we keep)
    master_product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    
    -- The duplicate product (redirects to master)
    duplicate_product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    
    -- Merge details
    merge_reason TEXT,
    similarity_score DECIMAL(5,2), -- 0-100, how similar they are
    merge_method VARCHAR(50), -- 'manual', 'barcode_match', 'name_similarity', 'ai_match'
    
    -- Who merged
    merged_by VARCHAR(100), -- user or 'system'
    merged_at TIMESTAMP DEFAULT NOW(),
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    
    UNIQUE(duplicate_product_id),
    CHECK (master_product_id != duplicate_product_id)
);

CREATE INDEX idx_product_merges_master ON product_merges(master_product_id);
CREATE INDEX idx_product_merges_duplicate ON product_merges(duplicate_product_id);
CREATE INDEX idx_product_merges_active ON product_merges(is_active) WHERE is_active = TRUE;

-- ============================================
-- View: Unified Products (with merges)
-- ============================================
CREATE OR REPLACE VIEW v_products_unified AS
SELECT 
    COALESCE(pm.master_product_id, p.id) as unified_id,
    p.id as original_id,
    p.name,
    p.description,
    p.ean,
    p.upc,
    p.manufacturer_code,
    p.attributes,
    p.vertical_id,
    p.category_id,
    p.brand_id,
    CASE WHEN pm.id IS NOT NULL THEN TRUE ELSE FALSE END as is_merged,
    pm.master_product_id as merged_to
FROM products p
LEFT JOIN product_merges pm ON p.id = pm.duplicate_product_id AND pm.is_active = TRUE;

-- ============================================
-- Helper Functions
-- ============================================

-- Function: Get or Create Currency
CREATE OR REPLACE FUNCTION get_or_create_currency(
    p_code CHAR(3),
    p_name VARCHAR(100) DEFAULT NULL,
    p_symbol VARCHAR(10) DEFAULT NULL
) RETURNS CHAR(3) AS $$
DECLARE
    v_code CHAR(3);
BEGIN
    -- Try to find existing currency
    SELECT code INTO v_code FROM currencies WHERE code = p_code;
    
    IF v_code IS NULL THEN
        -- Create new currency
        INSERT INTO currencies (code, name, symbol, exchange_rate_to_usd, is_active)
        VALUES (p_code, COALESCE(p_name, p_code), p_symbol, 0, TRUE)
        ON CONFLICT (code) DO NOTHING
        RETURNING code INTO v_code;
    END IF;
    
    RETURN v_code;
END;
$$ LANGUAGE plpgsql;

-- Function: Find Product (with smart matching)
CREATE OR REPLACE FUNCTION find_product_id(
    p_ean VARCHAR(20) DEFAULT NULL,
    p_upc VARCHAR(20) DEFAULT NULL,
    p_manufacturer_code VARCHAR(100) DEFAULT NULL,
    p_name VARCHAR(500) DEFAULT NULL,
    p_vertical_id INTEGER DEFAULT NULL
) RETURNS BIGINT AS $$
DECLARE
    v_product_id BIGINT;
BEGIN
    -- Priority 1: EAN
    IF p_ean IS NOT NULL AND p_ean != '' THEN
        SELECT id INTO v_product_id 
        FROM products 
        WHERE ean = p_ean 
        LIMIT 1;
        
        IF v_product_id IS NOT NULL THEN
            RETURN v_product_id;
        END IF;
    END IF;
    
    -- Priority 2: UPC
    IF p_upc IS NOT NULL AND p_upc != '' THEN
        SELECT id INTO v_product_id 
        FROM products 
        WHERE upc = p_upc 
        LIMIT 1;
        
        IF v_product_id IS NOT NULL THEN
            RETURN v_product_id;
        END IF;
    END IF;
    
    -- Priority 3: Manufacturer Code
    IF p_manufacturer_code IS NOT NULL AND p_manufacturer_code != '' THEN
        SELECT id INTO v_product_id 
        FROM products 
        WHERE manufacturer_code = p_manufacturer_code 
        LIMIT 1;
        
        IF v_product_id IS NOT NULL THEN
            RETURN v_product_id;
        END IF;
    END IF;
    
    -- Priority 4: Exact Name Match (with vertical)
    IF p_name IS NOT NULL AND p_name != '' THEN
        SELECT id INTO v_product_id 
        FROM products 
        WHERE name = p_name 
            AND (p_vertical_id IS NULL OR vertical_id = p_vertical_id)
        LIMIT 1;
        
        IF v_product_id IS NOT NULL THEN
            RETURN v_product_id;
        END IF;
    END IF;
    
    -- Not found
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- Update prices table to reference currency
-- ============================================
ALTER TABLE prices 
    ADD CONSTRAINT fk_prices_currency 
    FOREIGN KEY (currency) 
    REFERENCES currencies(code);

-- ============================================
-- Statistics View
-- ============================================
CREATE OR REPLACE VIEW v_import_statistics AS
SELECT 
    'products' as entity,
    COUNT(*) as total,
    COUNT(*) FILTER (WHERE is_active = TRUE) as active,
    COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '24 hours') as added_today
FROM products
UNION ALL
SELECT 
    'prices' as entity,
    COUNT(*) as total,
    COUNT(*) FILTER (WHERE is_available = TRUE) as active,
    COUNT(*) FILTER (WHERE scraped_at > NOW() - INTERVAL '24 hours') as added_today
FROM prices
UNION ALL
SELECT 
    'chains' as entity,
    COUNT(*) as total,
    COUNT(*) FILTER (WHERE is_active = TRUE) as active,
    COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '24 hours') as added_today
FROM chains
UNION ALL
SELECT 
    'stores' as entity,
    COUNT(*) as total,
    COUNT(*) FILTER (WHERE is_active = TRUE) as active,
    COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '24 hours') as added_today
FROM stores
UNION ALL
SELECT 
    'suppliers' as entity,
    COUNT(*) as total,
    COUNT(*) FILTER (WHERE is_active = TRUE) as active,
    COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '24 hours') as added_today
FROM suppliers;

-- ============================================
-- Comments
-- ============================================
COMMENT ON TABLE currencies IS 'Supported currencies with exchange rates';
COMMENT ON TABLE product_merges IS 'Product deduplication - maps duplicate products to master products';
COMMENT ON VIEW v_products_unified IS 'Unified view of products considering merges';
COMMENT ON FUNCTION get_or_create_currency IS 'Ensures currency exists, creates if not found';
COMMENT ON FUNCTION find_product_id IS 'Smart product lookup: EAN > UPC > Code > Name';

