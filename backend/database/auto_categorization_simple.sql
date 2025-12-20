-- ============================================
-- Simple Auto-Categorization with LIKE
-- ============================================

CREATE OR REPLACE FUNCTION auto_categorize_product_simple()
RETURNS TRIGGER AS $$
DECLARE
    v_category_id INTEGER;
    v_product_name TEXT;
BEGIN
    -- Only categorize if category is NULL
    IF NEW.category_id IS NOT NULL THEN
        RETURN NEW;
    END IF;
    
    v_product_name = LOWER(NEW.name);
    
    -- Try to match categories
    -- Dairy (חלב ומוצריו)
    IF v_product_name LIKE '%חלב%' OR v_product_name LIKE '%גבינ%' OR 
       v_product_name LIKE '%יוגורט%' OR v_product_name LIKE '%שמנת%' OR
       v_product_name LIKE '%עמק%' OR v_product_name LIKE '%תנובה%' OR
       v_product_name LIKE '%קוטג%' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%חלב%' OR name ILIKE '%גבינות%' OR name = 'מוצרי חלב' LIMIT 1;
    
    -- Meat & Deli (בשר)
    ELSIF v_product_name LIKE '%בשר%' OR v_product_name LIKE '%נקניק%' OR
          v_product_name LIKE '%סלמי%' OR v_product_name LIKE '%פסטרמה%' OR
          v_product_name LIKE '%עוף%' OR v_product_name LIKE '%הודו%' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%בשר%' OR name = 'בשר ועוף' LIMIT 1;
    
    -- Snacks (חטיפים)
    ELSIF v_product_name LIKE '%במבה%' OR v_product_name LIKE '%ביסלי%' OR
          v_product_name LIKE '%חטיף%' OR v_product_name LIKE '%צ''יפס%' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%חטיפים%' LIMIT 1;
    
    -- Sweets (ממתקים)
    ELSIF v_product_name LIKE '%שוקולד%' OR v_product_name LIKE '%וופל%' OR
          v_product_name LIKE '%ממתק%' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%ממתק%' OR name ILIKE '%שוקולד%' LIMIT 1;
    
    -- Drinks (משקאות)
    ELSIF v_product_name LIKE '%מיץ%' OR v_product_name LIKE '%משקה%' OR
          v_product_name LIKE '%קוקה%' OR v_product_name LIKE '%מים%' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%משקאות%' LIMIT 1;
    
    -- Cleaning (ניקיון)
    ELSIF v_product_name LIKE '%ניקוי%' OR v_product_name LIKE '%מטליות%' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%ניקיון%' LIMIT 1;
    
    -- Default: אחר
    ELSE
        SELECT id INTO v_category_id FROM categories WHERE name = 'אחר' OR name = 'כללי' LIMIT 1;
    END IF;
    
    -- Set category
    IF v_category_id IS NOT NULL THEN
        NEW.category_id = v_category_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Replace trigger
DROP TRIGGER IF EXISTS trigger_auto_categorize ON products;
CREATE TRIGGER trigger_auto_categorize
    BEFORE INSERT OR UPDATE ON products
    FOR EACH ROW
    WHEN (NEW.category_id IS NULL)
    EXECUTE FUNCTION auto_categorize_product_simple();

-- Create אחר category
INSERT INTO categories (name, slug, vertical_id, level)
SELECT 'אחר', 'acher', 1, 1
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = 'acher');

COMMENT ON FUNCTION auto_categorize_product_simple IS 'Simple LIKE-based auto-categorization';

