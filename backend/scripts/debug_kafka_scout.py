
import sys
import logging
from pathlib import Path

# Add backend to path
sys.path.append(str(Path(__file__).parent.parent))

from kafka_services.producer_scout import ImportScout

logging.basicConfig(level=logging.INFO)

def run_debug_scout():
    print("Initializing Scout...")
    scout = ImportScout()
    
    print("Starting Scan...")
    # This calls scan_sources() which iterates registry
    scout.scan_sources()
    print("Scan Complete.")

if __name__ == "__main__":
    run_debug_scout()
