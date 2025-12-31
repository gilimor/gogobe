#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Show database structure
"""
import sys
import psycopg2

sys.stdout.reconfigure(encoding='utf-8')

DB_CONFIG = {
    'dbname': 'gogobe',
    'user': 'postgres',
    'password': '9152245-Gl!',
    'host': 'localhost',
    'port': '5432'
}

def show_structure():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    
    # Show all tables
    print("\n" + "="*60)
    print("כל הטבלאות בבסיס הנתונים")
    print("="*60)
    cur.execute("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        ORDER BY table_name
    """)
    tables = [row[0] for row in cur.fetchall()]
    for table in tables:
        print(f"  - {table}")
    
    # Show tables structure
    for table_name in ['products', 'prices', 'store_chains', 'suppliers', 'verticals']:
        print("\n" + "="*60)
        print(f"מבנה טבלת {table_name.upper()}")
        print("="*60)
        cur.execute("""
            SELECT column_name, data_type, character_maximum_length
            FROM information_schema.columns 
            WHERE table_name = %s
            ORDER BY ordinal_position
        """, (table_name,))
        for row in cur.fetchall():
            col_name = row[0]
            col_type = row[1]
            col_len = f"({row[2]})" if row[2] else ""
            print(f"  {col_name:30} {col_type}{col_len}")
    
    # Show relations and constraints
    for table_name in ['products', 'prices', 'store_chains', 'suppliers']:
        print("\n" + "="*60)
        print(f"אילוצים ואינדקסים על {table_name.upper()}")
        print("="*60)
        cur.execute("""
            SELECT conname, pg_get_constraintdef(oid) 
            FROM pg_constraint 
            WHERE conrelid = %s::regclass
        """, (table_name,))
        for row in cur.fetchall():
            print(f"  {row[0]}: {row[1]}")
    
    conn.close()

if __name__ == '__main__':
    show_structure()





