
import json
import time
import random
from kafka import KafkaProducer

# Configuration
KAFKA_BROKER = 'localhost:9092'
TOPIC = 'gogobe.files.discovered'

def run_scout():
    print(f"🕵️ Scout initialized. Connecting to {KAFKA_BROKER}...")
    try:
        producer = KafkaProducer(
            bootstrap_servers=KAFKA_BROKER,
            value_serializer=lambda v: json.dumps(v).encode('utf-8')
        )
        print("✅ Connected to Kafka!")
        
        chains = ['shufersal', 'superpharm', 'fresh_market', 'victory', 'tiv_taam']
        
        while True:
            # Simulate finding a file
            chain = random.choice(chains)
            file_id = random.randint(1000, 9999)
            filename = f"PriceFull_{chain}_{file_id}.gz"
            
            message = {
                'chain': chain,
                'url': f"https://url.publishedprices.co.il/{chain}/{filename}",
                'filename': filename,
                'discovered_at': time.time()
            }
            
            # Send to Kafka
            producer.send(TOPIC, message)
            print(f"🔭 Found: {filename} -> Sent to Kafka")
            
            # Sleep random time (simulating scanning)
            time.sleep(random.uniform(0.1, 0.5))
            
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    run_scout()
