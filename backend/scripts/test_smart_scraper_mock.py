import asyncio
from smart_llm_scraper import scrape_with_llm
import llm_client

# Mock the LLM
def mock_generate(prompt):
    print(f"\n[MOCK] Received Prompt (Length: {len(prompt)})")
    print(f"[MOCK] Prompt Preview: {prompt[:100]}...")
    return """
    {
      "items": [
        {"name": "MOCK DISH 1", "price": 50, "description": "Delicious mock dish"},
        {"name": "MOCK DISH 2", "price": 100}
      ]
    }
    """

llm_client.generate_completion = mock_generate

if __name__ == "__main__":
    print("Running Smart Scraper with MOCK LLM...")
    scrape_with_llm("https://bilu.co.il/")
