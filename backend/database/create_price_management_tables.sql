-- ============================================
-- GOGOBE PRICE MANAGEMENT SYSTEM
-- Complete database schema for managing multi-source price data
-- ============================================

-- ============================================
-- 1. STORE CHAINS TABLE
-- Track supermarket chains and their stores
-- ============================================
CREATE TABLE IF NOT EXISTS store_chains (
    id SERIAL PRIMARY KEY,
    
    -- Chain identification
    chain_name VARCHAR(200) NOT NULL,
    chain_code VARCHAR(50), -- Official chain ID (e.g., 7290058108879)
    sub_chain_id VARCHAR(50),
    
    -- Parent source
    price_source_id INTEGER REFERENCES price_sources(id) ON DELETE CASCADE,
    
    -- Status
    is_active BOOLEAN DEFAULT true,
    
    -- Metadata
    country_code CHAR(2) DEFAULT 'IL',
    website_url TEXT,
    notes TEXT,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(chain_code, sub_chain_id)
);

-- ============================================
-- 2. STORES TABLE
-- Individual store locations
-- ============================================
CREATE TABLE IF NOT EXISTS stores (
    id SERIAL PRIMARY KEY,
    
    -- Store identification
    store_name VARCHAR(200) NOT NULL,
    store_code VARCHAR(50), -- Store ID from XML (e.g., 15)
    bikoret_no VARCHAR(50), -- Israeli supervision number
    
    -- Parent chain
    chain_id INTEGER REFERENCES store_chains(id) ON DELETE CASCADE,
    
    -- Location
    city VARCHAR(100),
    address TEXT,
    zip_code VARCHAR(20),
    
    -- Status
    is_active BOOLEAN DEFAULT true,
    last_update_date TIMESTAMP,
    
    -- Metadata
    config JSONB DEFAULT '{}',
    notes TEXT,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(chain_id, store_code)
);

-- ============================================
-- 3. DOWNLOADED FILES TRACKING
-- Track all downloaded price files to avoid duplicates
-- ============================================
CREATE TABLE IF NOT EXISTS downloaded_files (
    id SERIAL PRIMARY KEY,
    
    -- File identification
    filename VARCHAR(500) NOT NULL,
    file_hash VARCHAR(64), -- SHA256 hash of file content
    file_size BIGINT,
    
    -- Source tracking
    price_source_id INTEGER REFERENCES price_sources(id) ON DELETE CASCADE,
    store_id INTEGER REFERENCES stores(id) ON DELETE SET NULL,
    chain_id INTEGER REFERENCES store_chains(id) ON DELETE SET NULL,
    
    -- File metadata from filename
    file_type VARCHAR(50), -- 'Prices', 'PricesFull', 'Promos', 'PromosFull', 'Stores'
    file_timestamp TIMESTAMP, -- Extracted from filename (e.g., 202512191429)
    
    -- Download info
    download_url TEXT,
    local_path TEXT,
    downloaded_at TIMESTAMP DEFAULT NOW(),
    
    -- Processing status
    processing_status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'processing', 'completed', 'failed'
    processing_started_at TIMESTAMP,
    processing_completed_at TIMESTAMP,
    processing_error TEXT,
    
    -- Import statistics
    products_found INTEGER DEFAULT 0,
    products_imported INTEGER DEFAULT 0,
    prices_imported INTEGER DEFAULT 0,
    
    -- Metadata
    file_metadata JSONB DEFAULT '{}', -- Store XML metadata (ChainId, StoreId, etc.)
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(filename, price_source_id)
);

