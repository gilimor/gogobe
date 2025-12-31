"""
Gogobe Price Comparison API
FastAPI backend for local price comparison website
"""

import sys
from pathlib import Path
import os

# Add project root to sys.path to allow 'backend' imports
current_file = Path(__file__).resolve()
project_root = current_file.parent.parent.parent # backend/api/main.py -> backend/api -> backend -> root
if str(project_root) not in sys.path:
    sys.path.insert(0, str(project_root))

from fastapi import FastAPI, HTTPException, Query, Request, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, FileResponse, Response, StreamingResponse
from fastapi.staticfiles import StaticFiles
from typing import Optional, List
from datetime import datetime
import psycopg2
from psycopg2.extras import RealDictCursor
import os
import logging
import traceback
import asyncio
import json
from collections import deque
from pathlib import Path

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# In-memory error storage (last 100 errors)
error_log = deque(maxlen=100)

# Import routers
try:
    import routers.admin as admin
    from .routers import master_products
except ImportError:
    import routers.admin as admin
    import routers.master_products as master_products

# Create FastAPI app
app = FastAPI(
    title="Gogobe Price Comparison API",
    description="API for searching and comparing product prices",
    version="1.0.0"
)


app.include_router(admin.router)

try:
    from .routers import management
except ImportError:
    import routers.management as management
app.include_router(management.router)

# Master Products router
try:
    from .routers import master_products
except ImportError:
    import routers.master_products as master_products
app.include_router(master_products.router, prefix="/api/master-products", tags=["Master Products"])

# Smart Basket router
try:
    from . import smart_basket
except ImportError:
    import smart_basket
app.include_router(smart_basket.router)

# AI Extension router
try:
    from .routers import ai_extension
except ImportError:
    import routers.ai_extension as ai_extension
app.include_router(ai_extension.router)

# Products Router (Public Search)
try:
    from .routers import products
except ImportError:
    import routers.products as products
app.include_router(products.router)

# Sources Management router
try:
    from .routers import sources
except ImportError:
    import routers.sources as sources
app.include_router(sources.router)

# Price Scanner router
try:
    from .routers import price_scanner
except ImportError:
    import routers.price_scanner as price_scanner
app.include_router(price_scanner.router)


@app.get("/api/kafka/status")
async def get_kafka_status():
    """Get status of Kafka Swarm (Queues, Workers, Logs)"""
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # 1. Processing Stats from DB (Throughput)
            cur.execute("""
                SELECT 
                    status, 
                    COUNT(*) as count 
                FROM file_processing_log 
                GROUP BY status
            """)
            status_counts = {row['status']: row['count'] for row in cur.fetchall()}
            
            # 2. Latest active jobs (In Progress)
            cur.execute("""
                SELECT 
                    filename, 
                    source, 
                    status,
                    created_at,
                    products_added 
                FROM file_processing_log 
                WHERE status IN ('downloading', 'importing', 'parsing') 
                ORDER BY updated_at DESC 
                LIMIT 5
            """)
            active_jobs = cur.fetchall()
            
            # 3. Simulate Queue Depth (Since we can't easily query Kafka Broker directly without AdminClient)
            # In a real scenario, we'd use AdminClient to get offsets.
            # For now, we assume:
            # - Discovered (Scout) -> Downloading (Carrier) -> Processing (Parser) -> Completed
            # If we tracked 'discovered' events in DB, we could count lags.
            
            # Recent Logs (Last 10)
            cur.execute("""
                SELECT 
                    source,
                    status,
                    products_added,
                    prices_added,
                    processing_completed_at
                FROM file_processing_log
                WHERE status = 'completed'
                ORDER BY processing_completed_at DESC
                LIMIT 10
            """)
            recent_completed = cur.fetchall()

            return {
                "queues": {
                    "total_jobs": sum(status_counts.values()),
                    "pending": status_counts.get('pending', 0),
                    "downloading": status_counts.get('downloading', 0),
                    "importing": status_counts.get('importing', 0),
                    "completed": status_counts.get('completed', 0),
                    "failed": status_counts.get('failed', 0)
                },
                "workers": {
                    "scout": "active", # Assumed
                    "carriers": 3,
                    "parsers": 2
                },
                "active_jobs": active_jobs,
                "recent_completed": recent_completed
            }
    finally:
        conn.close()

# CORS middleware (allow local frontend)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount static files (frontend)
frontend_path = Path(__file__).parent.parent.parent / "frontend"
if frontend_path.exists():
    app.mount("/static", StaticFiles(directory=str(frontend_path)), name="static")

# Mount documentation system
docs_path = Path(__file__).parent.parent / "docs"
if docs_path.exists():
    app.mount("/docs", StaticFiles(directory=str(docs_path), html=True), name="docs")

# UTF-8 encoding middleware
@app.middleware("http")
async def add_utf8_headers(request: Request, call_next):
    """Ensure all responses have UTF-8 encoding headers"""
    response = await call_next(request)
    
    # Add UTF-8 charset to Content-Type if it's text/html or application/json
    content_type = response.headers.get("content-type", "")
    if "text/html" in content_type and "charset" not in content_type:
        response.headers["content-type"] = "text/html; charset=utf-8"
    elif "application/json" in content_type and "charset" not in content_type:
        response.headers["content-type"] = "application/json; charset=utf-8"
    
    return response

# Error logging middleware
@app.middleware("http")
async def log_errors(request: Request, call_next):
    try:
        response = await call_next(request)
        return response
    except Exception as e:
        error_entry = {
            "timestamp": datetime.now().isoformat(),
            "type": "server",
            "error_type": type(e).__name__,
            "message": str(e),
            "path": str(request.url),
            "method": request.method,
            "traceback": traceback.format_exc()
        }
        error_log.append(error_entry)
        logger.error(f"Server error: {e}", exc_info=True)
        return JSONResponse(
            status_code=500,
            content={"detail": "Internal server error", "error": str(e)},
            headers={"Content-Type": "application/json; charset=utf-8"}
        )

# Database configuration
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432'),
    'client_encoding': 'UTF8'
}


