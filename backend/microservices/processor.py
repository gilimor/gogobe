
"""
Microservice #3: PROCESSOR (The Ingestion Factory)
Responsibility: Parse files (XML/JSON), normalize data, and insert into DB.
Input: Local File Path
Output: DB Records + 'Data Ingested' event.
"""
import sys
import logging
from pathlib import Path

# Add parent directory to path
sys.path.append(str(Path(__file__).resolve().parents[2]))

from backend.scrapers.scraper_registry import SCRAPER_REGISTRY
from backend.scrapers.base_supermarket_scraper import BaseSupermarketScraper

logging.basicConfig(level=logging.INFO, format='%(asctime)s [PROCESSOR] %(message)s')
logger = logging.getLogger("Processor")

def run_processor(file_path_str, chain_name):
    file_path = Path(file_path_str)
    if not file_path.exists():
        logger.error(f"File not found: {file_path}")
        return

    logger.info(f"🏭 Processing Job: {file_path.name}")
    
    # Instantiate Scraper (to use its parsing logic)
    scraper_cls = SCRAPER_REGISTRY.get(chain_name)
    if not scraper_cls:
        logger.error(f"Unknown chain: {chain_name}")
        return

    scraper: BaseSupermarketScraper = scraper_cls()
    
    try:
        # 1. Decompress
        logger.info("Decompressing (if needed)...")
        final_path = scraper.decompress_file(file_path)
        
        # 2. Parse & Stream Import (Chunking)
        logger.info("Parsing & Streaming...")
        
        # We assume parse_file_stream yields items one by one (if available)
        # Or we handle the list in batches if it returns a list
        
        # Check if scraper has streaming capability
        if hasattr(scraper, 'parse_file_stream'):
            iterator = scraper.parse_file_stream(final_path)
        else:
            # Fallback for scrapers that only support full load
            # We still chunk the insertion part to save DB memory
            metadata, products_list = scraper.parse_file(final_path)
            # Create a generator from the list to unify logic
            iterator = ((metadata, p) for p in products_list)
            
        # Initialize Store (once per file usually)
        store_id = None
        
        batch_size = 1000
        batch = []
        stats = {'products': 0, 'prices': 0}
        
        for i, (meta_or_prod) in enumerate(iterator):
            # First item might be metadata (depending on implementation), or we extract it differently.
            # Adaptation: existing BaseScraper returns (metadata, list).
            # To truly stream, we'd need to refactor BaseScraper.
            # For now, we implement the "Insert Chunking" here.
            pass
            
        # RE-IMPL: Correct Logic for existing BaseScraper structure
        # Since refactoring all parsers is risky now, we optimize the INSERTION phase.
        
        metadata, products = scraper.parse_file(final_path)
        logger.info(f"Parsed {len(products)} products (Memory Loaded). Starting Chunked Insert...")
        
        # Store Setup
        store_data = scraper.get_store_from_metadata(metadata)
        store_id = scraper.get_or_create_store(store_data)
        
        # STREAMING INSERTS (The "Chunk" part)
        # Instead of one huge transaction, we break it down
        total = len(products)
        chunk_size = 2000 
        
        for i in range(0, total, chunk_size):
            chunk = products[i : i + chunk_size]
            
            # Flush chunk to DB
            for p in chunk:
                res = scraper.import_product(p, store_id)
                stats['products'] += res['products']
                stats['prices'] += res['prices']
                
            # Report Progress (Streaming Status)
            progress = (i + len(chunk)) / total * 100
            logger.info(f"   >> Stream Progress: {progress:.1f}% ({stats['prices']} prices)")
            
            # Optional: Emit Kafka event for 'Progress'
            
        logger.info(f"✅ Ingestion Complete: {stats}")
        
    except Exception as e:
        logger.error(f"Processing Failed: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: processor.py <filepath> <chain>")
        sys.exit(1)
        
    run_processor(sys.argv[1], sys.argv[2])
