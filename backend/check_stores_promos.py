#!/usr/bin/env python3
"""
Check data quality - stores and promo prices
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.scraper_registry import get_registry

print("🔍 בדיקת נתונים - חנויות ומבצעים")
print("=" * 80)
print()

registry = get_registry()
scraper = registry.get('shufersal')
scraper.get_db_connection()

conn = scraper.conn
cur = conn.cursor()

# 1. Overall stats
print("📊 סטטיסטיקה כוללת:")
cur.execute("SELECT COUNT(*) FROM products")
print(f"   מוצרים: {cur.fetchone()[0]:,}")

cur.execute("SELECT COUNT(*) FROM prices")
print(f"   מחירים: {cur.fetchone()[0]:,}")

cur.execute("SELECT COUNT(*) FROM stores")
total_stores = cur.fetchone()[0]
print(f"   חנויות: {total_stores:,}")

print()

# 2. Check store data quality
print("🏪 בדיקת נתוני חנויות:")
print()

# Stores with names vs store_id only
cur.execute("""
    SELECT 
        COUNT(*) as total,
        COUNT(CASE WHEN name IS NOT NULL AND name != '' THEN 1 END) as with_name,
        COUNT(CASE WHEN address IS NOT NULL AND address != '' THEN 1 END) as with_address,
        COUNT(CASE WHEN city IS NOT NULL AND city != '' THEN 1 END) as with_city
    FROM stores
""")
total, with_name, with_address, with_city = cur.fetchone()

print(f"   סה\"כ חנויות: {total}")
print(f"   עם שם: {with_name} ({with_name/total*100:.1f}%)")
print(f"   עם כתובת: {with_address} ({with_address/total*100:.1f}%)")
print(f"   עם עיר: {with_city} ({with_city/total*100:.1f}%)")

print()

# Sample stores from each chain
print("   דוגמאות חנויות:")
print()

# Shufersal
print("   📦 Shufersal:")
cur.execute("""
    SELECT name, address, city, store_id
    FROM stores
    WHERE chain_id = 2
    LIMIT 3
""")
for name, address, city, store_id in cur.fetchall():
    print(f"      • {name or f'סניף {store_id}'}")
    if address:
        print(f"        כתובת: {address}, {city or 'לא ידוע'}")
    else:
        print(f"        ⚠️  אין כתובת")

print()

# SuperPharm
print("   💊 SuperPharm:")
cur.execute("""
    SELECT name, address, city, store_id
    FROM stores
    WHERE chain_id = 210
    LIMIT 3
""")
for name, address, city, store_id in cur.fetchall():
    print(f"      • {name or f'סניף {store_id}'}")
    if address:
        print(f"        כתובת: {address}, {city or 'לא ידוע'}")
    else:
        print(f"        ⚠️  אין כתובת")

print()
print("=" * 80)
print()

# 3. Check for promo pricing
print("💰 בדיקת מחירי מבצע:")
print()

# Check prices table structure
cur.execute("""
    SELECT column_name 
    FROM information_schema.columns 
    WHERE table_name='prices'
    ORDER BY ordinal_position
""")
price_columns = [c[0] for c in cur.fetchall()]

print(f"   שדות בטבלת prices:")
for col in price_columns[:15]:  # Show first 15
    print(f"      - {col}")

print()

# Check for promo-related fields
promo_fields = [c for c in price_columns if 'promo' in c.lower() or 'sale' in c.lower() or 'discount' in c.lower()]
if promo_fields:
    print(f"   ✅ שדות מבצע קיימים: {', '.join(promo_fields)}")
    
    # Check how many prices have promo data
    for field in promo_fields:
        cur.execute(f"SELECT COUNT(*) FROM prices WHERE {field} IS NOT NULL AND {field} != '' AND {field} != '0'")
        count = cur.fetchone()[0]
        if count > 0:
            print(f"      • {field}: {count:,} מחירים")
else:
    print(f"   ⚠️  לא נמצאו שדות מבצע בטבלה")

print()

# Sample prices with all data
print("   דוגמאות מחירים (Shufersal):")
cur.execute("""
    SELECT p.name, pr.price, s.name
    FROM products p
    JOIN prices pr ON pr.product_id = p.id
    JOIN stores s ON pr.store_id = s.id
    WHERE s.chain_id = 2
    LIMIT 5
""")
for prod_name, price, store_name in cur.fetchall():
    print(f"      • {prod_name[:40]:40s} | ₪{price:6.2f} | {store_name[:30]}")

print()
print("=" * 80)

# 4. Summary
print()
print("📋 סיכום:")
if with_address < total * 0.5:
    print("   ⚠️  חסרות כתובות לחנויות - צריך geocoding/enrichment")
else:
    print("   ✅ רוב החנויות עם כתובת")

if not promo_fields:
    print("   ⚠️  אין שדות מבצע - צריך להוסיף תמיכה במחירי מבצע")
else:
    print("   ✅ יש תמיכה במחירי מבצע")

print()
print("=" * 80)

cur.close()
