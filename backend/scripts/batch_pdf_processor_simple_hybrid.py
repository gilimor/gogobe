"""
Gogobe Simple Batch PDF Processor with Keyword Classification
No database connection during classification - simpler and more reliable!
"""

import os
import sys
import re
from pathlib import Path
from datetime import datetime

try:
    import pdfplumber
    import pandas as pd
except ImportError:
    print("Missing libraries!")
    print("Run: pip install pdfplumber pandas openpyxl")
    sys.exit(1)


# Simple keyword-based classification
VERTICAL_KEYWORDS = {
    'dental': ['dental', 'tooth', 'teeth', 'orthodontic', 'endodontic', 'implant', 
               'crown', 'bridge', 'cavity', 'filling', 'braces', 'denture',
               'scaler', 'handpiece', 'turbine', 'curing', 'composite'],
    'medical': ['medical', 'hospital', 'patient', 'clinical', 'surgery',
                'surgical', 'diagnostic', 'stethoscope', 'blood pressure', 
                'thermometer', 'syringe', 'scalpel'],
    'electronics': ['laptop', 'computer', 'phone', 'smartphone', 'tablet',
                    'camera', 'television', 'tv', 'monitor', 'keyboard',
                    'iphone', 'ipad', 'samsung', 'laptop', 'macbook'],
    'fashion': ['shirt', 'pants', 'dress', 'shoes', 'jacket', 'coat',
                'jeans', 'sweater', 'blouse', 'nike', 'adidas', 'fashion'],
    'home-garden': ['furniture', 'chair', 'table', 'sofa', 'bed',
                    'lamp', 'curtain', 'plant', 'garden', 'kitchen'],
    'automotive': ['car', 'auto', 'vehicle', 'tire', 'wheel', 'engine',
                   'brake', 'oil', 'battery', 'motor'],
    'sports': ['sport', 'fitness', 'gym', 'exercise', 'running',
               'cycling', 'tennis', 'football', 'basketball', 'yoga'],
    'beauty': ['cosmetic', 'makeup', 'beauty', 'skincare', 'hair',
               'shampoo', 'cream', 'lotion', 'perfume', 'lipstick']
}


def classify_product(product_name):
    """Simple keyword-based classification"""
    text = product_name.lower()
    
    # Score each vertical
    scores = {}
    for vertical, keywords in VERTICAL_KEYWORDS.items():
        score = sum(2 if keyword in text else 0 for keyword in keywords)
        scores[vertical] = score
    
    # Return best match (or dental as default)
    if max(scores.values()) > 0:
        return max(scores, key=scores.get)
    return 'dental'


def extract_text_from_pdf(pdf_path):
    """Extract text from PDF"""
    text_pages = []
    try:
        with pdfplumber.open(pdf_path) as pdf:
            for i, page in enumerate(pdf.pages):
                text = page.extract_text()
                if text:
                    text_pages.append({'page': i + 1, 'text': text})
        return text_pages
    except Exception as e:
        print(f"Error extracting text: {e}")
        return []


def find_products_and_prices(text_pages):
    """Extract products and prices"""
    products = []
    price_pattern = r'[£$€¥₪]\s*\d+[,.]?\d*(?:\.\d{2})?|\d+[,.]\d{2}\s*[£$€¥₪]'
    
    for page_info in text_pages:
        page_num = page_info['page']
        text = page_info['text']
        lines = text.split('\n')
        
        for line in lines:
            prices = re.findall(price_pattern, line)
            
            if prices:
                product_name = re.sub(price_pattern, '', line).strip()
                product_name = re.sub(r'\s+', ' ', product_name)
                
                if 3 <= len(product_name) <= 200:
                    for price_str in prices:
                        currency_match = re.search(r'[£$€¥₪]', price_str)
                        currency = currency_match.group() if currency_match else 'GBP'
                        
                        currency_map = {'£': 'GBP', '$': 'USD', '€': 'EUR', '¥': 'JPY', '₪': 'ILS'}
                        currency = currency_map.get(currency, currency)
                        
                        amount_str = re.sub(r'[£$€¥₪,]', '', price_str).strip()
                        try:
                            amount = float(amount_str)
                            
                            # Classify product
                            vertical = classify_product(product_name)
                            
                            products.append({
                                'name': product_name,
                                'price': amount,
                                'currency': currency,
                                'page': page_num,
                                'vertical': vertical
                            })
                        except ValueError:
                            pass
    
    return products


