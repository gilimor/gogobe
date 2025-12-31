# 🗂️ מנגנון ניהול קטגוריות

## תאריך: 21 דצמבר 2025

---

## 🎯 בעיות קיימות

### ❌ הבעיות שזיהינו:
1. **כפילויות** - אותה קטגוריה בשמות שונים
2. **אין היררכיה** - לא ברור מי אב ומי בן
3. **אין סטנדרטיזציה** - שמות לא אחידים
4. **קשה לנווט** - אין מבנה עץ ברור

### ✅ הפתרון:
מנגנון מקיף לניהול קטגוריות עם:
- מבנה אב-בן (Tree Structure)
- מניעת כפילויות
- סטנדרטיזציה אוטומטית
- Merge קטגוריות
- LLM לקטגוריזציה

---

## 📊 Database Schema - Categories

```sql
-- ═══════════════════════════════════════════════════════════
-- Categories Table (Hierarchical)
-- ═══════════════════════════════════════════════════════════
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    
    -- Basic Info
    name VARCHAR(200) NOT NULL,
    name_en VARCHAR(200),  -- English name
    slug VARCHAR(200) UNIQUE NOT NULL,  -- URL-friendly: "food-beverages-dairy-milk"
    
    -- Hierarchy
    parent_id BIGINT REFERENCES categories(id) ON DELETE CASCADE,
    level INT NOT NULL DEFAULT 0,  -- 0=root, 1=child, 2=grandchild, etc.
    path VARCHAR(500),  -- Full path: "Food & Beverages > Dairy > Milk"
    
    -- Metadata
    description TEXT,
    icon VARCHAR(50),  -- Emoji or icon name
    color VARCHAR(7),  -- Hex color for UI
    
    -- Stats
    product_count INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT unique_name_per_parent UNIQUE(parent_id, name)
);

-- Indexes
CREATE INDEX idx_categories_parent ON categories(parent_id);
CREATE INDEX idx_categories_slug ON categories(slug);
CREATE INDEX idx_categories_path ON categories(path);
CREATE INDEX idx_categories_level ON categories(level);

-- ═══════════════════════════════════════════════════════════
-- Category Aliases (for duplicate detection)
-- ═══════════════════════════════════════════════════════════
CREATE TABLE category_aliases (
    id BIGSERIAL PRIMARY KEY,
    category_id BIGINT REFERENCES categories(id) ON DELETE CASCADE,
    alias VARCHAR(200) NOT NULL,
    language VARCHAR(5),  -- 'he', 'en', 'ar', etc.
    created_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(alias, language)
);

CREATE INDEX idx_category_aliases_category ON category_aliases(category_id);
CREATE INDEX idx_category_aliases_alias ON category_aliases(alias);

-- ═══════════════════════════════════════════════════════════
-- Category Merge History (for audit)
-- ═══════════════════════════════════════════════════════════
CREATE TABLE category_merge_history (
    id BIGSERIAL PRIMARY KEY,
    source_category_id BIGINT,  -- The category that was merged
    target_category_id BIGINT REFERENCES categories(id),  -- The category it was merged into
    source_name VARCHAR(200),
    product_count INT,
    merged_by VARCHAR(100),
    merged_at TIMESTAMP DEFAULT NOW()
);

-- ═══════════════════════════════════════════════════════════
-- Functions
-- ═══════════════════════════════════════════════════════════

-- Update category path automatically
CREATE OR REPLACE FUNCTION update_category_path()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.parent_id IS NULL THEN
        -- Root category
        NEW.level = 0;
        NEW.path = NEW.name;
    ELSE
        -- Child category
        SELECT level + 1, path || ' > ' || NEW.name
        INTO NEW.level, NEW.path
        FROM categories
        WHERE id = NEW.parent_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_category_path
BEFORE INSERT OR UPDATE ON categories
FOR EACH ROW
EXECUTE FUNCTION update_category_path();

-- Update product count
CREATE OR REPLACE FUNCTION update_category_product_count()
RETURNS TRIGGER AS $$
BEGIN
    -- Update the category's product count
    UPDATE categories
    SET product_count = (
        SELECT COUNT(*)
        FROM products
        WHERE category_id = NEW.category_id
    )
    WHERE id = NEW.category_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_product_count
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW
EXECUTE FUNCTION update_category_product_count();
```

