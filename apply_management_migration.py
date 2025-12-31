
import psycopg2
import os
import logging
import json

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def apply_migration():
    """Apply the add_management_tables.sql migration"""
    
    db_name = os.getenv('DB_NAME', 'gogobe')
    db_user = os.getenv('DB_USER', 'postgres')
    db_pass = os.getenv('DB_PASSWORD', '9152245-Gl!')
    db_host = os.getenv('DB_HOST', 'localhost')
    db_port = os.getenv('DB_PORT', '5432')
    
    sql_file_path = "backend/database/add_management_tables.sql"
    
    if not os.path.exists(sql_file_path):
        logger.error(f"SQL file not found at {sql_file_path}")
        return False
        
    try:
        conn = psycopg2.connect(
            dbname=db_name, user=db_user, password=db_pass, host=db_host, port=db_port
        )
        conn.autocommit = False
        cur = conn.cursor()
        
        logger.info(f"Connected to database {db_name}")
        
        with open(sql_file_path, 'r', encoding='utf-8') as f:
            sql_content = f.read()
            
        cur.execute(sql_content)
        conn.commit()
        logger.info("Migration applied successfully.")
        
        # Update existing chains with platform info roughly
        cur.execute("UPDATE store_chains SET source_platform = 'published_prices' WHERE chain_code IN ('7290058140886', '7290058108879')") # Rami Levy
        cur.execute("UPDATE store_chains SET source_platform = 'laib_catalog' WHERE chain_code IN ('7290696200003', '7290661400001', '7290455000004')") # Victory, etc
        conn.commit()
        
        cur.close()
        conn.close()
        return True
        
    except Exception as e:
        logger.error(f"Migration failed: {e}")
        return False

if __name__ == "__main__":
    apply_migration()
