print("STARTING SCRAPER...", flush=True)
import asyncio
import re
import json
from playwright.async_api import async_playwright
from bs4 import BeautifulSoup
from llm_client import generate_completion

# Configuration
OLLAMA_MODEL = "llama3"

def clean_html(html_content):
    soup = BeautifulSoup(html_content, 'html.parser')
    
    # Remove script and style elements
    for script in soup(["script", "style", "svg", "path", "noscript", "meta", "link"]):
        script.decompose()
        
    for tag in soup.find_all(True): 
        tag.attrs = {} 
        
    text = soup.body.get_text(separator=' ', strip=True) if soup.body else soup.get_text()
    
    # Compress whitespace
    text = re.sub(r'\s+', ' ', text)
    
    return text[:4000]

async def scrape_with_llm(url):
    print(f"Fetching {url}...", flush=True)
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True, args=["--no-sandbox"])
        page = await browser.new_page()
        all_items = []
        
        try:
            try:
                print(f"Navigating to {url}...", flush=True)
                await page.goto(url, timeout=45000, wait_until='commit')
                print("Page committed. Waiting for hydration...", flush=True)
                await page.wait_for_timeout(10000) # Wait for initial hydration
            except Exception as nav_err:
                 print(f"Navigation warning (proceeding): {nav_err}", flush=True)
            
            # Persistent Popup Handling (Loop)
            print("Attempting to close popups (Loop mode)...", flush=True)
            for i in range(5): # Try up to 5 times
                popup_found = False
                close_selectors = ["button[aria-label='Close']", ".close-button", ".popup-close", "div[role='dialog'] button"]
                for selector in close_selectors:
                    if await page.is_visible(selector):
                        popup_found = True
                        try:
                            print(f"Popup detected ({selector}). Clicking close...", flush=True)
                            await page.click(selector, timeout=2000, force=True)
                            await page.wait_for_timeout(1000) # Wait after close
                        except Exception as click_err:
                            print(f"Click failed for {selector}: {click_err}", flush=True)
                
                if not popup_found:
                    break
                await page.wait_for_timeout(500)
            
            content = await page.content()
            cleaned_text = clean_html(content)
            total_len = len(cleaned_text)
            print(f"Total Content Length (Cleaned): {total_len}", flush=True)
            
            # Chunking Logic
            CHUNK_SIZE = 500
            chunks = [cleaned_text[i:i+CHUNK_SIZE] for i in range(0, total_len, CHUNK_SIZE)]
            
            for index, chunk in enumerate(chunks):
                if index >= 3: break # Limit to first 3 chunks to save time for now
                
                print(f"Processing Chunk {index+1}/{len(chunks)} ({len(chunk)} chars)...", flush=True)
                
                prompt = f"""
                Extract menu items from this text chunk.
                Return JSON: {{ "items": [ {{ "name": "...", "price": 123 }} ] }}
                Ignore items without prices. Ignore phone numbers.
                Text:
                {chunk}
                """
                
                response = generate_completion(prompt)
                
                if response:
                    try:
                        clean_json = response
                        if "```json" in response:
                            clean_json = response.split("```json")[1].split("```")[0]
                        elif "```" in response:
                            clean_json = response.split("```")[1].split("```")[0]
                            
                        data = json.loads(clean_json)
                        items = data.get('items', [])
                        print(f"Chunk {index+1} found {len(items)} items.", flush=True)
                        all_items.extend(items)
                    except Exception as e:
                        print(f"Chunk {index+1} JSON Error: {e}", flush=True)
            
            print(f"\n--- Total Items Found: {len(all_items)} ---", flush=True)
            print(json.dumps(all_items, indent=2, ensure_ascii=False), flush=True)
                
        except Exception as e:
            print(f"Scrape Error: {e}", flush=True)
        finally:
            await browser.close()

if __name__ == "__main__":
    urls = [
        "https://bilu.co.il/תפריט-המסעדה/",
        "https://bilu.co.il/תפריט-טייק-אוויי/"
    ]
    for url in urls:
        asyncio.run(scrape_with_llm(url))
