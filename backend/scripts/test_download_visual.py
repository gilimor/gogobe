"""
Test download with VISIBLE browser to see what's happening
"""

import sys
from pathlib import Path
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
import time

def test_download_visual():
    """Test with visible browser"""
    print("=" * 60)
    print("Visual Browser Test")
    print("=" * 60)
    print()
    print("Watch the browser window to see what happens!")
    print()
    
    # Setup download directory
    download_dir = Path("backend/data/kingstore")
    download_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"[INFO] Download directory: {download_dir.absolute()}")
    print()
    
    # Setup Chrome - NO HEADLESS!
    chrome_options = Options()
    # chrome_options.add_argument("--headless")  # DISABLED - we want to see!
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--start-maximized")
    
    prefs = {
        "download.default_directory": str(download_dir.absolute()),
        "download.prompt_for_download": False,
        "download.directory_upgrade": True,
        "safebrowsing.enabled": False
    }
    chrome_options.add_experimental_option("prefs", prefs)
    
    driver = webdriver.Chrome(options=chrome_options)
    
    try:
        driver.execute_cdp_cmd("Browser.setDownloadBehavior", {
            "behavior": "allow",
            "downloadPath": str(download_dir.absolute())
        })
        
        print("[INFO] Opening KingStore...")
        driver.get("https://kingstore.binaprojects.com/Main.aspx")
        
        print("[INFO] Waiting for page to load...")
        time.sleep(5)
        
        print()
        print("=" * 60)
        print("BROWSER IS OPEN - Check it out!")
        print("=" * 60)
        print()
        print("What do you see?")
        print("  - Are there download buttons?")
        print("  - Do you need to scroll?")
        print("  - Is there a login/captcha?")
        print()
        print("I'll try to click the first download button in 10 seconds...")
        print()
        
        time.sleep(10)
        
        # Find buttons
        buttons = driver.find_elements(By.XPATH, "//a | //button | //input[@type='button']")
        
        download_buttons = []
        for button in buttons:
            try:
                text = button.text or button.get_attribute('value') or ''
                if 'להורדה' in text:
                    download_buttons.append(button)
                    if len(download_buttons) >= 5:
                        break
            except:
                continue
        
        print(f"[OK] Found {len(download_buttons)} download buttons")
        
        if download_buttons:
            print()
            print("[INFO] I will click the first button now...")
            print("       Watch the browser!")
            print()
            
            input("Press ENTER when you're ready...")
            
            files_before = set(download_dir.glob("*"))
            
            try:
                download_buttons[0].click()
                print("[OK] Button clicked!")
                print()
                print("Watch the browser - what happens?")
                print("  - Does a download start?")
                print("  - Does a popup appear?")
                print("  - Does it redirect?")
                print()
                print("Waiting 30 seconds...")
                
                # Wait and check
                for i in range(30):
                    time.sleep(1)
                    files_after = set(download_dir.glob("*"))
                    new_files = files_after - files_before
                    new_files = {f for f in new_files if not f.name.endswith('.crdownload')}
                    
                    if new_files:
                        new_file = list(new_files)[0]
                        print(f"\n[SUCCESS] Downloaded: {new_file.name}")
                        print(f"           After: {i+1} seconds")
                        break
                    
                    if i % 5 == 4:
                        print(f"  ... {i+1}s")
                else:
                    print("\n[INFO] No download detected after 30s")
                    print("       But the browser is still open - check manually!")
                
                print()
                print("=" * 60)
                print("BROWSER WILL STAY OPEN FOR 60 SECONDS")
                print("Try to click download buttons manually!")
                print("=" * 60)
                
                time.sleep(60)
                
            except Exception as e:
                print(f"[ERROR] Click failed: {e}")
        
        print()
        input("Press ENTER to close browser...")
        
    finally:
        driver.quit()
        print("\n[INFO] Browser closed")


if __name__ == "__main__":
    test_download_visual()








