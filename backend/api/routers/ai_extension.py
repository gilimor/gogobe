"""
AI Matching API Extension
Additional endpoint for AI stats and reviews
"""
from fastapi import APIRouter, HTTPException, BackgroundTasks
from pydantic import BaseModel
import sys
import os
import logging
from typing import List

# Get database connection
current_dir = os.path.dirname(os.path.abspath(__file__))
app_root = os.path.abspath(os.path.join(current_dir, "..", "..", ".."))
if app_root not in sys.path:
    sys.path.insert(0, app_root)

try:
    from backend.database.db_connection import get_db_cursor
    from backend.services.master_product_matcher import MasterProductMatcher
except ImportError:
    from database.db_connection import get_db_cursor
    from services.master_product_matcher import MasterProductMatcher

logger = logging.getLogger(__name__)

router = APIRouter(
    prefix="/api/admin",
    tags=["ai-extension"]
)

class ReviewRequest(BaseModel):
    link_id: int
    approve: bool

class BulkReviewRequest(BaseModel):
    link_ids: List[int]
    approve: bool

@router.get("/ai/stats")
async def get_ai_stats():
    """Get AI matching statistics"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        # Pending matches
        cur.execute("""
            SELECT COUNT(*) as count FROM product_master_links 
            WHERE match_method = 'llm_pending'
        """)
        pending_result = cur.fetchone()
        pending = pending_result['count'] if pending_result else 0
        
        # Approved matches
        cur.execute("""
            SELECT COUNT(*) as count FROM product_master_links 
            WHERE match_method = 'manual_approved'
        """)
        approved_result = cur.fetchone()
        approved = approved_result['count'] if approved_result else 0
        
        # Rejected matches (from feedback)
        # Note: If matching_feedback table doesn't exist yet, catch error
        rejected = 0
        try:
            cur.execute("""
                SELECT COUNT(*) as count FROM matching_feedback 
                WHERE feedback_type = 'reject'
            """)
            rejected_result = cur.fetchone()
            rejected = rejected_result['count'] if rejected_result else 0
        except Exception:
            conn.rollback()
        
        # Total products with AI suggestions
        cur.execute("""
            SELECT COUNT(DISTINCT product_id) as count FROM product_master_links 
            WHERE match_method IN ('llm_pending', 'llm_suggested', 'manual_approved', 'embedding')
        """)
        total_result = cur.fetchone()
        total = total_result['count'] if total_result else 0
        
        return {
            "pending": pending,
            "approved": approved,
            "rejected": rejected,
            "total": total
        }
    except Exception as e:
        logger.error(f"Error fetching AI stats: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cur.close()
        conn.close()

@router.get("/ai/pending")
async def get_pending_matches():
    """Get pending matches for review"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        # Fetch pending links with product and master info
        query = """
            SELECT 
                l.id as link_id,
                l.product_id,
                l.confidence_score,
                l.link_method as method,
                p.name as product_name,
                p.ean as product_ean,
                l.master_product_id as master_id,
                m.global_name as master_name
            FROM product_master_links l
            JOIN products p ON l.product_id = p.id
            JOIN master_products m ON l.master_product_id = m.id
            WHERE l.match_method IN ('llm_pending', 'llm_suggested', 'embedding')
            ORDER BY l.confidence_score DESC
            LIMIT 50
        """
        cur.execute(query)
        matches = cur.fetchall()
        return {"matches": matches}
    except Exception as e:
        logger.error(f"Error fetching pending matches: {e}")
        return {"matches": []}
    finally:
        cur.close()
        conn.close()


