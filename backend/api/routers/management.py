
from fastapi import APIRouter, HTTPException, Body
from typing import Optional, List
from pydantic import BaseModel
import psycopg2
from psycopg2.extras import RealDictCursor
import os
import logging
import json

router = APIRouter(prefix="/api", tags=["management"])

# Database configuration (Duplicated from main.py for independence or should be shared)
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'), # In Docker
    'port': os.getenv('DB_PORT', '5432'),
    'client_encoding': 'UTF8'
}

# Fallback for local dev
if os.getenv('DB_HOST') is None:
    DB_CONFIG['host'] = 'localhost'

def get_db_connection():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except Exception as e:
        print(f"Database connection error: {e}")
        return None

# --- Models ---
class TaskCreate(BaseModel):
    description: str
    priority: str = "normal"
    status: str = "pending"

class TaskUpdate(BaseModel):
    status: Optional[str] = None
    priority: Optional[str] = None
    description: Optional[str] = None

class ChainUpdate(BaseModel):
    chain_code: Optional[str] = None
    source_platform: Optional[str] = None
    is_active: Optional[bool] = None
    login_user: Optional[str] = None
    login_pass: Optional[str] = None

# --- Tasks Routes ---

@router.get("/tasks")
async def get_tasks():
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="DB Error")
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT * FROM project_tasks ORDER BY created_at DESC")
            tasks = cur.fetchall()
            return {"tasks": tasks}
    finally:
        conn.close()

@router.post("/tasks")
async def create_task(task: TaskCreate):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="DB Error")
    try:
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO project_tasks (description, priority, status) VALUES (%s, %s, %s) RETURNING id",
            (task.description, task.priority, task.status)
        )
        new_id = cur.fetchone()[0]
        conn.commit()
        return {"id": new_id, "status": "created"}
    finally:
        conn.close()

@router.put("/tasks/{task_id}/status")
async def update_task_status(task_id: int, update: TaskUpdate):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="DB Error")
    try:
        cur = conn.cursor()
        if update.status:
            completed_at = 'NOW()' if update.status == 'done' else 'NULL'
            # Use safe interpolation for completed_at via logic inside query or separate update
            if update.status == 'done':
                cur.execute("UPDATE project_tasks SET status = %s, completed_at = NOW() WHERE id = %s", (update.status, task_id))
            else:
                 cur.execute("UPDATE project_tasks SET status = %s, completed_at = NULL WHERE id = %s", (update.status, task_id))
        conn.commit()
        return {"status": "updated"}
    finally:
        conn.close()

# --- Chains Routes (Management Extensions) ---

@router.put("/chains/{chain_id}")
async def update_chain(chain_id: int, chain: ChainUpdate):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="DB Error")
    try:
        cur = conn.cursor()
        
        updates = []
        params = []
        
        if chain.chain_code is not None:
            updates.append("chain_code = %s")
            params.append(chain.chain_code)
            
        if chain.source_platform is not None:
            updates.append("source_platform = %s")
            params.append(chain.source_platform)
            
        if chain.is_active is not None:
            updates.append("is_active = %s")
            params.append(chain.is_active)
            
        # Handle Credentials JSON
        if chain.login_user is not None or chain.login_pass is not None:
            # First fetch existing
            cur.execute("SELECT login_credentials FROM store_chains WHERE id = %s", (chain_id,))
            res = cur.fetchone()
            creds = res[0] if res and res[0] else {}
            if isinstance(creds, str): creds = json.loads(creds)
            
            if chain.login_user is not None: creds['user'] = chain.login_user
            if chain.login_pass is not None: creds['pass'] = chain.login_pass
            
            updates.append("login_credentials = %s")
            params.append(json.dumps(creds))
            
        if not updates:
            return {"status": "no changes"}
            
        params.append(chain_id)
        query = f"UPDATE store_chains SET {', '.join(updates)} WHERE id = %s"
        
        cur.execute(query, tuple(params))
        conn.commit()
        return {"status": "updated"}
    finally:
        conn.close()

# Serves new pages
from fastapi.responses import FileResponse
from pathlib import Path

@router.get("/sources.html")
async def sources_page():
    frontend_path = Path(os.getcwd()) / "frontend" / "sources.html"
    return FileResponse(frontend_path)

