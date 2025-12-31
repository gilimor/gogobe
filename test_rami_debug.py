#!/usr/bin/env python3
"""
Test Rami Levy import with DEBUG logging
"""
import sys
import os
sys.path.append('/app/backend')
sys.path.append('/app/backend/scrapers')

import logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

from published_prices_scraper import PublishedPricesScraper

# Import Rami Levy
scraper = PublishedPricesScraper(
    chain_name="Rami Levy",
    chain_slug="rami_levy",
    chain_name_he="רמי לוי",
    chain_id="7290058140886",
    platform_user="RamiLevi"
)

# Run import
print("Starting Rami Levy import with DEBUG logging...")
stats = scraper.import_files(file_type='prices', limit=1, download_dir=None)
print(f"Import completed: {stats}")
scraper.close()
