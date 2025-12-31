
import psycopg2
import os
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def fix_chain_constraints():
    try:
        conn = psycopg2.connect(
            dbname=os.getenv('DB_NAME', 'gogobe'),
            user=os.getenv('DB_USER', 'postgres'),
            password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
            host=os.getenv('DB_HOST', 'localhost'),
            port=os.getenv('DB_PORT', '5432')
        )
        conn.autocommit = False
        cur = conn.cursor()
        
        logger.info("Adding unique constraint to store_chains.chain_code...")
        
        # Check if constraint exists or adds it
        # We use a unique index which acts as a constraint for ON CONFLICT
        cur.execute("""
            CREATE UNIQUE INDEX IF NOT EXISTS idx_store_chains_chain_code 
            ON store_chains (chain_code);
        """)
        
        conn.commit()
        logger.info("Unique index added successfully.")
        conn.close()
        
    except Exception as e:
        logger.error(f"Error: {e}")

if __name__ == "__main__":
    fix_chain_constraints()
