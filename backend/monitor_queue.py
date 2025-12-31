#!/usr/bin/env python3
"""Monitor queue status in real-time"""
import sys
sys.path.insert(0, '/app/backend')

from import_queue.import_queue import ImportQueue
import time

queue = ImportQueue()

print("🔄 Monitoring Queue Status...")
print("Press Ctrl+C to stop")
print()

try:
    while True:
        stats = queue.get_stats()
        
        download = stats.get('import:download', {}).get('length', 0)
        parse = stats.get('import:parse', {}).get('length', 0)
        process = stats.get('import:process', {}).get('length', 0)
        
        print(f"\r⏳ Download: {download:3d} | Parse: {parse:3d} | Process: {process:3d}", end='', flush=True)
        
        if download == 0 and parse == 0 and process == 0:
            print("\n\n✅ All queues empty! Work complete!")
            break
        
        time.sleep(2)
        
except KeyboardInterrupt:
    print("\n\n⏹️  Monitoring stopped")
    stats = queue.get_stats()
    print("\nFinal stats:")
    for stream, info in stats.items():
        print(f"  {stream}: {info['length']} pending")
