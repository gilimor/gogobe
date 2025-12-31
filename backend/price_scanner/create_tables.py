import psycopg2
import os
import uuid

def create_tables():
    print("🚀 Initializing Automatic Price Scanner Database Schema...")
    
    # DB Credentials (matching the rest of the project)
    conn = psycopg2.connect(
        dbname=os.getenv('DB_NAME', 'gogobe'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host=os.getenv('DB_HOST', 'localhost'),
        port=os.getenv('DB_PORT', '5432')
    )
    conn.autocommit = True
    cur = conn.cursor()
    
    # 1. source_discovery_tracking
    print("Creating table: source_discovery_tracking...")
    cur.execute("""
        CREATE TABLE IF NOT EXISTS source_discovery_tracking (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            domain VARCHAR(255) NOT NULL UNIQUE,
            sitemap_url VARCHAR(512),
            discovery_status VARCHAR(50) DEFAULT 'PENDING', 
            last_scan_at TIMESTAMP,
            products_found INT DEFAULT 0,
            success_rate FLOAT DEFAULT 0.0,
            schedule_interval INT DEFAULT 24,
            parser_config JSONB,
            created_at TIMESTAMP DEFAULT NOW(),
            required_country VARCHAR(10) -- For Geo-Blocking handling (e.g., 'ES')
        );
    """)
    
    # 2. source_health_log
    print("Creating table: source_health_log...")
    cur.execute("""
        CREATE TABLE IF NOT EXISTS source_health_log (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            source_id UUID REFERENCES source_discovery_tracking(id) ON DELETE CASCADE,
            checked_at TIMESTAMP DEFAULT NOW(),
            status_code INT,
            avg_response_ms INT,
            prices_found INT,
            error_log TEXT
        );
    """)

    # 3. generic_scraped_prices (The raw data storage)
    print("Creating table: generic_scraped_prices...")
    cur.execute("""
        CREATE TABLE IF NOT EXISTS generic_scraped_prices (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            source_id UUID REFERENCES source_discovery_tracking(id) ON DELETE SET NULL,
            product_url VARCHAR(2048) NOT NULL,
            product_name TEXT,
            price DECIMAL(10, 2),
            currency VARCHAR(10) DEFAULT 'ILS',
            barcode VARCHAR(50),
            brand VARCHAR(255),
            scraped_at TIMESTAMP DEFAULT NOW(),
            match_confidence FLOAT,
            master_product_id UUID,
            image_url TEXT,
            CONSTRAINT unique_url_per_scan UNIQUE (source_id, product_url) 
            -- Note: We might want to allow historical duplicates, but for raw current view unique is good.
            -- Actually, for price history we usually insert new rows. 
            -- Let's drop the unique constraint for now to allow history or manage it via partitions later.
            -- Keeping it simple: One current price per URL per source for now? 
            -- Let's stick to an APPEND ONLY log for now and clean up later.
        );
    """)
    
    # 4. blocked_aggregators (Blacklist)
    print("Creating table: blocked_aggregators...")
    cur.execute("""
        CREATE TABLE IF NOT EXISTS blocked_aggregators (
            domain VARCHAR(255) PRIMARY KEY,
            reason VARCHAR(255),
            blocked_at TIMESTAMP DEFAULT NOW()
        );
    """)

    print("✅ All tables created successfully!")
    cur.close()
    conn.close()

if __name__ == "__main__":
    create_tables()
