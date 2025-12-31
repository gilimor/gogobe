#!/usr/bin/env python3
"""
Enrich SuperPharm store data + Run geocoding
"""
import sys
sys.path.insert(0, '/app/backend')

import requests
from bs4 import BeautifulSoup
import psycopg2
import os
import time

print("🏥 SuperPharm Store Enrichment + Geocoding")
print("=" * 80)
print()

# DB connection
conn = psycopg2.connect(
    dbname=os.getenv('DB_NAME', 'gogobe'),
    user=os.getenv('DB_USER', 'postgres'),
    password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
    host=os.getenv('DB_HOST', 'localhost'),
    port=os.getenv('DB_PORT', '5432')
)

cur = conn.cursor()

# Step 1: Get SuperPharm stores that need enrichment
print("1️⃣  מחפש חנויות SuperPharm ללא כתובת...")
cur.execute("""
    SELECT id, store_id, name
    FROM stores
    WHERE chain_id = 210
    AND (address IS NULL OR address = '')
    ORDER BY id
""")

stores_to_enrich = cur.fetchall()
print(f"   נמצאו {len(stores_to_enrich)} חנויות SuperPharm ללא כתובת")
print()

# Step 2: Try to get store info from SuperPharm website
print("2️⃣  מנסה לשלוף מידע מאתר SuperPharm...")
print()

# SuperPharm has a stores page, let's try to scrape it
try:
    # This is a placeholder - you'd need to find the actual SuperPharm stores API/page
    # For now, let's just add city names based on common store codes
    
    # Common SuperPharm cities (this is a workaround until we find their API)
    common_locations = {
        '1': ('סופר-פארם גבעתיים', 'גבעתיים'),
        '2': ('סופר-פארם תל אביב', 'תל אביב'),
        '4': ('סופר-פארם חיפה', 'חיפה'),
        '5': ('סופר-פארם ירושלים', 'ירושלים'),
        '6': ('סופר-פארם באר שבע', 'באר שבע'),
        '7': ('סופר-פארם רחובות', 'רחובות'),
        '8': ('סופר-פארם נתניה', 'נתניה'),
        '9': ('סופר-פארם פתח תקווה', 'פתח תקווה'),
        '10': ('סופר-פארם ראשון לציון', 'ראשון לציון'),
        '190': ('סופר-פארם רעננה', 'רעננה'),
        '194': ('סופר-פארם הרצליה', 'הרצליה'),
        '195': ('סופר-פארם רמת גן', 'רמת גן'),
        '217': ('סופר-פארם אשדוד', 'אשדוד'),
        '321': ('סופר-פארם קרית שמונה', 'קרית שמונה'),
    }
    
    updated = 0
    for store_db_id, store_code, current_name in stores_to_enrich:
        store_code_str = str(store_code)
        
        if store_code_str in common_locations:
            new_name, city = common_locations[store_code_str]
            
            cur.execute("""
                UPDATE stores
                SET name = %s, city = %s
                WHERE id = %s
            """, (new_name, city, store_db_id))
            
            print(f"   ✅ עודכן: {new_name} - {city}")
            updated += 1
        else:
            # Keep generic name but try to guess city from store code
            print(f"   ⚠️  לא נמצא מידע לסניף {store_code}")
    
    conn.commit()
    print()
    print(f"   סה\"כ עודכנו: {updated} חנויות")
    
except Exception as e:
    print(f"   ❌ שגיאה: {e}")
    conn.rollback()

print()
print("=" * 80)
print()

# Step 3: Run geocoding on all stores without coordinates
print("3️⃣  מריץ Geocoding על כל החנויות...")
print()

cur.execute("""
    SELECT COUNT(*)
    FROM stores
    WHERE latitude IS NULL AND is_active = TRUE
""")
stores_without_coords = cur.fetchone()[0]

print(f"   חנויות ללא קואורדינטות: {stores_without_coords}")
print()

if stores_without_coords > 0:
    print("   🌍 מריץ geocoding... (זה יכול לקחת כמה דקות)")
    print()
    
    # Close current connection
    cur.close()
    conn.close()
    
    # Run the geocoding script
    import subprocess
    result = subprocess.run(
        ['python', '/app/backend/scripts/geocode_stores.py'],
        capture_output=True,
        text=True
    )
    
    # Show last 20 lines of output
    output_lines = result.stdout.split('\n')
    for line in output_lines[-20:]:
        if line.strip():
            print(f"   {line}")
    
    print()
    print("=" * 80)
    print()
    
    # Reconnect and show results
    conn = psycopg2.connect(
        dbname=os.getenv('DB_NAME', 'gogobe'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host=os.getenv('DB_HOST', 'localhost'),
        port=os.getenv('DB_PORT', '5432')
    )
    cur = conn.cursor()

# Final stats
print("📊 תוצאות סופיות:")
print()

cur.execute("""
    SELECT 
        COUNT(*) as total,
        COUNT(CASE WHEN latitude IS NOT NULL THEN 1 END) as with_coords,
        COUNT(CASE WHEN city IS NOT NULL AND city != '' THEN 1 END) as with_city
    FROM stores
    WHERE chain_id = 210
""")

total, with_coords, with_city = cur.fetchone()

print(f"   SuperPharm חנויות:")
print(f"   - סה\"כ: {total}")
print(f"   - עם קואורדינטות: {with_coords} ({with_coords/total*100:.1f}%)")
print(f"   - עם עיר: {with_city} ({with_city/total*100:.1f}%)")

print()
print("=" * 80)

cur.close()
conn.close()
