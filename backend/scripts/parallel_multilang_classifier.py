#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Multi-Source Automated Price Management System
Handles multiple price sources in parallel with automatic classification
"""
import sys
import os
import json
import time
import hashlib
from datetime import datetime
from typing import List, Dict, Optional, Tuple
from concurrent.futures import ProcessPoolExecutor, ThreadPoolExecutor, as_completed
from multiprocessing import cpu_count
import psycopg2
from psycopg2.extras import RealDictCursor

sys.stdout.reconfigure(encoding='utf-8')

# ========================================
# Configuration
# ========================================

DB_CONFIG = {
    'dbname': 'gogobe',
    'user': 'postgres',
    'password': '9152245-Gl!',
    'host': 'localhost',
    'port': '5432'
}

# How many parallel processes/threads
MAX_WORKERS = min(cpu_count(), 8)  # Don't overload the system
CHUNK_SIZE = 1000  # Products per batch

# ========================================
# Multi-Language Category Keywords
# ========================================

CATEGORY_KEYWORDS_MULTILANG = {
    'Dairy': {
        'he': ['חלב', 'גבינה', 'יוגורט', 'קוטג', 'לבנה', 'שמנת', 'חמאה', 'מרגרינה', 'ביצ'],
        'en': ['milk', 'cheese', 'yogurt', 'cottage', 'cream', 'butter', 'egg', 'dairy'],
        'ar': ['حليب', 'جبن', 'زبادي', 'قشدة', 'زبدة', 'بيض'],
        'ru': ['молоко', 'сыр', 'йогурт', 'творог', 'сливки', 'масло', 'яйцо'],
        'brands': ['תנובה', 'tnuva', 'שטראוס', 'strauss', 'יוטבתה', 'דנונה', 'danone']
    },
    
    'Bakery': {
        'he': ['לחם', 'חלה', 'פיתה', 'בגט', 'מאפה', 'עוגה', 'עוגי', 'ביסקוויט', 'קמח'],
        'en': ['bread', 'baguette', 'cake', 'cookie', 'biscuit', 'bagel', 'flour', 'pastry'],
        'ar': ['خبز', 'كعك', 'بسكويت', 'دقيق'],
        'ru': ['хлеб', 'булка', 'печенье', 'торт', 'мука']
    },
    
    'Beverages': {
        'he': ['מיץ', 'קולה', 'פפסי', 'משקה', 'שתיה', 'בירה', 'יין', 'מים', 'קפה', 'תה', 'שוקו'],
        'en': ['juice', 'cola', 'pepsi', 'drink', 'beverage', 'beer', 'wine', 'water', 'coffee', 'tea'],
        'ar': ['عصير', 'كولا', 'مشروب', 'بيرة', 'نبيذ', 'ماء', 'قهوة', 'شاي'],
        'ru': ['сок', 'кола', 'напиток', 'пиво', 'вино', 'вода', 'кофе', 'чай'],
        'brands': ['קוקה קולה', 'coca cola', 'ספרייט', 'sprite', 'פריגת', 'prigat', 'טרופיקנה']
    },
    
    'Meat': {
        'he': ['בשר', 'עוף', 'כבש', 'הודו', 'נקניק', 'המבורגר', 'קבב', 'שניצל', 'דג', 'טונה', 'סלמון'],
        'en': ['meat', 'chicken', 'beef', 'turkey', 'sausage', 'burger', 'schnitzel', 'fish', 'tuna', 'salmon'],
        'ar': ['لحم', 'دجاج', 'لحم بقر', 'سمك', 'تونة'],
        'ru': ['мясо', 'курица', 'говядина', 'рыба', 'тунец'],
        'brands': ['עוף טרי', 'זוגלובק', 'יכין', 'טיב טעם']
    },
    
    'Vegetables': {
        'he': ['עגבני', 'מלפפון', 'חסה', 'גזר', 'בצל', 'שום', 'תפוח אדמה', 'כרוב', 'פלפל', 'חציל', 'ירק', 'סלט'],
        'en': ['tomato', 'cucumber', 'lettuce', 'carrot', 'onion', 'garlic', 'potato', 'cabbage', 'pepper', 'eggplant', 'vegetable', 'salad'],
        'ar': ['طماطم', 'خيار', 'خس', 'جزر', 'بصل', 'ثوم', 'بطاطا', 'فلفل', 'خضار'],
        'ru': ['помидор', 'огурец', 'салат', 'морковь', 'лук', 'чеснок', 'картофель', 'овощ']
    },
    
    'Fruits': {
        'he': ['תפוח', 'בננה', 'תפוז', 'אבטיח', 'מלון', 'ענב', 'אגס', 'אננס', 'תות', 'פרי', 'לימון', 'אשכולית'],
        'en': ['apple', 'banana', 'orange', 'watermelon', 'melon', 'grape', 'pear', 'pineapple', 'strawberry', 'fruit', 'lemon'],
        'ar': ['تفاح', 'موز', 'برتقال', 'بطيخ', 'عنب', 'فراولة', 'فاكهة'],
        'ru': ['яблоко', 'банан', 'апельсин', 'арбуз', 'виноград', 'груша', 'фрукт']
    },
    
    'Snacks': {
        'he': ['חטיף', 'במבה', 'ביסלי', 'דוריטוס', 'צ\'יפס', 'פופקורן', 'שוקולד', 'ממתק', 'סוכרי', 'גרעין', 'אגוז', 'וופל'],
        'en': ['snack', 'chips', 'doritos', 'popcorn', 'chocolate', 'candy', 'nut', 'seed', 'wafer'],
        'ar': ['وجبة خفيفة', 'شوكولاتة', 'حلوى', 'مكسرات'],
        'ru': ['закуска', 'чипсы', 'шоколад', 'конфеты', 'орехи'],
        'brands': ['במבה', 'bamba', 'ביסלי', 'bissli', 'elite', 'אליט']
    },
    
    'Household': {
        'he': ['סבון', 'ניקוי', 'נייר טואלט', 'מגבת', 'שקית', 'אקונומיקה', 'כלים', 'שמפו', 'מרכך'],
        'en': ['soap', 'detergent', 'toilet paper', 'towel', 'bag', 'sponge', 'cleaning', 'dishes', 'shampoo'],
        'ar': ['صابون', 'منظف', 'ورق تواليت', 'كيس', 'تنظيف'],
        'ru': ['мыло', 'моющее средство', 'туалетная бумага', 'полотенце', 'пакет']
    },
    
    'Personal Care': {
        'he': ['משחת שיניים', 'מברשת שיניים', 'דאודורנט', 'קרם', 'סבון גוף', 'טיפוח', 'שיער', 'עור', 'ויטמין', 'תוסף'],
        'en': ['toothpaste', 'toothbrush', 'deodorant', 'cream', 'body wash', 'care', 'hair', 'skin', 'vitamin'],
        'ar': ['معجون أسنان', 'فرشاة أسنان', 'مزيل عرق', 'كريم', 'عناية'],
        'ru': ['зубная паста', 'зубная щетка', 'дезодорант', 'крем', 'уход']
    },
    
    'Frozen Foods': {
        'he': ['קפוא', 'גלידה'],
        'en': ['frozen', 'ice cream'],
        'ar': ['مجمد', 'آيس كريم'],
        'ru': ['замороженный', 'мороженое']
    },
    
    'Canned Foods': {
        'he': ['שימור', 'קופסה', 'מלפפון חמוץ'],
        'en': ['canned', 'can', 'pickle', 'preserved'],
        'ar': ['معلب', 'محفوظ'],
        'ru': ['консервированный', 'консервы']
    },
    
    'Spices': {
        'he': ['תבלין', 'פלפל שחור', 'כמון', 'מלח', 'אורגנו', 'בזיליקום', 'כורכום'],
        'en': ['spice', 'pepper', 'cumin', 'salt', 'oregano', 'basil', 'turmeric'],
        'ar': ['توابل', 'فلفل', 'ملح', 'كمون'],
        'ru': ['специя', 'перец', 'соль', 'тмин']
    },
    
    'Pasta & Rice': {
        'he': ['פסטה', 'ספגטי', 'אורז', 'קוסקוס', 'נודלס'],
        'en': ['pasta', 'spaghetti', 'rice', 'couscous', 'noodles'],
        'ar': ['معكرونة', 'أرز', 'كسكس'],
        'ru': ['паста', 'спагетти', 'рис', 'лапша']
    },
    
    'Oils & Sauces': {
        'he': ['שמן', 'זית', 'רטב', 'קטשופ', 'מיונז', 'חרדל', 'סילאן', 'דבש'],
        'en': ['oil', 'olive', 'sauce', 'ketchup', 'mayo', 'mustard', 'honey'],
        'ar': ['زيت', 'زيتون', 'صلصة', 'كاتشب', 'مايونيز', 'عسل'],
        'ru': ['масло', 'оливка', 'соус', 'кетчуп', 'майонез', 'мёд']
    },
    
    'Baby Products': {
        'he': ['תינוק', 'חיתול', 'מוצץ', 'תרכובת'],
        'en': ['baby', 'diaper', 'pacifier', 'formula'],
        'ar': ['طفل', 'حفاض', 'لهاية'],
        'ru': ['ребенок', 'подгузник', 'соска', 'смесь']
    },
    
    'Pet Food': {
        'he': ['כלב', 'חתול', 'חיית מחמד'],
        'en': ['dog', 'cat', 'pet'],
        'ar': ['كلب', 'قطة', 'حيوان أليف'],
        'ru': ['собака', 'кошка', 'питомец']
    },
}


def normalize_text(text: str) -> str:
    """Normalize text for multi-language matching"""
    if not text:
        return ""
    # Convert to lowercase
    text = text.lower()
    # Remove extra spaces
    text = ' '.join(text.split())
    return text


def classify_product_multilang(product_name: str, description: str = "") -> Tuple[Optional[str], int, List[str]]:
    """
    Classify a product based on multi-language keywords
    Returns: (category_name, confidence_score, matched_keywords)
    """
    full_text = normalize_text(f"{product_name} {description}")
    
    category_scores = {}
    
    for category, languages in CATEGORY_KEYWORDS_MULTILANG.items():
        score = 0
        matched_keywords = []
        
        # Check all languages
        for lang, keywords in languages.items():
            for keyword in keywords:
                keyword_lower = keyword.lower()
                # Exact word match (higher score)
                if f" {keyword_lower} " in f" {full_text} ":
                    score += 10
                    matched_keywords.append(f"{keyword} [{lang}]")
                # Partial match (lower score)
                elif keyword_lower in full_text:
                    score += 5
                    matched_keywords.append(f"{keyword} [{lang}]")
        
        if score > 0:
            category_scores[category] = {
                'score': score,
                'keywords': matched_keywords
            }
    
    if category_scores:
        best_category = max(category_scores.items(), key=lambda x: x[1]['score'])
        return best_category[0], best_category[1]['score'], best_category[1]['keywords']
    
    return None, 0, []


def process_batch(batch_data: Dict) -> Dict:
    """
    Process a batch of products for classification
    This runs in a separate process for parallel processing
    """
    products = batch_data['products']
    vertical_id = batch_data['vertical_id']
    
    # Create new DB connection for this process
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    stats = {
        'processed': 0,
        'classified': 0,
        'by_category': {}
    }
    
    try:
        for product in products:
            category_name, score, keywords = classify_product_multilang(
                product['name'],
                product.get('description', '')
            )
            
            if category_name and score >= 5:
                # Get or create category
                cur.execute("""
                    SELECT id FROM categories 
                    WHERE name = %s AND vertical_id = %s
                """, (category_name, vertical_id))
                
                result = cur.fetchone()
                if result:
                    category_id = result['id']
                else:
                    # Create category
                    slug = category_name.lower().replace(' ', '-').replace('&', 'and')
                    try:
                        cur.execute("""
                            INSERT INTO categories (name, slug, vertical_id)
                            VALUES (%s, %s, %s)
                            RETURNING id
                        """, (category_name, slug, vertical_id))
                        category_id = cur.fetchone()['id']
                    except psycopg2.errors.UniqueViolation:
                        conn.rollback()
                        cur.execute("""
                            SELECT id FROM categories 
                            WHERE slug = %s AND vertical_id = %s
                        """, (slug, vertical_id))
                        category_id = cur.fetchone()['id']
                
                # Update product
                cur.execute("""
                    UPDATE products 
                    SET category_id = %s 
                    WHERE id = %s
                """, (category_id, product['id']))
                
                stats['classified'] += 1
                stats['by_category'][category_name] = stats['by_category'].get(category_name, 0) + 1
            
            stats['processed'] += 1
        
        conn.commit()
        
    except Exception as e:
        conn.rollback()
        stats['error'] = str(e)
    finally:
        conn.close()
    
    return stats


def classify_all_parallel(vertical_slug: str = 'supermarket', max_workers: int = MAX_WORKERS):
    """
    Classify all unclassified products using parallel processing
    """
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        # Get vertical ID
        cur.execute("SELECT id FROM verticals WHERE slug = %s", (vertical_slug,))
        result = cur.fetchone()
        if not result:
            print(f"[ERROR] Vertical '{vertical_slug}' not found!")
            return
        
        vertical_id = result['id']
        
        # Get unclassified products
        cur.execute("""
            SELECT id, name, description
            FROM products
            WHERE category_id IS NULL 
                AND vertical_id = %s
                AND is_active = true
            ORDER BY id
        """, (vertical_id,))
        
        products = cur.fetchall()
        total_products = len(products)
        
        if total_products == 0:
            print("[INFO] No unclassified products found!")
            return
        
        print(f"\n{'='*70}")
        print(f"🚀 Parallel Classification - {max_workers} Workers")
        print(f"{'='*70}")
        print(f"Total products: {total_products:,}")
        print(f"Chunk size: {CHUNK_SIZE}")
        print(f"Estimated batches: {(total_products + CHUNK_SIZE - 1) // CHUNK_SIZE}")
        print(f"{'='*70}\n")
        
        # Split into batches
        batches = []
        for i in range(0, total_products, CHUNK_SIZE):
            batch = {
                'products': products[i:i + CHUNK_SIZE],
                'vertical_id': vertical_id
            }
            batches.append(batch)
        
        # Process in parallel
        start_time = time.time()
        total_stats = {
            'processed': 0,
            'classified': 0,
            'by_category': {}
        }
        
        with ProcessPoolExecutor(max_workers=max_workers) as executor:
            # Submit all batches
            futures = {executor.submit(process_batch, batch): i for i, batch in enumerate(batches)}
            
            # Collect results as they complete
            for future in as_completed(futures):
                batch_num = futures[future]
                try:
                    stats = future.result()
                    
                    total_stats['processed'] += stats['processed']
                    total_stats['classified'] += stats['classified']
                    
                    for cat, count in stats.get('by_category', {}).items():
                        total_stats['by_category'][cat] = total_stats['by_category'].get(cat, 0) + count
                    
                    # Progress
                    progress = (total_stats['processed'] / total_products) * 100
                    print(f"[{progress:5.1f}%] Batch {batch_num+1}/{len(batches)} complete - "
                          f"Classified: {stats['classified']}/{stats['processed']}")
                    
                except Exception as e:
                    print(f"[ERROR] Batch {batch_num} failed: {e}")
        
        elapsed_time = time.time() - start_time
        
        # Final statistics
        print(f"\n{'='*70}")
        print("Classification Complete!")
        print(f"{'='*70}")
        print(f"Time elapsed: {elapsed_time:.1f}s ({total_products/elapsed_time:.0f} products/sec)")
        print(f"Processed: {total_stats['processed']:,}")
        print(f"Classified: {total_stats['classified']:,} ({total_stats['classified']/total_stats['processed']*100:.1f}%)")
        print(f"\nBy Category:")
        for cat, count in sorted(total_stats['by_category'].items(), key=lambda x: x[1], reverse=True):
            print(f"  {cat:25} {count:6,} products")
        print(f"{'='*70}\n")
        
    finally:
        conn.close()


if __name__ == '__main__':
    import argparse
    
    parser = argparse.ArgumentParser(description='Parallel multi-language product classifier')
    parser.add_argument('--workers', type=int, default=MAX_WORKERS, help=f'Number of parallel workers (default: {MAX_WORKERS})')
    parser.add_argument('--vertical', type=str, default='supermarket', help='Vertical slug (default: supermarket)')
    parser.add_argument('--test', type=str, help='Test classification for a product name')
    
    args = parser.parse_args()
    
    if args.test:
        # Test mode
        category, score, keywords = classify_product_multilang(args.test)
        print(f"\nProduct: {args.test}")
        print(f"Category: {category}")
        print(f"Score: {score}")
        print(f"Keywords: {', '.join(keywords[:5])}")
    else:
        # Parallel classification
        classify_all_parallel(vertical_slug=args.vertical, max_workers=args.workers)


