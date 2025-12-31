
import requests

BASE_URL = "https://www.opendata.metro.tokyo.lg.jp/shijyou/"
FILES = [
    "result_price_fresh.csv",
    "result_price_seika.csv",
    "result_price_suisan.csv",
    "result_price_flower.csv",
    "market_price.csv"
]

def check(filename):
    url = f"{BASE_URL}{filename}"
    try:
        r = requests.head(url, timeout=5)
        print(f"{filename}: {r.status_code}")
        if r.status_code == 200:
            # Download first few lines
            r = requests.get(url, headers={'Range': 'bytes=0-500'}, timeout=5)
            r.encoding = 'shift_jis' # Common in Japan, but might be utf-8
            print(f"Content:\n{r.text[:300]}")
    except Exception as e:
        print(f"Error {filename}: {e}")

if __name__ == "__main__":
    for f in FILES:
        check(f)
