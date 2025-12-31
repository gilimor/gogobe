#!/usr/bin/env python3
"""Reset prices without store_id and mark files for reimport"""

import sys
sys.path.insert(0, 'backend/database')
from db_connection import get_db_connection

def main():
    conn = get_db_connection()
    cur = conn.cursor()
    
    print("=" * 70)
    print("RESET AND REIMPORT PRICES WITH STORE TRACKING")
    print("=" * 70)
    
    try:
        # Count existing prices without store_id
        cur.execute("""
            SELECT COUNT(*) FROM prices WHERE store_id IS NULL
        """)
        prices_without_store = cur.fetchone()[0]
        print(f"\n📊 Prices without store_id: {prices_without_store}")
        
        # Delete prices without store_id
        if prices_without_store > 0:
            print(f"\n🗑️  Deleting {prices_without_store} prices without store_id...")
            cur.execute("""
                DELETE FROM prices WHERE store_id IS NULL
            """)
            print("   ✅ Prices deleted")
        
        # Reset all files to pending status
        cur.execute("""
            UPDATE downloaded_files 
            SET processing_status = 'pending'
            WHERE processing_status = 'completed'
        """)
        files_reset = cur.rowcount
        print(f"\n📝 Reset {files_reset} files to pending status")
        
        conn.commit()
        
        print("\n" + "=" * 70)
        print("✅ SUCCESS - Ready to reimport with store tracking")
        print("=" * 70)
        print("\n💡 Now run: ⚙️ PROCESS_DOWNLOADED_FILES.bat")
        
    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        conn.rollback()
        return 1
    finally:
        cur.close()
        conn.close()
    
    return 0

if __name__ == "__main__":
    sys.exit(main())








