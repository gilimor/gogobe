#!/usr/bin/env python3
"""
SANDBOX Mode Test Import - Simplified
Fast testing without complex setup
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
import psycopg2
from datetime import datetime

print("=" * 70)
print("🧪 SANDBOX MODE TEST - FAST IMPORT")
print("=" * 70)
print()

# Connect
conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres',
    password='9152245-Gl!',
    host='gogobe-db-1'
)
cur = conn.cursor()

# BEFORE stats
cur.execute("SELECT COUNT(*) FROM products")
before_products = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM prices")
before_prices = cur.fetchone()[0]

print("BEFORE:")
print(f"  Products: {before_products:,}")
print(f"  Prices: {before_prices:,}")
print()

# Mark start time
start_mark = datetime.now()
print(f"Start: {start_mark}")
print()

# Import 3 files ONLY
print("⏳ Importing 3 files (fast test)...")
print()
start_time = datetime.now()

scraper = ShufersalScraper()
stats = scraper.import_files(limit=3)

duration = (datetime.now() - start_time).total_seconds()

# AFTER stats
cur.execute("SELECT COUNT(*) FROM products")
after_products = cur.fetchone()[0]

cur.execute("SELECT COUNT(*) FROM prices")
after_prices = cur.fetchone()[0]

# Mark new data as sandbox (created in last 5 minutes)
try:
    cur.execute("""
        UPDATE products SET is_sandbox = TRUE 
        WHERE created_at > %s
    """, (start_mark,))
    products_marked = cur.rowcount
    
    cur.execute("""
        UPDATE prices SET is_sandbox = TRUE 
        WHERE scraped_at > %s
    """, (start_mark,))
    prices_marked = cur.rowcount
    
    cur.execute("""
        UPDATE stores SET is_sandbox = TRUE
        WHERE created_at > %s
    """, (start_mark,))
    stores_marked = cur.rowcount
    
    conn.commit()
    
    sandbox_enabled = True
except Exception as e:
    print(f"⚠️  Sandbox marking failed: {e}")
    print("   (Columns not created yet - data not marked)")
    sandbox_enabled = False
    products_marked = 0
    prices_marked = 0
    stores_marked = 0

conn.close()

print("\n" + "=" * 70)
print("✅ TEST COMPLETE!")
print("=" * 70)
print(f"Duration: {duration:.1f} seconds")
print()
print("Results:")
print(f"  Products: {before_products:,} → {after_products:,} (+{after_products - before_products:,})")
print(f"  Prices: {before_prices:,} → {after_prices:,} (+{after_prices - before_prices:,})")
print()
print("Import Stats:")
print(f"  Files processed: {stats.get('files', 0)}")
print(f"  Products created: {stats.get('products', 0)}")
print(f"  Prices imported: {stats.get('prices', 0)}")
print(f"  Errors: {stats.get('errors', 0)}")
print()

if sandbox_enabled:
    print("🏷️  Sandbox Marking:")
    print(f"  Products marked: {products_marked:,}")
    print(f"  Prices marked: {prices_marked:,}")
    print(f"  Stores marked: {stores_marked}")
    print()
    print("To cleanup:")
    print('  docker exec gogobe-db-1 psql -U postgres -d gogobe -c "DELETE FROM prices WHERE is_sandbox = TRUE;"')
    print('  docker exec gogobe-db-1 psql -U postgres -d gogobe -c "DELETE FROM products WHERE is_sandbox = TRUE;"')
    print('  docker exec gogobe-db-1 psql -U postgres -d gogobe -c "DELETE FROM stores WHERE is_sandbox = TRUE;"')
else:
    print("⚠️  Sandbox mode not enabled")
    print("   Data was imported but not marked as test data")
    
print()

# Performance
if duration > 0:
    prices_per_sec = (after_prices - before_prices) / duration
    print(f"Performance: {prices_per_sec:.0f} prices/second")

print("=" * 70)
