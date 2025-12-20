"""
KingStore Parallel Processor
Download and process files simultaneously using multiple threads
"""

import sys
from pathlib import Path
from datetime import datetime
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import threading
import queue
import hashlib
import zipfile
import gzip
import xml.etree.ElementTree as ET
import json

# Add backend to path
backend_path = Path(__file__).parent.parent
sys.path.insert(0, str(backend_path))

from database.db_connection import get_db_connection


class ParallelKingStoreProcessor:
    def __init__(self, download_limit=None, num_downloaders=1, num_processors=3):
        """
        Initialize parallel processor
        
        Args:
            download_limit: Max files to download
            num_downloaders: Number of download threads (1-2 recommended)
            num_processors: Number of processing threads (2-4 recommended)
        """
        self.base_url = "https://kingstore.binaprojects.com/Main.aspx"
        self.download_dir = Path("backend/data/kingstore")
        self.download_dir.mkdir(parents=True, exist_ok=True)
        
        self.download_limit = download_limit
        self.num_downloaders = num_downloaders
        self.num_processors = num_processors
        
        # Queues for communication between threads
        self.download_queue = queue.Queue()  # Files to download
        self.processing_queue = queue.Queue()  # Files to process
        
        # Shared statistics (thread-safe with lock)
        self.stats_lock = threading.Lock()
        self.stats = {
            'files_found': 0,
            'files_downloaded': 0,
            'files_skipped': 0,
            'files_processed': 0,
            'files_failed': 0,
            'products_imported': 0,
            'prices_imported': 0
        }
        
        # Control flags
        self.stop_downloading = threading.Event()
        self.stop_processing = threading.Event()
        
        self.session_id = None
        self.price_source_id = None
        
    def log(self, message, thread_name="MAIN"):
        """Thread-safe logging"""
        timestamp = datetime.now().strftime('%H:%M:%S')
        print(f"[{timestamp}] [{thread_name}] {message}")
    
    def update_stat(self, key, increment=1):
        """Thread-safe statistics update"""
        with self.stats_lock:
            self.stats[key] += increment
    
    def create_session(self):
        """Create scraping session"""
        conn = get_db_connection()
        cur = conn.cursor()
        
        try:
            # Get price source
            cur.execute("SELECT id FROM price_sources WHERE name LIKE '%KingStore%' LIMIT 1")
            result = cur.fetchone()
            
            if result:
                self.price_source_id = result[0]
            else:
                cur.execute("""
                    INSERT INTO price_sources (name, source_type, base_url, country_code)
                    VALUES ('KingStore', 'website', %s, 'IL')
                    RETURNING id
                """, (self.base_url,))
                self.price_source_id = cur.fetchone()[0]
            
            # Create session
            cur.execute("""
                INSERT INTO scraping_sessions (session_name, price_source_id, status)
                VALUES (%s, %s, 'running')
                RETURNING id
            """, (f"KingStore Parallel {datetime.now().strftime('%Y-%m-%d %H:%M')}", self.price_source_id))
            
            self.session_id = cur.fetchone()[0]
            conn.commit()
            
            self.log(f"Created session (ID: {self.session_id})")
            
        finally:
            cur.close()
            conn.close()
    
    def setup_driver(self):
        """Setup Chrome WebDriver"""
        chrome_options = Options()
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--log-level=3")
        
        prefs = {
            "download.default_directory": str(self.download_dir.absolute()),
            "download.prompt_for_download": False,
            "safebrowsing.enabled": False
        }
        chrome_options.add_experimental_option("prefs", prefs)
        
        driver = webdriver.Chrome(options=chrome_options)
        driver.execute_cdp_cmd("Browser.setDownloadBehavior", {
            "behavior": "allow",
            "downloadPath": str(self.download_dir.absolute())
        })
        
        return driver
    
    def find_all_buttons(self):
        """Find all download buttons (run once at start)"""
        self.log("Finding download buttons...")
        driver = self.setup_driver()
        
        try:
            driver.get(self.base_url)
            time.sleep(3)
            
            WebDriverWait(driver, 15).until(
                EC.presence_of_element_located((By.TAG_NAME, "body"))
            )
            
            buttons = driver.find_elements(By.XPATH, "//a | //button | //input[@type='button']")
            
            download_buttons = []
            for button in buttons:
                try:
                    text = button.text or button.get_attribute('value') or ''
                    if 'להורדה' in text or 'download' in text.lower():
                        parent = button.find_element(By.XPATH, "./..")
                        context = parent.text
                        download_buttons.append(context)
                except:
                    continue
            
            self.log(f"Found {len(download_buttons)} download buttons")
            return download_buttons
            
        finally:
            driver.quit()
    
    def downloader_worker(self, worker_id):
        """Worker thread for downloading files"""
        thread_name = f"DL-{worker_id}"
        self.log("Started", thread_name)
        
        driver = self.setup_driver()
        
        try:
            driver.get(self.base_url)
            time.sleep(3)
            
            while not self.stop_downloading.is_set():
                try:
                    # Get next download task (with timeout)
                    button_index = self.download_queue.get(timeout=2)
                    
                    if button_index is None:  # Poison pill
                        break
                    
                    self.log(f"Downloading file #{button_index}", thread_name)
                    
                    # Find button
                    buttons = driver.find_elements(By.XPATH, "//a | //button | //input[@type='button']")
                    download_buttons = []
                    for button in buttons:
                        try:
                            text = button.text or ''
                            if 'להורדה' in text:
                                download_buttons.append(button)
                        except:
                            continue
                    
                    if button_index >= len(download_buttons):
                        self.log(f"Button {button_index} not found", thread_name)
                        continue
                    
                    # Download
                    files_before = set(self.download_dir.glob("*"))
                    download_buttons[button_index].click()
                    
                    # Wait for download
                    downloaded = False
                    for i in range(15):
                        time.sleep(1)
                        files_after = set(self.download_dir.glob("*"))
                        new_files = {f for f in (files_after - files_before) 
                                   if not f.name.endswith('.crdownload') and not f.name.endswith('.tmp')}
                        
                        if new_files:
                            new_file = list(new_files)[0]
                            self.log(f"Downloaded: {new_file.name}", thread_name)
                            self.update_stat('files_downloaded')
                            
                            # Add to processing queue
                            self.processing_queue.put(new_file)
                            downloaded = True
                            break
                    
                    if not downloaded:
                        self.log(f"Download timeout", thread_name)
                        self.update_stat('files_failed')
                    
                    self.download_queue.task_done()
                    
                except queue.Empty:
                    continue
                except Exception as e:
                    self.log(f"Error: {e}", thread_name)
                    self.update_stat('files_failed')
                    
        finally:
            driver.quit()
            self.log("Stopped", thread_name)
    
    def processor_worker(self, worker_id):
        """Worker thread for processing files"""
        thread_name = f"PROC-{worker_id}"
        self.log("Started", thread_name)
        
        # Use subprocess to call the standalone processor
        # This way each worker is independent
        import subprocess
        
        while not self.stop_processing.is_set():
            try:
                # Get next file to process
                filepath = self.processing_queue.get(timeout=2)
                
                if filepath is None:  # Poison pill
                    break
                
                self.log(f"Processing: {filepath.name}", thread_name)
                
                try:
                    # Mark file as processing in database
                    conn = get_db_connection()
                    cur = conn.cursor()
                    
                    cur.execute("""
                        UPDATE downloaded_files
                        SET processing_status = 'processing',
                            processing_started_at = NOW()
                        WHERE filename = %s AND price_source_id = %s
                    """, (filepath.name, self.price_source_id))
                    
                    conn.commit()
                    cur.close()
                    conn.close()
                    
                    # Let the main processor handle this file
                    # It will pick it up from the database
                    self.update_stat('files_processed')
                    self.log(f"Queued for processing", thread_name)
                    
                except Exception as e:
                    self.log(f"Processing error: {e}", thread_name)
                    self.update_stat('files_failed')
                
                self.processing_queue.task_done()
                
            except queue.Empty:
                continue
            except Exception as e:
                self.log(f"Worker error: {e}", thread_name)
        
        self.log("Stopped", thread_name)
    
    def run(self):
        """Main parallel processing"""
        print("=" * 70)
        print("     KINGSTORE PARALLEL PROCESSOR")
        print("=" * 70)
        print(f"  Downloaders: {self.num_downloaders}")
        print(f"  Processors:  {self.num_processors}")
        print("=" * 70)
        print()
        
        try:
            # Create session
            self.create_session()
            
            # Find all buttons
            buttons = self.find_all_buttons()
            self.stats['files_found'] = len(buttons)
            
            if not buttons:
                self.log("No buttons found!")
                return
            
            # Determine how many to download
            download_count = min(len(buttons), self.download_limit) if self.download_limit else len(buttons)
            self.log(f"Will download {download_count} files")
            
            # Fill download queue
            for i in range(download_count):
                self.download_queue.put(i)
            
            # Start processor threads
            processor_threads = []
            for i in range(self.num_processors):
                t = threading.Thread(target=self.processor_worker, args=(i+1,), daemon=True)
                t.start()
                processor_threads.append(t)
            
            time.sleep(1)
            
            # Start downloader threads
            downloader_threads = []
            for i in range(self.num_downloaders):
                t = threading.Thread(target=self.downloader_worker, args=(i+1,), daemon=True)
                t.start()
                downloader_threads.append(t)
            
            # Monitor progress
            last_stats = self.stats.copy()
            while True:
                time.sleep(10)
                
                with self.stats_lock:
                    current_stats = self.stats.copy()
                
                self.log(f"Progress: Downloaded={current_stats['files_downloaded']}, " +
                        f"Processed={current_stats['files_processed']}, " +
                        f"Products={current_stats['products_imported']}, " +
                        f"Prices={current_stats['prices_imported']}")
                
                # Check if done
                if (self.download_queue.empty() and self.processing_queue.empty() and
                    all(not t.is_alive() for t in downloader_threads)):
                    self.log("All downloads complete")
                    break
                
                last_stats = current_stats
            
            # Wait for processing to finish
            self.log("Waiting for processing to complete...")
            self.processing_queue.join()
            
            # Stop all threads
            self.stop_downloading.set()
            self.stop_processing.set()
            
            # Send poison pills
            for _ in range(self.num_processors):
                self.processing_queue.put(None)
            
            # Wait for threads
            for t in downloader_threads + processor_threads:
                t.join(timeout=5)
            
            # Print summary
            print("\n" + "=" * 70)
            print("     PROCESSING COMPLETE!")
            print("=" * 70)
            with self.stats_lock:
                print(f"Files found:      {self.stats['files_found']}")
                print(f"Files downloaded: {self.stats['files_downloaded']}")
                print(f"Files processed:  {self.stats['files_processed']}")
                print(f"Files failed:     {self.stats['files_failed']}")
                print(f"Products imported: {self.stats['products_imported']}")
                print(f"Prices imported:   {self.stats['prices_imported']}")
            print("=" * 70)
            
        except KeyboardInterrupt:
            self.log("\n\nStopping...")
            self.stop_downloading.set()
            self.stop_processing.set()
        except Exception as e:
            self.log(f"Error: {e}")
            import traceback
            traceback.print_exc()


def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(description='KingStore Parallel Processor')
    parser.add_argument('--limit', type=int, help='Limit number of files')
    parser.add_argument('--downloaders', type=int, default=1, help='Number of download threads (1-2)')
    parser.add_argument('--processors', type=int, default=3, help='Number of processing threads (2-4)')
    
    args = parser.parse_args()
    
    processor = ParallelKingStoreProcessor(
        download_limit=args.limit,
        num_downloaders=args.downloaders,
        num_processors=args.processors
    )
    
    processor.run()


if __name__ == "__main__":
    main()

