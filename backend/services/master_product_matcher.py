#!/usr/bin/env python3
"""
Master Product Matcher Service
The CORE PATENT of Gogobe System

This service implements the three-strategy matching system:
1. Barcode Matching (70% - exact barcode match)
2. AI Embedding Similarity (25% - semantic similarity)
3. LLM Creation (5% - create new master product)

CRITICAL RULE: No price can be inserted without a master_product_id
"""

import psycopg2
import logging
from typing import Optional, Dict, List, Tuple
from dataclasses import dataclass
import json
import hashlib

logger = logging.getLogger(__name__)


@dataclass
class ProductMatch:
    """Result of a master product match attempt"""
    master_product_id: Optional[int] = None
    confidence: float = 0.0
    method: str = 'none'  # 'barcode', 'embedding', 'llm', 'created'
    metadata: Dict = None


class MasterProductMatcher:
    """
    Master Product Matching Service
    
    Links regional products to global Master Products using:
    1. Barcode matching (fast, 70% coverage)
    2. AI embeddings (medium, 25% coverage)
    3. LLM creation (slow, 5% - creates new masters)
    
    Expected distribution:
    - Barcode: 70% (instant)
    - Embedding: 25% (fast)
    - LLM: 5% (slow, creates new)
    """
    
    def __init__(self, db_config: dict, use_ai: bool = True):
        """
        Initialize matcher
        
        Args:
            db_config: Database connection config
            use_ai: Enable AI matching (embeddings + LLM)
        """
        self.db_config = db_config
        self.use_ai = use_ai
        self.conn = None
        
        # Statistics
        self.stats = {
            'barcode_matches': 0,
            'embedding_matches': 0,
            'llm_creations': 0,
            'total_processed': 0
        }
        
        logger.info(f"✓ Master Product Matcher initialized (AI: {use_ai})")
    
    def get_db_connection(self):
        """Get database connection"""
        if self.conn is None or self.conn.closed:
            self.conn = psycopg2.connect(**self.db_config)
        return self.conn
    
    # ========================================
    # STRATEGY 1: Barcode Matching (70%)
    # ========================================
    
    def match_by_barcode(self, product_id: int, ean: str) -> ProductMatch:
        """
        Match product to master by exact barcode
        
        This is the PRIMARY strategy (70% success rate)
        Fast, reliable, exact match
        
        Args:
            product_id: Regional product ID
            ean: Product EAN/barcode
            
        Returns:
            ProductMatch with master_product_id if found
        """
        if not ean or len(ean) < 8:
            return ProductMatch(method='barcode', confidence=0.0)
        
        conn = self.get_db_connection()
        cur = conn.cursor()
        
        try:
            # Look for existing master product with this EAN
            cur.execute("""
                SELECT id, global_name, confidence_score
                FROM master_products
                WHERE global_ean = %s
                LIMIT 1
            """, (ean,))
            
            result = cur.fetchone()
            
            if result:
                master_id, name, confidence = result
                logger.info(f"✓ Barcode match: {ean} → Master #{master_id} ({name})")
                
                self.stats['barcode_matches'] += 1
                
                return ProductMatch(
                    master_product_id=master_id,
                    confidence=1.0,  # Exact match
                    method='barcode',
                    metadata={'master_name': name}
                )
            
            return ProductMatch(method='barcode', confidence=0.0)
            
        except Exception as e:
            logger.error(f"Barcode matching failed: {e}")
            return ProductMatch(method='barcode', confidence=0.0)
        finally:
            cur.close()
    
    # ========================================
    # STRATEGY 2: Fuzzy Search + LLM Validation (25%)
    # ========================================
    
    def match_by_embedding(self, product_id: int, product_data: Dict) -> ProductMatch:
        """
        Match product to master by Fuzzy Search + LLM Validation
        (Replaces Embedding Strategy for now)
        
        1. Search for candidates using pg_trgm (fuzzy string matching)
        2. Validate top candidates with LLM
        
        Args:
            product_id: Regional product ID
            product_data: Dict with name, description, attributes
            
        Returns:
            ProductMatch
        """
        if not self.use_ai:
             return ProductMatch(method='fuzzy_pending', confidence=0.0)

        conn = self.get_db_connection()
        cur = conn.cursor()
        
        try:
            # 1. Broad Fuzzy Search
            # Find masters with similar names
            name_query = product_data['name'].replace("'", "") # Basic sanitize
            cur.execute("""
                SELECT id, global_name, similarity(global_name, %s) as sim
                FROM master_products
                WHERE global_name % %s  -- trgm operator for "similar"
                ORDER BY sim DESC
                LIMIT 3
            """, (name_query, name_query))
            
            candidates = cur.fetchall()
            
            if not candidates:
                return ProductMatch(method='fuzzy_none', confidence=0.0)

            # 2. LLM Validation
            from openai import OpenAI
            client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))
            
            # Prepare prompt
            candidates_text = "\n".join([f"ID {c[0]}: {c[1]}" for c in candidates])
            prompt = f"""
            I have a product and a list of potential Master Products.
            Identify if the product matches EXACTLY to any of the master products.
            Matches must be the same item, allowing for language differences (e.g. Hebrew/English).
            
            Product: "{product_data['name']}"
            Attributes: {product_data.get('attributes')}
            
            Candidates:
            {candidates_text}
            
            Return JSON: {{ "match_found": boolean, "master_id": int | null, "confidence": float (0-1) }}
            """
            
            response = client.chat.completions.create(
                model="gpt-4o-mini",
                messages=[{"role": "user", "content": prompt}],
                response_format={ "type": "json_object" }
            )
            
            result = json.loads(response.choices[0].message.content)
            
            if result.get('match_found') and result.get('master_id'):
                mid = result['master_id']
                conf = result.get('confidence', 0.8)
                
                # Verify ID exists in candidates to be safe
                if any(c[0] == mid for c in candidates):
                    self.stats['embedding_matches'] += 1
                    return ProductMatch(
                        master_product_id=mid,
                        confidence=conf,
                        method='llm_fuzzy',
                        metadata={'llm_reasoning': 'Validated by GPT-4o-mini'}
                    )
            
            return ProductMatch(method='llm_rejected', confidence=0.0)

        except Exception as e:
            logger.error(f"Fuzzy matching failed: {e}")
            return ProductMatch(method='fuzzy_error', confidence=0.0)
        finally:
            cur.close()
    
    # ========================================
    # STRATEGY 3: LLM Creation (5%)
    # ========================================
    
    def create_by_llm(self, product_id: int, product_data: Dict) -> ProductMatch:
        """
        Create new Master Product using LLM
        
        When no match found, LLM analyzes product and creates
        a new global Master Product entry
        
        Target: 5% of products (fallback)
        
        Args:
            product_id: Regional product ID
            product_data: Complete product information
            
        Returns:
            ProductMatch with newly created master_product_id
        """
        if not self.use_ai:
            # Fallback: Create simple master without AI
            return self._create_simple_master(product_data)
        
        # TODO: Implement LLM creation
        # Requirements:
        # 1. OpenAI API key
        # 2. Prompt engineering for product analysis
        # 3. Master product schema creation
        
        logger.debug("LLM creation not yet implemented - using simple fallback")
        return self._create_simple_master(product_data)
    
    def _create_simple_master(self, product_data: Dict) -> ProductMatch:
        """
        Create simple master product without AI
        (Fallback when AI unavailable)
        """
        conn = self.get_db_connection()
        cur = conn.cursor()
        
        try:
            # Generate global ID
            global_id = self._generate_global_id(product_data)
            
            # Create master product
            # Use a robust INSERT ... ON CONFLICT with explicit checking
            sql = """
                INSERT INTO master_products (
                    global_id,
                    global_name,
                    global_ean,
                    category,
                    confidence_score,
                    creation_method,
                    name  -- Required by original schema not null constraint
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (global_ean) 
                DO UPDATE SET global_name = EXCLUDED.global_name
                RETURNING id
            """
            
            # Fallback name (original schema requires 'name' which is NOT null)
            name = product_data.get('name', 'Unknown')[:500]
            
            # RETRY LOOP for Race Conditions
            import time
            import random
            
            max_retries = 3
            for attempt in range(max_retries):
                try:
                    # 1. Try to FIND first (Optimistic)
                    if product_data.get('ean'):
                        cur.execute("SELECT id FROM master_products WHERE global_ean = %s", (product_data.get('ean'),))
                        row = cur.fetchone()
                        if row:
                            return ProductMatch(
                                master_product_id=row[0], 
                                confidence=1.0, 
                                method='barcode', 
                                metadata={'source': 'existing_scan'}
                            )

                    # 2. Try to INSERT
                    # Use a robust INSERT ... ON CONFLICT with explicit checking
                    sql = """
                        INSERT INTO master_products (
                            global_id,
                            global_name,
                            global_ean,
                            category,
                            confidence_score,
                            creation_method,
                            name  -- Required by original schema not null constraint
                        )
                        VALUES (%s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT (global_ean) 
                        DO UPDATE SET global_name = EXCLUDED.global_name
                        RETURNING id
                    """
                    
                    cur.execute(sql, (
                        global_id,
                        name,
                        product_data.get('ean'),
                        product_data.get('category'),
                        0.7,
                        'simple_auto',
                        name
                    ))
                    
                    row = cur.fetchone()
                    if row:
                        master_id = row[0]
                        conn.commit()
                        logger.info(f"✓ Created/Found Master Product: {global_id} (ID: {master_id})")
                        return ProductMatch(
                            master_product_id=master_id,
                            confidence=0.7,
                            method='created',
                            metadata={'global_id': global_id}
                        )
                    
                except psycopg2.IntegrityError:
                    # Race condition: ID might have been taken by global_id unique constraint logic
                    conn.rollback()
                    logger.warning(f"Race condition caught (attempt {attempt+1}/{max_retries}), retrying...")
                    
                    # Small random sleep to prevent thundering herd
                    time.sleep(random.uniform(0.05, 0.2))
                    
                    # On last attempt, try one last aggressive fetch
                    if attempt == max_retries - 1:
                        cur = conn.cursor()
                        # Try finding by Global ID (the likely cause of the non-EAN integrity error)
                        cur.execute("SELECT id FROM master_products WHERE global_id = %s", (global_id,))
                        res = cur.fetchone()
                        if res:
                            conn.commit()
                            return ProductMatch(master_product_id=res[0], confidence=0.7, method='created', metadata={'global_id': global_id})
                            
            # If we get here, we failed
            logger.error("Failed to solve race condition after retries")
            return ProductMatch(method='created_failed', confidence=0.0)
            
        except Exception as e:
            logger.error(f"Failed to create master product: {e}")
            conn.rollback()
            return ProductMatch(method='created', confidence=0.0)
        finally:
            cur.close()
    
    def _generate_global_id(self, product_data: Dict) -> str:
        """Generate unique global ID for master product"""
        # Use EAN if available
        if product_data.get('ean'):
            return f"GLOBAL_{product_data['ean']}"
        
        # Otherwise hash name + attributes
        name = product_data.get('name', 'unknown')
        attrs = json.dumps(product_data.get('attributes', {}), sort_keys=True)
        combined = f"{name}_{attrs}"
        hash_val = hashlib.md5(combined.encode()).hexdigest()[:12]
        return f"GLOBAL_{hash_val}"
    
    # ========================================
    # MAIN MATCHING FLOW
    # ========================================
    
    def match_product(self, product_id: int) -> ProductMatch:
        """
        Match a product to its Master Product
        
        Executes 3-strategy cascade:
        1. Try barcode (fast)
        2. Try embedding (medium)
        3. Create with LLM (slow)
        
        Args:
            product_id: Regional product database ID
            
        Returns:
            ProductMatch with master_product_id
        """
        self.stats['total_processed'] += 1
        
        conn = self.get_db_connection()
        cur = conn.cursor()
        
        try:
            # Fetch product data
            cur.execute("""
                SELECT id, name, description, ean, manufacturer_code, attributes, vertical_id
                FROM products
                WHERE id = %s
            """, (product_id,))
            
            row = cur.fetchone()
            if not row:
                logger.error(f"Product {product_id} not found")
                return ProductMatch()
            
            pid, name, desc, ean, mfr_code, attrs, vertical = row
            
            product_data = {
                'id': pid,
                'name': name,
                'description': desc,
                'ean': ean,
                'manufacturer_code': mfr_code,
                'attributes': attrs,
                'vertical_id': vertical
            }
            
            # STRATEGY 1: Barcode (70%)
            if ean:
                match = self.match_by_barcode(product_id, ean)
                if match.master_product_id:
                    self._link_product_to_master(product_id, match)
                    return match
            
            # STRATEGY 2: Embedding (25%)
            if self.use_ai:
                match = self.match_by_embedding(product_id, product_data)
                if match.master_product_id and match.confidence > 0.85:
                    self._link_product_to_master(product_id, match)
                    return match
            
            # STRATEGY 3: Create with LLM (5%)
            match = self.create_by_llm(product_id, product_data)
            if match.master_product_id:
                self._link_product_to_master(product_id, match)
                return match
            
            # Fallback: No match (should never happen)
            logger.warning(f"⚠️  No master found for product {product_id}: {name}")
            return ProductMatch()
            
        except Exception as e:
            logger.error(f"Matching failed for product {product_id}: {e}")
            return ProductMatch()
        finally:
            cur.close()
    
    def _link_product_to_master(self, product_id: int, match: ProductMatch):
        """
        Create link between regional product and master product
        """
        if not match.master_product_id:
            return
        
        conn = self.get_db_connection()
        cur = conn.cursor()
        
        try:
            cur.execute("""
                INSERT INTO product_master_links (
                    product_id,
                    master_product_id,
                    confidence_score,
                    link_method,
                    link_metadata
                )
                VALUES (%s, %s, %s, %s, %s::jsonb)
                ON CONFLICT (product_id) 
                DO UPDATE SET
                    master_product_id = EXCLUDED.master_product_id,
                    confidence_score = EXCLUDED.confidence_score,
                    link_method = EXCLUDED.link_method,
                    updated_at = CURRENT_TIMESTAMP;

                -- SYNC BACK to products table (Denormalization for API performance)
                UPDATE products 
                SET master_product_id = %s 
                WHERE id = %s;
            """, (
                product_id,
                match.master_product_id,
                match.confidence,
                match.method,
                json.dumps(match.metadata or {}),
                match.master_product_id, # For UPDATE products
                product_id               # For UPDATE products
            ))
            
            conn.commit()
            logger.debug(f"✓ Linked product {product_id} → master {match.master_product_id} (Synced to products table)")
            
        except Exception as e:
            logger.error(f"Failed to link product {product_id}: {e}")
            conn.rollback()
        finally:
            cur.close()
    
    # ========================================
    # BATCH PROCESSING
    # ========================================
    
    def match_batch(self, product_ids: List[int]) -> Dict:
        """
        Match multiple products in batch
        
        Args:
            product_ids: List of product IDs to match
            
        Returns:
            Statistics dict
        """
        logger.info(f"Matching {len(product_ids)} products in batch...")
        
        results = {
            'total': len(product_ids),
            'matched': 0,
            'failed': 0
        }
        
        for i, product_id in enumerate(product_ids):
            if (i + 1) % 100 == 0:
                logger.info(f"Progress: {i+1}/{len(product_ids)}")
            
            match = self.match_product(product_id)
            
            if match.master_product_id:
                results['matched'] += 1
            else:
                results['failed'] += 1
        
        return results
    
    def get_stats(self) -> Dict:
        """Get matching statistics"""
        total = self.stats['total_processed']
        
        if total == 0:
            return self.stats
        
        return {
            **self.stats,
            'barcode_rate': (self.stats['barcode_matches'] / total) * 100,
            'embedding_rate': (self.stats['embedding_matches'] / total) * 100,
            'llm_rate': (self.stats['llm_creations'] / total) * 100
        }


# ========================================
# USAGE EXAMPLE
# ========================================
if __name__ == "__main__":
    # Configure logging
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s'
    )
    
    # Database config
    db_config = {
        'dbname': 'gogobe',
        'user': 'postgres',
        'password': '9152245-Gl!',
        'host': 'localhost',
        'port': '5432'
    }
    
    # Initialize matcher
    matcher = MasterProductMatcher(db_config, use_ai=False)
    
    # Example: Match single product
    product_id = 1
    match = matcher.match_product(product_id)
    
    print(f"\nMatch result:")
    print(f"  Master ID: {match.master_product_id}")
    print(f"  Confidence: {match.confidence}")
    print(f"  Method: {match.method}")
    
    # Show stats
    stats = matcher.get_stats()
    print(f"\nStatistics:")
    print(f"  Total processed: {stats['total_processed']}")
    print(f"  Barcode matches: {stats['barcode_matches']}")
    print(f"  LLM creations: {stats['llm_creations']}")
