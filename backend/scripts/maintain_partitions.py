
import os
import psycopg2
from datetime import datetime, timedelta
import logging

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# DB Config
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432')
}

def get_next_months(count=2):
    """Get list of next X months (start dates)"""
    months = []
    current = datetime.now()
    # Align to 1st of month
    if current.day > 25: # If late in month, look ahead further
        current = current + timedelta(days=10)
    current = current.replace(day=1)
    
    for _ in range(count):
        months.append(current)
        # Add 32 days to skip to next month safely
        next_month = (current + timedelta(days=32)).replace(day=1)
        current = next_month
    return months

def ensure_partition_exists(cursor, table_name, start_date):
    """Check and create partition if missing"""
    partition_name = f"{table_name}_{start_date.strftime('%Y_%m')}"
    
    # Calculate bounds
    end_date = (start_date + timedelta(days=32)).replace(day=1)
    
    start_str = start_date.strftime('%Y-%m-%d')
    end_str = end_date.strftime('%Y-%m-%d')
    
    logger.info(f"Checking partition: {partition_name} ({start_str} to {end_str})")
    
    try:
        # Check existence
        cursor.execute(f"SELECT to_regclass('{partition_name}');")
        if cursor.fetchone()[0]:
            logger.info(f"✅ Partition {partition_name} exists.")
            return

        # Create Partition
        sql = f"""
            CREATE TABLE IF NOT EXISTS {partition_name} 
            PARTITION OF {table_name} 
            FOR VALUES FROM ('{start_str}') TO ('{end_str}');
        """
        cursor.execute(sql)
        logger.info(f"🆕 Created partition: {partition_name}")
        
    except Exception as e:
        logger.error(f"Failed to process partition {partition_name}: {e}")
        raise

def main():
    logger.info("Starting Partition Maintenance...")
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        conn.autocommit = True # DDL requires autocommit or commit
        cur = conn.cursor()
        
        # 1. Maintain 'prices' partitions
        targets = get_next_months(3) # Ensure current + next 2 months exist
        for target_date in targets:
            ensure_partition_exists(cur, 'prices', target_date)
            
        logger.info("Partition Maintenance Completed Successfully.")
        conn.close()
        
    except Exception as e:
        logger.error(f"Critical Error: {e}")
        exit(1)

if __name__ == "__main__":
    main()
