#!/usr/bin/env python3
"""
Test import for Stop Market - small chain to verify fixes
"""
import sys
sys.path.insert(0, '/app')

from backend.scrapers.published_prices_scraper import PublishedPricesScraper
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Create scraper for Stop Market
scraper = PublishedPricesScraper(
    chain_name="Stop Market",
    chain_slug="stop_market",
    chain_name_he="סטופ מרקט",
    chain_id="7290639000004",
    platform_user="stopmarket"
)

logger.info("=" * 80)
logger.info("Testing Stop Market Import")
logger.info("=" * 80)

# Step 1: Import stores
logger.info("\nSTEP 1: Importing Stores")
logger.info("-" * 80)
stores_stats = scraper.import_files(file_type='stores', limit=1, download_dir=None)
logger.info(f"Stores result: {stores_stats}")

# Step 2: Import prices
logger.info("\nSTEP 2: Importing Prices")
logger.info("-" * 80)
prices_stats = scraper.import_files(file_type='prices', limit=1, download_dir=None)
logger.info(f"Prices result: {prices_stats}")

scraper.close()

logger.info("=" * 80)
logger.info("Import completed - check database for results")
logger.info("=" * 80)
