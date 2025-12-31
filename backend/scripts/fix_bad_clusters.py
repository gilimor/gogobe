import psycopg2
import os
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')
logger = logging.getLogger(__name__)

DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432')
}

BAD_MASTER_IDS = []

def get_bad_clusters(cur):
    """Finds all Master Products that have more than 1 distinct EAN linked to them."""
    cur.execute("""
        SELECT l.master_product_id
        FROM product_master_links l 
        JOIN products p ON l.product_id = p.id 
        WHERE p.ean IS NOT NULL 
        GROUP BY l.master_product_id 
        HAVING COUNT(DISTINCT p.ean) > 1
    """)
    rows = cur.fetchall()
    return [row[0] for row in rows]

def fix_clusters():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    
    try:
        # Dynamic Detection
        bad_ids = get_bad_clusters(cur)
        if not bad_ids:
            logger.info("✅ No mixed-EAN clusters found. System is pure.")
            return

        logger.info(f"💥 identified {len(bad_ids)} Impure Clusters to Bust")
        logger.info(f" IDs: {bad_ids[:10]} ...")
        
        # 1. Reset products table (Denormalized Col)
        cur.execute("""
            UPDATE products 
            SET master_product_id = NULL 
            WHERE master_product_id = ANY(%s)
            RETURNING id;
        """, (bad_ids,))
        reset_products = cur.fetchall()
        logger.info(f"✓ Unlinked {len(reset_products)} products from Denormalized Col.")
        
        # 2. Delete from Link Table
        cur.execute("""
            DELETE FROM product_master_links 
            WHERE master_product_id = ANY(%s)
            RETURNING product_id;
        """, (bad_ids,))
        deleted_links = cur.fetchall()
        logger.info(f"✓ Deleted {len(deleted_links)} links from Link Table.")
        
        # 2a. Delete from matching_feedback (FK Constraint)
        cur.execute("""
            DELETE FROM matching_feedback 
            WHERE master_product_id = ANY(%s)
        """, (bad_ids,))
        logger.info(f"✓ Deleted related feedback records.")

        # 2b. Nullify prices table (FK Constraint)
        cur.execute("""
            UPDATE prices
            SET master_product_id = NULL
            WHERE master_product_id = ANY(%s)
        """, (bad_ids,))
        logger.info(f"✓ Unlinked prices from Bad Masters.")
        
        # 3. Delete the Master Products themselves
        cur.execute("""
            DELETE FROM master_products
            WHERE id = ANY(%s)
            RETURNING id, global_name;
        """, (bad_ids,))
        deleted_masters = cur.fetchall()
        logger.info(f"✓ Destroyed {len(deleted_masters)} Bad Master Products.")
            
        conn.commit()
        logger.info("✅ Purity Restore Complete. Now run Backfill to re-link properly.")
        
    except Exception as e:
        conn.rollback()
        logger.error(f"Failed: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    fix_clusters()