---

## 🔧 Microservice: Category Manager (Go)

```go
// services/category-service/category_manager.go
package main

import (
    "database/sql"
    "github.com/go-redis/redis/v8"
    "strings"
    "fmt"
)

type CategoryManager struct {
    db    *sql.DB
    redis *redis.Client
}

type Category struct {
    ID          int64
    Name        string
    NameEn      string
    Slug        string
    ParentID    *int64
    Level       int
    Path        string
    Description string
    Icon        string
    Color       string
    ProductCount int
    IsActive    bool
}

// ═══════════════════════════════════════════════════════════
// 1. Get or Create Category
// ═══════════════════════════════════════════════════════════
func (cm *CategoryManager) GetOrCreateCategory(
    name string,
    parentID *int64,
) (*Category, error) {
    
    // Normalize name
    normalizedName := cm.normalizeName(name)
    
    // ───────────────────────────────────────────────────────
    // TIER 1: Check Cache
    // ───────────────────────────────────────────────────────
    cacheKey := cm.buildCacheKey(normalizedName, parentID)
    
    cachedID, err := cm.redis.Get(ctx, cacheKey).Int64()
    if err == nil {
        // Cache hit - get full category
        return cm.GetCategoryByID(cachedID)
    }
    
    // ───────────────────────────────────────────────────────
    // TIER 2: Check Database
    // ───────────────────────────────────────────────────────
    category, err := cm.findCategory(normalizedName, parentID)
    if err == nil {
        // Found - cache it
        cm.cacheCategory(category)
        return category, nil
    }
    
    // ───────────────────────────────────────────────────────
    // TIER 3: Check Aliases (duplicate detection)
    // ───────────────────────────────────────────────────────
    category, err = cm.findByAlias(normalizedName)
    if err == nil {
        log.Printf("Found category by alias: %s → %s", name, category.Name)
        cm.cacheCategory(category)
        return category, nil
    }
    
    // ───────────────────────────────────────────────────────
    // TIER 4: Create New Category
    // ───────────────────────────────────────────────────────
    category, err = cm.createCategory(normalizedName, parentID)
    if err != nil {
        return nil, err
    }
    
    // Cache the new category
    cm.cacheCategory(category)
    
    log.Printf("✅ Created category: %s (ID: %d)", category.Name, category.ID)
    
    return category, nil
}

func (cm *CategoryManager) normalizeName(name string) string {
    // Remove extra spaces
    name = strings.TrimSpace(name)
    name = strings.Join(strings.Fields(name), " ")
    
    // Capitalize first letter of each word
    words := strings.Split(name, " ")
    for i, word := range words {
        if len(word) > 0 {
            words[i] = strings.ToUpper(word[:1]) + strings.ToLower(word[1:])
        }
    }
    
    return strings.Join(words, " ")
}

func (cm *CategoryManager) buildCacheKey(name string, parentID *int64) string {
    if parentID == nil {
        return fmt.Sprintf("category:name:%s:root", name)
    }
    return fmt.Sprintf("category:name:%s:parent:%d", name, *parentID)
}

func (cm *CategoryManager) findCategory(name string, parentID *int64) (*Category, error) {
    var category Category
    
    query := `
        SELECT id, name, name_en, slug, parent_id, level, path, 
               description, icon, color, product_count, is_active
        FROM categories
        WHERE name = $1 AND (parent_id = $2 OR (parent_id IS NULL AND $2 IS NULL))
        LIMIT 1
    `
    
    err := cm.db.QueryRow(query, name, parentID).Scan(
        &category.ID,
        &category.Name,
        &category.NameEn,
        &category.Slug,
        &category.ParentID,
        &category.Level,
        &category.Path,
        &category.Description,
        &category.Icon,
        &category.Color,
        &category.ProductCount,
        &category.IsActive,
    )
    
    return &category, err
}

func (cm *CategoryManager) findByAlias(alias string) (*Category, error) {
    var categoryID int64
    
    err := cm.db.QueryRow(`
        SELECT category_id
        FROM category_aliases
        WHERE alias = $1
        LIMIT 1
    `, alias).Scan(&categoryID)
    
    if err != nil {
        return nil, err
    }
    
    return cm.GetCategoryByID(categoryID)
}

func (cm *CategoryManager) createCategory(name string, parentID *int64) (*Category, error) {
    // Generate slug
    slug := cm.generateSlug(name, parentID)
    
    var category Category
    
    err := cm.db.QueryRow(`
        INSERT INTO categories (name, slug, parent_id)
        VALUES ($1, $2, $3)
        RETURNING id, name, name_en, slug, parent_id, level, path, 
                  description, icon, color, product_count, is_active
    `, name, slug, parentID).Scan(
        &category.ID,
        &category.Name,
        &category.NameEn,
        &category.Slug,
        &category.ParentID,
        &category.Level,
        &category.Path,
        &category.Description,
        &category.Icon,
        &category.Color,
        &category.ProductCount,
        &category.IsActive,
    )
    
    return &category, err
}

func (cm *CategoryManager) generateSlug(name string, parentID *int64) string {
    // Convert to lowercase
    slug := strings.ToLower(name)
    
    // Replace spaces with hyphens
    slug = strings.ReplaceAll(slug, " ", "-")
    
    // Remove special characters
    slug = strings.Map(func(r rune) rune {
        if (r >= 'a' && r <= 'z') || (r >= '0' && r <= '9') || r == '-' {
            return r
        }
        return -1
    }, slug)
    
    // If has parent, prepend parent slug
    if parentID != nil {
        var parentSlug string
        cm.db.QueryRow("SELECT slug FROM categories WHERE id = $1", parentID).Scan(&parentSlug)
        slug = parentSlug + "-" + slug
    }
    
    return slug
}

// ═══════════════════════════════════════════════════════════
// 2. Find Duplicate Categories
// ═══════════════════════════════════════════════════════════
func (cm *CategoryManager) FindDuplicates() ([]DuplicateGroup, error) {
    /*
    Find potential duplicate categories using:
    1. Similar names (Levenshtein distance)
    2. Same parent
    3. LLM verification
    */
    
    var duplicates []DuplicateGroup
    
    // ───────────────────────────────────────────────────────
    // Strategy 1: Exact name match (different parents)
    // ───────────────────────────────────────────────────────
    rows, _ := cm.db.Query(`
        SELECT 
            name,
            array_agg(id) as category_ids,
            array_agg(parent_id) as parent_ids,
            array_agg(path) as paths,
            COUNT(*) as count
        FROM categories
        GROUP BY name
        HAVING COUNT(*) > 1
    `)
    defer rows.Close()
    
    for rows.Next() {
        var group DuplicateGroup
        rows.Scan(&group.Name, &group.CategoryIDs, &group.ParentIDs, &group.Paths, &group.Count)
        
        group.Type = "exact_name"
        group.Confidence = 1.0
        
        duplicates = append(duplicates, group)
    }
    
    // ───────────────────────────────────────────────────────
    // Strategy 2: Similar names (Levenshtein)
    // ───────────────────────────────────────────────────────
    rows, _ = cm.db.Query(`
        SELECT 
            c1.id as id1,
            c1.name as name1,
            c1.path as path1,
            c2.id as id2,
            c2.name as name2,
            c2.path as path2,
            levenshtein(c1.name, c2.name) as distance
        FROM categories c1
        CROSS JOIN categories c2
        WHERE c1.id < c2.id
        AND c1.parent_id = c2.parent_id
        AND levenshtein(c1.name, c2.name) <= 3
        LIMIT 100
    `)
    defer rows.Close()
    
    for rows.Next() {
        var id1, id2 int64
        var name1, name2, path1, path2 string
        var distance int
        
        rows.Scan(&id1, &name1, &path1, &id2, &name2, &path2, &distance)
        
        // Calculate confidence (lower distance = higher confidence)
        confidence := 1.0 - (float64(distance) / 10.0)
        
        duplicates = append(duplicates, DuplicateGroup{
            Type:        "similar_name",
            CategoryIDs: []int64{id1, id2},
            Names:       []string{name1, name2},
            Paths:       []string{path1, path2},
            Confidence:  confidence,
        })
    }
    
    return duplicates, nil
}

type DuplicateGroup struct {
    Type        string
    CategoryIDs []int64
    Names       []string
    ParentIDs   []int64
    Paths       []string
    Count       int
    Confidence  float64
}

// ═══════════════════════════════════════════════════════════
// 3. Merge Categories
// ═══════════════════════════════════════════════════════════
func (cm *CategoryManager) MergeCategories(
    sourceID int64,
    targetID int64,
    dryRun bool,
) (*MergeResult, error) {
    
    if dryRun {
        log.Printf("DRY RUN: Would merge category %d → %d", sourceID, targetID)
        return cm.simulateMerge(sourceID, targetID)
    }
    
    // Start transaction
    tx, err := cm.db.Begin()
    if err != nil {
        return nil, err
    }
    defer tx.Rollback()
    
    // ───────────────────────────────────────────────────────
    // 1. Get source category info
    // ───────────────────────────────────────────────────────
    var sourceName string
    var productCount int
    
    tx.QueryRow(`
        SELECT name, product_count
        FROM categories
        WHERE id = $1
    `, sourceID).Scan(&sourceName, &productCount)
    
    // ───────────────────────────────────────────────────────
    // 2. Move all products to target category
    // ───────────────────────────────────────────────────────
    result, _ := tx.Exec(`
        UPDATE products
        SET category_id = $1
        WHERE category_id = $2
    `, targetID, sourceID)
    
    productsUpdated, _ := result.RowsAffected()
    
    // ───────────────────────────────────────────────────────
    // 3. Move child categories to target
    // ───────────────────────────────────────────────────────
    result, _ = tx.Exec(`
        UPDATE categories
        SET parent_id = $1
        WHERE parent_id = $2
    `, targetID, sourceID)
    
    childrenUpdated, _ := result.RowsAffected()
    
    // ───────────────────────────────────────────────────────
    // 4. Create alias for source name
    // ───────────────────────────────────────────────────────
    tx.Exec(`
        INSERT INTO category_aliases (category_id, alias, language)
        VALUES ($1, $2, 'he')
        ON CONFLICT DO NOTHING
    `, targetID, sourceName)
    
    // ───────────────────────────────────────────────────────
    // 5. Log merge history
    // ───────────────────────────────────────────────────────
    tx.Exec(`
        INSERT INTO category_merge_history (
            source_category_id,
            target_category_id,
            source_name,
            product_count,
            merged_by
        ) VALUES ($1, $2, $3, $4, 'system')
    `, sourceID, targetID, sourceName, productCount)
    
    // ───────────────────────────────────────────────────────
    // 6. Delete source category
    // ───────────────────────────────────────────────────────
    tx.Exec(`DELETE FROM categories WHERE id = $1`, sourceID)
    
    // Commit transaction
    tx.Commit()
    
    // Invalidate cache
    cm.invalidateCategoryCache(sourceID)
    cm.invalidateCategoryCache(targetID)
    
    log.Printf("✅ Merged category %d → %d: %d products, %d children", 
        sourceID, targetID, productsUpdated, childrenUpdated)
    
    return &MergeResult{
        Success:         true,
        ProductsUpdated: int(productsUpdated),
        ChildrenUpdated: int(childrenUpdated),
    }, nil
}

type MergeResult struct {
    Success         bool
    ProductsUpdated int
    ChildrenUpdated int
}

// ═══════════════════════════════════════════════════════════
// 4. Get Category Tree
// ═══════════════════════════════════════════════════════════
func (cm *CategoryManager) GetCategoryTree() ([]CategoryNode, error) {
    /*
    Build hierarchical tree structure
    */
    
    // Get all categories
    rows, err := cm.db.Query(`
        SELECT id, name, parent_id, level, path, product_count, icon
        FROM categories
        WHERE is_active = TRUE
        ORDER BY level, name
    `)
    if err != nil {
        return nil, err
    }
    defer rows.Close()
    
    // Build map of categories
    categoryMap := make(map[int64]*CategoryNode)
    var rootCategories []CategoryNode
    
    for rows.Next() {
        var node CategoryNode
        var parentID sql.NullInt64
        
        rows.Scan(
            &node.ID,
            &node.Name,
            &parentID,
            &node.Level,
            &node.Path,
            &node.ProductCount,
            &node.Icon,
        )
        
        node.Children = []CategoryNode{}
        categoryMap[node.ID] = &node
        
        if !parentID.Valid {
            // Root category
            rootCategories = append(rootCategories, node)
        }
    }
    
    // Build tree structure
    for _, node := range categoryMap {
        if node.Level > 0 {
            // Find parent and add as child
            var parentID int64
            cm.db.QueryRow(`
                SELECT parent_id FROM categories WHERE id = $1
            `, node.ID).Scan(&parentID)
            
            if parent, ok := categoryMap[parentID]; ok {
                parent.Children = append(parent.Children, *node)
            }
        }
    }
    
    return rootCategories, nil
}

type CategoryNode struct {
    ID           int64
    Name         string
    Level        int
    Path         string
    ProductCount int
    Icon         string
    Children     []CategoryNode
}
```