-- ============================================
-- 4. SCRAPING SESSIONS
-- Track each scraping run for monitoring and debugging
-- ============================================
CREATE TABLE IF NOT EXISTS scraping_sessions (
    id SERIAL PRIMARY KEY,
    
    -- Session info
    session_name VARCHAR(200),
    price_source_id INTEGER REFERENCES price_sources(id) ON DELETE CASCADE,
    
    -- Status
    status VARCHAR(50) DEFAULT 'running', -- 'running', 'completed', 'failed', 'partial'
    
    -- Statistics
    files_found INTEGER DEFAULT 0,
    files_downloaded INTEGER DEFAULT 0,
    files_processed INTEGER DEFAULT 0,
    files_failed INTEGER DEFAULT 0,
    total_products_imported INTEGER DEFAULT 0,
    total_prices_imported INTEGER DEFAULT 0,
    
    -- Timing
    started_at TIMESTAMP DEFAULT NOW(),
    completed_at TIMESTAMP,
    duration_seconds INTEGER,
    
    -- Error tracking
    error_message TEXT,
    error_details JSONB DEFAULT '{}',
    
    -- Metadata
    config JSONB DEFAULT '{}',
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- INDEXES for performance
-- ============================================

-- Store chains
CREATE INDEX IF NOT EXISTS idx_store_chains_source ON store_chains(price_source_id);
CREATE INDEX IF NOT EXISTS idx_store_chains_active ON store_chains(is_active) WHERE is_active = true;

-- Stores
CREATE INDEX IF NOT EXISTS idx_stores_chain ON stores(chain_id);
CREATE INDEX IF NOT EXISTS idx_stores_active ON stores(is_active) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_stores_city ON stores(city);

-- Downloaded files
CREATE INDEX IF NOT EXISTS idx_downloaded_files_source ON downloaded_files(price_source_id);
CREATE INDEX IF NOT EXISTS idx_downloaded_files_store ON downloaded_files(store_id);
CREATE INDEX IF NOT EXISTS idx_downloaded_files_status ON downloaded_files(processing_status);
CREATE INDEX IF NOT EXISTS idx_downloaded_files_hash ON downloaded_files(file_hash);
CREATE INDEX IF NOT EXISTS idx_downloaded_files_timestamp ON downloaded_files(file_timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_downloaded_files_type ON downloaded_files(file_type);

-- Scraping sessions
CREATE INDEX IF NOT EXISTS idx_scraping_sessions_source ON scraping_sessions(price_source_id);
CREATE INDEX IF NOT EXISTS idx_scraping_sessions_status ON scraping_sessions(status);
CREATE INDEX IF NOT EXISTS idx_scraping_sessions_started ON scraping_sessions(started_at DESC);

-- ============================================
-- TRIGGERS for updated_at
-- ============================================

CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_store_chains_updated_at
    BEFORE UPDATE ON store_chains
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trg_stores_updated_at
    BEFORE UPDATE ON stores
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

-- ============================================
-- COMMENTS for documentation
-- ============================================

COMMENT ON TABLE store_chains IS 'Supermarket chains and their relationships to price sources';
COMMENT ON TABLE stores IS 'Individual store locations within chains';
COMMENT ON TABLE downloaded_files IS 'Track all downloaded price files to prevent duplicates and enable reprocessing';
COMMENT ON TABLE scraping_sessions IS 'Log each scraping run for monitoring and debugging';

COMMENT ON COLUMN downloaded_files.file_hash IS 'SHA256 hash to detect duplicate content even with different filenames';
COMMENT ON COLUMN downloaded_files.file_timestamp IS 'Timestamp extracted from filename (e.g., Promo...202512191429.gz -> 2025-12-19 14:29)';
COMMENT ON COLUMN downloaded_files.processing_status IS 'Current processing state: pending/processing/completed/failed';

-- ============================================
-- SUCCESS MESSAGE
-- ============================================
DO $$
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Price Management Tables Created!';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Tables created:';
    RAISE NOTICE '  - store_chains';
    RAISE NOTICE '  - stores';
    RAISE NOTICE '  - downloaded_files';
    RAISE NOTICE '  - scraping_sessions';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Ready for multi-source price management!';
    RAISE NOTICE '========================================';
END $$;