def get_db_connection():
    """Get database connection"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except Exception as e:
        print(f"Database connection error: {e}")
        return None


def get_order_by_clause(sort_by: str) -> str:
    """Get ORDER BY clause based on sort_by parameter"""
    sort_options = {
        "price_asc": "pr.price ASC",
        "price_desc": "pr.price DESC",
        "scraped_at_desc": "pr.scraped_at DESC, pr.price ASC",
        "scraped_at_asc": "pr.scraped_at ASC, pr.price ASC",
        "product_name_asc": "p.name ASC, pr.price ASC",
        "product_name_desc": "p.name DESC, pr.price ASC",
        "store_name_asc": "COALESCE(s.name_he, s.name) ASC, pr.price ASC",
        "store_name_desc": "COALESCE(s.name_he, s.name) DESC, pr.price ASC",
    }
    return sort_options.get(sort_by, "pr.scraped_at DESC, pr.price ASC")


@app.get("/")
async def root():
    """Serve the main HTML page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "index.html"
    if frontend_path.exists():
        with open(frontend_path, 'r', encoding='utf-8') as f:
            content = f.read()
        return Response(
            content=content,
            media_type="text/html; charset=utf-8",
            headers={"Content-Type": "text/html; charset=utf-8"}
        )
    return {
        "message": "Gogobe Price Comparison API",
        "version": "1.0.0",
        "endpoints": {
            "search": "/api/products/search",
            "product": "/api/products/{id}",
            "stats": "/api/stats",
            "categories": "/api/categories",
            "suppliers": "/api/suppliers"
        }
    }


@app.get("/product.html")
async def product_page():
    """Serve dedicated product page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "product.html"
    with open(frontend_path, 'r', encoding='utf-8') as f:
        content = f.read()
    return Response(
        content=content,
        media_type="text/html; charset=utf-8",
        headers={"Content-Type": "text/html; charset=utf-8"}
    )


@app.get("/dashboard.html")
async def dashboard():
    """Serve dashboard page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "dashboard.html"
    with open(frontend_path, 'r', encoding='utf-8') as f:
        content = f.read()
    return Response(
        content=content,
        media_type="text/html; charset=utf-8",
        headers={"Content-Type": "text/html; charset=utf-8"}
    )


@app.get("/categories.html")
async def categories_page():
    """Serve categories page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "categories.html"
    with open(frontend_path, 'r', encoding='utf-8') as f:
        content = f.read()
    return Response(
        content=content,
        media_type="text/html; charset=utf-8",
        headers={"Content-Type": "text/html; charset=utf-8"}
    )


@app.get("/stores.html")
async def stores_page():
    """Serve stores page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "stores.html"
    with open(frontend_path, 'r', encoding='utf-8') as f:
        content = f.read()
    return Response(
        content=content,
        media_type="text/html; charset=utf-8",
        headers={"Content-Type": "text/html; charset=utf-8"}
    )


@app.get("/errors.html")
async def errors_page():
    """Serve errors page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "errors.html"
    with open(frontend_path, 'r', encoding='utf-8') as f:
        content = f.read()
    return Response(
        content=content,
        media_type="text/html; charset=utf-8",
        headers={"Content-Type": "text/html; charset=utf-8"}
    )

@app.get("/prices.html")
async def prices_page():
    """Serve prices page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "prices.html"
    with open(frontend_path, 'r', encoding='utf-8') as f:
        content = f.read()
    return Response(
        content=content,
        media_type="text/html; charset=utf-8",
        headers={"Content-Type": "text/html; charset=utf-8"}
    )

@app.get("/data-sources.html")
async def data_sources_page():
    """Serve data sources page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "data-sources.html"
    with open(frontend_path, 'r', encoding='utf-8') as f:
        content = f.read()
    return Response(
        content=content,
        media_type="text/html; charset=utf-8",
        headers={"Content-Type": "text/html; charset=utf-8"}
    )

@app.get("/price-sources.html")
async def price_sources_page():
    """Serve price sources page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "price-sources.html"
    with open(frontend_path, 'r', encoding='utf-8') as f:
        content = f.read()
    return Response(
        content=content,
        media_type="text/html; charset=utf-8",
        headers={"Content-Type": "text/html; charset=utf-8"}
    )


@app.get("/map.html")
async def map_page():
    """Serve map page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "map.html"
    with open(frontend_path, 'r', encoding='utf-8') as f:
        content = f.read()
    return Response(
        content=content,
        media_type="text/html; charset=utf-8",
        headers={"Content-Type": "text/html; charset=utf-8"}
    )


@app.get("/admin.html")
async def admin_page():
    """Serve admin page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "admin.html"
    with open(frontend_path, 'r', encoding='utf-8') as f:
        content = f.read()
    return Response(
        content=content,
        media_type="text/html; charset=utf-8",
        headers={"Content-Type": "text/html; charset=utf-8"}
    )


@app.get("/admin/master-management.html")
async def master_management_page():
    """Serve master management page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "admin" / "master-management.html"
    with open(frontend_path, 'r', encoding='utf-8') as f:
        content = f.read()
    return Response(
        content=content,
        media_type="text/html; charset=utf-8",
        headers={"Content-Type": "text/html; charset=utf-8"}
    )


@app.get("/admin/ai-matching.html")
async def ai_matching_page():
    """Serve AI matching page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "admin" / "ai-matching.html"
    with open(frontend_path, 'r', encoding='utf-8') as f:
        content = f.read()
    return Response(
        content=content,
        media_type="text/html; charset=utf-8",
        headers={"Content-Type": "text/html; charset=utf-8"}
    )


