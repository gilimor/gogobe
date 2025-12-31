
import json
import time
import os
import sys
from kafka import KafkaConsumer

# Configuration
KAFKA_BROKER = 'localhost:9092'
SOURCE_TOPIC = 'gogobe.files.discovered'
DEST_TOPIC = 'gogobe.files.downloaded'
GROUP_ID = 'carrier_downloaders'

def run_carrier(worker_id):
    print(f"🦅 Carrier #{worker_id} initialized. Connecting to {KAFKA_BROKER}...")
    
    try:
        # Consumer: Listens for discovered files
        consumer = KafkaConsumer(
            SOURCE_TOPIC,
            bootstrap_servers=KAFKA_BROKER,
            group_id=GROUP_ID,
            auto_offset_reset='earliest',
            value_deserializer=lambda x: json.loads(x.decode('utf-8'))
        )
        
        print(f"✅ Carrier #{worker_id} is LISTENING for jobs...")
        
        for message in consumer:
            task = message.value
            filename = task['filename']
            chain = task['chain']
            
            print(f"🦅 [Carrier #{worker_id}] Processing: {filename}")
            
            # SIMULATE DOWNLOAD (IO Bound)
            # In real life: requests.get(url)
            time.sleep(2) 
            
            print(f"⬇️ [Carrier #{worker_id}] Downloaded: {filename} from {chain}")
            
            # Use 'kafka-python' or similar to send success message to next topic
            # (Skipped here for brevity, logic implies pushing to Next Stage)

    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    # Allow running multiple with "python carrier.py 1", "python carrier.py 2"
    w_id = sys.argv[1] if len(sys.argv) > 1 else "1"
    run_carrier(w_id)
