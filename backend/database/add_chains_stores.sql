-- ==========================================
-- CHAINS & STORES Management
-- Handles retail chains and their branches
-- KingStore example: Chain (קינגסטור) -> Stores (סניפים)
-- ==========================================

-- ==========================================
-- CHAINS (Retail Chains / Networks)
-- ==========================================
CREATE TABLE IF NOT EXISTS chains (
    id SERIAL PRIMARY KEY,
    
    -- Basic Info
    name VARCHAR(200) NOT NULL UNIQUE,
    slug VARCHAR(200) UNIQUE,
    name_he VARCHAR(200), -- Hebrew name
    
    -- Details
    website VARCHAR(500),
    logo_url VARCHAR(500),
    description TEXT,
    
    -- Chain IDs from external sources
    chain_id VARCHAR(50), -- From XML/API (e.g., KingStore chain_id: 7290172900007)
    subchain_id VARCHAR(50), -- From XML/API
    
    -- Classification
    chain_type VARCHAR(50), -- 'supermarket', 'pharmacy', 'electronics', etc.
    
    -- Parent chain (for franchises)
    parent_chain_id INTEGER REFERENCES chains(id),
    
    -- Stats
    store_count INTEGER DEFAULT 0,
    product_count INTEGER DEFAULT 0,
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_chains_chain_id ON chains(chain_id);
CREATE INDEX idx_chains_subchain_id ON chains(subchain_id);
CREATE INDEX idx_chains_slug ON chains(slug);
CREATE INDEX idx_chains_type ON chains(chain_type);

-- ==========================================
-- STORES (Physical Locations / Branches)
-- ==========================================
CREATE TABLE IF NOT EXISTS stores (
    id SERIAL PRIMARY KEY,
    
    -- Relations
    chain_id INTEGER NOT NULL REFERENCES chains(id) ON DELETE CASCADE,
    
    -- Store Info
    store_id VARCHAR(50), -- From XML/API (e.g., KingStore store_id: "001")
    bikoret_no VARCHAR(20), -- Control number (מס' ביקורת)
    
    -- Names
    name VARCHAR(200) NOT NULL,
    name_he VARCHAR(200), -- Hebrew name
    branch_name VARCHAR(200), -- Branch specific name
    
    -- Location
    address TEXT,
    city VARCHAR(100),
    region VARCHAR(100),
    postal_code VARCHAR(20),
    country_code CHAR(2) DEFAULT 'IL',
    
    -- Coordinates
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    
    -- Contact
    phone VARCHAR(50),
    email VARCHAR(200),
    
    -- Hours (JSONB for flexibility)
    opening_hours JSONB,
    /*
    Example:
    {
        "sunday": {"open": "08:00", "close": "22:00"},
        "monday": {"open": "08:00", "close": "22:00"},
        ...
        "friday": {"open": "08:00", "close": "15:00"},
        "saturday": {"closed": true}
    }
    */
    
    -- Features
    has_parking BOOLEAN DEFAULT FALSE,
    has_delivery BOOLEAN DEFAULT FALSE,
    is_kosher BOOLEAN DEFAULT FALSE,
    
    -- Stats
    product_count INTEGER DEFAULT 0,
    price_count INTEGER DEFAULT 0,
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    last_updated TIMESTAMP,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(chain_id, store_id)
);

CREATE INDEX idx_stores_chain ON stores(chain_id);
CREATE INDEX idx_stores_store_id ON stores(store_id);
CREATE INDEX idx_stores_bikoret_no ON stores(bikoret_no);
CREATE INDEX idx_stores_city ON stores(city);
CREATE INDEX idx_stores_location ON stores(latitude, longitude);
CREATE INDEX idx_stores_active ON stores(is_active) WHERE is_active = TRUE;

-- ==========================================
-- Link SUPPLIERS to CHAINS (many-to-many)
-- A supplier might represent a chain or a specific store
-- ==========================================
CREATE TABLE IF NOT EXISTS supplier_chains (
    id SERIAL PRIMARY KEY,
    
    supplier_id INTEGER NOT NULL REFERENCES suppliers(id) ON DELETE CASCADE,
    chain_id INTEGER NOT NULL REFERENCES chains(id) ON DELETE CASCADE,
    
    -- Relationship type
    relationship_type VARCHAR(50), -- 'owner', 'franchisee', 'aggregator'
    
    created_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(supplier_id, chain_id)
);

CREATE INDEX idx_supplier_chains_supplier ON supplier_chains(supplier_id);
CREATE INDEX idx_supplier_chains_chain ON supplier_chains(chain_id);

-- ==========================================
-- Update PRICES table to reference stores
-- Add store_id to track which store the price is from
-- ==========================================
ALTER TABLE prices ADD COLUMN IF NOT EXISTS store_id INTEGER REFERENCES stores(id);
CREATE INDEX IF NOT EXISTS idx_prices_store ON prices(store_id);

-- ==========================================
-- SEED DATA: KingStore Chain & Stores
-- ==========================================
DO $$
DECLARE
    kingstore_chain_id INTEGER;
    kingstore_supplier_id INTEGER;
BEGIN
    -- Get KingStore supplier
    SELECT id INTO kingstore_supplier_id FROM suppliers WHERE slug = 'kingstore';
    
    IF kingstore_supplier_id IS NULL THEN
        RAISE NOTICE 'KingStore supplier not found';
        RETURN;
    END IF;
    
    -- Create KingStore chain
    INSERT INTO chains (
        name, 
        slug, 
        name_he, 
        chain_id, 
        chain_type,
        is_active
    ) VALUES (
        'KingStore',
        'kingstore',
        'קינגסטור',
        '7290172900007',
        'supermarket',
        TRUE
    )
    ON CONFLICT (slug) DO UPDATE SET
        chain_id = EXCLUDED.chain_id,
        updated_at = NOW()
    RETURNING id INTO kingstore_chain_id;
    
    -- Link supplier to chain
    INSERT INTO supplier_chains (supplier_id, chain_id, relationship_type)
    VALUES (kingstore_supplier_id, kingstore_chain_id, 'owner')
    ON CONFLICT (supplier_id, chain_id) DO NOTHING;
    
    RAISE NOTICE 'KingStore chain created with ID: %', kingstore_chain_id;
    
    -- Note: Stores will be auto-created during import from XML files
    -- Each XML file contains store metadata (store_id, store_name, bikoret_no, city, etc.)
    
END $$;

-- ==========================================
-- Helper Functions
-- ==========================================

-- Function to get or create a store
CREATE OR REPLACE FUNCTION get_or_create_store(
    p_chain_id INTEGER,
    p_store_id VARCHAR(50),
    p_name VARCHAR(200),
    p_city VARCHAR(100) DEFAULT NULL,
    p_bikoret_no VARCHAR(20) DEFAULT NULL
) RETURNS INTEGER AS $$
DECLARE
    v_store_id INTEGER;
BEGIN
    -- Try to find existing store
    SELECT id INTO v_store_id
    FROM stores
    WHERE chain_id = p_chain_id AND store_id = p_store_id;
    
    IF v_store_id IS NULL THEN
        -- Create new store
        INSERT INTO stores (
            chain_id,
            store_id,
            name,
            name_he,
            city,
            bikoret_no,
            is_active
        ) VALUES (
            p_chain_id,
            p_store_id,
            p_name,
            p_name,
            p_city,
            p_bikoret_no,
            TRUE
        )
        RETURNING id INTO v_store_id;
        
        -- Update chain store count
        UPDATE chains SET store_count = store_count + 1 WHERE id = p_chain_id;
    ELSE
        -- Update existing store
        UPDATE stores SET
            name = p_name,
            name_he = p_name,
            city = COALESCE(p_city, city),
            bikoret_no = COALESCE(p_bikoret_no, bikoret_no),
            updated_at = NOW()
        WHERE id = v_store_id;
    END IF;
    
    RETURN v_store_id;
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- Views for easy querying
-- ==========================================

-- View: All stores with chain info
CREATE OR REPLACE VIEW v_stores_full AS
SELECT 
    s.*,
    c.name as chain_name,
    c.name_he as chain_name_he,
    c.chain_type,
    c.website as chain_website
FROM stores s
JOIN chains c ON s.chain_id = c.id;

-- View: Store statistics
CREATE OR REPLACE VIEW v_store_stats AS
SELECT 
    s.id as store_id,
    s.name,
    s.city,
    c.name as chain_name,
    COUNT(DISTINCT p.product_id) as unique_products,
    COUNT(p.id) as total_prices,
    MIN(p.price) as min_price,
    MAX(p.price) as max_price,
    AVG(p.price) as avg_price,
    MAX(p.scraped_at) as last_updated
FROM stores s
JOIN chains c ON s.chain_id = c.id
LEFT JOIN prices p ON p.store_id = s.id
GROUP BY s.id, s.name, s.city, c.name;

COMMENT ON TABLE chains IS 'Retail chains and networks (e.g., KingStore, Shufersal)';
COMMENT ON TABLE stores IS 'Physical store locations/branches';
COMMENT ON TABLE supplier_chains IS 'Links suppliers to chains they represent';
COMMENT ON FUNCTION get_or_create_store IS 'Finds or creates a store by chain_id and store_id';

