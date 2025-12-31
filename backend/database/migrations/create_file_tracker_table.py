
import psycopg2
import os
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def create_tracking_table():
    try:
        conn = psycopg2.connect(
            dbname=os.getenv('DB_NAME', 'gogobe'),
            user=os.getenv('DB_USER', 'postgres'),
            password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
            host=os.getenv('DB_HOST', 'localhost'),
            port=os.getenv('DB_PORT', '5432')
        )
        cur = conn.cursor()
        
        logger.info("Creating file_processing_log table...")
        
        cur.execute("""
            CREATE TABLE IF NOT EXISTS file_processing_log (
                id SERIAL PRIMARY KEY,
                filename VARCHAR(500) UNIQUE,
                source VARCHAR(100),
                file_date DATE,
                file_hash VARCHAR(64),
                download_started_at TIMESTAMP,
                download_completed_at TIMESTAMP,
                processing_started_at TIMESTAMP,
                processing_completed_at TIMESTAMP,
                products_added INT DEFAULT 0,
                products_updated INT DEFAULT 0,
                prices_added INT DEFAULT 0,
                status VARCHAR(50), 
                error_message TEXT,
                worker_id VARCHAR(50),
                created_at TIMESTAMP DEFAULT NOW(),
                updated_at TIMESTAMP DEFAULT NOW()
            );
            
            -- Indexes for fast lookup
            CREATE INDEX IF NOT EXISTS idx_fpl_filename ON file_processing_log(filename);
            CREATE INDEX IF NOT EXISTS idx_fpl_status ON file_processing_log(status);
            CREATE INDEX IF NOT EXISTS idx_fpl_source ON file_processing_log(source);
        """)
        
        conn.commit()
        logger.info("Successfully created file_processing_log table.")
        
    except Exception as e:
        logger.error(f"Failed to create table: {e}")
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    create_tracking_table()
