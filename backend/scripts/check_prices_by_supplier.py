#!/usr/bin/env python3
"""Check which suppliers have prices"""

import sys
sys.path.insert(0, 'backend/database')
from db_connection import get_db_connection

def main():
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Get prices by supplier
    cur.execute("""
        SELECT s.id, s.name, COUNT(p.id) as price_count
        FROM suppliers s
        LEFT JOIN prices p ON s.id = p.supplier_id
        GROUP BY s.id, s.name
        HAVING COUNT(p.id) > 0
        ORDER BY price_count DESC
    """)
    
    print("=" * 70)
    print("PRICES BY SUPPLIER")
    print("=" * 70)
    print(f"{'ID':<5} {'Name':<40} {'Prices':<10}")
    print("-" * 70)
    
    for row in cur.fetchall():
        print(f"{row[0]:<5} {row[1]:<40} {row[2]:<10}")
    
    print("=" * 70)
    
    # Check KingStore specifically
    cur.execute("""
        SELECT COUNT(*) FROM prices
        WHERE supplier_id = (SELECT id FROM suppliers WHERE name = 'KingStore')
    """)
    print(f"\nKingStore prices: {cur.fetchone()[0]}")
    
    # Check Chain supplier
    cur.execute("""
        SELECT COUNT(*) FROM prices
        WHERE supplier_id = (SELECT id FROM suppliers WHERE name LIKE 'Chain%')
    """)
    print(f"Chain 7290058108879 prices: {cur.fetchone()[0]}")
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()








