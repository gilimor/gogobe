#!/usr/bin/env python3
import sys
sys.path.insert(0, '/app/backend')

from scrapers.scraper_registry import get_registry

print("📊 בדיקה: האם יובאו נתונים מ-2 ספקים?")
print("=" * 70)
print()

registry = get_registry()

# Check Shufersal
shufersal = registry.get('shufersal')
if shufersal and shufersal.conn:
    cur = shufersal.conn.cursor()
    
    # Count all prices
    cur.execute("SELECT COUNT(*) FROM prices")
    total_prices = cur.fetchone()[0]
    
    # Count stores with prices
    cur.execute("SELECT COUNT(DISTINCT store_id) FROM prices")
    stores_with_prices = cur.fetchone()[0]
    
    # Top stores by name
    cur.execute("""
        SELECT s.name, COUNT(p.id) as count
        FROM stores s
        JOIN prices p ON p.store_id = s.id
        GROUP BY s.name
        ORDER BY count DESC
        LIMIT 15
    """)
    
    print(f"📈 סטטיסטיקה כללית:")
    print(f"   סה\"כ מחירים: {total_prices:,}")
    print(f"   חנויות עם מחירים: {stores_with_prices}")
    print()
    
    print("🏪 15 החנויות המובילות:")
    for name, count in cur.fetchall():
        # Check if Shufersal or SuperPharm
        if 'shufersal' in name.lower() or 'שופרסל' in name:
            icon = "🛒"
        elif 'super' in name.lower() or 'פארם' in name or 'pharm' in name.lower():
            icon = "💊"
        else:
            icon = "🏪"
        print(f"   {icon} {name}: {count:,} מחירים")
    
    # Check for SuperPharm explicitly
    cur.execute("""
        SELECT COUNT(DISTINCT s.id), COUNT(p.id)
        FROM stores s
        LEFT JOIN prices p ON p.store_id = s.id
        WHERE s.name ILIKE '%super%pharm%' OR s.name ILIKE '%סופר%פארם%'
    """)
    sp_stores, sp_prices = cur.fetchone()
    
    print()
    print("=" * 70)
    print()
    
    if sp_prices and sp_prices > 0:
        print(f"✅ יש נתונים מ-SuperPharm!")
        print(f"   {sp_stores} חנויות SuperPharm")
        print(f"   {sp_prices:,} מחירים מ-SuperPharm")
    else:
        print(f"❌ אין עדיין נתונים מ-SuperPharm")
        print(f"   (נמצאו {sp_stores} חנויות אבל ללא מחירים)")
        print()
        print("💡 סיבה אפשרית: השגיאה 'store_cache' ב-SuperPharmScraper")
    
    cur.close()

print()
print("=" * 70)
