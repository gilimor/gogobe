#!/usr/bin/env python3
"""
Install upsert_price function via Python
"""
import psycopg2
import os

# Database connection
conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres',
    password='9152245-Gl!',
    host='localhost',
    port='5432'
)

print("="*60)
print("Installing upsert_price Function")
print("="*60)

# Read SQL file
sql_file = os.path.join(os.path.dirname(__file__), 'functions', 'upsert_price.sql')
with open(sql_file, 'r', encoding='utf-8') as f:
    sql = f.read()

# Execute
cur = conn.cursor()
try:
    cur.execute(sql)
    conn.commit()
    print("✓ upsert_price function installed successfully!")
    
    # Test
    print("\nTesting function...")
    cur.execute("SELECT upsert_price(1, 1, 1, 9.99, 'ILS', TRUE, 0.01) as test_result")
    result = cur.fetchone()
    print(f"✓ Test passed! Result: {result[0]}")
    
except Exception as e:
    print(f"✗ Error: {e}")
    conn.rollback()
finally:
    cur.close()
    conn.close()

print("="*60)
print("Done!")
print("="*60)
