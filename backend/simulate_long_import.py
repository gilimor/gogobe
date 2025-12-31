import time
import psycopg2
import os
import json
import random
from datetime import datetime

# DB Config
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'), # Internal docker host
    'port': os.getenv('DB_PORT', '5432')
}

def get_conn():
    return psycopg2.connect(**DB_CONFIG)

def run_simulation():
    conn = get_conn()
    cur = conn.cursor()
    
    print("--- STARTING SIMULATION: 'MISSION CONTROL TEST' ---")
    
    # 1. Create a dummy active task
    filename = f"simulation_{int(time.time())}.xml"
    source = "Simulation_Source_Alpha"
    
    print(f"Creating task for {filename}...")
    
    cur.execute("""
        INSERT INTO file_processing_log 
        (filename, source, status, products_added, prices_added, processing_started_at, updated_at)
        VALUES (%s, %s, 'processing', 0, 0, NOW(), NOW())
        RETURNING id
    """, (filename, source))
    
    task_id = cur.fetchone()[0]
    conn.commit()
    print(f"Task ID: {task_id} CREATED. Status: PROCESSING")
    
    # 2. Update loop (Simulation)
    try:
        products = 0
        prices = 0
        for i in range(120): # Run for 2 minutes
            time.sleep(1)
            
            # Increment counts
            products += random.randint(1, 5)
            prices += random.randint(10, 50)
            
            cur.execute("""
                UPDATE file_processing_log
                SET products_added = %s,
                    prices_added = %s,
                    updated_at = NOW()
                WHERE id = %s
            """, (products, prices, task_id))
            conn.commit()
            
            print(f"T+{i}s | Prods: {products} | Prices: {prices} | Updated DB")
            
    except KeyboardInterrupt:
        print("Simulation stopped.")
        
    # 3. Finish
    print("Completing task...")
    cur.execute("""
        UPDATE file_processing_log
        SET status = 'completed',
            completed_at = NOW(),
            updated_at = NOW()
        WHERE id = %s
    """, (task_id,))
    conn.commit()
    conn.close()
    print("--- SIMULATION COMPLETE ---")

if __name__ == "__main__":
    run_simulation()
