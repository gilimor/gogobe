import psycopg2
import os
import time

# Database config
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'localhost'), # Run from host usually, or adjust if inside docker
    'port': os.getenv('DB_PORT', '5432')
}

def optimize_database():
    print("🚀 Starting Database Optimization for High Scale...")
    
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        conn.autocommit = True
        cur = conn.cursor()
        
        # 1. Enable pg_trgm for super-fast text search
        print("🔧 Enabling pg_trgm extension...")
        cur.execute("CREATE EXTENSION IF NOT EXISTS pg_trgm;")
        
        # 2. Index Products Name (Critical for Search)
        # GIN index allows searching "Cola" and finding "Coca Cola" instantly without full scan
        print("📊 Creating GIN index on products(name)... this might take a moment.")
        cur.execute("""
            CREATE INDEX IF NOT EXISTS idx_products_name_trgm 
            ON products 
            USING GIN (name gin_trgm_ops);
        """)
        
        # 3. Index Products EAN (Barcode scan)
        print("📊 Creating B-Tree index on products(ean)...")
        cur.execute("""
            CREATE INDEX IF NOT EXISTS idx_products_ean 
            ON products(ean);
        """)

        # 4. Composite Index for Prices (Critical for "Best Price" lookups)
        # Helps filter prices by product rapidly
        print("📊 Creating Composite Index on prices(product_id, scraped_at)...")
        cur.execute("""
            CREATE INDEX IF NOT EXISTS idx_prices_product_date 
            ON prices(product_id, scraped_at DESC);
        """)

        # 5. Analyze tables to update query planner statistics
        print("🧹 Analyzing tables for Query Planner optimization...")
        cur.execute("ANALYZE products;")
        cur.execute("ANALYZE prices;")
        
        print("✅ Database Optimization Complete! Ready for millions of products.")
        
    except Exception as e:
        print(f"❌ Optimization Failed: {e}")
    finally:
        if 'conn' in locals() and conn:
            conn.close()

if __name__ == "__main__":
    optimize_database()
