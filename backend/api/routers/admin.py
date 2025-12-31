from fastapi import APIRouter, HTTPException, Depends
from typing import List, Optional
from pydantic import BaseModel
import sys
import os
import logging

logger = logging.getLogger(__name__)

# Add app root to path to import database module
import os
import sys

# Get the absolute path of the current file's directory
current_dir = os.path.dirname(os.path.abspath(__file__))
# Navigate up to the root (backend/api/routers -> backend/api -> backend -> root)
# Actually backend/api/routers is 3 levels deep from root if root is /app
app_root = os.path.abspath(os.path.join(current_dir, "..", "..", ".."))
if app_root not in sys.path:
    sys.path.insert(0, app_root)

try:
    from backend.database.db_connection import get_db_cursor
except ImportError:
    # Fallback for local dev if structure is different
    from database.db_connection import get_db_cursor

router = APIRouter(
    prefix="/api/admin",
    tags=["admin"]
)

# Models
class CreateMasterRequest(BaseModel):
    product_id: int

class LinkProductRequest(BaseModel):
    master_id: int
    product_id: int
    confidence: float = 1.0
    method: str = 'manual'

class MergeMastersRequest(BaseModel):
    source_master_id: int
    target_master_id: int

class UpdateMasterRequest(BaseModel):
    id: int
    name: Optional[str] = None
    description: Optional[str] = None
    main_image_url: Optional[str] = None

class MasterProduct(BaseModel):
    id: int
    name: str
    description: Optional[str] = None
    links_count: int = 0

class BulkReviewRequest(BaseModel):
    link_ids: List[int]
    approve: bool

