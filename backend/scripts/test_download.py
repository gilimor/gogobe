"""
Quick test to check if downloads are working
"""

import sys
from pathlib import Path
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
import time

def test_download():
    """Test download functionality"""
    print("=" * 60)
    print("Testing KingStore Downloads")
    print("=" * 60)
    print()
    
    # Setup download directory
    download_dir = Path("backend/data/kingstore")
    download_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"[INFO] Download directory: {download_dir.absolute()}")
    print(f"[INFO] Current files: {len(list(download_dir.glob('*')))}")
    print()
    
    # Setup Chrome
    chrome_options = Options()
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    
    prefs = {
        "download.default_directory": str(download_dir.absolute()),
        "download.prompt_for_download": False,
        "download.directory_upgrade": True,
        "safebrowsing.enabled": False
    }
    chrome_options.add_experimental_option("prefs", prefs)
    
    driver = webdriver.Chrome(options=chrome_options)
    
    try:
        # Enable downloads
        driver.execute_cdp_cmd("Browser.setDownloadBehavior", {
            "behavior": "allow",
            "downloadPath": str(download_dir.absolute())
        })
        
        print("[INFO] Navigating to KingStore...")
        driver.get("https://kingstore.binaprojects.com/Main.aspx")
        time.sleep(5)
        
        print("[INFO] Looking for download buttons...")
        buttons = driver.find_elements(By.XPATH, "//a | //button | //input[@type='button']")
        
        download_buttons = []
        for button in buttons:
            try:
                text = button.text or button.get_attribute('value') or ''
                if 'להורדה' in text:
                    download_buttons.append(button)
                    if len(download_buttons) >= 3:
                        break
            except:
                continue
        
        print(f"[OK] Found {len(download_buttons)} download buttons")
        print()
        
        if download_buttons:
            print("[INFO] Attempting to download first file...")
            files_before = set(download_dir.glob("*"))
            
            try:
                download_buttons[0].click()
                print("[OK] Button clicked, waiting for download...")
                
                # Wait and check for new files
                for i in range(20):
                    time.sleep(1)
                    files_after = set(download_dir.glob("*"))
                    new_files = files_after - files_before
                    new_files = {f for f in new_files if not f.name.endswith('.crdownload')}
                    
                    if new_files:
                        new_file = list(new_files)[0]
                        print(f"[SUCCESS] Downloaded: {new_file.name}")
                        print(f"           Size: {new_file.stat().st_size} bytes")
                        print(f"           Time: {i+1} seconds")
                        return True
                    
                    if i % 5 == 0 and i > 0:
                        print(f"  ... still waiting ({i}s)")
                
                print("[FAILED] No file downloaded after 20 seconds")
                return False
                
            except Exception as e:
                print(f"[ERROR] Click failed: {e}")
                return False
        else:
            print("[ERROR] No download buttons found")
            return False
            
    finally:
        driver.quit()
        print("\n[INFO] Browser closed")


if __name__ == "__main__":
    success = test_download()
    
    print("\n" + "=" * 60)
    if success:
        print("✅ TEST PASSED - Downloads are working!")
    else:
        print("❌ TEST FAILED - Downloads not working")
    print("=" * 60)








