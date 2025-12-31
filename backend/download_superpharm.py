#!/usr/bin/env python3
"""Download and inspect SuperPharm Price file"""
import requests
import gzip
import os

url = "https://prices.super-pharm.co.il/Download/Price7290172900007-321-202512241039.gz?bucketName=sp_transparency_output_prod"
output_file = "/app/data/superpharm/Price7290172900007-321-202512241039.gz"

os.makedirs("/app/data/superpharm", exist_ok=True)

print(f"📥 Downloading from: {url}")
response = requests.get(url, timeout=30)
response.raise_for_status()

print(f"✓ Downloaded {len(response.content)} bytes")

with open(output_file, 'wb') as f:
    f.write(response.content)

print(f"✓ Saved to: {output_file}")

# Decompress and show first lines
print(f"\n📄 File contents:")
print("=" * 80)

with gzip.open(output_file, 'rt', encoding='utf-8') as f:
    for i, line in enumerate(f):
        if i >= 50:
            break
        print(line.rstrip())

print("=" * 80)
