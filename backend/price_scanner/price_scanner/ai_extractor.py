import os
import json
from openai import OpenAI
import re

def extract_product_with_ai(html_content, url):
    """
    Uses OpenAI's GPT-4o-mini to extract product details from raw HTML.
    This is a fallback method for difficult sites.
    """
    api_key = os.getenv('OPENAI_API_KEY')
    if not api_key:
        print("⚠️ OpenAI API Key missing. Skipping AI extraction.")
        return None

    client = OpenAI(api_key=api_key)

    # 1. Clean and Truncate HTML to save tokens/money
    # We remove scripts and styles as they are usually noise for LLM (unless data is in script)
    # But often data IS in script (JSON-LD), so we keep it if possible, or just truncate hard.
    # A safe bet is to take the first 20kb of text after basic cleaning.
    
    clean_html = re.sub(r'<style[^>]*>.*?</style>', '', html_content, flags=re.DOTALL)
    # clean_html = re.sub(r'<script[^>]*>.*?</script>', '', clean_html, flags=re.DOTALL) # Keep scripts for now
    truncated_html = clean_html[:30000] # 30k chars is enough for most PDPs

    prompt = f"""
    You are a scraper bot. I will give you HTML from a product page.
    URL: {url}
    
    Extract the following fields into a pure JSON object:
    - name (string): Product title
    - price (number): Numeric price (e.g. 19.90)
    - currency (string): ISO code (ILS, USD, EUR) - default to ILS if strictly Hebrew context
    - barcode (string): EAN/GTIN if found
    
    HTML Snippet:
    ```html
    {truncated_html}
    ```
    
    Return ONLY valid JSON. No markdown formatting.
    """

    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": "You are a helpful data extraction assistant. You output only valid JSON."},
                {"role": "user", "content": prompt}
            ],
            temperature=0,
            response_format={ "type": "json_object" }
        )
        
        content = response.choices[0].message.content
        data = json.loads(content)
        
        # Basic validation
        if data.get('name') and data.get('price'):
            return data
            
    except Exception as e:
        print(f"❌ AI Extraction Error: {e}")
        return None

    return None
