
import psycopg2
import os

try:
    conn = psycopg2.connect(
        dbname='gogobe',
        user='postgres',
        password='9152245-Gl!',
        host='localhost',
        port='5432'
    )
    cur = conn.cursor()
    
    table_name = 'stores'
    print(f"Schema for table: {table_name}")
    cur.execute(f"""
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_name = '{table_name}'
    """)
    
    columns = cur.fetchall()
    for col in columns:
        print(f"- {col[0]}: {col[1]}")
        
    conn.close()

except Exception as e:
    print(f"Error: {e}")
