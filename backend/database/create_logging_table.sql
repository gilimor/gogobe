-- Create file_processing_log table for Dashboard Monitoring
CREATE TABLE IF NOT EXISTS file_processing_log (
    id SERIAL PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    file_type VARCHAR(50),
    source VARCHAR(100),
    status VARCHAR(50), -- 'pending', 'processing', 'completed', 'failed'
    products_count INTEGER DEFAULT 0,
    prices_count INTEGER DEFAULT 0,
    error_message TEXT,
    started_at TIMESTAMP DEFAULT NOW(),
    completed_at TIMESTAMP
);

-- Index for fast dashboard queries
CREATE INDEX IF NOT EXISTS idx_file_log_status_date ON file_processing_log(status, started_at DESC);
CREATE INDEX IF NOT EXISTS idx_file_log_filename ON file_processing_log(filename);

SELECT 'file_processing_log table created' as result;
