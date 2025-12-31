#!/usr/bin/env python3
"""
Import multiple chains from Published Prices platform
"""

import os
import sys

# Add backend to path
sys.path.append(os.path.join(os.getcwd(), 'backend'))

try:
    from backend.scrapers.published_prices_scraper import PublishedPricesScraper
except ImportError:
    sys.path.append(os.path.join(os.getcwd(), 'backend', 'scrapers'))
    from published_prices_scraper import PublishedPricesScraper

import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger("PublishedPricesRunner")

# List of chains available on Published Prices platform
CHAINS = [
    # (Name, Hebrew Name, Slug, Chain ID, Platform User, Platform Pass)
    ("Rami Levy", "רמי לוי", "rami_levy", "7290058140886", "RamiLevi", ""),
    ("Osher Ad", "אושר עד", "osher_ad", "7290103152017", "osherad", ""),
    ("Yohananof", "יוחננוף", "yohananof", "7290803800003", "yohananof", ""),
    ("Tiv Taam", "טיב טעם", "tiv_taam", "7290873255550", "TivTaam", ""),
    ("Keshet Taamim", "קשת טעמים", "keshet_taamim", "7290785400000", "Keshet", ""),
    ("Mahsanei Hashuk", "מחסני השוק", "mahsanei_hashuk", "7290661400001", "MahsaneyHashuk", ""),
    ("Stop Market", "סטופ מרקט", "stop_market", "7290639000004", "stopmarket", ""),
    ("Fresh Market", "פרש מרקט", "fresh_market", "7290876100000", "freshmarket", ""),
]

def run_chain(name, name_he, slug, chain_id, user, password):
    """Run import for a single chain"""
    logger.info(f"\n{'='*80}")
    logger.info(f"Starting import for {name} ({name_he})")
    logger.info(f"{'='*80}")
    
    try:
        scraper = PublishedPricesScraper(
            chain_name=name,
            chain_slug=slug,
            chain_name_he=name_he,
            chain_id=chain_id,
            platform_user=user,
            platform_pass=password
        )
        
        # Import 1 file for each chain (quick test)
        stats = scraper.import_files(file_type='prices', limit=1, download_dir=None)
        
        scraper.close()
        logger.info(f"✓ Finished {name}: {stats}")
        return True
        
    except Exception as e:
        logger.error(f"✗ Failed {name}: {e}")
        return False

def main():
    """Run imports for all chains"""
    success_count = 0
    failed_chains = []
    
    for name, name_he, slug, chain_id, user, password in CHAINS:
        if run_chain(name, name_he, slug, chain_id, user, password):
            success_count += 1
        else:
            failed_chains.append(name)
    
    logger.info(f"\n{'='*80}")
    logger.info(f"FINAL SUMMARY")
    logger.info(f"{'='*80}")
    logger.info(f"Successful: {success_count}/{len(CHAINS)}")
    
    if failed_chains:
        logger.info(f"Failed chains: {', '.join(failed_chains)}")
    
    logger.info(f"{'='*80}\n")

if __name__ == "__main__":
    main()