@router.get("/tasks.html")
async def tasks_page():
    frontend_path = Path(os.getcwd()) / "frontend" / "tasks.html"
    return FileResponse(frontend_path)

# --- SYSTEM MAINTENANCE & STATS ---

@router.post("/management/db-migrate")
async def run_db_migration():
    """
    Apply schematic changes (add columns) safely from within the container context.
    """
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="DB Error")
    try:
        cur = conn.cursor()
        logging.info("Checking if 'price_change_24h' exists...")
        cur.execute("SELECT column_name FROM information_schema.columns WHERE table_name='products' AND column_name='price_change_24h';")
        if not cur.fetchone():
            logging.info("Adding column 'price_change_24h' to products table...")
            cur.execute("ALTER TABLE products ADD COLUMN price_change_24h NUMERIC(5,2) DEFAULT 0;")
            cur.execute("CREATE INDEX IF NOT EXISTS idx_price_change ON products(price_change_24h);")
            conn.commit()
            return {"status": "migration_applied", "details": "Added price_change_24h column"}
        else:
            return {"status": "skipped", "details": "Column already exists"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()

@router.post("/management/stats/recalc")
async def recalculate_product_stats():
    """
    HEAVY BATCH JOB: Updates 'price_change_24h' for ALL products.
    Should be triggered after bulk ingestion.
    """
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="DB Error")
    try:
        cur = conn.cursor()
        
        # SQL Logic: Update products based on comparison of Today vs Yesterday Avg Price
        sql = """
        WITH TodayStats AS (
            SELECT product_id, AVG(price) as today_avg
            FROM prices 
            WHERE scraped_at >= NOW() - INTERVAL '24 hours'
            GROUP BY product_id
        ),
        YesterdayStats AS (
            SELECT product_id, AVG(price) as yest_avg
            FROM prices 
            WHERE scraped_at BETWEEN NOW() - INTERVAL '48 hours' AND NOW() - INTERVAL '24 hours'
            GROUP BY product_id
        )
        UPDATE products p
        SET price_change_24h = ((t.today_avg - y.yest_avg) / y.yest_avg) * 100
        FROM TodayStats t
        JOIN YesterdayStats y ON t.product_id = y.product_id
        WHERE p.id = t.product_id
        AND y.yest_avg > 0;
        """
        
        cur.execute(sql)
        affected = cur.rowcount
        conn.commit()
        return {"status": "success", "products_updated": affected}
        
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()


@router.post("/management/run-script")
async def run_backend_script(script_name: str = Body(..., embed=True)):
    """
    GOD MODE: Execute a Python script inside the backend container.
    """
    import subprocess
    import sys
    
    # SIMPLIFIED PATH RESOLUTION
    # Try multiple common locations
    possible_paths = [
        Path(os.getcwd()) / "scripts" / script_name,        # ./scripts/foo.py
        Path(os.getcwd()) / script_name,                    # ./foo.py
        Path("/app/scripts") / script_name,                 # Docker standard
        Path("c:/Users/shake/Limor Shaked Dropbox/LIMOR SHAKED ADVANCED COSMETICS LTD/Gogobe/scripts") / script_name # Hardcoded fallback
    ]
    
    script_path = None
    for p in possible_paths:
        if p.exists():
            script_path = p
            break
            
    if not script_path:
         raise HTTPException(status_code=404, detail=f"Script not found. Searched in: {[str(p) for p in possible_paths]}")
        
    try:
        # Run script
        result = subprocess.run(
            [sys.executable, str(script_path)],
            capture_output=True,
            text=True,
            timeout=300
        )
        return {
            "status": "success" if result.returncode == 0 else "error",
            "stdout": result.stdout,
            "stderr": result.stderr
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/management/run-sql")
async def run_raw_sql(sql_query: str = Body(..., embed=True)):
    """
    ULTIMATE BYPASS: Run raw SQL directly against the DB.
    Use with caution.
    """
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="DB Error")
    try:
        cur = conn.cursor()
        cur.execute(sql_query)
        try:
            conn.commit()
            if cur.description:
                res = cur.fetchall()
                return {"status": "success", "rows": res}
            else:
                return {"status": "success", "rows_affected": cur.rowcount}
        except Exception as e:
            conn.rollback()
            raise e
    except Exception as e:
        return {"status": "error", "message": str(e)}
    finally:
        conn.close()


