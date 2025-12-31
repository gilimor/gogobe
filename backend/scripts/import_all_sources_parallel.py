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
import argparse
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
    
    parser = argparse.ArgumentParser(description='Multi-Source Parallel Import')
    parser.add_argument('--workers', type=int, default=2, help='Number of parallel workers (default: 2)')
    args = parser.parse_args()

    # Import registry
    try:
        from scrapers.scraper_registry import get_registry
    except ImportError:
        sys.path.insert(0, str(Path(__file__).parent.parent))
        from scrapers.scraper_registry import get_registry
        
    registry = get_registry()
    status = registry.get_status()
    enabled_sources = [sid for sid, s in status.items() if s['enabled']]
    
    if not enabled_sources:
        logger.warning("No scrapers enabled!")
        return

    logger.info(f"Enabled sources: {', '.join(enabled_sources)}")
    
    run_scrapers(enabled_sources, registry, max_workers=args.workers)
    
def run_scrapers(enabled_sources, registry, max_workers=2):
    """
    Run scrapers in parallel with SMART RESOURCE GOVERNANCE.
    Returns: total_stats dictionary
    """
    logger.info("\n🚀 Starting Smart Orchestra for parallel import...")
    
    # Number of workers (one per source, max Limit)
    num_workers = min(len(enabled_sources), max_workers)
    logger.info(f"🛡️  Safety Limit: Max {max_workers} concurrent workers (Active: {num_workers}).")
    
    # Prepare source list with worker IDs
    source_list = [(source, i % num_workers) for i, source in enumerate(enabled_sources)]
    
    total_stats = {
        'sources_processed': 0,
        'sources_failed': 0,
        'total_products': 0,
        'total_prices': 0
    }
    
    start_time = datetime.now()
    
    logger.info("\n🚀 Starting parallel import...")
    
    logger.info(f"Target Concurrency: {num_workers} workers")
    
    # 2. Sequential Dispatch with Resource Check
    # We don't submit all at once because that loads the Pool queue. 
    # Instead, we want to hold back if CPU is high.
    # Note: Traditional ProcessPoolExecutor doesn't let us pause tasks easily once submitted.
    # So we simply limit the max_workers which is the most effective guard.
    # But we can also add a pre-check loop if we were managing threads manualy.
    
    # Since we use 'max_workers=num_workers', the OS scheduler handles it.
    # However, to meet user demand for "SMART GOVERNANCE", we will perform a pre-flight check.

    try:
        import psutil
        cpu = psutil.cpu_percent()
        if cpu > 90:
            logger.warning(f"⚠️ Initial CPU Load High ({cpu}%). Cooling down 5s...")
            import time
            time.sleep(5)
    except: pass
    
    with ProcessPoolExecutor(max_workers=num_workers) as executor:
        # Submit all tasks (The Pool will throttle automatically to num_workers)
        # We rely on the Pool's size (3-4) to protect the machine.
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
                result_id, success, stats, error = future.result(timeout=1200) # 20 min timeout per chain
                
                if success:
                    total_stats['sources_processed'] += 1
                    total_stats['total_products'] += stats.get('products', 0)
                    total_stats['total_prices'] += stats.get('prices', 0)
                    logger.info(f"[{completed}/{total}] ✅ {result_id}")
                    
                    try: registry.update_last_import(result_id, datetime.now())
                    except: pass
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
