#!/usr/bin/env python3
"""
Rami Levy Data Ingestion Script
Triggers the ingestion of Rami Levy prices using PublishedPricesScraper
"""

import sys
import os
from pathlib import Path
import argparse
import logging

# Add backend to path to import scrapers
backend_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if backend_path not in sys.path:
    sys.path.append(backend_path)

from scrapers.published_prices_scraper import PublishedPricesScraper


def main():
    parser = argparse.ArgumentParser(description='Import Rami Levy prices')
    parser.add_argument('--limit-files', type=int, default=1, help='Maximum number of files to process')
    parser.add_argument('--file-type', type=str, default='prices_full', help='Type of files to import')
    parser.add_argument('--download-dir', type=str, default='data/rami-levy', help='Directory to save downloaded files')
    
    args = parser.parse_args()
    
    # Configure logging
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    
    # Initialize scraper
    scraper = PublishedPricesScraper(
        chain_name="Rami Levy",
        chain_slug="rami-levy",
        chain_name_he="רמי לוי",
        chain_id="7290058140886",
        platform_user="RamiLevi"
    )
    
    try:
        # Run import
        stats = scraper.import_files(
            file_type=args.file_type,
            limit=args.limit_files,
            download_dir=Path(args.download_dir)
        )
        
        logger.info(f"Ingestion complete: {stats}")
        
    except Exception as e:
        logger.error(f"Ingestion failed: {e}")
        sys.exit(1)
    finally:
        scraper.close()

if __name__ == "__main__":
    main()
