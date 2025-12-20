"""
Gogobe Price Comparison API
FastAPI backend for local price comparison website
"""

from fastapi import FastAPI, HTTPException, Query, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, FileResponse
from fastapi.staticfiles import StaticFiles
from typing import Optional, List
from datetime import datetime
import psycopg2
from psycopg2.extras import RealDictCursor
import os
import logging
import traceback
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

# Create FastAPI app
app = FastAPI(
    title="Gogobe Price Comparison API",
    description="API for searching and comparing product prices",
    version="1.0.0"
)

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
            content={"detail": "Internal server error", "error": str(e)}
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


@app.get("/")
async def root():
    """Serve the main HTML page"""
    frontend_path = Path(__file__).parent.parent.parent / "frontend" / "index.html"
    if frontend_path.exists():
        return FileResponse(
            frontend_path,
            media_type="text/html; charset=utf-8"
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


@app.get("/dashboard.html")
async def dashboard():
    """Serve dashboard page"""
    return FileResponse(
        Path(__file__).parent.parent.parent / "frontend" / "dashboard.html",
        media_type="text/html; charset=utf-8"
    )


@app.get("/categories.html")
async def categories_page():
    """Serve categories page"""
    return FileResponse(
        Path(__file__).parent.parent.parent / "frontend" / "categories.html",
        media_type="text/html; charset=utf-8"
    )


@app.get("/stores.html")
async def stores_page():
    """Serve stores page"""
    return FileResponse(
        Path(__file__).parent.parent.parent / "frontend" / "stores.html",
        media_type="text/html; charset=utf-8"
    )


@app.get("/errors.html")
async def errors_page():
    """Serve errors page"""
    return FileResponse(
        Path(__file__).parent.parent.parent / "frontend" / "errors.html",
        media_type="text/html; charset=utf-8"
    )

@app.get("/prices.html")
async def prices_page():
    """Serve prices page"""
    return FileResponse(
        Path(__file__).parent.parent.parent / "frontend" / "prices.html",
        media_type="text/html; charset=utf-8"
    )

@app.get("/data-sources.html")
async def data_sources_page():
    """Serve data sources page"""
    return FileResponse(
        Path(__file__).parent.parent.parent / "frontend" / "data-sources.html",
        media_type="text/html; charset=utf-8"
    )


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
                    st.name as store_name,
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


@app.get("/api/categories")
async def get_categories():
    """Get all categories"""
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT 
                    c.id,
                    c.name,
                    c.slug,
                    v.name as vertical_name,
                    COUNT(DISTINCT p.id) as product_count
                FROM categories c
                LEFT JOIN verticals v ON c.vertical_id = v.id
                LEFT JOIN products p ON p.category_id = c.id AND p.is_active = TRUE
                GROUP BY c.id, c.name, c.slug, v.name
                ORDER BY product_count DESC
            """)
            categories = cur.fetchall()
            return {"categories": categories}
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


@app.get("/api/prices")
async def get_prices(
    page: int = Query(1, ge=1),
    per_page: int = Query(50, ge=1, le=200),
    product_id: Optional[int] = None,
    store_id: Optional[int] = None,
    chain_id: Optional[int] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    from_date: Optional[str] = None,
    to_date: Optional[str] = None
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
            
            if store_id:
                where_conditions.append("pr.store_id = %s")
                params.append(store_id)
            
            if chain_id:
                where_conditions.append("s.chain_id = %s")
                params.append(chain_id)
            
            if min_price:
                where_conditions.append("pr.price >= %s")
                params.append(min_price)
            
            if max_price:
                where_conditions.append("pr.price <= %s")
                params.append(max_price)
            
            if from_date:
                where_conditions.append("pr.scraped_at >= %s")
                params.append(from_date)
            
            if to_date:
                where_conditions.append("pr.scraped_at <= %s")
                params.append(to_date)
            
            where_clause = " AND ".join(where_conditions) if where_conditions else "TRUE"
            
            # Count total
            count_query = f"""
                SELECT COUNT(*) as total
                FROM prices pr
                LEFT JOIN products p ON pr.product_id = p.id
                LEFT JOIN stores s ON pr.store_id = s.id
                LEFT JOIN chains c ON s.chain_id = c.id
                WHERE {where_clause}
            """
            cur.execute(count_query, params)
            total = cur.fetchone()['total']
            
            # Get prices with pagination
            offset = (page - 1) * per_page
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
                    s.id as store_id,
                    s.name as store_name,
                    s.city as store_city,
                    s.bikoret_no,
                    c.id as chain_id,
                    c.name as chain_name,
                    sup.name as supplier_name
                FROM prices pr
                LEFT JOIN products p ON pr.product_id = p.id
                LEFT JOIN stores s ON pr.store_id = s.id
                LEFT JOIN chains c ON s.chain_id = c.id
                LEFT JOIN suppliers sup ON pr.supplier_id = sup.id
                WHERE {where_clause}
                ORDER BY pr.scraped_at DESC, pr.price ASC
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
    """Get all stores with statistics"""
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
                GROUP BY s.id, s.store_id, s.name, s.name_he, s.city, s.address, s.bikoret_no, 
                         c.name, c.name_he
                ORDER BY product_count DESC
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
    page: int = Query(1, ge=1, description="Page number"),
    per_page: int = Query(20, ge=1, le=100, description="Items per page")
):
    """
    Search products with filters
    
    - **q**: Search text in product name
    - **category**: Filter by category ID
    - **supplier**: Filter by supplier ID
    - **min_price**: Minimum price
    - **max_price**: Maximum price
    - **currency**: Currency (default: GBP)
    - **sort_by**: Sort order
    - **page**: Page number (starts at 1)
    - **per_page**: Results per page (max 100)
    """
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Build query
            query_parts = []
            params = []
            
            base_query = """
                SELECT 
                    p.id,
                    p.name,
                    p.description,
                    p.ean,
                    p.upc,
                    p.model_number,
                    p.manufacturer_code,
                    p.attributes,
                    b.name as brand_name,
                    c.name as category_name,
                    v.name as vertical_name,
                    STRING_AGG(DISTINCT s.name, ', ') as supplier_names,
                    STRING_AGG(DISTINCT st.name, ', ') as store_names,
                    COUNT(DISTINCT st.id) as store_count,
                    MIN(pr.price) as min_price,
                    MAX(pr.price) as max_price,
                    AVG(pr.price) as avg_price,
                    COUNT(DISTINCT pr.supplier_id) as supplier_count,
                    pr.currency,
                    MAX(pr.scraped_at) as last_updated
                FROM products p
                LEFT JOIN categories c ON p.category_id = c.id
                LEFT JOIN verticals v ON p.vertical_id = v.id
                LEFT JOIN brands b ON p.brand_id = b.id
                LEFT JOIN prices pr ON p.id = pr.product_id
                LEFT JOIN suppliers s ON pr.supplier_id = s.id
                LEFT JOIN stores st ON pr.store_id = st.id
                WHERE p.is_active = TRUE
            """
            
            if q:
                query_parts.append("AND p.name ILIKE %s")
                params.append(f"%{q}%")
            
            if category:
                query_parts.append("AND p.category_id = %s")
                params.append(category)
            
            if currency:
                query_parts.append("AND pr.currency = %s")
                params.append(currency)
            
            if supplier:
                query_parts.append("AND pr.supplier_id = %s")
                params.append(supplier)
            
            # Group by
            group_by = """
                GROUP BY p.id, p.name, p.description, p.ean, p.upc, p.model_number, 
                         p.manufacturer_code, p.attributes, b.name, c.name, v.name, pr.currency
            """
            
            # Having clause for price filters
            having_parts = []
            if min_price is not None:
                having_parts.append("MIN(pr.price) >= %s")
                params.append(min_price)
            
            if max_price is not None:
                having_parts.append("MAX(pr.price) <= %s")
                params.append(max_price)
            
            having_clause = ""
            if having_parts:
                having_clause = "HAVING " + " AND ".join(having_parts)
            
            # Sort
            order_map = {
                "price_asc": "min_price ASC NULLS LAST",
                "price_desc": "max_price DESC NULLS LAST",
                "name_asc": "p.name ASC",
                "name_desc": "p.name DESC",
                "newest": "MAX(pr.scraped_at) DESC NULLS LAST"
            }
            order_by = f"ORDER BY {order_map.get(sort_by, 'min_price ASC')}"
            
            # Count query
            count_query = base_query + " ".join(query_parts) + group_by + having_clause
            count_wrapper = f"SELECT COUNT(*) as total FROM ({count_query}) as subq"
            
            cur.execute(count_wrapper, params)
            total = cur.fetchone()['total']
            
            # Main query with pagination
            offset = (page - 1) * per_page
            params_with_limit = params + [per_page, offset]
            
            main_query = base_query + " ".join(query_parts) + group_by + having_clause + order_by + " LIMIT %s OFFSET %s"
            
            cur.execute(main_query, params_with_limit)
            products = cur.fetchall()
            
            # Get prices for each product with store information
            for product in products:
                cur.execute("""
                    SELECT 
                        s.name as supplier_name,
                        s.slug as supplier_slug,
                        pr.price,
                        pr.currency,
                        pr.scraped_at
                    FROM prices pr
                    JOIN suppliers s ON pr.supplier_id = s.id
                    WHERE pr.product_id = %s
                    ORDER BY pr.price ASC
                """, (product['id'],))
                product['prices'] = cur.fetchall()
            
            return {
                "products": products,
                "pagination": {
                    "page": page,
                    "per_page": per_page,
                    "total": total,
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
                    st.address
                FROM prices pr
                JOIN suppliers s ON pr.supplier_id = s.id
                LEFT JOIN stores st ON pr.store_id = st.id
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


if __name__ == "__main__":
    import uvicorn
    print("🚀 Starting Gogobe API Server...")
    print("📊 API Docs: http://localhost:8000/docs")
    print("🌐 Frontend: http://localhost:8000/static/index.html")
    uvicorn.run(app, host="0.0.0.0", port=8000)

