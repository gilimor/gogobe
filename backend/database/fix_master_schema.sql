-- Fix Master Product Schema - ROBUST VERSION

-- 1. Create table if not exists (with all columns we need)
CREATE TABLE IF NOT EXISTS master_products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    description TEXT,
    main_image_url VARCHAR(500),
    
    -- "The Patent" Columns
    global_id VARCHAR(100) UNIQUE,
    global_name VARCHAR(500),
    global_ean VARCHAR(50),
    category VARCHAR(100),
    confidence_score DECIMAL(3,2) DEFAULT 1.0,
    creation_method VARCHAR(50),
    
    -- External Links
    wikipedia_url VARCHAR(500),
    youtube_url VARCHAR(500),

    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 2. Add columns if table existed but columns were missing (Idempotent)
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='master_products' AND column_name='global_ean') THEN
        ALTER TABLE master_products ADD COLUMN global_ean VARCHAR(50);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='master_products' AND column_name='global_id') THEN
        ALTER TABLE master_products ADD COLUMN global_id VARCHAR(100) UNIQUE;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='master_products' AND column_name='category') THEN
        ALTER TABLE master_products ADD COLUMN category VARCHAR(100);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='master_products' AND column_name='confidence_score') THEN
        ALTER TABLE master_products ADD COLUMN confidence_score DECIMAL(3,2) DEFAULT 1.0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='master_products' AND column_name='creation_method') THEN
        ALTER TABLE master_products ADD COLUMN creation_method VARCHAR(50);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='master_products' AND column_name='global_name') THEN
        ALTER TABLE master_products ADD COLUMN global_name VARCHAR(500);
    END IF;
END $$;


-- 3. Indexes
CREATE INDEX IF NOT EXISTS idx_master_global_ean ON master_products(global_ean);
CREATE INDEX IF NOT EXISTS idx_master_global_id ON master_products(global_id);
CREATE INDEX IF NOT EXISTS idx_master_global_name_trgm ON master_products USING gin(global_name gin_trgm_ops);


-- 4. Ensure product_master_links table exists
CREATE TABLE IF NOT EXISTS product_master_links (
    id BIGSERIAL PRIMARY KEY,
    master_product_id BIGINT REFERENCES master_products(id) ON DELETE CASCADE,
    product_id BIGINT UNIQUE REFERENCES products(id) ON DELETE CASCADE,
    
    confidence_score DECIMAL(3,2) DEFAULT 1.0,
    match_method VARCHAR(50), -- 'manual', 'llm', 'rule-based', 'barcode', 'created'
    link_method VARCHAR(50),  -- Alias
    link_metadata JSONB,
    
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_links_master ON product_master_links(master_product_id);
CREATE INDEX IF NOT EXISTS idx_links_product ON product_master_links(product_id);


-- 5. Add master_product_id to products table (Cache/Direct Link)
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='master_product_id') THEN
        ALTER TABLE products ADD COLUMN master_product_id BIGINT REFERENCES master_products(id);
        CREATE INDEX idx_products_master ON products(master_product_id);
    END IF;
END $$;


-- 6. Add master_product_id to prices table (For fast filtering)
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='prices' AND column_name='master_product_id') THEN
        ALTER TABLE prices ADD COLUMN master_product_id BIGINT REFERENCES master_products(id);
        CREATE INDEX idx_prices_master ON prices(master_product_id);
    END IF;
END $$;

-- 7. Add matching_feedback table
CREATE TABLE IF NOT EXISTS matching_feedback (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES products(id),
    master_product_id BIGINT REFERENCES master_products(id),
    feedback_type VARCHAR(20), -- 'approve', 'reject'
    created_at TIMESTAMP DEFAULT NOW()
);

SELECT 'Schema fixed successfully' as result;
