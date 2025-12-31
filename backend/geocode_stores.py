
import os
import sys
import time
import requests
import logging
from pathlib import Path

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')
logger = logging.getLogger(__name__)

# Add /app to path (parent of backend)
sys.path.append(str(Path(__file__).parent.parent))

# Adjust based on location: if in /app/backend, parent is /app.
# We want to be able to import 'backend.database' or just 'database' if we are in backend?
# Let's try adding `backend` directory itself to path.
sys.path.append(str(Path(__file__).parent))

try:
    from database.db_connection import get_db_connection
except ImportError:
    from backend.database.db_connection import get_db_connection

NOMINATIM_URL = "https://nominatim.openstreetmap.org/search"
USER_Agent = "GogobePriceComparison/1.0 (internal tool)"

def geocode_store(address, city):
    try:
        query = f"{address}, {city}, Israel"
        params = {
            'q': query,
            'format': 'json',
            'limit': 1,
            'addressdetails': 1
        }
        headers = {'User-Agent': USER_Agent}
        
        response = requests.get(NOMINATIM_URL, params=params, headers=headers, timeout=10)
        
        if response.status_code == 200:
            data = response.json()
            if data:
                lat = data[0]['lat']
                lon = data[0]['lon']
                return float(lat), float(lon)
    except Exception as e:
        logger.error(f"Geocoding error for {query}: {e}")
        
    return None, None

def run():
    conn = get_db_connection()
    if not conn:
        logger.error("Database connection failed")
        return

    try:
        with conn.cursor() as cur:
            # Get stores without coordinates
            # Prioritize Shufersal stores (id 7290027600007 is chain_id)
            # We filter by stores that HAVE address (imported from Stores.xml)
            cur.execute("""
                SELECT id, name, name_he, address, city 
                FROM stores 
                WHERE latitude IS NULL AND address IS NOT NULL AND city IS NOT NULL
                ORDER BY id DESC
            """)
            stores = cur.fetchall()
            
            logger.info(f"Found {len(stores)} stores needing geocoding")
            
            for store in stores:
                store_id, name, name_he, address, city = store
                
                # Skip if address is too short or invalid
                if not address or len(address) < 3:
                    continue
                    
                display_name = name_he or name
                
                logger.info(f"📍 Geocoding: {display_name} | {address}, {city}")
                
                lat, lon = geocode_store(address, city)
                
                if lat and lon:
                    logger.info(f"   ✅ Found: {lat}, {lon}")
                    cur.execute("""
                        UPDATE stores 
                        SET latitude = %s, longitude = %s, updated_at = NOW()
                        WHERE id = %s
                    """, (lat, lon, store_id))
                    conn.commit()
                else:
                    logger.warning(f"   ❌ Not found")
                
                # Respect OpenStreetMap rate limits (1 req/sec)
                time.sleep(1.1)
                
    except Exception as e:
        logger.error(f"Script error: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    run()
