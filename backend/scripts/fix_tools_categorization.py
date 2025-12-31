
import psycopg2
import os
import sys

# Add parent dir to path to import auto_categorizer
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from services.auto_categorizer import AutoCategorizer

def main():
    print("="*80)
    print("FIXING 'TOOLS' CATEGORIZATION & RUNNING AUTO-CATEGORIZER")
    print("="*80)
    
    db_config = {
        'dbname': os.getenv('DB_NAME', 'gogobe'),
        'user': os.getenv('DB_USER', 'postgres'),
        'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
        'host': os.getenv('DB_HOST', 'db'),
        'port': os.getenv('DB_PORT', '5432')
    }
    
    conn = psycopg2.connect(**db_config)
    cur = conn.cursor()
    
    # 1. Reset 'Tools' category (ID 574 - verified via SQL)
    # Also reset NULLs just in case
    print("Resetting category_id for products in 'Tools' (574)...")
    cur.execute("UPDATE products SET category_id = NULL WHERE category_id = 574")
    print(f"Reset {cur.rowcount} products from 'Tools'.")
    conn.commit()
    
    # 2. Run Auto Categorizer
    print("Running Auto Categorizer...")
    categorizer = AutoCategorizer(db_config)
    categorizer.run_bulk_categorization()
    
    # 3. Verify improvements
    print("\nVerifying 'Tools' category stats:")
    cur.execute("SELECT COUNT(*) FROM products WHERE category_id = 574")
    count = cur.fetchone()[0]
    print(f"Products remaining in 'Tools': {count}")
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
