#!/usr/bin/env python3
import redis

r = redis.Redis(host='redis')

info = r.xinfo_stream('import:download')
print(f"Stream length: {info['length']}")
print(f"First entry: {info.get('first-entry')}")
print()

msgs = r.xrange('import:download', count=2)
print(f"Sample {len(msgs)} messages:")
for msg_id, data in msgs:
    print(f"  {msg_id}: {data}")
