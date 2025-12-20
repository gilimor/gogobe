"""
Database connection module for Gogobe
Handles PostgreSQL connections with environment configuration
"""

import os
import psycopg2
from psycopg2.extras import RealDictCursor
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables
env_path = Path(__file__).parent.parent.parent / '.env'
if env_path.exists():
    load_dotenv(env_path)

# Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432'),
    'database': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!')
}

def get_db_connection():
    """
    Create and return a database connection
    
    Returns:
        psycopg2.connection: Database connection object
    """
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except psycopg2.Error as e:
        print(f"❌ Database connection error: {e}")
        raise

def get_db_cursor(dict_cursor=False):
    """
    Create and return a database connection and cursor
    
    Args:
        dict_cursor (bool): If True, returns RealDictCursor for dict-like results
    
    Returns:
        tuple: (connection, cursor)
    """
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor) if dict_cursor else conn.cursor()
    return conn, cursor

def execute_query(query, params=None, fetch=False, dict_cursor=False):
    """
    Execute a database query
    
    Args:
        query (str): SQL query to execute
        params (tuple/dict): Query parameters
        fetch (bool): Whether to fetch results
        dict_cursor (bool): Use dictionary cursor
    
    Returns:
        list/None: Query results if fetch=True, None otherwise
    """
    conn, cur = get_db_cursor(dict_cursor=dict_cursor)
    
    try:
        cur.execute(query, params)
        
        if fetch:
            results = cur.fetchall()
            return results
        else:
            conn.commit()
            return None
            
    except Exception as e:
        conn.rollback()
        print(f"❌ Query execution error: {e}")
        raise
    finally:
        cur.close()
        conn.close()

def test_connection():
    """Test database connection"""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT version();")
        version = cur.fetchone()
        print(f"✅ Database connection successful!")
        print(f"PostgreSQL version: {version[0]}")
        cur.close()
        conn.close()
        return True
    except Exception as e:
        print(f"❌ Database connection failed: {e}")
        return False

if __name__ == "__main__":
    # Test connection when run directly
    test_connection()

