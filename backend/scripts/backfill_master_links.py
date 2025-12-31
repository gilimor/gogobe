#!/usr/bin/env python3
"""
Backfill Master Links
Iterates over all products that are NOT linked to a Master Product and attempts to link them.
Uses the MasterProductMatcher logic (Barcode -> AI -> Create).
"""

import psycopg2
from psycopg2.extras import RealDictCursor
import os
import sys
import logging
import time

# Add parent directory to path to allow imports
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from services.master_product_matcher import MasterProductMatcher

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - BACKFILL - %(message)s',
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler("backfill.log")
    ]
)
logger = logging.getLogger(__name__)

DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432')
}

class BackfillService:
    def __init__(self):
        self.matcher = MasterProductMatcher(DB_CONFIG, use_ai=False) # Start with strict/fast matching
        self.conn = psycopg2.connect(**DB_CONFIG)

    def get_unlinked_product_ids(self):
        """Fetch all product IDs that are missing from product_master_links AND products.master_product_id"""
        with self.conn.cursor() as cur:
            cur.execute("""
                SELECT p.id 
                FROM products p
                LEFT JOIN product_master_links pml ON p.id = pml.product_id
                WHERE pml.master_product_id IS NULL
                -- ORDER BY p.id DESC -- Newest first
            """)
            rows = cur.fetchall()
            return [r[0] for r in rows]

    def run(self, batch_size=1000):
        ids = self.get_unlinked_product_ids()
        total = len(ids)
        logger.info(f"🚀 Starting Backfill for {total} unlinked products...")

        start_time = time.time()
        success_count = 0
        error_count = 0

        # Process in batches to allow progress tracking
        for i, pid in enumerate(ids):
            try:
                if i % 100 == 0:
                    elapsed = time.time() - start_time
                    rate = (i + 1) / elapsed if elapsed > 0 else 0
                    logger.info(f"Progress: {i}/{total} ({((i/total)*100):.1f}%) - Rate: {rate:.1f} items/sec")

                # The matcher handles the logic: Match -> Link -> Sync to Products Table
                match = self.matcher.match_product(pid)
                
                if match.master_product_id:
                    success_count += 1
                else:
                    # Should rarely happen as logic auto-creates
                    logger.warning(f"Failed to match/create for Product {pid}")

            except KeyboardInterrupt:
                logger.info("🛑 Backfill interrupted by user.")
                break
            except Exception as e:
                logger.error(f"Error processing {pid}: {e}")
                error_count += 1

        logger.info("="*50)
        logger.info("✅ BACKFILL COMPLETE")
        logger.info(f"Total Processed: {total}")
        logger.info(f"Successful Links: {success_count}")
        logger.info(f"Errors: {error_count}")
        logger.info("="*50)

if __name__ == "__main__":
    backfill = BackfillService()
    backfill.run()