@app.get("/admin/sources-discovery.html")
async def scanner_page():
    """Serve scanner page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "admin" / "sources-discovery.html"
    with open(frontend_path, 'r', encoding='utf-8') as f:
        content = f.read()
    return Response(
        content=content,
        media_type="text/html; charset=utf-8",
        headers={"Content-Type": "text/html; charset=utf-8"}
    )




@app.get("/api/stats")
async def get_stats():
    """Get overall statistics for dashboard"""
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Total products
            cur.execute("SELECT COUNT(DISTINCT id) as count FROM products")
            total_products = cur.fetchone()['count']
            
            # Total prices
            cur.execute("SELECT COUNT(id) as count FROM prices")
            total_prices = cur.fetchone()['count']
            
            # Total categories
            cur.execute("SELECT COUNT(DISTINCT id) as count FROM categories")
            total_categories = cur.fetchone()['count']
            
            # Total suppliers
            cur.execute("SELECT COUNT(DISTINCT id) as count FROM suppliers")
            total_suppliers = cur.fetchone()['count']
            
            # Total chains
            cur.execute("SELECT COUNT(DISTINCT id) as count FROM chains")
            total_chains = cur.fetchone()['count']
            
            # Total stores
            cur.execute("SELECT COUNT(DISTINCT id) as count FROM stores")
            total_stores = cur.fetchone()['count']
            
            return {
                "total_products": total_products,
                "total_prices": total_prices,
                "total_categories": total_categories,
                "total_suppliers": total_suppliers,
                "total_chains": total_chains,
                "total_stores": total_stores
            }
    finally:
        conn.close()


@app.get("/api/data-sources/stats")
async def get_data_sources_stats():
    """Get statistics for all data sources"""
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Get stats per supplier/chain
            cur.execute("""
                SELECT 
                    s.name as source_name,
                    s.slug as source_slug,
                    COUNT(DISTINCT p.id) as total_products,
                    COUNT(pr.id) as total_prices,
                    COUNT(DISTINCT st.id) as total_stores,
                    MAX(pr.scraped_at) as last_import,
                    MIN(pr.scraped_at) as first_import,
                    COUNT(DISTINCT DATE(pr.scraped_at)) as import_days
                FROM suppliers s
                LEFT JOIN prices pr ON pr.supplier_id = s.id
                LEFT JOIN products p ON pr.product_id = p.id
                LEFT JOIN stores st ON pr.store_id = st.id
                GROUP BY s.id, s.name, s.slug
                ORDER BY last_import DESC NULLS LAST
            """)
            
            sources = cur.fetchall()
            
            # Get per-store stats for chains with stores
            cur.execute("""
                SELECT 
                    c.name as chain_name,
                    c.slug as chain_slug,
                    st.id as store_id,
                    st.store_id as store_code,
                    COALESCE(st.name_he, st.name) as store_name,
                    st.city,
                    COUNT(DISTINCT pr.product_id) as products,
                    COUNT(pr.id) as prices,
                    MAX(pr.scraped_at) as last_import,
                    MIN(pr.scraped_at) as first_import
                FROM chains c
                JOIN stores st ON st.chain_id = c.id
                LEFT JOIN prices pr ON pr.store_id = st.id
                WHERE st.is_active = TRUE
                GROUP BY c.id, c.name, c.slug, st.id, st.store_id, st.name, st.city
                HAVING COUNT(pr.id) > 0
                ORDER BY c.name, last_import DESC
            """)
            
            stores = cur.fetchall()
            
            return {
                "sources": sources,
                "stores": stores,
                "summary": {
                    "total_sources": len(sources),
                    "active_sources": len([s for s in sources if s['last_import']]),
                    "total_stores": len(stores)
                }
            }
    finally:
        conn.close()


@app.get("/api/health")
async def health_check():
    """Health check endpoint"""
    conn = get_db_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                cur.execute("SELECT 1")
                conn.close()
                return {"status": "healthy", "database": "connected"}
        except:
            return {"status": "unhealthy", "database": "error"}
    return {"status": "unhealthy", "database": "disconnected"}


@app.get("/api/errors")
async def get_errors(limit: int = 50, error_type: Optional[str] = None):
    """Get recent errors from server and client"""
    errors = list(error_log)
    
    # Filter by type if specified
    if error_type:
        errors = [e for e in errors if e.get('type') == error_type]
    
    # Sort by timestamp (newest first)
    errors.sort(key=lambda x: x.get('timestamp', ''), reverse=True)
    
    # Limit results
    errors = errors[:limit]
    
    return {
        "total": len(errors),
        "errors": errors
    }


@app.post("/api/errors/client")
async def log_client_error(error_data: dict):
    """Log client-side JavaScript errors"""
    error_entry = {
        "timestamp": datetime.now().isoformat(),
        "type": "client",
        "error_type": error_data.get("type", "Unknown"),
        "message": error_data.get("message", ""),
        "stack": error_data.get("stack", ""),
        "url": error_data.get("url", ""),
        "line": error_data.get("line"),
        "column": error_data.get("column"),
        "user_agent": error_data.get("userAgent", "")
    }
    error_log.append(error_entry)
    logger.warning(f"Client error: {error_entry['message']}")
    return {"status": "logged"}


@app.delete("/api/errors")
async def clear_errors():
    """Clear all logged errors"""
    error_log.clear()
    return {"status": "cleared", "message": "All errors cleared"}


@app.get("/api/stats")
async def get_stats():
    """Get database statistics"""
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Get chains for filter
            cur.execute("SELECT id, name FROM store_chains WHERE is_active = TRUE")
            chains = [{'id': r[0], 'name': r[1]} for r in cur.fetchall()]
            
            # Total products
            cur.execute("SELECT COUNT(*) as count FROM products WHERE is_active = TRUE")
            total_products = cur.fetchone()['count']
            
            # Total prices
            cur.execute("SELECT COUNT(*) as count FROM prices")
            total_prices = cur.fetchone()['count']
            
            # Total suppliers
            cur.execute("SELECT COUNT(*) as count FROM suppliers WHERE is_active = TRUE")
            total_suppliers = cur.fetchone()['count']
            
            # Total categories
            cur.execute("SELECT COUNT(*) as count FROM categories")
            total_categories = cur.fetchone()['count']
            
            # Latest price update
            cur.execute("""
                SELECT 
                    MAX(scraped_at) as latest_update,
                    COUNT(DISTINCT DATE(scraped_at)) as days_with_data
                FROM prices
            """)
            latest_data = cur.fetchone()
            
            # Price range
            cur.execute("""
                SELECT 
                    MIN(price) as min_price,
                    MAX(price) as max_price,
                    AVG(price) as avg_price,
                    COUNT(DISTINCT currency) as currencies
                FROM prices
            """)
            price_stats = cur.fetchone()
            
            return {
                "total_products": total_products,
                "total_prices": total_prices,
                "total_suppliers": total_suppliers,
                "total_categories": total_categories,
                "latest_update": latest_data['latest_update'] if latest_data else None,
                "days_with_data": latest_data['days_with_data'] if latest_data else 0,
                "price_stats": price_stats
            }
    finally:
        conn.close()


# ... imports ...
try:
    from cache.redis_cache import get_cache
except ImportError:
    # Ensure backend is in path
    sys.path.append(str(Path(__file__).parent.parent))
    from cache.redis_cache import get_cache

@app.get("/api/categories")
async def get_categories():
    """Get all categories (Cached & Hierarchical)"""
    # 1. Try Cache
    try:
        cache = get_cache(host=os.getenv('REDIS_HOST', 'redis'))
        if cache and cache._is_connected():
            cached_data = cache.redis.get("api:categories:tree")
            if cached_data:
                return json.loads(cached_data)
    except Exception as e:
        logger.warning(f"Cache lookup failed: {e}")

    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Fetch all categories with counts
            # We select name_en if available (handled by SELECT *) or explicit list
            # Using explicit columns to be safe
            cur.execute("""
                SELECT 
                    c.id,
                    c.name,
                    c.name_en,
                    c.slug,
                    c.parent_id,
                    c.level,
                    COUNT(DISTINCT p.id) as product_count
                FROM categories c
                LEFT JOIN products p ON p.category_id = c.id
                GROUP BY c.id, c.name, c.name_en, c.slug, c.parent_id, c.level
                ORDER BY c.level ASC, product_count DESC
            """)
            rows = cur.fetchall()
            
            # Build Tree Strategy
            # 1. Create a map of ID -> Category
            categories_map = {}
            for row in rows:
                row['children'] = []
                # Fallback for name_en if NULL
                if not row.get('name_en'):
                    row['name_en'] = row['name']
                categories_map[row['id']] = row
            
            # 2. Link children to parents
            root_categories = []
            for row in rows:
                parent_id = row.get('parent_id')
                if parent_id and parent_id in categories_map:
                    parent = categories_map[parent_id]
                    parent['children'].append(row)
                elif row.get('level') == 1:
                    # Top level category
                    root_categories.append(row)
            
            response_data = {"categories": root_categories}
            
            # 2. Set Cache (TTL 1 hour)
            try:
                if cache and cache._is_connected():
                    cache.redis.setex(
                        "api:categories:tree",
                        3600,
                        json.dumps(response_data)
                    )
            except Exception as e:
                logger.warning(f"Cache set failed: {e}")
                
            return response_data
    finally:
        conn.close()


@app.get("/api/suppliers")
async def get_suppliers():
    """Get all suppliers"""
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT 
                    s.id,
                    s.name,
                    s.slug,
                    s.country_code,
                    COUNT(DISTINCT pr.product_id) as product_count,
                    COUNT(pr.id) as price_count
                FROM suppliers s
                LEFT JOIN prices pr ON s.id = pr.supplier_id
                WHERE s.is_active = TRUE
                GROUP BY s.id, s.name, s.slug, s.country_code
                ORDER BY product_count DESC
            """)
            suppliers = cur.fetchall()
            return {"suppliers": suppliers}
    finally:
        conn.close()


