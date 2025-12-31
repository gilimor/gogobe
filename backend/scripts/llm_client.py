import requests
import json
import logging

OLLAMA_HOST = "http://host.docker.internal:11434"
MODEL = "llama3"

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def generate_completion(prompt):
    url = f"{OLLAMA_HOST}/api/generate"
    payload = {
        "model": MODEL,
        "prompt": prompt,
        "stream": False,
        "format": "json" # Enforce JSON output
    }
    
    try:
        logger.info(f"Sending prompt to Ollama ({MODEL})...")
        res = requests.post(url, json=payload, timeout=300) # Extended timeout for CPU inference
        if res.status_code == 200:
            data = res.json()
            return data.get('response', '')
        elif res.status_code == 404:
             logger.error(f"Model '{MODEL}' not found. Please run 'ollama pull {MODEL}' on host.")
             return None
        else:
            logger.error(f"Ollama Error {res.status_code}: {res.text}")
            return None
    except Exception as e:
        logger.error(f"Connection Error: {e}")
        return None

if __name__ == "__main__":
    # Test
    print(generate_completion("Return a JSON list of 3 fruits."))