@router.post("/ai/review")
async def review_match(request: ReviewRequest):
    """Approve or reject a specific match"""
    conn, cur = get_db_cursor()
    try:
        if request.approve:
            # Update link status to manual_approved
            cur.execute("""
                UPDATE product_master_links 
                SET match_method = 'manual_approved'
                WHERE id = %s
            """, (request.link_id,))
        else:
            # Remove link and log rejection
            # First get details for feedback log
            cur.execute("SELECT product_id, master_product_id FROM product_master_links WHERE id = %s", (request.link_id,))
            row = cur.fetchone()
            if row:
                pid, mid = row
                try:
                    cur.execute("""
                        INSERT INTO matching_feedback (product_id, master_product_id, feedback_type)
                        VALUES (%s, %s, 'reject')
                    """, (pid, mid))
                except Exception:
                    conn.rollback() # Ignore if feedback table missing

                # Delete the link
                cur.execute("DELETE FROM product_master_links WHERE id = %s", (request.link_id,))
        
        conn.commit()
        return {"status": "success"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cur.close()
        conn.close()

@router.post("/ai/bulk-review")
async def bulk_review(request: BulkReviewRequest):
    """Bulk approve or reject matches"""
    conn, cur = get_db_cursor()
    try:
        if request.approve:
            cur.execute("""
                UPDATE product_master_links 
                SET match_method = 'manual_approved'
                WHERE id = ANY(%s)
            """, (request.link_ids,))
        else:
            # For rejection, we should log feedback but for bulk maybe just delete
            cur.execute("DELETE FROM product_master_links WHERE id = ANY(%s)", (request.link_ids,))
            
        conn.commit()
        return {"status": "success"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cur.close()
        conn.close()

def run_matcher_task(use_ai=True):
    """Background task to run matcher"""
    try:
        # Config
        db_config = {
            'dbname': os.getenv('DB_NAME', 'gogobe'),
            'user': os.getenv('DB_USER', 'postgres'),
            'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
            'host': os.getenv('DB_HOST', 'db'),
            'port': os.getenv('DB_PORT', '5432')
        }
        
        matcher = MasterProductMatcher(db_config, use_ai=use_ai)
        
        # Find unmatched products
        # This is a bit heavy, so we limit to 50
        conn = psycopg2.connect(**db_config)
        cur = conn.cursor()
        
        cur.execute("""
            SELECT p.id 
            FROM products p
            LEFT JOIN product_master_links l ON p.id = l.product_id
            WHERE p.is_active = TRUE AND l.id IS NULL
            LIMIT 50
        """)
        
        product_ids = [r[0] for r in cur.fetchall()]
        cur.close()
        conn.close()
        
        if product_ids:
            logger.info(f"Running background matching for {len(product_ids)} products")
            matcher.match_batch(product_ids)
            
    except Exception as e:
        logger.error(f"Background matching failed: {e}")

@router.post("/ai/run")
async def run_ai_job(background_tasks: BackgroundTasks):
    """Trigger background matching"""
    background_tasks.add_task(run_matcher_task, use_ai=True)
    return {"status": "started", "message": "AI matching job started in background"}

@router.get("/masters/stats")
async def get_master_stats():
    """Get master product statistics"""
    conn, cur = get_db_cursor(dict_cursor=True)
    try:
        # Total masters
        cur.execute("SELECT COUNT(*) as count FROM master_products")
        total_masters = cur.fetchone()['count'] or 0
        
        # Total linked products
        cur.execute("""
            SELECT COUNT(DISTINCT product_id) as count 
            FROM product_master_links
        """)
        linked_products = cur.fetchone()['count'] or 0
        
        # Orphan products (no master)
        cur.execute("""
            SELECT COUNT(*) as count FROM products 
            WHERE master_product_id IS NULL AND is_active = TRUE
        """)
        # Note: products table might not have master_product_id column if we use link table
        # If link table is source of truth, orphan is products NOT IN link table
        
        # Check if master_product_id column exists
        has_col = False
        try:
            cur.execute("SELECT master_product_id FROM products LIMIT 1")
            has_col = True
        except:
            conn.rollback()

        if has_col:
             orphan_products = cur.fetchone()['count'] or 0
        else:
             # Use link table logic
             cur.execute("""
                SELECT COUNT(*) as count FROM products p
                LEFT JOIN product_master_links l ON p.id = l.product_id
                WHERE p.is_active = TRUE AND l.id IS NULL
             """)
             orphan_products = cur.fetchone()['count'] or 0
        
        # Total products
        cur.execute("SELECT COUNT(*) as count FROM products WHERE is_active = TRUE")
        total_products = cur.fetchone()['count'] or 0
        
        return {
            "total_masters": total_masters,
            "linked_products": linked_products,
            "orphan_products": orphan_products,
            "total_products": total_products
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cur.close()
        conn.close()
