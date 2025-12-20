-- Price Sources Management Table
-- Track all external sources for price data

CREATE TABLE IF NOT EXISTS price_sources (
    id SERIAL PRIMARY KEY,
    
    -- Source identification
    name VARCHAR(200) NOT NULL,
    source_type VARCHAR(50) NOT NULL, -- 'website', 'api', 'ftp', 'manual'
    base_url TEXT,
    
    -- Vertical/domain
    vertical_id INTEGER REFERENCES verticals(id),
    
    -- Status
    is_active BOOLEAN DEFAULT true,
    last_check_at TIMESTAMP,
    last_success_at TIMESTAMP,
    check_frequency_hours INTEGER DEFAULT 24, -- How often to check
    
    -- Configuration
    config JSONB DEFAULT '{}', -- API keys, credentials, settings
    
    -- Statistics
    total_files_found INTEGER DEFAULT 0,
    total_files_processed INTEGER DEFAULT 0,
    total_products_imported INTEGER DEFAULT 0,
    total_prices_imported INTEGER DEFAULT 0,
    last_error TEXT,
    error_count INTEGER DEFAULT 0,
    
    -- Metadata
    country_code CHAR(2) DEFAULT 'IL',
    language VARCHAR(10) DEFAULT 'he',
    notes TEXT,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_price_sources_active ON price_sources(is_active) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_price_sources_vertical ON price_sources(vertical_id);
CREATE INDEX IF NOT EXISTS idx_price_sources_type ON price_sources(source_type);

-- Trigger for updated_at
CREATE OR REPLACE FUNCTION update_price_sources_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_price_sources_updated_at
    BEFORE UPDATE ON price_sources
    FOR EACH ROW
    EXECUTE FUNCTION update_price_sources_updated_at();

-- Comments
COMMENT ON TABLE price_sources IS 'External sources for price data (websites, APIs, FTP servers)';
COMMENT ON COLUMN price_sources.config IS 'JSON config: API keys, auth tokens, scraping rules, etc.';
COMMENT ON COLUMN price_sources.check_frequency_hours IS 'How often to check this source for new data';

-- Insert first source: KingStore
INSERT INTO price_sources (
    name,
    source_type,
    base_url,
    vertical_id,
    config,
    notes
) VALUES (
    'KingStore - Israeli Supermarket XML Files',
    'website',
    'https://kingstore.binaprojects.com/Main.aspx',
    (SELECT id FROM verticals WHERE slug = 'supermarket'),
    '{
        "file_types": ["Prices", "PricesFull", "Stores", "Promos", "PromosFull"],
        "file_extensions": [".xml", ".gz"],
        "encoding": "windows-1255"
    }'::jsonb,
    'Public repository of XML files from Israeli supermarket chains per transparency law (חוק שקיפות מחירים)'
) ON CONFLICT DO NOTHING;

-- Success message
DO $$
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Price Sources Table Created!';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Table: price_sources';
    RAISE NOTICE 'First source added: KingStore';
    RAISE NOTICE 'URL: https://kingstore.binaprojects.com/Main.aspx';
    RAISE NOTICE '========================================';
END $$;






