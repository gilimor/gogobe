
import psycopg2
import os

def clean_zombies():
    try:
        conn = psycopg2.connect(
            dbname=os.getenv('DB_NAME', 'gogobe'),
            user=os.getenv('DB_USER', 'postgres'),
            password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
            host='db'
        )
        cur = conn.cursor()
        
        # Mark tasks older than 1 hour as failed/stale
        cur.execute("""
            UPDATE file_processing_log 
            SET status = 'failed', error_message = 'Stale task (Zombie cleanup)'
            WHERE status IN ('processing', 'importing', 'downloading', 'extracting') 
            AND processing_started_at < NOW() - INTERVAL '1 hour'
        """)
        count = cur.rowcount
        conn.commit()
        print(f"Cleaned {count} zombie tasks.")
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    clean_zombies()
