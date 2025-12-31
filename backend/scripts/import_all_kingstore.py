"""
Simple KingStore Full Importer
Processes ALL KingStore XML files and then deduplicates
"""

import sys
import psycopg2
from psycopg2.extras import RealDictCursor
from pathlib import Path
from datetime import datetime

# Add parent to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from scripts.kingstore_xml_processor import KingStoreXMLProcessor

def main():
    print("=" * 80)
    print("🏪 KingStore - Full Import + Deduplication")
    print("=" * 80)
    
    # Data directory
    data_dir = Path(__file__).parent.parent / "data" / "kingstore"
    
    if not data_dir.exists():
        print(f"\n❌ Directory not found: {data_dir}")
        return
    
    # Count files
    xml_files = list(data_dir.glob("Price*.xml"))
    gz_files = list(data_dir.glob("Price*.gz"))
    
    total_files = len(xml_files) + len(gz_files)
    
    print(f"\nFound {total_files} files:")
    print(f"  • {len(xml_files)} XML files")
    print(f"  • {len(gz_files)} GZ files")
    
    if total_files == 0:
        print("\n❌ No files found!")
        return
    
    print("\n" + "=" * 80)
    print("This will:")
    print("  1. Process ALL XML files")
    print("  2. Import products and prices")
    print("  3. Create stores automatically")
    print("\nThis may take 10-15 minutes...")
    print("=" * 80)
    
    input("\nPress Enter to continue...")
    
    # Create processor
    processor = KingStoreXMLProcessor()
    
    # Process directory
    print("\n" + "=" * 80)
    print("STEP 1: Processing XML files")
    print("=" * 80)
    
    processor.process_directory(data_dir)
    
    print("\n" + "=" * 80)
    print("✅ Import Complete!")
    print("=" * 80)
    print("\nNext step: Run deduplication to merge products by barcode")
    print("Command: scripts\\database\\deduplicate-products.bat")
    print("\nOr check results: http://localhost:8000")

if __name__ == "__main__":
    main()




