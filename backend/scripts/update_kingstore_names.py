#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Update KingStore store names from website data
"""
import sys
import psycopg2
from psycopg2.extras import RealDictCursor

sys.stdout.reconfigure(encoding='utf-8')

import os

DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432')
}

# Store names from https://kingstore.binaprojects.com/Main.aspx
KINGSTORE_STORES = {
    '1': 'אום אלפחם',
    '2': 'דבוריה',
    '3': 'פרידיס',
    '5': 'קלנסווה',
    '6': 'שפרעם',
    '7': 'סכנין',
    '8': 'באר שבע',
    '9': 'טמרה',
    '10': 'דליית אל כרמל',
    '12': 'נצרת',
    '13': 'קאסם',
    '14': 'כבאביר חיפה',
    '15': 'כרמיאל',
    '16': 'עכו',
    '17': 'יפיע',
    '18': 'יפת - יפו תל אביב',
    '19': 'רמלה',
    '27': 'בסמת טבעון',
    '28': 'מיני קינגסטור רהט',
    '30': 'כפר כנא',
    '31': 'צים סנטר נוף הגליל',
    '50': 'אינטרנט',
    '200': 'ירושליים',
    '334': 'דיר חנא זכיינות',
    '335': 'דוכאן כפר ברא',
    '336': 'דוכאן קלנסווה',
    '337': 'דוכאן אעבלין',
    '338': 'דוכאן חי אלוורוד',
    '339': 'יפו תלאביב מכללה',
    '340': 'מיני קינג סח\'נין',
}


def update_store_names():
    """
    Update store names in database
    """
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        print("\n" + "="*70)
        print("🏪 Updating KingStore Store Names")
        print("="*70 + "\n")
        
        updated_count = 0
        not_found_count = 0
        
        for store_id_key, city_name in KINGSTORE_STORES.items():
            # Standardize name
            new_name = f"קינג סטור - {city_name}"
            
            # Find store by chain_id and store_id
            cur.execute("""
                SELECT id, name, city
                FROM stores
                WHERE chain_id = 1 AND store_id = %s
            """, (store_id_key,))
            
            existing = cur.fetchone()
            
            if existing:
                # Update name and city
                if existing['name'] != new_name:
                    cur.execute("""
                        UPDATE stores
                        SET name = %s, city = %s, updated_at = NOW()
                        WHERE id = %s
                    """, (new_name, city_name, existing['id']))
                    
                    print(f"✅ Updated: [{store_id_key}] {existing['name']} -> {new_name}")
                    updated_count += 1
                else:
                    print(f"⏭️  Unchanged: [{store_id_key}] {new_name}")
            else:
                print(f"❌ Not found in DB: [{store_id_key}] {city_name}")
                not_found_count += 1
        
        conn.commit()
        
        print("\n" + "="*70)
        print(f"✅ Update Complete!")
        print(f"   Updated:   {updated_count}")
        print(f"   Not found: {not_found_count}")
        print(f"   Total:     {len(KINGSTORE_STORES)}")
        print("="*70 + "\n")
        
        # Show current state
        print("Current stores in database:")
        cur.execute("""
            SELECT store_id, name, city, COUNT(pr.id) as price_count
            FROM stores s
            LEFT JOIN prices pr ON s.id = pr.store_id
            WHERE chain_id = 1
            GROUP BY s.id, s.store_id, s.name, s.city
            ORDER BY store_id::INTEGER ASC
        """)
        
        stores = cur.fetchall()
        for store in stores:
            print(f"  [{store['store_id']:3}] {str(store['name']):35} | {str(store['city']):15} ({store['price_count']:5} מחירים)")
        
    except Exception as e:
        conn.rollback()
        print(f"\n[ERROR] Update failed: {e}")
        import traceback
        traceback.print_exc()
    finally:
        conn.close()


if __name__ == '__main__':
    update_store_names()





