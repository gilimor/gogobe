
import psycopg2
import os
import sys

def enable_vector_extension():
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

        # 1. Enable Extension
        print("📦 Enabling vector extension...")
        try:
            cur.execute("CREATE EXTENSION IF NOT EXISTS vector;")
            print("✅ Vector extension enabled!")
        except Exception as e:
            print(f"❌ Failed to enable vector extension: {e}")

        # 2. Add embedding columns
        print("➕ Adding embedding columns...")
        tables = ['master_products', 'products']
        for table in tables:
            try:
                cur.execute(f"ALTER TABLE {table} ADD COLUMN IF NOT EXISTS embedding vector(1536);")
                print(f"✅ Added embedding column to {table}")
            except Exception as e:
                print(f"⚠️ Failed to add column to {table}: {e}")

        # 3. Create feedback table
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

        # 4. Create indexes (HNSW) for speed
        # Only creates if not exists logic is hard in SQL so wrapping in try
        try:
            print("⚡ Creating vector indexes...")
            cur.execute("CREATE INDEX IF NOT EXISTS master_products_embedding_idx ON master_products USING hnsw (embedding vector_cosine_ops);")
            cur.execute("CREATE INDEX IF NOT EXISTS products_embedding_idx ON products USING hnsw (embedding vector_cosine_ops);")
            print("✅ Vector indexes created!")
        except Exception as e:
            print(f"⚠️ Index creation warning: {e}")

        cur.close()
        conn.close()

    except Exception as e:
        print(f"❌ Connection failed: {e}")

if __name__ == "__main__":
    enable_vector_extension()
