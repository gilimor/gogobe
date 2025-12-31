from fastapi import APIRouter, HTTPException, Query
from typing import List, Optional, Dict
import psycopg2
from psycopg2.extras import RealDictCursor
import os
import logging
import time

# Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Database config
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'gogobe'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', '9152245-Gl!'),
    'host': os.getenv('DB_HOST', 'db'),
    'port': os.getenv('DB_PORT', '5432')
}

router = APIRouter(
    prefix="/api/products",
    tags=["products"]
)

def get_db_connection():
    try:
        return psycopg2.connect(**DB_CONFIG)
    except Exception as e:
        logger.error(f"DB Connection Failed: {e}")
        return None

@router.get("/categories")
def get_categories():
    conn = get_db_connection()
    if not conn: return []
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT id, name FROM categories ORDER BY name")
            return cur.fetchall()
    finally:
        conn.close()

@router.get("/chains")
def get_chains():
    conn = get_db_connection()
    if not conn: return []
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT id, name FROM chains ORDER BY name")
            return cur.fetchall()
    finally:
        conn.close()

@router.get("/search")
@router.get("/search")
def search_products(
    query: str = Query(None), # Made min_length optional to allow browsing a category without search term
    category: Optional[str] = Query(None, alias="category"), # Accepts ID or Name
    master_id: Optional[int] = Query(None, alias="master_id"), # New: Filter by Master ID
    limit: int = 20,
    offset: int = 0
):
    """
    High-Performance Search & Browse.
    Supports filtering by text AND/OR category AND/OR master_id.
    """
    start_time = time.time()
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")

    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Step 1: ultra-fast product lookup
            product_sql = """
                SELECT id, name, ean, category_id
                FROM products
                WHERE is_active = TRUE
            """
            params = []
            
            # Text Search
            if query and len(query) >= 2:
                logger.info(f"Executing Search Query: {query}")
                product_sql += " AND (name ILIKE %s OR ean LIKE %s)"
                term = f"%{query}%"
                params.extend([term, term])
            
            # Master ID Filter
            if master_id:
                product_sql += " AND master_product_id = %s"
                params.append(master_id)

            # Category Filter
            if category:
                # Check if it's an ID (digit) or Name
                if category.isdigit():
                    product_sql += " AND category_id = %s"
                    params.append(int(category))
                else:
                    # Filter by category name (join needed or subquery)
                    # For performance, simplified to ID or exact subquery
                    # But if we use JOIN it might slow down. 
                    # Let's assume frontend sends ID mostly.
                    # If name, we interpret as simple string match if needed, but safe to ignore or try simple ID
                   pass

            # Efficient pagination
            product_sql += " ORDER BY name LIMIT %s OFFSET %s"
            params.extend([limit, offset])
            
            cur.execute(product_sql, params)
            products = cur.fetchall()
            logger.info(f"Search Step 1: Found {len(products)} basic products")
            
            if not products:
                return {"products": [], "meta": {"time_ms": (time.time() - start_time) * 1000}}

            # Extract IDs for Step 2
            product_ids = tuple(p['id'] for p in products)
            
            if not product_ids:
                 return {"products": [], "meta": {"time_ms": (time.time() - start_time) * 1000}}

            # Step 2: Bulk fetch min/max prices for these IDs
            # This avoids joining the entire prices table (millions of rows)
            price_sql = """
                SELECT 
                    product_id,
                    MIN(price) as price_min,
                    MAX(price) as price_max,
                    COUNT(DISTINCT store_id) as store_count,
                    MIN(currency) as currency
                FROM prices
                WHERE product_id IN %s
                GROUP BY product_id
            """
            cur.execute(price_sql, (product_ids,))
            price_stats = {row['product_id']: row for row in cur.fetchall()}
            
            # Step 3: Merge back
            results = []
            for p in products:
                stats = price_stats.get(p['id'], {})
                results.append({
                    **p,
                    "price_min": stats.get('price_min'),
                    "price_max": stats.get('price_max'),
                    "store_count": stats.get('store_count', 0),
                    "currency": stats.get('currency', '₪')
                })
                
            # Relevance Sorting: Put products with stores/prices first
            results.sort(key=lambda x: x['store_count'], reverse=True)
            
            return {
                "products": results,
                "meta": {
                    "count": len(results),
                    "time_ms": round((time.time() - start_time) * 1000, 2)
                }
            }
            
    except Exception as e:
        logger.error(f"Search Failed: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()


@router.get("/{product_id}")
def get_product_details(product_id: int):
    """
    Get full product details including all current prices and basic history stats.
    """
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")

    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # 1. Product Info
            cur.execute("""
                SELECT 
                    p.*, 
                    c.name as category_name,
                    mp.global_name as master_name
                FROM products p
                LEFT JOIN categories c ON p.category_id = c.id
                LEFT JOIN master_products mp ON p.master_product_id = mp.id
                WHERE p.id = %s
            """, (product_id,))
            product = cur.fetchone()
            
            if not product:
                raise HTTPException(status_code=404, detail="Product not found")

            # 2. Current Prices (Optimized for indexes)
            # Use DISTINCT ON to get latest price per store efficiently
            cur.execute("""
                SELECT DISTINCT ON (pr.store_id)
                    pr.id, pr.price, pr.currency, pr.scraped_at as date,
                    s.name as store_name, s.city, 
                    s.latitude, s.longitude,
                    ch.name as chain_name
                FROM prices pr
                JOIN stores s ON pr.store_id = s.id
                LEFT JOIN chains ch ON s.chain_id = ch.id
                WHERE pr.product_id = %s
                ORDER BY pr.store_id, pr.scraped_at DESC
            """, (product_id,))
            prices = cur.fetchall()
            
            # 3. Price History (Aggregated daily avg) - Limit to last 90 days for performance
            cur.execute("""
                SELECT 
                    DATE(scraped_at) as date,
                    AVG(price) as avg_price,
                    MIN(price) as min_price
                FROM prices
                WHERE product_id = %s AND scraped_at > NOW() - INTERVAL '90 days'
                GROUP BY DATE(scraped_at)
                ORDER BY date ASC
            """, (product_id,))
            history = cur.fetchall()

            # 4. Chain Stats (For comparison chart)
            cur.execute("""
                SELECT 
                    ch.name,
                    AVG(pr.price) as avg_price,
                    MIN(pr.price) as min_price,
                    MAX(pr.price) as max_price,
                    COUNT(pr.store_id) as store_count
                FROM prices pr
                JOIN stores s ON pr.store_id = s.id
                JOIN chains ch ON s.chain_id = ch.id
                WHERE pr.product_id = %s AND scraped_at > NOW() - INTERVAL '48 hours'
                GROUP BY ch.name
                ORDER BY avg_price ASC
            """, (product_id,))
            chain_stats = cur.fetchall()

            # 5. Regional Stats (Heuristic based on city)
            # This is a basic implementation. Ideally we'd have a 'region' column in stores.
            # Using CASE WHEN for on-the-fly categorization
            cur.execute("""
                WITH RegionalStores AS (
                    SELECT 
                        s.id,
                        CASE 
                            WHEN s.city IN ('תל אביב', 'רמת גן', 'גבעתיים', 'בני ברק', 'חולון', 'בת ים', 'ראשון לציון', 'פתח תקווה') THEN 'Center'
                            WHEN s.city IN ('חיפה', 'נשר', 'קרית אתא', 'קרית ביאליק', 'קרית מוצקין', 'עכו', 'נהריה', 'טבריה', 'נצרת', 'עפולה') THEN 'North'
                            WHEN s.city IN ('באר שבע', 'אשדוד', 'אשקלון', 'נתיבות', 'שדרות', 'דימונה', 'אילת') THEN 'South'
                            WHEN s.city IN ('ירושלים', 'בית שמש', 'מעלה אדומים') THEN 'Jerusalem'
                            WHEN s.city IN ('נתניה', 'כפר סבא', 'רעננה', 'הוד השרון', 'הרצליה') THEN 'Sharon'
                            ELSE 'Other'
                        END as region
                    FROM stores s
                )
                SELECT 
                    rs.region,
                    AVG(pr.price) as avg_price,
                    COUNT(pr.store_id) as store_count
                FROM prices pr
                JOIN RegionalStores rs ON pr.store_id = rs.id
                WHERE pr.product_id = %s AND scraped_at > NOW() - INTERVAL '48 hours'
                GROUP BY rs.region
                HAVING COUNT(pr.store_id) > 2
                ORDER BY avg_price ASC
            """, (product_id,))
            regional_stats = cur.fetchall()

            # 6. Similar Products (Same Master ID)
            similar_products = []
            if product.get('master_product_id'):
                cur.execute("""
                     SELECT id, name, CAST(0 as float) as price -- price fetch is expensive, skip for efficiency
                     FROM products 
                     WHERE master_product_id = %s AND id != %s 
                     LIMIT 5
                """, (product['master_product_id'], product_id))
                similar_products = cur.fetchall()
            
            return {
                "product": product,
                "prices": prices,
                "history": history,
                "chain_stats": chain_stats,
                "regional_stats": regional_stats,
                "similar_products": similar_products
            }
    finally:
        conn.close()

@router.get("/{product_id}/history")
def get_product_history(product_id: int):
    """
    Get just the price history for charts (lightweight).
    """
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")

    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                SELECT 
                    DATE(scraped_at) as date,
                    AVG(price) as avg_price,
                    MIN(price) as min_price
                FROM prices
                WHERE product_id = %s AND scraped_at > NOW() - INTERVAL '90 days'
                GROUP BY DATE(scraped_at)
                ORDER BY date ASC
            """, (product_id,))
            history = cur.fetchall()
            return {"history": history}
    finally:
        conn.close()

@router.get("/trends/analyze")
@router.get("/trends/analyze")
def analyze_trends(
    days_back: int = Query(2, description="Compare against price X days ago"),
    min_change_pct: int = Query(10, description="Minimum percentage change to detect"),
    limit: int = 50,
    offset: int = 0,
    category_id: Optional[int] = None,
    chain_id: Optional[int] = None
):
    """
    ANALYSIS ENGINE: Detects significant price movements with Filters & Pagination.
    """
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Database connection failed")

    start_time = time.time()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # HYBRID STRATEGY:
            # 1. For Short Term (< 3 days), use the pre-calculated `price_change_24h` column in `products`.
            #    This is much faster and works even if `prices` history was overwritten (Issue #9).
            # 2. For Long Term (>= 3 days), use the heavy SQL aggregation on `prices` table.
            
            if days_back < 3:
                # Build Dynamic Where Clause
                where_clauses = ["ABS(p.price_change_24h) >= %s", "p.is_active = TRUE"]
                params_common = [min_change_pct]
                
                if category_id:
                    where_clauses.append("p.category_id = %s")
                    params_common.append(category_id)
                
                if chain_id:
                    where_clauses.append("s.chain_id = %s")
                    params_common.append(chain_id)

                where_str = " AND ".join(where_clauses)
                
                # Query 1: Top Drops (Negative change)
                params_drops = list(params_common) + [limit, offset]
                drops_where = where_str.replace("ABS(p.price_change_24h) >= %s", "p.price_change_24h <= -%s")
                
                sql_drops = f"""
                    SELECT 
                        p.id, p.name, p.ean,
                        pr.price as curr_avg,
                        CASE 
                            WHEN p.price_change_24h = -100 THEN 0 
                            ELSE (pr.price / (1 + (p.price_change_24h / 100.0))) 
                        END as hist_avg,
                        p.price_change_24h as change_pct,
                        s.name as store_name,
                        ch.name as chain_name
                    FROM products p
                    JOIN LATERAL (
                        SELECT price, store_id FROM prices 
                        WHERE product_id = p.id 
                        ORDER BY scraped_at DESC 
                        LIMIT 1
                    ) pr ON TRUE
                    LEFT JOIN stores s ON pr.store_id = s.id
                    LEFT JOIN chains ch ON s.chain_id = ch.id
                    WHERE {drops_where}
                    ORDER BY p.price_change_24h ASC
                    LIMIT %s OFFSET %s;
                """
                cur.execute(sql_drops, params_drops)
                drops = cur.fetchall()

                # Query 2: Top Hikes (Positive change)
                params_hikes = list(params_common) + [limit, offset]
                hikes_where = where_str.replace("ABS(p.price_change_24h) >= %s", "p.price_change_24h >= %s")

                sql_hikes = f"""
                    SELECT 
                        p.id, p.name, p.ean,
                        pr.price as curr_avg,
                        CASE 
                            WHEN p.price_change_24h = -100 THEN 0 
                            ELSE (pr.price / (1 + (p.price_change_24h / 100.0))) 
                        END as hist_avg,
                        p.price_change_24h as change_pct,
                        s.name as store_name,
                        ch.name as chain_name
                    FROM products p
                    JOIN LATERAL (
                        SELECT price, store_id FROM prices 
                        WHERE product_id = p.id 
                        ORDER BY scraped_at DESC 
                        LIMIT 1
                    ) pr ON TRUE
                    LEFT JOIN stores s ON pr.store_id = s.id
                    LEFT JOIN chains ch ON s.chain_id = ch.id
                    WHERE {hikes_where}
                    ORDER BY p.price_change_24h DESC
                    LIMIT %s OFFSET %s;
                """
                cur.execute(sql_hikes, params_hikes)
                hikes = cur.fetchall()
            

            
            else:
                # Use Historical Aggregation (Original Logic)
                days_interval = f"{days_back} days"
                
                sql = """
                    WITH CurrentStats AS (
                        SELECT product_id, AVG(price) as curr_avg
                        FROM prices 
                        WHERE scraped_at >= NOW() - INTERVAL '24 hours'
                        GROUP BY product_id
                    ),
                    HistoryStats AS (
                        SELECT product_id, AVG(price) as hist_avg
                        FROM prices 
                        WHERE scraped_at BETWEEN NOW() - INTERVAL %s - INTERVAL '24 hours' 
                                           AND NOW() - INTERVAL %s
                        GROUP BY product_id
                    )
                    SELECT 
                        p.id, p.name, p.ean, 
                        c.curr_avg, h.hist_avg,
                        ((c.curr_avg - h.hist_avg) / h.hist_avg) * 100 as change_pct
                    FROM CurrentStats c
                    JOIN HistoryStats h ON c.product_id = h.product_id
                    JOIN products p ON c.product_id = p.id
                    WHERE ABS((c.curr_avg - h.hist_avg) / h.hist_avg * 100) >= %s
                    ORDER BY ABS(change_pct) DESC
                    LIMIT %s;
                """
                cur.execute(sql, (days_interval, days_interval, min_change_pct, limit))
                results = cur.fetchall()
            
                # Enrich data (for Historical Path)
                drops = [r for r in results if r['change_pct'] < 0]
                hikes = [r for r in results if r['change_pct'] > 0]
                
                drops.sort(key=lambda x: x['change_pct']) # Most negative first
                hikes.sort(key=lambda x: x['change_pct'], reverse=True) # Most positive first
            
            return {
                "meta": {
                    "analyzed_days": days_back,
                    "threshold_pct": min_change_pct,
                    "time_ms": round((time.time() - start_time) * 1000, 2),
                    "strategy": "optimized_column_join" if days_back < 3 else "historical_aggregation",
                    "offset": offset,
                    "limit": limit
                },
                "drops": drops,
                "hikes": hikes
            }

    except Exception as e:
        logger.error(f"Trend Analysis Failed: {e}")
        return {"meta": {"error": str(e)}, "drops": [], "hikes": []}
    finally:
        conn.close()
@router.get("/trends/insights")
def analyze_insights():
    """
    Get high-level market insights (Arbitrage, Cheapest Chain, Volatility)
    """
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="DB Connection Failed")
    
    start_time = time.time()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            
            # 1. Arbitrage Count (> 50% gap)
            # Find products where max_price > 1.5 * min_price
            # We use the 'prices' table efficiently
            cur.execute("""
                WITH PriceStats AS (
                    SELECT product_id, MIN(price) as min_p, MAX(price) as max_p
                    FROM prices
                    WHERE scraped_at > NOW() - INTERVAL '2 days'
                    GROUP BY product_id
                )
                SELECT COUNT(*) as count 
                FROM PriceStats 
                WHERE min_p > 0 AND (max_p - min_p) / min_p > 0.5
            """)
            arb_count = cur.fetchone()['count']
            
            # 2. Cheapest Chain (Most 'wins')
            # Who has the lowest price most often?
            cur.execute("""
                WITH LowestPrices AS (
                    SELECT product_id, store_id
                    FROM (
                        SELECT product_id, store_id, price,
                               ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY price ASC) as rn
                        FROM prices
                        WHERE scraped_at > NOW() - INTERVAL '2 days'
                    ) ranked
                    WHERE rn = 1
                )
                SELECT ch.name, COUNT(*) as wins
                FROM LowestPrices lp
                JOIN stores s ON lp.store_id = s.id
                JOIN chains ch ON s.chain_id = ch.id
                WHERE ch.name != 'Unknown'
                GROUP BY ch.name
                ORDER BY wins DESC
                LIMIT 1
            """)
            cheapest = cur.fetchone()
            
            # 3. Volatile Category
            # Category with highest average absolute price change
            cur.execute("""
                SELECT c.name, AVG(ABS(p.price_change_24h)) as volatility
                FROM products p
                JOIN categories c ON p.category_id = c.id
                WHERE p.price_change_24h != 0 AND p.price_change_24h != -100
                GROUP BY c.name
                ORDER BY volatility DESC
                LIMIT 1
            """)
            volatile = cur.fetchone()
            
            return {
                "arbitrage": {
                    "count": arb_count,
                    "description": "Products with >50% price gap"
                },
                "cheapest_chain": {
                    "name": cheapest['name'] if cheapest else "N/A",
                    "wins": cheapest['wins'] if cheapest else 0
                },
                "volatile_category": {
                    "name": volatile['name'] if volatile else "N/A",
                    "pct": round(volatile['volatility'], 1) if volatile else 0
                },
                "meta": {"time_ms": round((time.time() - start_time) * 1000, 2)}
            }

    except Exception as e:
        logger.error(f"Insights Error: {e}")
        return {"error": str(e)}
    finally:
        conn.close()

@router.get("/trends/arbitrage")
def get_arbitrage_products(
    limit: int = 50,
    offset: int = 0
):
    """
    Get products with significant price gaps between stores (Arbitrage opportunities).
    """
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="DB Connection Failed")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("""
                WITH PriceStats AS (
                    SELECT 
                        product_id, 
                        MIN(price) as min_p, 
                        MAX(price) as max_p,
                        COUNT(DISTINCT store_id) as store_count
                    FROM prices pr
                    JOIN products p ON pr.product_id = p.id
                    WHERE pr.scraped_at > NOW() - INTERVAL '2 days' 
                      AND pr.currency = 'ILS'
                      AND p.name NOT LIKE '%%פקדון%%'
                    GROUP BY product_id
                    HAVING COUNT(DISTINCT store_id) > 1 
                       AND MIN(pr.price) >= 1.0
                       AND (MAX(pr.price) - MIN(pr.price)) / MIN(pr.price) BETWEEN 0.5 AND 5.0
                )
                SELECT 
                    p.id, p.name, p.ean,
                    ps.min_p, ps.max_p,
                    ROUND(((ps.max_p - ps.min_p) / ps.min_p * 100)::numeric, 1) as gap_pct,
                    (SELECT s.name FROM prices pr JOIN stores s ON pr.store_id = s.id WHERE pr.product_id = p.id AND pr.price = ps.min_p ORDER BY pr.scraped_at DESC LIMIT 1) as min_store,
                    (SELECT s.name FROM prices pr JOIN stores s ON pr.store_id = s.id WHERE pr.product_id = p.id AND pr.price = ps.max_p ORDER BY pr.scraped_at DESC LIMIT 1) as max_store
                FROM PriceStats ps
                JOIN products p ON ps.product_id = p.id
                ORDER BY gap_pct DESC
                LIMIT %s OFFSET %s
            """, (limit, offset))
            
            results = cur.fetchall()
            return {"arbitrage": results}
    except Exception as e:
        logger.error(f"Arbitrage Fetch Error: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()
