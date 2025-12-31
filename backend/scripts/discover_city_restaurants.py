import asyncio
import json
import sys
from playwright.async_api import async_playwright

async def discover_restaurants(city):
    print(f"Starting discovery for: {city}")
    data = []
    
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        # Search for restaurants
        query = f"Restaurants in {city}"
        print(f"Navigating to Google Maps for '{query}'...")
        await page.goto(f"https://www.google.com/maps/search/{query}")
        
        # Wait for the results feed to load
        try:
            # This selector aims at the scrollable list container.
            # Google Maps changes classes often, relying on role="feed" is safer.
            await page.wait_for_selector('div[role="feed"]', timeout=20000)
            print("Feed loaded.")
        except Exception as e:
            print("Could not find result feed. taking screenshot.")
            await page.screenshot(path="maps_error.png")
            await browser.close()
            return

        # Scroll loop to load more
        feed = page.locator('div[role="feed"]')
        
        # Scroll a few times to get ~20-30 results
        for i in range(5):
            print(f"scrolling {i}...")
            await feed.evaluate("node => node.scrollBy(0, 5000)")
            await page.wait_for_timeout(2000)
        
        # Extract items
        # Items are usually div[role="article"] or similar chunks inside the feed
        # We look for links.
        # The structure is complex. We'll grab all links inside the feed and try to parse.
        
        items = await feed.locator('div[role="article"]').all()
        print(f"Found {len(items)} potential items.")
        
        for item in items:
            try:
                # Name is usually in an aria-label of a link or just text
                # Website is in a specific 'a' tag with 'data-value="Website"' or similar
                # Let's extract all links and analyze
                
                text_content = await item.inner_text()
                lines = text_content.split('\n')
                name = lines[0] if lines else "Unknown"
                
                # Check for website
                # We need to click the item to see details? No, usually buttons are there or we can extract href from "Website" button
                # Actually, in the list view, the website button might not be directly visible or is an 'a' tag.
                # Let's look for any 'a' tag that is NOT the main item link.
                
                # Google Maps List View is tricky.
                # Simpler approach: Just get the text for now to confirm we have the list.
                
                data.append({
                    "name": name,
                    "raw_text": text_content[:100].replace('\n', ' ')
                })
                
            except Exception as e:
                pass
                
        await browser.close()

    # Save
    filename = f"/app/backend/discovered_{city}.json"
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"Saved {len(data)} results to {filename}")

if __name__ == "__main__":
    city = sys.argv[1] if len(sys.argv) > 1 else "Rehovot"
    asyncio.run(discover_restaurants(city))
