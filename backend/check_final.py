#!/usr/bin/env python3
import sys
sys.path.insert(0, '/app/backend')
from scrapers.scraper_registry import get_registry

print("💰 בדיקת מחירי מבצע")
print("=" * 70)
print()

registry = get_registry()
scraper = registry.get('shufersal')
scraper.get_db_connection()
cur = scraper.conn.cursor()

# Total prices
cur.execute("SELECT COUNT(*) FROM prices")
total = cur.fetchone()[0]

# Prices on sale
cur.execute("SELECT COUNT(*) FROM prices WHERE is_on_sale = TRUE")
on_sale = cur.fetchone()[0]

# With discount
cur.execute("SELECT COUNT(*) FROM prices WHERE discount_percentage > 0")
with_discount = cur.fetchone()[0]

print(f"סה\"כ מחירים: {total:,}")
print(f"מחירי מבצע (is_on_sale): {on_sale:,} ({on_sale/total*100:.1f}%)")
print(f"עם הנחה (discount > 0): {with_discount:,} ({with_discount/total*100:.1f}%)")

print()
print("=" * 70)
print()

# Sample sale prices
if on_sale > 0:
    print("דוגמאות למחירי מבצע:")
    cur.execute("""
        SELECT p.name, pr.price, pr.original_price, pr.discount_percentage, s.name
        FROM products p
        JOIN prices pr ON pr.product_id = p.id
        JOIN stores s ON pr.store_id = s.id
        WHERE pr.is_on_sale = TRUE
        LIMIT 5
    """)
    
    for name, price, orig, disc, store in cur.fetchall():
        print(f"  • {name[:35]:35s} | ₪{price:6.2f} (היה: ₪{orig or 0:6.2f}) | {disc or 0}% | {store[:25]}")
else:
    print("⚠️  אין מחירי מבצע במערכת")

print()

# Store address status
print("=" * 70)
print()
print("🏪 מצב כתובות חנויות:")
print()

cur.execute("""
    SELECT 
        s.chain_id,
        COUNT(*) as total,
        COUNT(CASE WHEN address IS NOT NULL AND address != '' THEN 1 END) as with_address
    FROM stores s
    GROUP BY s.chain_id
    ORDER BY total DESC
""")

for chain_id, total, with_addr in cur.fetchall():
    # Get chain name
    cur_temp = scraper.conn.cursor()
    cur_temp.execute("SELECT name FROM stores WHERE chain_id = %s LIMIT 1", (chain_id,))
    store_name = cur_temp.fetchone()[0]
    cur_temp.close()
    
    if 'shufersal' in store_name.lower():
        chain_name = "Shufersal"
    elif 'super' in store_name.lower() or 'פארם' in store_name:
        chain_name = "SuperPharm"
    else:
        chain_name = f"Chain {chain_id}"
    
    pct = (with_addr / total * 100) if total > 0 else 0
    status = "✅" if pct > 80 else "⚠️"
    print(f"  {status} {chain_name:20s} {with_addr:3d}/{total:3d} חנויות עם כתובת ({pct:5.1f}%)")

print()
print("=" * 70)

cur.close()
