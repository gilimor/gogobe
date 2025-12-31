"""
Sources Management API
Manage data source scrapers
"""
from fastapi import APIRouter, HTTPException, BackgroundTasks
from pydantic import BaseModel
from typing import Optional
import sys
import os

# Add path for scraper registry
current_dir = os.path.dirname(os.path.abspath(__file__))
app_root = os.path.abspath(os.path.join(current_dir, "..", "..", ".."))
if app_root not in sys.path:
    sys.path.insert(0, app_root)

from backend.scrapers.scraper_registry import get_registry

router = APIRouter(
    prefix="/api/admin/sources",
    tags=["sources"]
)

class SourceToggleRequest(BaseModel):
    source_id: str

class ImportRequest(BaseModel):
    source_id: str
    limit: Optional[int] = 100

# Database helper
import psycopg2
from psycopg2.extras import RealDictCursor

DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432')
}
if os.getenv('DB_HOST') is None: DB_CONFIG['host'] = 'localhost'

def get_db_connection():
    try: return psycopg2.connect(**DB_CONFIG)
    except: return None

@router.get("/status")
async def get_sources_status():
    """Get status of all data sources with DB stats"""
    try:
        registry = get_registry()
        # 1. Get Base Status
        status = registry.get_status()
        
        # 2. Enrich with DB Stats
        conn = get_db_connection()
        if conn:
            try:
                with conn.cursor(cursor_factory=RealDictCursor) as cur:
                    # Generic stats map
                    db_stats = {} 
                    
                    # Fetch Chain Stats
                    cur.execute("""
                        SELECT 
                            c.slug,
                            COUNT(DISTINCT s.id) as branch_count,
                            COUNT(DISTINCT pr.product_id) as product_count,
                            MAX(pr.scraped_at) as last_db_import
                        FROM chains c
                        LEFT JOIN stores s ON c.id = s.chain_id AND s.is_active = TRUE
                        LEFT JOIN prices pr ON s.id = pr.store_id
                        GROUP BY c.slug
                    """)
                    for row in cur.fetchall():
                        db_stats[row['slug']] = row

                    # Fetch Supplier Stats (for non-chains)
                    cur.execute("""
                        SELECT 
                            s.slug,
                            0 as branch_count,
                            COUNT(DISTINCT pr.product_id) as product_count,
                            MAX(pr.scraped_at) as last_db_import
                        FROM suppliers s
                        LEFT JOIN prices pr ON s.id = pr.supplier_id
                        GROUP BY s.slug
                    """)
                    for row in cur.fetchall():
                        # Prefer chain stats if conflict (unlikely), else add
                        if row['slug'] not in db_stats:
                            db_stats[row['slug']] = row

                    # Merge
                    for source_id, data in status.items():
                        stat = db_stats.get(source_id)
                        if stat:
                            data['branch_count'] = stat['branch_count']
                            data['product_count'] = stat['product_count']
                            # Prefer DB last_import if available and newer? 
                            # Actually registry might be more "process" aware, DB is "data" aware.
                            # Let's show DB last import if registry is None
                            if not data['last_import'] and stat['last_db_import']:
                                data['last_import'] = stat['last_db_import'].isoformat()
                        else:
                            data['branch_count'] = 0
                            data['product_count'] = 0

            finally:
                conn.close()
        
        return {"sources": status}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/enable")
async def enable_source(request: SourceToggleRequest):
    """Enable a data source"""
    try:
        registry = get_registry()
        registry.enable(request.source_id)
        return {"status": "success", "message": f"{request.source_id} enabled"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/disable")
async def disable_source(request: SourceToggleRequest):
    """Disable a data source"""
    try:
        registry = get_registry()
        registry.disable(request.source_id, reason="Manual disable from UI")
        return {"status": "success", "message": f"{request.source_id} disabled"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/import")
async def import_from_source(request: ImportRequest, background_tasks: BackgroundTasks):
    """Run import from a specific source in BACKGROUND"""
    try:
        registry = get_registry()
        scraper = registry.get(request.source_id)
        
        if not scraper:
            raise HTTPException(status_code=404, detail=f"Source {request.source_id} not found or disabled")
        
        # Define the background job
        def run_job(scraper_ref, limit_cnt):
            try:
                if hasattr(scraper_ref, 'scrape_latest'):
                    products = scraper_ref.scrape_latest(max_files=limit_cnt)
                    count = len(products) if products else 0
                elif hasattr(scraper_ref, 'run_full_import'):
                    result = scraper_ref.run_full_import(limit=limit_cnt)
                    count = result.get('products_count', 0) if result else 0
                else:
                    return # Not supported
                
                # Update last import time
                from datetime import datetime
                registry.update_last_import(request.source_id, datetime.now())
                
            except Exception as e:
                import logging
                logging.getLogger(__name__).error(f"Background import failed for {request.source_id}: {e}")

        # Schedule the job
        background_tasks.add_task(run_job, scraper, request.limit)
        
        return {
            "status": "started",
            "message": f"Import started for {request.source_id} (Background)",
            "source_id": request.source_id
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/import-all")
async def import_all_sources():
    """Run parallel import from all enabled sources"""
    try:
        import subprocess
        from pathlib import Path
        
        # Get script path
        script_path = Path(__file__).parent.parent.parent / "scripts" / "import_all_sources_parallel.py"
        
        if not script_path.exists():
            raise HTTPException(status_code=500, detail="Import script not found")
        
        # Run in background
        process = subprocess.Popen(
            [sys.executable, str(script_path)],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        # Don't wait - return immediately
        return {
            "status": "started",
            "message": "Parallel import started in background",
            "pid": process.pid
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
