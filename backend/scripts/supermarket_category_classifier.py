#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Supermarket Product Category Classifier
Classifies products into supermarket categories based on keywords
"""
import sys
import re
import psycopg2
from psycopg2.extras import RealDictCursor
from datetime import datetime

sys.stdout.reconfigure(encoding='utf-8')

DB_CONFIG = {
    'dbname': 'gogobe',
    'user': 'postgres',
    'password': '9152245-Gl!',
    'host': 'localhost',
    'port': '5432'
}

# ========================================
# Category Keywords (Hebrew + English)
# ========================================
CATEGORY_KEYWORDS = {
    'Dairy': [
        # חלב ומוצריו
        'חלב', 'גבינה', 'יוגורט', 'קוטג', 'לבנה', 'שמנת', 'חמאה', 'מרגרינה',
        'milk', 'cheese', 'yogurt', 'cottage', 'cream', 'butter',
        'גבינת', 'חלבי', 'דנונה', 'תנובה', 'יוטבתה', 'שטראוס',
        # ביצים
        'ביצ', 'egg',
    ],
    
    'Bakery': [
        # לחמים ומאפים
        'לחם', 'חלה', 'פיתה', 'בגט', 'מאפה', 'עוגה', 'עוגי', 'ביסקוויט',
        'bread', 'baguette', 'cake', 'cookie', 'biscuit', 'bagel',
        'שמרים', 'קמח', 'flour',
        'קרואסון', 'croissant', 'מאפין', 'muffin',
    ],
    
    'Beverages': [
        # משקאות
        'מיץ', 'קולה', 'פפסי', 'משקה', 'שתיה', 'בירה', 'יין',
        'juice', 'cola', 'pepsi', 'drink', 'beverage', 'beer', 'wine',
        'ספרייט', 'sprite', 'פאנטה', 'fanta', 'מים', 'water',
        'קפה', 'coffee', 'תה', 'tea', 'שוקו', 'chocolate milk',
        'אנרגיה', 'energy', 'ריד בול', 'red bull',
    ],
    
    'Snacks': [
        # חטיפים
        'חטיף', 'במבה', 'ביסלי', 'דוריטוס', 'צ\'יפס', 'פופקורן',
        'snack', 'chips', 'doritos', 'popcorn', 'pretzel',
        'שוקולד', 'chocolate', 'ממתק', 'candy', 'סוכרי',
        'גרעין', 'אגוז', 'nut', 'seed', 'קשיו', 'cashew',
        'וופל', 'wafer',
    ],
    
    'Meat': [
        # בשר ודגים
        'בשר', 'עוף', 'כבש', 'הודו', 'נקניק', 'המבורגר', 'קבב',
        'meat', 'chicken', 'beef', 'turkey', 'sausage', 'burger',
        'דג', 'טונה', 'סלמון', 'fish', 'tuna', 'salmon',
        'שניצל', 'schnitzel',
    ],
    
    'Vegetables': [
        # ירקות
        'עגבני', 'מלפפון', 'חסה', 'גזר', 'בצל', 'שום', 'תפוח אדמה',
        'tomato', 'cucumber', 'lettuce', 'carrot', 'onion', 'garlic', 'potato',
        'כרוב', 'cabbage', 'פלפל', 'pepper', 'חציל', 'eggplant',
        'ירק', 'vegetable', 'סלט', 'salad',
    ],
    
    'Fruits': [
        # פירות
        'תפוח', 'בננה', 'תפוז', 'אבטיח', 'מלון', 'ענב', 'אגס',
        'apple', 'banana', 'orange', 'watermelon', 'melon', 'grape', 'pear',
        'אננס', 'pineapple', 'תות', 'strawberry', 'פרי', 'fruit',
        'לימון', 'lemon', 'אשכולית', 'grapefruit',
    ],
    
    'Household': [
        # ניקיון ובית
        'סבון', 'סיר', 'נייר טואלט', 'מגבת', 'שקית', 'אקונומיקה',
        'soap', 'detergent', 'toilet paper', 'towel', 'bag', 'sponge',
        'ניקוי', 'cleaning', 'אקונומיקה', 'כלים', 'dishes',
        'שמפו', 'shampoo', 'מרכך', 'conditioner',
    ],
    
    'Personal Care': [
        # טיפוח ובריאות
        'משחת שיניים', 'מברשת שיניים', 'דאודורנט', 'קרם', 'סבון גוף',
        'toothpaste', 'toothbrush', 'deodorant', 'cream', 'body wash',
        'שיער', 'hair', 'עור', 'skin', 'טיפוח', 'care',
        'ויטמין', 'vitamin', 'תוסף', 'supplement',
    ],
    
    'Frozen Foods': [
        # מזון קפוא
        'קפוא', 'frozen', 'גלידה', 'ice cream', 'פיצה קפואה',
    ],
    
    'Canned Foods': [
        # שימורים
        'שימור', 'קופסה', 'canned', 'can', 'מלפפון חמוץ', 'pickle',
    ],
    
    'Spices': [
        # תבלינים
        'תבלין', 'spice', 'פלפל שחור', 'pepper', 'כמון', 'מלח', 'salt',
        'אורגנו', 'oregano', 'בזיליקום', 'basil',
    ],
    
    'Pasta & Rice': [
        # פסטה ואורז
        'פסטה', 'pasta', 'ספגטי', 'spaghetti', 'אורז', 'rice',
        'קוסקוס', 'couscous', 'נודלס', 'noodles',
    ],
    
    'Oils & Sauces': [
        # שמנים ורטבים
        'שמן', 'oil', 'זית', 'olive', 'רטב', 'sauce', 'קטשופ', 'ketchup',
        'מיונז', 'mayo', 'חרדל', 'mustard', 'סילאן', 'דבש', 'honey',
    ],
    
    'Baby Products': [
        # מוצרי תינוקות
        'תינוק', 'baby', 'חיתול', 'diaper', 'מוצץ', 'pacifier',
        'תרכובת', 'formula',
    ],
    
    'Pet Food': [
        # מזון לחיות מחמד
        'כלב', 'dog', 'חתול', 'cat', 'חיית מחמד', 'pet',
    ],
}


def normalize_text(text):
    """Normalize text for better matching"""
    if not text:
        return ""
    # Convert to lowercase
    text = text.lower()
    # Remove extra spaces
    text = ' '.join(text.split())
    return text


def classify_product(product_name, description=""):
    """
    Classify a product based on its name and description
    Returns: (category_name, confidence_score)
    """
    # Combine name and description
    full_text = normalize_text(f"{product_name} {description}")
    
    # Score each category
    category_scores = {}
    
    for category, keywords in CATEGORY_KEYWORDS.items():
        score = 0
        matched_keywords = []
        
        for keyword in keywords:
            keyword_lower = keyword.lower()
            # Exact word match (higher score)
            if f" {keyword_lower} " in f" {full_text} ":
                score += 10
                matched_keywords.append(keyword)
            # Partial match (lower score)
            elif keyword_lower in full_text:
                score += 5
                matched_keywords.append(keyword)
        
        if score > 0:
            category_scores[category] = {
                'score': score,
                'keywords': matched_keywords
            }
    
    # Get best match
    if category_scores:
        best_category = max(category_scores.items(), key=lambda x: x[1]['score'])
        return best_category[0], best_category[1]['score'], best_category[1]['keywords']
    
    return None, 0, []


def get_or_create_category(cur, category_name, vertical_id):
    """Get category ID or create if doesn't exist"""
    # Try to find existing category
    cur.execute("""
        SELECT id FROM categories 
        WHERE name = %s AND vertical_id = %s
    """, (category_name, vertical_id))
    
    result = cur.fetchone()
    if result:
        return result['id']
    
    # Create new category with unique slug
    slug = category_name.lower().replace(' ', '-').replace('&', 'and')
    
    # Try to insert, if slug exists, find another one
    attempt = 0
    while attempt < 10:
        try:
            test_slug = slug if attempt == 0 else f"{slug}-{attempt}"
            cur.execute("""
                INSERT INTO categories (name, slug, vertical_id)
                VALUES (%s, %s, %s)
                RETURNING id
            """, (category_name, test_slug, vertical_id))
            return cur.fetchone()['id']
        except psycopg2.errors.UniqueViolation:
            attempt += 1
            continue
    
    # If all attempts failed, find existing
    cur.execute("""
        SELECT id FROM categories 
        WHERE slug LIKE %s AND vertical_id = %s
        LIMIT 1
    """, (f"{slug}%", vertical_id))
    result = cur.fetchone()
    if result:
        return result['id']
    
    raise Exception(f"Could not create category {category_name}")


