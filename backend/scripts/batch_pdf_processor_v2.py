"""
Gogobe Batch PDF Processor V2
With source tracking and duplicate prevention

Usage:
    python batch_pdf_processor_v2.py "C:\path\to\pdf\folder"
    python batch_pdf_processor_v2.py "C:\path\to\pdf\folder" --force-rescan
"""

import os
import sys
import re
import hashlib
from pathlib import Path
from datetime import datetime
import json

try:
    import pdfplumber
    import pandas as pd
    import psycopg2
    from psycopg2.extras import RealDictCursor
except ImportError:
    print("Missing libraries!")
    print("Run: pip install pdfplumber pandas openpyxl psycopg2-binary")
    sys.exit(1)


class SourceTracker:
    """Track scraped sources in database"""
    
    def __init__(self, db_config):
        self.db_config = db_config
        self.conn = None
        
    def connect(self):
        """Connect to database"""
        try:
            self.conn = psycopg2.connect(**self.db_config)
            return True
        except Exception as e:
            print(f"Database connection failed: {e}")
            return False
    
    def close(self):
        """Close database connection"""
        if self.conn:
            self.conn.close()
    
    def calculate_file_hash(self, file_path):
        """Calculate SHA256 hash of file"""
        sha256 = hashlib.sha256()
        with open(file_path, 'rb') as f:
            for chunk in iter(lambda: f.read(8192), b''):
                sha256.update(chunk)
        return sha256.hexdigest()
    
    def is_already_scanned(self, file_hash):
        """Check if file was already scanned"""
        if not self.conn:
            return False, None
        
        try:
            with self.conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("""
                    SELECT * FROM is_source_already_scanned(%s)
                """, (file_hash,))
                result = cur.fetchone()
                
                if result and result['is_scanned']:
                    return True, dict(result)
                return False, None
        except Exception as e:
            print(f"   Warning: Could not check database: {e}")
            return False, None
    
    def record_scan_start(self, file_path, file_hash, file_size):
        """Record that scanning started"""
        if not self.conn:
            return None
        
        try:
            with self.conn.cursor() as cur:
                cur.execute("""
                    INSERT INTO scraped_sources (
                        source_type, source_name, file_hash, file_size_bytes,
                        original_path, scan_status, scan_date
                    ) VALUES (
                        'pdf', %s, %s, %s, %s, 'processing', NOW()
                    )
                    RETURNING id
                """, (file_path.name, file_hash, file_size, str(file_path)))
                
                source_id = cur.fetchone()[0]
                self.conn.commit()
                return source_id
        except Exception as e:
            print(f"   Warning: Could not record scan start: {e}")
            self.conn.rollback()
            return None
    
    def update_scan_complete(self, source_id, stats, csv_path=None, sql_path=None):
        """Update scan as completed"""
        if not self.conn or not source_id:
            return False
        
        try:
            with self.conn.cursor() as cur:
                cur.execute("""
                    UPDATE scraped_sources
                    SET scan_status = 'completed',
                        total_pages = %s,
                        products_found = %s,
                        products_imported = %s,
                        scan_duration_seconds = %s,
                        csv_file_path = %s,
                        sql_file_path = %s,
                        updated_at = NOW()
                    WHERE id = %s
                """, (
                    stats.get('pages', 0),
                    stats.get('products_found', 0),
                    stats.get('products_cleaned', 0),
                    stats.get('duration', 0),
                    str(csv_path) if csv_path else None,
                    str(sql_path) if sql_path else None,
                    source_id
                ))
                self.conn.commit()
                return True
        except Exception as e:
            print(f"   Warning: Could not update scan: {e}")
            self.conn.rollback()
            return False
    
    def update_scan_failed(self, source_id, error_message):
        """Update scan as failed"""
        if not self.conn or not source_id:
            return False
        
        try:
            with self.conn.cursor() as cur:
                cur.execute("""
                    UPDATE scraped_sources
                    SET scan_status = 'failed',
                        notes = %s,
                        updated_at = NOW()
                    WHERE id = %s
                """, (error_message, source_id))
                self.conn.commit()
                return True
        except Exception as e:
            print(f"   Warning: Could not update failed scan: {e}")
            self.conn.rollback()
            return False


