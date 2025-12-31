import asyncio
from playwright.async_api import async_playwright
from bs4 import BeautifulSoup
import re

URLS = [
    ("Hatarbush (Directory)", "https://israelbusinessguide.com/catalog/rehovot/hatarbosh/"),
    ("Bilu Grill (Real Site)", "https://bilu.co.il/")
]

async def analyze_url(name, url):
    print(f"\n--- Analyzing {name} ---")
    print(f"URL: {url}")
    
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True, args=["--no-sandbox", "--disable-setuid-sandbox"])
        page = await browser.new_page()
        try:
            await page.goto(url, timeout=30000, wait_until='domcontentloaded')
            # Wait a bit for JS
            await page.wait_for_timeout(3000)
            
            content = await page.content()
            text = await page.evaluate("document.body.innerText")
            
            print(f"Status: 200")
            print(f"HTML Length: {len(content)}")
            print(f"Visible Text Length: {len(text)}")
            
            # Check for Menu keywords
            menu_keywords = ['תפריט', 'Menu', 'ראשונות', 'עיקריות', 'Starters', 'Mains']
            found_keywords = [kw for kw in menu_keywords if kw in content]
            print(f"Menu Keywords Found: {found_keywords}")
            
            # Check for Images (possible menu)
            imgs = await page.evaluate("Array.from(document.images, e => e.src)")
            print(f"Image Count: {len(imgs)}")
            
            # Check for Price patterns in Text
            price_re = re.compile(r'([₪$€£฿])?\s*(\d+)\s*([₪$€£฿])?')
            matches = price_re.findall(text)
            
            # Filter matches for reasonable prices (e.g. 20-200)
            valid_prices = []
            for m in matches:
                try:
                    val = float(m[1])
                    if 10 <= val <= 300: valid_prices.append(val)
                except: pass
                
            print(f"Potential Price Candidates (10-300): {len(valid_prices)}")
            print(f"Sample Prices: {valid_prices[:5]}")
            
            # Check Title
            title = await page.title()
            print(f"Page Title: {title}")
            
        except Exception as e:
            print(f"Error fetching {url}: {e}")
        finally:
            await browser.close()

async def main():
    for name, url in URLS:
        await analyze_url(name, url)

if __name__ == "__main__":
    asyncio.run(main())
