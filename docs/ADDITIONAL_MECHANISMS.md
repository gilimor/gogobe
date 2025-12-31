# 🔧 מנגנונים נוספים - Post-Import Processing

## תאריך: 21 דצמבר 2025

---

## 📊 1. מנגנון עדכון סטטיסטיקות לאחר ייבוא מחירון

### תפקיד
עדכון מטריקות ומדדים אחרי כל ייבוא מוצלח

### Flow

```
┌─────────────────────────────────────────────────────────────┐
│ Trigger: Import Completed Event                             │
└─────────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│ MICROSERVICE: Statistics Service (Go)                       │
└─────────────────────────────────────────────────────────────┘
```

### Implementation

```go
// services/statistics-service/main.go
package main

import (
    "github.com/confluentinc/confluent-kafka-go/kafka"
    "database/sql"
)

type StatisticsService struct {
    db    *sql.DB
    redis *redis.Client
}

type ImportCompletedEvent struct {
    ImportID    int64     `json:"import_id"`
    ChainID     int64     `json:"chain_id"`
    Region      string    `json:"region"`
    FileType    string    `json:"file_type"`  // "prices", "stores", "products"
    RecordsCount int      `json:"records_count"`
    StartTime   time.Time `json:"start_time"`
    EndTime     time.Time `json:"end_time"`
}

func (ss *StatisticsService) ProcessImportCompleted(event ImportCompletedEvent) {
    
    // ═══════════════════════════════════════════════════════════
    // 1. Update Import Log
    // ═══════════════════════════════════════════════════════════
    _, err := ss.db.Exec(`
        INSERT INTO import_logs (
            import_id,
            chain_id,
            region,
            file_type,
            records_count,
            duration_seconds,
            status,
            completed_at
        ) VALUES ($1, $2, $3, $4, $5, $6, 'success', NOW())
    `, 
        event.ImportID,
        event.ChainID,
        event.Region,
        event.FileType,
        event.RecordsCount,
        event.EndTime.Sub(event.StartTime).Seconds(),
    )
    
    // ═══════════════════════════════════════════════════════════
    // 2. Update Chain Statistics
    // ═══════════════════════════════════════════════════════════
    ss.updateChainStats(event.ChainID, event.Region)
    
    // ═══════════════════════════════════════════════════════════
    // 3. Update Global Statistics
    // ═══════════════════════════════════════════════════════════
    ss.updateGlobalStats(event.Region)
    
    // ═══════════════════════════════════════════════════════════
    // 4. Update Price Coverage
    // ═══════════════════════════════════════════════════════════
    ss.updatePriceCoverage(event.ChainID)
    
    // ═══════════════════════════════════════════════════════════
    // 5. Invalidate Cache
    // ═══════════════════════════════════════════════════════════
    ss.invalidateStatsCache(event.Region)
    
    log.Printf("✅ Statistics updated for import %d", event.ImportID)
}

func (ss *StatisticsService) updateChainStats(chainID int64, region string) {
    // Calculate and update chain-level statistics
    
    var stats struct {
        TotalStores   int
        TotalProducts int
        TotalPrices   int
        LastUpdate    time.Time
    }
    
    // Query current stats
    ss.db.QueryRow(`
        SELECT 
            COUNT(DISTINCT s.id) as total_stores,
            COUNT(DISTINCT p.id) as total_products,
            COUNT(pr.id) as total_prices,
            MAX(pr.scraped_at) as last_update
        FROM store_chains sc
        LEFT JOIN stores s ON s.chain_id = sc.id
        LEFT JOIN prices pr ON pr.store_id = s.id
        LEFT JOIN products p ON p.id = pr.product_id
        WHERE sc.id = $1
    `, chainID).Scan(
        &stats.TotalStores,
        &stats.TotalProducts,
        &stats.TotalPrices,
        &stats.LastUpdate,
    )
    
    // Update chain_statistics table
    ss.db.Exec(`
        INSERT INTO chain_statistics (
            chain_id,
            region,
            total_stores,
            total_products,
            total_prices,
            last_import_at,
            updated_at
        ) VALUES ($1, $2, $3, $4, $5, NOW(), NOW())
        ON CONFLICT (chain_id, region)
        DO UPDATE SET
            total_stores = EXCLUDED.total_stores,
            total_products = EXCLUDED.total_products,
            total_prices = EXCLUDED.total_prices,
            last_import_at = EXCLUDED.last_import_at,
            updated_at = NOW()
    `, chainID, region, stats.TotalStores, stats.TotalProducts, stats.TotalPrices)
    
    log.Printf("✅ Chain stats updated: %d stores, %d products, %d prices", 
        stats.TotalStores, stats.TotalProducts, stats.TotalPrices)
}

func (ss *StatisticsService) updateGlobalStats(region string) {
    // Calculate global statistics
    
    var globalStats struct {
        TotalChains        int
        TotalStores        int
        TotalProducts      int
        TotalMasterProducts int
        TotalPrices        int
        AvgPricePerProduct float64
    }
    
    ss.db.QueryRow(`
        SELECT 
            COUNT(DISTINCT sc.id) as total_chains,
            COUNT(DISTINCT s.id) as total_stores,
            COUNT(DISTINCT p.id) as total_products,
            COUNT(DISTINCT mp.id) as total_master_products,
            COUNT(pr.id) as total_prices,
            COALESCE(AVG(prices_per_product), 0) as avg_price_per_product
        FROM store_chains sc
        LEFT JOIN stores s ON s.chain_id = sc.id
        LEFT JOIN prices pr ON pr.store_id = s.id
        LEFT JOIN products p ON p.id = pr.product_id
        LEFT JOIN product_master_links pml ON pml.regional_product_id = p.id
        LEFT JOIN master_products mp ON mp.id = pml.master_product_id
        LEFT JOIN LATERAL (
            SELECT COUNT(*) as prices_per_product
            FROM prices
            WHERE product_id = p.id
        ) pp ON true
        WHERE s.region = $1 OR $1 IS NULL
    `, region).Scan(
        &globalStats.TotalChains,
        &globalStats.TotalStores,
        &globalStats.TotalProducts,
        &globalStats.TotalMasterProducts,
        &globalStats.TotalPrices,
        &globalStats.AvgPricePerProduct,
    )
    
    // Update global_statistics table
    ss.db.Exec(`
        INSERT INTO global_statistics (
            region,
            total_chains,
            total_stores,
            total_products,
            total_master_products,
            total_prices,
            avg_prices_per_product,
            updated_at
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
        ON CONFLICT (region)
        DO UPDATE SET
            total_chains = EXCLUDED.total_chains,
            total_stores = EXCLUDED.total_stores,
            total_products = EXCLUDED.total_products,
            total_master_products = EXCLUDED.total_master_products,
            total_prices = EXCLUDED.total_prices,
            avg_prices_per_product = EXCLUDED.avg_prices_per_product,
            updated_at = NOW()
    `, region, globalStats.TotalChains, globalStats.TotalStores, 
       globalStats.TotalProducts, globalStats.TotalMasterProducts,
       globalStats.TotalPrices, globalStats.AvgPricePerProduct)
    
    log.Printf("✅ Global stats updated for region %s", region)
}

func (ss *StatisticsService) updatePriceCoverage(chainID int64) {
    // Calculate price coverage (% of products with prices)
    
    var coverage struct {
        ProductsWithPrices int
        TotalProducts      int
        CoveragePercent    float64
    }
    
    ss.db.QueryRow(`
        SELECT 
            COUNT(DISTINCT pr.product_id) as products_with_prices,
            COUNT(DISTINCT p.id) as total_products,
            ROUND(100.0 * COUNT(DISTINCT pr.product_id) / NULLIF(COUNT(DISTINCT p.id), 0), 2) as coverage_percent
        FROM products p
        LEFT JOIN prices pr ON pr.product_id = p.id
        WHERE EXISTS (
            SELECT 1 FROM prices
            WHERE product_id = p.id
            AND store_id IN (
                SELECT id FROM stores WHERE chain_id = $1
            )
        )
    `, chainID).Scan(
        &coverage.ProductsWithPrices,
        &coverage.TotalProducts,
        &coverage.CoveragePercent,
    )
    
    log.Printf("✅ Price coverage: %.2f%% (%d/%d products)", 
        coverage.CoveragePercent, coverage.ProductsWithPrices, coverage.TotalProducts)
}

func (ss *StatisticsService) invalidateStatsCache(region string) {
    // Invalidate cached statistics
    
    keys := []string{
        fmt.Sprintf("stats:global:%s", region),
        fmt.Sprintf("stats:chains:%s", region),
        "stats:dashboard",
    }
    
    for _, key := range keys {
        ss.redis.Del(ctx, key)
    }
    
    log.Printf("✅ Cache invalidated for region %s", region)
}
```

### Database Schema

```sql
-- Import logs
CREATE TABLE import_logs (
    id BIGSERIAL PRIMARY KEY,
    import_id BIGINT NOT NULL,
    chain_id BIGINT REFERENCES store_chains(id),
    region VARCHAR(10),
    file_type VARCHAR(50),
    records_count INT,
    duration_seconds DECIMAL(10,2),
    status VARCHAR(20),
    error_message TEXT,
    completed_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_import_logs_chain ON import_logs(chain_id, completed_at DESC);

-- Chain statistics
CREATE TABLE chain_statistics (
    id BIGSERIAL PRIMARY KEY,
    chain_id BIGINT REFERENCES store_chains(id),
    region VARCHAR(10),
    total_stores INT DEFAULT 0,
    total_products INT DEFAULT 0,
    total_prices INT DEFAULT 0,
    last_import_at TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(chain_id, region)
);

-- Global statistics
CREATE TABLE global_statistics (
    id BIGSERIAL PRIMARY KEY,
    region VARCHAR(10) UNIQUE,
    total_chains INT DEFAULT 0,
    total_stores INT DEFAULT 0,
    total_products INT DEFAULT 0,
    total_master_products INT DEFAULT 0,
    total_prices INT DEFAULT 0,
    avg_prices_per_product DECIMAL(10,2) DEFAULT 0,
    updated_at TIMESTAMP DEFAULT NOW()
);
```

---

## 🤖 2. מנגנון קטלוג מוצר חדש (LLM)

### תפקיד
ניתוח אוטומטי של מוצר חדש והוספה לקטלוג

### Flow

```python
# services/catalog-service/product_cataloger.py
from typing import Dict, List
import openai
import json

class ProductCataloger:
    """
    Automatically catalog new products using LLM
    """
    
    def catalog_product(self, product_name: str, barcode: str, region: str) -> Dict:
        """
        Full cataloging process:
        1. Extract attributes
        2. Classify category
        3. Identify brand
        4. Generate tags/keywords
        5. Find similar products
        """
        
        # ═══════════════════════════════════════════════════════
        # Step 1: Extract Attributes
        # ═══════════════════════════════════════════════════════
        attributes = self._extract_attributes(product_name, region)
        
        # ═══════════════════════════════════════════════════════
        # Step 2: Classify Category
        # ═══════════════════════════════════════════════════════
        category = self._classify_category(product_name, attributes)
        
        # ═══════════════════════════════════════════════════════
        # Step 3: Identify Brand
        # ═══════════════════════════════════════════════════════
        brand = self._identify_brand(product_name, attributes)
        
        # ═══════════════════════════════════════════════════════
        # Step 4: Generate Keywords
        # ═══════════════════════════════════════════════════════
        keywords = self._generate_keywords(product_name, attributes, category)
        
        # ═══════════════════════════════════════════════════════
        # Step 5: Find Similar Products
        # ═══════════════════════════════════════════════════════
        similar = self._find_similar_products(product_name, barcode)
        
        return {
            'attributes': attributes,
            'category': category,
            'brand': brand,
            'keywords': keywords,
            'similar_products': similar
        }
    
    def _extract_attributes(self, product_name: str, region: str) -> Dict:
        """
        Extract structured attributes using GPT-4
        """
        
        prompt = f"""
Analyze this product and extract ALL relevant attributes:

Product: {product_name}
Region: {region}

Extract:
1. Product Type (e.g., "Milk", "Smartphone", "Shampoo")
2. Brand/Manufacturer
3. Size/Volume/Weight (with units)
4. Flavor/Scent/Color
5. Special properties (e.g., "Organic", "Sugar-free", "Gluten-free")
6. Target audience (e.g., "Kids", "Adults", "Professional")
7. Package type (e.g., "Bottle", "Can", "Box")
8. Quantity in package

Return JSON with all found attributes.
Be specific and use standardized units (L, ml, kg, g, etc.)
"""
        
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a product data expert. Extract precise, structured data."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.1,
            response_format={"type": "json_object"}
        )
        
        return json.loads(response.choices[0].message.content)
    
    def _classify_category(self, product_name: str, attributes: Dict) -> str:
        """
        Classify product into category hierarchy
        """
        
        # Load category tree from DB
        categories = self._load_category_tree()
        
        prompt = f"""
Classify this product into the most specific category:

Product: {product_name}
Attributes: {json.dumps(attributes)}

Available categories:
{json.dumps(categories, indent=2)}

Return the FULL category path, e.g.:
"Food & Beverages > Dairy > Milk > Fresh Milk"

Be as specific as possible.
"""
        
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a product categorization expert."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.1
        )
        
        category_path = response.choices[0].message.content.strip()
        
        # Validate category exists
        if self._validate_category(category_path):
            return category_path
        else:
            # Fallback to parent category
            return self._get_parent_category(category_path)
    
    def _identify_brand(self, product_name: str, attributes: Dict) -> str:
        """
        Identify and standardize brand name
        """
        
        # Check if brand already in attributes
        if 'brand' in attributes:
            brand = attributes['brand']
        else:
            # Extract using LLM
            prompt = f"""
Extract the brand/manufacturer name from this product:

Product: {product_name}

Return ONLY the brand name in standardized English format.
Examples:
- "תנובה" → "Tnuva"
- "קוקה קולה" → "Coca-Cola"
- "סמסונג" → "Samsung"
"""
            
            response = openai.ChatCompletion.create(
                model="gpt-4",
                messages=[
                    {"role": "system", "content": "You are a brand identification expert."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.1
            )
            
            brand = response.choices[0].message.content.strip()
        
        # Standardize brand name
        return self._standardize_brand(brand)
    
    def _generate_keywords(
        self, 
        product_name: str, 
        attributes: Dict, 
        category: str
    ) -> List[str]:
        """
        Generate search keywords for the product
        """
        
        prompt = f"""
Generate search keywords for this product:

Product: {product_name}
Category: {category}
Attributes: {json.dumps(attributes)}

Generate 10-15 keywords that users might search for.
Include:
- Product type variations
- Brand variations
- Common misspellings
- Related terms
- Translations (if applicable)

Return as JSON array.
"""
        
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a search optimization expert."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.3,
            response_format={"type": "json_object"}
        )
        
        result = json.loads(response.choices[0].message.content)
        return result.get('keywords', [])
    
    def _find_similar_products(self, product_name: str, barcode: str) -> List[Dict]:
        """
        Find similar products using embedding similarity
        """
        
        # Generate embedding
        embedding_response = openai.Embedding.create(
            input=product_name,
            model="text-embedding-ada-002"
        )
        embedding = embedding_response['data'][0]['embedding']
        
        # Search in database
        cur = self.db.cursor()
        cur.execute("""
            SELECT 
                id,
                name,
                ean,
                1 - (embedding <=> %s::vector) as similarity
            FROM products
            WHERE ean != %s
            AND 1 - (embedding <=> %s::vector) > 0.85
            ORDER BY similarity DESC
            LIMIT 5
        """, (embedding, barcode, embedding))
        
        similar = []
        for row in cur.fetchall():
            similar.append({
                'id': row[0],
                'name': row[1],
                'barcode': row[2],
                'similarity': row[3]
            })
        
        return similar
```

---

## 🔗 3. מנגנון איחוד מוצרי אב אוטומטי

### תפקיד
זיהוי ואיחוד אוטומטי של מוצרי אב כפולים

### Flow

```python
# services/master-product-service/merger.py
class MasterProductMerger:
    """
    Automatically detect and merge duplicate master products
    """
    
    def find_duplicates(self) -> List[Dict]:
        """
        Find potential duplicate master products
        
        Strategies:
        1. Same barcode
        2. High embedding similarity (>95%)
        3. Same brand + product type + key attributes
        """
        
        duplicates = []
        
        # ═══════════════════════════════════════════════════════
        # Strategy 1: Same Barcode
        # ═══════════════════════════════════════════════════════
        cur = self.db.cursor()
        cur.execute("""
            SELECT 
                global_ean,
                array_agg(id) as master_ids,
                array_agg(name) as names,
                COUNT(*) as count
            FROM master_products
            WHERE global_ean IS NOT NULL
            GROUP BY global_ean
            HAVING COUNT(*) > 1
        """)
        
        for row in cur.fetchall():
            duplicates.append({
                'type': 'same_barcode',
                'barcode': row[0],
                'master_ids': row[1],
                'names': row[2],
                'confidence': 1.0  # 100% - same barcode
            })
        
        # ═══════════════════════════════════════════════════════
        # Strategy 2: Embedding Similarity
        # ═══════════════════════════════════════════════════════
        cur.execute("""
            SELECT 
                m1.id as id1,
                m1.name as name1,
                m2.id as id2,
                m2.name as name2,
                1 - (m1.embedding <=> m2.embedding) as similarity
            FROM master_products m1
            CROSS JOIN master_products m2
            WHERE m1.id < m2.id
            AND 1 - (m1.embedding <=> m2.embedding) > 0.95
            LIMIT 100
        """)
        
        for row in cur.fetchall():
            duplicates.append({
                'type': 'embedding_similarity',
                'master_ids': [row[0], row[2]],
                'names': [row[1], row[3]],
                'confidence': row[4]
            })
        
        # ═══════════════════════════════════════════════════════
        # Strategy 3: Attribute Matching
        # ═══════════════════════════════════════════════════════
        cur.execute("""
            SELECT 
                m1.id as id1,
                m1.name as name1,
                m2.id as id2,
                m2.name as name2
            FROM master_products m1
            JOIN master_products m2 ON 
                m1.brand = m2.brand
                AND m1.category = m2.category
                AND m1.id < m2.id
            WHERE m1.attributes->>'product_type' = m2.attributes->>'product_type'
            LIMIT 100
        """)
        
        for row in cur.fetchall():
            # Use LLM to verify if they're the same
            is_same = self._verify_with_llm(row[1], row[3])
            
            if is_same['confidence'] > 0.90:
                duplicates.append({
                    'type': 'attribute_match',
                    'master_ids': [row[0], row[2]],
                    'names': [row[1], row[3]],
                    'confidence': is_same['confidence']
                })
        
        return duplicates
    
    def _verify_with_llm(self, name1: str, name2: str) -> Dict:
        """
        Use LLM to verify if two products are the same
        """
        
        prompt = f"""
Are these two products the SAME product?

Product 1: {name1}
Product 2: {name2}

Consider:
- Brand
- Product type
- Size/volume
- Flavor/variant

Return JSON:
{{
    "is_same": true/false,
    "confidence": 0.0-1.0,
    "reason": "explanation"
}}
"""
        
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a product matching expert."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.1,
            response_format={"type": "json_object"}
        )
        
        return json.loads(response.choices[0].message.content)
    
    def merge_master_products(
        self, 
        master_id_keep: int, 
        master_id_merge: int,
        dry_run: bool = True
    ) -> Dict:
        """
        Merge two master products
        
        Process:
        1. Update all product_master_links
        2. Update all prices
        3. Merge attributes
        4. Delete duplicate master product
        """
        
        if dry_run:
            log.info(f"DRY RUN: Would merge {master_id_merge} → {master_id_keep}")
            return {'dry_run': True}
        
        cur = self.db.cursor()
        
        # ═══════════════════════════════════════════════════════
        # 1. Update product_master_links
        # ═══════════════════════════════════════════════════════
        cur.execute("""
            UPDATE product_master_links
            SET master_product_id = %s
            WHERE master_product_id = %s
        """, (master_id_keep, master_id_merge))
        
        links_updated = cur.rowcount
        
        # ═══════════════════════════════════════════════════════
        # 2. Update prices
        # ═══════════════════════════════════════════════════════
        cur.execute("""
            UPDATE prices
            SET master_product_id = %s
            WHERE master_product_id = %s
        """, (master_id_keep, master_id_merge))
        
        prices_updated = cur.rowcount
        
        # ═══════════════════════════════════════════════════════
        # 3. Merge attributes (keep most complete)
        # ═══════════════════════════════════════════════════════
        cur.execute("""
            SELECT attributes
            FROM master_products
            WHERE id IN (%s, %s)
        """, (master_id_keep, master_id_merge))
        
        attrs = [row[0] for row in cur.fetchall()]
        merged_attrs = self._merge_attributes(attrs[0], attrs[1])
        
        cur.execute("""
            UPDATE master_products
            SET attributes = %s
            WHERE id = %s
        """, (json.dumps(merged_attrs), master_id_keep))
        
        # ═══════════════════════════════════════════════════════
        # 4. Delete duplicate master product
        # ═══════════════════════════════════════════════════════
        cur.execute("""
            DELETE FROM master_products
            WHERE id = %s
        """, (master_id_merge,))
        
        self.db.commit()
        
        log.info(f"✅ Merged {master_id_merge} → {master_id_keep}: {links_updated} links, {prices_updated} prices")
        
        return {
            'success': True,
            'links_updated': links_updated,
            'prices_updated': prices_updated
        }
```

---

## ✅ 4. מנגנון בדיקת איחודים (Quality Control)

### תפקיד
וידוא שאיחודים נעשו נכון + rollback אם צריך

### Flow

```python
# services/quality-control-service/merge_validator.py
class MergeValidator:
    """
    Validate and potentially rollback master product merges
    """
    
    def validate_merge(self, merge_id: int) -> Dict:
        """
        Validate a completed merge
        
        Checks:
        1. Price consistency (no huge jumps)
        2. Regional distribution (not all from one region)
        3. User feedback (if available)
        4. Attribute compatibility
        """
        
        # Get merge details
        merge = self._get_merge_details(merge_id)
        
        issues = []
        
        # ═══════════════════════════════════════════════════════
        # Check 1: Price Consistency
        # ═══════════════════════════════════════════════════════
        price_check = self._check_price_consistency(merge['master_id'])
        if not price_check['valid']:
            issues.append({
                'type': 'price_inconsistency',
                'severity': 'high',
                'details': price_check['details']
            })
        
        # ═══════════════════════════════════════════════════════
        # Check 2: Regional Distribution
        # ═══════════════════════════════════════════════════════
        region_check = self._check_regional_distribution(merge['master_id'])
        if not region_check['valid']:
            issues.append({
                'type': 'regional_imbalance',
                'severity': 'medium',
                'details': region_check['details']
            })
        
        # ═══════════════════════════════════════════════════════
        # Check 3: Attribute Compatibility
        # ═══════════════════════════════════════════════════════
        attr_check = self._check_attribute_compatibility(merge['master_id'])
        if not attr_check['valid']:
            issues.append({
                'type': 'attribute_mismatch',
                'severity': 'high',
                'details': attr_check['details']
            })
        
        # ═══════════════════════════════════════════════════════
        # Decision
        # ═══════════════════════════════════════════════════════
        high_severity_count = sum(1 for i in issues if i['severity'] == 'high')
        
        if high_severity_count > 0:
            return {
                'valid': False,
                'action': 'rollback',
                'issues': issues
            }
        elif len(issues) > 2:
            return {
                'valid': False,
                'action': 'review',
                'issues': issues
            }
        else:
            return {
                'valid': True,
                'action': 'approve',
                'issues': issues
            }
    
    def _check_price_consistency(self, master_id: int) -> Dict:
        """
        Check if prices are consistent across linked products
        """
        
        cur = self.db.cursor()
        cur.execute("""
            SELECT 
                region,
                AVG(price_usd) as avg_price,
                STDDEV(price_usd) as price_stddev,
                MIN(price_usd) as min_price,
                MAX(price_usd) as max_price
            FROM global_prices
            WHERE master_product_id = %s
            AND time > NOW() - INTERVAL '7 days'
            GROUP BY region
        """, (master_id,))
        
        regions = cur.fetchall()
        
        # Check if price range is reasonable
        for region in regions:
            avg = region[1]
            stddev = region[2]
            min_p = region[3]
            max_p = region[4]
            
            # If max price is > 3x min price, suspicious
            if max_p > min_p * 3:
                return {
                    'valid': False,
                    'details': f"Price range too wide in {region[0]}: ${min_p:.2f} - ${max_p:.2f}"
                }
            
            # If stddev > 50% of avg, suspicious
            if stddev > avg * 0.5:
                return {
                    'valid': False,
                    'details': f"High price volatility in {region[0]}: stddev ${stddev:.2f}"
                }
        
        return {'valid': True}
    
    def rollback_merge(self, merge_id: int) -> Dict:
        """
        Rollback a merge that was found to be incorrect
        """
        
        # Get original merge details
        merge = self._get_merge_details(merge_id)
        
        # Recreate the deleted master product
        cur = self.db.cursor()
        cur.execute("""
            INSERT INTO master_products (
                master_id, name, global_ean, brand, category, attributes
            )
            SELECT 
                master_id, name, global_ean, brand, category, attributes
            FROM master_products_archive
            WHERE id = %s
            RETURNING id
        """, (merge['merged_master_id'],))
        
        new_id = cur.fetchone()[0]
        
        # Restore links
        cur.execute("""
            UPDATE product_master_links
            SET master_product_id = %s
            WHERE id IN (
                SELECT link_id FROM merge_history
                WHERE merge_id = %s
            )
        """, (new_id, merge_id))
        
        # Restore prices
        cur.execute("""
            UPDATE prices
            SET master_product_id = %s
            WHERE id IN (
                SELECT price_id FROM merge_history
                WHERE merge_id = %s
            )
        """, (new_id, merge_id))
        
        self.db.commit()
        
        log.info(f"✅ Rolled back merge {merge_id}")
        
        return {'success': True, 'new_master_id': new_id}
```

---

## 📊 Database Schema - Audit Tables

```sql
-- Merge history (for rollback)
CREATE TABLE merge_history (
    id BIGSERIAL PRIMARY KEY,
    merge_id BIGINT,
    master_id_keep BIGINT,
    master_id_merge BIGINT,
    link_id BIGINT,
    price_id BIGINT,
    merged_at TIMESTAMP DEFAULT NOW()
);

-- Master products archive (for rollback)
CREATE TABLE master_products_archive (
    id BIGINT,
    master_id VARCHAR(200),
    name VARCHAR(500),
    global_ean VARCHAR(50),
    brand VARCHAR(200),
    category VARCHAR(200),
    attributes JSONB,
    deleted_at TIMESTAMP DEFAULT NOW()
);

-- Merge validation results
CREATE TABLE merge_validations (
    id BIGSERIAL PRIMARY KEY,
    merge_id BIGINT,
    is_valid BOOLEAN,
    action VARCHAR(20),  -- 'approve', 'rollback', 'review'
    issues JSONB,
    validated_at TIMESTAMP DEFAULT NOW()
);
```

---

## ✅ סיכום המנגנונים

| # | מנגנון | תפקיד | Trigger | Output |
|---|--------|-------|---------|--------|
| 1 | **Statistics Update** | עדכון מדדים | Import completed | Updated stats |
| 2 | **Product Cataloging** | קטלוג LLM | New product | Attributes, category, keywords |
| 3 | **Master Merge** | איחוד כפילויות | Scheduled/Manual | Merged master products |
| 4 | **Merge Validation** | בדיקת איכות | After merge | Approve/Rollback |

**כל המנגנונים פועלים אסינכרונית ולא חוסמים את הייבוא!** ⚡
