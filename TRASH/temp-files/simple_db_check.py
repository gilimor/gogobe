"""
סקריפט בדיקה פשוט - יבוא 2 קבצי XML ובדיקת התוצאה
"""
import sys
from pathlib import Path

# Add backend to path
backend_path = Path(__file__).parent / 'backend'
sys.path.insert(0, str(backend_path))

try:
    from database.db_connection import get_db_connection
    
    print("=" * 70)
    print("בדיקה: האם יובאו מוצרים?")
    print("=" * 70)
    print()
    
    conn = get_db_connection()
    if not conn:
        print("לא מצליח להתחבר ל-DB")
        exit(1)
    
    cur = conn.cursor()
    
    # Check if we have data
    print("1. כמה מוצרים supermarket יש לנו עכשיו:")
    cur.execute("""
        SELECT COUNT(*)
        FROM products
        WHERE vertical_id = (SELECT id FROM verticals WHERE name ILIKE '%supermarket%')
    """)
    count = cur.fetchone()[0]
    print(f"   {count:,} מוצרים")
    print()
    
    print("2. כמה חנויות יש:")
    cur.execute("SELECT COUNT(*) FROM stores")
    store_count = cur.fetchone()[0]
    print(f"   {store_count} חנויות")
    print()
    
    # Check for specific product
    print("3. חיפוש מוצר ספציפי: 'פיקדון בקבוקים'")
    cur.execute("""
        SELECT p.id, p.name
        FROM products p
        WHERE p.name LIKE '%פיקדון בקבוקים%'
        LIMIT 1
    """)
    
    product = cur.fetchone()
    
    if product:
        product_id, product_name = product
        print(f"   נמצא: {product_name} (ID: {product_id})")
        print()
        
        # Get prices for this product
        print(f"4. מחירים עבור '{product_name}':")
        cur.execute("""
            SELECT 
                s.store_code,
                s.store_name,
                pr.price
            FROM prices pr
                LEFT JOIN stores s ON pr.store_id = s.id
            WHERE pr.product_id = %s
            ORDER BY s.store_code
        """, (product_id,))
        
        prices = cur.fetchall()
        
        if prices:
            print(f"   {len(prices)} מחירים:")
            for store_code, store_name, price in prices[:10]:
                store_name = store_name or 'ללא שם'
                store_code = store_code or 'N/A'
                print(f"      סניף {store_code} ({store_name}): ₪{price}")
            
            if len(prices) > 10:
                print(f"      ...ועוד {len(prices) - 10}")
        else:
            print("   אין מחירים למוצר הזה!")
    else:
        print("   לא נמצא המוצר 'פיקדון בקבוקים'")
        print("   זה אומר שלא יובאו הקבצים, או שהיבוא נכשל")
    print()
    
    cur.close()
    conn.close()
    
    print("=" * 70)
    print("✅ הבדיקה הושלמה")
    print("=" * 70)

except ImportError as e:
    print(f"לא מצליח לטעון את המודול: {e}")
except Exception as e:
    print(f"שגיאה: {e}")
    import traceback
    traceback.print_exc()

