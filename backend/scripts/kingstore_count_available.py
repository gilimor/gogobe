"""
Quick script to count available files on KingStore without downloading
"""

import sys
from pathlib import Path
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

def count_kingstore_files():
    """Count how many files are available on KingStore"""
    print("=" * 60)
    print("     🔍 KingStore File Counter")
    print("=" * 60)
    print()
    
    # Setup Chrome
    chrome_options = Options()
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--log-level=3")
    
    driver = webdriver.Chrome(options=chrome_options)
    
    try:
        print("[INFO] Connecting to KingStore...")
        driver.get("https://kingstore.binaprojects.com/Main.aspx")
        time.sleep(3)
        
        # Wait for page load
        WebDriverWait(driver, 15).until(
            EC.presence_of_element_located((By.TAG_NAME, "body"))
        )
        
        # Find all download buttons
        buttons = driver.find_elements(By.XPATH, "//a | //button | //input[@type='button']")
        
        download_buttons = []
        chains = {}
        
        print("[INFO] Analyzing page content...")
        print()
        
        for button in buttons:
            try:
                text = button.text or button.get_attribute('value') or ''
                
                if 'להורדה' in text or 'download' in text.lower():
                    parent = button.find_element(By.XPATH, "./..")
                    context = parent.text
                    
                    download_buttons.append(context)
                    
                    # Try to extract chain info
                    if 'Price' in context or 'Promo' in context:
                        # Extract chain name if visible
                        for line in context.split('\n'):
                            if any(keyword in line for keyword in ['רמי לוי', 'שופרסל', 'ויקטורי', 'יינות ביתן']):
                                chains[line.strip()] = chains.get(line.strip(), 0) + 1
            except:
                continue
        
        print("=" * 60)
        print(f"  📊 AVAILABLE FILES: {len(download_buttons)}")
        print("=" * 60)
        print()
        
        if chains:
            print("🏪 Chains found:")
            for chain, count in sorted(chains.items(), key=lambda x: x[1], reverse=True)[:10]:
                print(f"  • {chain}: {count} files")
            print()
        
        print("📦 File types:")
        prices = sum(1 for b in download_buttons if 'Price' in b)
        promos = sum(1 for b in download_buttons if 'Promo' in b)
        stores = sum(1 for b in download_buttons if 'Store' in b)
        
        if prices:
            print(f"  • Prices (מחירים): ~{prices}")
        if promos:
            print(f"  • Promos (מבצעים): ~{promos}")
        if stores:
            print(f"  • Stores (סניפים): ~{stores}")
        
        print()
        print("=" * 60)
        print("  💡 Use these scripts to download:")
        print("=" * 60)
        print("  • 🛒 TEST_KINGSTORE_10_FILES.bat     (10 files)")
        print("  • 🛒 DOWNLOAD_50_FILES.bat           (50 files)")
        print("  • 🛒 DOWNLOAD_ALL_KINGSTORE.bat      (ALL files)")
        print("=" * 60)
        
    except Exception as e:
        print(f"[ERROR] {e}")
        import traceback
        traceback.print_exc()
        
    finally:
        driver.quit()
        print()
        print("[OK] Browser closed")


if __name__ == "__main__":
    count_kingstore_files()





