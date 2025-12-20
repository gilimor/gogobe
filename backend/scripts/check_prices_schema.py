#!/usr/bin/env python3
"""Check the structure of the prices table"""

import sys
sys.path.insert(0, 'backend/database')
from db_connection import get_db_connection

def main():
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Get columns info
    cur.execute("""
        SELECT 
            column_name, 
            data_type,
            is_nullable,
            column_default
        FROM information_schema.columns
        WHERE table_name = 'prices'
        ORDER BY ordinal_position
    """)
    
    print("=" * 70)
    print("PRICES TABLE STRUCTURE")
    print("=" * 70)
    print(f"{'Column':<20} {'Type':<20} {'Nullable':<10} {'Default':<20}")
    print("-" * 70)
    
    for row in cur.fetchall():
        print(f"{row[0]:<20} {row[1]:<20} {row[2]:<10} {str(row[3] or '')[:20]:<20}")
    
    print("=" * 70)
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()