---

## 🤖 LLM Integration - Auto-Categorization

```python
# services/category-service/llm_categorizer.py
import openai
import json

class LLMCategorizer:
    """
    Use LLM to automatically categorize products
    """
    
    def categorize_product(self, product_name: str, existing_categories: list) -> dict:
        """
        Find best category for product using LLM
        """
        
        # Build category tree string
        category_tree = self._build_category_tree_string(existing_categories)
        
        prompt = f"""
You are a product categorization expert.

Product: {product_name}

Available categories (hierarchical):
{category_tree}

Task:
1. Find the MOST SPECIFIC category that fits this product
2. If no exact match, suggest the closest parent category
3. If completely new type, suggest a new category path

Return JSON:
{{
    "category_path": "Food & Beverages > Dairy > Milk",
    "confidence": 0.95,
    "is_new_category": false,
    "suggested_new_path": null,
    "reasoning": "explanation"
}}
"""
        
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a product categorization expert."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.1,
            response_format={"type": "json_object"}
        )
        
        return json.loads(response.choices[0].message.content)
    
    def _build_category_tree_string(self, categories: list) -> str:
        """
        Convert category list to tree string
        """
        tree_lines = []
        
        for cat in categories:
            indent = "  " * cat['level']
            tree_lines.append(f"{indent}- {cat['name']} ({cat['product_count']} products)")
        
        return "\n".join(tree_lines)
```

