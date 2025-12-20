"""
בדיקה של מוצרים וסניפים - דרך חיבור ישיר
"""

# Direct DB check - no fancy imports
try:
    import psycopg2
    from psycopg2.extras import RealDictCursor
    
    print("=" * 70)
    print(" 🔍 בדיקת מוצרים וסניפים - KingStore")
    print("=" * 70)
    print()
    
    # Connect
    conn = psycopg2.connect(
        dbname='gogobe',
        user='postgres',
        password='9152245-Gl!',
        host='localhost',
        port='5432'
    )
    
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    # 1. Products count
    print("1. כמה מוצרים יש:")
    cur.execute("""
        SELECT COUNT(*) as cnt
        FROM products
        WHERE vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%supermarket%')
    """)
    row = cur.fetchone()
    print(f"   {row['cnt']:,} מוצרים")
    print()
    
    # 2. Stores count
    print("2. כמה חנויות יש:")
    cur.execute("SELECT COUNT(*) as cnt FROM stores")
    row = cur.fetchone()
    print(f"   {row['cnt']} חנויות")
    print()
    
    # 3. Stores with prices
    print("3. חנויות עם מחירים:")
    cur.execute("""
        SELECT COUNT(DISTINCT store_id) as cnt
        FROM prices
        WHERE store_id IS NOT NULL
    """)
    row = cur.fetchone()
    print(f"   {row['cnt']} חנויות עם מחירים")
    print()
    
    # 4. Products in multiple stores
    print("4. מוצרים שנמכרים ביותר מסניף אחד:")
    cur.execute("""
        SELECT 
            p.name,
            COUNT(DISTINCT pr.store_id) as store_count
        FROM products p
            JOIN prices pr ON p.id = pr.product_id
        WHERE 
            p.vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%supermarket%')
            AND pr.store_id IS NOT NULL
        GROUP BY p.id, p.name
        HAVING COUNT(DISTINCT pr.store_id) > 1
        ORDER BY store_count DESC
        LIMIT 10
    """)
    
    rows = cur.fetchall()
    
    if rows:
        print(f"   כן! {len(rows)} דוגמאות:")
        for row in rows:
            name = row['name'][:55] if len(row['name']) > 55 else row['name']
            count = row['store_count']
            print(f"      • {name}: {count} סניפים")
    else:
        print("   ❌ אין מוצרים שנמכרים ביותר מסניף אחד!")
        print("      זו בעיה!")
    print()
    
    # 5. Top stores
    print("5. חנויות עם הכי הרבה מחירים:")
    cur.execute("""
        SELECT 
            s.store_name,
            s.store_code,
            COUNT(pr.id) as price_count
        FROM stores s
            LEFT JOIN prices pr ON s.id = pr.store_id
        GROUP BY s.id, s.store_name, s.store_code
        ORDER BY price_count DESC
        LIMIT 10
    """)
    
    rows = cur.fetchall()
    
    for i, row in enumerate(rows, 1):
        name = row['store_name'] or 'ללא שם'
        code = row['store_code'] or 'N/A'
        count = row['price_count']
        print(f"   {i:2d}. {name} ({code}): {count:,} מחירים")
    print()
    
    # 6. Statistics
    print("6. סטטיסטיקות כלליות:")
    cur.execute("""
        SELECT 
            COUNT(*) as total_prices,
            COUNT(DISTINCT product_id) as unique_products,
            COUNT(DISTINCT store_id) as unique_stores
        FROM prices
        WHERE store_id IS NOT NULL
    """)
    
    row = cur.fetchone()
    print(f"   סה\"כ מחירים: {row['total_prices']:,}")
    print(f"   מוצרים ייחודיים: {row['unique_products']:,}")
    print(f"   סניפים ייחודיים: {row['unique_stores']}")
    print()
    
    # 7. Distribution
    print("7. פילוח - מוצרים לפי כמות סניפים:")
    cur.execute("""
        SELECT 
            store_count,
            COUNT(*) as product_count
        FROM (
            SELECT 
                p.id,
                COUNT(DISTINCT pr.store_id) as store_count
            FROM products p
                JOIN prices pr ON p.id = pr.product_id
            WHERE 
                p.vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%supermarket%')
                AND pr.store_id IS NOT NULL
            GROUP BY p.id
        ) AS product_stores
        GROUP BY store_count
        ORDER BY store_count
    """)
    
    rows = cur.fetchall()
    
    if rows:
        for row in rows[:20]:
            count = row['store_count']
            products = row['product_count']
            bar = "█" * min(int(products / 100), 40)
            print(f"   {count:2d} סניפים: {products:6,} מוצרים {bar}")
        
        if len(rows) > 20:
            print(f"   ... ועוד {len(rows) - 20} שורות")
    print()
    
    # 8. Sample product
    print("8. דוגמא - מוצר אקראי עם המחירים שלו:")
    cur.execute("""
        SELECT id, name
        FROM products
        WHERE vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%supermarket%')
            AND id IN (
                SELECT DISTINCT product_id
                FROM prices
                WHERE store_id IS NOT NULL
            )
        ORDER BY RANDOM()
        LIMIT 1
    """)
    
    product = cur.fetchone()
    
    if product:
        print(f"   מוצר: {product['name'][:60]}")
        print()
        
        cur.execute("""
            SELECT 
                s.store_name,
                s.store_code,
                pr.price
            FROM prices pr
                JOIN stores s ON pr.store_id = s.id
            WHERE pr.product_id = %s
            ORDER BY pr.price
        """, (product['id'],))
        
        prices = cur.fetchall()
        print(f"   מחירים ({len(prices)} סניפים):")
        
        for row in prices[:10]:
            name = row['store_name'] or 'ללא שם'
            code = row['store_code'] or 'N/A'
            price = row['price']
            print(f"      • {name} ({code}): ₪{price:.2f}")
        
        if len(prices) > 10:
            print(f"      ... ועוד {len(prices) - 10} סניפים")
    print()
    
    cur.close()
    conn.close()
    
    print("=" * 70)
    print(" ✅ הבדיקה הושלמה!")
    print("=" * 70)
    
except ImportError as e:
    print(f"❌ אין psycopg2: {e}")
    print()
    print("התקן עם: pip install psycopg2-binary")
    
except Exception as e:
    print(f"❌ שגיאה: {e}")
    import traceback
    traceback.print_exc()

