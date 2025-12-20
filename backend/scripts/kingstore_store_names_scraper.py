#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
KingStore Store Names Scraper
Downloads the store names table from KingStore website
"""
import sys
import re
import requests
from bs4 import BeautifulSoup
import psycopg2
from psycopg2.extras import RealDictCursor

sys.stdout.reconfigure(encoding='utf-8')

DB_CONFIG = {
    'dbname': 'gogobe',
    'user': 'postgres',
    'password': '9152245-Gl!',
    'host': 'localhost',
    'port': '5432'
}

KINGSTORE_URL = "https://kingstore.binaprojects.com/Main.aspx"


def scrape_store_names():
    """
    Scrape store names from KingStore website
    """
    print("\n" + "="*70)
    print("🏪 Scraping Store Names from KingStore")
    print("="*70)
    
    try:
        # Download the page
        print(f"\n[INFO] Downloading from {KINGSTORE_URL}...")
        response = requests.get(KINGSTORE_URL, timeout=30)
        response.raise_for_status()
        
        # Parse HTML
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Find the stores dropdown/select
        # The page has a select element with store options
        stores_data = []
        
        # Look for select element with id or name containing "store" or "מחסן"
        selects = soup.find_all('select')
        
        for select in selects:
            options = select.find_all('option')
            if len(options) > 5:  # Likely the stores dropdown
                print(f"\n[INFO] Found {len(options)} options in dropdown")
                
                for option in options:
                    value = option.get('value', '').strip()
                    text = option.get_text().strip()
                    
                    if value and value.isdigit() and text and text not in ['הכל', 'All', 'בחר', 'Select']:
                        # Extract store code and name
                        # Format might be: "13 - חנות רמת השרון"
                        match = re.match(r'(\d+)\s*[-–]\s*(.+)', text)
                        if match:
                            store_code = match.group(1)
                            store_name = match.group(2).strip()
                        else:
                            store_code = value
                            store_name = text
                        
                        stores_data.append({
                            'store_code': store_code,
                            'store_name': store_name,
                            'full_text': text
                        })
                        print(f"  [{store_code}] {store_name}")
        
        if not stores_data:
            print("\n[WARN] No stores found in dropdown. Trying alternative methods...")
            # Try to find in JavaScript or other elements
            scripts = soup.find_all('script')
            for script in scripts:
                if script.string and ('store' in script.string.lower() or 'מחסן' in script.string):
                    # Try to extract store data from JavaScript
                    # This is a fallback method
                    pass
        
        print(f"\n[INFO] Found {len(stores_data)} stores")
        
        return stores_data
    
    except requests.RequestException as e:
        print(f"[ERROR] Failed to download page: {e}")
        return []
    except Exception as e:
        print(f"[ERROR] Failed to parse page: {e}")
        import traceback
        traceback.print_exc()
        return []


def update_store_names_in_db(stores_data):
    """
    Update store names in database
    """
    if not stores_data:
        print("[ERROR] No store data to update")
        return
    
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        print("\n" + "="*70)
        print("💾 Updating Store Names in Database")
        print("="*70 + "\n")
        
        # Get KingStore chain
        cur.execute("""
            SELECT sc.id as chain_id
            FROM store_chains sc
            JOIN price_sources ps ON sc.price_source_id = ps.id
            WHERE ps.name = 'KingStore'
            LIMIT 1
        """)
        
        chain = cur.fetchone()
        if not chain:
            print("[ERROR] KingStore chain not found in database")
            return
        
        chain_id = chain['chain_id']
        
        updated_count = 0
        created_count = 0
        
        for store in stores_data:
            store_code = store['store_code']
            store_name = store['store_name']
            
            # Check if store exists
            cur.execute("""
                SELECT id, store_name
                FROM stores
                WHERE chain_id = %s AND store_code = %s
            """, (chain_id, store_code))
            
            existing = cur.fetchone()
            
            if existing:
                # Update name if different
                if existing['store_name'] != store_name:
                    cur.execute("""
                        UPDATE stores
                        SET store_name = %s, updated_at = NOW()
                        WHERE id = %s
                    """, (store_name, existing['id']))
                    
                    print(f"✅ Updated: [{store_code}] {existing['store_name']} → {store_name}")
                    updated_count += 1
                else:
                    print(f"⏭️  Skipped: [{store_code}] {store_name} (already correct)")
            else:
                # Create new store
                cur.execute("""
                    INSERT INTO stores (store_name, store_code, chain_id, is_active)
                    VALUES (%s, %s, %s, TRUE)
                """, (store_name, store_code, chain_id))
                
                print(f"➕ Created: [{store_code}] {store_name}")
                created_count += 1
        
        conn.commit()
        
        print("\n" + "="*70)
        print(f"✅ Complete!")
        print(f"   Updated: {updated_count}")
        print(f"   Created: {created_count}")
        print(f"   Total:   {len(stores_data)}")
        print("="*70 + "\n")
        
    except Exception as e:
        conn.rollback()
        print(f"\n[ERROR] Database update failed: {e}")
        import traceback
        traceback.print_exc()
    finally:
        conn.close()


def main():
    """Main function"""
    # Step 1: Scrape store names
    stores_data = scrape_store_names()
    
    if not stores_data:
        print("\n[ERROR] No stores found. Cannot update database.")
        print("\n[INFO] Manual fallback: Please check the website structure")
        print(f"[INFO] URL: {KINGSTORE_URL}")
        return
    
    # Step 2: Update database
    update_store_names_in_db(stores_data)
    
    print("\n✅ Store names updated successfully!")
    print("   Now the frontend will show correct store names instead of numbers.")


if __name__ == '__main__':
    # Check if BeautifulSoup is installed
    try:
        import bs4
    except ImportError:
        print("[ERROR] BeautifulSoup4 is not installed!")
        print("Please install it: pip install beautifulsoup4")
        sys.exit(1)
    
    main()