@app.get("/api/chains")
async def get_chains():
    """Get all retail chains with store counts"""
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT 
                    c.id,
                    c.name,
                    c.name_he,
                    c.slug,
                    c.chain_type,
                    c.store_count,
                    COUNT(DISTINCT s.id) as active_store_count,
                    COUNT(DISTINCT pr.product_id) as product_count,
                    COUNT(pr.id) as price_count
                FROM chains c
                LEFT JOIN stores s ON c.id = s.chain_id AND s.is_active = TRUE
                LEFT JOIN prices pr ON s.id = pr.store_id
                WHERE c.is_active = TRUE
                GROUP BY c.id, c.name, c.name_he, c.slug, c.chain_type, c.store_count
                ORDER BY product_count DESC
            """)
            chains = cur.fetchall()
            return {"chains": chains}
    finally:
        conn.close()


@app.get("/api/chains/{chain_id}/stores")
async def get_chain_stores(chain_id: int):
    """Get all stores for a specific chain"""
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT 
                    s.id,
                    s.store_id,
                    s.name,
                    s.name_he,
                    s.city,
                    s.address,
                    s.bikoret_no,
                    s.phone,
                    COUNT(DISTINCT pr.product_id) as product_count,
                    COUNT(pr.id) as price_count,
                    MIN(pr.price) as min_price,
                    MAX(pr.price) as max_price,
                    MAX(pr.scraped_at) as last_updated
                FROM stores s
                LEFT JOIN prices pr ON s.id = pr.store_id
                WHERE s.chain_id = %s AND s.is_active = TRUE
                GROUP BY s.id, s.store_id, s.name, s.name_he, s.city, s.address, s.bikoret_no, s.phone
                ORDER BY product_count DESC
            """, (chain_id,))
            stores = cur.fetchall()
            return {"stores": stores}
    finally:
        conn.close()


@app.get("/api/master-products/search")
async def public_search_masters(q: str = ""):
    """Public endpoint to search for master products"""
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            query = """
                SELECT id, name, main_image_url
                FROM master_products
                WHERE name ILIKE %s
                ORDER BY name
                LIMIT 20
            """
            cur.execute(query, (f"%{q}%",))
            results = cur.fetchall()
            return {"masters": results}
    finally:
        conn.close()


@app.get("/api/master-products/{master_id}/map-prices")
async def get_master_map_prices(master_id: int):
    """Get prices for a master product across all branches with coordinates for mapping"""
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Get total unique stores for this master (even without coordinates)
            cur.execute("""
                SELECT COUNT(DISTINCT pr.store_id) as count
                FROM prices pr
                JOIN product_master_links l ON pr.product_id = l.product_id
                WHERE l.master_product_id = %s
            """, (master_id,))
            total_stores_found = cur.fetchone()['count'] or 0

            # Get one price per store for all stores with coordinates
            cur.execute("""
                SELECT DISTINCT ON (s.id)
                    pr.price,
                    pr.currency,
                    pr.scraped_at,
                    s.id as store_id,
                    COALESCE(s.name_he, s.name) as store_name,
                    s.city,
                    s.address,
                    s.latitude,
                    s.longitude,
                    c.name as chain_name,
                    c.name_he as chain_name_he,
                    p.name as variant_name
                FROM prices pr
                JOIN products p ON pr.product_id = p.id
                JOIN product_master_links l ON p.id = l.product_id
                JOIN stores s ON pr.store_id = s.id
                JOIN chains c ON s.chain_id = c.id
                WHERE l.master_product_id = %s 
                  AND s.latitude IS NOT NULL 
                  AND s.longitude IS NOT NULL
                ORDER BY s.id, pr.price ASC
            """, (master_id,))
            prices = cur.fetchall()
            
            return {
                "prices": prices,
                "total_stores_found": total_stores_found,
                "total_on_map": len(prices)
            }
    finally:
        conn.close()


