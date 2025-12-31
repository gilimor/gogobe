import asyncio
from playwright.async_api import async_playwright

async def main():
    print("Launching playwright...")
    try:
        async with async_playwright() as p:
            print("Browser launching...")
            browser = await p.chromium.launch(headless=True, args=["--no-sandbox", "--disable-setuid-sandbox"])
            print("Page creating...")
            page = await browser.new_page()
            print("Navigating...")
            await page.goto("http://example.com")
            title = await page.title()
            print(f"Title: {title}")
            await browser.close()
            print("Success!")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    asyncio.run(main())
