import asyncio
from playwright.async_api import async_playwright
from llm_client import generate_completion

async def sanity_check():
    url = "https://example.com"
    print(f"Sanity Check: Fetching {url}...", flush=True)
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True, args=["--no-sandbox"])
        page = await browser.new_page()
        await page.goto(url)
        content = await page.content()
        print(f"Content Length: {len(content)}", flush=True)
        await browser.close()
        
    print("Sending to Ollama...", flush=True)
    res = generate_completion("Say 'System Operational' if you can read this.")
    print(f"Ollama Response: {res}", flush=True)

if __name__ == "__main__":
    asyncio.run(sanity_check())
