-- ==========================================
-- GOGOBE - Global Price Tracker
-- Universal schema for ALL products
-- Starting with dental, expanding to everything
-- Built for 50GB+ data
-- ==========================================

-- Create database
-- Run: CREATE DATABASE gogobe;
-- Then: \c gogobe

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;  -- Fuzzy search
CREATE EXTENSION IF NOT EXISTS btree_gin; -- Better indexes

-- ==========================================
-- VERTICALS (Industries/Domains)
-- dental, electronics, fashion, etc.
-- ==========================================
CREATE TABLE verticals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(100),
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    is_priority BOOLEAN DEFAULT FALSE, -- Dental = TRUE first
    
    -- Stats
    category_count INTEGER DEFAULT 0,
    product_count INTEGER DEFAULT 0,
    supplier_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT NOW()
);

-- Seed verticals
INSERT INTO verticals (name, slug, is_priority) VALUES
    ('Dental Equipment', 'dental', TRUE),
    ('Medical Equipment', 'medical', FALSE),
    ('Electronics', 'electronics', FALSE),
    ('Fashion', 'fashion', FALSE),
    ('Home & Garden', 'home-garden', FALSE),
    ('Automotive', 'automotive', FALSE),
    ('Sports & Outdoors', 'sports', FALSE),
    ('Beauty & Health', 'beauty', FALSE);

-- ==========================================
-- CATEGORIES (Hierarchical)
-- Works for ANY vertical
-- ==========================================
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    vertical_id INTEGER REFERENCES verticals(id) ON DELETE CASCADE,
    parent_id INTEGER REFERENCES categories(id),
    
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) NOT NULL,
    full_path VARCHAR(500), -- "dental/surgical/forceps"
    level INTEGER DEFAULT 0,
    
    description TEXT,
    icon VARCHAR(100),
    
    -- Vertical-specific attributes schema
    attribute_schema JSONB, -- Defines what attributes this category needs
    
    -- Stats
    product_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(vertical_id, slug, parent_id)
);

CREATE INDEX idx_categories_vertical ON categories(vertical_id);
CREATE INDEX idx_categories_parent ON categories(parent_id);
CREATE INDEX idx_categories_slug ON categories(slug);
CREATE INDEX idx_categories_path ON categories(full_path);

-- ==========================================
-- BRANDS (Universal)
-- ==========================================
CREATE TABLE brands (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL UNIQUE,
    normalized_name VARCHAR(200) UNIQUE,
    
    -- Details
    country VARCHAR(50),
    website VARCHAR(500),
    logo_url VARCHAR(500),
    description TEXT,
    
    -- Classification
    is_premium BOOLEAN DEFAULT FALSE,
    verticals TEXT[], -- Can sell in multiple verticals
    
    -- Stats
    product_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_brands_normalized_name ON brands(normalized_name);
CREATE INDEX idx_brands_verticals ON brands USING gin(verticals);

-- ==========================================
-- SUPPLIERS (Universal)
-- ==========================================
CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) UNIQUE,
    website VARCHAR(500),
    
    -- Location
    country_code CHAR(2),
    city VARCHAR(100),
    
    -- Type
    supplier_type VARCHAR(50), -- 'manufacturer', 'distributor', 'retailer', 'marketplace'
    verticals TEXT[], -- Which industries they serve
    
    -- Shipping
    ships_internationally BOOLEAN DEFAULT FALSE,
    ships_to_countries TEXT[],
    
    -- Ratings
    reliability_score DECIMAL(3,2) DEFAULT 0.00,
    
    -- Stats
    product_count INTEGER DEFAULT 0,
    last_scraped_at TIMESTAMP,
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_suppliers_verticals ON suppliers USING gin(verticals);
CREATE INDEX idx_suppliers_country ON suppliers(country_code);
CREATE INDEX idx_suppliers_active ON suppliers(is_active) WHERE is_active = TRUE;

-- ==========================================
-- PRODUCTS (Universal, flexible)
-- ==========================================
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    
    -- Basic info
    name VARCHAR(500) NOT NULL,
    normalized_name VARCHAR(500), -- For deduplication
    description TEXT,
    
    -- Classification
    vertical_id INTEGER REFERENCES verticals(id),
    category_id INTEGER REFERENCES categories(id),
    brand_id INTEGER REFERENCES brands(id),
    
    -- Universal identifiers
    model_number VARCHAR(100),
    sku VARCHAR(100),
    upc VARCHAR(20),
    ean VARCHAR(20),
    asin VARCHAR(10), -- Amazon
    gtin VARCHAR(14),
    manufacturer_code VARCHAR(100),
    
    -- Flexible attributes (different per vertical/category)
    attributes JSONB DEFAULT '{}',
    /*
    Dental example:
    {
      "material": "Stainless Steel",
      "length_mm": 180,
      "is_autoclavable": true
    }
    
    Electronics example:
    {
      "screen_size": "6.1 inches",
      "ram": "8GB",
      "storage": "256GB"
    }
    
    Fashion example:
    {
      "size": "M",
      "color": "Black",
      "material": "Cotton"
    }
    */
    
    specifications JSONB DEFAULT '{}',
    features TEXT[],
    
    -- Media (universal)
    main_image_url VARCHAR(500),
    image_urls TEXT[],
    video_url VARCHAR(500),
    
    -- Documents
    manual_pdf_url VARCHAR(500),
    catalog_pdf_url VARCHAR(500),
    
    -- Stats
    view_count INTEGER DEFAULT 0,
    favorite_count INTEGER DEFAULT 0,
    
    -- SEO
    meta_title VARCHAR(200),
    meta_description VARCHAR(500),
    keywords TEXT[],
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    last_scraped_at TIMESTAMP
);

