#!/usr/bin/env python3
"""
Quick import script for Rami Levy - Stores first, then Prices
"""
import sys
sys.path.insert(0, '/app')

from backend.scrapers.published_prices_scraper import PublishedPricesScraper
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Create scraper
scraper = PublishedPricesScraper(
    chain_name="Rami Levy",
    chain_slug="rami_levy",
    chain_name_he="רמי לוי",
    chain_id="7290058140886",
    platform_user="RamiLevi"
)

# Step 1: Import stores
logger.info("=" * 80)
logger.info("STEP 1: Importing Stores")
logger.info("=" * 80)
stores_stats = scraper.import_files(file_type='stores', limit=1, download_dir=None)
logger.info(f"Stores import: {stores_stats}")

# Step 2: Import prices
logger.info("=" * 80)
logger.info("STEP 2: Importing Prices")
logger.info("=" * 80)
prices_stats = scraper.import_files(file_type='prices', limit=1, download_dir=None)
logger.info(f"Prices import: {prices_stats}")

scraper.close()

logger.info("=" * 80)
logger.info("COMPLETE!")
logger.info("=" * 80)
