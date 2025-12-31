#!/usr/bin/env python3
"""
Geocode Stores Script
Uses various geocoding services (Nominatim, Google Maps, etc.)
to populate latitude/longitude for stores that are missing them.
"""

import os
import time
import requests
import psycopg2
import logging
import json
from datetime import datetime
from typing import Dict, Optional, Tuple

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class StoreGeocoder:
    def __init__(self):
        self.conn = psycopg2.connect(
            dbname=os.getenv('DB_NAME', 'gogobe'),
            user=os.getenv('DB_USER', 'postgres'),
            password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
            host=os.getenv('DB_HOST', 'localhost'),
            port=os.getenv('DB_PORT', '5432')
        )
        self.user_agent = "GogobePriceComparator/1.0"
        
    def get_stores_without_coords(self):
        """Fetch stores that are missing coordinates"""
        cur = self.conn.cursor()
        cur.execute("""
            SELECT s.id, s.name, s.city, s.address, c.name as chain_name
            FROM stores s
            JOIN chains c ON s.chain_id = c.id
            WHERE (s.latitude IS NULL OR s.longitude IS NULL)
               OR (s.city IS NULL OR s.city = '')
               OR (s.name LIKE '%סניף%' AND s.name NOT LIKE '% - %')
            AND s.is_active = TRUE
            ORDER BY s.id
            LIMIT 50 -- Limit batch size for safety/speed in this run
        """)
        return cur.fetchall()

    def geocode_address(self, address: str, city: str = "") -> Optional[Tuple[float, float, str, str]]:
        """
        Geocode and return (lat, lon, city, full_address)
        """
        try:
            # Clean address
            clean_address = address.replace('"', '').strip()
            if not clean_address:
                return None
                
            # Construct query
            query = f"{clean_address}"
            if city and city not in clean_address:
                query += f", {city}"
            query += ", Israel"
            
            url = "https://nominatim.openstreetmap.org/search"
            params = {
                'q': query,
                'format': 'json',
                'addressdetails': 1,
                'limit': 1,
                'accept-language': 'he,en'
            }
            headers = {'User-Agent': self.user_agent}
            
            response = requests.get(url, params=params, headers=headers, timeout=10)
            
            if response.status_code == 200:
                data = response.json()
                if data:
                    item = data[0]
                    lat = float(item['lat'])
                    lon = float(item['lon'])
                    
                    # Extract City
                    addr = item.get('address', {})
                    found_city = addr.get('city') or addr.get('town') or addr.get('village') or addr.get('county') or ''
                    
                    display_name = item.get('display_name', '')
                    
                    return (lat, lon, found_city, display_name)
            return None
            
        except Exception as e:
            logger.error(f"Geocoding error: {e}")
            return None

    def update_store_data(self, store_id: int, lat: float, lon: float, city: str, address: str, name: str):
        """Update store coordinates and metadata"""
        cur = self.conn.cursor()
        try:
            cur.execute("""
                UPDATE stores 
                SET latitude = %s, 
                    longitude = %s, 
                    city = COALESCE(NULLIF(city, ''), %s),
                    address = COALESCE(NULLIF(address, ''), %s),
                    name = %s,
                    updated_at = NOW()
                WHERE id = %s
            """, (lat, lon, city, address, name, store_id))
            self.conn.commit()
            logger.info(f"✓ Updated store {store_id}")
        except Exception as e:
            logger.error(f"Update failed: {e}")
            self.conn.rollback()

    def run(self):
        stores = self.get_stores_without_coords()
        logger.info(f"Found {len(stores)} stores needing geocoding")
        
        success_count = 0
        
        for store in stores:
            store_id, name, city, address, chain_name = store
            
            # Skip check removed to allow fallback to name-based geocoding
            # if not address and not city:
            #     logger.warning(f"Skipping store {store_id} ({name}) - No address info")
            #     continue
                
            # Try to geocode
            result = self.geocode_address(address or name, city)
            
            if result:
                lat, lon, new_city, new_addr = result
                
                # Logic to rename generic stores
                new_name = name
                if new_city and ("סניף" in name or "Branch" in name) and new_city not in name:
                     new_name = f"{name} - {new_city}"
                     logger.info(f"✨ Renaming: '{name}' -> '{new_name}'")

                self.update_store_data(store_id, lat, lon, new_city, new_addr, new_name)
                success_count += 1
            else:
                logger.warning(f"Could not geocode: {name}, {address}, {city}")
            
            # Respect rate limits for free API
            time.sleep(1.5)
            
        logger.info(f"Done! Updated {success_count}/{len(stores)} stores")
        self.conn.close()

if __name__ == "__main__":
    geocoder = StoreGeocoder()
    geocoder.run()
