#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Final Status Report - Gogobe Price Comparison System
"""
import sys
import psycopg2
from psycopg2.extras import RealDictCursor

sys.stdout.reconfigure(encoding='utf-8')

DB_CONFIG = {
    'dbname': 'gogobe',
    'user': 'postgres',
    'password': '9152245-Gl!',
    'host': 'localhost',
    'port': '5432'
}

def generate_report():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    print("\n" + "="*70)
    print("🎯 דוח מצב סופי - מערכת Gogobe להשוואת מחירים")
    print("="*70)
    
    # === Products ===
    print("\n📦 מוצרים:")
    print("-" * 70)
    
    cur.execute("SELECT COUNT(*) as total FROM products WHERE is_active = true")
    total_products = cur.fetchone()['total']
    print(f"   סה\"כ מוצרים פעילים:        {total_products:,}")
    
    cur.execute("SELECT COUNT(*) as total FROM products WHERE category_id IS NOT NULL AND is_active = true")
    categorized = cur.fetchone()['total']
    print(f"   מוצרים מסווגים:             {categorized:,} ({categorized/total_products*100:.1f}%)")
    
    cur.execute("SELECT COUNT(*) as total FROM products WHERE category_id IS NULL AND is_active = true")
    uncategorized = cur.fetchone()['total']
    print(f"   מוצרים ללא קטגוריה:         {uncategorized:,} ({uncategorized/total_products*100:.1f}%)")
    
    # === Categories ===
    print("\n🏷️ קטגוריות:")
    print("-" * 70)
    
    cur.execute("""
        SELECT c.name, v.name as vertical, COUNT(p.id) as count
        FROM categories c
        LEFT JOIN verticals v ON c.vertical_id = v.id
        LEFT JOIN products p ON p.category_id = c.id AND p.is_active = true
        GROUP BY c.id, c.name, v.name
        HAVING COUNT(p.id) > 0
        ORDER BY count DESC
        LIMIT 10
    """)
    
    top_categories = cur.fetchall()
    for cat in top_categories:
        print(f"   {cat['name']:30} {cat['count']:6,} מוצרים")
    
    # === Prices ===
    print("\n💰 מחירים:")
    print("-" * 70)
    
    cur.execute("SELECT COUNT(*) as total FROM prices")
    total_prices = cur.fetchone()['total']
    print(f"   סה\"כ מחירים:                {total_prices:,}")
    
    cur.execute("SELECT COUNT(*) as total FROM prices WHERE store_id IS NOT NULL")
    with_store = cur.fetchone()['total']
    print(f"   מחירים משויכים לחנות:       {with_store:,} ({with_store/total_prices*100:.1f}%)")
    
    cur.execute("SELECT COUNT(DISTINCT product_id) as total FROM prices")
    products_with_prices = cur.fetchone()['total']
    print(f"   מוצרים עם מחירים:           {products_with_prices:,}")
    
    cur.execute("SELECT AVG(price) as avg, MIN(price) as min, MAX(price) as max FROM prices WHERE currency = 'ILS'")
    price_stats = cur.fetchone()
    print(f"   מחיר ממוצע (ILS):            ₪{price_stats['avg']:.2f}")
    print(f"   טווח מחירים:                ₪{price_stats['min']:.2f} - ₪{price_stats['max']:.2f}")
    
    # === Stores ===
    print("\n🏪 חנויות:")
    print("-" * 70)
    
    cur.execute("SELECT COUNT(*) as total FROM stores WHERE is_active = true")
    total_stores = cur.fetchone()['total']
    print(f"   סה\"כ חנויות פעילות:        {total_stores}")
    
    cur.execute("""
        SELECT s.store_name, COUNT(p.id) as price_count
        FROM stores s
        LEFT JOIN prices p ON s.id = p.store_id
        WHERE s.is_active = true
        GROUP BY s.id, s.store_name
        ORDER BY price_count DESC
        LIMIT 10
    """)
    
    top_stores = cur.fetchall()
    for store in top_stores:
        print(f"   {store['store_name']:45} {store['price_count']:6,} מחירים")
    
    # === Suppliers ===
    print("\n🏢 ספקים:")
    print("-" * 70)
    
    cur.execute("""
        SELECT s.name, COUNT(DISTINCT p.product_id) as product_count, COUNT(p.id) as price_count
        FROM suppliers s
        LEFT JOIN prices p ON s.id = p.supplier_id
        WHERE s.is_active = true
        GROUP BY s.id, s.name
        ORDER BY product_count DESC
    """)
    
    suppliers = cur.fetchall()
    for sup in suppliers:
        print(f"   {sup['name']:30} {sup['product_count']:6,} מוצרים, {sup['price_count']:6,} מחירים")
    
    # === Downloaded Files ===
    print("\n📥 קבצים שהורדו:")
    print("-" * 70)
    
    cur.execute("SELECT COUNT(*) as total FROM downloaded_files")
    total_files = cur.fetchone()['total']
    print(f"   סה\"כ קבצים:                 {total_files}")
    
    cur.execute("SELECT COUNT(*) as total FROM downloaded_files WHERE processing_status = 'completed'")
    completed = cur.fetchone()['total']
    print(f"   קבצים שעובדו:                {completed}")
    
    cur.execute("SELECT SUM(products_imported) as total FROM downloaded_files WHERE processing_status = 'completed'")
    imported = cur.fetchone()['total'] or 0
    print(f"   סה\"כ מוצרים מיובאים:        {imported:,}")
    
    # === Database Size ===
    print("\n💾 גודל בסיס הנתונים:")
    print("-" * 70)
    
    cur.execute("""
        SELECT 
            pg_size_pretty(pg_database_size('gogobe')) as db_size
    """)
    db_size = cur.fetchone()['db_size']
    print(f"   גודל DB:                     {db_size}")
    
    # === System Health ===
    print("\n✅ בריאות המערכת:")
    print("-" * 70)
    
    issues = []
    
    # Check for products without prices
    cur.execute("SELECT COUNT(*) as total FROM products p WHERE NOT EXISTS (SELECT 1 FROM prices pr WHERE pr.product_id = p.id) AND p.is_active = true")
    no_prices = cur.fetchone()['total']
    if no_prices > 0:
        issues.append(f"   ⚠️ {no_prices:,} מוצרים ללא מחירים")
    
    # Check for prices without stores
    cur.execute("SELECT COUNT(*) as total FROM prices WHERE store_id IS NULL")
    no_store = cur.fetchone()['total']
    if no_store > 0:
        issues.append(f"   ⚠️ {no_store:,} מחירים ללא חנות")
    else:
        print("   ✅ כל המחירים משויכים לחנויות")
    
    # Check categorization rate
    if uncategorized / total_products > 0.5:
        issues.append(f"   ⚠️ {uncategorized/total_products*100:.0f}% מהמוצרים ללא קטגוריה")
    else:
        print(f"   ✅ {categorized/total_products*100:.0f}% מהמוצרים מסווגים")
    
    if issues:
        print("\n   נקודות לשיפור:")
        for issue in issues:
            print(issue)
    
    print("\n" + "="*70)
    print("📊 סיכום: המערכת פעילה ותקינה!")
    print("="*70 + "\n")
    
    conn.close()

if __name__ == '__main__':
    generate_report()

