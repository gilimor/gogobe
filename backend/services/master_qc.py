#!/usr/bin/env python3
"""
Master Product Quality Control (QC) Service
Runs audits to find orphans, duplicates, and data anomalies.
"""

import psycopg2
from psycopg2.extras import RealDictCursor
import os
import logging
import json

# Logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - QC - %(message)s')
logger = logging.getLogger(__name__)

DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432')
}

class MasterQC:
    def __init__(self):
        self.conn = None

    def connect(self):
        self.conn = psycopg2.connect(**DB_CONFIG)

    def close(self):
        if self.conn:
            self.conn.close()

    def find_orphans(self):
        """Find Master Products with ZERO linked regional products"""
        logger.info("🔎 Searching for orphan Master Products...")
        with self.conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT mp.id, mp.global_name, mp.global_ean 
                FROM master_products mp
                LEFT JOIN product_master_links pml ON mp.id = pml.master_product_id
                WHERE pml.product_id IS NULL
            """)
            orphans = cur.fetchall()
            logger.info(f"Found {len(orphans)} orphan master products.")
            return orphans

    def find_unlinked_products(self):
        """Find Regional Products that have NO Master Link (Violation of Strict Mode)"""
        logger.info("🔎 Searching for unlinked Regional Products...")
        with self.conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT p.id, p.name, p.ean 
                FROM products p
                LEFT JOIN product_master_links pml ON p.id = pml.product_id
                WHERE pml.master_product_id IS NULL
            """)
            unlinked = cur.fetchall()
            logger.info(f"Found {len(unlinked)} unlinked regional products.")
            return unlinked

    def find_duplicates_by_ean(self):
        """Find Multiple Master Products sharing the same EAN"""
        logger.info("🔎 Searching for Master Products with duplicate EANs...")
        with self.conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT global_ean, COUNT(*), array_agg(id) as ids, array_agg(global_name) as names
                FROM master_products
                WHERE global_ean IS NOT NULL
                GROUP BY global_ean
                HAVING COUNT(*) > 1
            """)
            duplicates = cur.fetchall()
            logger.info(f"Found {len(duplicates)} EAN conflicts.")
            return duplicates

    def run_full_audit(self):
        self.connect()
        report = {
            "orphans": [],
            "unlinked": [],
            "duplicates": []
        }
        try:
            report["orphans"] = self.find_orphans()
            report["unlinked"] = self.find_unlinked_products()
            report["duplicates"] = self.find_duplicates_by_ean()
            
            self.print_report(report)
        finally:
            self.close()

    def print_report(self, report):
        print("\n" + "="*50)
        print("📊 MASTER PRODUCT QC REPORT")
        print("="*50)
        
        print(f"\n🗑️  ORPHANS: {len(report['orphans'])}")
        for o in report['orphans'][:5]:
            print(f"   - #{o['id']} {o['global_name']} (EAN: {o['global_ean']})")
        if len(report['orphans']) > 5: print("   ... (and more)")

        print(f"\n🔗 UNLINKED PRODUCTS: {len(report['unlinked'])}")
        for u in report['unlinked'][:5]:
            print(f"   - #{u['id']} {u['name']} (EAN: {u['ean']})")
        if len(report['unlinked']) > 5: print("   ... (and more)")

        print(f"\n👯 DUPLICATE MASTERS: {len(report['duplicates'])}")
        for d in report['duplicates']:
            print(f"   - EAN {d['global_ean']}: IDs {d['ids']}")

        print("\n" + "="*50)

if __name__ == "__main__":
    qc = MasterQC()
    qc.run_full_audit()
