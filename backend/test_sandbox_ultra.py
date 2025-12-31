#!/usr/bin/env python3
"""
⚡ SANDBOX MODE - ULTRA FAST
Uses Redis cache + existing files + small dataset
Perfect for development and testing
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
import psycopg2
from datetime import datetime

print("=" * 70)
print("⚡ SANDBOX MODE - ULTRA FAST TEST")
print("=" * 70)
print()

# Configuration
LIMIT_FILES = 1  # Import only 1 file

print(f"Config: {LIMIT_FILES} file(s) max")
print()

# Connect to DB
conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres',
    password='9152245-Gl!',
    host='gogobe-db-1'
)
cur = conn.cursor()

# BEFORE
cur.execute("SELECT COUNT(*) FROM products")
before_products = cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM prices")
before_prices = cur.fetchone()[0]

print(f"BEFORE: {before_products:,} products, {before_prices:,} prices")
print()

start_time = datetime.now()
start_mark = start_time

# Use the scraper's built-in import (it handles everything correctly)
scraper = ShufersalScraper()

print(f"⏳ Importing {LIMIT_FILES} file(s)...")
print()

# Let the scraper handle everything - it knows how to parse and import
stats = scraper.import_files(limit=LIMIT_FILES)

duration = (datetime.now() - start_time).total_seconds()

# AFTER
cur.execute("SELECT COUNT(*) FROM products")
after_products = cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM prices")
after_prices = cur.fetchone()[0]

# Mark as sandbox
try:
    cur.execute("UPDATE products SET is_sandbox = TRUE WHERE created_at > %s", (start_mark,))
    products_marked = cur.rowcount
    cur.execute("UPDATE prices SET is_sandbox = TRUE WHERE scraped_at > %s", (start_mark,))
    prices_marked = cur.rowcount
    cur.execute("UPDATE stores SET is_sandbox = TRUE WHERE created_at > %s", (start_mark,))
    stores_marked = cur.rowcount
    conn.commit()
    sandbox_ok = True
except Exception as e:
    print(f"⚠️  Sandbox marking failed: {e}")
    sandbox_ok = False
    products_marked = prices_marked = stores_marked = 0

conn.close()

print("\n" + "=" * 70)
print("✅ SANDBOX TEST COMPLETE!")
print("=" * 70)
print(f"Duration: {duration:.1f}s")
print()
print(f"Products: {before_products:,} → {after_products:,} (+{after_products-before_products:,})")
print(f"Prices: {before_prices:,} → {after_prices:,} (+{after_prices-before_prices:,})")
print()
print("Import Stats:")
print(f"  Files: {stats.get('files', 0)}")
print(f"  Products created: {stats.get('products', 0)}")
print(f"  Prices imported: {stats.get('prices', 0)}")
print(f"  Errors: {stats.get('errors', 0)}")
print()

if duration > 0:
    prices_imported = stats.get('prices', 0)
    if prices_imported > 0:
        print(f"⚡ Performance: {prices_imported/duration:.0f} prices/second")
        print()

if sandbox_ok:
    print(f"🏷️  Marked as SANDBOX:")
    print(f"   Products: {products_marked:,}")
    print(f"   Prices: {prices_marked:,}")
    print(f"   Stores: {stores_marked}")
    print()
    print("To cleanup:")
    print('   docker exec gogobe-db-1 psql -U postgres -d gogobe -c "DELETE FROM prices WHERE is_sandbox=TRUE; DELETE FROM products WHERE is_sandbox=TRUE; DELETE FROM stores WHERE is_sandbox=TRUE;"')

print("=" * 70)
