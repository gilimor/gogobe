#!/usr/bin/env python3
"""
Universal Supermarket Import Script
Import data from any supported supermarket chain
"""

import sys
import argparse
from pathlib import Path

# Add scrapers directory to path
sys.path.insert(0, str(Path(__file__).parent.parent / 'scrapers'))

from shufersal_scraper import ShufersalScraper
# from kingstore_scraper import KingStoreScraper  # TODO: Refactor KingStore to use base class


SUPPORTED_CHAINS = {
    'shufersal': ShufersalScraper,
    # 'kingstore': KingStoreScraper,  # TODO: Add after refactoring
}


def main():
    parser = argparse.ArgumentParser(
        description='Import price data from supermarket chains',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Import Shufersal stores
  python import_supermarket.py --chain shufersal --type stores --file /data/Stores*.xml
  
  # Import Shufersal prices (10 files)
  python import_supermarket.py --chain shufersal --type prices_full --dir /data/shufersal --limit 10
  
  # Import single file
  python import_supermarket.py --chain shufersal --file /data/PriceFull*.xml
        """
    )
    
    parser.add_argument(
        '--chain',
        required=True,
        choices=SUPPORTED_CHAINS.keys(),
        help='Supermarket chain to import from'
    )
    
    parser.add_argument(
        '--type',
        default='prices_full',
        choices=['stores', 'prices_full', 'prices', 'promos_full', 'promos'],
        help='Type of data to import (default: prices_full)'
    )
    
    parser.add_argument(
        '--file',
        type=Path,
        help='Import a single file'
    )
    
    parser.add_argument(
        '--dir',
        type=Path,
        help='Directory containing files to import'
    )
    
    parser.add_argument(
        '--limit',
        type=int,
        help='Maximum number of files to process'
    )
    
    parser.add_argument(
        '--verbose',
        action='store_true',
        help='Enable verbose logging'
    )
    
    args = parser.parse_args()
    
    # Create scraper instance
    scraper_class = SUPPORTED_CHAINS[args.chain]
    scraper = scraper_class()
    
    try:
        if args.file:
            # Import single file
            print(f"Importing single file: {args.file}")
            
            if args.type == 'stores' or 'Store' in args.file.name:
                # Import stores
                scraper.import_stores(args.file)
            else:
                # Import prices
                # Decompress if needed
                if args.file.suffix in ['.gz', '.bz2', '.zip']:
                    args.file = scraper.decompress_file(args.file)
                
                metadata, products = scraper.parse_file(args.file)
                
                # Get store ID
                store_id = None
                if metadata.get('store_id'):
                    from base_supermarket_scraper import ParsedStore
                    store_data = ParsedStore(
                        store_id=metadata['store_id'],
                        name=metadata.get('store_name', f"{scraper.chain_name} - Store {metadata['store_id']}"),
                        city=metadata.get('city'),
                        address=metadata.get('address'),
                        bikoret_no=metadata.get('bikoret_no')
                    )
                    scraper.ensure_chain_exists()
                    store_id = scraper.get_or_create_store(store_data)
                
                # Import products
                total_stats = {'products': 0, 'prices': 0, 'skipped': 0}
                for product in products:
                    stats = scraper.import_product(product, store_id)
                    total_stats['products'] += stats['products']
                    total_stats['prices'] += stats['prices']
                    total_stats['skipped'] += stats['skipped']
                
                print(f"\n✓ Imported: {total_stats['products']} products, {total_stats['prices']} prices")
        
        elif args.dir:
            # Import from directory
            print(f"Importing from directory: {args.dir}")
            
            # Find files matching pattern
            if args.type == 'stores':
                pattern = "Store*.xml"
            elif args.type == 'prices_full':
                pattern = "PriceFull*.xml"
            elif args.type == 'prices':
                pattern = "Price*.xml"
            elif args.type == 'promos_full':
                pattern = "PromoFull*.xml"
            elif args.type == 'promos':
                pattern = "Promo*.xml"
            
            files = sorted(args.dir.glob(pattern))
            
            if args.limit:
                files = files[:args.limit]
            
            print(f"Found {len(files)} files")
            
            if not files:
                print("No files found!")
                return
            
            # Process each file
            for i, file_path in enumerate(files):
                print(f"\n[{i+1}/{len(files)}] Processing: {file_path.name}")
                
                try:
                    # Decompress if needed
                    if file_path.suffix in ['.gz', '.bz2', '.zip']:
                        file_path = scraper.decompress_file(file_path)
                    
                    if args.type == 'stores':
                        scraper.import_stores(file_path)
                    else:
                        metadata, products = scraper.parse_file(file_path)
                        
                        # Get store ID
                        store_id = None
                        if metadata.get('store_id'):
                            from base_supermarket_scraper import ParsedStore
                            store_data = ParsedStore(
                                store_id=metadata['store_id'],
                                name=metadata.get('store_name'),
                                city=metadata.get('city'),
                                address=metadata.get('address'),
                                bikoret_no=metadata.get('bikoret_no')
                            )
                            scraper.ensure_chain_exists()
                            store_id = scraper.get_or_create_store(store_data)
                        
                        # Import products
                        for product in products:
                            scraper.import_product(product, store_id)
                        
                        print(f"  ✓ Imported {len(products)} products")
                
                except Exception as e:
                    print(f"  ✗ Error: {e}")
                    continue
        
        else:
            print("Error: Must specify either --file or --dir")
            parser.print_help()
            return
    
    finally:
        scraper.close()


if __name__ == "__main__":
    main()
