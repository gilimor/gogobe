#!/usr/bin/env python3
import sys
sys.path.insert(0, '/app/backend')
from scrapers.scraper_registry import get_registry

s = get_registry().get('shufersal')
s.get_db_connection()
cur = s.conn.cursor()

cur.execute("SELECT column_name FROM information_schema.columns WHERE table_name='products' ORDER BY ordinal_position")
print("Products table columns:")
for col in cur.fetchall():
    print(f"  - {col[0]}")
