import sys
import os
import logging
import argparse
import traceback

# Fix paths to ensure we can import 'backend'
current_dir = os.path.dirname(os.path.abspath(__file__))
r_root = os.path.dirname(current_dir) # Go up one level to Project Root
sys.path.insert(0, r_root)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("GenericImport")

def run_import(source_id, limit=50):
    logger.info(f"--- STARTING GENERIC IMPORT FOR: {source_id} ---")
    
    try:
        from backend.scrapers.scraper_registry import get_registry
        registry = get_registry()
        
        # 1. Get Scraper (Tests Loading Logic)
        scraper = registry.get(source_id)
        if not scraper:
            logger.error(f"FATAL: Could not load scraper '{source_id}'. Check Registry logs/last_error.")
            # Start manual debug of registry
            config = registry._scrapers.get(source_id)
            if config:
                logger.error(f"Config Status: Enabled={config.enabled}, Available={config.is_available()}")
                logger.error(f"Last Error in Config: {config.last_error}")
            return False

        logger.info(f"Successfully loaded class: {type(scraper).__name__}")
        
        # 2. Run Import
        if hasattr(scraper, 'run_full_import'):
            logger.info("Running run_full_import...")
            result = scraper.run_full_import(limit=limit)
            logger.info(f"Result: {result}")
        elif hasattr(scraper, 'scrape_latest'):
             logger.info("Running scrape_latest...")
             res = scraper.scrape_latest(max_files=limit)
             logger.info(f"Result count: {len(res) if res else 0}")
        
        # 3. Recalc Stats (Generic Logic)
        logger.info("Triggering Stats Recalculation...")
        import psycopg2
        # Use localhost inside container logic or env vars
        conn = psycopg2.connect(
            dbname=os.getenv('DB_NAME', 'gogobe'),
            user=os.getenv('DB_USER', 'postgres'),
            password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
            host=os.getenv('DB_HOST', 'db'), # Assuming running inside container linking
            port=os.getenv('DB_PORT', '5432')
        )
        cur = conn.cursor()
        cur.execute("UPDATE products SET price_change_24h = 0 WHERE price_change_24h IS NULL") # Init
        # Real calc logic here...
        conn.commit()
        conn.close()
        logger.info("Stats updated.")
        
        return True

    except Exception as e:
        logger.error(f"EXCEPTION: {e}")
        traceback.print_exc()
        return False

if __name__ == "__main__":
    # Allow running with args: python run_generic_import.py fresh_market
    source = sys.argv[1] if len(sys.argv) > 1 else 'fresh_market'
    run_import(source)
