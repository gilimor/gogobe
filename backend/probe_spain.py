
import requests
import json
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger('SpainProbe')

URL = "https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/"

def probe():
    try:
        logger.info(f"Fetching {URL}...")
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': 'application/json'
        }
        resp = requests.get(URL, headers=headers, timeout=30)
        logger.info(f"Status: {resp.status_code}")
        
        if resp.status_code == 200:
            data = resp.json()
            # It usually has a wrapper key like "ListaEESSPrecio"
            keys = list(data.keys())
            logger.info(f"Root keys: {keys}")
            
            if 'ListaEESSPrecio' in data:
                stations = data['ListaEESSPrecio']
                logger.info(f"Found {len(stations)} stations.")
                if len(stations) > 0:
                    logger.info("Sample station:")
                    print(json.dumps(stations[0], indent=2, ensure_ascii=False))
            else:
                logger.warning("Key 'ListaEESSPrecio' not found.")
                print(str(data)[:500])
                
    except Exception as e:
        logger.error(f"Error: {e}")

if __name__ == "__main__":
    probe()
