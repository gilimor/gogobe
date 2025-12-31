
import psycopg2
import os
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def list_chains():
    try:
        conn = psycopg2.connect(
            dbname=os.getenv('DB_NAME', 'gogobe'),
            user=os.getenv('DB_USER', 'postgres'),
            password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
            host=os.getenv('DB_HOST', 'localhost'),
            port=os.getenv('DB_PORT', '5432')
        )
        cur = conn.cursor()
        
        cur.execute("SELECT id, chain_name, chain_code FROM store_chains ORDER BY id")
        rows = cur.fetchall()
        
        with open("current_chains.txt", "w", encoding="utf-8") as f:
            f.write("Current Chains in DB:\n")
            f.write("---------------------\n")
            for row in rows:
                f.write(f"ID: {row[0]}, Name: {row[1]}, Code: {row[2]}\n")
                
        logger.info("Chains list written to current_chains.txt")
        conn.close()
        
    except Exception as e:
        logger.error(f"Error: {e}")

if __name__ == "__main__":
    list_chains()
