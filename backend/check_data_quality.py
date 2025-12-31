#!/usr/bin/env python3
"""
Check imported data quality
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.scraper_registry import get_registry

print("🔍 בדיקת איכות הנתונים")
print("=" * 80)
print()

# Get a working scraper to access DB
registry = get_registry()
scraper = registry.get('shufersal')

if not scraper or not scraper.conn:
    scraper.get_db_connection()

conn = scraper.conn
cur = conn.cursor()

# 1. Total stats
print("📊 סטטיסטיקה כוללת:")
cur.execute("SELECT COUNT(*) FROM products")
total_products = cur.fetchone()[0]
print(f"   סה\"כ מוצרים: {total_products:,}")

cur.execute("SELECT COUNT(*) FROM prices")
total_prices = cur.fetchone()[0]
print(f"   סה\"כ מחירים: {total_prices:,}")

cur.execute("SELECT COUNT(DISTINCT store_id) FROM prices")
stores_with_prices = cur.fetchone()[0]
print(f"   חנויות עם מחירים: {stores_with_prices}")

print()

# 2. By chain
print("🏪 פילוח לפי רשת:")
cur.execute("""
    SELECT 
        s.chain_id,
        COUNT(DISTINCT s.id) as stores,
        COUNT(DISTINCT p.id) as prices
    FROM stores s
    LEFT JOIN prices p ON p.store_id = s.id
    WHERE p.id IS NOT NULL
    GROUP BY s.chain_id
    ORDER BY prices DESC
""")

for chain_id, stores, prices in cur.fetchall():
    # Get chain name
    cur.execute("SELECT id, name FROM stores WHERE chain_id = %s LIMIT 1", (chain_id,))
    result = cur.fetchone()
    if result:
        store_name = result[1]
        if 'shufersal' in store_name.lower() or 'שופרסל' in store_name:
            chain_name = "Shufersal"
        elif 'super' in store_name.lower() or 'פארם' in store_name:
            chain_name = "SuperPharm"
        else:
            chain_name = f"Chain {chain_id}"
        
        print(f"   {chain_name}: {stores} חנויות, {prices:,} מחירים")

print()

# 3. Sample products from each chain
print("🛍️ דוגמאות מוצרים:")
print()

# Shufersal sample
print("   📦 Shufersal:")
cur.execute("""
    SELECT p.name, p.barcode, pr.price
    FROM products p
    JOIN prices pr ON pr.product_id = p.id
    JOIN stores s ON pr.store_id = s.id
    WHERE s.chain_id = 2
    LIMIT 3
""")
for name, barcode, price in cur.fetchall():
    print(f"      • {name[:40]} | ברקוד: {barcode} | ₪{price}")

print()

# SuperPharm sample
print("   💊 SuperPharm:")
cur.execute("""
    SELECT p.name, p.barcode, pr.price
    FROM products p
    JOIN prices pr ON pr.product_id = p.id
    JOIN stores s ON pr.store_id = s.id
    WHERE s.chain_id = 210
    LIMIT 3
""")
for name, barcode, price in cur.fetchall():
    print(f"      • {name[:40]} | ברקוד: {barcode} | ₪{price}")

print()

# 4. Price range check
print("💰 טווח מחירים:")
cur.execute("""
    SELECT 
        MIN(price) as min_price,
        MAX(price) as max_price,
        AVG(price) as avg_price,
        COUNT(*) as count
    FROM prices
    WHERE price > 0
""")
min_p, max_p, avg_p, count = cur.fetchone()
print(f"   מינימום: ₪{min_p:.2f}")
print(f"   מקסימום: ₪{max_p:.2f}")
print(f"   ממוצע: ₪{avg_p:.2f}")
print(f"   מחירים תקינים: {count:,}")

print()

# 5. Top stores by prices
print("🏆 Top 10 חנויות לפי מספר מחירים:")
cur.execute("""
    SELECT s.name, COUNT(p.id) as price_count
    FROM stores s
    JOIN prices p ON p.store_id = s.id
    GROUP BY s.name
    ORDER BY price_count DESC
    LIMIT 10
""")
for i, (name, count) in enumerate(cur.fetchall(), 1):
    print(f"   {i}. {name[:50]}: {count:,} מחירים")

print()

# 6. Data quality checks
print("✅ בדיקות תקינות:")

# Check for missing barcodes
cur.execute("SELECT COUNT(*) FROM products WHERE barcode IS NULL OR barcode = ''")
missing_barcodes = cur.fetchone()[0]
if missing_barcodes > 0:
    pct = (missing_barcodes / total_products * 100)
    print(f"   ⚠️  מוצרים ללא ברקוד: {missing_barcodes:,} ({pct:.1f}%)")
else:
    print(f"   ✅ כל המוצרים עם ברקוד")

# Check for zero prices
cur.execute("SELECT COUNT(*) FROM prices WHERE price = 0 OR price IS NULL")
zero_prices = cur.fetchone()[0]
if zero_prices > 0:
    pct = (zero_prices / total_prices * 100)
    print(f"   ⚠️  מחירים באפס/null: {zero_prices:,} ({pct:.1f}%)")
else:
    print(f"   ✅ כל המחירים תקינים")

# Check for duplicate products
cur.execute("""
    SELECT barcode, COUNT(*) as count
    FROM products
    WHERE barcode IS NOT NULL AND barcode != ''
    GROUP BY barcode
    HAVING COUNT(*) > 1
    LIMIT 1
""")
if cur.fetchone():
    cur.execute("""
        SELECT COUNT(DISTINCT barcode)
        FROM (
            SELECT barcode
            FROM products
            WHERE barcode IS NOT NULL AND barcode != ''
            GROUP BY barcode
            HAVING COUNT(*) > 1
        ) AS dupes
    """)
    dupes = cur.fetchone()[0]
    print(f"   ⚠️  ברקודים כפולים: {dupes:,}")
else:
    print(f"   ✅ אין ברקודים כפולים")

print()
print("=" * 80)

cur.close()
