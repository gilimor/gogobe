#!/usr/bin/env python3
"""
SANDBOX Mode Test Import
Fast testing with easy cleanup
"""
import sys
sys.path.insert(0, '/app/backend')

from scrapers.shufersal_scraper import ShufersalScraper
import psycopg2
from datetime import datetime

# ENABLE SANDBOX MODE
SANDBOX_MODE = True

print("=" * 70)
print("SANDBOX MODE TEST IMPORT")
print("=" * 70)
print()

if SANDBOX_MODE:
    print("⚠️  SANDBOX MODE ENABLED")
    print("   All data will be marked as test data")
    print("   Can be deleted with: SELECT cleanup_sandbox();")
    print()

# Connect
conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres',
    password='9152245-Gl!',
    host='gogobe-db-1'
)
cur = conn.cursor()

# Check current sandbox data
cur.execute("SELECT * FROM get_sandbox_stats()")
before_stats = cur.fetchall()

print("Before:")
for table, count in before_stats:
    print(f"  {table}: {count:,} sandbox records")
print()

# Temporarily modify scraper to use sandbox mode
# We'll do this by executing SQL after each insert
# For now, let's just import a few files and manually mark them

start_time = datetime.now()

scraper = ShufersalScraper()
print("Importing 3 files (SANDBOX)...")
print()

# Import
stats = scraper.import_files(limit=3)

# Mark everything from this run as sandbox
# (products/prices created in last minute)
cur.execute("""
    UPDATE products SET is_sandbox = TRUE 
    WHERE created_at > NOW() - INTERVAL '2 minutes'
""")
products_marked = cur.rowcount

cur.execute("""
    UPDATE prices SET is_sandbox = TRUE 
    WHERE scraped_at > NOW() - INTERVAL '2 minutes'
""")  
prices_marked = cur.rowcount

cur.execute("""
    UPDATE stores SET is_sandbox = TRUE
    WHERE id > 472  -- New stores created today
    AND created_at > NOW() - INTERVAL '2 minutes'
""")
stores_marked = cur.rowcount

conn.commit()

# After stats
cur.execute("SELECT * FROM get_sandbox_stats()")
after_stats = cur.fetchall()

conn.close()

end_time = datetime.now()
duration = (end_time - start_time).total_seconds()

print("\n" + "=" * 70)
print("SANDBOX IMPORT COMPLETE")
print("=" * 70)
print(f"Duration: {duration:.1f} seconds")
print()
print("Marked as SANDBOX:")
print(f"  Products: {products_marked:,}")
print(f"  Prices: {prices_marked:,}")
print(f"  Stores: {stores_marked}")
print()
print("Total SANDBOX data:")
for table, count in after_stats:
    print(f"  {table}: {count:,}")
print()
print("To cleanup:")
print("  docker exec gogobe-db-1 psql -U postgres -d gogobe -c \"SELECT cleanup_sandbox();\"")
print("=" * 70)
