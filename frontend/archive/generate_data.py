"""
Generate JSON data from PostgreSQL for static website
Run this once to export data
"""

import psycopg2
from psycopg2.extras import RealDictCursor
import json
from pathlib import Path

# Database configuration
DB_CONFIG = {
    'dbname': 'gogobe',
    'user': 'postgres',
    'password': '9152245-Gl!',
    'host': 'localhost',
    'port': '5432'
}

def export_data():
    """Export database to JSON files"""
    print("🚀 Exporting database to JSON...")
    
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor(cursor_factory=RealDictCursor)
        
        # Export products with prices
        print("📦 Exporting products...")
        cur.execute("""
            SELECT 
                p.id,
                p.name,
                p.slug,
                p.description,
                p.sku,
                c.name as category_name,
                c.id as category_id,
                v.name as vertical_name,
                b.name as brand_name,
                p.created_at::text as created_at
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            LEFT JOIN verticals v ON p.vertical_id = v.id
            LEFT JOIN brands b ON p.brand_id = b.id
            WHERE p.is_active = TRUE
            ORDER BY p.id
        """)
        products = cur.fetchall()
        
        # Add prices to each product
        for product in products:
            cur.execute("""
                SELECT 
                    pr.price,
                    pr.currency,
                    pr.scraped_at::text as scraped_at,
                    s.name as supplier_name,
                    s.slug as supplier_slug,
                    s.id as supplier_id,
                    s.country_code
                FROM prices pr
                JOIN suppliers s ON pr.supplier_id = s.id
                WHERE pr.product_id = %s
                ORDER BY pr.price ASC
            """, (product['id'],))
            product['prices'] = cur.fetchall()
            
            # Calculate stats
            if product['prices']:
                prices_list = [p['price'] for p in product['prices']]
                product['min_price'] = min(prices_list)
                product['max_price'] = max(prices_list)
                product['avg_price'] = sum(prices_list) / len(prices_list)
                product['supplier_count'] = len(product['prices'])
                product['currency'] = product['prices'][0]['currency']
            else:
                product['min_price'] = None
                product['max_price'] = None
                product['avg_price'] = None
                product['supplier_count'] = 0
                product['currency'] = 'GBP'
        
        print(f"✅ Exported {len(products)} products")
        
        # Export categories
        print("📂 Exporting categories...")
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
            WHERE c.is_active = TRUE
            GROUP BY c.id, c.name, c.slug, v.name
            ORDER BY product_count DESC
        """)
        categories = cur.fetchall()
        print(f"✅ Exported {len(categories)} categories")
        
        # Export suppliers
        print("🏪 Exporting suppliers...")
        cur.execute("""
            SELECT 
                s.id,
                s.name,
                s.slug,
                s.country_code,
                COUNT(DISTINCT pr.product_id) as product_count
            FROM suppliers s
            LEFT JOIN prices pr ON s.id = pr.supplier_id
            WHERE s.is_active = TRUE
            GROUP BY s.id, s.name, s.slug, s.country_code
            ORDER BY product_count DESC
        """)
        suppliers = cur.fetchall()
        print(f"✅ Exported {len(suppliers)} suppliers")
        
        # Export stats
        print("📊 Calculating stats...")
        cur.execute("SELECT COUNT(*) as count FROM products WHERE is_active = TRUE")
        total_products = cur.fetchone()['count']
        
        cur.execute("SELECT COUNT(*) as count FROM prices")
        total_prices = cur.fetchone()['count']
        
        cur.execute("SELECT COUNT(*) as count FROM suppliers WHERE is_active = TRUE")
        total_suppliers = cur.fetchone()['count']
        
        stats = {
            'total_products': total_products,
            'total_prices': total_prices,
            'total_suppliers': total_suppliers,
            'last_updated': None
        }
        
        cur.execute("""
            SELECT source_name, scan_date::text, products_imported 
            FROM scraped_sources 
            WHERE scan_status = 'completed'
            ORDER BY scan_date DESC 
            LIMIT 1
        """)
        latest = cur.fetchone()
        if latest:
            stats['latest_scan'] = dict(latest)
            stats['last_updated'] = latest['scan_date']
        
        print(f"✅ Stats: {total_products} products, {total_suppliers} suppliers")
        
        # Save to JSON files
        output_dir = Path(__file__).parent / 'data'
        output_dir.mkdir(exist_ok=True)
        
        print(f"\n💾 Saving to {output_dir}...")
        
        with open(output_dir / 'products.json', 'w', encoding='utf-8') as f:
            json.dump(products, f, ensure_ascii=False, indent=2)
        print(f"✅ Saved products.json ({len(products)} items)")
        
        with open(output_dir / 'categories.json', 'w', encoding='utf-8') as f:
            json.dump(categories, f, ensure_ascii=False, indent=2)
        print(f"✅ Saved categories.json ({len(categories)} items)")
        
        with open(output_dir / 'suppliers.json', 'w', encoding='utf-8') as f:
            json.dump(suppliers, f, ensure_ascii=False, indent=2)
        print(f"✅ Saved suppliers.json ({len(suppliers)} items)")
        
        with open(output_dir / 'stats.json', 'w', encoding='utf-8') as f:
            json.dump(stats, f, ensure_ascii=False, indent=2)
        print(f"✅ Saved stats.json")
        
        conn.close()
        
        print("\n" + "="*50)
        print("🎉 Export Complete!")
        print("="*50)
        print(f"\nData exported to: {output_dir}")
        print(f"\nYou can now open: frontend/index_static.html")
        print("(No server needed!)")
        
        return True
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        return False


if __name__ == "__main__":
    export_data()









