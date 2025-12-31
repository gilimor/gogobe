
import requests


URL = "https://www.fuelwatch.wa.gov.au/fuelwatch/fuelWatchRSS"
HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
}

def check(params, label):
    try:
        r = requests.get(URL, params=params, headers=HEADERS, timeout=10)
        print(f"\n--- {label} ---")
        print(f"URL: {r.url}")
        print(f"Status: {r.status_code}")
        
        xml = r.text
        if "<title>" in xml:
            # Extract main title
            start = xml.find("<title>") + 7
            end = xml.find("</title>")
            print(f"Title: {xml[start:end]}")
        
        # Print start of XML
        print(xml[:300])
    except Exception as e:
        print(f"Error {label}: {e}")

check({"Product": 1}, "Default")
check({"Product": 1, "Day": "tomorrow"}, "Tomorrow")
check({"Product": 1, "Day": "today"}, "Today")
