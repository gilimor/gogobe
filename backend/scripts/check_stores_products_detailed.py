"""
בדיקה מפורטת של מוצרים וסניפים ב-KingStore
"""

import psycopg2
from psycopg2.extras import RealDictCursor

# Database connection
DB_CONFIG = {
    'dbname': 'gogobe',
    'user': 'postgres',
    'password': '9152245-Gl!',
    'host': 'localhost'
}


def main():
    """Run detailed check"""
    print("=" * 60)
    print("🔍 בדיקת מוצרים וסניפים - KingStore")
    print("=" * 60)
    print()
    
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    # 1. כמה מוצרים
    print("1️⃣  כמה מוצרים יש לנו:")
    cur.execute("""
        SELECT COUNT(*) as count
        FROM products
        WHERE vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%supermarket%')
    """)
    product_count = cur.fetchone()['count']
    print(f"   ✅ {product_count:,} מוצרים")
    print()
    
    # 2. כמה חנויות
    print("2️⃣  כמה חנויות יש:")
    cur.execute("SELECT COUNT(*) as count FROM stores")
    store_count = cur.fetchone()['count']
    print(f"   ✅ {store_count} חנויות")
    print()
    
    # 3. מוצרים במספר סניפים
    print("3️⃣  האם יש מוצרים שנמכרים ביותר מסניף אחד:")
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
        LIMIT 15
    """)
    
    multi_store_products = cur.fetchall()
    
    if multi_store_products:
        print(f"   ✅ כן! מצאתי {len(multi_store_products)} מוצרים:")
        for row in multi_store_products[:10]:
            name = row['name'][:50]
            count = row['store_count']
            print(f"      • {name}... : {count} סניפים")
        if len(multi_store_products) > 10:
            print(f"      ... ועוד {len(multi_store_products) - 10} מוצרים")
    else:
        print("   ❌ אין מוצרים שנמכרים ביותר מסניף אחד!")
        print("      זו בעיה! כל מוצר צריך להיות במספר סניפים")
    print()
    
    # 4. דוגמא למוצר ראשון
    print("4️⃣  דוגמא - מוצר ראשון עם המחירים שלו:")
    cur.execute("""
        SELECT name, id
        FROM products
        WHERE vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%supermarket%')
        LIMIT 1
    """)
    
    first_product = cur.fetchone()
    
    if first_product:
        product_name = first_product['name']
        product_id = first_product['id']
        
        print(f"   מוצר: {product_name[:60]}")
        print()
        
        # Get prices
        cur.execute("""
            SELECT 
                s.store_name,
                s.store_code,
                s.city,
                pr.price
            FROM prices pr
                JOIN stores s ON pr.store_id = s.id
            WHERE pr.product_id = %s
            ORDER BY pr.price
        """, (product_id,))
        
        prices = cur.fetchall()
        
        print(f"   מחירים: {len(prices)} סניפים")
        if prices:
            for row in prices[:10]:
                store_name = row['store_name'] or 'ללא שם'
                store_code = row['store_code'] or 'N/A'
                city = row['city'] or ''
                price = row['price']
                print(f"      • {store_name} (קוד: {store_code}) {city}: ₪{price:.2f}")
            if len(prices) > 10:
                print(f"      ... ועוד {len(prices) - 10} סניפים")
        else:
            print("      ❌ אין מחירים למוצר הזה!")
    print()
    
    # 5. רשימת חנויות
    print("5️⃣  רשימת כל החנויות:")
    cur.execute("""
        SELECT 
            s.store_name,
            s.store_code,
            s.city,
            COUNT(pr.id) as price_count
        FROM stores s
            LEFT JOIN prices pr ON s.id = pr.store_id
        GROUP BY s.id, s.store_name, s.store_code, s.city
        ORDER BY price_count DESC, s.store_name
    """)
    
    stores = cur.fetchall()
    print(f"   סה\"כ: {len(stores)} חנויות")
    print()
    
    stores_with_prices = [s for s in stores if s['price_count'] > 0]
    stores_without_prices = [s for s in stores if s['price_count'] == 0]
    
    print(f"   📊 עם מחירים: {len(stores_with_prices)} חנויות")
    print(f"   📊 ללא מחירים: {len(stores_without_prices)} חנויות")
    print()
    
    if stores_with_prices:
        print("   חנויות עם הכי הרבה מחירים:")
        for i, row in enumerate(stores_with_prices[:10], 1):
            name = row['store_name'] or 'ללא שם'
            code = row['store_code'] or 'N/A'
            city = row['city'] or ''
            count = row['price_count']
            print(f"      {i:2d}. {name} ({code}) {city}: {count:,} מחירים")
    print()
    
    if stores_without_prices:
        print(f"   ⚠️  חנויות ללא מחירים ({len(stores_without_prices)}):")
        for i, row in enumerate(stores_without_prices[:10], 1):
            name = row['store_name'] or 'ללא שם'
            code = row['store_code'] or 'N/A'
            city = row['city'] or ''
            print(f"      {i:2d}. {name} ({code}) {city}")
        if len(stores_without_prices) > 10:
            print(f"      ... ועוד {len(stores_without_prices) - 10}")
    print()
    
    # 6. סטטיסטיקות מחירים
    print("6️⃣  סטטיסטיקות מחירים:")
    cur.execute("""
        SELECT 
            COUNT(*) as total_prices,
            COUNT(DISTINCT product_id) as unique_products,
            COUNT(DISTINCT store_id) as unique_stores,
            AVG(price) as avg_price,
            MIN(price) as min_price,
            MAX(price) as max_price
        FROM prices
        WHERE store_id IS NOT NULL
    """)
    
    stats = cur.fetchone()
    print(f"   • סה\"כ מחירים: {stats['total_prices']:,}")
    print(f"   • מוצרים ייחודיים: {stats['unique_products']:,}")
    print(f"   • סניפים ייחודיים: {stats['unique_stores']}")
    print(f"   • מחיר ממוצע: ₪{stats['avg_price']:.2f}")
    print(f"   • מחיר מינימלי: ₪{stats['min_price']:.2f}")
    print(f"   • מחיר מקסימלי: ₪{stats['max_price']:.2f}")
    print()
    
    # 7. ניתוח - מוצרים לפי כמות סניפים
    print("7️⃣  ניתוח - מוצרים לפי כמות סניפים:")
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
    
    distribution = cur.fetchall()
    
    if distribution:
        print("   פילוח מוצרים:")
        for row in distribution[:15]:
            count = row['store_count']
            products = row['product_count']
            bar = "█" * min(int(products / 100), 50)
            print(f"      {count:2d} סניפים: {products:5,} מוצרים {bar}")
    print()
    
    # Close connection
    cur.close()
    conn.close()
    
    print("=" * 60)
    print("✅ הבדיקה הושלמה!")
    print("=" * 60)


if __name__ == "__main__":
    main()


