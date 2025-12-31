#!/usr/bin/env python3
"""Debug SuperPharm page structure"""
import requests
from bs4 import BeautifulSoup

url = 'https://prices.super-pharm.co.il/?page=1'
response = requests.get(url, timeout=30)
soup = BeautifulSoup(response.text, 'html.parser')

print("🔍 Structure of SuperPharm page:")
print()

# Find table
tables = soup.find_all('table')
print(f"Found {len(tables)} tables")

if tables:
    table = tables[0]
    
    # Headers
    headers = table.find_all('th')
    print(f"\nHeaders ({len(headers)}):")
    for i, h in enumerate(headers):
        print(f"  {i}: {h.get_text(strip=True)}")
    
    # First few rows
    rows = table.find_all('tr')[1:6]  # Skip header, get first 5
    print(f"\nFirst 5 rows:")
    for row_idx, row in enumerate(rows, 1):
        cells = row.find_all('td')
        print(f"\n  Row {row_idx} ({len(cells)} cells):")
        for cell_idx, cell in enumerate(cells):
            text = cell.get_text(strip=True)[:50]
            print(f"    Cell {cell_idx}: {text}")
