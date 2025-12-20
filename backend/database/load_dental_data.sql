-- ==========================================
-- Load your 13 dental products
-- ==========================================

-- Get vertical ID for dental
DO $$
DECLARE
    dental_vertical_id INTEGER;
    category_endo_id INTEGER;
    category_turbine_id INTEGER;
    category_curing_id INTEGER;
    category_scaler_id INTEGER;
    supplier_ba_id INTEGER;
    supplier_schott_id INTEGER;
    supplier_qed_id INTEGER;
    product_id BIGINT;
BEGIN
    -- Get dental vertical
    SELECT id INTO dental_vertical_id FROM verticals WHERE slug = 'dental';
    
    -- Create additional categories if needed
    INSERT INTO categories (vertical_id, name, slug, level, full_path)
    VALUES 
        (dental_vertical_id, 'Endodontic Equipment', 'endodontic-equipment', 1, 'dental/endodontic-equipment'),
        (dental_vertical_id, 'Turbines & Handpieces', 'turbines-handpieces', 1, 'dental/turbines-handpieces'),
        (dental_vertical_id, 'Curing Lights', 'curing-lights', 1, 'dental/curing-lights'),
        (dental_vertical_id, 'Scalers & Polishers', 'scalers-polishers', 1, 'dental/scalers-polishers'),
        (dental_vertical_id, 'Endodontic Files', 'endodontic-files', 1, 'dental/endodontic-files')
    ON CONFLICT DO NOTHING;
    
    -- Get category IDs
    SELECT id INTO category_endo_id FROM categories WHERE slug = 'endodontic-equipment';
    SELECT id INTO category_turbine_id FROM categories WHERE slug = 'turbines-handpieces';
    SELECT id INTO category_curing_id FROM categories WHERE slug = 'curing-lights';
    SELECT id INTO category_scaler_id FROM categories WHERE slug = 'scalers-polishers';
    
    -- Create suppliers
    INSERT INTO suppliers (name, slug, website, country_code, supplier_type, verticals, ships_internationally)
    VALUES 
        ('B.A. International', 'ba-international', 'https://bainternational.co.uk', 'GB', 'manufacturer', ARRAY['dental'], TRUE),
        ('Schottlander', 'schottlander', 'https://schottlander.com', 'GB', 'manufacturer', ARRAY['dental'], TRUE),
        ('QED Endo', 'qed-endo', 'https://qedendo.com', 'GB', 'distributor', ARRAY['dental'], TRUE)
    ON CONFLICT (slug) DO NOTHING;
    
    -- Get supplier IDs
    SELECT id INTO supplier_ba_id FROM suppliers WHERE slug = 'ba-international';
    SELECT id INTO supplier_schott_id FROM suppliers WHERE slug = 'schottlander';
    SELECT id INTO supplier_qed_id FROM suppliers WHERE slug = 'qed-endo';
    
    -- ==========================================
    -- Product 1: Optima E+ Endo Motor
    -- ==========================================
    INSERT INTO products (
        name, description, vertical_id, category_id, brand_id,
        model_number, attributes, is_active
    )
    VALUES (
        'Optima E+ BAE380R Brushless Endo Motor',
        'Brushless Endo Motor with Integrated Apex Locator',
        dental_vertical_id,
        category_endo_id,
        (SELECT id FROM brands WHERE normalized_name = 'sklar-surgical'), -- temp brand
        'BAE380R',
        '{
            "features": [
                "360° Safety Chuck Path",
                "2:1 ratio compatible",
                "Memory programme",
                "Torque 0.6-5.0Ncm",
                "Speed 100-2000rpm",
                "Cordless operation"
            ],
            "warranty": "2 years",
            "country": "UK",
            "source": "Dentistry Magazine June 2024"
        }'::jsonb,
        TRUE
    )
    RETURNING id INTO product_id;
    
    INSERT INTO prices (product_id, supplier_id, price, currency, is_available, scraped_at)
    VALUES (product_id, supplier_ba_id, 995.00, 'GBP', TRUE, '2024-06-01');
    
    RAISE NOTICE 'Product 1 loaded: Optima E+ (£995)';
    
    -- ==========================================
    -- Product 2: Ultimate Power+ Turbine
    -- ==========================================
    INSERT INTO products (
        name, description, vertical_id, category_id,
        model_number, attributes, is_active
    )
    VALUES (
        'Ultimate Power+ BA755L/BA758L Premium Turbine',
        'Premium turbine with superior handling and up to 22W power',
        dental_vertical_id,
        category_turbine_id,
        'BA755L/BA758L',
        '{
            "features": [
                "Up to 22W power",
                "Anti-retraction valve",
                "Ceramic bearings",
                "Multiple connectors (Borden/KaVo/Midwest/W&H)"
            ],
            "warranty": "2 years",
            "country": "UK",
            "made_in": "Germany",
            "type": "Premium"
        }'::jsonb,
        TRUE
    )
    RETURNING id INTO product_id;
    
    INSERT INTO prices (product_id, supplier_id, price, currency, is_available, scraped_at)
    VALUES (product_id, supplier_ba_id, 799.00, 'GBP', TRUE, '2024-06-01');
    
    RAISE NOTICE 'Product 2 loaded: Ultimate Power+ Turbine (£799)';
    
    -- ==========================================
    -- Product 3: Optima 10 Curing Light
    -- ==========================================
    INSERT INTO products (
        name, description, vertical_id, category_id,
        model_number, attributes, is_active
    )
    VALUES (
        'Optima 10 Light and Compact Curing Light',
        'Light and compact LED curing light',
        dental_vertical_id,
        category_curing_id,
        'OPTIMA10',
        '{
            "features": [
                "1200mW/cm²",
                "Digital display",
                "5/8/10mm cure depths",
                "6 power levels",
                "360° rotation",
                "Ramp & Pulse modes"
            ],
            "warranty": "2 years",
            "power": "1200mW/cm²",
            "type": "LED"
        }'::jsonb,
        TRUE
    )
    RETURNING id INTO product_id;
    
    INSERT INTO prices (product_id, supplier_id, price, currency, is_available, scraped_at)
    VALUES (product_id, supplier_ba_id, 235.00, 'GBP', TRUE, '2024-06-01');
    
    RAISE NOTICE 'Product 3 loaded: Optima 10 Curing Light (£235)';
    
    -- ==========================================
    -- Product 4: UltiCLEAN 3004 Scaler + Air Polisher
    -- ==========================================
    INSERT INTO products (
        name, description, vertical_id, category_id,
        model_number, attributes, is_active
    )
    VALUES (
        'UltiCLEAN 3004 Dental Scaler + Air Polisher',
        'Modern scaler and air polisher combo for prevention and prophylaxis',
        dental_vertical_id,
        category_scaler_id,
        '3004',
        '{
            "features": [
                "Complete prophy solution",
                "Scaling and air polishing tools",
                "Easy to use"
            ],
            "type": "Combo Unit",
            "uses": ["Scaling", "Air Polishing", "Prevention", "Prophylaxis"]
        }'::jsonb,
        TRUE
    )
    RETURNING id INTO product_id;
    
    INSERT INTO prices (product_id, supplier_id, price, currency, is_available, scraped_at)
    VALUES (product_id, supplier_ba_id, 435.00, 'GBP', TRUE, '2024-06-01');
    
    RAISE NOTICE 'Product 4 loaded: UltiCLEAN 3004 (£435)';
    
    -- ==========================================
    -- Product 5: RACE EVO Single Patient Kit
    -- ==========================================
    INSERT INTO products (
        name, description, vertical_id, category_id,
        model_number, attributes, is_active
    )
    VALUES (
        'RACE EVO Single Patient Kit',
        'Complete rotary file system for all canal anatomies',
        dental_vertical_id,
        (SELECT id FROM categories WHERE slug = 'endodontic-files'),
        'RACE-EVO',
        '{
            "features": [
                "Dedicated files for glide path/initial/final shaping",
                "Safe/efficient/controlled",
                "Race Design + Heat Treatment"
            ],
            "recommended_speed": "800-1000 rpm",
            "type": "Rotary Files",
            "package": "Single Patient Kit"
        }'::jsonb,
        TRUE
    )
    RETURNING id INTO product_id;
    
    INSERT INTO prices (product_id, supplier_id, price, currency, is_available, scraped_at, is_on_sale, original_price, discount_percentage)
    VALUES (product_id, supplier_schott_id, 18.71, 'GBP', TRUE, '2024-06-01', TRUE, 24.95, 25.0);
    
    RAISE NOTICE 'Product 5 loaded: RACE EVO Kit (£18.71, was £24.95)';
    
    -- ==========================================
    -- Update summary
    -- ==========================================
    RAISE NOTICE '✅ Loaded 5 dental products successfully!';
    RAISE NOTICE '';
    RAISE NOTICE 'To view:';
    RAISE NOTICE '  SELECT * FROM products WHERE vertical_id = %', dental_vertical_id;
    RAISE NOTICE '  SELECT * FROM prices ORDER BY scraped_at DESC;';
    
END $$;

-- Show summary
SELECT 
    'Loaded Products' as status,
    COUNT(*) as count
FROM products 
WHERE vertical_id = (SELECT id FROM verticals WHERE slug = 'dental');

SELECT 
    'Total Prices' as status,
    COUNT(*) as count
FROM prices;