@router.get("/masters/stats")
async def get_master_stats():
    """Get statistics for Master Product Management dashboard"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        stats = {
            "total_masters": 0,
            "linked_products": 0,
            "orphan_products": 0,
            "total_products": 0
        }
        
        # Total Masters
        cur.execute("SELECT COUNT(*) as cnt FROM master_products")
        stats['total_masters'] = cur.fetchone()['cnt']
        
        # Product Stats
        # linked = has master_product_id OR exists in link table
        # We use the products table cache column master_product_id for speed
        cur.execute("""
            SELECT 
                COUNT(*) as total,
                COUNT(master_product_id) as linked
            FROM products
        """)
        res = cur.fetchone()
        stats['total_products'] = res['total']
        stats['linked_products'] = res['linked']
        stats['orphan_products'] = res['total'] - res['linked']
        
        return stats
    finally:
        cur.close()
        conn.close()

# Endpoints

@router.post("/masters/create")
async def create_master_product(request: CreateMasterRequest):
    """Promote a product to be a Master Product"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        # 1. Get product details
        cur.execute("SELECT * FROM products WHERE id = %s", (request.product_id,))
        product = cur.fetchone()
        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        # 2. Check for duplicate name (Strict: Trim + Lower)
        cur.execute("SELECT id FROM master_products WHERE LOWER(TRIM(name)) = LOWER(TRIM(%s))", (product['name'],))
        existing = cur.fetchone()
        if existing:
            # Instead of error, we can just link to existing
            master_id = existing['id']
            logger.info(f"Master with name '{product['name']}' already exists. Linking to ID: {master_id}")
        else:
            # Create Master Product
            cur.execute("""
                INSERT INTO master_products (name, main_image_url, description)
                VALUES (%s, %s, %s)
                RETURNING id
            """, (product['name'], product.get('main_image_url'), product.get('description')))
            master_id = cur.fetchone()['id']

        # 3. Link original product to this master
        cur.execute("""
            INSERT INTO product_master_links (master_product_id, product_id, match_method)
            VALUES (%s, %s, 'manual_promotion')
        """, (master_id, request.product_id))
        
        # 4. Update prices linkage
        cur.execute("""
            UPDATE prices SET master_product_id = %s WHERE product_id = %s
        """, (master_id, request.product_id))
        
        # 5. Update original product master reference
        cur.execute("""
            UPDATE products SET master_product_id = %s WHERE id = %s
        """, (master_id, request.product_id))

        conn.commit()
        return {"status": "success", "master_id": master_id, "message": "Product promoted to master"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cur.close()
        conn.close()

@router.post("/masters/link")
async def link_product_to_master(request: LinkProductRequest):
    """Link a product to an existing Master"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        # Check if link exists
        cur.execute("SELECT id FROM product_master_links WHERE product_id = %s", (request.product_id,))
        existing = cur.fetchone()
        
        if existing:
            # Update existing link
            cur.execute("""
                UPDATE product_master_links 
                SET master_product_id = %s, match_method = %s, confidence_score = %s 
                WHERE product_id = %s
            """, (request.master_id, request.method, request.confidence, request.product_id))
        else:
            # Create new link
            cur.execute("""
                INSERT INTO product_master_links (master_product_id, product_id, confidence_score, match_method)
                VALUES (%s, %s, %s, %s)
            """, (request.master_id, request.product_id, request.confidence, request.method))

        # Update prices
        cur.execute("""
            UPDATE prices SET master_product_id = %s WHERE product_id = %s
        """, (request.master_id, request.product_id))
        
        # Update product
        cur.execute("""
            UPDATE products SET master_product_id = %s WHERE id = %s
        """, (request.master_id, request.product_id))

        conn.commit()
        return {"status": "success", "message": "Product linked to master"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cur.close()
        conn.close()

@router.post("/masters/unlink")
async def unlink_product_from_master(request: CreateMasterRequest):
    """Unlink a product from its master"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        # 1. Remove link
        cur.execute("DELETE FROM product_master_links WHERE product_id = %s", (request.product_id,))
        
        # 2. Update prices linkage (nullify)
        cur.execute("UPDATE prices SET master_product_id = NULL WHERE product_id = %s", (request.product_id,))
        
        # 3. Update product reference
        cur.execute("UPDATE products SET master_product_id = NULL WHERE id = %s", (request.product_id,))

        conn.commit()
        return {"status": "success", "message": "Product unlinked from master"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cur.close()
        conn.close()

# AI / LLM Endpoints
from backend.scripts.llm.match_products import run_matching_job

@router.post("/ai/run")
async def run_ai_matching(limit: int = 50):
    """Trigger AI matching job (simplified for sync execution)"""
    try:
        # In a real app, this should be a background task (Celery/redis-queue)
        # Here we run a small batch synchronously
        run_matching_job() 
        return {"status": "success", "message": f"AI job verified/processed items"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/ai/pending")
async def get_pending_matches():
    """Get pending AI matches for review"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        cur.execute("""
            SELECT 
                l.id as link_id,
                l.confidence_score,
                p.name as product_name,
                p.id as product_id,
                m.name as master_name,
                m.id as master_id
            FROM product_master_links l
            JOIN products p ON l.product_id = p.id
            JOIN master_products m ON l.master_product_id = m.id
            WHERE l.match_method = 'llm_pending'
            ORDER BY l.confidence_score DESC
            LIMIT 100
        """)
        return {"matches": cur.fetchall()}
    finally:
        cur.close()
        conn.close()

class ApproveMatchRequest(BaseModel):
    link_id: int
    approve: bool

@router.post("/ai/review")
async def review_match(request: ApproveMatchRequest):
    """Approve or Reject an AI match and record feedback"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        # Get link info before MOD/DEL
        cur.execute("SELECT product_id, master_product_id FROM product_master_links WHERE id = %s", (request.link_id,))
        link = cur.fetchone()
        if not link:
            raise HTTPException(status_code=404, detail="Link not found")

        if request.approve:
            # 1. Approve link
            cur.execute("""
                UPDATE product_master_links 
                SET match_method = 'manual_approved', confidence_score = 1.0
                WHERE id = %s
            """, (request.link_id,))
            
            # 2. Record feedback
            cur.execute("""
                INSERT INTO matching_feedback (product_id, master_product_id, feedback_type)
                VALUES (%s, %s, 'approve')
            """, (link['product_id'], link['master_product_id']))
            msg = "Approved"
        else:
            # 1. Record feedback (REJECT)
            cur.execute("""
                INSERT INTO matching_feedback (product_id, master_product_id, feedback_type)
                VALUES (%s, %s, 'reject')
            """, (link['product_id'], link['master_product_id']))
            
            # 2. Delete the link
            cur.execute("DELETE FROM product_master_links WHERE id = %s", (request.link_id,))
            msg = "Rejected"
            
        conn.commit()
        return {"status": "success", "message": msg}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cur.close()
        conn.close()

@router.post("/ai/review-bulk")
async def review_match_bulk(request: BulkReviewRequest):
    """Approve or Reject multiple AI matches at once"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        if not request.link_ids:
            return {"status": "success", "message": "No items to process"}

        # Fetch link details for feedback recording
        cur.execute("SELECT product_id, master_product_id FROM product_master_links WHERE id = ANY(%s)", (request.link_ids,))
        links = cur.fetchall()

        if request.approve:
            # 1. Update links
            cur.execute("""
                UPDATE product_master_links 
                SET match_method = 'manual_approved', confidence_score = 1.0
                WHERE id = ANY(%s)
            """, (request.link_ids,))
            
            # 2. Record feedback
            feedback_data = [(l['product_id'], l['master_product_id'], 'approve') for l in links]
            cur.executemany("INSERT INTO matching_feedback (product_id, master_product_id, feedback_type) VALUES (%s, %s, %s)", feedback_data)
        else:
            # 1. Record feedback (REJECT)
            feedback_data = [(l['product_id'], l['master_product_id'], 'reject') for l in links]
            cur.executemany("INSERT INTO matching_feedback (product_id, master_product_id, feedback_type) VALUES (%s, %s, %s)", feedback_data)
            
            # 2. Delete links
            cur.execute("DELETE FROM product_master_links WHERE id = ANY(%s)", (request.link_ids,))

        conn.commit()
        return {"status": "success", "message": f"Processed {len(links)} items"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cur.close()
        conn.close()

@router.get("/masters/search")
async def search_masters(q: str = ""):
    """Search for master products"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        query = """
            SELECT m.*, COUNT(l.id) as child_count 
            FROM master_products m
            LEFT JOIN product_master_links l ON m.id = l.master_product_id
            WHERE m.name ILIKE %s
            GROUP BY m.id
            ORDER BY m.name
            LIMIT 20
        """
        cur.execute(query, (f"%{q}%",))
        results = cur.fetchall()
        return {"masters": results}
    finally:
        cur.close()
        conn.close()

@router.get("/masters/{master_id}")
async def get_master_details(master_id: int):
    """Get full details of a master product, its children, and all prices"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        # 1. Master Info
        cur.execute("SELECT * FROM master_products WHERE id = %s", (master_id,))
        master = cur.fetchone()
        if not master:
            raise HTTPException(status_code=404, detail="Master product not found")
        
        # 2. Children (Products)
        cur.execute("""
            SELECT p.*, l.confidence_score, l.match_method, l.id as link_id
            FROM products p
            JOIN product_master_links l ON p.id = l.product_id
            WHERE l.master_product_id = %s
        """, (master_id,))
        children = cur.fetchall()
        
        # 3. Prices (Consolidated from all children)
        cur.execute("""
            SELECT pr.*, s.name as store_name, p.name as product_name
            FROM prices pr
            JOIN products p ON pr.product_id = p.id
            JOIN product_master_links l ON p.id = l.product_id
            LEFT JOIN stores s ON pr.store_id = s.id
            WHERE l.master_product_id = %s
            ORDER BY pr.price ASC
        """, (master_id,))
        prices = cur.fetchall()
        
        return {
            "master": master,
            "children": children,
            "prices": prices
        }
    finally:
        cur.close()
        conn.close()

@router.post("/masters/update")
async def update_master_product(request: UpdateMasterRequest):
    """Update master product details"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        if request.name:
            # Check for name collision (Strict: Trim + Lower)
            cur.execute("SELECT id FROM master_products WHERE LOWER(TRIM(name)) = LOWER(TRIM(%s)) AND id != %s", (request.name, request.id))
            if cur.fetchone():
                raise HTTPException(status_code=400, detail=f"שם אב מוצר '{request.name}' כבר קיים במערכת. בחר שם אחר או בצע איחוד.")

        cur.execute("""
            UPDATE master_products 
            SET name = COALESCE(%s, name),
                description = COALESCE(%s, description),
                main_image_url = COALESCE(%s, main_image_url)
            WHERE id = %s
        """, (request.name, request.description, request.main_image_url, request.id))
        conn.commit()
        return {"status": "success", "message": "Master product updated"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
@router.post("/masters/merge")
async def merge_master_products(request: MergeMastersRequest):
    """Merge source master into target master"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        # 1. Update all links pointing to source to point to target
        cur.execute("""
            UPDATE product_master_links 
            SET master_product_id = %s 
            WHERE master_product_id = %s
        """, (request.target_master_id, request.source_master_id))
        
        # 2. Update all prices
        cur.execute("""
            UPDATE prices 
            SET master_product_id = %s 
            WHERE master_product_id = %s
        """, (request.target_master_id, request.source_master_id))
        
        # 3. Update all products
        cur.execute("""
            UPDATE products 
            SET master_product_id = %s 
            WHERE master_product_id = %s
        """, (request.target_master_id, request.source_master_id))

        # 4. Update matching feedback
        cur.execute("""
            UPDATE matching_feedback 
            SET master_product_id = %s 
            WHERE master_product_id = %s
        """, (request.target_master_id, request.source_master_id))
        
        # 5. Delete the source master
        cur.execute("DELETE FROM master_products WHERE id = %s", (request.source_master_id,))
        
        conn.commit()
        return {"status": "success", "message": "Masters merged successfully"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cur.close()
        conn.close()
@router.post("/masters/cleanup")
async def cleanup_master_duplicates():
    """
    Automatically merge all master products that have the exact same name 
    (case-insensitive and trimmed).
    """
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        # 1. Find duplicate groups
        cur.execute("""
            WITH groups AS (
                SELECT LOWER(TRIM(name)) as clean_name, array_agg(id ORDER BY created_at ASC) as ids
                FROM master_products
                GROUP BY LOWER(TRIM(name))
                HAVING COUNT(*) > 1
            )
            SELECT * FROM groups
        """)
        duplicate_groups = cur.fetchall()
        
        merged_count = 0
        for group in duplicate_groups:
            ids = group['ids']
            target_id = ids[0] # Keep the oldest one
            source_ids = ids[1:]
            
            for source_id in source_ids:
                # Update links
                cur.execute("UPDATE product_master_links SET master_product_id = %s WHERE master_product_id = %s", (target_id, source_id))
                # Update prices
                cur.execute("UPDATE prices SET master_product_id = %s WHERE master_product_id = %s", (target_id, source_id))
                # Update products
                cur.execute("UPDATE products SET master_product_id = %s WHERE master_product_id = %s", (target_id, source_id))
                # Update feedback
                cur.execute("UPDATE matching_feedback SET master_product_id = %s WHERE master_product_id = %s", (target_id, source_id))
                # Delete source
                cur.execute("DELETE FROM master_products WHERE id = %s", (source_id,))
                merged_count += 1
        
        conn.commit()
        return {"status": "success", "message": f"Merged {merged_count} duplicate master products."}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cur.close()
        conn.close()
@router.post("/run-pipeline")
async def run_pipeline():
    """
    Trigger the daily pipeline script (Import -> Categorize -> QC -> Report)
    Runs in the background.
    """
    import subprocess
    import sys
    
    script_path = os.path.join(app_root, "backend", "scripts", "run_pipeline.py")
    
    if not os.path.exists(script_path):
        # Fallback for different CWD
        script_path = os.path.join(os.getcwd(), "backend", "scripts", "run_pipeline.py")
        
    if not os.path.exists(script_path):
         raise HTTPException(status_code=404, detail=f"Pipeline script not found at {script_path}")

    try:
        # Run in independent process (DETACHED) so it survives if API restarts logic is complex, 
        # but for now just Popen is enough to return immediately.
        # using sys.executable to ensure same python env
        subprocess.Popen([sys.executable, script_path], 
                         stdout=subprocess.DEVNULL, 
                         stderr=subprocess.DEVNULL)
        
        return {"status": "success", "message": "Pipeline started in background"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
