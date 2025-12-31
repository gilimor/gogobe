#!/usr/bin/env python3
"""
UNIVERSAL PARALLEL IMPORTER
Works with ANY supermarket chain scraper
Configuration-based, scalable, high-performance

Usage:
  python import_universal.py --chains shufersal,rami_levy --workers 8
  python import_universal.py --all --workers 16
"""
import sys
sys.path.insert(0, '/app/backend')

import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime
import psycopg2
import threading
from typing import List, Dict

# Import all available scrapers
from scrapers.shufersal_scraper import ShufersalScraper
from scrapers.superpharm_scraper import SuperPharmScraper
try:
    from scrapers.rami_levy_scraper import RamiLevyScraper
    HAS_RAMI_LEVY = True
except:
    HAS_RAMI_LEVY = False
# Add more as needed...

# Scraper registry - AUTO-REGISTER all scrapers
AVAILABLE_SCRAPERS = {
    'shufersal': ShufersalScraper,
    'superpharm': SuperPharmScraper,
}

if HAS_RAMI_LEVY:
    AVAILABLE_SCRAPERS['rami_levy'] = RamiLevyScraper

class UniversalImporter:
    """
    Universal parallel importer for all supermarket chains
    """
    
    def __init__(self, num_workers=8):
        self.num_workers = num_workers
        self.stats_lock = threading.Lock()
        self.global_stats = {
            'files': 0,
            'products': 0,
            'prices': 0,
            'errors': 0
        }
        
    def get_db_stats(self):
        """Get current database stats"""
        conn = psycopg2.connect(
            dbname='gogobe',
            user='postgres',
            password='9152245-Gl!',
            host='gogobe-db-1'
        )
        cur = conn.cursor()
        
        cur.execute("SELECT COUNT(*) FROM products")
        products = cur.fetchone()[0]
        
        cur.execute("SELECT COUNT(*) FROM prices")
        prices = cur.fetchone()[0]
        
        cur.execute("SELECT COUNT(*) FROM stores")
        stores = cur.fetchone()[0]
        
        conn.close()
        return {'products': products, 'prices': prices, 'stores': stores}
    
    def process_file_worker(self, scraper_class, file_metadata):
        """Worker function - processes single file using any scraper"""
        try:
            # Create scraper instance for this worker
            scraper = scraper_class()
            
            # Parse file
            filepath = scraper.download_dir + '/' + file_metadata.filename
            products = scraper.parse_file(filepath)
            
            if not products:
                return {'success': False, 'count': 0}
            
            # Get/create store
            store_id = scraper.get_or_create_store(file_metadata.store_code)
            
            # Import products
            for product in products:
                scraper.import_product(product, store_id)
            
            # Flush batch
            scraper._flush_price_batch()
            
            # Update global stats
            with self.stats_lock:
                self.global_stats['files'] += 1
                self.global_stats['products'] += len(products)
                self.global_stats['prices'] += len(products)
            
            return {'success': True, 'count': len(products)}
            
        except Exception as e:
            with self.stats_lock:
                self.global_stats['errors'] += 1
            return {'success': False, 'error': str(e)}
    
    def import_chain(self, chain_name: str, scraper_class):
        """Import all files from a single chain"""
        print(f"\n{'='*80}")
        print(f"📦 {chain_name.upper()}")
        print(f"{'='*80}")
        
        # Initialize scraper to get file list
        scraper = scraper_class()
        
        print(f"📡 Fetching {chain_name} files...")
        all_files = scraper.fetch_file_list(limit=None)
        total_files = len(all_files)
        
        print(f"✓ {total_files} files found")
        print(f"✓ Processing with {self.num_workers} parallel workers")
        print()
        
        chain_start = datetime.now()
        chain_stats = {'files': 0, 'prices': 0}
        
        # Process files in parallel
        with ThreadPoolExecutor(max_workers=self.num_workers) as executor:
            futures = {executor.submit(self.process_file_worker, scraper_class, f): f 
                      for f in all_files}
            
            completed = 0
            for future in as_completed(futures):
                completed += 1
                result = future.result()
                
                if result['success']:
                    chain_stats['files'] += 1
                    chain_stats['prices'] += result['count']
                
                # Progress update
                if completed % 20 == 0:
                    elapsed = (datetime.now() - chain_start).total_seconds()
                    rate = chain_stats['prices'] / elapsed if elapsed > 0 else 0
                    print(f"  [{chain_name}] {completed}/{total_files} | "
                          f"{chain_stats['prices']:,} prices | "
                          f"{rate:.0f}/sec")
        
        chain_duration = (datetime.now() - chain_start).total_seconds()
        
        print()
        print(f"✅ {chain_name.upper()} complete:")
        print(f"   Files: {chain_stats['files']}/{total_files}")
        print(f"   Prices: {chain_stats['prices']:,}")
        print(f"   Duration: {chain_duration/60:.1f} min")
        if chain_duration > 0:
            print(f"   Speed: {chain_stats['prices']/chain_duration:.0f} prices/sec")
        
        return chain_stats
    
    def import_chains(self, chain_names: List[str]):
        """Import from multiple chains"""
        print("=" * 80)
        print(f"🚀 UNIVERSAL PARALLEL IMPORTER")
        print("=" * 80)
        print(f"Chains: {', '.join(chain_names)}")
        print(f"Workers: {self.num_workers} parallel per chain")
        print()
        
        # Get initial stats
        initial = self.get_db_stats()
        print(f"📊 DATABASE BEFORE:")
        print(f"   Products: {initial['products']:,}")
        print(f"   Prices:   {initial['prices']:,}")
        print(f"   Stores:   {initial['stores']}")
        
        overall_start = datetime.now()
        
        # Import each chain
        for chain_name in chain_names:
            if chain_name not in AVAILABLE_SCRAPERS:
                print(f"⚠️  Chain '{chain_name}' not found. Skipping.")
                continue
            
            scraper_class = AVAILABLE_SCRAPERS[chain_name]
            self.import_chain(chain_name, scraper_class)
        
        overall_duration = (datetime.now() - overall_start).total_seconds()
        final = self.get_db_stats()
        
        # Final summary
        print()
        print("=" * 80)
        print("🎉 ALL CHAINS IMPORT COMPLETE!")
        print("=" * 80)
        print()
        print(f"⏱️  Total Duration: {overall_duration/60:.1f} minutes")
        print()
        print(f"📊 DATABASE AFTER:")
        print(f"   Products: {initial['products']:,} → {final['products']:,} "
              f"(+{final['products']-initial['products']:,})")
        print(f"   Prices:   {initial['prices']:,} → {final['prices']:,} "
              f"(+{final['prices']-initial['prices']:,})")
        print(f"   Stores:   {initial['stores']} → {final['stores']} "
              f"(+{final['stores']-initial['stores']})")
        print()
        print(f"📈 GLOBAL STATS:")
        print(f"   Files: {self.global_stats['files']}")
        print(f"   Errors: {self.global_stats['errors']}")
        print()
        
        if overall_duration > 0:
            prices_added = final['prices'] - initial['prices']
            print(f"⚡⚡⚡ PERFORMANCE:")
            print(f"   {prices_added/overall_duration:.0f} prices/second")
            print(f"   {self.num_workers}x parallel workers")
            print(f"   {len(chain_names)} chain(s) imported")
        
        print()
        print("=" * 80)


def main():
    parser = argparse.ArgumentParser(description='Universal Parallel Importer')
    parser.add_argument('--chains', type=str, help='Comma-separated chain names (e.g., shufersal,rami_levy)')
    parser.add_argument('--all', action='store_true', help='Import all available chains')
    parser.add_argument('--workers', type=int, default=8, help='Number of parallel workers (default: 8)')
    
    args = parser.parse_args()
    
    # Determine which chains to import
    if args.all:
        chain_names = list(AVAILABLE_SCRAPERS.keys())
    elif args.chains:
        chain_names = [c.strip() for c in args.chains.split(',')]
    else:
        # Default: just shufersal
        chain_names = ['shufersal']
    
    # Create importer and run
    importer = UniversalImporter(num_workers=args.workers)
    importer.import_chains(chain_names)


if __name__ == '__main__':
    main()
