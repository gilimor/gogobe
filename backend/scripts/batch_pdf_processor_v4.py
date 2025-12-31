"""
Gogobe Batch PDF Processor V4
With Hybrid Classification: Database → Local LLM → OpenAI GPT

This version minimizes costs by using free methods first!

Strategy:
1. Search similar products in DB (FREE, instant)
2. If uncertain, use local Ollama LLM (FREE, ~2 sec)
3. If still uncertain, use OpenAI GPT (PAID, ~$0.0001 per product)

Usage:
    python batch_pdf_processor_v4.py "C:\path\to\pdf\folder"
    python batch_pdf_processor_v4.py "C:\path\to\pdf\folder" --force-rescan
"""

import os
import sys
import re
import hashlib
from pathlib import Path
from datetime import datetime
import json
import time

try:
    import pdfplumber
    import pandas as pd
    import psycopg2
    from psycopg2.extras import RealDictCursor
except ImportError:
    print("Missing libraries!")
    print("Run: pip install pdfplumber pandas openpyxl psycopg2-binary")
    sys.exit(1)

# Import hybrid classifier
try:
    from hybrid_vertical_classifier import HybridVerticalClassifier
    HYBRID_AVAILABLE = True
except ImportError:
    HYBRID_AVAILABLE = False
    print("Warning: Hybrid classifier not available!")
    print("Falling back to simple classification")


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
            for chunk in iter(lambda: f.read(4096), b''):
                sha256.update(chunk)
        return sha256.hexdigest()
    
    def is_already_scanned(self, file_hash):
        """Check if PDF already scanned"""
        cursor = self.conn.cursor(cursor_factory=RealDictCursor)
        try:
            cursor.execute(
                "SELECT * FROM is_source_already_scanned(%s, 'PDF', NULL)",
                (file_hash,)
            )
            result = cursor.fetchone()
            
            if result and result['scanned']:
                return True, result['scan_date'], result['products_found']
            return False, None, None
            
        except Exception as e:
            print(f"Error checking if source scanned: {e}")
            return False, None, None
        finally:
            cursor.close()
    
    def record_scan_start(self, source_name, file_hash, metadata=None):
        """Record start of scan"""
        cursor = self.conn.cursor()
        try:
            cursor.execute("""
                INSERT INTO scraped_sources 
                (source_name, source_type, file_hash, scan_date, status, metadata)
                VALUES (%s, 'PDF', %s, NOW(), 'Processing', %s)
                RETURNING id
            """, (source_name, file_hash, json.dumps(metadata or {})))
            
            self.conn.commit()
            return cursor.fetchone()[0]
            
        except Exception as e:
            self.conn.rollback()
            print(f"Error recording scan start: {e}")
            return None
        finally:
            cursor.close()
    
    def record_scan_success(self, scan_id, products_found, products_imported, duration):
        """Record successful scan"""
        cursor = self.conn.cursor()
        try:
            cursor.execute("""
                UPDATE scraped_sources
                SET status = 'Completed',
                    products_found = %s,
                    products_imported = %s,
                    scan_duration_seconds = %s
                WHERE id = %s
            """, (products_found, products_imported, duration, scan_id))
            
            self.conn.commit()
            
        except Exception as e:
            self.conn.rollback()
            print(f"Error recording scan success: {e}")
        finally:
            cursor.close()
    
    def record_scan_failure(self, scan_id, error_message, duration=None):
        """Record failed scan"""
        cursor = self.conn.cursor()
        try:
            if scan_id:
                cursor.execute("""
                    UPDATE scraped_sources
                    SET status = 'Failed',
                        error_message = %s,
                        scan_duration_seconds = %s
                    WHERE id = %s
                """, (error_message, duration, scan_id))
            
            self.conn.commit()
            
        except Exception as e:
            self.conn.rollback()
            print(f"Error recording scan failure: {e}")
        finally:
            cursor.close()