def generate_sql(df, sql_path, base_name):
    """Generate SQL with vertical classification"""
    sql_lines = [
        f"-- Generated from {base_name}",
        f"-- Date: {datetime.now().isoformat()}",
        f"-- Total: {len(df)} products\n",
        "DO $$",
        "DECLARE ",
        "    v_vertical_id INTEGER;",
        "    v_cat_id INTEGER;",
        "    v_supp_id INTEGER;",
        "    v_pid BIGINT;",
        "BEGIN",
        f"    -- Create supplier",
        f"    INSERT INTO suppliers (name, slug, country_code)",
        f"    VALUES ('{base_name}', '{base_name.lower().replace(' ', '-')}', 'GB')",
        f"    ON CONFLICT (slug) DO NOTHING;",
        f"    SELECT id INTO v_supp_id FROM suppliers WHERE slug = '{base_name.lower().replace(' ', '-')}';\n"
    ]
    
    # Group by vertical
    for vertical_slug, group in df.groupby('vertical'):
        sql_lines.append(f"\n    -- ===== Vertical: {vertical_slug} ({len(group)} products) =====")
        sql_lines.append(f"    SELECT id INTO v_vertical_id FROM verticals WHERE slug = '{vertical_slug}';")
        sql_lines.append(f"    SELECT id INTO v_cat_id FROM categories WHERE vertical_id = v_vertical_id LIMIT 1;\n")
        
        for idx, row in group.iterrows():
            name = row['name'].replace("'", "''")
            
            sql_lines.append(f"    -- {name[:60]}...")
            sql_lines.append(f"    INSERT INTO products (name, vertical_id, category_id)")
            sql_lines.append(f"    VALUES ('{name}', v_vertical_id, v_cat_id)")
            sql_lines.append(f"    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;")
            sql_lines.append(f"    IF v_pid IS NOT NULL THEN")
            sql_lines.append(f"        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)")
            sql_lines.append(f"        VALUES (v_pid, v_supp_id, {row['price']}, '{row['currency']}', NOW());")
            sql_lines.append(f"    END IF;\n")
    
    sql_lines.append("END $$;")
    
    with open(sql_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(sql_lines))


def main():
    if len(sys.argv) < 2:
        print("Usage: python batch_pdf_processor_simple_hybrid.py <pdf_directory>")
        sys.exit(1)
    
    input_dir = Path(sys.argv[1])
    output_dir = input_dir / "processed"
    output_dir.mkdir(exist_ok=True)
    
    pdf_files = list(input_dir.glob("*.pdf"))
    
    if not pdf_files:
        print(f"No PDF files found in {input_dir}")
        return
    
    print("="*60)
    print("Gogobe PDF Processor - Simple Hybrid Classification")
    print("="*60)
    print(f"Found {len(pdf_files)} PDF files\n")
    
    all_dfs = []
    
    for pdf_file in pdf_files:
        print(f"\nProcessing: {pdf_file.name}")
        
        # Extract text
        print("  Extracting text...")
        text_pages = extract_text_from_pdf(pdf_file)
        
        if not text_pages:
            print("  ERROR: No text extracted")
            continue
        
        # Find products
        print("  Finding products and classifying...")
        products = find_products_and_prices(text_pages)
        
        if not products:
            print("  ERROR: No products found")
            continue
        
        print(f"  Found {len(products)} products")
        
        # Show vertical distribution
        df = pd.DataFrame(products)
        print("\n  Vertical distribution:")
        for vertical, count in df['vertical'].value_counts().items():
            print(f"    {vertical}: {count}")
        
        # Save CSV
        base_name = pdf_file.stem
        csv_path = output_dir / f"{base_name}.csv"
        df.to_csv(csv_path, index=False, encoding='utf-8')
        print(f"\n  Saved CSV: {csv_path.name}")
        
        # Generate SQL
        sql_path = output_dir / f"{base_name}.sql"
        generate_sql(df, sql_path, base_name)
        print(f"  Saved SQL: {sql_path.name}")
        
        all_dfs.append(df)
    
    # Combined files
    if all_dfs:
        print("\n" + "="*60)
        print("Creating combined files...")
        
        combined_df = pd.concat(all_dfs, ignore_index=True)
        
        # Combined CSV
        combined_csv = output_dir / "ALL_PRODUCTS_COMBINED.csv"
        combined_df.to_csv(combined_csv, index=False, encoding='utf-8')
        print(f"  Combined CSV: {combined_csv.name}")
        
        # Combined SQL
        combined_sql = output_dir / "ALL_PRODUCTS_COMBINED.sql"
        generate_sql(combined_df, combined_sql, "Combined_PDFs")
        print(f"  Combined SQL: {combined_sql.name}")
        
        # Summary
        print("\n" + "="*60)
        print("SUMMARY")
        print("="*60)
        print(f"Total products: {len(combined_df)}")
        print("\nVertical distribution:")
        for vertical, count in combined_df['vertical'].value_counts().items():
            print(f"  {vertical}: {count} ({count/len(combined_df)*100:.1f}%)")
        print("="*60)


if __name__ == "__main__":
    main()

