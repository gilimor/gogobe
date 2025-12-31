-- APS (Automatic Price Scanner) Schema Extension

DROP TABLE IF EXISTS source_discovery_tracking CASCADE;
DROP TABLE IF EXISTS source_health_log CASCADE;

-- 1. Source Discovery Tracking
-- Tracks the discovery status of potential source domains/URLs
CREATE TABLE source_discovery_tracking (
    id SERIAL PRIMARY KEY,
    domain VARCHAR(255) NOT NULL UNIQUE,
    status VARCHAR(50) DEFAULT 'discovered', -- discovered, scanning, completed, failed, ignored
    
    -- Metrics
    total_urls_found INTEGER DEFAULT 0,
    product_urls_found INTEGER DEFAULT 0,
    
    -- Depth Tracking
    last_scanned_at TIMESTAMP WITH TIME ZONE,
    error_count INTEGER DEFAULT 0,
    last_error TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for fast lookup/filtering
CREATE INDEX IF NOT EXISTS idx_source_discovery_status ON source_discovery_tracking(status);
CREATE INDEX IF NOT EXISTS idx_source_discovery_domain ON source_discovery_tracking(domain);


-- 2. Source Health Log
-- Detailed log of health checks and operational metrics for sources
CREATE TABLE IF NOT EXISTS source_health_log (
    id SERIAL PRIMARY KEY,
    source_id VARCHAR(100) NOT NULL, -- e.g. 'king_store', 'rami_levy'
    check_type VARCHAR(50) NOT NULL, -- 'connectivity', 'data_integrity', 'file_availability'
    status VARCHAR(50) NOT NULL, -- 'healthy', 'degraded', 'down'
    
    latency_ms INTEGER,
    details JSONB, -- Flexible payload for errors or stats
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for timeseries queries
CREATE INDEX IF NOT EXISTS idx_health_log_source_time ON source_health_log(source_id, created_at DESC);
