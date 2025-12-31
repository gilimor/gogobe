האם
import psycopg2
import os
import sys

def enable_ai_tables():
    db_config = {
        'dbname': os.getenv('DB_NAME', 'gogobe'),
        'user': os.getenv('DB_USER', 'postgres'),
        'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
        'host': os.getenv('DB_HOST', 'db'),
        'port': os.getenv('DB_PORT', '5432')
    }

    print(f"🔌 Connecting to {db_config['host']}...")
    try:
        conn = psycopg2.connect(**db_config)
        conn.autocommit = True
        cur = conn.cursor()

        # 1. Enable pg_trgm for fuzzy search
        print("📦 Enabling pg_trgm extension...")
        try:
            cur.execute("CREATE EXTENSION IF NOT EXISTS pg_trgm;")
            print("✅ pg_trgm extension enabled!")
        except Exception as e:
            print(f"❌ Failed to enable pg_trgm: {e}")

        # 2. Add master_product_id status columns if missing
        print("📝 Creating matching_feedback table...")
        cur.execute("""
            CREATE TABLE IF NOT EXISTS matching_feedback (
                id SERIAL PRIMARY KEY,
                product_id INTEGER,
                master_product_id INTEGER,
                feedback_type VARCHAR(50), 
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
        """)
        print("✅ Feedback table ready!")
        
        # 3. Add match_method column to links if not exists
        try:
            cur.execute("ALTER TABLE product_master_links ADD COLUMN IF NOT EXISTS match_method VARCHAR(50);")
            cur.execute("ALTER TABLE product_master_links ADD COLUMN IF NOT EXISTS confidence_score FLOAT;")
        except Exception:
            pass

        cur.close()
        conn.close()

    except Exception as e:
        print(f"❌ Connection failed: {e}")

if __name__ == "__main__":
    enable_ai_tables()
