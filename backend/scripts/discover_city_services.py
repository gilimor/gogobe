import asyncio
import json
import sys
from playwright.async_api import async_playwright

async def discover_services(city, service_type, custom_query=None):
    print(f"Starting discovery for: {service_type} in {city}")
    if custom_query:
        print(f"Using Custom Query: {custom_query}")
    
    data = []
    
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True, args=["--no-sandbox", "--disable-setuid-sandbox"])
        page = await browser.new_page()
        
        # SearchQuery
        query = custom_query if custom_query else f"{service_type} in {city}"
        print(f"Navigating to Google Maps for '{query}'...")
        await page.goto(f"https://www.google.com/maps/search/{query}")
        
        try:
            await page.wait_for_selector('div[role="feed"]', timeout=20000)
            print("Feed loaded.")
        except:
            print("Feed not found. screenshot.")
            await page.screenshot(path=f"maps_error_{service_type}.png")
            await browser.close()
            return

        feed = page.locator('div[role="feed"]')
        for i in range(5):
            print(f"scrolling {i}...")
            await feed.evaluate("node => node.scrollBy(0, 5000)")
            await page.wait_for_timeout(2000)
        
        items = await feed.locator('div[role="article"]').all()
        print(f"Found {len(items)} potential items.")
        
        for item in items:
            try:
                text = await item.inner_text()
                lines = text.split('\n')
                name = lines[0] if lines else "Unknown"
                
                data.append({
                    "name": name,
                    "raw_text": text[:100].replace('\n', ' ')
                })
            except: pass
            
        await browser.close()

    filename = f"/app/backend/discovered_{service_type}_{city}.json"
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"Saved {len(data)} results to {filename}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python discover_city_services.py <city> <service_type> [query]")
        sys.exit(1)
        
    city = sys.argv[1]
    service_type = sys.argv[2]
    custom_query = sys.argv[3] if len(sys.argv) > 3 else None
    
    asyncio.run(discover_services(city, service_type, custom_query))
