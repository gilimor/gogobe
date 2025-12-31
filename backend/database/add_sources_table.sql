-- Table for tracking scraped sources (PDFs, magazines, etc.)
-- Prevents duplicate scanning and maintains history

CREATE TABLE IF NOT EXISTS scraped_sources (
    id SERIAL PRIMARY KEY,
    
    -- File identification
    source_type VARCHAR(50) NOT NULL, -- 'pdf', 'website', 'magazine', 'catalog'
    source_name VARCHAR(500) NOT NULL, -- Original filename or URL
    file_hash VARCHAR(64) UNIQUE, -- SHA256 hash for duplicate detection
    file_size_bytes BIGINT,
    
    -- Source details
    publisher VARCHAR(200), -- Magazine/catalog publisher
    issue_date DATE, -- Publication date
    issue_number VARCHAR(50), -- Issue/edition number
    language VARCHAR(10) DEFAULT 'en',
    country_code CHAR(2),
    
    -- Scanning details
    scan_date TIMESTAMP NOT NULL DEFAULT NOW(),
    scan_status VARCHAR(20) DEFAULT 'completed', -- 'processing', 'completed', 'failed', 'skipped'
    scan_duration_seconds NUMERIC(10,2),
    
    -- Results
    total_pages INTEGER,
    products_found INTEGER DEFAULT 0,
    products_imported INTEGER DEFAULT 0,
    prices_imported INTEGER DEFAULT 0,
    
    -- Storage
    original_path TEXT, -- Where the file is stored
    processed_path TEXT, -- Where results are stored
    csv_file_path TEXT,
    sql_file_path TEXT,
    
    -- Metadata
    notes TEXT,
    tags TEXT[], -- ['dental', 'uk', '2024', etc.]
    metadata JSONB DEFAULT '{}', -- Flexible additional data
    
    -- Tracking
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    last_checked_at TIMESTAMP, -- For re-scanning check
    
    -- Flags
    is_active BOOLEAN DEFAULT TRUE,
    allow_rescan BOOLEAN DEFAULT FALSE -- Allow scanning same file again
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_sources_file_hash ON scraped_sources(file_hash);
CREATE INDEX IF NOT EXISTS idx_sources_type ON scraped_sources(source_type);
CREATE INDEX IF NOT EXISTS idx_sources_publisher ON scraped_sources(publisher);
CREATE INDEX IF NOT EXISTS idx_sources_scan_date ON scraped_sources(scan_date);
CREATE INDEX IF NOT EXISTS idx_sources_status ON scraped_sources(scan_status);
CREATE INDEX IF NOT EXISTS idx_sources_tags ON scraped_sources USING gin(tags);
CREATE INDEX IF NOT EXISTS idx_sources_active ON scraped_sources(is_active) WHERE is_active = TRUE;

-- Trigger to update updated_at
CREATE OR REPLACE FUNCTION update_sources_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sources_updated_at
    BEFORE UPDATE ON scraped_sources
    FOR EACH ROW
    EXECUTE FUNCTION update_sources_updated_at();

-- View for quick statistics
CREATE OR REPLACE VIEW v_source_statistics AS
SELECT 
    source_type,
    COUNT(*) as total_sources,
    SUM(products_found) as total_products_found,
    SUM(products_imported) as total_products_imported,
    AVG(scan_duration_seconds) as avg_scan_duration,
    MIN(scan_date) as first_scan,
    MAX(scan_date) as last_scan
FROM scraped_sources
WHERE is_active = TRUE
GROUP BY source_type;

-- View for duplicate detection
CREATE OR REPLACE VIEW v_duplicate_sources AS
SELECT 
    file_hash,
    COUNT(*) as scan_count,
    ARRAY_AGG(source_name ORDER BY scan_date DESC) as filenames,
    ARRAY_AGG(scan_date ORDER BY scan_date DESC) as scan_dates,
    MAX(scan_date) as latest_scan
FROM scraped_sources
WHERE file_hash IS NOT NULL
GROUP BY file_hash
HAVING COUNT(*) > 1;

-- Function to check if source was already scanned
CREATE OR REPLACE FUNCTION is_source_already_scanned(
    p_file_hash VARCHAR(64)
)
RETURNS TABLE (
    is_scanned BOOLEAN,
    source_id INTEGER,
    scan_date TIMESTAMP,
    products_found INTEGER,
    allow_rescan BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        TRUE as is_scanned,
        s.id,
        s.scan_date,
        s.products_found,
        s.allow_rescan
    FROM scraped_sources s
    WHERE s.file_hash = p_file_hash
        AND s.is_active = TRUE
        AND s.scan_status = 'completed'
    ORDER BY s.scan_date DESC
    LIMIT 1;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, NULL::INTEGER, NULL::TIMESTAMP, NULL::INTEGER, TRUE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Insert some sample data for testing
COMMENT ON TABLE scraped_sources IS 'Tracks all scraped sources (PDFs, magazines, catalogs) to prevent duplicate scanning';
COMMENT ON COLUMN scraped_sources.file_hash IS 'SHA256 hash of file content for duplicate detection';
COMMENT ON COLUMN scraped_sources.allow_rescan IS 'If TRUE, allows re-scanning the same file';
COMMENT ON COLUMN scraped_sources.metadata IS 'Flexible JSON field for additional data like: {"volume": "23", "year": "2024"}';

-- Display success message
DO $$
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Scraped Sources Table Created!';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Table: scraped_sources';
    RAISE NOTICE 'Views: v_source_statistics, v_duplicate_sources';
    RAISE NOTICE 'Function: is_source_already_scanned()';
    RAISE NOTICE '';
    RAISE NOTICE 'Use this to track all PDF/magazine scans';
    RAISE NOTICE 'and prevent duplicate processing.';
    RAISE NOTICE '========================================';
END $$;









