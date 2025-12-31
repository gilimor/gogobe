
import requests
import json
import sys

def test_sse():
    print("Testing SSE Endpoint...")
    url = "http://localhost:8000/api/stream-status"
    
    try:
        with requests.get(url, stream=True, timeout=5) as r:
            print(f"Status Code: {r.status_code}")
            if r.status_code != 200:
                print("FAILED: Endpoint not returning 200 OK")
                return

            print("Connected! Listening for events...")
            # I'll iterate lines to simulate specific event capturing
            chunks_received = 0
            for line in r.iter_lines():
                if line:
                    decoded = line.decode('utf-8')
                    print(f"RX: {decoded[:100]}...") # Print first 100 chars
                    
                    if decoded.startswith("data:"):
                        try:
                            json_str = decoded[6:] # Strip 'data: '
                            data = json.loads(json_str)
                            print("✅ Valid JSON received!")
                            print(f"Active Tasks: {len(data.get('active_tasks', []))}")
                            print(f"System Metrics: {data.get('system')}")
                            chunks_received += 1
                        except json.JSONDecodeError:
                            print("❌ Invalid JSON in data packet")
                
                if chunks_received >= 20: 
                    print("Test Passed: Received 20 data packets.")
                    break
                    
    except Exception as e:
        print(f"❌ Connection failed: {e}")

if __name__ == "__main__":
    test_sse()
