#!/usr/bin/env python3
"""Test downloader"""
import sys
sys.path.insert(0, '/app/backend')

from import_queue.import_queue import ImportQueue

queue = ImportQueue()

print("Testing get_download_jobs...")
jobs = queue.get_download_jobs("test-worker", count=1, block=100)

if jobs:
    print(f"✅ Got {len(jobs)} jobs")
    for job in jobs:
        print(f"   Job ID: {job['id']}")
        print(f"   Data: {job['data']}")
else:
    print("❌ No jobs returned")

print("\nQueue stats:")
stats = queue.get_stats()
for stream, info in stats.items():
    print(f"  {stream}: {info['length']} pending")
