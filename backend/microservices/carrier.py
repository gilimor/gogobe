
"""
Microservice #2: CARRIER (The Download Service)
Responsibility: Download large files from remote servers to local storage.
Input: File URL + Metadata
Output: Local Path + 'File Downloaded' event.
"""
import sys
import logging
from pathlib import Path
import requests

# Add parent directory to path
sys.path.append(str(Path(__file__).resolve().parents[2]))

from backend.scrapers.base_supermarket_scraper import FileMetadata

logging.basicConfig(level=logging.INFO, format='%(asctime)s [CARRIER] %(message)s')
logger = logging.getLogger("Carrier")

def run_carrier(url, filename, chain_name):
    logger.info(f"🚚 Carrier Job: {filename}")
    
    # Define Download Path (Shared Volume)
    base_dir = Path("data") / chain_name
    base_dir.mkdir(parents=True, exist_ok=True)
    output_path = base_dir / filename
    
    if output_path.exists():
        logger.info(f"File exists: {output_path}")
        return str(output_path)
        
    try:
        # Generic Download Logic
        logger.info(f"Downloading {url}...")
        headers = {'User-Agent': 'Mozilla/5.0 (Scout/2.0)'}
        
        with requests.get(url, stream=True, headers=headers, verify=False, timeout=120) as r:
            r.raise_for_status()
            with open(output_path, 'wb') as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)
                    
        logger.info(f"✅ Download Complete: {output_path} ({output_path.stat().st_size} bytes)")
        # TODO: Push to Kafka/Redis Queue: 'process_queue'
        return str(output_path)
        
    except Exception as e:
        logger.error(f"Download Failed: {e}")
        return None

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: carrier.py <url> <filename> <chain>")
        sys.exit(1)
    
    run_carrier(sys.argv[1], sys.argv[2], sys.argv[3])
