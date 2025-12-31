
import requests
import sys

def test_stats():
    try:
        url = "http://localhost:8000/api/admin/masters/stats"
        print(f"Testing URL: {url}")
        resp = requests.get(url)
        print(f"Status Code: {resp.status_code}")
        if resp.status_code == 200:
            print("Response:", resp.json())
        else:
            print("Error:", resp.text)
    except Exception as e:
        print(f"Failed to connect: {e}")

if __name__ == "__main__":
    test_stats()
