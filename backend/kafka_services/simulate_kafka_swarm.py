
import json
import time
import random
import threading
import sys
import os

# Install kafka-python if missing (fallback)
try:
    from kafka import KafkaConsumer, KafkaProducer
    from kafka.errors import NoBrokersAvailable
except ImportError:
    print("Installing kafka-python...")
    os.system("pip install kafka-python")
    from kafka import KafkaConsumer, KafkaProducer
    from kafka.errors import NoBrokersAvailable

# Config
KAFKA_BROKER = 'kafka:29092'
TOPIC = 'gogobe.demo.tasks'
NUM_CARRIERS = 5
NUM_TASKS = 30

def get_producer():
    """Retry logic for connecting to Kafka"""
    retries = 30
    for i in range(retries):
        try:
            return KafkaProducer(
                bootstrap_servers=KAFKA_BROKER,
                value_serializer=lambda v: json.dumps(v).encode('utf-8')
            )
        except NoBrokersAvailable:
            sys.stdout.write(f"\r⏳ Connecting to Kafka (Attempt {i+1}/{retries})...")
            sys.stdout.flush()
            time.sleep(2)
    raise Exception("Could not connect to Kafka")

def scout_worker():
    """Simulates finding files and adding to Queue"""
    print(f"\n🕵️ Scout: Connecting to Kafka...")
    try:
        producer = get_producer()
        print("\n✅ Scout connected! Dispatched 30 jobs.")
        
        chains = ['Shufersal', 'SuperPharm', 'FreshMarket', 'Victory', 'TivTaam']
        
        for i in range(NUM_TASKS):
            msg = {
                'id': i,
                'filename': f"PriceFull_{random.choice(chains)}_{random.randint(1000,9999)}.gz", 
                'size': f"{random.randint(10, 500)}MB"
            }
            producer.send(TOPIC, msg)
            if i % 10 == 0:
                print(f"   scout -> dispatched batch {i}")
        producer.flush()
        
    except Exception as e:
        print(f"❌ Scout Error: {e}")

def carrier_worker(worker_id):
    """Simulates downloading files"""
    try:
        # Each worker has its own consumer
        consumer = KafkaConsumer(
            TOPIC,
            bootstrap_servers=KAFKA_BROKER,
            group_id='demo_swarm_group',
            auto_offset_reset='earliest',
            value_deserializer=lambda x: json.loads(x.decode('utf-8')),
            consumer_timeout_ms=10000 # Stop if no msg for 10s
        )
        
        for message in consumer:
            task = message.value
            print(f"🦅 [Carrier #{worker_id}] ⬇️ Downloading {task['filename']} ({task['size']})")
            
            # Simulate work (I/O)
            time.sleep(random.uniform(0.5, 2.0))
            
            print(f"✅ [Carrier #{worker_id}]    Processed {task['filename']}")
            
    except Exception as e:
        print(f"❌ Carrier #{worker_id} Error: {e}")

if __name__ == "__main__":
    print("="*60)
    print(f"🚀 LAUNCHING KAFKA SWARM SIMULATION")
    print(f"   Workers: {NUM_CARRIERS}")
    print(f"   Broker:  {KAFKA_BROKER}")
    print("="*60)
    
    # 1. Start Scout (Producer)
    scout_thread = threading.Thread(target=scout_worker)
    scout_thread.start()
    scout_thread.join() # Wait for tasks to populate
    
    # 2. Start Swarm (Consumers)
    print(f"\n🦅 Releasing {NUM_CARRIERS} Carrier Eagles...\n")
    
    threads = []
    for i in range(1, NUM_CARRIERS + 1):
        t = threading.Thread(target=carrier_worker, args=(i,))
        t.start()
        threads.append(t)
        
    for t in threads:
        t.join()
        
    print("\n🏁 Simulation Complete.")
