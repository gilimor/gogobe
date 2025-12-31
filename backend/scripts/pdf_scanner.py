"""
Gogobe PDF Magazine Scanner
Extract dental products from PDF magazines
"""

import re
import sys
from pathlib import Path

try:
    import pdfplumber
    import pandas as pd
except ImportError:
    print("❌ Missing libraries!")
    print("Run: pip install pdfplumber pandas")
    sys.exit(1)

def extract_text_from_pdf(pdf_path):
    """Extract text from all pages"""
    pages_text = []
    
    with pdfplumber.open(pdf_path) as pdf:
        print(f"📄 PDF has {len(pdf.pages)} pages")
        
        for i, page in enumerate(pdf.pages, 1):
            text = page.extract_text()
            if text:
                pages_text.append({
                    'page': i,
                    'text': text
                })
                print(f"   Page {i}: {len(text)} characters")
    
    return pages_text

def find_products_with_prices(text, page_num):
    """Find products with prices in text"""
    products = []
    
    # Pattern for prices: £XX.XX or £X,XXX
    price_pattern = r'£([\d,]+(?:\.\d{2})?)'
    
    for match in re.finditer(price_pattern, text):
        price_str = match.group(1).replace(',', '')
        try:
            price = float(price_str)
        except:
            continue
        
        # Get context around price
        start = max(0, match.start() - 300)
        end = min(len(text), match.end() + 300)
        context = text[start:end]
        
        # Try to find product name (lines before price)
        before = context[:match.start()-start]
        lines = [l.strip() for l in before.split('\n') if l.strip()]
        
        product_name = ''
        for line in reversed(lines):
            if len(line) > 10 and not line.startswith('£'):
                product_name = line
                break
        
        if product_name and price > 0:
            products.append({
                'page': page_num,
                'name': product_name[:200],  # Limit length
                'price': price,
                'currency': 'GBP',
                'context': context[:300]
            })
    
    return products

def is_valid_product(name):
    """Filter out non-products"""
    name_lower = name.lower()
    
    # Exclude keywords
    exclude = [
        'subscription', 'magazine', 'event', 'training',
        'course', 'seminar', 'conference', 'membership',
        'advertisement', 'sponsored'
    ]
    
    return not any(kw in name_lower for kw in exclude)

def scan_pdf(pdf_path):
    """Main scanning function"""
    print(f"\n{'='*60}")
    print(f"🦷 Gogobe PDF Scanner")
    print(f"{'='*60}\n")
    print(f"📄 File: {pdf_path}")
    
    # Extract text
    pages = extract_text_from_pdf(pdf_path)
    print(f"\n✅ Extracted {len(pages)} pages\n")
    
    # Find products
    print("🔍 Searching for products...\n")
    all_products = []
    
    for page_data in pages:
        products = find_products_with_prices(page_data['text'], page_data['page'])
        all_products.extend(products)
    
    print(f"✅ Found {len(all_products)} potential products\n")
    
    # Convert to DataFrame
    df = pd.DataFrame(all_products)
    
    if df.empty:
        print("❌ No products found!")
        return None
    
    # Clean data
    print("🧹 Cleaning data...\n")
    df = df.drop_duplicates(subset=['name', 'price'])
    df = df[df['name'].str.len() > 15]
    df = df[df['price'] > 10]
    df = df[df['name'].apply(is_valid_product)]
    df = df.sort_values('price', ascending=False)
    
    print(f"✅ {len(df)} products after cleaning\n")
    
    # Summary
    print(f"{'='*60}")
    print(f"📊 SUMMARY")
    print(f"{'='*60}")
    print(f"Products: {len(df)}")
    print(f"Price range: £{df['price'].min():.2f} - £{df['price'].max():.2f}")
    print(f"Average: £{df['price'].mean():.2f}")
    print(f"Total value: £{df['price'].sum():.2f}")
    print(f"{'='*60}\n")
    
    return df

def save_csv(df, output_path):
    """Save to CSV"""
    df_export = df[['page', 'name', 'price', 'currency']]
    df_export.to_csv(output_path, index=False)
    print(f"✅ Saved CSV: {output_path}")

def generate_sql(df, output_path):
    """Generate SQL INSERT statements"""
    sql_lines = [
        "-- Products extracted from PDF magazine",
        "-- Run in PostgreSQL gogobe database\n"
    ]
    
    for _, row in df.iterrows():
        name = row['name'].replace("'", "''")
        price = row['price']
        
        sql = f"""
-- Page {row['page']}: {name[:50]}
INSERT INTO products (name, vertical_id, description, is_active)
VALUES (
    '{name}',
    (SELECT id FROM verticals WHERE slug = 'dental'),
    'Extracted from magazine PDF page {row['page']}',
    TRUE
)
ON CONFLICT DO NOTHING;

INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
SELECT 
    (SELECT id FROM products WHERE name = '{name}' LIMIT 1),
    (SELECT id FROM suppliers WHERE slug = 'dental-directory' LIMIT 1),
    {price},
    'GBP',
    NOW()
WHERE EXISTS (SELECT 1 FROM products WHERE name = '{name}');

"""
        sql_lines.append(sql)
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(sql_lines))
    
    print(f"✅ Saved SQL: {output_path}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python pdf_scanner.py <pdf_file>")
        print("\nExample:")
        print('  python pdf_scanner.py "Dentistry_Magazine_2024.pdf"')
        sys.exit(1)
    
    pdf_file = sys.argv[1]
    pdf_path = Path(pdf_file)
    
    if not pdf_path.exists():
        print(f"❌ File not found: {pdf_file}")
        sys.exit(1)
    
    # Scan PDF
    df = scan_pdf(pdf_path)
    
    if df is not None:
        # Save outputs
        base_name = pdf_path.stem
        csv_file = f"{base_name}_products.csv"
        sql_file = f"{base_name}_products.sql"
        
        save_csv(df, csv_file)
        generate_sql(df, sql_file)
        
        print("\n🎉 Done!")
        print("\n📦 Files created:")
        print(f"   1. {csv_file}")
        print(f"   2. {sql_file}")
        print("\n🚀 Next: Run SQL in database:")
        print(f'   psql -U postgres -d gogobe -f "{sql_file}"')









