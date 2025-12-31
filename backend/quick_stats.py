#!/usr/bin/env python3
import sys
sys.path.insert(0, '/app/backend')
from import_queue.import_queue import ImportQueue

q = ImportQueue()
s = q.get_stats()

print(f"Download:  {s['import:download']['length']:3d} pending")
print(f"Parse:     {s['import:parse']['length']:3d} pending")  
print(f"Process:   {s['import:process']['length']:3d} pending")
