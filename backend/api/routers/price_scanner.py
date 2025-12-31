from fastapi import APIRouter, HTTPException, BackgroundTasks
from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
import psycopg2
import os
import uuid
import subprocess

router = APIRouter(
    prefix="/scanner",
    tags=["Price Scanner"]
)

# --- Models ---
class SourceCreate(BaseModel):
    domain: str
    sitemap_url: str
    required_country: Optional[str] = None

class SourceResponse(BaseModel):
    id: str
    domain: str
    sitemap_url: str
    discovery_status: str
    last_scan_at: Optional[datetime]
    products_found: int
    success_rate: float

# --- DB Helper ---
def get_db_connection():
    return psycopg2.connect(
        dbname=os.getenv('DB_NAME', 'gogobe'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', '9152245-Gl!'),
        host=os.getenv('DB_HOST', 'localhost'),
        port=os.getenv('DB_PORT', '5432')
    )

# --- Routes ---

@router.get("/sources", response_model=List[SourceResponse])
def list_sources():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT id, domain, sitemap_url, discovery_status, last_scan_at, products_found, success_rate 
        FROM source_discovery_tracking 
        ORDER BY created_at DESC
    """)
    rows = cur.fetchall()
    cur.close()
    conn.close()
    
    results = []
    for row in rows:
        results.append(SourceResponse(
            id=str(row[0]),
            domain=row[1],
            sitemap_url=row[2],
            discovery_status=row[3],
            last_scan_at=row[4],
            products_found=row[5],
            success_rate=row[6]
        ))
    return results

@router.post("/sources", response_model=SourceResponse)
def add_source(source: SourceCreate):
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        cur.execute("""
            INSERT INTO source_discovery_tracking (domain, sitemap_url, required_country, discovery_status)
            VALUES (%s, %s, %s, 'PENDING')
            RETURNING id, domain, sitemap_url, discovery_status, last_scan_at, products_found, success_rate
        """, (source.domain, source.sitemap_url, source.required_country))
        row = cur.fetchone()
        conn.commit()
    except psycopg2.errors.UniqueViolation:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Domain already exists")
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cur.close()
        conn.close()
        
    return SourceResponse(
        id=str(row[0]),
        domain=row[1],
        sitemap_url=row[2],
        discovery_status=row[3],
        last_scan_at=row[4],
        products_found=row[5],
        success_rate=row[6]
    )

def run_scrapy_task(domain: str, sitemap_url: str, source_id: str):
    # This is a naive implementation. Ideally this should be a Celery task or Producer logic.
    # We update status to SCANNING
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("UPDATE source_discovery_tracking SET discovery_status = 'SCANNING' WHERE id = %s", (source_id,))
    conn.commit()
    conn.close()
    
    # Run Scrapy subprocess
    # Note: We are running inside Docker, so paths should be absolute
    cmd = [
        "scrapy", "crawl", "price_hunter",
        "-a", f"domain={domain}",
        "-a", f"sitemap_url={sitemap_url}",
        "-a", f"source_id={source_id}"
    ]
    
    try:
        # Run inside the scanner directory
        subprocess.run(
            cmd, 
            cwd="/app/backend/price_scanner", 
            check=True,
            capture_output=True
        )
        # We assume the pipeline updates the success metrics / products found
        # But we need to update status to ACTIVE or IDLE
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("UPDATE source_discovery_tracking SET discovery_status = 'ACTIVE', last_scan_at = NOW() WHERE id = %s", (source_id,))
        conn.commit()
        conn.close()
        
    except subprocess.CalledProcessError as e:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("UPDATE source_discovery_tracking SET discovery_status = 'ERROR' WHERE id = %s", (source_id,))
        conn.commit()
        conn.close()
        print(f"Scrapy Error: {e.stderr.decode()}")


@router.post("/sources/{source_id}/scan")
def trigger_scan(source_id: str, background_tasks: BackgroundTasks):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT domain, sitemap_url FROM source_discovery_tracking WHERE id = %s", (source_id,))
    row = cur.fetchone()
    cur.close()
    conn.close()
    
    if not row:
        raise HTTPException(status_code=404, detail="Source not found")
        
    domain, sitemap_url = row
    
    # Add to background
    background_tasks.add_task(run_scrapy_task, domain, sitemap_url, source_id)
    
    return {"message": "Scan triggered in background"}