---

## 📊 API Endpoints

```python
# API endpoints for category management

# GET /api/categories
# Get all categories (tree structure)

# GET /api/categories/{id}
# Get specific category

# POST /api/categories
# Create new category
{
    "name": "Organic Milk",
    "parent_id": 123,
    "description": "Organic dairy products"
}

# PUT /api/categories/{id}
# Update category

# DELETE /api/categories/{id}
# Delete category (moves products to parent)

# GET /api/categories/duplicates
# Find duplicate categories

# POST /api/categories/merge
# Merge two categories
{
    "source_id": 456,
    "target_id": 123,
    "dry_run": false
}

# POST /api/categories/auto-categorize
# Auto-categorize product using LLM
{
    "product_name": "חלב תנובה 3%"
}
```

---

## ✅ Summary

### מנגנונים שיצרנו:
1. ✅ **Get-or-Create** - עם cache ו-alias detection
2. ✅ **Find Duplicates** - Levenshtein distance
3. ✅ **Merge Categories** - עם audit trail
4. ✅ **Category Tree** - מבנה היררכי
5. ✅ **LLM Categorization** - אוטומטי

### תכונות:
- 🔍 מניעת כפילויות
- 🌳 מבנה אב-בן
- 🔄 Merge עם היסטוריה
- 🤖 LLM לקטגוריזציה
- 💾 Cache ב-Redis
- 📊 ספירת מוצרים אוטומטית

**עכשיו יש לך מערכת קטגוריות מסודרת!** 🎯
