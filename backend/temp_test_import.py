import sys
import os
import logging
from datetime import datetime

# Setup Path to allow imports
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("ForceImport")

try:
    # 1. Direct Import
    from backend.scrapers.fresh_market_scraper import FreshMarketScraper
    
    logger.info("--- STARTING FORCE IMPORT: FRESH MARKET ---")
    scraper = FreshMarketScraper()
    
    # 2. Run Import
    # limit=5 files is enough for a quick test
    result = scraper.run_full_import(limit=5)
    
    logger.info(f"--- IMPORT FINISHED ---")
    logger.info(f"Products: {result.get('products_count')}")
    logger.info(f"Prices: {result.get('prices_count')}")

    # 3. Trigger Stats Recalc (via API logic injected here for speed)
    import psycopg2
    
    # DB Credentials hardcoded for speed/reliability in this script
    conn = psycopg2.connect(
        dbname=os.getenv('DB_NAME', 'gogobe'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host=os.getenv('DB_HOST', 'localhost'),
        port=os.getenv('DB_PORT', '5432')
    )
    cur = conn.cursor()
    
    logger.info("--- CALCULATING STATS (PRICE CHANGES) ---")
    sql = """
        WITH TodayStats AS (
            SELECT product_id, AVG(price) as today_avg
            FROM prices 
            WHERE scraped_at >= NOW() - INTERVAL '24 hours'
            GROUP BY product_id
        ),
        YesterdayStats AS (
            SELECT product_id, AVG(price) as yest_avg
            FROM prices 
            WHERE scraped_at BETWEEN NOW() - INTERVAL '48 hours' AND NOW() - INTERVAL '24 hours'
            GROUP BY product_id
        )
        UPDATE products p
        SET price_change_24h = ((t.today_avg - y.yest_avg) / y.yest_avg) * 100
        FROM TodayStats t
        JOIN YesterdayStats y ON t.product_id = y.product_id
        WHERE p.id = t.product_id
        AND y.yest_avg > 0;
    """
    cur.execute(sql)
    affected = cur.rowcount
    conn.commit()
    conn.close()
    
    logger.info(f"--- STATS UPDATED: {affected} PRODUCTS ---")
    logger.info("DONE.")

except Exception as e:
    logger.error(f"CRITICAL FAILURE: {e}")
    import traceback
    traceback.print_exc()
