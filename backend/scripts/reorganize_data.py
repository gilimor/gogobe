"""
ארגון מחדש של קבצי נתונים לפי מבנה היררכי

מארגן קבצים מ:
  backend/data/kingstore/Price7290058108879-001-202512180922.xml

ל:
  backend/data/supermarkets/kingstore/chain-7290058108879/stores/001/prices/2025-12-20-0922.xml
"""

from pathlib import Path
import re
from datetime import datetime
import shutil
from collections import defaultdict

class DataReorganizer:
    """Reorganize downloaded data files into logical structure"""
    
    def __init__(self, source_dir, target_base_dir, dry_run=True):
        self.source_dir = Path(source_dir)
        self.target_base_dir = Path(target_base_dir)
        self.dry_run = dry_run
        self.stats = defaultdict(int)
        
    def parse_kingstore_filename(self, filename):
        """
        Parse KingStore filename
        
        Format: Price7290058108879-001-202512180922.xml
        Returns: {
            'type': 'price' or 'promo',
            'chain_id': '7290058108879',
            'store_id': '001',
            'date': '2025-12-18',
            'time': '0922',
            'ext': 'xml' or 'gz'
        }
        """
        # Pattern: (Price|Promo)(CHAIN_ID)-(STORE_ID)-(DATETIME).(EXT)
        pattern = r'(Price|Promo)(\d+)-(\d+)-(\d{12})\.(xml|gz)$'
        match = re.match(pattern, filename)
        
        if not match:
            return None
            
        file_type, chain_id, store_id, datetime_str, ext = match.groups()
        
        # Parse datetime: 202512180922 = 2025-12-18 09:22
        year = datetime_str[:4]
        month = datetime_str[4:6]
        day = datetime_str[6:8]
        hour = datetime_str[8:10]
        minute = datetime_str[10:12]
        
        return {
            'type': file_type.lower(),
            'chain_id': chain_id,
            'store_id': store_id.zfill(3),  # Pad to 3 digits: 001
            'date': f"{year}-{month}-{day}",
            'time': f"{hour}{minute}",
            'ext': ext,
            'year_month': f"{year}-{month}"
        }
    
    def get_target_path(self, file_info):
        """
        Build target path from file info
        
        Returns: supermarkets/kingstore/chain-XXX/stores/001/prices/2025-12/2025-12-20-0922.xml
        """
        target_dir = (
            self.target_base_dir /
            "supermarkets" /
            "kingstore" /
            f"chain-{file_info['chain_id']}" /
            "stores" /
            file_info['store_id'] /
            f"{file_info['type']}s" /
            file_info['year_month']
        )
        
        filename = f"{file_info['date']}-{file_info['time']}.{file_info['ext']}"
        
        return target_dir / filename
    
    def reorganize_kingstore(self):
        """Reorganize all KingStore files"""
        print("=" * 70)
        print("ארגון מחדש של קבצי KingStore")
        print("=" * 70)
        print()
        
        if self.dry_run:
            print("⚠️  DRY RUN MODE - לא מבצע שינויים בפועל")
            print()
        
        # Get all XML and GZ files
        files = list(self.source_dir.glob("*.xml")) + list(self.source_dir.glob("*.gz"))
        
        print(f"מצאתי {len(files)} קבצים")
        print()
        
        for file_path in files:
            file_info = self.parse_kingstore_filename(file_path.name)
            
            if not file_info:
                print(f"⏭️  מדלג: {file_path.name} (לא תואם לפורמט)")
                self.stats['skipped'] += 1
                continue
            
            target_path = self.get_target_path(file_info)
            
            # Show what will happen
            print(f"📦 {file_path.name}")
            print(f"   → {target_path.relative_to(self.target_base_dir)}")
            
            if not self.dry_run:
                # Create directory
                target_path.parent.mkdir(parents=True, exist_ok=True)
                
                # Move file
                try:
                    shutil.move(str(file_path), str(target_path))
                    self.stats['moved'] += 1
                    
                    # Create/update 'latest' file
                    latest_path = target_path.parent.parent / f"latest.{file_info['ext']}"
                    if latest_path.exists():
                        latest_path.unlink()
                    shutil.copy(str(target_path), str(latest_path))
                    
                except Exception as e:
                    print(f"   ❌ שגיאה: {e}")
                    self.stats['errors'] += 1
            else:
                self.stats['would_move'] += 1
        
        # Print summary
        print()
        print("=" * 70)
        print("סיכום")
        print("=" * 70)
        
        if self.dry_run:
            print(f"יועברו: {self.stats['would_move']} קבצים")
            print(f"ידולגו: {self.stats['skipped']} קבצים")
        else:
            print(f"הועברו: {self.stats['moved']} קבצים")
            print(f"דולגו: {self.stats['skipped']} קבצים")
            print(f"שגיאות: {self.stats['errors']} קבצים")
        
        print()
    
    def create_metadata_files(self):
        """Create metadata files with store info"""
        print("יוצר קבצי metadata...")
        
        # Collect store info
        stores_data = {}
        
        for store_dir in (self.target_base_dir / "supermarkets" / "kingstore").glob("chain-*/stores/*"):
            if store_dir.is_dir():
                store_id = store_dir.name
                chain_dir = store_dir.parent.parent
                chain_id = chain_dir.name.replace("chain-", "")
                
                # Count files
                price_count = len(list(store_dir.glob("prices/**/*.xml")))
                promo_count = len(list(store_dir.glob("promos/**/*.xml")))
                
                stores_data[store_id] = {
                    'store_id': store_id,
                    'chain_id': chain_id,
                    'price_files': price_count,
                    'promo_files': promo_count
                }
        
        # Save metadata
        import json
        
        metadata_dir = self.target_base_dir / "supermarkets" / "kingstore" / "metadata"
        metadata_dir.mkdir(parents=True, exist_ok=True)
        
        with open(metadata_dir / "stores.json", 'w', encoding='utf-8') as f:
            json.dump(stores_data, f, indent=2, ensure_ascii=False)
        
        print(f"✅ נוצר: {metadata_dir / 'stores.json'}")
        print(f"   {len(stores_data)} חנויות")
        print()


def main():
    """Main function"""
    import sys
    
    # Configuration
    source_dir = "backend/data/kingstore"
    target_base_dir = "backend/data"
    
    # Check if dry run
    dry_run = "--execute" not in sys.argv
    
    print()
    print("=" * 70)
    print("סקריפט ארגון נתונים - KingStore")
    print("=" * 70)
    print()
    print(f"מקור: {source_dir}")
    print(f"יעד: {target_base_dir}/supermarkets/kingstore/")
    print()
    
    if dry_run:
        print("⚠️  מצב DRY RUN - לא יבוצעו שינויים")
        print("   להרצה בפועל: python reorganize_data.py --execute")
        print()
        input("לחץ Enter להמשיך...")
    else:
        print("🚨 מצב ביצוע - שינויים יבוצעו בפועל!")
        print()
        response = input("האם להמשיך? (yes/no): ")
        if response.lower() not in ['yes', 'y']:
            print("בוטל.")
            return
    
    # Create reorganizer
    reorganizer = DataReorganizer(source_dir, target_base_dir, dry_run=dry_run)
    
    # Reorganize
    reorganizer.reorganize_kingstore()
    
    # Create metadata
    if not dry_run:
        reorganizer.create_metadata_files()
    
    print()
    print("✅ הושלם!")
    print()


if __name__ == "__main__":
    main()


