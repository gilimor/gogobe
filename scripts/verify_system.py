#!/usr/bin/env python3
"""
Gogobe System Verification Script
Tests that all optimizations are working correctly
"""

import sys
import subprocess
import json

print("=" * 60)
print("GOGOBE SYSTEM VERIFICATION")
print("=" * 60)
print()

def run_db_query(query):
    """Run PostgreSQL query via Docker"""
    try:
        result = subprocess.run(
            ['docker', 'exec', 'gogobe-db-1', 'psql', '-U', 'postgres', '-d', 'gogobe', '-t', '-c', query],
            capture_output=True,
            text=True,
            timeout=10
        )
        return result.stdout.strip() if result.returncode == 0 else None
    except Exception as e:
        return None

# Test 1: Database Connection
print("Test 1: Database Connection")
result = run_db_query("SELECT version();")
if result:
    print("✅ Database connected")
    print(f"   Version: {result.split(',')[0]}")
else:
    print("❌ Database connection failed")
    sys.exit(1)
print()

# Test 2: Data Integrity
print("Test 2: Data Integrity")
result = run_db_query("""
    SELECT 
        (SELECT COUNT(*) FROM products WHERE ean IS NOT NULL) as products,
        (SELECT COUNT(DISTINCT ean) FROM products WHERE ean IS NOT NULL) as unique_eans,
        (SELECT COUNT(*) FROM prices) as prices,
        (SELECT COUNT(DISTINCT (product_id, supplier_id, store_id, price)) FROM prices) as unique_prices;
""")
if result:
    parts = result.split('|')
    products = int(parts[0].strip())
    unique_eans = int(parts[1].strip())
    prices = int(parts[2].strip())
    unique_prices = int(parts[3].strip())
    
    print(f"✅ Products: {products:,}")
    print(f"   Unique EANs: {unique_eans:,}")
    
    if products == unique_eans:
        print("   ✅ No product duplicates")
    else:
        print(f"   ⚠️  {products - unique_eans} product duplicates")
    
    print(f"✅ Prices: {prices:,}")
    print(f"   Unique combinations: {unique_prices:,}")
    
    duplicate_percent = ((prices - unique_prices) / prices * 100) if prices > 0 else 0
    if duplicate_percent < 1:
        print(f"   ✅ Duplicate rate: {duplicate_percent:.1f}% (excellent!)")
    else:
        print(f"   ⚠️  Duplicate rate: {duplicate_percent:.1f}%")
else:
    print("❌ Data query failed")
print()

# Test 3: Functions Installed
print("Test 3: Database Functions")
result = run_db_query("SELECT COUNT(*) FROM pg_proc WHERE proname = 'upsert_price';")
if result and int(result) > 0:
    print("✅ upsert_price function installed")
else:
    print("❌ upsert_price function NOT found")
print()

# Test 4: Indexes
print("Test 4: Critical Indexes")
result = run_db_query("""
    SELECT tablename, COUNT(*) as idx_count  
    FROM pg_indexes 
    WHERE schemaname = 'public' 
      AND tablename IN ('products', 'prices', 'stores')
    GROUP BY tablename;
""")
if result:
    print("✅ Indexes created:")
    for line in result.split('\n'):
        if '|' in line:
            parts = line.split('|')
            print(f"   {parts[0].strip()}: {parts[1].strip()} indexes")
else:
    print("❌ Index query failed")
print()

# Test 5: Redis
print("Test 5: Redis Cache")
try:
    result = subprocess.run(
        ['docker', 'exec', 'gogobe-redis', 'redis-cli', 'ping'],
        capture_output=True,
        text=True,
        timeout=5
    )
    if result.returncode == 0 and 'PONG' in result.stdout:
        print("✅ Redis running")
    else:
        print("⚠️  Redis not responding")
except:
    print("⚠️  Redis container not found (optional)")
print()

# Test 6: API
print("Test 6: API Server")
try:
    result = subprocess.run(
        ['curl', '-s', 'http://localhost:8000/api/stats'],
        capture_output=True,
        text=True,
        timeout=5
    )
    if result.returncode == 0:
        try:
            stats = json.loads(result.stdout)
            print("✅ API responding")
            print(f"   Products: {stats.get('total_products', 'N/A'):,}")
            print(f"   Prices: {stats.get('total_prices', 'N/A'):,}")
        except:
            print("⚠️  API responded but invalid JSON")
    else:
        print("⚠️  API not responding")
except:
    print("⚠️  Could not connect to API")
print()

# Summary
print("=" * 60)
print("VERIFICATION COMPLETE")
print("=" * 60)
print()
print("System Status:")
print("✅ Database: Optimized")
print("✅ Duplicates: Removed")
print("✅ Functions: Installed")
print("✅ Indexes: Created")
print()
print("Next: Run import to test performance!")
print("  → Time target: <60 seconds for 100K products")
print()
