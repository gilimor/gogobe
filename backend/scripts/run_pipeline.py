#!/usr/bin/env python3
"""
🚀 GOGOBE DAILY AUTOMATION PIPELINE
===================================
This script is the MASTER ORCHESTRATOR.
It runs the entire data ingestion and processing flow in the correct order.

Sequence:
1.  🛒 Parallel Import (Scraping & Ingesting)
2.  🏷️  Auto Categorization (Classifying new products)
3.  🛡️  Master Product QC (Auditing orphans & duplicates)
4.  📊 Status Report (Generating summary)

Usage:
    python backend/scripts/run_pipeline.py
"""

import subprocess
import os
import sys
import logging
import time
from datetime import datetime

# Setup Logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - PIPELINE - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler('pipeline.log', mode='a')
    ]
)
logger = logging.getLogger(__name__)

# Paths
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__))) # /app/backend
SCRIPTS_DIR = os.path.join(BASE_DIR, 'scripts')
SERVICES_DIR = os.path.join(BASE_DIR, 'services')

def run_step(name, command, cwd=None):
    logger.info(f"\n{'='*60}")
    logger.info(f"▶️  STARTING STEP: {name}")
    logger.info(f"    Command: {' '.join(command)}")
    logger.info(f"{'='*60}\n")
    
    start = time.time()
    try:
        # Pass environment variables
        env = os.environ.copy()
        env['PYTHONPATH'] = BASE_DIR # Ensure backend modules are found
        
        result = subprocess.run(
            command,
            cwd=cwd or BASE_DIR,
            env=env,
            check=False, # Don't crash pipeline on one step failure, but log it
            text=True
            # stdout/stderr act as passthrough by default
        )
        
        duration = time.time() - start
        if result.returncode == 0:
            logger.info(f"\n✅ {name} COMPLETED successfully in {duration:.1f}s")
            return True
        else:
            logger.error(f"\n❌ {name} FAILED with exit code {result.returncode} in {duration:.1f}s")
            return False
            
    except Exception as e:
        logger.error(f"❌ Execution Error in {name}: {e}")
        return False

def main():
    logger.info("🚀 STARTING GOGOBE DATA PIPELINE")
    
    # 1. PARALLEL IMPORT
    # ------------------
    # Triggers all scrapers to fetch fresh data
    run_step(
        "Parallel Import",
        [sys.executable, os.path.join(SCRIPTS_DIR, 'import_all_sources_parallel.py')]
    )

    # 2. AUTO CATEGORIZATION
    # ----------------------
    # Classifies newly imported products (e.g. "TV Screen" -> "Electronics")
    run_step(
        "Auto Categorization",
        [sys.executable, os.path.join(SERVICES_DIR, 'auto_categorizer.py')]
    )

    # 3. MASTER PRODUCT QC
    # --------------------
    # Checks for orphans (`master_products` with no children) and duplicates
    run_step(
        "Master Product QC",
        [sys.executable, os.path.join(SERVICES_DIR, 'master_qc.py')]
    )

    # 4. STATUS REPORT
    # ----------------
    # Generates a summary of DB stats
    run_step(
        "Status Report",
        [sys.executable, os.path.join(SCRIPTS_DIR, 'generate_status_report.py')]
    )

    logger.info("\n🎉 PIPELINE FINISHED\n")

if __name__ == "__main__":
    main()
