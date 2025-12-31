import sys
import os

print("----------------------------------------------------------------")
print(f"Python Executable: {sys.executable}")
print(f"Python Version: {sys.version}")
print("----------------------------------------------------------------")

try:
    import psycopg2
    print("[OK] psycopg2 is installed and importable.")
except ImportError as e:
    print(f"[FAIL] psycopg2 is NOT installed or importable: {e}")

try:
    import requests
    print("[OK] requests is installed and importable.")
except ImportError as e:
    print(f"[FAIL] requests is NOT installed or importable: {e}")

try:
    import pandas
    print("[OK] pandas is installed and importable.")
except ImportError as e:
    print(f"[FAIL] pandas is NOT installed or importable: {e}")

print("----------------------------------------------------------------")
print("Trying database connection...")

DB_NAME = os.getenv('DB_NAME', 'gogobe')
DB_USER = os.getenv('DB_USER', 'postgres')
DB_PASS = os.getenv('DB_PASSWORD', '9152245-Gl!')
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = os.getenv('DB_PORT', '5432')

print(f"Connecting to {DB_NAME} on {DB_HOST}:{DB_PORT} as {DB_USER}...")

try:
    conn = psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASS,
        host=DB_HOST,
        port=DB_PORT
    )
    print("[OK] Database connection successful!")
    conn.close()
except Exception as e:
    print(f"[FAIL] Database connection FAILED: {e}")

print("----------------------------------------------------------------")
