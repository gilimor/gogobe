#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
KingStore Check New Files
Quick check for new files by release date
"""

import sys
from pathlib import Path
from datetime import datetime
import re
import os
import psycopg2

def get_db_connection():
    """Get database connection"""
    return psycopg2.connect(
        dbname=os.getenv('DB_NAME', 'gogobe'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host=os.getenv('DB_HOST', 'db'),
        port=os.getenv('DB_PORT', '5432'),
        client_encoding='UTF8'
    )

def get_release_date_from_filename(filename):
    """Extract release date (YYYYMMDD) from filename"""
    match = re.search(r'-(\d{8})\d{4}', filename)
    if match:
        return match.group(1)
    return None

def get_last_processed_release_date(conn):
    """Get the last release date that was processed"""
    cur = conn.cursor()
    try:
        cur.execute("""
            SELECT MAX(last_scraped_at) as last_date
            FROM prices
            WHERE supplier_id = (SELECT id FROM suppliers WHERE slug = 'kingstore')
        """)
        result = cur.fetchone()
        
        if result and result[0]:
            return result[0].strftime('%Y%m%d')
        return None
    finally:
        cur.close()

def main():
    """Main function"""
    print("=" * 70)
    print("KINGSTORE - CHECK NEW FILES")
    print("=" * 70)
    
    download_dir = os.getenv('KINGSTORE_DOWNLOAD_DIR', '/app/data/kingstore/downloads')
    download_path = Path(download_dir)
    
    # Get last processed date
    conn = get_db_connection()
    try:
        last_date = get_last_processed_release_date(conn)
        if last_date:
            print(f"\nLast processed release date: {last_date}")
        else:
            print("\nNo previous imports found")
            last_date = "00000000"
    finally:
        conn.close()
    
    # Scan files
    files_by_date = {}
    for file_path in download_path.glob('Price*.gz'):
        release_date = get_release_date_from_filename(file_path.name)
        if release_date:
            if release_date not in files_by_date:
                files_by_date[release_date] = []
            files_by_date[release_date].append(file_path.name)
    
    # Find new dates
    new_dates = []
    for date in sorted(files_by_date.keys(), reverse=True):
        if date > last_date:
            new_dates.append(date)
    
    print(f"\nFiles found: {sum(len(files) for files in files_by_date.values())} total")
    print(f"Unique release dates: {len(files_by_date)}")
    
    if new_dates:
        print(f"\n🆕 NEW FILES TO PROCESS: {len(new_dates)} dates")
        print("-" * 70)
        for date in sorted(new_dates):
            file_count = len(files_by_date[date])
            print(f"  {date}: {file_count} files")
        print("-" * 70)
        print(f"\nTo process, run:")
        print(f"  docker exec gogobe-api-1 python /app/backend/scripts/kingstore_process_by_release_date.py")
    else:
        print(f"\n✅ No new files - all up to date!")
        if files_by_date:
            print(f"\nLatest date in files: {max(files_by_date.keys())}")
    
    print("=" * 70)

if __name__ == "__main__":
    main()