@app.get("/api/prices")
async def get_prices(
    page: int = Query(1, ge=1),
    per_page: int = Query(50, ge=1, le=200),
    product_id: Optional[int] = None,
    product_name: Optional[str] = None,
    store_id: Optional[int] = None,
    store_name: Optional[str] = None,
    chain_id: Optional[int] = None,
    chain_name: Optional[str] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    currency: Optional[str] = None,
    from_date: Optional[str] = None,
    to_date: Optional[str] = None,
    sort_by: Optional[str] = Query("scraped_at_desc", description="Sort: price_asc, price_desc, scraped_at_desc, scraped_at_asc, product_name_asc, product_name_desc, store_name_asc")
):
    """
    Get all price records with filtering and pagination
    This is the PRICE TABLE - each record is a unique price observation
    """
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Build WHERE conditions
            where_conditions = []
            params = []
            
            if product_id:
                where_conditions.append("pr.product_id = %s")
                params.append(product_id)
            
            if product_name:
                where_conditions.append("p.name ILIKE %s")
                params.append(f"%{product_name}%")
            
            if store_id:
                where_conditions.append("pr.store_id = %s")
                params.append(store_id)
            
            if store_name:
                where_conditions.append("(COALESCE(s.name_he, s.name) ILIKE %s OR s.city ILIKE %s)")
                params.extend([f"%{store_name}%", f"%{store_name}%"])
            
            if chain_id:
                where_conditions.append("s.chain_id = %s")
                params.append(chain_id)
            
            if chain_name:
                where_conditions.append("(COALESCE(c.name_he, c.name) ILIKE %s)")
                params.append(f"%{chain_name}%")
            
            if min_price:
                where_conditions.append("pr.price >= %s")
                params.append(min_price)
            
            if max_price:
                where_conditions.append("pr.price <= %s")
                params.append(max_price)
            
            if currency:
                where_conditions.append("pr.currency = %s")
                params.append(currency)
            
            if from_date:
                where_conditions.append("pr.scraped_at >= %s")
                params.append(from_date)
            
            if to_date:
                where_conditions.append("pr.scraped_at <= %s")
                params.append(to_date)
            
            where_clause = " AND ".join(where_conditions) if where_conditions else "TRUE"
            
            # Count total - optimized for performance
            # Use estimated count for large datasets if no filters (much faster)
            if len(where_conditions) == 0:
                # No filters - use fast approximate count for performance
                cur.execute("SELECT reltuples::BIGINT AS estimate FROM pg_class WHERE relname = 'prices'")
                result = cur.fetchone()
                estimate = result['estimate'] if result else 0
                if estimate > 1000000:  # If more than 1M records, use estimate
                    total = estimate
                else:
                    cur.execute("SELECT COUNT(*) as total FROM prices")
                    total = cur.fetchone()['total']
            else:
                # Optimize JOINs for COUNT query based on active filters
                # Only join tables strictly needed for filtering
                join_clauses = []
                
                # Check which tables are actually needed for the active filters
                needs_products = product_name is not None
                needs_stores = store_name is not None or chain_id is not None or chain_name is not None
                needs_chains = chain_name is not None
                
                # 'chain_id' is filtered via store table (s.chain_id), so we need stores but not necessarily chains table
                
                if needs_products:
                    join_clauses.append("LEFT JOIN products p ON pr.product_id = p.id")
                if needs_stores:
                    join_clauses.append("LEFT JOIN stores s ON pr.store_id = s.id")
                if needs_chains:
                    join_clauses.append("LEFT JOIN chains c ON s.chain_id = c.id")
                
                joins_str = " ".join(join_clauses)
                
                count_query = f"""
                    SELECT COUNT(*) as total
                    FROM prices pr
                    {joins_str}
                    WHERE {where_clause}
                """
                cur.execute(count_query, params)
                total = cur.fetchone()['total']
            
            # Get prices with pagination
            offset = (page - 1) * per_page
            order_clause = get_order_by_clause(sort_by)
            query = f"""
                SELECT 
                    pr.id as price_id,
                    pr.price,
                    pr.currency,
                    pr.first_scraped_at,
                    pr.last_scraped_at,
                    pr.scraped_at,
                    p.id as product_id,
                    p.name as product_name,
                    p.ean as product_ean,
                    cat.name as category_name,
                    mp.id as master_product_id,
                    mp.global_name as master_product_name,
                    mp.main_image_url as master_image_url,
                    s.id as store_id,
                    COALESCE(s.name_he, s.name, 'ללא שם') as store_name,
                    COALESCE(s.name_he, s.name, 'ללא שם') as store_name_he,
                    s.city as store_city,
                    s.address as store_address,
                    s.bikoret_no,
                    c.id as chain_id,
                    COALESCE(c.name_he, c.name, 'ללא שם') as chain_name,
                    COALESCE(c.name_he, c.name, 'ללא שם') as chain_name_he,
                    sup.name as supplier_name,
                    sup.country_code
                FROM prices pr
                LEFT JOIN products p ON pr.product_id = p.id
                LEFT JOIN categories cat ON p.category_id = cat.id
                LEFT JOIN master_products mp ON p.master_product_id = mp.id
                LEFT JOIN stores s ON pr.store_id = s.id
                LEFT JOIN chains c ON s.chain_id = c.id
                LEFT JOIN suppliers sup ON pr.supplier_id = sup.id
                WHERE {where_clause}
                ORDER BY {order_clause}
                LIMIT %s OFFSET %s
            """
            cur.execute(query, params + [per_page, offset])
            prices = cur.fetchall()
            
            return {
                "prices": prices,
                "pagination": {
                    "page": page,
                    "per_page": per_page,
                    "total": total,
                    "pages": (total + per_page - 1) // per_page
                }
            }
    finally:
        conn.close()


@app.get("/api/stores")
async def get_stores():
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT 
                    s.id,
                    s.store_id,
                    s.name,
                    s.name_he,
                    s.city,
                    s.address,
                    s.latitude,
                    s.longitude,
                    s.bikoret_no,
                    c.name as chain_name,
                    c.name_he as chain_name_he,
                    COUNT(DISTINCT pr.product_id) as product_count,
                    COUNT(pr.id) as price_count,
                    MIN(pr.price) as min_price,
                    MAX(pr.price) as max_price,
                    MAX(pr.scraped_at) as last_updated
                FROM stores s
                JOIN chains c ON s.chain_id = c.id
                LEFT JOIN prices pr ON s.id = pr.store_id
                WHERE s.is_active = TRUE
                GROUP BY s.id, s.store_id, s.name, s.name_he, s.city, s.address, s.latitude, s.longitude, s.bikoret_no, 
                         c.name, c.name_he
                ORDER BY product_count DESC
            """)
            stores = cur.fetchall()
            return {"stores": stores}
    finally:
        conn.close()


@app.get("/api/stores/geo")
async def get_stores_geo():
    """Get optimized store locations for map (lightweight)"""
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT 
                    s.id,
                    s.store_id,
                    s.name,
                    s.name_he,
                    s.city,
                    s.address,
                    s.latitude,
                    s.longitude,
                    c.name as chain_name,
                    c.name_he as chain_name_he
                FROM stores s
                JOIN chains c ON s.chain_id = c.id
                WHERE s.is_active = TRUE 
                  AND s.latitude IS NOT NULL 
                  AND s.longitude IS NOT NULL
            """)
            stores = cur.fetchall()
            return {"stores": stores}
    finally:
        conn.close()


