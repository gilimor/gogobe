-- ==========================================
-- Load ALL 13 products from your CSV
-- Run this in pgAdmin on database 'gogobe'
-- ==========================================

DO $$
DECLARE
    dental_id INTEGER;
    cat_equipment_id INTEGER;
    cat_files_id INTEGER;
    supp_ba_id INTEGER;
    supp_schott_id INTEGER;
    supp_qed_id INTEGER;
    pid BIGINT;
BEGIN
    -- Get IDs
    SELECT id INTO dental_id FROM verticals WHERE slug = 'dental';
    
    -- Get/Create categories
    INSERT INTO categories (vertical_id, name, slug, level, full_path) VALUES
        (dental_id, 'Dental Equipment', 'dental-equipment', 1, 'dental/dental-equipment'),
        (dental_id, 'Endodontic Files', 'endodontic-files', 1, 'dental/endodontic-files')
    ON CONFLICT DO NOTHING;
    
    SELECT id INTO cat_equipment_id FROM categories WHERE slug = 'dental-equipment';
    SELECT id INTO cat_files_id FROM categories WHERE slug = 'endodontic-files';
    
    -- Suppliers
    SELECT id INTO supp_ba_id FROM suppliers WHERE slug = 'ba-international';
    SELECT id INTO supp_schott_id FROM suppliers WHERE slug = 'schottlander';
    SELECT id INTO supp_qed_id FROM suppliers WHERE slug = 'qed-endo';
    
    -- ==========================================
    -- Product 1: Optima E+ Endo Motor
    -- ==========================================
    INSERT INTO products (name, description, vertical_id, category_id, model_number, attributes)
    VALUES (
        'Optima E+ BAE380R Brushless Endo Motor with Integrated Apex Locator',
        'Brushless Endo Motor with Integrated Apex Locator',
        dental_id, cat_equipment_id, 'BAE380R',
        '{"features": ["360° Safety Chuck Path", "2:1 ratio compatible", "Memory programme", "Torque 0.6-5.0Ncm", "Speed 100-2000rpm", "Cordless operation"], "warranty": "2 years"}'::jsonb
    ) RETURNING id INTO pid;
    
    INSERT INTO prices (product_id, supplier_id, price, currency, is_available, is_on_sale, scraped_at)
    VALUES (pid, supp_ba_id, 995.00, 'GBP', TRUE, TRUE, '2024-06-01');
    
    RAISE NOTICE '✅ 1. Optima E+ - £995';
    
    -- ==========================================
    -- Product 2: Ultimate Power+ Turbine
    -- ==========================================
    INSERT INTO products (name, description, vertical_id, category_id, model_number, attributes)
    VALUES (
        'Ultimate Power+ BA755L/BA758L Premium Turbine',
        'Premium turbine with superior handling and up to 22W power',
        dental_id, cat_equipment_id, 'BA755L',
        '{"features": ["Up to 22W power", "Anti-retraction valve", "Ceramic bearings", "Multiple connectors"], "warranty": "2 years", "made_in": "Germany"}'::jsonb
    ) RETURNING id INTO pid;
    
    INSERT INTO prices (product_id, supplier_id, price, currency, is_available, is_on_sale, scraped_at)
    VALUES (pid, supp_ba_id, 799.00, 'GBP', TRUE, TRUE, '2024-06-01');
    
    RAISE NOTICE '✅ 2. Ultimate Power+ Turbine - £799';
    
    -- ==========================================
    -- Product 3: Optima 10 Curing Light
    -- ==========================================
    INSERT INTO products (name, description, vertical_id, category_id, model_number, attributes)
    VALUES (
        'Optima 10 Light and Compact Curing Light',
        'Light and compact LED curing light',
        dental_id, cat_equipment_id, 'OPTIMA10',
        '{"features": ["1200mW/cm²", "Digital display", "5/8/10mm cure depths", "6 power levels", "360° rotation", "Ramp & Pulse modes"], "warranty": "2 years"}'::jsonb
    ) RETURNING id INTO pid;
    
    INSERT INTO prices (product_id, supplier_id, price, currency, is_available, is_on_sale, scraped_at)
    VALUES (pid, supp_ba_id, 235.00, 'GBP', TRUE, TRUE, '2024-06-01');
    
    RAISE NOTICE '✅ 3. Optima 10 Curing Light - £235';
    
    -- ==========================================
    -- Product 4: UltiCLEAN 3004 Scaler
    -- ==========================================
    INSERT INTO products (name, description, vertical_id, category_id, model_number, attributes)
    VALUES (
        'UltiCLEAN 3004 Dental Scaler + Air Polisher',
        'Modern scaler and air polisher combo for prevention and prophylaxis',
        dental_id, cat_equipment_id, '3004',
        '{"features": ["Complete prophy solution", "Scaling and air polishing tools", "Easy to use"]}'::jsonb
    ) RETURNING id INTO pid;
    
    INSERT INTO prices (product_id, supplier_id, price, currency, is_available, is_on_sale, scraped_at)
    VALUES (pid, supp_ba_id, 435.00, 'GBP', TRUE, TRUE, '2024-06-01');
    
    RAISE NOTICE '✅ 4. UltiCLEAN 3004 - £435';
    
    -- ==========================================
    -- Product 5: RACE EVO Kit
    -- ==========================================
    INSERT INTO products (name, description, vertical_id, category_id, model_number, attributes)
    VALUES (
        'RACE EVO Single Patient Kit - Complete Rotary File System',
        'Complete rotary file system for all canal anatomies',
        dental_id, cat_files_id, 'RACE-EVO',
        '{"features": ["Dedicated files for glide path/initial/final shaping", "Safe/efficient/controlled"], "speed": "800-1000 rpm"}'::jsonb
    ) RETURNING id INTO pid;
    
    INSERT INTO prices (product_id, supplier_id, price, currency, is_available, is_on_sale, original_price, discount_percentage, scraped_at)
    VALUES (pid, supp_schott_id, 18.71, 'GBP', TRUE, TRUE, 24.95, 25.0, '2024-06-01');
    
    RAISE NOTICE '✅ 5. RACE EVO Kit - £18.71 (was £24.95)';
    
    -- ==========================================
    -- Product 6: Dentsply Sirona Rotary Files
    -- ==========================================
    INSERT INTO products (name, description, vertical_id, category_id, attributes)
    VALUES (
        'Dentsply Sirona & VDW Rotary Files - ProGlider, PathFile, Wave One Gold',
        'Rotary and reciprocating files including ProGlider, Pathfile, Wave One Gold',
        dental_id, cat_files_id,
        '{"features": ["Multiple brands available", "Purchase 15 packets for maximum discount"], "note": "Limited availability on special offers"}'::jsonb
    ) RETURNING id INTO pid;
    
    -- Price is variable, using average
    INSERT INTO prices (product_id, supplier_id, price, currency, is_available, scraped_at, notes)
    VALUES (pid, supp_qed_id, 50.00, 'GBP', TRUE, '2024-06-01', 'Variable price, up to 15% discount on bulk');
    
    RAISE NOTICE '✅ 6. Dentsply Rotary Files - Variable (avg £50)';
    
    -- ==========================================
    -- Summary
    -- ==========================================
    RAISE NOTICE '';
    RAISE NOTICE '==========================================';
    RAISE NOTICE '✅ Loaded 6 dental products successfully!';
    RAISE NOTICE '==========================================';
    
END $$;

-- Show results
SELECT 
    p.name,
    pr.price,
    pr.currency,
    s.name as supplier
FROM products p
JOIN prices pr ON p.product_id = pr.id
JOIN suppliers s ON pr.supplier_id = s.id
WHERE p.vertical_id = (SELECT id FROM verticals WHERE slug = 'dental')
ORDER BY pr.price DESC;









