#!/usr/bin/env python3
"""
Update existing products to add store_name to attributes
"""
import psycopg2
import json
import os

# KingStore store mapping
STORE_NAMES = {
    '1': 'קינג סטור - סניף 1',
    '2': 'קינג סטור - סניף 2',
    '3': 'קינג סטור - סניף 3',
    '5': 'קינג סטור - סניף 5',
    '6': 'קינג סטור - סניף 6',
    '7': 'קינג סטור - סניף 7',
    '8': 'קינג סטור - סניף 8',
    '9': 'קינג סטור - סניף 9',
    '10': 'קינג סטור - סניף 10',
    '12': 'קינג סטור - סניף 12',
    '13': 'קינג סטור - סניף 13',
    '14': 'קינג סטור - סניף 14',
    '15': 'קינג סטור - סניף 15',
    '16': 'קינג סטור - סניף 16',
    '17': 'קינג סטור - סניף 17',
    '18': 'קינג סטור - סניף 18',
    '19': 'קינג סטור - סניף 19',
    '27': 'קינג סטור - סניף 27',
    '28': 'קינג סטור - סניף 28',
    '30': 'קינג סטור - סניף 30',
}

def main():
    conn = psycopg2.connect(
        dbname=os.getenv('DB_NAME', 'gogobe'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host=os.getenv('DB_HOST', 'db'),
        port=os.getenv('DB_PORT', '5432'),
        client_encoding='UTF8'
    )
    
    cur = conn.cursor()
    
    print("=" * 80)
    print("UPDATING STORE NAMES IN ATTRIBUTES")
    print("=" * 80)
    
    # Get all products with store_id but no store_name
    cur.execute("""
        SELECT id, attributes 
        FROM products 
        WHERE attributes ? 'store_id' 
        AND NOT attributes ? 'store_name'
    """)
    
    products = cur.fetchall()
    print(f"Found {len(products)} products to update")
    
    updated = 0
    for product_id, attributes in products:
        store_id = attributes.get('store_id')
        if store_id:
            store_name = STORE_NAMES.get(store_id, f'קינג סטור - סניף {store_id}')
            attributes['store_name'] = store_name
            
            cur.execute("""
                UPDATE products 
                SET attributes = %s::jsonb 
                WHERE id = %s
            """, (json.dumps(attributes, ensure_ascii=False), product_id))
            
            updated += 1
            if updated % 1000 == 0:
                print(f"  Updated {updated}...")
                conn.commit()
    
    conn.commit()
    print(f"✅ Updated {updated} products with store names")
    print("=" * 80)
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()

