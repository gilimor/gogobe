
import os
import psycopg2
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def apply_migration():
    conn = psycopg2.connect(
        dbname=os.getenv('DB_NAME', 'gogobe'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host=os.getenv('DB_HOST', 'localhost'),
        port=os.getenv('DB_PORT', '5432')
    )
    cur = conn.cursor()
    try:
        logger.info("Adding promo columns to prices table...")
        
        # Add columns if they don't exist
        # Note: 'is_on_sale' already exists, but we are using 'is_sale' in the code.
        # We should align them. The code uses is_sale, price_regular, promo_description.
        # DB has is_on_sale.
        
        # Let's add the missing ones and maybe alias is_sale -> is_on_sale in code?
        # No, easier to add column to match code for now to avoid breaking existing logic, 
        # or better: Update code to use is_on_sale.
        
        # Checking base_supermarket_scraper.py:
        # It uses: is_sale = EXCLUDED.is_sale
        # So it expects 'is_sale'.
        
        # I will add is_sale (or rename is_on_sale?)
        # Let's add is_sale to be safe and price_regular, promo_description
        
        cur.execute("""
            ALTER TABLE prices 
            ADD COLUMN IF NOT EXISTS is_sale BOOLEAN DEFAULT FALSE,
            ADD COLUMN IF NOT EXISTS price_regular NUMERIC(10,2),
            ADD COLUMN IF NOT EXISTS promo_description TEXT;
        """)
        
        conn.commit()
        logger.info("Success.")
    except Exception as e:
        logger.error(f"Failed: {e}")
        conn.rollback()
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    apply_migration()
