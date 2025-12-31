
import requests
import io
import csv

# URL: https://www.shijou-nippo.metro.tokyo.lg.jp/SN/202512/20251226/Sui/Sui_K0.csv
URL = "https://www.shijou-nippo.metro.tokyo.lg.jp/SN/202512/20251226/Sui/Sui_K0.csv"

def check_csv():
    try:
        r = requests.get(URL, timeout=10)
        r.encoding = 'shift_jis' # Standard Japanese CSV
        
        print(f"Status: {r.status_code}")
        if r.status_code == 200:
            lines = r.text.splitlines()[:10]
            print("\n--- First 10 lines ---")
            for l in lines:
                print(l)
                
            # Try parsing with csv
            # f = io.StringIO(r.text)
            # reader = csv.reader(f)
            # header = next(reader)
            # print(f"\nHeader: {header}")
            
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_csv()