class PDFBatchProcessorV2:
    """Process multiple PDFs with source tracking"""
    
    def __init__(self, input_folder, output_folder=None, db_config=None, force_rescan=False):
        self.input_folder = Path(input_folder)
        self.output_folder = Path(output_folder) if output_folder else self.input_folder / "processed"
        self.output_folder.mkdir(exist_ok=True)
        self.force_rescan = force_rescan
        
        # Source tracker
        self.tracker = None
        if db_config:
            self.tracker = SourceTracker(db_config)
            if self.tracker.connect():
                print("Database connected for source tracking")
            else:
                print("Warning: Running without database tracking")
                self.tracker = None
        
        # Statistics
        self.stats = {
            'total_pdfs': 0,
            'processed': 0,
            'skipped': 0,
            'failed': 0,
            'total_products': 0,
            'total_pages': 0,
            'start_time': datetime.now(),
            'files': []
        }
    
    def __del__(self):
        """Cleanup"""
        if self.tracker:
            self.tracker.close()
    
    def find_pdfs(self):
        """Find all PDF files"""
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
                        pages_text.append({'page': i, 'text': text})
        except Exception as e:
            print(f"   Warning: Error extracting text: {e}")
            return []
        return pages_text
    
    def find_products_with_prices(self, text, page_num):
        """Find products with prices"""
        products = []
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
                
                if price < 5:
                    continue
                
                start = max(0, match.start() - 300)
                end = min(len(text), match.end() + 300)
                context = text[start:end]
                
                before = context[:match.start()-start]
                lines = [l.strip() for l in before.split('\n') if l.strip()]
                
                product_name = ''
                for line in reversed(lines):
                    if len(line) > 10 and not re.match(r'^[£$€₪\d,.\s]+$', line):
                        product_name = line
                        break
                
                if product_name:
                    products.append({
                        'page': page_num,
                        'name': product_name[:300],
                        'price': price,
                        'currency': currency
                    })
        return products
    
    def is_valid_product(self, name):
        """Filter out non-products"""
        exclude = ['subscription', 'magazine', 'event', 'training', 'course',
                   'seminar', 'conference', 'membership', 'advertisement',
                   'sponsored', 'page', 'issue', 'editorial', 'contents']
        return not any(kw in name.lower() for kw in exclude)
    
    def clean_products(self, df):
        """Clean and filter products"""
        if df.empty:
            return df
        df = df.drop_duplicates(subset=['name', 'price', 'currency'])
        df = df[df['name'].str.len() > 15]
        df = df[df['price'] > 10]
        df = df[df['price'] < 100000]
        df = df[df['name'].apply(self.is_valid_product)]
        return df.sort_values('price', ascending=False).reset_index(drop=True)
    
    def process_single_pdf(self, pdf_path):
        """Process a single PDF file"""
        file_stats = {
            'filename': pdf_path.name,
            'success': False,
            'skipped': False,
            'pages': 0,
            'products_found': 0,
            'products_cleaned': 0,
            'error': None,
            'source_id': None
        }
        
        print(f"\n{'='*80}")
        print(f"Processing: {pdf_path.name}")
        print(f"{'='*80}")
        
        # Calculate file hash
        file_hash = None
        file_size = pdf_path.stat().st_size
        source_id = None
        
        if self.tracker:
            print("   Calculating file hash...")
            file_hash = self.tracker.calculate_file_hash(pdf_path)
            print(f"   Hash: {file_hash[:16]}...")
            
            # Check if already scanned
            is_scanned, scan_info = self.tracker.is_already_scanned(file_hash)
            
            if is_scanned and not self.force_rescan:
                print(f"   SKIPPED: Already scanned on {scan_info['scan_date']}")
                print(f"   Previous scan found {scan_info['products_found']} products")
                print(f"   Use --force-rescan to process again")
                file_stats['skipped'] = True
                self.stats['skipped'] += 1
                return None, file_stats
            elif is_scanned and self.force_rescan:
                print(f"   Re-scanning (previous scan: {scan_info['scan_date']})")
            
            # Record scan start
            source_id = self.tracker.record_scan_start(pdf_path, file_hash, file_size)
            file_stats['source_id'] = source_id
        
        start_time = datetime.now()
        
        try:
            # Extract text
            print("   Extracting text...")
            pages = self.extract_text_from_pdf(pdf_path)
            file_stats['pages'] = len(pages)
            self.stats['total_pages'] += len(pages)
            print(f"   Extracted {len(pages)} pages")
            
            if not pages:
                file_stats['error'] = 'No text extracted'
                if self.tracker and source_id:
                    self.tracker.update_scan_failed(source_id, 'No text extracted')
                return None, file_stats
            
            # Find products
            print("   Searching for products...")
            all_products = []
            for page_data in pages:
                products = self.find_products_with_prices(page_data['text'], page_data['page'])
                all_products.extend(products)
            
            file_stats['products_found'] = len(all_products)
            print(f"   Found {len(all_products)} potential products")
            
            if not all_products:
                file_stats['error'] = 'No products found'
                if self.tracker and source_id:
                    self.tracker.update_scan_failed(source_id, 'No products found')
                return None, file_stats
            
            # Clean data
            print("   Cleaning data...")
            df = pd.DataFrame(all_products)
            df = self.clean_products(df)
            file_stats['products_cleaned'] = len(df)
            print(f"   {len(df)} products after cleaning")
            
            if df.empty:
                file_stats['error'] = 'All products filtered out'
                if self.tracker and source_id:
                    self.tracker.update_scan_failed(source_id, 'All products filtered out')
                return None, file_stats
            
            file_stats['success'] = True
            self.stats['processed'] += 1
            self.stats['total_products'] += len(df)
            
            # Update tracker
            duration = (datetime.now() - start_time).total_seconds()
            file_stats['duration'] = duration
            
            return df, file_stats
            
        except Exception as e:
            file_stats['error'] = str(e)
            self.stats['failed'] += 1
            print(f"   Error: {e}")
            if self.tracker and source_id:
                self.tracker.update_scan_failed(source_id, str(e))
            return None, file_stats
    
    def save_csv(self, df, pdf_path):
        """Save to CSV"""
        base_name = pdf_path.stem
        csv_path = self.output_folder / f"{base_name}_products.csv"
        df_export = df[['page', 'name', 'price', 'currency']].copy()
        df_export.to_csv(csv_path, index=False, encoding='utf-8')
        print(f"   Saved CSV: {csv_path.name}")
        return csv_path
    
    def generate_sql(self, df, pdf_path):
        """Generate SQL"""
        base_name = pdf_path.stem
        sql_path = self.output_folder / f"{base_name}_products.sql"
        
        sql_lines = [
            f"-- Products from {pdf_path.name}",
            f"-- Total: {len(df)} products\n",
            "DO $$",
            "DECLARE dental_id INTEGER; cat_id INTEGER; supp_id INTEGER; pid BIGINT;",
            "BEGIN",
            "  SELECT id INTO dental_id FROM verticals WHERE slug = 'dental';",
            "  SELECT id INTO cat_id FROM categories WHERE vertical_id = dental_id LIMIT 1;",
            f"  INSERT INTO suppliers (name, slug) VALUES ('{base_name}', '{base_name.lower()}') ON CONFLICT DO NOTHING;",
            f"  SELECT id INTO supp_id FROM suppliers WHERE slug = '{base_name.lower()}';\n"
        ]
        
        for idx, row in df.iterrows():
            name = row['name'].replace("'", "''")
            sql_lines.append(f"  INSERT INTO products (name, vertical_id, category_id) VALUES ('{name}', dental_id, cat_id) ON CONFLICT DO NOTHING RETURNING id INTO pid;")
            sql_lines.append(f"  IF pid IS NOT NULL THEN INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at) VALUES (pid, supp_id, {row['price']}, '{row['currency']}', NOW()); END IF;")
        
        sql_lines.append("END $$;")
        
        with open(sql_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(sql_lines))
        
        print(f"   Saved SQL: {sql_path.name}")
        return sql_path
    
    def process_all(self):
        """Main processing function"""
        print(f"\n{'='*80}")
        print("Gogobe Batch PDF Processor V2 (with source tracking)")
        print(f"{'='*80}")
        print(f"Input folder: {self.input_folder}")
        print(f"Output folder: {self.output_folder}")
        if self.force_rescan:
            print("Force rescan: ENABLED")
        
        pdfs = self.find_pdfs()
        
        if not pdfs:
            print("\nNo PDF files found!")
            return
        
        print(f"\nFound {len(pdfs)} PDF file(s)")
        
        all_results = {}
        
        for pdf_path in pdfs:
            df, file_stats = self.process_single_pdf(pdf_path)
            self.stats['files'].append(file_stats)
            
            if file_stats['skipped']:
                continue
            
            if df is not None and not df.empty:
                csv_path = self.save_csv(df, pdf_path)
                sql_path = self.generate_sql(df, pdf_path)
                all_results[pdf_path.name] = df
                
                # Update tracker
                if self.tracker and file_stats['source_id']:
                    self.tracker.update_scan_complete(
                        file_stats['source_id'],
                        file_stats,
                        csv_path,
                        sql_path
                    )
        
        # Print summary
        self.print_summary()
        
        return self.stats


    def print_summary(self):
        """Print processing summary"""
        duration = (datetime.now() - self.stats['start_time']).total_seconds()
        
        print(f"\n{'='*80}")
        print("BATCH PROCESSING SUMMARY")
        print(f"{'='*80}")
        print(f"Total PDFs found: {self.stats['total_pdfs']}")
        print(f"Successfully processed: {self.stats['processed']}")
        print(f"Skipped (already scanned): {self.stats['skipped']}")
        print(f"Failed: {self.stats['failed']}")
        print(f"\nTotal pages scanned: {self.stats['total_pages']}")
        print(f"Total products extracted: {self.stats['total_products']}")
        print(f"\nProcessing time: {duration:.1f} seconds")
        
        if self.stats['total_products'] > 0 and self.stats['processed'] > 0:
            print(f"Average: {self.stats['total_products']/self.stats['processed']:.1f} products per PDF")
            print(f"Speed: {self.stats['total_pages']/duration:.1f} pages per second")
        
        print(f"\nOutput folder: {self.output_folder}")
        print(f"{'='*80}")
        
        # Detailed file stats
        if self.stats['files']:
            print("\nFile Details:")
            print(f"{'='*80}")
            for file_stat in self.stats['files']:
                if file_stat['skipped']:
                    status = "SKIPPED"
                elif file_stat['success']:
                    status = "OK"
                else:
                    status = "FAILED"
                    
                print(f"{status:8} {file_stat['filename']}")
                if not file_stat['skipped']:
                    print(f"         Pages: {file_stat['pages']}, Products: {file_stat['products_cleaned']}")
                if file_stat['error']:
                    print(f"         Error: {file_stat['error']}")


def main():
    if len(sys.argv) < 2:
        print("Usage: python batch_pdf_processor_v2.py <pdf_folder> [--force-rescan]")
        sys.exit(1)
    
    input_folder = sys.argv[1]
    force_rescan = '--force-rescan' in sys.argv
    
    if not os.path.exists(input_folder):
        print(f"Folder not found: {input_folder}")
        sys.exit(1)
    
    # Database config
    db_config = {
        'dbname': 'gogobe',
        'user': 'postgres',
        'password': '9152245-Gl!',
        'host': 'localhost',
        'port': '5432'
    }
    
    processor = PDFBatchProcessorV2(input_folder, db_config=db_config, force_rescan=force_rescan)
    processor.process_all()


if __name__ == "__main__":
    main()









