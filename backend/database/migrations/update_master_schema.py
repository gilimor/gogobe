
import os
import psycopg2
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def get_db_connection():
    return psycopg2.connect(
        dbname=os.getenv('DB_NAME', 'gogobe'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host=os.getenv('DB_HOST', 'localhost'),
        port=os.getenv('DB_PORT', '5432')
    )

def apply_migration():
    logger.info("Starting Master Products Schema Update Migration...")
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # 1. Update master_products table
        logger.info("Updating master_products table...")
        
        # Check and add columns
        cur.execute("""
            ALTER TABLE master_products 
            ADD COLUMN IF NOT EXISTS global_id VARCHAR(255) UNIQUE,
            ADD COLUMN IF NOT EXISTS global_ean VARCHAR(50) UNIQUE,
            ADD COLUMN IF NOT EXISTS global_name VARCHAR(500),
            ADD COLUMN IF NOT EXISTS category VARCHAR(255),
            ADD COLUMN IF NOT EXISTS confidence_score FLOAT,
            ADD COLUMN IF NOT EXISTS creation_method VARCHAR(50);
        """)
        
        # Migrate data: copy name to global_name if global_name is null
        cur.execute("UPDATE master_products SET global_name = name WHERE global_name IS NULL")
        
        # 2. Update product_master_links table
        logger.info("Updating product_master_links table...")
        cur.execute("""
            ALTER TABLE product_master_links 
            ADD COLUMN IF NOT EXISTS link_method VARCHAR(50),
            ADD COLUMN IF NOT EXISTS link_metadata JSONB;
        """)
        
        # Migrate match_method to link_method if link_method is null
        # Check if match_method exists first to avoid error
        cur.execute("SELECT column_name FROM information_schema.columns WHERE table_name='product_master_links' AND column_name='match_method'")
        if cur.fetchone():
             cur.execute("UPDATE product_master_links SET link_method = match_method WHERE link_method IS NULL")
        
        conn.commit()
        logger.info("Failed? No, Success! Migration applied successfully.")
        
    except Exception as e:
        logger.error(f"Migration failed: {e}")
        conn.rollback()
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    apply_migration()
