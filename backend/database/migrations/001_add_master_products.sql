-- Migration: Add Master Products features
-- Date: 2025-12-20

-- 1. Create master_products table
CREATE TABLE IF NOT EXISTS master_products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    main_image_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 2. Create product_master_links table
CREATE TABLE IF NOT EXISTS product_master_links (
    id BIGSERIAL PRIMARY KEY,
    master_product_id BIGINT REFERENCES master_products(id) ON DELETE CASCADE,
    product_id BIGINT UNIQUE REFERENCES products(id) ON DELETE CASCADE,
    confidence_score DECIMAL(3,2) DEFAULT 1.0,
    match_method VARCHAR(50), -- 'manual', 'llm', 'rule-based'
    created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for links
CREATE INDEX IF NOT EXISTS idx_links_master ON product_master_links(master_product_id);
CREATE INDEX IF NOT EXISTS idx_links_product ON product_master_links(product_id);

-- 3. Add column to prices
ALTER TABLE prices ADD COLUMN IF NOT EXISTS master_product_id BIGINT REFERENCES master_products(id);
CREATE INDEX IF NOT EXISTS idx_prices_master ON prices(master_product_id);

-- 4. Initial Seed (Optional: logic to be handled by app)
-- SELECT 'Migration Complete' as status;