-- Critical indexes
CREATE INDEX idx_products_vertical ON products(vertical_id) WHERE is_active = TRUE;
CREATE INDEX idx_products_category ON products(category_id) WHERE is_active = TRUE;
CREATE INDEX idx_products_brand ON products(brand_id);
CREATE INDEX idx_products_model ON products(model_number);
CREATE INDEX idx_products_asin ON products(asin) WHERE asin IS NOT NULL;
CREATE INDEX idx_products_ean ON products(ean) WHERE ean IS NOT NULL;

-- Full-text search
CREATE INDEX idx_products_search ON products 
    USING gin(to_tsvector('english', COALESCE(name, '') || ' ' || COALESCE(description, '')));

-- Fuzzy matching
CREATE INDEX idx_products_name_trgm ON products USING gin(name gin_trgm_ops);

-- JSONB attributes (for filtering)
CREATE INDEX idx_products_attributes ON products USING gin(attributes);

-- ==========================================
-- PRICES (The big table - 50GB!)
-- This will hold MILLIONS of price records
-- ==========================================
CREATE TABLE prices (
    id BIGSERIAL PRIMARY KEY,
    
    -- Relations
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    supplier_id INTEGER NOT NULL REFERENCES suppliers(id) ON DELETE CASCADE,
    
    -- Price info
    price DECIMAL(12,2) NOT NULL,
    currency CHAR(3) DEFAULT 'USD',
    
    -- Original price (if on sale)
    original_price DECIMAL(12,2),
    discount_percentage DECIMAL(5,2),
    
    -- Quantity/Unit
    quantity INTEGER DEFAULT 1,
    unit VARCHAR(50) DEFAULT 'piece',
    
    -- Sale info
    is_on_sale BOOLEAN DEFAULT FALSE,
    sale_ends_at TIMESTAMP,
    
    -- Availability
    is_available BOOLEAN DEFAULT TRUE,
    stock_level VARCHAR(50),
    
    -- Shipping
    shipping_cost DECIMAL(10,2),
    free_shipping BOOLEAN DEFAULT FALSE,
    
    -- Source
    source_url VARCHAR(1000),
    
    -- Scraping metadata
    scrape_job_id UUID,
    scraped_at TIMESTAMP DEFAULT NOW(),
    
    -- Validation
    is_verified BOOLEAN DEFAULT FALSE,
    
    CONSTRAINT valid_price CHECK (price >= 0)
);

-- CRITICAL indexes for 50GB performance!
CREATE INDEX idx_prices_product_time ON prices(product_id, scraped_at DESC);
CREATE INDEX idx_prices_supplier_time ON prices(supplier_id, scraped_at DESC);
CREATE INDEX idx_prices_scraped_at ON prices(scraped_at DESC);
CREATE INDEX idx_prices_available ON prices(is_available) WHERE is_available = TRUE;
CREATE INDEX idx_prices_product_supplier ON prices(product_id, supplier_id, scraped_at DESC);

-- Partition by month for better performance (optional but recommended for 50GB)
-- ALTER TABLE prices PARTITION BY RANGE (scraped_at);
-- CREATE TABLE prices_2025_12 PARTITION OF prices
--     FOR VALUES FROM ('2025-12-01') TO ('2026-01-01');

-- ==========================================
-- PRICE SUMMARY (for fast queries)
-- ==========================================
CREATE TABLE price_summary (
    product_id BIGINT PRIMARY KEY REFERENCES products(id) ON DELETE CASCADE,
    
    -- Current
    current_min_price DECIMAL(12,2),
    current_min_supplier_id INTEGER,
    current_avg_price DECIMAL(12,2),
    
    -- Historical
    all_time_low DECIMAL(12,2),
    all_time_low_date TIMESTAMP,
    all_time_high DECIMAL(12,2),
    all_time_high_date TIMESTAMP,
    
    -- Recent trends
    price_30d_avg DECIMAL(12,2),
    price_90d_avg DECIMAL(12,2),
    
    -- Changes
    price_change_7d DECIMAL(10,2),
    price_change_30d DECIMAL(10,2),
    
    -- Availability
    available_supplier_count INTEGER DEFAULT 0,
    
    last_updated TIMESTAMP DEFAULT NOW()
);

