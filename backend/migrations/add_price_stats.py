import psycopg2
import os
import logging

# Config
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432')
}

logging.basicConfig(level=logging.INFO)

def migrate():
    conn = None
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        logging.info("Checking if 'price_change_24h' exists...")
        cur.execute("SELECT column_name FROM information_schema.columns WHERE table_name='products' AND column_name='price_change_24h';")
        if not cur.fetchone():
            logging.info("Adding column 'price_change_24h' to products table...")
            cur.execute("ALTER TABLE products ADD COLUMN price_change_24h NUMERIC(5,2) DEFAULT 0;")
            cur.execute("CREATE INDEX IF NOT EXISTS idx_price_change ON products(price_change_24h);")
            conn.commit()
            logging.info("Migration successful: Column added and indexed.")
        else:
            logging.info("Column already exists. Skipping.")

    except Exception as e:
        logging.error(f"Migration Failed: {e}")
    finally:
        if conn: conn.close()

if __name__ == "__main__":
    migrate()
