#!/usr/bin/env python3
"""
Osher Ad Scraper
Uses the PublishedPrices generic scraper
"""

import sys
from pathlib import Path

# Add parent directory to path to allow importing modules
sys.path.append(str(Path(__file__).parent.parent))

from scrapers.published_prices_scraper import PublishedPricesScraper, logger

if __name__ == "__main__":
    
    logger.info("Starting Osher Ad Import...")
    
    # Initialize scraper for Osher Ad
    # Credentials: User=osherad, No password usually required or same as user
    scraper = PublishedPricesScraper(
        chain_name="Osher Ad",
        chain_slug="osher_ad",
        chain_name_he="אושר עד",
        chain_id="7290103152017",
        platform_user="osherad",  # Often the username on Cerberus platforms
        base_domain="url.publishedprices.co.il" 
    )
    
    try:
        # 1. Import Stores (to get locations)
        logger.info("="*80)
        logger.info("Step 1: Importing Stores files...")
        logger.info("="*80)
        stats_stores = scraper.import_files(file_type='stores', limit=3)
        logger.info(f"Stores import completed: {stats_stores}")
        
        # 2. Import Prices
        logger.info("\n" + "="*80)
        logger.info("Step 2: Importing Prices files...")
        logger.info("="*80)
        stats_prices = scraper.import_files(file_type='prices', limit=10)
        logger.info(f"Prices import completed: {stats_prices}")
        
    except Exception as e:
        logger.error(f"Osher Ad import failed: {e}")
    # finally:
        # scraper.close()