@app.get("/api/products/search")
async def search_products(
    q: Optional[str] = Query(None, description="Search query"),
    category: Optional[int] = Query(None, description="Category ID"),
    supplier: Optional[int] = Query(None, description="Supplier ID"),
    min_price: Optional[float] = Query(None, description="Minimum price"),
    max_price: Optional[float] = Query(None, description="Maximum price"),
    currency: Optional[str] = Query("ILS", description="Currency filter"),
    sort_by: Optional[str] = Query("price_asc", description="Sort: price_asc, price_desc, name_asc, name_desc, newest"),
    chains: Optional[str] = Query(None, description="Comma separated chain IDs"),
    page: int = Query(1, ge=1, description="Page number"),
    per_page: int = Query(20, ge=1, le=100, description="Items per page")
):
    """
    Search products with filters - MASTER CENTRIC UNIFIED
    """
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Build query parts using the new unified master view
            # Chain Filter (NEW)
            if chains:
                chain_ids = [int(cid) for cid in chains.split(',') if cid.strip().isdigit()]
                if chain_ids:
                    # Filter: Product must have a price in one of the selected chains
                    # We check both master links (for Type=Master) and direct prices (for Type=Orphan)
                    # Since the View ID is unique, we can just join effectively.
                    # But since it's a view, we use a global EXISTS on prices+stores
                    # Note: v_products_unified_master.id corresponds to either master_product_id or product_id
                    
                    # Optimized approach: Since the view is UNION of Master and Orphan, ID is tricky.
                    # Master Row: ID = master_products.id
                    # Orphan Row: ID = products.id
                    
                    # We need a conditional check or a smart subquery.
                    # Simplest robust way: 
                    # "Show me this row IF it is a Master AND exists in chains OR it is Orphan AND exists in chains"
                    
                    # However, to keep it fast, let's assume the user just wants "Availability".
                    # We can use the 'stores' table joined with prices.
                    
                    # Constructing the subquery:
                    # Logic: 
                    # IF type='master', check product_master_links -> prices -> stores
                    # IF type='orphan', check prices -> stores
                    
                    # To avoid complex dynamic SQL string injection, we'll append a static SQL fragment with params
                    where_conditions.append(f"""
                        (
                            (type = 'master' AND EXISTS (
                                SELECT 1 FROM product_master_links pml
                                JOIN prices p ON p.product_id = pml.product_id
                                JOIN stores s ON p.store_id = s.id
                                WHERE pml.master_product_id = v_products_unified_master.id
                                AND s.chain_id IN %s
                            ))
                            OR
                            (type = 'orphan' AND EXISTS (
                                SELECT 1 FROM prices p
                                JOIN stores s ON p.store_id = s.id
                                WHERE p.product_id = v_products_unified_master.id
                                AND s.chain_id IN %s
                            ))
                        )
                    """)
                    # We pass the tuple of IDs twice
                    chain_tuple = tuple(chain_ids)
                    params.append(chain_tuple)
                    params.append(chain_tuple)

            if q:
                where_conditions.append("name ILIKE %s")
                params.append(f"%{q}%")
            
            if category:
                where_conditions.append("category_id = %s")
                params.append(category)

            if min_price:
                where_conditions.append("min_price >= %s")
                params.append(min_price)
                
            if max_price:
                where_conditions.append("max_price <= %s")
                params.append(max_price)
            
            where_clause = " AND ".join(where_conditions)
            
            # Count Query
            cur.execute(f"SELECT COUNT(*) as total FROM v_products_unified_master WHERE {where_clause}", params)
            total = cur.fetchone()['total']

            # Sort Mapping
            order_map = {
                "price_asc": "min_price ASC NULLS LAST",
                "price_desc": "max_price DESC NULLS LAST",
                "name_asc": "name ASC",
                "name_desc": "name DESC",
                "newest": "last_updated DESC NULLS LAST"
            }
            order_by = order_map.get(sort_by, "min_price ASC NULLS LAST")
            
            # Fetch Data
            query = f"""
                SELECT * FROM v_products_unified_master
                WHERE {where_clause}
                ORDER BY {order_by}
                LIMIT %s OFFSET %s
            """
            cur.execute(query, params + [per_page, (page - 1) * per_page])
            products = cur.fetchall()
            
            return {
                "products": products,
                "pagination": {
                    "total": total,
                    "page": page,
                    "per_page": per_page,
                    "pages": (total + per_page - 1) // per_page
                },
                "filters": {
                    "q": q,
                    "category": category,
                    "supplier": supplier,
                    "min_price": min_price,
                    "max_price": max_price,
                    "currency": currency,
                    "sort_by": sort_by
                }
            }
    finally:
        conn.close()


@app.get("/api/masters/{master_id}")
async def get_master_detail(master_id: int):
    """Get master product with all its variant products and consolidated prices"""
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # 1. Get Master metadata
            cur.execute("SELECT * FROM master_products WHERE id = %s", (master_id,))
            master = cur.fetchone()
            if not master:
                raise HTTPException(status_code=404, detail="Master product not found")
            
            # 2. Get all Variants (children)
            cur.execute("""
                SELECT p.*, c.name as category_name, b.name as brand_name
                FROM products p
                JOIN product_master_links l ON p.id = l.product_id
                LEFT JOIN categories c ON p.category_id = c.id
                LEFT JOIN brands b ON p.brand_id = b.id
                WHERE l.master_product_id = %s
            """, (master_id,))
            master['variants'] = cur.fetchall()
            
            # 3. Get consolidated prices from ALL variants
            cur.execute("""
                SELECT 
                    pr.*,
                    s.name as supplier_name,
                    st.name as store_name,
                    st.name_he as store_name_he,
                    st.city,
                    p.name as variant_name
                FROM prices pr
                JOIN product_master_links l ON pr.product_id = l.product_id
                JOIN products p ON pr.product_id = p.id
                JOIN suppliers s ON pr.supplier_id = s.id
                LEFT JOIN stores st ON pr.store_id = st.id
                WHERE l.master_product_id = %s
                ORDER BY pr.price ASC
            """, (master_id,))
            master['prices'] = cur.fetchall()
            
            return master
    finally:
        conn.close()


