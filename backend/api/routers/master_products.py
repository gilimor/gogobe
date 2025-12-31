from fastapi import APIRouter, HTTPException, Query
from typing import List, Optional, Dict
import psycopg2
from psycopg2.extras import RealDictCursor
import os
from pydantic import BaseModel

router = APIRouter()

# Database Config
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432')
}

class MasterProduct(BaseModel):
    id: int
    global_name: str
    global_ean: Optional[str]
    linked_count: int
    confidence_score: Optional[float] = None

class MasterProductResponse(BaseModel):
    data: List[MasterProduct]
    meta: Dict

def get_db_connection():
    return psycopg2.connect(**DB_CONFIG)

@router.get("/", response_model=MasterProductResponse)
def get_master_products(
    page: int = 1,
    limit: int = 50,
    search: Optional[str] = None,
    sort_by: str = 'linked_count',
    order: str = 'desc'
):
    offset = (page - 1) * limit
    conn = get_db_connection()
    
    # Safe Sort Mapping
    SORT_MAP = {
        'id': 'mp.id',
        'global_name': 'mp.global_name',
        'linked_count': 'linked_count',
        'confidence_score': 'mp.confidence_score',
        'global_ean': 'mp.global_ean'
    }
    
    sort_col = SORT_MAP.get(sort_by, 'linked_count')
    sort_dir = 'ASC' if order.lower() == 'asc' else 'DESC'

    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Base query
            query = """
                SELECT 
                    mp.id, 
                    mp.global_name, 
                    mp.global_ean, 
                    mp.confidence_score,
                    COUNT(pml.product_id) as linked_count
                FROM master_products mp
                LEFT JOIN product_master_links pml ON mp.id = pml.master_product_id
            """
            
            params = []
            
            # Search filter
            if search:
                query += " WHERE mp.global_name ILIKE %s OR mp.global_ean ILIKE %s "
                params.extend([f"%{search}%", f"%{search}%"])
            
            # Grouping and Sorting
            query += f" GROUP BY mp.id ORDER BY {sort_col} {sort_dir} "
            
            # Pagination
            query += " LIMIT %s OFFSET %s "
            params.extend([limit, offset])
            
            cur.execute(query, tuple(params))
            results = cur.fetchall()
            
            # Count total for metadata
            count_query = "SELECT COUNT(*) FROM master_products"
            if search:
                 count_query += " WHERE global_name ILIKE %s OR global_ean ILIKE %s"
                 cur.execute(count_query, (f"%{search}%", f"%{search}%"))
            else:
                 cur.execute(count_query)
            
            total = cur.fetchone()['count']
            
            return {
                "data": results,
                "meta": {
                    "total": total,
                    "page": page,
                    "limit": limit,
                    "pages": (total + limit - 1) // limit
                }
            }
            
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()

@router.get("/stats")
def get_master_stats():
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # 1. Total Masters
            cur.execute("SELECT COUNT(*) as count FROM master_products")
            total_masters = cur.fetchone()['count']
            
            # 2. Total Linked Products
            cur.execute("SELECT COUNT(*) as count FROM product_master_links")
            total_linked = cur.fetchone()['count']
            
            # 3. Orphans (Masters with 0 links)
            cur.execute("""
                SELECT COUNT(*) as count 
                FROM master_products mp
                LEFT JOIN product_master_links pml ON mp.id = pml.master_product_id
                WHERE pml.product_id IS NULL
            """)
            orphans = cur.fetchone()['count']
            
            # 4. Coverage (Products with Master vs Total Products)
            cur.execute("SELECT COUNT(*) FROM products")
            total_products = cur.fetchone()['count']
            
            coverage = 0
            if total_products > 0:
                coverage = (total_linked / total_products) * 100
            
            return {
                "total_masters": total_masters,
                "total_linked": total_linked,
                "orphans": orphans,
                "coverage_rate": round(coverage, 1)
            }
    finally:
        conn.close()
