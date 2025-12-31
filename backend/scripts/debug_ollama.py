import requests

def check_ollama():
    url = "http://host.docker.internal:11434/api/tags"
    print(f"Checking Ollama at {url}...")
    try:
        res = requests.get(url, timeout=5)
        print(f"Status: {res.status_code}")
        print(f"Models: {res.text}")
    except Exception as e:
        print(f"Error: {e}")
        # Try localhost just in case (network mode host?)
        try:
            url2 = "http://localhost:11434/api/tags"
            print(f"Trying {url2}...")
            res = requests.get(url2, timeout=5)
            print(f"Status: {res.status_code}")
        except Exception as e2:
            print(f"Error localhost: {e2}")

if __name__ == "__main__":
    check_ollama()
