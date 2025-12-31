
import requests
from bs4 import BeautifulSoup
import re
import logging
import sys

# Setup logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

USERNAME = "RamiLevi"
PASSWORD = ""
BASE_URL = "https://url.publishedprices.co.il"

def debug_login():
    session = requests.Session()
    
    # Headers to mimic browser
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
        'Accept-Language': 'he-IL,he;q=0.9,en-US;q=0.8,en;q=0.7',
        'Upgrade-Insecure-Requests': '1',
        'Sec-Ch-Ua': '"Not/A)Brand";v="99", "Google Chrome";v="115", "Chromium";v="115"',
        'Sec-Ch-Ua-Mobile': '?0',
        'Sec-Ch-Ua-Platform': '"Windows"',
        'Sec-Fetch-Dest': 'document',
        'Sec-Fetch-Mode': 'navigate',
        'Sec-Fetch-Site': 'none',
        'Sec-Fetch-User': '?1'
    }
    session.headers.update(headers)

    # Step 1: GET Login Page
    login_url = f"{BASE_URL}/login"
    print(f"GET {login_url}")
    try:
        response = session.get(login_url, timeout=30, verify=False)
    except Exception as e:
        print(f"GET failed: {e}")
        return

    soup = BeautifulSoup(response.content, 'html.parser')
    
    # Extract CSRF
    csrf_input = soup.find('input', attrs={'name': re.compile(r'csrf|token|__RequestVerificationToken', re.I)})
    csrf_token = csrf_input.get('value') if csrf_input else None
    print(f"CSRF Token: {csrf_token}")

    # Prepare POST data
    data = {
        'username': USERNAME,
        'password': PASSWORD
    }
    if csrf_input:
        data[csrf_input.get('name')] = csrf_token

    # Update headers for POST
    post_headers = headers.copy()
    post_headers.update({
        'Origin': BASE_URL,
        'Referer': login_url,
        'Content-Type': 'application/x-www-form-urlencoded',
        'Sec-Fetch-Site': 'same-origin'
    })

    # Step 2: POST Credentials
    print(f"POST {login_url} with user={USERNAME}")
    try:
        post_response = session.post(login_url, data=data, headers=post_headers, timeout=30, verify=False)
    except Exception as e:
        print(f"POST failed: {e}")
        return

    print(f"Status Code: {post_response.status_code}")
    print(f"Final URL: {post_response.url}")
    
    if "login" in post_response.url.lower():
        print("Still on login page.")
        # Save HTML for inspection
        with open("login_fail.html", "wb") as f:
            f.write(post_response.content)
        print("Saved login_fail.html")
    else:
        print("Login seemingly successful (redirected).")

if __name__ == "__main__":
    import urllib3
    urllib3.disable_warnings()
    debug_login()
