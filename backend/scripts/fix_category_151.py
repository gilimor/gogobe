#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Fix category ID 151 encoding issue
Updates the category name from gibberish to correct Hebrew 'אחר'
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

def fix_category():
    """Fix category ID 151 name encoding"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        # Update category name with correct Hebrew
        cur.execute("""
            UPDATE categories 
            SET name = %s 
            WHERE id = 151 AND slug = 'acher'
        """, ('אחר',))
        
        conn.commit()
        
        # Verify the fix
        cur.execute("SELECT id, name, slug FROM categories WHERE id = 151")
        result = cur.fetchone()
        
        if result:
            print(f"✅ Fixed category ID {result[0]}: '{result[1]}' (slug: {result[2]})")
            if result[1] == 'אחר':
                print("✅ Category name is now correct!")
                return True
            else:
                print(f"⚠️  Category name is still: '{result[1]}'")
                return False
        else:
            print("❌ Category not found!")
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
    print("Fixing category ID 151 encoding...")
    success = fix_category()
    sys.exit(0 if success else 1)

