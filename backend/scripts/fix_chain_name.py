#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Fix KingStore chain name_he encoding issue
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

def fix_chain_name():
    """Fix KingStore chain name_he"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        # Update chain name_he with correct Hebrew
        cur.execute("""
            UPDATE chains 
            SET name_he = %s 
            WHERE slug = 'kingstore'
        """, ('קינג סטור',))
        
        conn.commit()
        
        # Verify the fix
        cur.execute("SELECT id, name, name_he, slug FROM chains WHERE slug = 'kingstore'")
        result = cur.fetchone()
        
        if result:
            print(f"✅ Fixed chain ID {result[0]}: '{result[2]}' (slug: {result[3]})")
            if result[2] == 'קינג סטור':
                print("✅ Chain name is now correct!")
                return True
            else:
                print(f"⚠️  Chain name is still: '{result[2]}'")
                return False
        else:
            print("❌ Chain not found!")
            return False
            
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
    print("Fixing KingStore chain name_he encoding...")
    success = fix_chain_name()
    sys.exit(0 if success else 1)