-- ==========================================
-- SCRAPING JOBS
-- ==========================================
CREATE TABLE scraping_jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    vertical_id INTEGER REFERENCES verticals(id),
    supplier_id INTEGER REFERENCES suppliers(id),
    
    job_type VARCHAR(50),
    status VARCHAR(50) DEFAULT 'running',
    
    started_at TIMESTAMP DEFAULT NOW(),
    completed_at TIMESTAMP,
    
    -- Stats
    products_found INTEGER DEFAULT 0,
    products_new INTEGER DEFAULT 0,
    prices_collected INTEGER DEFAULT 0,
    errors_count INTEGER DEFAULT 0,
    
    config JSONB,
    error_log TEXT
);

CREATE INDEX idx_jobs_status ON scraping_jobs(status);
CREATE INDEX idx_jobs_vertical ON scraping_jobs(vertical_id);

-- ==========================================
-- SEED DATA - Dental Categories
-- ==========================================
DO $$
DECLARE
    dental_id INTEGER;
BEGIN
    -- Get dental vertical ID
    SELECT id INTO dental_id FROM verticals WHERE slug = 'dental';
    
    -- Insert dental categories
    INSERT INTO categories (vertical_id, name, slug, level, full_path) VALUES
        (dental_id, 'Cleaning & Prevention', 'cleaning-prevention', 1, 'dental/cleaning-prevention'),
        (dental_id, 'Diagnostic', 'diagnostic', 1, 'dental/diagnostic'),
        (dental_id, 'Restorative', 'restorative', 1, 'dental/restorative'),
        (dental_id, 'Endodontics', 'endodontics', 1, 'dental/endodontics'),
        (dental_id, 'Surgery', 'surgery', 1, 'dental/surgery'),
        (dental_id, 'Orthodontics', 'orthodontics', 1, 'dental/orthodontics'),
        (dental_id, 'Prosthodontics', 'prosthodontics', 1, 'dental/prosthodontics'),
        (dental_id, 'Periodontics', 'periodontics', 1, 'dental/periodontics'),
        (dental_id, 'Implantology', 'implantology', 1, 'dental/implantology'),
        (dental_id, 'Radiology', 'radiology', 1, 'dental/radiology');
END $$;

-- Dental brands
INSERT INTO brands (name, normalized_name, country, is_premium, verticals) VALUES
    ('Hu-Friedy', 'hu-friedy', 'USA', TRUE, ARRAY['dental']),
    ('Dentsply Sirona', 'dentsply-sirona', 'USA', TRUE, ARRAY['dental']),
    ('KaVo Kerr', 'kavo-kerr', 'Germany', TRUE, ARRAY['dental']),
    ('NSK', 'nsk', 'Japan', TRUE, ARRAY['dental']),
    ('Sklar Surgical', 'sklar-surgical', 'USA', FALSE, ARRAY['dental', 'medical']);

-- Dental suppliers
INSERT INTO suppliers (name, slug, website, country_code, supplier_type, verticals, ships_internationally) VALUES
    ('Henry Schein', 'henry-schein', 'https://www.henryschein.com', 'US', 'distributor', ARRAY['dental', 'medical'], TRUE),
    ('Patterson Dental', 'patterson-dental', 'https://www.pattersondental.com', 'US', 'distributor', ARRAY['dental'], TRUE),
    ('Dental Directory', 'dental-directory', 'https://www.dentaldirectory.co.uk', 'GB', 'retailer', ARRAY['dental'], TRUE),
    ('Net32', 'net32', 'https://www.net32.com', 'US', 'retailer', ARRAY['dental'], TRUE);

-- ==========================================
-- VIEWS
-- ==========================================

-- Latest prices per product/supplier
CREATE OR REPLACE VIEW v_latest_prices AS
SELECT DISTINCT ON (product_id, supplier_id)
    p.*,
    pr.name as product_name,
    pr.vertical_id,
    s.name as supplier_name
FROM prices p
JOIN products pr ON p.product_id = pr.id
JOIN suppliers s ON p.supplier_id = s.id
WHERE p.is_available = TRUE
ORDER BY product_id, supplier_id, scraped_at DESC;

-- Product catalog
CREATE OR REPLACE VIEW v_product_catalog AS
SELECT 
    p.id,
    p.name,
    v.name as vertical_name,
    c.name as category_name,
    b.name as brand_name,
    ps.current_min_price,
    ps.available_supplier_count,
    p.is_active
FROM products p
LEFT JOIN verticals v ON p.vertical_id = v.id
LEFT JOIN categories c ON p.category_id = c.id
LEFT JOIN brands b ON p.brand_id = b.id
LEFT JOIN price_summary ps ON p.id = ps.product_id
WHERE p.is_active = TRUE;

-- ==========================================
-- FUNCTIONS
-- ==========================================

-- Update timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to tables
CREATE TRIGGER trg_categories_updated_at BEFORE UPDATE ON categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_suppliers_updated_at BEFORE UPDATE ON suppliers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ==========================================
-- DONE!
-- ==========================================

SELECT 'Gogobe schema created successfully!' as status,
       'Universal schema ready for dental and beyond!' as message;