@app.get("/api/products/{product_id}")
async def get_product(product_id: int):
    """Get single product with all prices"""
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Get product
            cur.execute("""
                SELECT 
                    p.*,
                    c.name as category_name,
                    v.name as vertical_name,
                    b.name as brand_name
                FROM products p
                LEFT JOIN categories c ON p.category_id = c.id
                LEFT JOIN verticals v ON p.vertical_id = v.id
                LEFT JOIN brands b ON p.brand_id = b.id
                WHERE p.id = %s AND p.is_active = TRUE
            """, (product_id,))
            
            product = cur.fetchone()
            
            if not product:
                raise HTTPException(status_code=404, detail="Product not found")
            
            # Get all prices with store information
            cur.execute("""
                SELECT 
                    pr.*,
                    s.name as supplier_name,
                    s.slug as supplier_slug,
                    s.country_code,
                    st.name as store_name,
                    st.name_he as store_name_he,
                    st.store_id as store_code,
                    st.city,
                    st.address,
                    ch.name as chain_name,
                    ch.name_he as chain_name_he
                FROM prices pr
                JOIN suppliers s ON pr.supplier_id = s.id
                LEFT JOIN stores st ON pr.store_id = st.id
                LEFT JOIN chains ch ON st.chain_id = ch.id
                WHERE pr.product_id = %s
                ORDER BY pr.price ASC
            """, (product_id,))
            
            product['prices'] = cur.fetchall()
            
            # Get price history
            cur.execute("""
                SELECT 
                    DATE(scraped_at) as date,
                    AVG(price) as avg_price,
                    MIN(price) as min_price,
                    MAX(price) as max_price,
                    COUNT(*) as price_count
                FROM prices
                WHERE product_id = %s
                GROUP BY DATE(scraped_at)
                ORDER BY date DESC
                LIMIT 30
            """, (product_id,))
            
            product['price_history'] = cur.fetchall()
            
            return product
    finally:
        conn.close()


@app.get("/api/price-sources")
async def get_price_sources():
    """Get all price sources"""
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT *
                FROM price_sources
                ORDER BY is_active DESC, name
            """)
            return cur.fetchall()
    finally:
        conn.close()


@app.get("/api/price-sources/stats")
async def get_price_sources_stats():
    """Get statistics for price sources"""
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Get total sources
            cur.execute("SELECT COUNT(*) as total FROM price_sources WHERE is_active = TRUE")
            total_sources = cur.fetchone()['total']
            
            # Get total files
            cur.execute("SELECT COUNT(*) as total FROM downloaded_files")
            total_files = cur.fetchone()['total']
            
            # Get total products imported
            cur.execute("SELECT SUM(products_imported) as total FROM downloaded_files")
            total_products = cur.fetchone()['total'] or 0
            
            # Get last update
            cur.execute("SELECT MAX(downloaded_at) as last_update FROM downloaded_files")
            last_update = cur.fetchone()['last_update']
            
            return {
                "total_sources": total_sources,
                "total_files": total_files,
                "total_products": total_products,
                "last_update": last_update
            }
    finally:
        conn.close()


@app.get("/api/downloaded-files")
async def get_downloaded_files(limit: int = Query(20, le=100)):
    """Get list of downloaded files"""
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT *
                FROM downloaded_files
                ORDER BY downloaded_at DESC
                LIMIT %s
            """, (limit,))
            return cur.fetchall()
    finally:
        conn.close()


