#!/usr/bin/env python3
import redis

r = redis.Redis(host='redis')

# Direct test
print("Direct xreadgroup test:")
msgs = r.xreadgroup(
    groupname='downloaders',
    consumername='direct-test',
    streams={'import:download': '>'},
    count=1,
    block=1000
)

print(f"Messages returned: {len(msgs)}")
if msgs:
    print(f"Content: {msgs}")
else:
    print("Empty list returned")
    
# Check group status
info = r.xinfo_groups('import:download')
print(f"\nGroup info: {info}")
