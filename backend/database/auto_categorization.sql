-- ============================================
-- Auto-Categorization System
-- Trigger-based automatic product categorization
-- ============================================

-- 1. Function: Auto-categorize product based on name
CREATE OR REPLACE FUNCTION auto_categorize_product()
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
    
    -- Dairy Products (חלב ומוצריו)
    IF v_product_name ~ 'חלב|גבינ|יוגורט|שמנת|חמאה|קוטג|לבן|עמק|תנובה|שטראוס|טרה' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%חלב%' OR name ILIKE '%גבינות%' LIMIT 1;
    
    -- Meat & Deli (בשר ונקניקים)
    ELSIF v_product_name ~ 'בשר|נקניק|סלמי|פסטרמה|נקניקי|קבב|המבורגר|שניצל|עוף|הודו|בקר' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%בשר%' OR name ILIKE '%נקניקים%' LIMIT 1;
    
    -- Bread & Bakery (לחם ומאפים)
    ELSIF v_product_name ~ 'לחם|חלה|בגט|פיתה|לאפה|רוגלך|עוגה|עוגיות|מאפה|קרואסון' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%לחם%' OR name ILIKE '%מאפים%' LIMIT 1;
    
    -- Snacks (חטיפים)
    ELSIF v_product_name ~ 'במבה|ביסלי|חטיף|דוריטוס|צ\.יפס|פופקורן|קליק|טורטי' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%חטיפים%' LIMIT 1;
    
    -- Drinks (משקאות)
    ELSIF v_product_name ~ 'קוקה|פפסי|פנטה|ספרייט|מיץ|משקה|שוופס|נביעות|מים|בירה|יין' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%משקאות%' LIMIT 1;
    
    -- Sweets (ממתקים)
    ELSIF v_product_name ~ 'שוקולד|וופל|ממתק|סוכרי|מנטוס|עלית|פרה|קינדר|מרס' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%ממתקים%' OR name ILIKE '%שוקולד%' LIMIT 1;
    
    -- Cleaning (ניקיון)
    ELSIF v_product_name ~ 'ניקוי|מטליות|סמרטוט|דומסטוס|מבריק|אקונומיקה|פלאש|מיר' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%ניקיון%' LIMIT 1;
    
    -- Personal Care (טיפוח אישי)
    ELSIF v_product_name ~ 'שמפו|סבון|מרכך|דאודורנט|משחת שיניים|מברשת|גילוח' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%טיפוח%' LIMIT 1;
    
    -- Canned Food (שימורים)
    ELSIF v_product_name ~ 'שימורי|קופסת|טונה|זיתים|תירס|חומוס|טחינה|ריבה' THEN
        SELECT id INTO v_category_id FROM categories WHERE name ILIKE '%שימורים%' LIMIT 1;
    
    -- Default: Uncategorized
    ELSE
        SELECT id INTO v_category_id FROM categories WHERE name = 'אחר' OR name = 'כללי' LIMIT 1;
    END IF;
    
    -- Set category if found
    IF v_category_id IS NOT NULL THEN
        NEW.category_id = v_category_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Create trigger for new products
DROP TRIGGER IF EXISTS trigger_auto_categorize ON products;
CREATE TRIGGER trigger_auto_categorize
    BEFORE INSERT OR UPDATE ON products
    FOR EACH ROW
    WHEN (NEW.category_id IS NULL)
    EXECUTE FUNCTION auto_categorize_product();

-- 3. Function: Batch categorize existing products
CREATE OR REPLACE FUNCTION batch_categorize_products()
RETURNS TABLE(
    total_products INTEGER,
    categorized INTEGER,
    uncategorized INTEGER
) AS $$
DECLARE
    v_total INTEGER;
    v_before INTEGER;
    v_after INTEGER;
BEGIN
    -- Count before
    SELECT COUNT(*) INTO v_total FROM products WHERE is_active = TRUE;
    SELECT COUNT(*) INTO v_before FROM products WHERE category_id IS NULL AND is_active = TRUE;
    
    -- Update all products without category
    UPDATE products
    SET category_id = NULL  -- Trigger will set it
    WHERE category_id IS NULL AND is_active = TRUE;
    
    -- Force trigger by updating updated_at
    UPDATE products
    SET updated_at = NOW()
    WHERE category_id IS NULL AND is_active = TRUE;
    
    -- Count after
    SELECT COUNT(*) INTO v_after FROM products WHERE category_id IS NULL AND is_active = TRUE;
    
    -- Return results
    total_products := v_total;
    uncategorized := v_after;
    categorized := v_before - v_after;
    
    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;

-- 4. Create a default "אחר" category if not exists
INSERT INTO categories (name, slug, vertical_id, level)
SELECT 'אחר', 'other', v.id, 1
FROM verticals v
WHERE v.slug = 'supermarket'
ON CONFLICT (slug) DO NOTHING;

COMMENT ON FUNCTION auto_categorize_product IS 'Automatically categorizes products based on name keywords';
COMMENT ON FUNCTION batch_categorize_products IS 'Batch categorize all uncategorized products';
COMMENT ON TRIGGER trigger_auto_categorize ON products IS 'Auto-categorize products on insert/update';

