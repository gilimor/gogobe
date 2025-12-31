#!/usr/bin/env python3
"""
Redis Cache Warmup
Pre-loads all products into Redis for faster imports
"""
import sys
sys.path.insert(0, '/app/backend')

from cache.redis_cache import get_cache
import psycopg2
from datetime import datetime

print("=" * 70)
print("⚡ REDIS CACHE WARMUP")
print("=" * 70)
print()

start = datetime.now()

# Connect to DB
conn = psycopg2.connect(
    dbname='gogobe',
    user='postgres',
    password='9152245-Gl!',
    host='gogobe-db-1'
)

cache = get_cache()
cur = conn.cursor()

print("Loading products from database...")
cur.execute("SELECT ean, id FROM products WHERE ean IS NOT NULL")
products_list = cur.fetchall()
products_dict = {ean: product_id for ean, product_id in products_list}

print(f"Found {len(products_dict):,} products")
print()

print("Loading stores from database...")
cur.execute("SELECT chain_id, store_id, id FROM stores")
stores_list = cur.fetchall()

print(f"Found {len(stores_list):,} stores")
print()

# Warmup products
print("Warming up Redis cache...")
cache.cache_products_batch(products_dict, ttl_hours=24)

# Warmup stores
for chain_id, store_code, store_id in stores_list:
    cache.cache_store(chain_id, store_code, store_id, ttl_hours=24)

conn.close()

duration = (datetime.now() - start).total_seconds()

print()
print("=" * 70)
print("✅ CACHE WARMUP COMPLETE!")
print("=" * 70)
print(f"Duration: {duration:.1f}s")
print()
print(f"Cached:")
print(f"  Products: {len(products_dict):,}")
print(f"  Stores: {len(stores_list):,}")
print()
print("Cache Stats:")
stats = cache.get_stats()
print(f"  Status: {stats.get('status')}")
print(f"  Total keys: {stats.get('total_keys', 0):,}")
print()
print("✓ All imports will now use cached data!")
print("✓ Expected speedup: 1.4-2x faster")
print("=" * 70)
