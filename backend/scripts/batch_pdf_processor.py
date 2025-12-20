"""
Gogobe Batch PDF Processor
Process all PDFs in a folder automatically

Usage:
    python batch_pdf_processor.py "C:\path\to\pdf\folder"
"""

import os
import sys
import re
from pathlib import Path
from datetime import datetime
import json

try:
    import pdfplumber
    import pandas as pd
except ImportError:
    print("❌ Missing libraries!")
    print("Run: pip install pdfplumber pandas openpyxl")
    sys.exit(1)


class PDFBatchProcessor:
    """Process multiple PDFs and extract products"""
    
    def __init__(self, input_folder, output_folder=None):
        self.input_folder = Path(input_folder)
        self.output_folder = Path(output_folder) if output_folder else self.input_folder / "processed"
        self.output_folder.mkdir(exist_ok=True)
        
        # Statistics
        self.stats = {
            'total_pdfs': 0,
            'processed': 0,
            'failed': 0,
            'total_products': 0,
            'total_pages': 0,
            'start_time': datetime.now(),
            'files': []
        }
    
    def find_pdfs(self):
        """Find all PDF files in folder"""
        pdfs = list(self.input_folder.glob("*.pdf"))
        self.stats['total_pdfs'] = len(pdfs)
        return pdfs
    
    def extract_text_from_pdf(self, pdf_path):
        """Extract text from all pages"""
        pages_text = []
        
        try:
            with pdfplumber.open(pdf_path) as pdf:
                for i, page in enumerate(pdf.pages, 1):
                    text = page.extract_text()
                    if text:
                        pages_text.append({
                            'page': i,
                            'text': text
                        })
        except Exception as e:
            print(f"   ⚠️ Error extracting text: {e}")
            return []
        
        return pages_text
    
    def find_products_with_prices(self, text, page_num):
        """Find products with prices in text"""
        products = []
        
        # Price patterns for different currencies
        patterns = [
            (r'£([\d,]+(?:\.\d{2})?)', 'GBP'),
            (r'\$([\d,]+(?:\.\d{2})?)', 'USD'),
            (r'€([\d,]+(?:\.\d{2})?)', 'EUR'),
            (r'₪([\d,]+(?:\.\d{2})?)', 'ILS'),
        ]
        
        for pattern, currency in patterns:
            for match in re.finditer(pattern, text):
                price_str = match.group(1).replace(',', '')
                try:
                    price = float(price_str)
                except:
                    continue
                
                if price < 5:  # Skip too small prices
                    continue
                
                # Get context around price
                start = max(0, match.start() - 300)
                end = min(len(text), match.end() + 300)
                context = text[start:end]
                
                # Try to find product name
                before = context[:match.start()-start]
                lines = [l.strip() for l in before.split('\n') if l.strip()]
                
                product_name = ''
                for line in reversed(lines):
                    if len(line) > 10 and not re.match(r'^[£$€₪\d,\.\s]+$', line):
                        product_name = line
                        break
                
                if product_name and price > 0:
                    products.append({
                        'page': page_num,
                        'name': product_name[:300],
                        'price': price,
                        'currency': currency,
                        'context': context[:500]
                    })
        
        return products
    
    def is_valid_product(self, name):
        """Filter out non-products"""
        name_lower = name.lower()
        
        exclude = [
            'subscription', 'magazine', 'event', 'training',
            'course', 'seminar', 'conference', 'membership',
            'advertisement', 'sponsored', 'page', 'issue',
            'editorial', 'contents', 'classified', 'terms',
            'conditions', 'copyright', 'reserved'
        ]
        
        return not any(kw in name_lower for kw in exclude)
    
    def clean_products(self, df):
        """Clean and filter products"""
        if df.empty:
            return df
        
        initial_count = len(df)
        
        # Remove duplicates
        df = df.drop_duplicates(subset=['name', 'price', 'currency'])
        
        # Filter by name length
        df = df[df['name'].str.len() > 15]
        
        # Filter by price range
        df = df[df['price'] > 10]
        df = df[df['price'] < 100000]
        
        # Filter valid products
        df = df[df['name'].apply(self.is_valid_product)]
        
        # Sort by price
        df = df.sort_values('price', ascending=False)
        df = df.reset_index(drop=True)
        
        return df
    
    def process_single_pdf(self, pdf_path):
        """Process a single PDF file"""
        file_stats = {
            'filename': pdf_path.name,
            'success': False,
            'pages': 0,
            'products_found': 0,
            'products_cleaned': 0,
            'error': None
        }
        
        print(f"\n{'='*80}")
        print(f"📄 Processing: {pdf_path.name}")
        print(f"{'='*80}")
        
        try:
            # Extract text
            print("   🔍 Extracting text...")
            pages = self.extract_text_from_pdf(pdf_path)
            file_stats['pages'] = len(pages)
            self.stats['total_pages'] += len(pages)
            print(f"   ✅ Extracted {len(pages)} pages")
            
            if not pages:
                file_stats['error'] = 'No text extracted'
                return None, file_stats
            
            # Find products
            print("   🔍 Searching for products...")
            all_products = []
            for page_data in pages:
                products = self.find_products_with_prices(page_data['text'], page_data['page'])
                all_products.extend(products)
            
            file_stats['products_found'] = len(all_products)
            print(f"   ✅ Found {len(all_products)} potential products")
            
            if not all_products:
                file_stats['error'] = 'No products found'
                return None, file_stats
            
            # Create DataFrame
            df = pd.DataFrame(all_products)
            
            # Clean data
            print("   🧹 Cleaning data...")
            df = self.clean_products(df)
            file_stats['products_cleaned'] = len(df)
            print(f"   ✅ {len(df)} products after cleaning")
            
            if df.empty:
                file_stats['error'] = 'All products filtered out'
                return None, file_stats
            
            file_stats['success'] = True
            self.stats['processed'] += 1
            self.stats['total_products'] += len(df)
            
            return df, file_stats
            
        except Exception as e:
            file_stats['error'] = str(e)
            self.stats['failed'] += 1
            print(f"   ❌ Error: {e}")
            return None, file_stats
    
    def save_csv(self, df, pdf_path):
        """Save to CSV"""
        base_name = pdf_path.stem
        csv_path = self.output_folder / f"{base_name}_products.csv"
        
        df_export = df[['page', 'name', 'price', 'currency']].copy()
        df_export.to_csv(csv_path, index=False, encoding='utf-8')
        
        print(f"   💾 Saved CSV: {csv_path.name}")
        return csv_path
    
    def generate_sql(self, df, pdf_path):
        """Generate SQL INSERT statements"""
        base_name = pdf_path.stem
        sql_path = self.output_folder / f"{base_name}_products.sql"
        
        sql_lines = [
            f"-- Products extracted from {pdf_path.name}",
            f"-- Extracted: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
            f"-- Total products: {len(df)}",
            "-- Run in PostgreSQL gogobe database\n",
            "DO $$",
            "DECLARE",
            "    dental_id INTEGER;",
            "    cat_id INTEGER;",
            "    supp_id INTEGER;",
            "    pid BIGINT;",
            "BEGIN",
            "    -- Get vertical ID",
            "    SELECT id INTO dental_id FROM verticals WHERE slug = 'dental';",
            "    ",
            "    -- Get category ID",
            "    SELECT id INTO cat_id FROM categories WHERE vertical_id = dental_id LIMIT 1;",
            "    ",
            "    -- Create supplier for this PDF",
            f"    INSERT INTO suppliers (name, slug)",
            f"    VALUES ('{base_name}', '{base_name.lower().replace(' ', '-')}')",
            "    ON CONFLICT (slug) DO NOTHING;",
            "    ",
            f"    SELECT id INTO supp_id FROM suppliers WHERE slug = '{base_name.lower().replace(' ', '-')}';",
            "    \n"
        ]
        
        for idx, row in df.iterrows():
            name = row['name'].replace("'", "''")
            price = row['price']
            currency = row['currency']
            page = row['page']
            
            sql_lines.append(f"    -- Product {idx+1} (Page {page})")
            sql_lines.append(f"    INSERT INTO products (name, vertical_id, category_id, description)")
            sql_lines.append(f"    VALUES (")
            sql_lines.append(f"        '{name}',")
            sql_lines.append(f"        dental_id, cat_id,")
            sql_lines.append(f"        'From {pdf_path.name}, page {page}'")
            sql_lines.append(f"    )")
            sql_lines.append(f"    ON CONFLICT DO NOTHING")
            sql_lines.append(f"    RETURNING id INTO pid;")
            sql_lines.append(f"    ")
            sql_lines.append(f"    IF pid IS NOT NULL THEN")
            sql_lines.append(f"        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)")
            sql_lines.append(f"        VALUES (pid, supp_id, {price}, '{currency}', NOW());")
            sql_lines.append(f"    END IF;")
            sql_lines.append(f"    ")
        
        sql_lines.append("    RAISE NOTICE '✅ Loaded % products from " + pdf_path.name + "', (SELECT COUNT(*) FROM products WHERE description LIKE '%" + pdf_path.name + "%');")
        sql_lines.append("END $$;")
        
        with open(sql_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(sql_lines))
        
        print(f"   💾 Saved SQL: {sql_path.name}")
        return sql_path
    
    def create_combined_sql(self):
        """Create a single SQL file that loads all products"""
        combined_path = self.output_folder / "ALL_PRODUCTS_COMBINED.sql"
        
        sql_files = list(self.output_folder.glob("*_products.sql"))
        sql_files = [f for f in sql_files if f.name != "ALL_PRODUCTS_COMBINED.sql"]
        
        if not sql_files:
            return None
        
        with open(combined_path, 'w', encoding='utf-8') as outfile:
            outfile.write("-- Combined SQL from all processed PDFs\n")
            outfile.write(f"-- Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            outfile.write(f"-- Total files: {len(sql_files)}\n")
            outfile.write(f"-- Total products: {self.stats['total_products']}\n\n")
            
            for sql_file in sql_files:
                outfile.write(f"\n-- {'='*70}\n")
                outfile.write(f"-- File: {sql_file.name}\n")
                outfile.write(f"-- {'='*70}\n\n")
                
                with open(sql_file, 'r', encoding='utf-8') as infile:
                    content = infile.read()
                    # Skip header comments
                    lines = content.split('\n')
                    start_idx = 0
                    for i, line in enumerate(lines):
                        if line.strip().startswith('DO $$'):
                            start_idx = i
                            break
                    outfile.write('\n'.join(lines[start_idx:]))
                    outfile.write('\n\n')
        
        print(f"\n   💾 Created combined SQL: {combined_path.name}")
        return combined_path
    
    def create_combined_csv(self):
        """Create a single CSV with all products"""
        combined_path = self.output_folder / "ALL_PRODUCTS_COMBINED.csv"
        
        csv_files = list(self.output_folder.glob("*_products.csv"))
        csv_files = [f for f in csv_files if f.name != "ALL_PRODUCTS_COMBINED.csv"]
        
        if not csv_files:
            return None
        
        all_dfs = []
        for csv_file in csv_files:
            df = pd.read_csv(csv_file)
            df['source_file'] = csv_file.stem.replace('_products', '')
            all_dfs.append(df)
        
        combined_df = pd.concat(all_dfs, ignore_index=True)
        combined_df = combined_df[['source_file', 'page', 'name', 'price', 'currency']]
        combined_df.to_csv(combined_path, index=False, encoding='utf-8')
        
        print(f"   💾 Created combined CSV: {combined_path.name}")
        return combined_path
    
    def print_summary(self):
        """Print processing summary"""
        duration = (datetime.now() - self.stats['start_time']).total_seconds()
        
        print(f"\n{'='*80}")
        print("📊 BATCH PROCESSING SUMMARY")
        print(f"{'='*80}")
        print(f"Total PDFs found: {self.stats['total_pdfs']}")
        print(f"Successfully processed: {self.stats['processed']}")
        print(f"Failed: {self.stats['failed']}")
        print(f"\nTotal pages scanned: {self.stats['total_pages']}")
        print(f"Total products extracted: {self.stats['total_products']}")
        print(f"\nProcessing time: {duration:.1f} seconds")
        
        if self.stats['total_products'] > 0:
            print(f"Average: {self.stats['total_products']/self.stats['processed']:.1f} products per PDF")
            print(f"Speed: {self.stats['total_pages']/duration:.1f} pages per second")
        
        print(f"\n📁 Output folder: {self.output_folder}")
        print(f"{'='*80}")
        
        # Detailed file stats
        if self.stats['files']:
            print("\n📄 File Details:")
            print(f"{'='*80}")
            for file_stat in self.stats['files']:
                status = "✅" if file_stat['success'] else "❌"
                print(f"{status} {file_stat['filename']}")
                print(f"   Pages: {file_stat['pages']}, Products: {file_stat['products_cleaned']}")
                if file_stat['error']:
                    print(f"   Error: {file_stat['error']}")
        
        # Save summary to JSON
        summary_path = self.output_folder / "processing_summary.json"
        with open(summary_path, 'w', encoding='utf-8') as f:
            summary_data = {
                **self.stats,
                'start_time': self.stats['start_time'].isoformat(),
                'duration_seconds': duration
            }
            json.dump(summary_data, f, indent=2, ensure_ascii=False)
        print(f"\n💾 Summary saved: {summary_path.name}")
    
    def process_all(self):
        """Main processing function"""
        print(f"\n{'='*80}")
        print("Gogobe Batch PDF Processor")
        print(f"{'='*80}")
        print(f"Input folder: {self.input_folder}")
        print(f"Output folder: {self.output_folder}")
        
        # Find PDFs
        pdfs = self.find_pdfs()
        
        if not pdfs:
            print("\n❌ No PDF files found!")
            return
        
        print(f"\n✅ Found {len(pdfs)} PDF file(s)")
        
        # Process each PDF
        for pdf_path in pdfs:
            df, file_stats = self.process_single_pdf(pdf_path)
            self.stats['files'].append(file_stats)
            
            if df is not None and not df.empty:
                # Save individual files
                self.save_csv(df, pdf_path)
                self.generate_sql(df, pdf_path)
        
        # Create combined files
        if self.stats['processed'] > 0:
            print(f"\n{'='*80}")
            print("📦 Creating combined files...")
            print(f"{'='*80}")
            self.create_combined_csv()
            self.create_combined_sql()
        
        # Print summary
        self.print_summary()
        
        return self.stats


def main():
    if len(sys.argv) < 2:
        print("Usage: python batch_pdf_processor.py <pdf_folder> [output_folder]")
        print("\nExample:")
        print('  python batch_pdf_processor.py "C:\\PDFs"')
        print('  python batch_pdf_processor.py "C:\\PDFs" "C:\\Output"')
        sys.exit(1)
    
    input_folder = sys.argv[1]
    output_folder = sys.argv[2] if len(sys.argv) > 2 else None
    
    if not os.path.exists(input_folder):
        print(f"❌ Folder not found: {input_folder}")
        sys.exit(1)
    
    processor = PDFBatchProcessor(input_folder, output_folder)
    processor.process_all()


if __name__ == "__main__":
    main()

