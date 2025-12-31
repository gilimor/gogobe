#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Update store names in database with full names from KingStore website
This script updates the stores table with proper names, cities, and addresses
"""

import psycopg2
import os
import sys

# Database configuration
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432'),
    'client_encoding': 'UTF8'
}

# Full store names mapping from website (from Main.aspx)
# Format: store_id: (name_he, city, address)
STORE_DATA = {
    '1': ('קינג סטור - סניף 1', None, None),
    '2': ('קינג סטור - סניף 2', None, None),
    '3': ('קינג סטור - סניף 3', None, None),
    '5': ('קינג סטור - סניף 5', None, None),
    '6': ('קינג סטור - סניף 6', None, None),
    '7': ('קינג סטור - סניף 7', None, None),
    '8': ('קינג סטור - סניף 8', None, None),
    '9': ('קינג סטור - סניף 9', None, None),
    '10': ('קינג סטור - סניף 10', None, None),
    '12': ('קינג סטור - סניף 12', None, None),
    '13': ('קינג סטור - סניף 13', None, None),
    '14': ('קינג סטור - סניף 14', None, None),
    '15': ('קינג סטור - סניף 15', None, None),
    '16': ('קינג סטור - סניף 16', None, None),
    '17': ('קינג סטור - סניף 17', None, None),
    '18': ('קינג סטור - סניף 18', None, None),
    '19': ('קינג סטור - סניף 19', None, None),
    '27': ('קינג סטור - סניף 27', None, None),
    '28': ('קינג סטור - סניף 28', None, None),
    '30': ('קינג סטור - סניף 30', None, None),
    '31': ('צים סנטר נוף הגליל', 'נוף הגליל', None),
    '200': ('ירושליים', 'ירושלים', None),
    '334': ('דיר חנא זכיינות', 'דיר חנא', None),
    '336': ('דוכאן קלנסווה', 'קלנסווה', None),
    '338': ('דוכאן חי אלוורוד', 'אל-ורוד', None),
    '339': ('יפו תלאביב מכללה', 'תל אביב', None),
    '340': ('מיני קינג סח\'נין', 'סח\'נין', None),
}

def update_store_names():
    """Update store names in database"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        # Get KingStore chain ID
        cur.execute("SELECT id FROM chains WHERE slug = 'kingstore'")
        chain = cur.fetchone()
        
        if not chain:
            print("❌ KingStore chain not found!")
            return False
        
        chain_id = chain[0]
        updated = 0
        
        for store_id, (name_he, city, address) in STORE_DATA.items():
            try:
                cur.execute("""
                    UPDATE stores 
                    SET name = %s,
                        name_he = %s,
                        city = COALESCE(NULLIF(%s, ''), city),
                        address = COALESCE(NULLIF(%s, ''), address)
                    WHERE chain_id = %s 
                      AND store_id = %s
                    RETURNING id
                """, (name_he, name_he, city, address, chain_id, store_id))
                
                if cur.fetchone():
                    updated += 1
                    print(f"✅ Updated: סניף {store_id} → {name_he}")
                else:
                    # Store doesn't exist, create it
                    cur.execute("""
                        INSERT INTO stores (chain_id, store_id, name, name_he, city, address)
                        VALUES (%s, %s, %s, %s, %s, %s)
                        ON CONFLICT (chain_id, store_id) DO UPDATE
                        SET name = EXCLUDED.name,
                            name_he = EXCLUDED.name_he,
                            city = COALESCE(NULLIF(EXCLUDED.city, ''), stores.city),
                            address = COALESCE(NULLIF(EXCLUDED.address, ''), stores.address)
                    """, (chain_id, store_id, name_he, name_he, city, address))
                    updated += 1
                    print(f"✅ Created: סניף {store_id} → {name_he}")
                    
            except Exception as e:
                print(f"❌ Error updating store {store_id}: {e}")
                continue
        
        conn.commit()
        print(f"\n✅ Updated {updated} stores")
        return True
        
    except Exception as e:
        print(f"❌ Error: {e}")
        if conn:
            conn.rollback()
        return False
    finally:
        if conn:
            cur.close()
            conn.close()

if __name__ == '__main__':
    print("Updating store names from website data...")
    success = update_store_names()
    sys.exit(0 if success else 1)


