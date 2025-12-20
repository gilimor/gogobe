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
    
    # Show products table structure
    print("\n" + "="*60)
    print("מבנה טבלת PRODUCTS")
    print("="*60)
    cur.execute("""
        SELECT column_name, data_type, character_maximum_length
        FROM information_schema.columns 
        WHERE table_name = 'products' 
        ORDER BY ordinal_position
    """)
    for row in cur.fetchall():
        col_name = row[0]
        col_type = row[1]
        col_len = f"({row[2]})" if row[2] else ""
        print(f"  {col_name:30} {col_type}{col_len}")
    
    # Show prices table structure
    print("\n" + "="*60)
    print("מבנה טבלת PRICES")
    print("="*60)
    cur.execute("""
        SELECT column_name, data_type, character_maximum_length
        FROM information_schema.columns 
        WHERE table_name = 'prices' 
        ORDER BY ordinal_position
    """)
    for row in cur.fetchall():
        col_name = row[0]
        col_type = row[1]
        col_len = f"({row[2]})" if row[2] else ""
        print(f"  {col_name:30} {col_type}{col_len}")
    
    # Show relationships
    print("\n" + "="*60)
    print("קשרים בין טבלאות (Foreign Keys)")
    print("="*60)
    cur.execute("""
        SELECT DISTINCT
            tc.table_name,
            kcu.column_name,
            ccu.table_name AS foreign_table_name,
            ccu.column_name AS foreign_column_name
        FROM information_schema.table_constraints AS tc
        JOIN information_schema.key_column_usage AS kcu
            ON tc.constraint_name = kcu.constraint_name
        JOIN information_schema.constraint_column_usage AS ccu
            ON ccu.constraint_name = tc.constraint_name
        WHERE tc.constraint_type = 'FOREIGN KEY'
            AND tc.table_name IN ('products', 'prices')
        ORDER BY tc.table_name, kcu.column_name
    """)
    for row in cur.fetchall():
        print(f"  {row[0]}.{row[1]} -> {row[2]}.{row[3]}")
    
    print("\n" + "="*60)
    
    conn.close()

if __name__ == '__main__':
    show_structure()


