
import os
import sys
import psycopg2
from psycopg2.extras import RealDictCursor
import logging
from datetime import datetime

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432'),
}

def get_db_connection():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except Exception as e:
        logger.error(f"Database connection error: {e}")
        return None

def detect_anomalies():
    conn = get_db_connection()
    if not conn:
        return

    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            logger.info("Starting Price Anomaly Detection...")

            # 1. Get stats per Master Product (Median, Count)
            # We want master products with at least 3 prices to calculate meaningful stats
            cur.execute("""
                SELECT 
                    l.master_product_id,
                    array_agg(pr.price ORDER BY pr.price) as prices,
                    array_agg(pr.id ORDER BY pr.price) as price_ids
                FROM product_master_links l
                JOIN prices pr ON l.product_id = pr.product_id
                WHERE pr.is_suspicious = FALSE
                GROUP BY l.master_product_id
                HAVING COUNT(pr.id) >= 3
            """)
            
            masters = cur.fetchall()
            logger.info(f"Analyzing {len(masters)} master products...")
            
            suspicious_ids = []
            
            for m in masters:
                # Pure Python Median Calculation
                prices = sorted([float(p) for p in m['prices']])
                price_ids = m['price_ids'] # Already sorted by price in SQL text array? Yes.
                
                n = len(prices)
                if n == 0:
                    continue
                    
                if n % 2 == 1:
                    median = prices[n // 2]
                else:
                    median = (prices[n // 2 - 1] + prices[n // 2]) / 2.0
                
                # Thresholds:
                # - Less than 20% of median (e.g. 100 vs 500) -> Suspiciously Cheap
                # - More than 500% of median (e.g. 2500 vs 500) -> Suspiciously Expensive
                
                lower_bound = median * 0.20
                upper_bound = median * 5.0
                
                for i, p in enumerate(prices):
                    if p < lower_bound or p > upper_bound:
                        logger.warning(f"Suspicious Price: {p} (Median: {median}) for Master {m['master_product_id']}")
                        suspicious_ids.append(price_ids[i])

            if suspicious_ids:
                logger.info(f"Flagging {len(suspicious_ids)} suspicious prices...")
                cur.execute("""
                    UPDATE prices 
                    SET is_suspicious = TRUE 
                    WHERE id = ANY(%s)
                """, (suspicious_ids,))
                conn.commit()
                logger.info("Prices flagged successfully.")
            else:
                logger.info("No anomalies found.")
                
    except Exception as e:
        logger.error(f"Error during detection: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    detect_anomalies()
