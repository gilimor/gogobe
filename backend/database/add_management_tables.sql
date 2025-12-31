
-- Update store_chains to hold more management info
ALTER TABLE store_chains 
ADD COLUMN IF NOT EXISTS login_credentials JSONB DEFAULT '{}',
ADD COLUMN IF NOT EXISTS last_import_status VARCHAR(50),
ADD COLUMN IF NOT EXISTS last_import_date TIMESTAMP,
ADD COLUMN IF NOT EXISTS source_platform VARCHAR(50); -- e.g. 'published_prices', 'laib', 'bina'

-- Create tasks table
CREATE TABLE IF NOT EXISTS project_tasks (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending', -- pending, in_progress, done
    priority VARCHAR(20) DEFAULT 'normal', -- low, normal, high
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);

-- Seed some initial tasks based on user request
INSERT INTO project_tasks (description, status, priority) VALUES 
('Unified Navigation Bar across all pages', 'pending', 'high'),
('Source Management Page', 'pending', 'high'),
('Database Management Interface', 'pending', 'normal')
ON CONFLICT DO NOTHING;
