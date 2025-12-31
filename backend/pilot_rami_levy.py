#!/usr/bin/env python3
"""
Pilot Import: Rami Levy
Verifies the PublishedPricesScraper by importing a small batch of data.
"""

from scrapers.published_prices_scraper import PublishedPricesScraper
from pathlib import Path
import os
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

def run_pilot():
    # Setup scraper for Rami Levy
    scraper = PublishedPricesScraper(
        chain_name="Rami Levy",
        chain_slug="rami-levy",
        chain_name_he="רמי לוי",
        chain_id="7290058140886",
        platform_user="RamiLevi"
    )
    
    # Create download directory
    download_dir = Path("data/rami_levy")
    download_dir.mkdir(parents=True, exist_ok=True)
    
    print("Starting Rami Levy Pilot Import...")
    
    # 1. Import Stores
    print("\nStep 1: Fetching Stores...")
    stores_files = scraper.fetch_file_list(file_type='stores', limit=1)
    if stores_files:
        store_file_path = scraper.download_file(stores_files[0], download_dir)
        # Note: BaseSupermarketScraper handles stores in parse_file normally, 
        # but let's just use the prices flow which creates stores on the fly
        print(f"Found stores file: {stores_files[0].filename}")
    
    # 2. Import Prices (Pilot: 2 files)
    print("\nStep 2: Fetching Prices (Full)...")
    price_files = scraper.fetch_file_list(file_type='prices_full', limit=2)
    
    if not price_files:
        print("No price files found!")
        return
        
    for file_meta in price_files:
        print(f"\nProcessing {file_meta.filename}...")
        try:
            # Download and import
            file_path = scraper.download_file(file_meta, download_dir)
            
            # Decompress (inherited from base)
            decompressed_path = scraper.decompress_file(file_path)
            
            # Import (inherited from base)
            # We'll override the parse_file in the instance if needed, 
            # but PublishedPricesScraper already implements it.
            stats = scraper.import_files(
                file_type='prices_full',
                limit=1, # We iterate manually here
                download_dir=download_dir
            )
            print(f"Import stats: {stats}")
            
        except Exception as e:
            print(f"Error processing {file_meta.filename}: {e}")

    scraper.close()
    print("\nPulse Import Complete!")

if __name__ == "__main__":
    run_pilot()
