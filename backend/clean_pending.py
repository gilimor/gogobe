#!/usr/bin/env python3
"""Clean and claim old pending messages"""
import sys
sys.path.insert(0, '/app/backend')

import redis

r = redis.Redis(host='redis')

print("🔧 Cleaning старые pending messages...\n")

# Get pending messages that are old
try:
    # Get all pending messages
    pending_info = r.xpending('import:download', 'downloaders')
    print(f"Total pending: {pending_info['pending']}")
    
    if pending_info['pending'] > 0:
        # Get detailed list
        pending_list = r.xpending_range('import:download', 'downloaders', '-', '+', count=1000)
        
        print(f"\nFound {len(pending_list)} pending messages")
        
        # Claim old messages (older than 10 seconds)
        to_claim = []
        for msg in pending_list:
            msg_id = msg['message_id']
            consumer = msg['consumer']
            idle_time = msg['time_since_delivered']
            
            if idle_time > 10000:  # 10 seconds
                to_claim.append(msg_id)
        
        if to_claim:
            print(f"\nClaiming {len(to_claim)} old messages...")
            # Claim them for a new fictitious consumer
            claimed = r.xclaim('import:download', 'downloaders', 'cleanup-worker', min_idle_time=10000, message_ids=to_claim)
            print(f"✅ Claimed {len(claimed)} messages")
            
            # Now ACK them all to release
            for msg_id in to_claim:
                r.xack('import:download', 'downloaders', msg_id)
            
            print(f"✅ ACKed all {len(to_claim)} messages - they're now available again!")
        else:
            print("No old messages to claim")
            
except Exception as e:
    print(f"❌ Error: {e}")

# Show final stats
try:
    pending_info = r.xpending('import:download', 'downloaders')
    print(f"\n📊 Final pending: {pending_info['pending']}")
except Exception as e:
    print(f"Error getting final stats: {e}")
