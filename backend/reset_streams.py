#!/usr/bin/env python3
"""Fresh start - delete all streams and recreate"""
import redis

r = redis.Redis(host='redis')

print("🗑️  Deleting all import streams...")

# Delete streams
for stream in ['import:download', 'import:parse', 'import:process']:
    try:
        r.delete(stream)
        print(f"  ✅ Deleted {stream}")
    except Exception as e:
        print(f"  ⚠️  {stream}: {e}")

print("\n✅ All streams deleted - ready for fresh start!")
print("\nNow run: python /app/backend/orchestrator_multi.py")
