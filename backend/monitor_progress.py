#!/usr/bin/env python3
"""Monitor progress with DB stats"""
import sys
sys.path.insert(0, '/app/backend')

from import_queue.import_queue import ImportQueue
import psycopg2
import time

queue = ImportQueue()

# DB connection
conn = psycopg2.connect(
    host='db',
    port=5432,
    user='gogobe_user',
    password='gogobe_password',
    dbname='gogobe'
)

print("📊 IMPORT PROGRESS MONITOR")
print("=" * 80)
print()

for i in range(20):
    # Queue stats
    stats = queue.get_stats()
    download = stats.get('import:download', {}).get('length', 0)
    parse = stats.get('import:parse', {}).get('length', 0)
    process = stats.get('import:process', {}).get('length', 0)
    
    # DB stats
    cur = conn.cursor()
    cur.execute("SELECT COUNT(*) FROM products")
    products_count = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM prices")
    prices_count = cur.fetchone()[0]
    cur.close()
    
    print(f"\r⏳ Queue: D:{download:2d} P:{parse:2d} PR:{process:2d} | DB: Products:{products_count:,} Prices:{prices_count:,}", end='', flush=True)
    
    if download == 0 and parse == 0 and process == 0:
        print("\n\n✅ All queues empty!")
        break
    
    time.sleep(2)

print()
print("=" * 80)

# Final stats
cur = conn.cursor()
cur.execute("SELECT COUNT(*) FROM products")
final_products = cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM prices")
final_prices = cur.fetchone()[0]
cur.execute("SELECT name_en, COUNT(*) FROM store_chains GROUP BY name_en")
chains = cur.fetchall()
cur.close()
conn.close()

print("\n📈 FINAL RESULTS:")
print(f"   Products: {final_products:,}")
print(f"   Prices: {final_prices:,}")
print("\n🏪 Chains:")
for chain, count in chains:
    print(f"   {chain}: {count} stores")
print()
print("=" * 80)
