#!/usr/bin/env python3
"""
Test import to catch the error
"""
import sys
sys.path.insert(0, '/app/backend')

try:
    from scrapers.shufersal_scraper import ShufersalScraper
    from datetime import datetime

    print("Starting test import of 5 files...")
    
    scraper = ShufersalScraper()
    stats = scraper.import_files(limit=5)
    
    print(f"\n✅ SUCCESS!")
    print(f"Files: {stats['files']}")
    print(f"Products: {stats['products']}")
    print(f"Prices: {stats['prices']}")
    print(f"Errors: {stats['errors']}")
    
except Exception as e:
    print(f"\n❌ ERROR: {type(e).__name__}")
    print(f"Message: {str(e)}")
    
    import traceback
    print("\nFull traceback:")
    traceback.print_exc()
    
    sys.exit(1)
