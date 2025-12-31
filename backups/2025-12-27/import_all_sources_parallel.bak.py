#!/usr/bin/env python3
"""
Multi-Source Parallel Import
Import from all enabled scrapers in parallel
"""
import sys
import os
from pathlib import Path
from datetime import datetime
import multiprocessing
from concurrent.futures import ProcessPoolExecutor, as_completed
import logging

# Add path
current_dir = Path(__file__).parent
app_root = current_dir.parent
if str(app_root) not in sys.path:
    sys.path.insert(0, str(app_root))

logging.basicConfig(
    level=logging.INFO,
    format='[%(asctime)s] %(message)s',
    datefmt='%H:%M:%S'
)
logger = logging.getLogger(__name__)


def import_single_source(source_info):
    """
    Import from a single source - runs in parallel
    Returns: (source_id, success, stats, error)
    """
    source_id, worker_id = source_info
    
    try:
        logger.info(f"[Worker {worker_id}] Starting {source_id}...")
        
        # Import in worker process
        from scrapers.scraper_registry import get_registry
        
        registry = get_registry()
        scraper = registry.get(source_id)
        
        if not scraper:
            return (source_id, False, {}, f"Scraper not available")
        
        # Run import based on scraper type
        if hasattr(scraper, 'run_full_import'):
            result = scraper.run_full_import(limit=100)  # Limit for safety
            
            if result and result.get('success'):
                stats = {
                    'products': result.get('products_count', 0),
                    'prices': result.get('prices_count', 0)
                }
                logger.info(f"[Worker {worker_id}] ✅ {source_id}: {stats}")
                return (source_id, True, stats, None)
            else:
                error = result.get('error', 'Unknown error')
                return (source_id, False, {}, error)
                
        elif hasattr(scraper, 'scrape_latest'):
            products = scraper.scrape_latest(max_files=10)
            count = len(products) if products else 0
            stats = {'products': count, 'prices': 0}
            logger.info(f"[Worker {worker_id}] ✅ {source_id}: {count} products")
            return (source_id, True, stats, None)
            
        else:
            return (source_id, False, {}, "Scraper doesn't support import")
            
    except Exception as e:
        logger.error(f"[Worker {worker_id}] ❌ {source_id}: {e}")
        return (source_id, False, {}, str(e))


def main():
    """Main parallel import orchestrator"""
    logger.info("=" * 80)
    logger.info("Multi-Source Parallel Import")
    logger.info("=" * 80)
    
    # Import registry
    try:
        from scrapers.scraper_registry import get_registry
    except ImportError:
        sys.path.insert(0, str(Path(__file__).parent.parent))
        from scrapers.scraper_registry import get_registry
    
    registry = get_registry()
    
    # Get all enabled sources
    status = registry.get_status()
    enabled_sources = [
        source_id for source_id, info in status.items()
        if info['enabled'] and info['available']
    ]
    
    if not enabled_sources:
        logger.error("No enabled sources found!")
        return
    
    logger.info(f"Enabled sources: {', '.join(enabled_sources)}")
    
    # Number of workers (one per source, max CPUs)
    num_workers = min(len(enabled_sources), multiprocessing.cpu_count())
    logger.info(f"Using {num_workers} parallel workers")
    
    # Prepare source list with worker IDs
    source_list = [(source, i % num_workers) for i, source in enumerate(enabled_sources)]
    
    # Run parallel import
    total_stats = {
        'sources_processed': 0,
        'sources_failed': 0,
        'total_products': 0,
        'total_prices': 0
    }
    
    start_time = datetime.now()
    
    logger.info("\n🚀 Starting parallel import...")
    
    with ProcessPoolExecutor(max_workers=num_workers) as executor:
        # Submit all tasks
        future_to_source = {
            executor.submit(import_single_source, source_info): source_info[0]
            for source_info in source_list
        }
        
        # Process results
        completed = 0
        total = len(source_list)
        
        for future in as_completed(future_to_source):
            completed += 1
            source_id = future_to_source[future]
            
            try:
                result_id, success, stats, error = future.result(timeout=600)  # 10 min timeout
                
                if success:
                    total_stats['sources_processed'] += 1
                    total_stats['total_products'] += stats.get('products', 0)
                    total_stats['total_prices'] += stats.get('prices', 0)
                    logger.info(f"[{completed}/{total}] ✅ {result_id}")
                    
                    # Update last import time
                    registry.update_last_import(result_id, datetime.now())
                else:
                    total_stats['sources_failed'] += 1
                    logger.error(f"[{completed}/{total}] ❌ {result_id}: {error}")
                    
            except Exception as e:
                total_stats['sources_failed'] += 1
                logger.error(f"[{completed}/{total}] ❌ {source_id}: {e}")
    
    # Summary
    end_time = datetime.now()
    duration = (end_time - start_time).total_seconds()
    
    logger.info("\n" + "=" * 80)
    logger.info("IMPORT SUMMARY")
    logger.info("=" * 80)
    logger.info(f"Sources processed:  {total_stats['sources_processed']}")
    logger.info(f"Sources failed:     {total_stats['sources_failed']}")
    logger.info(f"Total products:     {total_stats['total_products']:,}")
    logger.info(f"Total prices:       {total_stats['total_prices']:,}")
    logger.info(f"Duration:           {duration:.1f} seconds ({duration/60:.1f} minutes)")
    
    if total_stats['total_prices'] > 0:
        logger.info(f"Speed:              {total_stats['total_prices']/duration:.1f} prices/second")
    
    logger.info("=" * 80)
    
    if total_stats['sources_failed'] == 0:
        logger.info("✅ All sources imported successfully!")
    else:
        logger.warning(f"⚠️  {total_stats['sources_failed']} sources had errors")


if __name__ == "__main__":
    main()
