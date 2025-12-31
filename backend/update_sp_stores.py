#!/usr/bin/env python3
"""
Update existing SuperPharm store names and cities
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.scraper_registry import get_registry
import psycopg2
import os

print("🔄 עדכון שמות וערים של סניפי SuperPharm")
print("=" * 80)
print()

# Get SuperPharm scraper
registry = get_registry()
sp = registry.get('superpharm')

# Step 1: Build store registry by fetching file list
print("1️⃣  בונה store registry...")
files = sp.fetch_file_list(limit=None)  # Get all files to build complete registry
print(f"   ✅ Store registry: {len(sp.store_registry)} סניפים")
print()

# Step 2: Connect to DB and update existing stores
print("2️⃣  מעדכן סניפים קיימים ב-DB...")
print()

conn = psycopg2.connect(
    dbname=os.getenv('DB_NAME', 'gogobe'),
    user=os.getenv('DB_USER', 'postgres'),
    password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
    host=os.getenv('DB_HOST', 'localhost'),
    port=os.getenv('DB_PORT', '5432')
)

cur = conn.cursor()

# Get SuperPharm chain_id
cur.execute("SELECT id FROM stores WHERE chain_id = 210 LIMIT 1")
result = cur.fetchone()
if not result:
    print("   ❌ לא נמצאו סניפי SuperPharm ב-DB")
    cur.close()
    conn.close()
    exit(1)

# Get all SuperPharm stores from DB
cur.execute("""
    SELECT id, store_id, name, city
    FROM stores
    WHERE chain_id = 210
    ORDER BY store_id
""")

existing_stores = cur.fetchall()
print(f"   נמצאו {len(existing_stores)} סניפים ב-DB")
print()

updated = 0
skipped = 0

for db_id, store_code, current_name, current_city in existing_stores:
    store_code_str = str(store_code)
    
    if store_code_str in sp.store_registry:
        store_info = sp.store_registry[store_code_str]
        new_name = store_info['name']
        new_city = store_info['city']
        
        # Check if we need to update
        should_update = False
        
        # Update if current name is generic
        if current_name and 'סניף' in current_name:
            should_update = True
        # Or if we don't have a city
        elif not current_city and new_city:
            should_update = True
        
        if should_update:
            cur.execute("""
                UPDATE stores
                SET name = %s, city = %s
                WHERE id = %s
            """, (new_name, new_city, db_id))
            
            print(f"   ✅ עודכן {store_code}: {new_name} | {new_city or 'N/A'}")
            updated += 1
        else:
            skipped += 1
    else:
        print(f"   ⚠️  לא נמצא ב-registry: {store_code}")
        skipped += 1

conn.commit()

print()
print(f"   סה\"כ עודכנו: {updated} סניפים")
print(f"   דולגו: {skipped} סניפים")
print()

# Step 3: Show sample of updated stores
print("3️⃣  דוגמאות לסניפים מעודכנים:")
print()

cur.execute("""
    SELECT store_id, name, city
    FROM stores
    WHERE chain_id = 210
    AND city IS NOT NULL
    ORDER BY store_id
    LIMIT 10
""")

for store_id, name, city in cur.fetchall():
    print(f"   {store_id:3s}: {name:40s} | {city or 'N/A'}")

print()
print("=" * 80)
print()

# Step 4: Final stats
cur.execute("""
    SELECT 
        COUNT(*) as total,
        COUNT(CASE WHEN city IS NOT NULL AND city != '' THEN 1 END) as with_city,
        COUNT(CASE WHEN name NOT LIKE '%סניף%' THEN 1 END) as with_real_name
    FROM stores
    WHERE chain_id = 210
""")

total, with_city, with_real_name = cur.fetchone()

print("📊 סטטיסטיקה סופית:")
print(f"   סה\"כ סניפי SuperPharm: {total}")
print(f"   עם שם אמיתי: {with_real_name} ({with_real_name/total*100:.1f}%)")
print(f"   עם עיר: {with_city} ({with_city/total*100:.1f}%)")
print()
print("=" * 80)

cur.close()
conn.close()

print()
print("✅ עדכון הושלם!")
