
import sys
import os
import logging
import time

# Add backend to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from scrapers.scraper_registry import get_registry

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("Verifier")

# Sources to validate
NEW_SOURCES = [
    'king_store',
    'maayan2000',
    'dor_alon', 
    'stop_market',
    'politzer', 
    'paz_yellow',
    'super_yuda',
    'keshet_taamim',
    'super_cofix',
    'fresh_market' # Control
]

def verify_source_deep(source_id):
    print(f"\n{'='*60}")
    print(f"VERIFYING: {source_id}")
    print(f"{'='*60}")
    
    registry = get_registry()
    scraper = registry.get(source_id)
    
    if not scraper:
        logger.error(f"[-] {source_id}: Not found or Disabled")
        return {'stores': False, 'prices': False, 'address_check': False}

    results = {'stores': False, 'prices': False, 'address_check': False}

    # 1. Verify STORES
    try:
        print(f"[*] {source_id}: Fetching STORES list...")
        store_files = scraper.fetch_file_list(file_type='stores', limit=1)
        
        if store_files:
            f = store_files[0]
            print(f"    Found store file: {f.filename}")
            
            # Download and Parse
            print(f"    Downloading & Parsing...")
            # Note: get_stores implementation depends on base_supermarket_scraper.
            # It should handle download + parse.
            stores = scraper.get_stores(limit=5) 
            
            if stores:
                print(f"    [+] Parsed {len(stores)} stores.")
                # Check Address
                sample = stores[0]
                addr = getattr(sample, 'address', 'N/A') or getattr(sample, 'store_address', 'N/A')
                print(f"    Sample Store: {sample.store_id} - {sample.name} | Address: {addr}")
                results['stores'] = True
                if addr and len(str(addr)) > 3 and str(addr) != 'N/A':
                     results['address_check'] = True
            else:
                 print("    [-] Downloaded but parsed 0 stores.")
        else:
            print("    [-] No STORES list returned (might be empty dir or auth issue).")

    except Exception as e:
        logger.error(f"    [!] Error testing STORES: {e}")

    # 2. Verify PRICES
    try:
        print(f"[*] {source_id}: Fetching PRICES list...")
        # Try prices_full first, then prices
        price_files = scraper.fetch_file_list(file_type='prices_full', limit=1)
        if not price_files:
             print("    No price_full, trying partial prices...")
             price_files = scraper.fetch_file_list(file_type='prices', limit=1)

        if price_files:
            f = price_files[0]
            print(f"    Found price file: {f.filename}")
            results['prices'] = True 
            print("    [+] Price file reference verified (Skipping full download)")
        else:
            print("    [-] No PRICES files found.")
            
    except Exception as e:
        logger.error(f"    [!] Error testing PRICES: {e}")

    return results

if __name__ == "__main__":
    summary = {}
    for source in NEW_SOURCES:
        summary[source] = verify_source_deep(source)
        time.sleep(2) # Polite delay between chains

    print("\n\n" + "="*80)
    print(f"{'SOURCE':<20} | {'STATUS':<10} | {'STORES':<8} | {'PRICES':<8} | {'ADDRESS'}")
    print("="*80)
    for source, res in summary.items():
        status = "PASS" if (res['stores'] and res['prices']) else "PARTIAL" if (res['stores'] or res['prices']) else "FAIL"
        addr_ok = "OK" if res['address_check'] else "--"
        print(f"{source:<20} | {status:<10} | {str(res['stores']):<8} | {str(res['prices']):<8} | {addr_ok}")