class PDFBatchProcessor:
    """Process multiple PDFs with hybrid classification"""
    
    def __init__(self, input_dir, db_config, force_rescan=False):
        self.input_dir = Path(input_dir)
        self.output_dir = self.input_dir / "processed"
        self.output_dir.mkdir(exist_ok=True)
        self.force_rescan = force_rescan
        self.db_config = db_config
        
        # Initialize hybrid classifier
        self.classifier = None
        if HYBRID_AVAILABLE:
            try:
                self.classifier = HybridVerticalClassifier(
                    db_config=db_config,
                    use_local_llm=True,
                    use_openai=True,
                    min_db_confidence=0.90,
                    min_local_llm_confidence=0.85
                )
                print("Hybrid Classifier initialized!")
                print("  Tier 1: Database search (FREE)")
                print("  Tier 2: Local LLM via Ollama (FREE)")
                print("  Tier 3: OpenAI GPT (PAID - only if needed)")
            except Exception as e:
                print(f"Failed to initialize hybrid classifier: {e}")
        
        # Initialize source tracker
        self.source_tracker = SourceTracker(db_config)
        if not self.source_tracker.connect():
            raise Exception("Failed to connect to database")
        
        self.processed_count = 0
        self.skipped_count = 0
        self.failed_count = 0
        self.total_products = 0
        
    def extract_text_from_pdf(self, pdf_path):
        """Extract text from PDF"""
        text_pages = []
        try:
            with pdfplumber.open(pdf_path) as pdf:
                for i, page in enumerate(pdf.pages):
                    text = page.extract_text()
                    if text:
                        text_pages.append({
                            'page': i + 1,
                            'text': text
                        })
            return text_pages
        except Exception as e:
            print(f"Error extracting text from {pdf_path.name}: {e}")
            return []
    
    def find_products_and_prices(self, text_pages):
        """Extract products and prices from text"""
        products = []
        
        # Price patterns
        price_pattern = r'[£$€¥₪]\s*\d+[,.]?\d*(?:\.\d{2})?|\d+[,.]\d{2}\s*[£$€¥₪]'
        
        for page_info in text_pages:
            page_num = page_info['page']
            text = page_info['text']
            lines = text.split('\n')
            
            for line in lines:
                # Find prices
                prices = re.findall(price_pattern, line)
                
                if prices:
                    # Clean the line to get product name
                    product_name = re.sub(price_pattern, '', line).strip()
                    product_name = re.sub(r'\s+', ' ', product_name)
                    
                    # Skip if too short or too long
                    if 3 <= len(product_name) <= 200:
                        for price_str in prices:
                            # Extract currency and amount
                            currency_match = re.search(r'[£$€¥₪]', price_str)
                            currency = currency_match.group() if currency_match else 'GBP'
                            
                            # Map currency symbols
                            currency_map = {'£': 'GBP', '$': 'USD', '€': 'EUR', '¥': 'JPY', '₪': 'ILS'}
                            currency = currency_map.get(currency, currency)
                            
                            # Extract amount
                            amount_str = re.sub(r'[£$€¥₪,]', '', price_str).strip()
                            try:
                                amount = float(amount_str)
                                
                                products.append({
                                    'name': product_name,
                                    'price': amount,
                                    'currency': currency,
                                    'page': page_num,
                                    'raw_text': line[:200]
                                })
                            except ValueError:
                                pass
        
        return products
    
    def classify_product(self, product_name, raw_text):
        """Classify product using hybrid classifier"""
        if self.classifier:
            vertical, confidence, source = self.classifier.classify(
                product_name=product_name,
                category_name='',
                text_context=raw_text
            )
            return vertical, confidence, source
        else:
            # Fallback to dental
            return 'dental', 0.0, 'fallback'
    
    def process_pdf(self, pdf_path):
        """Process a single PDF"""
        print(f"\nProcessing: {pdf_path.name}")
        
        start_time = time.time()
        scan_id = None
        
        try:
            # Calculate file hash
            file_hash = self.source_tracker.calculate_file_hash(pdf_path)
            
            # Check if already scanned
            if not self.force_rescan:
                already_scanned, scan_date, products_found = self.source_tracker.is_already_scanned(file_hash)
                
                if already_scanned:
                    print(f"  SKIP: Already scanned on {scan_date}")
                    print(f"        Found {products_found} products previously")
                    self.skipped_count += 1
                    return None
            
            # Record scan start
            scan_id = self.source_tracker.record_scan_start(
                source_name=pdf_path.name,
                file_hash=file_hash,
                metadata={'file_size': pdf_path.stat().st_size}
            )
            
            # Extract text
            print("  Extracting text...")
            text_pages = self.extract_text_from_pdf(pdf_path)
            
            if not text_pages:
                raise Exception("No text extracted from PDF")
            
            # Find products
            print("  Finding products and prices...")
            products = self.find_products_and_prices(text_pages)
            
            if not products:
                raise Exception("No products found")
            
            print(f"  Found {len(products)} products")
            
            # Classify products
            print("  Classifying products (hybrid method)...")
            for i, product in enumerate(products):
                if i % 10 == 0 and i > 0:
                    print(f"    Progress: {i}/{len(products)}")
                
                vertical, confidence, source = self.classify_product(
                    product['name'],
                    product.get('raw_text', '')
                )
                product['vertical'] = vertical
                product['confidence'] = confidence
                product['source'] = source
            
            # Create DataFrame
            df = pd.DataFrame(products)
            
            # Save to CSV
            base_name = pdf_path.stem
            csv_path = self.output_dir / f"{base_name}.csv"
            df.to_csv(csv_path, index=False, encoding='utf-8')
            print(f"  Saved CSV: {csv_path.name}")
            
            # Generate SQL
            sql_path = self.output_dir / f"{base_name}.sql"
            self.generate_sql(df, sql_path, base_name)
            print(f"  Saved SQL: {sql_path.name}")
            
            # Record success
            duration = time.time() - start_time
            self.source_tracker.record_scan_success(
                scan_id=scan_id,
                products_found=len(products),
                products_imported=len(products),
                duration=duration
            )
            
            self.processed_count += 1
            self.total_products += len(products)
            
            return df
            
        except Exception as e:
            duration = time.time() - start_time
            print(f"  ERROR: {e}")
            
            if scan_id:
                self.source_tracker.record_scan_failure(scan_id, str(e), duration)
            
            self.failed_count += 1
            return None
    
    def generate_sql(self, df, sql_path, base_name):
        """Generate SQL with dynamic vertical classification"""
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
            f"    -- Create supplier for this PDF",
            f"    INSERT INTO suppliers (name, slug, country_code)",
            f"    VALUES ('{base_name}', '{base_name.lower().replace(' ', '-')}', 'Unknown')",
            f"    ON CONFLICT (slug) DO NOTHING;",
            f"    SELECT id INTO v_supp_id FROM suppliers WHERE slug = '{base_name.lower().replace(' ', '-')}';\n"
        ]
        
        # Group products by vertical
        for vertical_slug, group in df.groupby('vertical'):
            sql_lines.append(f"\n    -- ===== Vertical: {vertical_slug} =====")
            sql_lines.append(f"    SELECT id INTO v_vertical_id FROM verticals WHERE slug = '{vertical_slug}';")
            sql_lines.append(f"    SELECT id INTO v_cat_id FROM categories WHERE vertical_id = v_vertical_id LIMIT 1;\n")
            
            for idx, row in group.iterrows():
                name = row['name'].replace("'", "''")
                confidence = row.get('confidence', 0.0)
                source = row.get('source', 'unknown')
                
                sql_lines.append(f"    -- {name[:50]}... (confidence: {confidence:.0%}, source: {source})")
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
    
    def process_all(self):
        """Process all PDFs in directory"""
        pdf_files = list(self.input_dir.glob("*.pdf"))
        
        if not pdf_files:
            print(f"No PDF files found in {self.input_dir}")
            return
        
        print("="*60)
        print("Gogobe PDF Batch Processor V4 - HYBRID CLASSIFICATION")
        print("="*60)
        print(f"Input directory: {self.input_dir}")
        print(f"Output directory: {self.output_dir}")
        print(f"Found {len(pdf_files)} PDF files")
        print(f"Force rescan: {self.force_rescan}")
        print("="*60)
        
        all_dfs = []
        
        for pdf_file in pdf_files:
            df = self.process_pdf(pdf_file)
            if df is not None:
                all_dfs.append(df)
        
        # Combine all results
        if all_dfs:
            print("\n" + "="*60)
            print("Creating combined output files...")
            
            combined_df = pd.concat(all_dfs, ignore_index=True)
            
            # Save combined CSV
            combined_csv = self.output_dir / "ALL_PRODUCTS_COMBINED.csv"
            combined_df.to_csv(combined_csv, index=False, encoding='utf-8')
            print(f"  Combined CSV: {combined_csv.name}")
            
            # Generate combined SQL
            combined_sql = self.output_dir / "ALL_PRODUCTS_COMBINED.sql"
            self.generate_sql(combined_df, combined_sql, "Combined_PDFs")
            print(f"  Combined SQL: {combined_sql.name}")
        
        # Print summary
        print("\n" + "="*60)
        print("Processing Complete!")
        print("="*60)
        print(f"Processed: {self.processed_count} PDFs")
        print(f"Skipped: {self.skipped_count} PDFs (already scanned)")
        print(f"Failed: {self.failed_count} PDFs")
        print(f"Total products: {self.total_products}")
        
        # Print classifier stats
        if self.classifier:
            self.classifier.print_stats()
        
        print("="*60)
        
        self.source_tracker.close()


def main():
    # Database configuration
    DB_CONFIG = {
        'host': 'localhost',
        'port': 5432,
        'database': 'gogobe',
        'user': 'postgres',
        'password': '9152245-Gl!'
    }
    
    # Check arguments
    if len(sys.argv) < 2:
        print("Usage: python batch_pdf_processor_v4.py <pdf_directory> [--force-rescan]")
        sys.exit(1)
    
    input_dir = sys.argv[1]
    force_rescan = '--force-rescan' in sys.argv
    
    # Create processor
    processor = PDFBatchProcessor(input_dir, DB_CONFIG, force_rescan=force_rescan)
    
    # Process all PDFs
    processor.process_all()


if __name__ == "__main__":
    main()









