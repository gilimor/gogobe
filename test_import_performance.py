#!/usr/bin/env python3
"""
Test Import Performance
Quick script to test cache + batch processing improvements
"""

import time
import psycopg2
from pathlib import Path
import sys

# Add backend to path
sys.path.insert(0, str(Path(__file__).parent / 'backend'))

from cache.redis_cache import get_cache

def test_cache_connection():
    """Test 1: Redis Connection"""
    print("="*60)
    print("TEST 1: Redis Cache Connection")
    print("="*60)
    
    cache = get_cache()
    stats = cache.get_stats()
    
    if stats.get('status') == 'connected':
        print("✅ Redis connected!")
        print(f"   Memory: {stats.get('memory_used', 'N/A')}")
        print(f"   Keys: {stats.get('total_keys', 0)}")
        print(f"   Hit rate: {stats.get('hit_rate', 0):.1f}%")
    else:
        print("⚠️  Redis not available")
        print("   System will work without cache (slower)")
    print()

def test_database_functions():
    """Test 2: Database Functions"""
    print("="*60)
    print("TEST 2: Database Functions")
    print("="*60)
    
    try:
        conn = psycopg2.connect(
            dbname='gogobe',
            user='postgres',
            password='9152245-Gl!',
            host='localhost',
            port='5432'
        )
        cur = conn.cursor()
        
        # Test upsert_price function
        print("Checking upsert_price function...")
        cur.execute("""
            SELECT COUNT(*) FROM pg_proc 
            WHERE proname = 'upsert_price'
        """)
        count = cur.fetchone()[0]
        
        if count > 0:
            print("✅ upsert_price function exists")
            
            # Test it
            cur.execute("""
                SELECT upsert_price(999999, 1, 1, 9.99, 'ILS', TRUE, 0.01)
            """)
            result = cur.fetchone()[0]
            print(f"✅ Function works! (returned: {result})")
            conn.rollback()  # Don't save test data
        else:
            print("❌ upsert_price function NOT found!")
            print("   → Run: backend/database/functions/upsert_price.sql")
        
        print()
        
        # Test indexes
        print("Checking critical indexes...")
        cur.execute("""
            SELECT tablename, COUNT(*) as idx_count
            FROM pg_indexes
            WHERE schemaname = 'public'
              AND tablename IN ('products', 'prices', 'stores')
            GROUP BY tablename
            ORDER BY tablename
        """)
        
        total_indexes = 0
        for table, count in cur.fetchall():
            print(f"   {table}: {count} indexes")
            total_indexes += count
        
        if total_indexes >= 10:
            print(f"✅ Found {total_indexes} indexes (good!)")
        else:
            print(f"⚠️  Only {total_indexes} indexes found")
            print("   → Run: backend/database/indexes_critical.sql")
        
        cur.close()
        conn.close()
        
    except Exception as e:
        print(f"❌ Database error: {e}")
    
    print()

def test_import_performance():
    """Test 3: Import Performance"""
    print("="*60)
    print("TEST 3: Import One File (Performance Test)")
    print("="*60)
    
    try:
        from scrapers.published_prices_scraper import PublishedPricesScraper
        
        scraper = PublishedPricesScraper()
        
        print("Starting import test...")
        print("(importing 1 file to measure performance)")
        print()
        
        start = time.time()
        
        # Import just 1 file
        stats = scraper.import_files(limit=1)
        
        elapsed = time.time() - start
        
        print()
        print("="*60)
        print("PERFORMANCE RESULTS")
        print("="*60)
        print(f"Time elapsed: {elapsed:.2f} seconds")
        print(f"Products created: {stats.get('products', 0)}")
        print(f"Prices imported: {stats.get('prices', 0)}")
        print(f"Cache hits: {stats.get('cached', 0)}")
        
        if stats.get('prices', 0) > 0:
            rate = stats['prices'] / elapsed
            print(f"Import rate: {rate:.0f} products/second")
            
            # Estimate for 100K
            estimated_time = 100000 / rate
            print(f"\n📊 Estimated time for 100K products: {estimated_time:.1f} seconds")
            
            if estimated_time < 60:
                print("✅ EXCELLENT! Under 60 seconds target!")
            elif estimated_time < 300:
                print("⚠️  Good, but can be improved")
            else:
                print("❌ Too slow - check Redis and indexes")
        
    except Exception as e:
        print(f"❌ Import test failed: {e}")
        import traceback
        traceback.print_exc()
    
    print()

def main():
    """Run all tests"""
    print("\n")
    print("🚀 " + "="*56 + " 🚀")
    print("   GOGOBE PERFORMANCE TEST SUITE")
    print("🚀 " + "="*56 + " 🚀")
    print()
    
    test_cache_connection()
    test_database_functions()
    test_import_performance()
    
    print("="*60)
    print("✅ Tests Complete!")
    print("="*60)
    print()
    print("Next steps:")
    print("1. If upsert_price missing: Install via pgAdmin")
    print("2. If indexes low: Install via pgAdmin")
    print("3. If Redis unavailable: docker run -d -p 6379:6379 redis")
    print("4. If performance good: Proceed to Master Product Matching!")
    print()

if __name__ == "__main__":
    main()
