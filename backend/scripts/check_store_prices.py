#!/usr/bin/env python3
"""Check if we track store information for prices"""

import sys
sys.path.insert(0, 'backend/database')
from db_connection import get_db_connection

def main():
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Check stores
    cur.execute('SELECT COUNT(*) FROM stores')
    store_count = cur.fetchone()[0]
    print(f'Total stores: {store_count}')
    
    if store_count > 0:
        cur.execute('''
            SELECT s.id, s.store_name, s.store_code, sc.chain_name
            FROM stores s
            LEFT JOIN store_chains sc ON s.chain_id = sc.id
            ORDER BY s.id
            LIMIT 10
        ''')
        print('\nSample stores:')
        for row in cur.fetchall():
            print(f'  Store ID: {row[0]}, Name: {row[1]}, Code: {row[2]}, Chain: {row[3]}')
    
    # Check if prices have store tracking
    cur.execute("""
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name = 'prices' AND column_name = 'store_id'
    """)
    has_store_id = cur.fetchone()
    print(f'\nPrices table has store_id column: {bool(has_store_id)}')
    
    # Sample a product with multiple prices
    cur.execute("""
        SELECT p.name, COUNT(DISTINCT pr.id) as price_count
        FROM products p
        JOIN prices pr ON p.id = pr.product_id
        WHERE p.vertical_id = 10
        GROUP BY p.id, p.name
        HAVING COUNT(DISTINCT pr.id) > 1
        ORDER BY price_count DESC
        LIMIT 5
    """)
    print('\nProducts with multiple prices:')
    for row in cur.fetchall():
        print(f'  {row[0]}: {row[1]} prices')
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()