@app.get("/api/scraping-sessions")
async def get_scraping_sessions(limit: int = Query(10, le=50)):
    """Get list of scraping sessions"""
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT *
                FROM scraping_sessions
                ORDER BY started_at DESC
                LIMIT %s
            """, (limit,))
            return cur.fetchall()
    finally:
        conn.close()




# Serve nav.js explicitly (Global Navigation)
@app.get("/nav.js")
async def serve_nav_js():
    file_path = frontend_path / "nav.js"
    if file_path.exists():
        return FileResponse(str(file_path))
    raise HTTPException(status_code=404, detail="nav.js not found")

# Serve Root URL
@app.get("/")
async def read_root():
    return FileResponse(str(frontend_path / "index.html"))

# Serve Frontend Pages from Root (e.g. /dashboard.html, /prices.html)
@app.get("/{page}.html")
async def read_html(page: str):
    file_path = frontend_path / f"{page}.html"
    if file_path.exists():
        return FileResponse(str(file_path))
    raise HTTPException(status_code=404, detail="Page not found")

# Serve Admin Sub-pages
@app.get("/admin/{page}.html")
async def read_admin_html(page: str):
    file_path = frontend_path / "admin" / f"{page}.html"
    if file_path.exists():
        return FileResponse(str(file_path))
    raise HTTPException(status_code=404, detail="Page not found")


# --- REAL-TIME STREAMING ENDPOINT ---
@app.get("/api/stream-status")
async def stream_status():
    """
    Server-Sent Events (SSE) endpoint for real-time dashboard.
    """

    async def status_event_generator():
        # Setup Redis (Async) - Optional
        import redis.asyncio as redis
        use_redis = False
        try:
            r = redis.from_url("redis://localhost", decode_responses=True)
            pubsub = r.pubsub()
            await pubsub.subscribe("channel:ingest")
            use_redis = True
        except Exception as e:
            print(f"⚠️ Redis not available ({e}). Running in polling mode.")
            r = None
            pubsub = None

        # Local aggregation
        ingest_buffer = 0
        last_db_sync = datetime.now()
        
        # Try to import psutil for system metrics
        try:
            import psutil
            has_psutil = True
        except ImportError:
            has_psutil = False

        try:
            while True:
                # 1. Listen for Real-Time Events (Timeout 1s)
                if use_redis and pubsub:
                    try:
                        msg = await pubsub.get_message(ignore_subscribe_messages=True, timeout=1.0)
                        if msg:
                             try:
                                 parts = msg['data'].split(':')
                                 if parts[0] == 'price':
                                     count = int(parts[2])
                                     ingest_buffer += count
                             except: pass
                    except Exception:
                        use_redis = False # Disable if fails mid-stream

                # 2. Frequent Update (Every 1s) - Send Flux/Buffer
                if ingest_buffer > 0:
                    yield f"data: {json.dumps({'type': 'flux', 'count': ingest_buffer}, default=str)}\n\n"
                    ingest_buffer = 0

                # 3. Heavy Update (Every 3s)
                now = datetime.now()
                if (now - last_db_sync).total_seconds() < 3.0:
                    await asyncio.sleep(0.5) # Prevent CPU spinning
                    continue

                last_db_sync = now

                conn = get_db_connection()
                if not conn:
                    continue
                
                try:
                    with conn.cursor(cursor_factory=RealDictCursor) as cur:
                         # 0. Global Stats (Today's Progress)
                        cur.execute("""
                            SELECT 
                                COALESCE(SUM(prices_added), 0) as prices_today,
                                COALESCE(SUM(products_added), 0) as products_today,
                                COALESCE(COUNT(*), 0) as files_today
                            FROM file_processing_log 
                            WHERE processing_completed_at >= CURRENT_DATE
                        """)
                        today_stats = cur.fetchone()

                        # 1. Processing Stats (Active Files + Recently Completed)
                        cur.execute("""
                            SELECT 
                                id,
                                source, 
                                filename,
                                status, 
                                products_added,
                                prices_added,
                                EXTRACT(EPOCH FROM (NOW() - processing_started_at)) as seconds_running
                            FROM file_processing_log 
                            WHERE 
                               status IN ('downloading', 'extracting', 'parsing', 'importing', 'processing')
                               OR (status IN ('completed', 'failed') AND updated_at > NOW() - INTERVAL '30 seconds')
                            ORDER BY updated_at DESC
                            LIMIT 15
                        """)
                        active_files = cur.fetchall()
                        
                        # Calculate Flux (Items/Minute based on recent completed files)
                        cur.execute("""
                            SELECT 
                                COALESCE(SUM(prices_added), 0) as recent_items
                            FROM file_processing_log
                            WHERE updated_at > NOW() - INTERVAL '60 seconds'
                        """)
                        flux_res = cur.fetchone()
                        flux_bpm = flux_res['recent_items'] if flux_res else 0 # Items per minute active

                        # 2. Smart Telemetry (Network Status)
                        # TO-DO: Optimize this (cache it) if it becomes slow.
                        cur.execute("""
                             SELECT 
                                (SELECT COUNT(*) FROM suppliers) as total_sources,
                                (SELECT COUNT(DISTINCT source) FROM file_processing_log WHERE updated_at >= CURRENT_DATE) as active_sources_today,
                                (SELECT COUNT(*) FROM stores) as total_stores,
                                (SELECT COUNT(DISTINCT s.id) 
                                 FROM prices p 
                                 JOIN stores s ON p.store_id = s.id 
                                 WHERE p.scraped_at >= CURRENT_DATE
                                ) as stores_visited_today
                        """)
                        net_stats = cur.fetchone()

                        stats = {
                            "active_sources_count": net_stats['active_sources_today'] or 0,
                            "total_sources": net_stats['total_sources'] or 0,
                            "stores_visited": net_stats['stores_visited_today'] or 0,
                            "total_stores": net_stats['total_stores'] or 0,
                            
                            "daily_prices": int(today_stats['prices_today']),
                            "daily_products": int(today_stats['products_today']),
                            "daily_files": int(today_stats['files_today']),
                            "flux_bpm": int(flux_bpm)
                        }

                        # Construct Event
                        data = {
                            "system": {
                                "cpu_percent": psutil.cpu_percent() if has_psutil else 0,
                                "memory_percent": psutil.virtual_memory().percent if has_psutil else 0,
                                "success_rate": 100, # Mock for now
                                "store_coverage": {
                                    "scanned": stats['stores_visited'], 
                                    "total": stats['total_stores']
                                }
                            },
                            "stats": stats,
                            "active_tasks": [
                                {
                                    "source": f['source'],
                                    "status": f['status'],
                                    "filename": f['filename'],
                                    "products_added": f['products_added'],
                                    "prices_added": f['prices_added'],
                                    "started_at": f['seconds_running']  # We send seconds elapsed directly or timestamp? SQL gets epoch seconds.
                                } for f in active_files if f['status'] not in ('completed', 'failed')
                            ],
                            "fleet_matrix": [], # Deprecated by user request
                            "recent_logs": [
                                {
                                    "msg": f"{l['source']} finished: {l['products_added']} prods, {l['prices_added']} prices",
                                    "type": "success" if l['status'] == 'completed' else "error"
                                } for l in active_files if l['status'] in ('completed', 'failed')
                            ]
                        }
                        
                        yield f"data: {json.dumps(data, default=str)}\n\n"

                except Exception as e:
                    print(f"Stream Error: {e}")
                    yield f"data: {json.dumps({'error': str(e)})}\n\n"
                
                finally:
                    conn.close()

                # Sleep (Faster update for realtime feel)
                await asyncio.sleep(1.5)
                        


        except asyncio.CancelledError:
            print("Stream cancelled")
        finally:
            if pubsub: await pubsub.close()
            if r: await r.close()
            
            # Reduce Load: Sleep 3 seconds instead of default (which was tight loop or 1s)
            await asyncio.sleep(3.0)

    return StreamingResponse(
        status_event_generator(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
            "X-Accel-Buffering": "no"
        }
    )

@app.post("/api/run-import")
async def run_import_job(background_tasks: BackgroundTasks):
    """
    Trigger the full E2E import process in the background.
    """
    import subprocess
    
    def run_script():
        try:
            # Run the parallel import script
            # Path inside Docker: /app/backend/scripts/import_all_sources_parallel.py
            cmd = ["python", "/app/backend/scripts/import_all_sources_parallel.py"]
            subprocess.run(cmd, check=True)
            print("Background Import Job Finished Successfully")
        except Exception as e:
            print(f"Background Import Job Failed: {e}")

    background_tasks.add_task(run_script)
    return {"status": "started", "message": "Full import job running in background"}

# Mount Frontend Static Files (At the end to avoid shadowing API routes)
frontend_path = project_root / "frontend"
if frontend_path.exists():
    app.mount("/", StaticFiles(directory=str(frontend_path), html=True), name="frontend")
else:
    logger.warning(f"Frontend directory not found at {frontend_path}")

if __name__ == "__main__":
    import uvicorn
    print("Starting Gogobe API Server...")
    print("API Docs: http://localhost:8000/docs")
    print("Frontend: http://localhost:8000/")
    uvicorn.run(app, host="0.0.0.0", port=8000)

