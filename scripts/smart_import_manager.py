
import subprocess
import time
import sys
import re

MAX_IDLE_SECONDS = 60  # Stop after 60 seconds of silence
CHECK_INTERVAL = 10    # Check every 10 seconds

def run_cmd(cmd, shell=True, capture_output=True):
    """Runs a shell command and returns stdout."""
    print(f"Executing: {cmd}")
    try:
        result = subprocess.run(
            cmd, 
            shell=shell, 
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE,
            text=True
        )
        if result.returncode != 0:
            print(f"Error executing command: {result.stderr}")
        return result.stdout.strip()
    except Exception as e:
        print(f"Exception: {e}")
        return ""

def get_lag(group_id):
    """Checks Kafka Consumer Group Lag using docker exec."""
    # Command: kafka-consumer-groups --bootstrap-server kafka:29092 --describe --group <group_id>
    # Output format is table, need to parse.
    cmd = (
        f"docker exec gogobe-kafka-1 kafka-consumer-groups "
        f"--bootstrap-server kafka:29092 --describe --group {group_id}"
    )
    
    output = run_cmd(cmd)
    
    # Check for empty output or errors
    if not output or "Error" in output:
        return 0 # Assume 0 to avoid crashing, but could be dangerous if we stop too early. 
                 # Actually if kafka is down, we probably should stop anyway.

    # Parse output lines
    # Example:
    # GROUP           TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID     HOST            CLIENT-ID
    # gogobe_v1       topic1          0          10              12              2               ...
    
    total_lag = 0
    lines = output.split('\n')
    for line in lines:
        parts = line.split()
        if len(parts) > 5 and parts[5].isdigit():
            total_lag += int(parts[5])
            
    return total_lag

def main():
    print("🚀 Starting Smart Import Manager...")
    
    # 1. Start Infrastructure (Lightweight)
    print("\n--- Phase 1: Warming Up Engines (DB, Kafka, Redis) ---")
    run_cmd("docker-compose up -d db redis zookeeper kafka api")
    
    print("⏳ Waiting 15s for Kafka to stabilize...")
    time.sleep(15)
    
    # 2. Start Workers (Heavyweight)
    print("\n--- Phase 2: Deploying Workers (Carrier, Parser) ---")
    # Using 'patched' image logic from docker-compose
    run_cmd("docker-compose up -d --scale parser=2 carrier")
    
    print("⏳ Waiting 10s for Workers to join Group...")
    time.sleep(10)
    
    # 3. Trigger Scout (The Task)
    print("\n--- Phase 3: Launching Scout (Finding Sources) ---")
    # Run the scout inside gogobe-api-1 container
    scout_log = run_cmd("docker exec gogobe-api-1 python /app/backend/kafka_services/producer_scout.py")
    print("Scout Output snippet:", scout_log[:200])
    
    # 4. Monitor Loop
    print("\n--- Phase 4: Monitoring Progress ---")
    idle_counter = 0
    groups = ['gogobe_carriers_v1', 'gogobe_processors_v1']
    
    while True:
        total_lag = 0
        for g in groups:
            lag = get_lag(g)
            total_lag += lag
            print(f"   Group {g}: Lag={lag}")
            
        print(f"Total Combined Lag: {total_lag}")
        
        if total_lag == 0:
            idle_counter += 1
            print(f"✅ System matches Idle criteria ({idle_counter}/{MAX_IDLE_SECONDS // CHECK_INTERVAL})")
        else:
            idle_counter = 0
            print("⚡ System is BUSY processing...")
            
        if idle_counter * CHECK_INTERVAL >= MAX_IDLE_SECONDS:
            print("\n🎉 Work Complete! System is idle.")
            break
            
        time.sleep(CHECK_INTERVAL)

    # 5. Shutdown Workers
    print("\n--- Phase 5: Shutting Down Workers ---")
    run_cmd("docker-compose stop parser carrier")
    run_cmd("docker-compose rm -f parser carrier")
    
    # Optional: Stop Kafka too? 
    # User said "Open docker/services only when needed".
    # Kafka is heavy (Java). Let's stop Kafka/Zookeeper too, but keep DB/Redis/API.
    print("--- Phase 6: Shutting Down Kafka to save RAM ---")
    run_cmd("docker-compose stop kafka zookeeper")
    
    print("\n✅ DONE. DB and API are still running for you to browse data.")
    print("   Access: http://localhost:8000/static/debug_file_list.html")
    print("   To stop everything completely, run: docker-compose down")

if __name__ == "__main__":
    main()