def classify_unclassified_products(limit=None, dry_run=False):
    """
    Classify products that don't have a category
    """
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        # Get Supermarkets vertical ID
        cur.execute("SELECT id FROM verticals WHERE slug = 'supermarket'")
        result = cur.fetchone()
        if not result:
            print("[ERROR] 'Supermarket' vertical not found!")
            return
        
        supermarket_vertical_id = result['id']
        
        # Get unclassified products
        query = """
            SELECT p.id, p.name, p.description, p.manufacturer_code
            FROM products p
            WHERE p.category_id IS NULL 
                AND p.vertical_id = %s
                AND p.is_active = true
        """
        
        if limit:
            query += f" LIMIT {limit}"
        
        cur.execute(query, (supermarket_vertical_id,))
        products = cur.fetchall()
        
        print(f"\n{'='*60}")
        print(f"Found {len(products)} unclassified products")
        print(f"{'='*60}\n")
        
        if dry_run:
            print("[DRY RUN MODE - No changes will be made]\n")
        
        # Statistics
        stats = {
            'classified': 0,
            'unclassified': 0,
            'by_category': {}
        }
        
        for i, product in enumerate(products, 1):
            category_name, score, keywords = classify_product(
                product['name'], 
                product['description'] or ""
            )
            
            if category_name and score >= 5:  # Minimum confidence threshold
                stats['classified'] += 1
                stats['by_category'][category_name] = stats['by_category'].get(category_name, 0) + 1
                
                if i <= 20:  # Show first 20
                    print(f"[{i:4}] ✅ {product['name'][:50]:50} → {category_name:20} (score: {score})")
                
                if not dry_run:
                    # Get or create category
                    category_id = get_or_create_category(cur, category_name, supermarket_vertical_id)
                    
                    # Update product
                    cur.execute("""
                        UPDATE products 
                        SET category_id = %s 
                        WHERE id = %s
                    """, (category_id, product['id']))
            else:
                stats['unclassified'] += 1
                if i <= 10:  # Show first 10 unclassified
                    print(f"[{i:4}] ❌ {product['name'][:50]:50} → Not classified")
        
        if not dry_run:
            conn.commit()
            print(f"\n✅ Committed changes to database")
        
        # Print statistics
        print(f"\n{'='*60}")
        print("Classification Results")
        print(f"{'='*60}")
        print(f"Total products:     {len(products)}")
        print(f"Classified:         {stats['classified']} ({stats['classified']/len(products)*100:.1f}%)")
        print(f"Unclassified:       {stats['unclassified']} ({stats['unclassified']/len(products)*100:.1f}%)")
        print(f"\nBy Category:")
        for cat, count in sorted(stats['by_category'].items(), key=lambda x: x[1], reverse=True):
            print(f"  {cat:25} {count:6} products")
        print(f"{'='*60}\n")
        
    except Exception as e:
        conn.rollback()
        print(f"[ERROR] {e}")
        import traceback
        traceback.print_exc()
    finally:
        conn.close()


if __name__ == '__main__':
    import argparse
    
    parser = argparse.ArgumentParser(description='Classify supermarket products into categories')
    parser.add_argument('--limit', type=int, help='Limit number of products to process')
    parser.add_argument('--dry-run', action='store_true', help='Show results without updating database')
    parser.add_argument('--test', type=str, help='Test classification for a product name')
    
    args = parser.parse_args()
    
    if args.test:
        # Test mode
        category, score, keywords = classify_product(args.test)
        print(f"\nProduct: {args.test}")
        print(f"Category: {category}")
        print(f"Score: {score}")
        print(f"Keywords: {', '.join(keywords)}")
    else:
        # Classification mode
        classify_unclassified_products(limit=args.limit, dry_run=args.dry_run)

