#!/usr/bin/env python3
"""
Install critical indexes via Python
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
print("Installing Critical Indexes")
print("="*60)
print("This may take 2-5 minutes...")
print()

# Read SQL file
sql_file = os.path.join(os.path.dirname(__file__), 'indexes_critical.sql')
with open(sql_file, 'r', encoding='utf-8') as f:
    sql = f.read()

# Execute
cur = conn.cursor()
try:
    # Split by semicolon and execute each statement
    statements = [s.strip() for s in sql.split(';') if s.strip()]
    
    for i, statement in enumerate(statements):
        if statement.startswith('--') or not statement:
            continue
        
        try:
            cur.execute(statement)
            conn.commit()
            
            # Extract index name if it's a CREATE INDEX statement
            if 'CREATE INDEX' in statement.upper():
                import re
                match = re.search(r'idx_\w+', statement)
                if match:
                    print(f"✓ Created: {match.group(0)}")
        except Exception as e:
            if 'already exists' in str(e):
                print(f"• Skipped (already exists)")
            else:
                print(f"✗ Error: {e}")
    
    print("\n✓ All indexes processed!")
    
except Exception as e:
    print(f"✗ Error: {e}")
    conn.rollback()
finally:
    cur.close()
    conn.close()

print("="*60)
print("Done!")
print("="*60)
