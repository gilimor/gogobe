-- Products extracted from catalogue.pdf
-- Extracted: 2025-12-19 10:56:49
-- Total products: 800
-- Run in PostgreSQL gogobe database

DO $$
DECLARE
    dental_id INTEGER;
    cat_id INTEGER;
    supp_id INTEGER;
    pid BIGINT;
BEGIN
    -- Get vertical ID
    SELECT id INTO dental_id FROM verticals WHERE slug = 'dental';
    
    -- Get category ID
    SELECT id INTO cat_id FROM categories WHERE vertical_id = dental_id LIMIT 1;
    
    -- Create supplier for this PDF
    INSERT INTO suppliers (name, slug)
    VALUES ('catalogue', 'catalogue')
    ON CONFLICT (slug) DO NOTHING;
    
    SELECT id INTO supp_id FROM suppliers WHERE slug = 'catalogue';
    

    -- Product 1 (Page 25)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'lOX3l RRP £3995.00 IOX32 RRP £4795.00 lOX33 RRP',
        dental_id, cat_id,
        'From catalogue.pdf, page 25'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 7495.0, 'GBP', NOW());
    END IF;
    
    -- Product 2 (Page 25)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'lOX3l RRP £3995.00 IOX32 RRP',
        dental_id, cat_id,
        'From catalogue.pdf, page 25'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 4795.0, 'GBP', NOW());
    END IF;
    
    -- Product 3 (Page 25)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '25 x 36mm details.',
        dental_id, cat_id,
        'From catalogue.pdf, page 25'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 3995.0, 'GBP', NOW());
    END IF;
    
    -- Product 4 (Page 20)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Classic Flat Bed chair',
        dental_id, cat_id,
        'From catalogue.pdf, page 20'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 3950.0, 'GBP', NOW());
    END IF;
    
    -- Product 5 (Page 20)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Classic Flat Bed chair £3950.00 Soft Knee Break chair',
        dental_id, cat_id,
        'From catalogue.pdf, page 20'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 3825.0, 'GBP', NOW());
    END IF;
    
    -- Product 6 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TEP-E10RM (+D) £298.38 Cordless and portable with SURGPRO1 RRP',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 3493.0, 'GBP', NOW());
    END IF;
    
    -- Product 7 (Page 24)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Non Vacuum cycle 12 mins • HTM01-05 compliant for type B • Palm-size, light-weight comfortable',
        dental_id, cat_id,
        'From catalogue.pdf, page 24'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 3250.0, 'GBP', NOW());
    END IF;
    
    -- Product 8 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £1040.00 save 25% £780.00 RRP',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 2900.0, 'GBP', NOW());
    END IF;
    
    -- Product 9 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'valve. BORA03 Triple pack + coupling Bien Air',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 2450.0, 'GBP', NOW());
    END IF;
    
    -- Product 10 (Page 14)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• 10 preset options PANASPRAY 500ml can £21.24',
        dental_id, cat_id,
        'From catalogue.pdf, page 14'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 2350.0, 'GBP', NOW());
    END IF;
    
    -- Product 11 (Page 14)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'accessory tray Bien Air compatible for Unifix coupling No over oiling of the instruments 1 Litre',
        dental_id, cat_id,
        'From catalogue.pdf, page 14'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 2250.0, 'GBP', NOW());
    END IF;
    
    -- Product 12 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £1040.00 save 25% £780.00 RRP £2900 25% off',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 2175.0, 'GBP', NOW());
    END IF;
    
    -- Product 13 (Page 22)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'height 27"-35", variable speed foot automatic pumped drainage.',
        dental_id, cat_id,
        'From catalogue.pdf, page 22'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 2025.0, 'GBP', NOW());
    END IF;
    
    -- Product 14 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ARTE101 £399.00 ARTE103 £75.00 HYGEA2',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 1995.0, 'GBP', NOW());
    END IF;
    
    -- Product 15 (Page 22)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Wall mounted version Fimet mobile cart available as part of a CAT21 11mm £24.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 22'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 1850.0, 'GBP', NOW());
    END IF;
    
    -- Product 16 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £2450.00 only',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 1837.5, 'GBP', NOW());
    END IF;
    
    -- Product 17 (Page 22)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Mobile cart made in USA ASPI06',
        dental_id, cat_id,
        'From catalogue.pdf, page 22'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 1665.0, 'GBP', NOW());
    END IF;
    
    -- Product 18 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• High reliability, economically priced.',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 1536.74, 'GBP', NOW());
    END IF;
    
    -- Product 19 (Page 14)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'and cooling and eliminates the need OILN05 integrated detergent and foaming oil CARE3Plus C2',
        dental_id, cat_id,
        'From catalogue.pdf, page 14'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 1503.08, 'GBP', NOW());
    END IF;
    
    -- Product 20 (Page 14)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Stand aloneThe quality efficient OILN06 £9.40 care cycle CARE3Plus C1',
        dental_id, cat_id,
        'From catalogue.pdf, page 14'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 1427.06, 'GBP', NOW());
    END IF;
    
    -- Product 21 (Page 22)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Mobile cart made in USA ASPI06 £1665.00 TRID02',
        dental_id, cat_id,
        'From catalogue.pdf, page 22'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 1395.0, 'GBP', NOW());
    END IF;
    
    -- Product 22 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BLINA04 Triple pack + coupling',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 1125.0, 'GBP', NOW());
    END IF;
    
    -- Product 23 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BACA10L 10:1 reducing BAMS1 1:1 straight For smaller head PRESTIGE LK',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 1109.0, 'GBP', NOW());
    END IF;
    
    -- Product 24 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'With Apex locator head',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 1091.12, 'GBP', NOW());
    END IF;
    
    -- Product 25 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BACA1L 1:1 direct RRP',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 1050.0, 'GBP', NOW());
    END IF;
    
    -- Product 26 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BACA15L 1:5 increasing Multiflex coupling',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 1040.0, 'GBP', NOW());
    END IF;
    
    -- Product 27 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BAMCA15L 1:5 increasing',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 1040.0, 'GBP', NOW());
    END IF;
    
    -- Product 28 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '360º rotation for engine files. ENDOMATE TC2 PACK',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 999.82, 'GBP', NOW());
    END IF;
    
    -- Product 29 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'M25 Non-optic £358.82 nano95LS',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 995.25, 'GBP', NOW());
    END IF;
    
    -- Product 30 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BACA10 10:1 reducing BLINA02 Turbine + coupling',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 994.0, 'GBP', NOW());
    END IF;
    
    -- Product 31 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'clinical fluids such as hydrogen',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 959.2, 'GBP', NOW());
    END IF;
    
    -- Product 32 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £1125.00 only',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 956.25, 'GBP', NOW());
    END IF;
    
    -- Product 33 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '1:1 Direct drive, single spray, 200,000 rpm max, FG burs 1.6 dia 1:5 speed increasing, quattro spray,',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 933.04, 'GBP', NOW());
    END IF;
    
    -- Product 34 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BACA15 1:5 increasing BLINA01 Turbine',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 933.0, 'GBP', NOW());
    END IF;
    
    -- Product 35 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £493.00 save 25% £369.75 RRP',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 901.0, 'GBP', NOW());
    END IF;
    
    -- Product 36 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TIX15 4:1 Non-optic £515.98 nano15LS',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 896.3, 'GBP', NOW());
    END IF;
    
    -- Product 37 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'M15LOptic £639.29 2.35mm. Z10L',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 892.26, 'GBP', NOW());
    END IF;
    
    -- Product 38 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BACA1L 1:1 direct RRP £1050.00 25% off £787.50',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 867.0, 'GBP', NOW());
    END IF;
    
    -- Product 39 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'for CA burs 2.35dia max speed DURACOAT. Cellular glass optics. Z15L',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 840.29, 'GBP', NOW());
    END IF;
    
    -- Product 40 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £1109.00 save 25%',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 831.75, 'GBP', NOW());
    END IF;
    
    -- Product 41 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '10,000 rpm Quattro Spray 16:1 speed reducing, single spray',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 827.94, 'GBP', NOW());
    END IF;
    
    -- Product 42 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TIX95L 1:5 Optic',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 816.1, 'GBP', NOW());
    END IF;
    
    -- Product 43 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BLSPIL5 Lojic+5 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 807.7, 'GBP', NOW());
    END IF;
    
    -- Product 44 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BLSPIL5 Lojic+5 Spill x 500 £807.70 BPSPIL5 5 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 807.7, 'GBP', NOW());
    END IF;
    
    -- Product 45 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'A spherical particulate powder designed',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 802.75, 'GBP', NOW());
    END IF;
    
    -- Product 46 (Page 23)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Stainless steel tray for testing of Valisafe CEI AUTO01A',
        dental_id, cat_id,
        'From catalogue.pdf, page 23'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 796.0, 'GBP', NOW());
    END IF;
    
    -- Product 47 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BACA1L 1:1 direct RRP £1050.00 25% off',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 787.5, 'GBP', NOW());
    END IF;
    
    -- Product 48 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £1040.00 save 25%',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 780.0, 'GBP', NOW());
    END IF;
    
    -- Product 49 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'M25 Non-optic £358.82 nano95LS £995.25',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 776.19, 'GBP', NOW());
    END IF;
    
    -- Product 50 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £1033.00 only',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 774.75, 'GBP', NOW());
    END IF;
    
    -- Product 51 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TIX12L 10:1 Optic',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 761.4, 'GBP', NOW());
    END IF;
    
    -- Product 52 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TIX10L 16:1 Optic',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 761.4, 'GBP', NOW());
    END IF;
    
    -- Product 53 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BACA1122 1:1 direct',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 755.0, 'GBP', NOW());
    END IF;
    
    -- Product 54 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £994.00 save 25%',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 745.5, 'GBP', NOW());
    END IF;
    
    -- Product 55 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'X-SG20L 20:1 reduction',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 745.0, 'GBP', NOW());
    END IF;
    
    -- Product 56 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BACA1 1:1 direct spray, non optic, for Unifix connection,',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 737.0, 'GBP', NOW());
    END IF;
    
    -- Product 57 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TIX10 16:1 Non-optic £545.55 Ti Max Z45L nano65LS',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 736.31, 'GBP', NOW());
    END IF;
    
    -- Product 58 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TIX15L 4:1 Optic',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 717.05, 'GBP', NOW());
    END IF;
    
    -- Product 59 (Page 23)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '2100 Classic (Basket)',
        dental_id, cat_id,
        'From catalogue.pdf, page 23'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 716.0, 'GBP', NOW());
    END IF;
    
    -- Product 60 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'precisely detect the location of the IMPLANT HANDPIECES X-SG93L 1:3 increasing',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 711.41, 'GBP', NOW());
    END IF;
    
    -- Product 61 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BAMCA1L 1:1 direct RRP',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 700.0, 'GBP', NOW());
    END IF;
    
    -- Product 62 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £933.00 save 25%',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 699.75, 'GBP', NOW());
    END IF;
    
    -- Product 63 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'EXEND0128 £386.69 Auto-detects the apex accurately in any SGS-E2',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 698.16, 'GBP', NOW());
    END IF;
    
    -- Product 64 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'NLXSET01 £1536.74',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 695.0, 'GBP', NOW());
    END IF;
    
    -- Product 65 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Non optic SONICflex tips',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 687.25, 'GBP', NOW());
    END IF;
    
    -- Product 66 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'QDJC02 £77.62 All optic versions',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 677.62, 'GBP', NOW());
    END IF;
    
    -- Product 67 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'life of the bearings. TIX205L £676.39 M205LGM4',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 676.39, 'GBP', NOW());
    END IF;
    
    -- Product 68 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'life of the bearings. TIX205L',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 676.39, 'GBP', NOW());
    END IF;
    
    -- Product 69 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £493.00 save 25% £369.75 RRP £901.00 25% off',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 675.75, 'GBP', NOW());
    END IF;
    
    -- Product 70 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'M95 Non-optic £533.06',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 674.71, 'GBP', NOW());
    END IF;
    
    -- Product 71 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'M95 Non-optic £533.06',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 662.35, 'GBP', NOW());
    END IF;
    
    -- Product 72 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Straight Handpiece TIX25L 1:1 Optic',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 662.35, 'GBP', NOW());
    END IF;
    
    -- Product 73 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'system and removal of all residues no M40LED',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 661.98, 'GBP', NOW());
    END IF;
    
    -- Product 74 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SBSPIL5 5 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 658.87, 'GBP', NOW());
    END IF;
    
    -- Product 75 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'with push on silicone protector. PMN01 Set',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 657.41, 'GBP', NOW());
    END IF;
    
    -- Product 76 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £867.00 save 25%',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 650.25, 'GBP', NOW());
    END IF;
    
    -- Product 77 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TIX95 1:5 Non-optic',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 643.12, 'GBP', NOW());
    END IF;
    
    -- Product 78 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'M15 Non-optic £426.26 For use with CA/RA burs diameter 2,500 rpm max, CA burs 2.35 dia',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 639.29, 'GBP', NOW());
    END IF;
    
    -- Product 79 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'torque calibration enabling optimum SG-20',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 628.91, 'GBP', NOW());
    END IF;
    
    -- Product 80 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Tear resistant quality mesh BSPIL05 5 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 627.7, 'GBP', NOW());
    END IF;
    
    -- Product 81 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'GS80P GS80 Powder 250g',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 627.7, 'GBP', NOW());
    END IF;
    
    -- Product 82 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Alpron to ensure no further biofilm',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 624.75, 'GBP', NOW());
    END IF;
    
    -- Product 83 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Data Sheets LXC-12V02 £330.00 MX2-LED',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 620.25, 'GBP', NOW());
    END IF;
    
    -- Product 84 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TIX65L 1:1 Optic',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 613.55, 'GBP', NOW());
    END IF;
    
    -- Product 85 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'scaler after just 4 months’ use',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 595.0, 'GBP', NOW());
    END IF;
    
    -- Product 86 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Ti-ENDO provides the precise torque iPEX PACK',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 593.57, 'GBP', NOW());
    END IF;
    
    -- Product 87 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '2.35mm 1:1 direct drive. X-SG25L 1:1 direct',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 571.74, 'GBP', NOW());
    END IF;
    
    -- Product 88 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £755.00 save 25%',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 566.25, 'GBP', NOW());
    END IF;
    
    -- Product 89 (Page 24)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RADIP01 Plus light',
        dental_id, cat_id,
        'From catalogue.pdf, page 24'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 565.0, 'GBP', NOW());
    END IF;
    
    -- Product 90 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ALP006 Dip Slide Pack 10 £39.95 LB-20EM (Din) £129.80 MCX-LED',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 561.0, 'GBP', NOW());
    END IF;
    
    -- Product 91 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'latch head design, external and internal',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 557.43, 'GBP', NOW());
    END IF;
    
    -- Product 92 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £737.00 save 25%',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 552.75, 'GBP', NOW());
    END IF;
    
    -- Product 93 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BULTC5 5 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 546.81, 'GBP', NOW());
    END IF;
    
    -- Product 94 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TIX10 16:1 Non-optic',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 545.55, 'GBP', NOW());
    END IF;
    
    -- Product 95 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TIX12 10:1 Non-optic',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 545.55, 'GBP', NOW());
    END IF;
    
    -- Product 96 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'MPF16R £192.19 DENAP01 £215.00 depth indicator £515.32 TiSG65L 1:1',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 545.43, 'GBP', NOW());
    END IF;
    
    -- Product 97 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BLSPIL3 Lojic+3 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 532.91, 'GBP', NOW());
    END IF;
    
    -- Product 98 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BLSPIL3 Lojic+3 Spill x 500 £532.91 BPSPIL3 3 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 532.91, 'GBP', NOW());
    END IF;
    
    -- Product 99 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BAMCA1L 1:1 direct RRP £700.00 save 25%',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 525.0, 'GBP', NOW());
    END IF;
    
    -- Product 100 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TIX15 4:1 Non-optic',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 515.98, 'GBP', NOW());
    END IF;
    
    -- Product 101 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'MPF16R £192.19 DENAP01 £215.00 depth indicator',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 515.32, 'GBP', NOW());
    END IF;
    
    -- Product 102 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Universal Type Tip Midwest 4 hole fitting',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 510.0, 'GBP', NOW());
    END IF;
    
    -- Product 103 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'All optic versions',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 501.58, 'GBP', NOW());
    END IF;
    
    -- Product 104 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BAS1123 1:1 straight',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 500.0, 'GBP', NOW());
    END IF;
    
    -- Product 105 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ARTM3II25K (25k)',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 495.0, 'GBP', NOW());
    END IF;
    
    -- Product 106 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £1109.00 save 25% £831.75 RRP',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 493.0, 'GBP', NOW());
    END IF;
    
    -- Product 107 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Speed increasing factor of 5. Light via',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 493.0, 'GBP', NOW());
    END IF;
    
    -- Product 108 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'All non optic versions',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 467.5, 'GBP', NOW());
    END IF;
    
    -- Product 109 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BLSPIL2 Lojic+2 Spill x 500 £450.50 please ask BPSPIL2 2 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 450.5, 'GBP', NOW());
    END IF;
    
    -- Product 110 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BLSPIL2 Lojic+2 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 450.5, 'GBP', NOW());
    END IF;
    
    -- Product 111 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TCP200 HC7021W W&H fitting',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 449.0, 'GBP', NOW());
    END IF;
    
    -- Product 112 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'HC7021S Sirona fitting',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 449.0, 'GBP', NOW());
    END IF;
    
    -- Product 113 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'HC7021K KaVo fitting',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 449.0, 'GBP', NOW());
    END IF;
    
    -- Product 114 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SBSPIL3 3 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 444.88, 'GBP', NOW());
    END IF;
    
    -- Product 115 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'AS2000M £327.18 • Excellent weight balance',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 437.75, 'GBP', NOW());
    END IF;
    
    -- Product 116 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TIX25 1:1 Non-optic',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 435.82, 'GBP', NOW());
    END IF;
    
    -- Product 117 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'for FG burs 1.6dia max speed',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 435.82, 'GBP', NOW());
    END IF;
    
    -- Product 118 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'solution. The pH shock, so induced, PLEWS6802',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 435.0, 'GBP', NOW());
    END IF;
    
    -- Product 119 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £994.00 save 25% £745.50 RRP',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 425.0, 'GBP', NOW());
    END IF;
    
    -- Product 120 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'matter how stubborn. Ensure all M40N non optic',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 415.99, 'GBP', NOW());
    END IF;
    
    -- Product 121 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TIX65 1:1 Non-optic',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 406.58, 'GBP', NOW());
    END IF;
    
    -- Product 122 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Non-optic, latch type for use with FFB-EC FX205MM4 4 hole',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 400.42, 'GBP', NOW());
    END IF;
    
    -- Product 123 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'CA/RA burs diameter 2.35mm. Contra Angle Handpiece £132.81 FX205Mb2 2 hole',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 400.42, 'GBP', NOW());
    END IF;
    
    -- Product 124 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Satelec Scaler Handpiece WOOD17',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 399.0, 'GBP', NOW());
    END IF;
    
    -- Product 125 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'MC3LED £624.75 for only',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 399.0, 'GBP', NOW());
    END IF;
    
    -- Product 126 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Buy a pair for £18.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 399.0, 'GBP', NOW());
    END IF;
    
    -- Product 127 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ARTMB325K £399.00 flat and tip changer scaler. WOOD32 Satelec and NSK £30.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 399.0, 'GBP', NOW());
    END IF;
    
    -- Product 128 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SATHPKIT £210.00 WOOD18 DTE-D7',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 399.0, 'GBP', NOW());
    END IF;
    
    -- Product 129 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'autoclavable box tips: 2 universal, 1 flat chisel, 1 round Compatible with Woodpecker and EMS WOOD09 EMS £30.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 399.0, 'GBP', NOW());
    END IF;
    
    -- Product 130 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Monopolar unit cleaning SPSM01 £249.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 399.0, 'GBP', NOW());
    END IF;
    
    -- Product 131 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '\16:1 Reduction, miniature head, for 2 apex fire holders 2 apex probe leads SGM-ER256i 256:1',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 398.49, 'GBP', NOW());
    END IF;
    
    -- Product 132 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'FBSPIL3 3 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 396.13, 'GBP', NOW());
    END IF;
    
    -- Product 133 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'retention BSPIL03 3 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 396.13, 'GBP', NOW());
    END IF;
    
    -- Product 134 (Page 25)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'sensor driver. UltiMax works with Windows XP, Vista and Seven both 32 and 64bit versions ORAC01',
        dental_id, cat_id,
        'From catalogue.pdf, page 25'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 395.0, 'GBP', NOW());
    END IF;
    
    -- Product 135 (Page 24)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RADIIC01 Cal light',
        dental_id, cat_id,
        'From catalogue.pdf, page 24'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 395.0, 'GBP', NOW());
    END IF;
    
    -- Product 136 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'rotation for Ni Ti files. 2.35ø iPEXII 1:2 speed increasing',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 386.69, 'GBP', NOW());
    END IF;
    
    -- Product 137 (Page 9)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'water, max 25,000 rpm delivering stable high quality LED illumination even at low speeds. Air motor',
        dental_id, cat_id,
        'From catalogue.pdf, page 9'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 381.94, 'GBP', NOW());
    END IF;
    
    -- Product 138 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BULTC3 3 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 380.12, 'GBP', NOW());
    END IF;
    
    -- Product 139 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Available with push contra speed reduction 4 ball bearing. EC-30BLP',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 378.5, 'GBP', NOW());
    END IF;
    
    -- Product 140 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ME-20MPKIT £378.50 ESG-30AR £138.25 30,000 rpm ball bearing push button Screw In Prophy',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 378.5, 'GBP', NOW());
    END IF;
    
    -- Product 141 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'volume. Unit supplied with 4 lip hooks, SGM-ER64i 64:1',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 375.39, 'GBP', NOW());
    END IF;
    
    -- Product 142 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'location of apex, adjustable sound SGM-ER32i 32:1',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 375.39, 'GBP', NOW());
    END IF;
    
    -- Product 143 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £500.00 save 25%',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 375.0, 'GBP', NOW());
    END IF;
    
    -- Product 144 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £493.00 save 25%',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 369.75, 'GBP', NOW());
    END IF;
    
    -- Product 145 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £1109.00 save 25% £831.75 RRP £493.00 save 25%',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 369.75, 'GBP', NOW());
    END IF;
    
    -- Product 146 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £994.00 save 25% £745.50 RRP £425.00 only',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 361.25, 'GBP', NOW());
    END IF;
    
    -- Product 147 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TB404 Anterior SBSPIL2 2 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 359.29, 'GBP', NOW());
    END IF;
    
    -- Product 148 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'HC5021W W&H fitting',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 359.0, 'GBP', NOW());
    END IF;
    
    -- Product 149 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TCQJM4 HC5021S Sirona fitting',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 359.0, 'GBP', NOW());
    END IF;
    
    -- Product 150 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'HC5021K KaVo fitting',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 359.0, 'GBP', NOW());
    END IF;
    
    -- Product 151 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £933.00 save 25% £699.75 RRP',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 357.0, 'GBP', NOW());
    END IF;
    
    -- Product 152 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BLSPIL1 Lojic+1 Spill x 500 £354.87 BPSPIL1 1 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 354.87, 'GBP', NOW());
    END IF;
    
    -- Product 153 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BLSPIL1 Lojic+1 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 354.87, 'GBP', NOW());
    END IF;
    
    -- Product 154 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Complete with 4 tips',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 349.0, 'GBP', NOW());
    END IF;
    
    -- Product 155 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Internal basket dims. 20 x 108 x 55',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 349.0, 'GBP', NOW());
    END IF;
    
    -- Product 156 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Works equally well in wet or dry SGM-ER20i 20:1',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 345.86, 'GBP', NOW());
    END IF;
    
    -- Product 157 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Specially designed walls for extra Mercury 500gm Bottle £23.50 BSPIL02 2 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 342.09, 'GBP', NOW());
    END IF;
    
    -- Product 158 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'FBSPIL2 2 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 342.09, 'GBP', NOW());
    END IF;
    
    -- Product 159 (Page 19)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ratchet, 12" gas lift. extra cost',
        dental_id, cat_id,
        'From catalogue.pdf, page 19'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 335.0, 'GBP', NOW());
    END IF;
    
    -- Product 160 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Data Sheets LXC-12V02',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 330.0, 'GBP', NOW());
    END IF;
    
    -- Product 161 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TITANSW Including Coupling Prophy-Mate Neo',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 327.18, 'GBP', NOW());
    END IF;
    
    -- Product 162 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TITANK Without Coupling',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 327.18, 'GBP', NOW());
    END IF;
    
    -- Product 163 (Page 24)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Can read light output of',
        dental_id, cat_id,
        'From catalogue.pdf, page 24'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 325.0, 'GBP', NOW());
    END IF;
    
    -- Product 164 (Page 19)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'GRS12 £175.00 Surgeon saddle stool, ergonomically',
        dental_id, cat_id,
        'From catalogue.pdf, page 19'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 325.0, 'GBP', NOW());
    END IF;
    
    -- Product 165 (Page 19)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'GRS13 ring, 12" gas lift',
        dental_id, cat_id,
        'From catalogue.pdf, page 19'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 325.0, 'GBP', NOW());
    END IF;
    
    -- Product 166 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'and get a free connector PTLOP01 Complete Pack',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 322.89, 'GBP', NOW());
    END IF;
    
    -- Product 167 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SAT04 £54.95 complete with 6 tips: 2 x GD1, 1 x WOOD01',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 319.0, 'GBP', NOW());
    END IF;
    
    -- Product 168 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'E-Type Airmotor Kit 2 hole',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 315.25, 'GBP', NOW());
    END IF;
    
    -- Product 169 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'E-Type Airmotor Kit 4 hole',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 315.25, 'GBP', NOW());
    END IF;
    
    -- Product 170 (Page 19)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Available in Fimet GMS10',
        dental_id, cat_id,
        'From catalogue.pdf, page 19'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 315.0, 'GBP', NOW());
    END IF;
    
    -- Product 171 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BULTC2 2 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 304.16, 'GBP', NOW());
    END IF;
    
    -- Product 172 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BULTCF2 2 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 304.16, 'GBP', NOW());
    END IF;
    
    -- Product 173 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SBSPIL1 1 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 303.98, 'GBP', NOW());
    END IF;
    
    -- Product 174 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'With Apex locator head £1091.12',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 303.65, 'GBP', NOW());
    END IF;
    
    -- Product 175 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £933.00 save 25% £699.75 RRP £357.00 only',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 303.45, 'GBP', NOW());
    END IF;
    
    -- Product 176 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ARTMB330K £399.00 ARTP6',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 299.0, 'GBP', NOW());
    END IF;
    
    -- Product 177 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'WITHOUT LIGHT TI9500BLUX',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 299.0, 'GBP', NOW());
    END IF;
    
    -- Product 178 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• HTM01-05 and HTM2030 compliant',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 295.0, 'GBP', NOW());
    END IF;
    
    -- Product 179 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'WOOD16 EMS £30.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 295.0, 'GBP', NOW());
    END IF;
    
    -- Product 180 (Page 19)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'position, 9" gas lift',
        dental_id, cat_id,
        'From catalogue.pdf, page 19'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 295.0, 'GBP', NOW());
    END IF;
    
    -- Product 181 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '128:1 Reduction, Miniature Head. 360º SGS-ES',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 292.37, 'GBP', NOW());
    END IF;
    
    -- Product 182 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'for engine files 1/4 Turn Endodontic With probe ring for apex locator, long',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 285.33, 'GBP', NOW());
    END IF;
    
    -- Product 183 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ALLOYS FBSPIL1 1 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 279.0, 'GBP', NOW());
    END IF;
    
    -- Product 184 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Strong and tough plastic MCY01 BSPIL01 1 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 279.0, 'GBP', NOW());
    END IF;
    
    -- Product 185 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Used together, the MX2 and Micro- RRP £183.00 save 25% £137.25',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 267.0, 'GBP', NOW());
    END IF;
    
    -- Product 186 (Page 19)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'foot-ring Assistant stool, extra lever for back rest',
        dental_id, cat_id,
        'From catalogue.pdf, page 19'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 265.0, 'GBP', NOW());
    END IF;
    
    -- Product 187 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ARYK Head only £37.14 ER64M 64:1Reduction',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 262.08, 'GBP', NOW());
    END IF;
    
    -- Product 188 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ALP001 BRS full starter kit £99.50 LXC-12V01',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 260.0, 'GBP', NOW());
    END IF;
    
    -- Product 189 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Contra Angle Handpiece £88.93 FX205MM4',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 257.12, 'GBP', NOW());
    END IF;
    
    -- Product 190 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Buy 3 for £112.05 each',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 256.39, 'GBP', NOW());
    END IF;
    
    -- Product 191 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Standard Head - Size 10.6dia x 12.5H • Push Button Chuck Stainless Steel Body. NMCSU03 Standard £119.52',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 256.39, 'GBP', NOW());
    END IF;
    
    -- Product 192 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'for hand files 1/4 Turn Endodontic with MPASF16R',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 252.2, 'GBP', NOW());
    END IF;
    
    -- Product 193 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TEQ-E 1.1 £151.95 MPAF16R',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 252.2, 'GBP', NOW());
    END IF;
    
    -- Product 194 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Monopolar unit cleaning SPSM01',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 249.0, 'GBP', NOW());
    END IF;
    
    -- Product 195 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Buy 3 for £129.00 each spray, 340000 rpm idle speed, ceramic',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 249.0, 'GBP', NOW());
    END IF;
    
    -- Product 196 (Page 24)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Easy to record and interpret small hands RADIIP06 bleach arch kit',
        dental_id, cat_id,
        'From catalogue.pdf, page 24'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 249.0, 'GBP', NOW());
    END IF;
    
    -- Product 197 (Page 19)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Assistant stool, 12" gas lift with SRS08',
        dental_id, cat_id,
        'From catalogue.pdf, page 19'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 235.0, 'GBP', NOW());
    END IF;
    
    -- Product 198 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'E64R 64:1 Reduction',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 233.02, 'GBP', NOW());
    END IF;
    
    -- Product 199 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BULTC1 1 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 232.35, 'GBP', NOW());
    END IF;
    
    -- Product 200 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BULTCF1 1 Spill x 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 232.35, 'GBP', NOW());
    END IF;
    
    -- Product 201 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PAXPTUM4 Midwest 4 Hole',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 230.1, 'GBP', NOW());
    END IF;
    
    -- Product 202 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PAXPTUB2 Borden 2 Hole',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 230.1, 'GBP', NOW());
    END IF;
    
    -- Product 203 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PAXPSUM4 Midwest 4 Hole',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 230.1, 'GBP', NOW());
    END IF;
    
    -- Product 204 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PAXPSUB2 Borden 2 Hole',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 230.1, 'GBP', NOW());
    END IF;
    
    -- Product 205 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SCL-LED for Sirona®',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 229.66, 'GBP', NOW());
    END IF;
    
    -- Product 206 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'water volume adjuster Ti-Max',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 229.66, 'GBP', NOW());
    END IF;
    
    -- Product 207 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £267.00 only',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 226.95, 'GBP', NOW());
    END IF;
    
    -- Product 208 (Page 19)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Surgeon stool, 9" gas lift',
        dental_id, cat_id,
        'From catalogue.pdf, page 19'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 225.0, 'GBP', NOW());
    END IF;
    
    -- Product 209 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Thermo Disinfector Proof £102.91 ER16M 16:1Reduction',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 223.0, 'GBP', NOW());
    END IF;
    
    -- Product 210 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'mid west fitting',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 219.0, 'GBP', NOW());
    END IF;
    
    -- Product 211 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'rates HC2001B borden fitting',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 219.0, 'GBP', NOW());
    END IF;
    
    -- Product 212 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PAXSUB2 Borden 2 Hole',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 216.22, 'GBP', NOW());
    END IF;
    
    -- Product 213 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PAXSUM4 Midwest 4 Hole',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 216.22, 'GBP', NOW());
    END IF;
    
    -- Product 214 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PAXTUB2 Borden 2 Hole',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 216.22, 'GBP', NOW());
    END IF;
    
    -- Product 215 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PAXTUM4 Midwest 4 Hole',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 216.22, 'GBP', NOW());
    END IF;
    
    -- Product 216 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'MPF16R £192.19 DENAP01',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 215.0, 'GBP', NOW());
    END IF;
    
    -- Product 217 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Auto alarm after 20 seconds',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 215.0, 'GBP', NOW());
    END IF;
    
    -- Product 218 (Page 19)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Assistant seat only, 9" gas lift with',
        dental_id, cat_id,
        'From catalogue.pdf, page 19'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 215.0, 'GBP', NOW());
    END IF;
    
    -- Product 219 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'subgingival, and Interdental.',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 210.0, 'GBP', NOW());
    END IF;
    
    -- Product 220 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'AREMK ER10M 10:1Reduction',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 209.08, 'GBP', NOW());
    END IF;
    
    -- Product 221 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'E16R 16:1 Reduction',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 209.03, 'GBP', NOW());
    END IF;
    
    -- Product 222 (Page 30)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS113 £2.90 BDS08 £1.60 BDS251 £2.90 KIT-HY £20.95',
        dental_id, cat_id,
        'From catalogue.pdf, page 30'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 200.0, 'GBP', NOW());
    END IF;
    
    -- Product 223 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Childs Upper Pre Molars 159',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 200.0, 'GBP', NOW());
    END IF;
    
    -- Product 224 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'S1,S2,S3 wrench and cover. Available Non optic PROP300M4',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 199.0, 'GBP', NOW());
    END IF;
    
    -- Product 225 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Solid titanium body. 3 Level power ring, 6000, Hz elliptical movement, complete PROP300B2',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 199.0, 'GBP', NOW());
    END IF;
    
    -- Product 226 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Includes 3 tips and tip changer',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 199.0, 'GBP', NOW());
    END IF;
    
    -- Product 227 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'E10R 10:1 Reduction',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 195.09, 'GBP', NOW());
    END IF;
    
    -- Product 228 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'GK4 Longer tip Perio £35.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 195.0, 'GBP', NOW());
    END IF;
    
    -- Product 229 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Buy 3 for £30.00 each Midwest',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 195.0, 'GBP', NOW());
    END IF;
    
    -- Product 230 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'please ring ALMT01',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 195.0, 'GBP', NOW());
    END IF;
    
    -- Product 231 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Ni-Ti files 2.35ø and batteries SGMS-ER20i 20:1 with 40,000rpm',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 192.19, 'GBP', NOW());
    END IF;
    
    -- Product 232 (Page 24)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ACUA4 £2395.00 MEDSAT01 19mm x 50mts £2.60 LEDC £149.00 WOOD29',
        dental_id, cat_id,
        'From catalogue.pdf, page 24'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 185.0, 'GBP', NOW());
    END IF;
    
    -- Product 233 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £737.00 save 25% £552.75 end of the day. 12 months warranty BAUNI03',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 183.0, 'GBP', NOW());
    END IF;
    
    -- Product 234 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Used together, the MX2 and Micro- RRP',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 183.0, 'GBP', NOW());
    END IF;
    
    -- Product 235 (Page 24)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'touchscreen display CU100A',
        dental_id, cat_id,
        'From catalogue.pdf, page 24'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 179.0, 'GBP', NOW());
    END IF;
    
    -- Product 236 (Page 19)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Surgeon seat only, 9" gas lift GMS10',
        dental_id, cat_id,
        'From catalogue.pdf, page 19'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 175.0, 'GBP', NOW());
    END IF;
    
    -- Product 237 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Triple pack £590.00 LEDB01 LED £49.50 PLSET01',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 169.0, 'GBP', NOW());
    END IF;
    
    -- Product 238 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'turbine. Fits to quick connector optimizes durability and scratch',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 169.0, 'GBP', NOW());
    END IF;
    
    -- Product 239 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ARYKC01 £15.53 FX57M',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 168.17, 'GBP', NOW());
    END IF;
    
    -- Product 240 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'E10R 10:1 Reduction £195.09 FX-15M',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 168.17, 'GBP', NOW());
    END IF;
    
    -- Product 241 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'clean head system, ultra push chuck, • Quattro Spray PTL-CL-LEDIII',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 162.02, 'GBP', NOW());
    END IF;
    
    -- Product 242 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Tank dimensions: 285 x 205 x 160mm',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 159.0, 'GBP', NOW());
    END IF;
    
    -- Product 243 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'CERA01 £24.95 AMALGINT',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 159.0, 'GBP', NOW());
    END IF;
    
    -- Product 244 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ALP003 Alpron 5L refill £149.50 LXC-125',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 156.2, 'GBP', NOW());
    END IF;
    
    -- Product 245 (Page 13)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TEQ-E10R £285.33 shank files',
        dental_id, cat_id,
        'From catalogue.pdf, page 13'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 151.95, 'GBP', NOW());
    END IF;
    
    -- Product 246 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ALP003 Alpron 5L refill',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 149.5, 'GBP', NOW());
    END IF;
    
    -- Product 247 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Non-optic, latch type for use with Non-optic, push button chuck for use technologies developed throughout FX-65M',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 149.14, 'GBP', NOW());
    END IF;
    
    -- Product 248 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'EX-6 The NEW FX205M mini air motor is',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 149.14, 'GBP', NOW());
    END IF;
    
    -- Product 249 (Page 23)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• W600 x H820 x D540',
        dental_id, cat_id,
        'From catalogue.pdf, page 23'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 149.0, 'GBP', NOW());
    END IF;
    
    -- Product 250 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'U95 £215.00 ALGMIX01',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 149.0, 'GBP', NOW());
    END IF;
    
    -- Product 251 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Pack includes PTL control module, PTL',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 149.0, 'GBP', NOW());
    END IF;
    
    -- Product 252 (Page 24)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ACUA4 £2395.00 MEDSAT01 19mm x 50mts £2.60 LEDC',
        dental_id, cat_id,
        'From catalogue.pdf, page 24'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 149.0, 'GBP', NOW());
    END IF;
    
    -- Product 253 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BB-EC 1:1 Latch Contra Thermo Disinfector Proof',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 146.8, 'GBP', NOW());
    END IF;
    
    -- Product 254 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PTLCM01 Control Module',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 145.78, 'GBP', NOW());
    END IF;
    
    -- Product 255 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'standard and torque heads. Suitable for KaVo®, and Sirona® PTL-CL-LED',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 145.62, 'GBP', NOW());
    END IF;
    
    -- Product 256 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Hydrogen Peroxide 6%',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 145.0, 'GBP', NOW());
    END IF;
    
    -- Product 257 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '90 min to overnight',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 145.0, 'GBP', NOW());
    END IF;
    
    -- Product 258 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'MXB04 Pk 12 £1.75 LUX002',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 145.0, 'GBP', NOW());
    END IF;
    
    -- Product 259 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'and accessories.',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 145.0, 'GBP', NOW());
    END IF;
    
    -- Product 260 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Easy installation and hook up of the Control, which stabilizes and adjusts',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 144.0, 'GBP', NOW());
    END IF;
    
    -- Product 261 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ARTMB330K £399.00 ARTP6 £299.00 WOOD02',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 144.0, 'GBP', NOW());
    END IF;
    
    -- Product 262 (Page 22)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'and chip blower Spiral Tubing',
        dental_id, cat_id,
        'From catalogue.pdf, page 22'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 140.0, 'GBP', NOW());
    END IF;
    
    -- Product 263 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ME-20MPKIT £378.50 ESG-30AR',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 138.25, 'GBP', NOW());
    END IF;
    
    -- Product 264 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RRP £183.00 save 25%',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 137.25, 'GBP', NOW());
    END IF;
    
    -- Product 265 (Page 12)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Used together, the MX2 and Micro- RRP £183.00 save 25%',
        dental_id, cat_id,
        'From catalogue.pdf, page 12'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 137.25, 'GBP', NOW());
    END IF;
    
    -- Product 266 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BBEEFFOORREE AAFFTTEERR',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 136.0, 'GBP', NOW());
    END IF;
    
    -- Product 267 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'POLADB6 £145.00 Bulk kit Polanight 10% POLATR01 £13.25',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 136.0, 'GBP', NOW());
    END IF;
    
    -- Product 268 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'NAC-EC 1:1 Latch Contra Angle Handpiece',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 135.15, 'GBP', NOW());
    END IF;
    
    -- Product 269 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PTL4HP01Optic Hose',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 135.1, 'GBP', NOW());
    END IF;
    
    -- Product 270 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'EHN-50PS (for NSK) £28.93',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 133.0, 'GBP', NOW());
    END IF;
    
    -- Product 271 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'CA/RA burs diameter 2.35mm. Contra Angle Handpiece',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 132.81, 'GBP', NOW());
    END IF;
    
    -- Product 272 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Contra Angle Handpiece £88.93 ER4M 4:1 Reduction',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 131.04, 'GBP', NOW());
    END IF;
    
    -- Product 273 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ALP006 Dip Slide Pack 10 £39.95 LB-20EM (Din)',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 129.8, 'GBP', NOW());
    END IF;
    
    -- Product 274 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ALP005 Dip Slide £5.50 LB-20EMJ (Jack)',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 129.8, 'GBP', NOW());
    END IF;
    
    -- Product 275 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'the entire preparation area',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 129.0, 'GBP', NOW());
    END IF;
    
    -- Product 276 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '2 KIT rate £19.00 each FUJI PLUS02 liquid 8g',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 129.0, 'GBP', NOW());
    END IF;
    
    -- Product 277 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '30g Powder Kit. FUJI Light cured conditioner 25g SET_ _ (Shade) box of 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 129.0, 'GBP', NOW());
    END IF;
    
    -- Product 278 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Hi-Fi Liquid 10ml SET_ _ (Shade) box of 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 125.0, 'GBP', NOW());
    END IF;
    
    -- Product 279 (Page 5)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SEPBIO01 15 capsules',
        dental_id, cat_id,
        'From catalogue.pdf, page 5'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 124.95, 'GBP', NOW());
    END IF;
    
    -- Product 280 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'EX-6B Straight Handpiece',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 121.17, 'GBP', NOW());
    END IF;
    
    -- Product 281 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Sealed Prophy Screw-in EC-20APS',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 120.0, 'GBP', NOW());
    END IF;
    
    -- Product 282 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Internal dims. 200 x 150 x 75',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 120.0, 'GBP', NOW());
    END IF;
    
    -- Product 283 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'EC-30BLP £133.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.7, 'GBP', NOW());
    END IF;
    
    -- Product 284 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Cellular Glass Optics SXSUO3',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.52, 'GBP', NOW());
    END IF;
    
    -- Product 285 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Mini (500) head power 16W TiSU03',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.52, 'GBP', NOW());
    END IF;
    
    -- Product 286 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Pana Max • Clean Head System LED Light SXSUO3',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.52, 'GBP', NOW());
    END IF;
    
    -- Product 287 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Ceramic Bearings SXMUO3',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.52, 'GBP', NOW());
    END IF;
    
    -- Product 288 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• ISB Turbine SXMUO3',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.52, 'GBP', NOW());
    END IF;
    
    -- Product 289 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PAXQDSU £256.39 • Quattro Spray FMCLB £97.03 NMCMU03 Mini',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.52, 'GBP', NOW());
    END IF;
    
    -- Product 290 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TURBINES NPATU03 Torque',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.52, 'GBP', NOW());
    END IF;
    
    -- Product 291 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'NSK’s Premium Series Turbines 2/3 HOLE BORDEN NPAMU03 Mini',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.52, 'GBP', NOW());
    END IF;
    
    -- Product 292 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Standard Head - Size 10.6dia x 12.5H • Push Button Chuck Stainless Steel Body. NMCSU03 Standard',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.52, 'GBP', NOW());
    END IF;
    
    -- Product 293 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'NPASU03 Standard',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.52, 'GBP', NOW());
    END IF;
    
    -- Product 294 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Speed 380000-450000 rpm TiTU03',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.52, 'GBP', NOW());
    END IF;
    
    -- Product 295 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PAXPSUB2 Borden 2 Hole £230.10 NCHTU',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.52, 'GBP', NOW());
    END IF;
    
    -- Product 296 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PAXPSUM4 Midwest 4 Hole£230.10 NCHSU',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.52, 'GBP', NOW());
    END IF;
    
    -- Product 297 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'QD couplings • Clean Head System FM-CL-B NMCTU03 Torque',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 119.52, 'GBP', NOW());
    END IF;
    
    -- Product 298 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'design, easy maintenance with FLASHPS',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 117.92, 'GBP', NOW());
    END IF;
    
    -- Product 299 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ME-80B 2 HOLE £200.57 EC-50PK £62.85 SHS-EGG Handpiece',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 117.2, 'GBP', NOW());
    END IF;
    
    -- Product 300 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ARYS Head only £37.14 E4R 4:1 Reduction',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 117.06, 'GBP', NOW());
    END IF;
    
    -- Product 301 (Page 14)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'HANDPIECE OIL 6 x 500ml cans',
        dental_id, cat_id,
        'From catalogue.pdf, page 14'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 114.65, 'GBP', NOW());
    END IF;
    
    -- Product 302 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Screw on type high speed turbine, • Push Button Chuck For NSK with water volume adjuster Buy 3 for',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 112.05, 'GBP', NOW());
    END IF;
    
    -- Product 303 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Size 10.6dia x 12.5H Buy 3 for',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 112.05, 'GBP', NOW());
    END IF;
    
    -- Product 304 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Torque Head - Size 12.1dia x 13.5H FM-CL-M4 Buy 3 for',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 112.05, 'GBP', NOW());
    END IF;
    
    -- Product 305 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Titanium Body with Scratch NON OPTICAL FITTING Buy 3 for',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 112.05, 'GBP', NOW());
    END IF;
    
    -- Product 306 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Torque Head - Size 12.1dia x 13.5H • 2 Year warranty',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 112.05, 'GBP', NOW());
    END IF;
    
    -- Product 307 (Page 23)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Economy model. As the Pico Flush model without the MEDIPCD AUTO01SEAL pack 4',
        dental_id, cat_id,
        'From catalogue.pdf, page 23'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 111.51, 'GBP', NOW());
    END IF;
    
    -- Product 308 (Page 27)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'KIT1 All for £99.50 KIT2 All for',
        dental_id, cat_id,
        'From catalogue.pdf, page 27'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 110.0, 'GBP', NOW());
    END IF;
    
    -- Product 309 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'straight handpiece and an E-type latch',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 109.25, 'GBP', NOW());
    END IF;
    
    -- Product 310 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '4 hole LED coupling handpiece',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 109.0, 'GBP', NOW());
    END IF;
    
    -- Product 311 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Thermo Disinfector Proof',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 102.91, 'GBP', NOW());
    END IF;
    
    -- Product 312 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Easy instrument identification. Each box',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 100.0, 'GBP', NOW());
    END IF;
    
    -- Product 313 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ALP001 BRS full starter kit',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 99.5, 'GBP', NOW());
    END IF;
    
    -- Product 314 (Page 23)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PICO XXL 2 x 25 pack',
        dental_id, cat_id,
        'From catalogue.pdf, page 23'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 99.5, 'GBP', NOW());
    END IF;
    
    -- Product 315 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Please ring for triple pack offers',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 99.0, 'GBP', NOW());
    END IF;
    
    -- Product 316 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BB-EC 1:1 Latch Contra Thermo Disinfector Proof £146.80',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 98.96, 'GBP', NOW());
    END IF;
    
    -- Product 317 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PAXQDSU £256.39 • Quattro Spray FMCLB',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 97.03, 'GBP', NOW());
    END IF;
    
    -- Product 318 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Ti-MAX X SERIES FMCLM4',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 97.03, 'GBP', NOW());
    END IF;
    
    -- Product 319 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'LSPIL5 Lojic+5 Spill x 50 £96.62 available – PSPIL5 5 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 96.62, 'GBP', NOW());
    END IF;
    
    -- Product 320 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'LSPIL5 Lojic+5 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 96.62, 'GBP', NOW());
    END IF;
    
    -- Product 321 (Page 4)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Metronidazole SEPRTRCON Pack £69.95 SEPEP02 3 x 14g',
        dental_id, cat_id,
        'From catalogue.pdf, page 4'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 96.16, 'GBP', NOW());
    END IF;
    
    -- Product 322 (Page 4)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'KPETC01 28pk £2.50 BLDENT01 5pk',
        dental_id, cat_id,
        'From catalogue.pdf, page 4'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 89.9, 'GBP', NOW());
    END IF;
    
    -- Product 323 (Page 23)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'handpiece manifold. 1 x PCD and 10 CEI test strips',
        dental_id, cat_id,
        'From catalogue.pdf, page 23'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 89.25, 'GBP', NOW());
    END IF;
    
    -- Product 324 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'QDJK03 £109.00 Light Control Module',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 89.0, 'GBP', NOW());
    END IF;
    
    -- Product 325 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Contra Angle Handpiece',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 88.93, 'GBP', NOW());
    END IF;
    
    -- Product 326 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'plaque are quickly erased FLASHPB',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 85.69, 'GBP', NOW());
    END IF;
    
    -- Product 327 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'MXBH03 holder £6.95 LUX001',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 85.0, 'GBP', NOW());
    END IF;
    
    -- Product 328 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'S950L £802.75 KAVOSF07 Perio No.7',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 85.0, 'GBP', NOW());
    END IF;
    
    -- Product 329 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'S950 £687.25 KAVOSF05 Universal No.5',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 85.0, 'GBP', NOW());
    END IF;
    
    -- Product 330 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Optic KASVOFG06 SICKLE No.6',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 85.0, 'GBP', NOW());
    END IF;
    
    -- Product 331 (Page 53)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'POLAOFF63 rrp £99.40',
        dental_id, cat_id,
        'From catalogue.pdf, page 53'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 83.5, 'GBP', NOW());
    END IF;
    
    -- Product 332 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Handpiece £78.86 FPBY01 Head only',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 83.38, 'GBP', NOW());
    END IF;
    
    -- Product 333 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PAXSUM4 Midwest 4 Hole £216.22 • Non optic versions available for NPAS03',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 81.32, 'GBP', NOW());
    END IF;
    
    -- Product 334 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'thermodisinfector. • Integrated LED handpieces available',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 81.32, 'GBP', NOW());
    END IF;
    
    -- Product 335 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Torque Head - Size • Optic versions available for NSK,',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 81.32, 'GBP', NOW());
    END IF;
    
    -- Product 336 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Handpiece £98.96 FFBY01 Head only',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 81.04, 'GBP', NOW());
    END IF;
    
    -- Product 337 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Wall mounted or free standing speed and time adjustment',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 79.5, 'GBP', NOW());
    END IF;
    
    -- Product 338 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'NAC-EC 1:1 Latch Contra Angle Handpiece £135.15 offers a more secure grip. Stainless',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 78.86, 'GBP', NOW());
    END IF;
    
    -- Product 339 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '2 & 3 Hole Borden',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 77.62, 'GBP', NOW());
    END IF;
    
    -- Product 340 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PAXTUM4 Midwest 4 Hole £216.22 Sirona®, W&H®and Bien Air® KCL-LED Buy 3 for',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 76.24, 'GBP', NOW());
    END IF;
    
    -- Product 341 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ME-80M 5,000 rpm 4 hole Motor EH-30BLP',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 75.0, 'GBP', NOW());
    END IF;
    
    -- Product 342 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'EHN-30BLP (for NSK)',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 75.0, 'GBP', NOW());
    END IF;
    
    -- Product 343 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ARTE101 £399.00 ARTE103',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 75.0, 'GBP', NOW());
    END IF;
    
    -- Product 344 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SSPIL5 5 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 74.26, 'GBP', NOW());
    END IF;
    
    -- Product 345 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Handpiece £78.86 FPBY01 Head only £83.38 steel material ensures high durability',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 72.79, 'GBP', NOW());
    END IF;
    
    -- Product 346 (Page 14)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Sinus membrane separator. expanding cleaning gas and dirt',
        dental_id, cat_id,
        'From catalogue.pdf, page 14'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 72.78, 'GBP', NOW());
    END IF;
    
    -- Product 347 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Wide occlusal plane AMARM241X 30g POA SPIL05 5 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 71.22, 'GBP', NOW());
    END IF;
    
    -- Product 348 (Page 4)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Metronidazole SEPRTRCON Pack',
        dental_id, cat_id,
        'From catalogue.pdf, page 4'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 69.95, 'GBP', NOW());
    END IF;
    
    -- Product 349 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Box 50 • 12 gm hand mix powder/water Light Yellow (CERK2) same visit. Bonds to enamel, dentine',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 69.75, 'GBP', NOW());
    END IF;
    
    -- Product 350 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'As above with 1 port spray couplings PL324C',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 69.0, 'GBP', NOW());
    END IF;
    
    -- Product 351 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RIVARLC _ _ (shade)',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 68.5, 'GBP', NOW());
    END IF;
    
    -- Product 352 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'HFP _ _ _ £22.95 RIVAAPP £31.00 RIVAPRO02',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 68.49, 'GBP', NOW());
    END IF;
    
    -- Product 353 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'HFDP_ _ _ £26.95 RIVAPRO01',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 68.49, 'GBP', NOW());
    END IF;
    
    -- Product 354 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ULTC5 5 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 67.79, 'GBP', NOW());
    END IF;
    
    -- Product 355 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'LSPIL3 Lojic+3 Spill x 50 £65.14 PSPIL3 3 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 65.14, 'GBP', NOW());
    END IF;
    
    -- Product 356 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'LSPIL3 Lojic+3 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 65.14, 'GBP', NOW());
    END IF;
    
    -- Product 357 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '2 or 4 hole EC-50PK SHS-EG Handpiece',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 65.0, 'GBP', NOW());
    END IF;
    
    -- Product 358 (Page 5)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SEPRACE01 13ml £20.89 3 x 1.4g + 20 tips',
        dental_id, cat_id,
        'From catalogue.pdf, page 5'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 64.95, 'GBP', NOW());
    END IF;
    
    -- Product 359 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RIVAFS _ _ (shade)',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 64.5, 'GBP', NOW());
    END IF;
    
    -- Product 360 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RIVARS _ _ (shade)',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 64.5, 'GBP', NOW());
    END IF;
    
    -- Product 361 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ME-80B 2 HOLE £200.57 EC-50PK',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 62.85, 'GBP', NOW());
    END IF;
    
    -- Product 362 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Sealed Prophy Screw-in EC-20APS £120.00 30,000 ball bearing push button for',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 62.85, 'GBP', NOW());
    END IF;
    
    -- Product 363 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Latch Contra 20,000 rpm EH-30BL',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 62.85, 'GBP', NOW());
    END IF;
    
    -- Product 364 (Page 23)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Standard main power • HTM 2030 and HTM 01-05 compliant 3EZYME 4 litre',
        dental_id, cat_id,
        'From catalogue.pdf, page 23'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 62.5, 'GBP', NOW());
    END IF;
    
    -- Product 365 (Page 5)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Ledermix Kit BLLEDKIT01 Pack',
        dental_id, cat_id,
        'From catalogue.pdf, page 5'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 62.45, 'GBP', NOW());
    END IF;
    
    -- Product 366 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ADAPT02 MW to B £39.95 Buy a 3 pack for',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 61.4, 'GBP', NOW());
    END IF;
    
    -- Product 367 (Page 24)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'and chiropody surgeries 134 C 3 mins x 100 £13.50 LED-C MET200',
        dental_id, cat_id,
        'From catalogue.pdf, page 24'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 59.95, 'GBP', NOW());
    END IF;
    
    -- Product 368 (Page 24)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'MEDBD01 • Built-in light check in the charger RADIIP07 bleach arch stand',
        dental_id, cat_id,
        'From catalogue.pdf, page 24'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 59.95, 'GBP', NOW());
    END IF;
    
    -- Product 369 (Page 14)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ARTOP1 Set £2250.00 OILN02 £9.40 QUAT2104 POA Care3oil',
        dental_id, cat_id,
        'From catalogue.pdf, page 14'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 59.87, 'GBP', NOW());
    END IF;
    
    -- Product 370 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ALP004 Clean & Clear Wire Tip',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 59.5, 'GBP', NOW());
    END IF;
    
    -- Product 371 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'KLZ01 40g Powder £16.95',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 59.0, 'GBP', NOW());
    END IF;
    
    -- Product 372 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Eugenol Liquid 30ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 59.0, 'GBP', NOW());
    END IF;
    
    -- Product 373 (Page 42)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'FINBUR_ _ Each style £4.70',
        dental_id, cat_id,
        'From catalogue.pdf, page 42'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 58.5, 'GBP', NOW());
    END IF;
    
    -- Product 374 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'release, Radiopaque, in 3 shades A1 For cementation of metal or porcelain posts, veneers, orthodontic bands.',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 58.1, 'GBP', NOW());
    END IF;
    
    -- Product 375 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'unidose complets COM248X2A3.5 Dark Yellow £22.95 shade A3',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 57.5, 'GBP', NOW());
    END IF;
    
    -- Product 376 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'EHN-30BL (for NSK)',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 56.85, 'GBP', NOW());
    END IF;
    
    -- Product 377 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ME-20B 20,000 rpm 2 hole Motor Buy 3 for £56.56 each bur',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 56.85, 'GBP', NOW());
    END IF;
    
    -- Product 378 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ME-20B 20,000 rpm 2 hole Motor Buy 3 for',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 56.56, 'GBP', NOW());
    END IF;
    
    -- Product 379 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'LSPIL2 Lojic+2 Spill x 50 £55.86 Full SDI range PSPIL2 2 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 55.86, 'GBP', NOW());
    END IF;
    
    -- Product 380 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'LSPIL2 Lojic+2 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 55.86, 'GBP', NOW());
    END IF;
    
    -- Product 381 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Scaling, Perio and Endo. Comes Curing light attachment available see P22',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 54.95, 'GBP', NOW());
    END IF;
    
    -- Product 382 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Detachable autoclavable handpiece WOOD25 Satelec and NSK £30.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 54.95, 'GBP', NOW());
    END IF;
    
    -- Product 383 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'for supra-gingival scaling SAT10X',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 54.95, 'GBP', NOW());
    END IF;
    
    -- Product 384 (Page 44)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ANTERIOR CROWNS Please order PTCR…then the number',
        dental_id, cat_id,
        'From catalogue.pdf, page 44'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 54.95, 'GBP', NOW());
    END IF;
    
    -- Product 385 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'and tip changer all Satelec compatible',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 54.95, 'GBP', NOW());
    END IF;
    
    -- Product 386 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Extra Heavy RDRC06 £6.45 RDF01 £5.95 Regular set: work time 2.30min, set AFFPU02 Soft',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 49.95, 'GBP', NOW());
    END IF;
    
    -- Product 387 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Heavy RDRC05 £6.25 sterile and dry operation. Contains 6 regular and 6 intra oral tips. AFFPU01 Fast',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 49.95, 'GBP', NOW());
    END IF;
    
    -- Product 388 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'time 1.00 min AFFPU03 Super soft',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 49.95, 'GBP', NOW());
    END IF;
    
    -- Product 389 (Page 31)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'WBG01 £21.80 PINL01',
        dental_id, cat_id,
        'From catalogue.pdf, page 31'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 49.95, 'GBP', NOW());
    END IF;
    
    -- Product 390 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SSPIL3 3 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 49.94, 'GBP', NOW());
    END IF;
    
    -- Product 391 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Triple pack £590.00 LEDB01 LED',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 49.5, 'GBP', NOW());
    END IF;
    
    -- Product 392 (Page 44)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Molar Kit - 96 assorted',
        dental_id, cat_id,
        'From catalogue.pdf, page 44'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 49.5, 'GBP', NOW());
    END IF;
    
    -- Product 393 (Page 25)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PACKAGE 1 PACKAGE 2 PACKAGE 3',
        dental_id, cat_id,
        'From catalogue.pdf, page 25'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 49.5, 'GBP', NOW());
    END IF;
    
    -- Product 394 (Page 24)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'The Medisafe TST Helix is a Hollow Load • Only 3 seconds to cure most',
        dental_id, cat_id,
        'From catalogue.pdf, page 24'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 49.0, 'GBP', NOW());
    END IF;
    
    -- Product 395 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Hi-Fi Liquid 10ml SET_ _ (Shade) box of 50 £125.00 RIVALC',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 48.12, 'GBP', NOW());
    END IF;
    
    -- Product 396 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'AIRSCALE05 Perio tip £31.25',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 48.0, 'GBP', NOW());
    END IF;
    
    -- Product 397 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Buy 3 tips for £27.50 each Prophy 300 Air',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 48.0, 'GBP', NOW());
    END IF;
    
    -- Product 398 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Regular Set FSPIL3 3 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 47.56, 'GBP', NOW());
    END IF;
    
    -- Product 399 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'high silver (70% Ag) SPIL03 3 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 47.56, 'GBP', NOW());
    END IF;
    
    -- Product 400 (Page 44)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '…003 …013 …023 …033 …043 …203 …213 …006 …007 …016 …017',
        dental_id, cat_id,
        'From catalogue.pdf, page 44'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 47.35, 'GBP', NOW());
    END IF;
    
    -- Product 401 (Page 23)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PICO04 POA MEDICEI10 CEI 10 pack strips',
        dental_id, cat_id,
        'From catalogue.pdf, page 23'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 47.25, 'GBP', NOW());
    END IF;
    
    -- Product 402 (Page 4)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Cones pack of 2 x 0.3cm3 SEPEP01 14g',
        dental_id, cat_id,
        'From catalogue.pdf, page 4'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 45.99, 'GBP', NOW());
    END IF;
    
    -- Product 403 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'with adaptors 1.3mts',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 45.0, 'GBP', NOW());
    END IF;
    
    -- Product 404 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'HC5021W W&H fitting £359.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 45.0, 'GBP', NOW());
    END IF;
    
    -- Product 405 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'unidose complets COM248X2A3.5 Dark Yellow £22.95 shade A3 £57.50',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 45.0, 'GBP', NOW());
    END IF;
    
    -- Product 406 (Page 32)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Large Tray Rack (cheapest) one free DISTIP01 Box of 200 £16.50 MES03 £21.50',
        dental_id, cat_id,
        'From catalogue.pdf, page 32'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 45.0, 'GBP', NOW());
    END IF;
    
    -- Product 407 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'CAT23 11mm £45.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 45.0, 'GBP', NOW());
    END IF;
    
    -- Product 408 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Light Brown/Dark Yellow (CERK7)',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 45.0, 'GBP', NOW());
    END IF;
    
    -- Product 409 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'LSPIL1 Lojic+1 Spill x 50 £44.52 PSPIL1 1 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 44.52, 'GBP', NOW());
    END IF;
    
    -- Product 410 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'LSPIL1 Lojic+1 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 44.52, 'GBP', NOW());
    END IF;
    
    -- Product 411 (Page 5)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'No.2 paste BLLEDRP01 5g',
        dental_id, cat_id,
        'From catalogue.pdf, page 5'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 44.5, 'GBP', NOW());
    END IF;
    
    -- Product 412 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TITANTP Perio tip',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 42.5, 'GBP', NOW());
    END IF;
    
    -- Product 413 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Universal TITANTU Universal tip',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 42.5, 'GBP', NOW());
    END IF;
    
    -- Product 414 (Page 44)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Refill of 12 Pcs',
        dental_id, cat_id,
        'From catalogue.pdf, page 44'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 42.5, 'GBP', NOW());
    END IF;
    
    -- Product 415 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TITANTS Sickle tip',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 42.5, 'GBP', NOW());
    END IF;
    
    -- Product 416 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SHS-EC Handpiece',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 42.5, 'GBP', NOW());
    END IF;
    
    -- Product 417 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Kind to pulp, bonds to tooth only FUJI_ _ Only',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 41.6, 'GBP', NOW());
    END IF;
    
    -- Product 418 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'FUJI PLUS02 powder yellow 15g inlays and crowns. Riva Luting Plus',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 41.49, 'GBP', NOW());
    END IF;
    
    -- Product 419 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ULTC3 3 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 41.41, 'GBP', NOW());
    END IF;
    
    -- Product 420 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '2 KITS £42.75 each Ceramcore B silver',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 41.4, 'GBP', NOW());
    END IF;
    
    -- Product 421 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SSPIL2 2 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 41.39, 'GBP', NOW());
    END IF;
    
    -- Product 422 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RIVASIL01 £69.75',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.5, 'GBP', NOW());
    END IF;
    
    -- Product 423 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ART25INS04 £40.00 ART25INS05',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 424 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Satelec compatible tips New ART-M3II 25k Pro Multi-Functional',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 425 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ART30INS04 £40.00 ART30INS05',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 426 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Discounts availablewhen purchasing instruments as follows:',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 427 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS38 £2.90 BDS319 £12.95 BDS337 £12.95 BDS359 £12.95',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 428 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ART25INS01 £40.00 ART25INS03',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 429 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ARTTIPE3 £30.00 25K UNIVERSAL INSERT 25K SLIM INSERT',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 430 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'motor. Unit supplied with 2 universal CAV25KTB',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 431 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ARTM3II25K (25k) £495.00 CAV30KTB £40.00 ART30INS02',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 432 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'EMS compatible tips system with built in water reservoir and',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 433 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ARTM3II25K (25k) £495.00 CAV30KTB',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 434 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'motor. Unit supplied with 2 universal CAV25KTB £40.00 ART25INS02',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 435 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ELDENT01 £399.00 ARTSPA30K £40.00 ARTENDO120',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 436 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ELDENT01 £399.00 ARTSPA30K',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 437 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '30K UNIVERSAL INSERT 30K SLIM INSERT',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 438 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ART30INS01 £40.00 ART30INS03',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 439 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'worktop footprint. ARTSPA25K',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 40.0, 'GBP', NOW());
    END IF;
    
    -- Product 440 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ALP001 BRS full starter kit £99.50 LXC-12V01 £260.00 ANTH05',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 39.95, 'GBP', NOW());
    END IF;
    
    -- Product 441 (Page 32)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Red, 04 Green, 05 Yellow 6 + MINI £2.80 each (Includes 2 Free Tips)',
        dental_id, cat_id,
        'From catalogue.pdf, page 32'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 39.95, 'GBP', NOW());
    END IF;
    
    -- Product 442 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Data Sheets LXC-12V02 £330.00 MX2-LED £620.25 ANTH04',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 39.95, 'GBP', NOW());
    END IF;
    
    -- Product 443 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'IMPP02 Regular set',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 39.95, 'GBP', NOW());
    END IF;
    
    -- Product 444 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ALP006 Dip Slide Pack 10',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 39.95, 'GBP', NOW());
    END IF;
    
    -- Product 445 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Non-gamma 2 amalgam alloy SPIL02 2 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 39.88, 'GBP', NOW());
    END IF;
    
    -- Product 446 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Ultracaps+ FSPIL2 2 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 39.88, 'GBP', NOW());
    END IF;
    
    -- Product 447 (Page 48)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'WABF01 £15.50 DISPO01',
        dental_id, cat_id,
        'From catalogue.pdf, page 48'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 39.6, 'GBP', NOW());
    END IF;
    
    -- Product 448 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'and accessories.',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 39.5, 'GBP', NOW());
    END IF;
    
    -- Product 449 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'chemical and thermal changes',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 39.5, 'GBP', NOW());
    END IF;
    
    -- Product 450 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'and accessories. POLAN16',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 39.5, 'GBP', NOW());
    END IF;
    
    -- Product 451 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '3% Kit • High viscosity, spearmint flavoured gel • 0.11% fluoride ions Buy 10 for £14.95 each',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 39.5, 'GBP', NOW());
    END IF;
    
    -- Product 452 (Page 47)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '3 x 500ml assorted',
        dental_id, cat_id,
        'From catalogue.pdf, page 47'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 39.0, 'GBP', NOW());
    END IF;
    
    -- Product 453 (Page 32)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Small Tray Rack SSCB5 Blue £14.50 Disposable 3 IN 1 Tips Monoject 3cc endodontic syringes with',
        dental_id, cat_id,
        'From catalogue.pdf, page 32'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 39.0, 'GBP', NOW());
    END IF;
    
    -- Product 454 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Wave mv, Wave hv ICE + SHADE COMP',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 37.92, 'GBP', NOW());
    END IF;
    
    -- Product 455 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Hydrogen Peroxide 3%. Buy 3 for',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 37.5, 'GBP', NOW());
    END IF;
    
    -- Product 456 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• For producing local or loco-regional DENCSA18 100 x 2.2ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 37.5, 'GBP', NOW());
    END IF;
    
    -- Product 457 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ALP002 Alpron 1L refill',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 37.5, 'GBP', NOW());
    END IF;
    
    -- Product 458 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Rapid on-set DENC18 100 x 2.2ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 37.5, 'GBP', NOW());
    END IF;
    
    -- Product 459 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Assortment, one of each number. Dark Medium RDR01 £7.95 AFFW02 Affinis wash fast 5 rate £4.55',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 37.0, 'GBP', NOW());
    END IF;
    
    -- Product 460 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Wave mv, Wave hv ICE + SHADE COMP £37.92',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 36.56, 'GBP', NOW());
    END IF;
    
    -- Product 461 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Procedures in upper jaw: 10 RATE',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 36.5, 'GBP', NOW());
    END IF;
    
    -- Product 462 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Buy any 3 of the above for',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 36.0, 'GBP', NOW());
    END IF;
    
    -- Product 463 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ULTC2 2 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 35.64, 'GBP', NOW());
    END IF;
    
    -- Product 464 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ULTCF2 2 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 35.64, 'GBP', NOW());
    END IF;
    
    -- Product 465 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'A light cured hybrid fluoride releasing',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 35.09, 'GBP', NOW());
    END IF;
    
    -- Product 466 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'release, tooth coloured, Radiopaque. FUJLC',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 35.07, 'GBP', NOW());
    END IF;
    
    -- Product 467 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'GK2 Interproximal',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 35.0, 'GBP', NOW());
    END IF;
    
    -- Product 468 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'punch, holder and 5 clamps. A dark blue A silicone putty. 300ml IMPTIP04 Blue £13.75',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 35.0, 'GBP', NOW());
    END IF;
    
    -- Product 469 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'GK4 Longer tip Perio',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 35.0, 'GBP', NOW());
    END IF;
    
    -- Product 470 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'kit alone £59.50 Motor Only ANTH07',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 34.95, 'GBP', NOW());
    END IF;
    
    -- Product 471 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ALP003 Alpron 5L refill £149.50 LXC-125 £156.20 ANTH06',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 34.95, 'GBP', NOW());
    END IF;
    
    -- Product 472 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '3 tier basket tray system 240 x 170 x',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 34.95, 'GBP', NOW());
    END IF;
    
    -- Product 473 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ALP006 Dip Slide Pack 10 £39.95 LB-20EM (Din) £129.80 MCX-LED £561.00 ANTH08',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 34.95, 'GBP', NOW());
    END IF;
    
    -- Product 474 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'EC-30FGP EH-30TL',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 34.65, 'GBP', NOW());
    END IF;
    
    -- Product 475 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Riva Light Cure AMALGA2',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 33.5, 'GBP', NOW());
    END IF;
    
    -- Product 476 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'A light cured, resin-',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 33.5, 'GBP', NOW());
    END IF;
    
    -- Product 477 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Riva Light Cure AMALGA2 £33.50',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 33.5, 'GBP', NOW());
    END IF;
    
    -- Product 478 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SSPIL1 1 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 33.47, 'GBP', NOW());
    END IF;
    
    -- Product 479 (Page 51)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'speed 150 films size 2',
        dental_id, cat_id,
        'From catalogue.pdf, page 51'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 32.99, 'GBP', NOW());
    END IF;
    
    -- Product 480 (Page 47)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '20% chlorhexidine mouthwash Sosoft. Cotton Wool Rolls - DC02 All for',
        dental_id, cat_id,
        'From catalogue.pdf, page 47'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 32.99, 'GBP', NOW());
    END IF;
    
    -- Product 481 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RBDC _ _ _ £3.75 exceeding 118°C (224°F). regular body 6611',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 32.95, 'GBP', NOW());
    END IF;
    
    -- Product 482 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RBDCKIT £37.00 Light Medium RDR02 £7.95 light body 6601',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 32.95, 'GBP', NOW());
    END IF;
    
    -- Product 483 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'FSPIL1 1 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 31.85, 'GBP', NOW());
    END IF;
    
    -- Product 484 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Good corrosion resistance SPIL01 1 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 31.85, 'GBP', NOW());
    END IF;
    
    -- Product 485 (Page 4)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'fluoride gel. 4 x 1.2ml syringes.',
        dental_id, cat_id,
        'From catalogue.pdf, page 4'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 31.5, 'GBP', NOW());
    END IF;
    
    -- Product 486 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'POLAD6 £39.50 Standard kit',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 31.5, 'GBP', NOW());
    END IF;
    
    -- Product 487 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'AIRSCALE03 Universal tip',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 31.25, 'GBP', NOW());
    END IF;
    
    -- Product 488 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'AIRSCALE04 Sickle tip',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 31.25, 'GBP', NOW());
    END IF;
    
    -- Product 489 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'AIRSCALE05 Perio tip',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 31.25, 'GBP', NOW());
    END IF;
    
    -- Product 490 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'HFP _ _ _ £22.95 RIVAAPP',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 31.0, 'GBP', NOW());
    END IF;
    
    -- Product 491 (Page 23)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PICO Pioneer AUTO01SEAL1 each',
        dental_id, cat_id,
        'From catalogue.pdf, page 23'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.6, 'GBP', NOW());
    END IF;
    
    -- Product 492 (Page 53)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'POLAOFF61 rrp £36.44',
        dental_id, cat_id,
        'From catalogue.pdf, page 53'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.5, 'GBP', NOW());
    END IF;
    
    -- Product 493 (Page 23)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '4 x 25 pack £195.00 AWT01 2 x 0.5L',
        dental_id, cat_id,
        'From catalogue.pdf, page 23'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.45, 'GBP', NOW());
    END IF;
    
    -- Product 494 (Page 48)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'WrapAround provides a mechanical Size 2 (30x40) Box 300',
        dental_id, cat_id,
        'From catalogue.pdf, page 48'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 495 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'As above but with LED handpiece handpiece hypochlorite via the water bottle system WOOD15 EMS',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 496 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'WOOD22 Satelec and NSK',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 497 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Replacement Tip PLP01 £7.95',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 498 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Interproximal recommended for the WOOD20 Satelec',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 499 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'WOOD24 Satelec and NSK',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 500 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SATHPKIT £210.00 WOOD18 DTE-D7 £399.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 501 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'WOOD28 £349.00 WOOD04 EMS',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 502 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Detachable autoclavable handpiece WOOD25 Satelec and NSK',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 503 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ARTMB325K £399.00 flat and tip changer scaler. WOOD32 Satelec and NSK',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 504 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'JJJaaapppaaannn... (((222))) DDDrrr GGGrrreeeggg MMMoooooorrreee,,, QQQuuueeeeeennnssslllaaannnddd,,, AAAuuussstttrrraaallliiiaaa... (((333))) DDDrrr PPPhhhiiillliiippp CCCaaasssaaannn,,, VVVictoria, Australia. Buy any 100 for only',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 505 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PROP600B2 £195.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 506 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• EMS style handpiece WOOD13 EMS',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 507 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SATP5NEWLED £1263.20 • Vibration frequency 28kHz WOOD23 Satelec and NSK',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 508 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'motor. Unit supplied with 2 universal CAV25KTB £40.00 ART25INS02 £40.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 509 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'WOOD34 Satelec and NSK',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 510 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ART25INS04 £40.00 ART25INS05 £40.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 511 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Satelec compatible tips',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 512 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'autoclavable box tips: 2 universal, 1 flat chisel, 1 round Compatible with Woodpecker and EMS WOOD09 EMS',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 513 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Wireless foot control, German infusion',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 514 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'the neck of the tooth.',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 515 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'EMS compatible tips',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 516 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ART30INS04 £40.00 ART30INS05 £40.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 30.0, 'GBP', NOW());
    END IF;
    
    -- Product 517 (Page 43)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SOF-LEXpop on disc refills',
        dental_id, cat_id,
        'From catalogue.pdf, page 43'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 29.95, 'GBP', NOW());
    END IF;
    
    -- Product 518 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'temporary filling. KLZ03 40g Powder £6.99 BOND701 5ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 29.95, 'GBP', NOW());
    END IF;
    
    -- Product 519 (Page 44)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '…201 …202 …211 …212 60 assorted',
        dental_id, cat_id,
        'From catalogue.pdf, page 44'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 29.95, 'GBP', NOW());
    END IF;
    
    -- Product 520 (Page 44)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Kit of 60 assorted crown forms 1 Green, 2 Yellow, 3 Orange, 4 Blue Aluminium Shell Crowns',
        dental_id, cat_id,
        'From catalogue.pdf, page 44'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 29.95, 'GBP', NOW());
    END IF;
    
    -- Product 521 (Page 48)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Digital X Ray 200mm Width',
        dental_id, cat_id,
        'From catalogue.pdf, page 48'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 29.95, 'GBP', NOW());
    END IF;
    
    -- Product 522 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Natural B2 ICE FCK01',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 29.95, 'GBP', NOW());
    END IF;
    
    -- Product 523 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'OCM01 £19.50 CL01 £11.95 BOND01 6ml + accessories',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 29.5, 'GBP', NOW());
    END IF;
    
    -- Product 524 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'EHN-50PK (for NSK)',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 28.93, 'GBP', NOW());
    END IF;
    
    -- Product 525 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'EHN-50PS (for NSK)',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 28.93, 'GBP', NOW());
    END IF;
    
    -- Product 526 (Page 4)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'KPPENVK250 28pk £1.79 COLDURA01 10ml £28.50 SEPTR4 13ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 4'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 28.89, 'GBP', NOW());
    END IF;
    
    -- Product 527 (Page 4)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'KPPENVK250 28pk £1.79 COLDURA01 10ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 4'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 28.5, 'GBP', NOW());
    END IF;
    
    -- Product 528 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'CERA01 £24.95 AMALGINT £159.00 ordering.',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 28.5, 'GBP', NOW());
    END IF;
    
    -- Product 529 (Page 46)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SCB02 without £1.95 surfaces. 5L',
        dental_id, cat_id,
        'From catalogue.pdf, page 46'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 28.5, 'GBP', NOW());
    END IF;
    
    -- Product 530 (Page 44)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Shell Crown Kit - 84 assorted',
        dental_id, cat_id,
        'From catalogue.pdf, page 44'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 27.95, 'GBP', NOW());
    END IF;
    
    -- Product 531 (Page 47)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'antiseptic mouthwash 2 Ply white. 125 sheets x 18 Rolls. 1 Box Rate £5.95 Wall mounted',
        dental_id, cat_id,
        'From catalogue.pdf, page 47'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 27.95, 'GBP', NOW());
    END IF;
    
    -- Product 532 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'of metal, PFM and resin crowns,',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 27.86, 'GBP', NOW());
    END IF;
    
    -- Product 533 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ULTC1 1 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 27.56, 'GBP', NOW());
    END IF;
    
    -- Product 534 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ULTCF1 1 Spill x 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 27.56, 'GBP', NOW());
    END IF;
    
    -- Product 535 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TITANIUM LINE couplings PTLAD01 Power adaptor',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 27.54, 'GBP', NOW());
    END IF;
    
    -- Product 536 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'go! VCAK01 All for',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 26.99, 'GBP', NOW());
    END IF;
    
    -- Product 537 (Page 47)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Box of 1000 Rolls.',
        dental_id, cat_id,
        'From catalogue.pdf, page 47'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 26.95, 'GBP', NOW());
    END IF;
    
    -- Product 538 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Shades A2, A3.5 Box 50 Radiopaque. Acid etchable. Excellent',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 26.95, 'GBP', NOW());
    END IF;
    
    -- Product 539 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ROK + SHADE all at',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 26.34, 'GBP', NOW());
    END IF;
    
    -- Product 540 (Page 44)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'L/ANTS SHORT 65 66 67 68 69 - - FPD02A 100 pack Green',
        dental_id, cat_id,
        'From catalogue.pdf, page 44'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 26.3, 'GBP', NOW());
    END IF;
    
    -- Product 541 (Page 44)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'L/ANTS LONG 60 61 62 63 64 - - FPD02 100 pack Blue',
        dental_id, cat_id,
        'From catalogue.pdf, page 44'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 26.3, 'GBP', NOW());
    END IF;
    
    -- Product 542 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '3 Ball Bearing EHN-20L (for NSK)',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 26.04, 'GBP', NOW());
    END IF;
    
    -- Product 543 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Connects Borden handpieces to Mid FBRO01',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 25.58, 'GBP', NOW());
    END IF;
    
    -- Product 544 (Page 10)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ADAPT01 B to MW £39.95 FBRO02',
        dental_id, cat_id,
        'From catalogue.pdf, page 10'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 25.58, 'GBP', NOW());
    END IF;
    
    -- Product 545 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ROK + SHADE all at £26.34 microfilled hybrid composite. Designed',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 25.28, 'GBP', NOW());
    END IF;
    
    -- Product 546 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Buy any 3 tips below',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 25.0, 'GBP', NOW());
    END IF;
    
    -- Product 547 (Page 16)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ULTRASONIC PIEZO STYLE SCALERS Buy any 3 tips below',
        dental_id, cat_id,
        'From catalogue.pdf, page 16'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 25.0, 'GBP', NOW());
    END IF;
    
    -- Product 548 (Page 45)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'DA02 blue £7.95 BLHOG02 Ladies blue',
        dental_id, cat_id,
        'From catalogue.pdf, page 45'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.95, 'GBP', NOW());
    END IF;
    
    -- Product 549 (Page 45)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BLHOG05 Gents blue',
        dental_id, cat_id,
        'From catalogue.pdf, page 45'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.95, 'GBP', NOW());
    END IF;
    
    -- Product 550 (Page 44)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Temporary Crowns FPS02',
        dental_id, cat_id,
        'From catalogue.pdf, page 44'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.95, 'GBP', NOW());
    END IF;
    
    -- Product 551 (Page 45)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'DA01 white £7.95 BLHOH01 Ladies black',
        dental_id, cat_id,
        'From catalogue.pdf, page 45'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.95, 'GBP', NOW());
    END IF;
    
    -- Product 552 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '10g Powder & 6ml liquid conditioner 5ml varnish bottles & scoops code CERS_ _ _ then shade when',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.95, 'GBP', NOW());
    END IF;
    
    -- Product 553 (Page 45)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BLHOG07 Childs blue',
        dental_id, cat_id,
        'From catalogue.pdf, page 45'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.95, 'GBP', NOW());
    END IF;
    
    -- Product 554 (Page 45)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '5 Rate £6.95 BLHOG03 Ladies pink',
        dental_id, cat_id,
        'From catalogue.pdf, page 45'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.95, 'GBP', NOW());
    END IF;
    
    -- Product 555 (Page 45)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BLHOG04 Gents black',
        dental_id, cat_id,
        'From catalogue.pdf, page 45'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.95, 'GBP', NOW());
    END IF;
    
    -- Product 556 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'E-Type straight handpiece 40,000rpm. EH-20L',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.85, 'GBP', NOW());
    END IF;
    
    -- Product 557 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'EC-30BL £109.25 EH-50PK',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.85, 'GBP', NOW());
    END IF;
    
    -- Product 558 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ME-20BPKIT £378.50 contra EH-50PS',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.85, 'GBP', NOW());
    END IF;
    
    -- Product 559 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Hydrogen Peroxide 3%. Buy 3 for £20.00 each',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.25, 'GBP', NOW());
    END IF;
    
    -- Product 560 (Page 5)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'No.3 powder BLLEDP3 3g',
        dental_id, cat_id,
        'From catalogue.pdf, page 5'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.25, 'GBP', NOW());
    END IF;
    
    -- Product 561 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Buy 3 at £25.28 for both anterior and posterior',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.23, 'GBP', NOW());
    END IF;
    
    -- Product 562 (Page 22)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BEWALL01 £1850.00 Fimet package. CAT22 16mm',
        dental_id, cat_id,
        'From catalogue.pdf, page 22'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.0, 'GBP', NOW());
    END IF;
    
    -- Product 563 (Page 15)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Available for NSK, KaVo, W&H, Bien',
        dental_id, cat_id,
        'From catalogue.pdf, page 15'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.0, 'GBP', NOW());
    END IF;
    
    -- Product 564 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'with adaptors 1.3mts',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.0, 'GBP', NOW());
    END IF;
    
    -- Product 565 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Item 15 10 packs for',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.0, 'GBP', NOW());
    END IF;
    
    -- Product 566 (Page 22)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Wall mounted version Fimet mobile cart available as part of a CAT21 11mm',
        dental_id, cat_id,
        'From catalogue.pdf, page 22'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.0, 'GBP', NOW());
    END IF;
    
    -- Product 567 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '£21.00 £11.95 10 packs for',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.0, 'GBP', NOW());
    END IF;
    
    -- Product 568 (Page 48)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'WABF01 £15.50 DISPO01 £39.60 Size 4 (54x75) Bbox 100',
        dental_id, cat_id,
        'From catalogue.pdf, page 48'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.0, 'GBP', NOW());
    END IF;
    
    -- Product 569 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'CAT21 11mm £24.00 Item 14',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 24.0, 'GBP', NOW());
    END IF;
    
    -- Product 570 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ICE + SHADE all at',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 23.97, 'GBP', NOW());
    END IF;
    
    -- Product 571 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'bulk prices on NACYC01',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 23.7, 'GBP', NOW());
    END IF;
    
    -- Product 572 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Assorted box of 50 contains 10 of each CERI01',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 23.7, 'GBP', NOW());
    END IF;
    
    -- Product 573 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RIVAFS _ _ (shade) £64.50 • Shades A2, A3, A3.5 in 12gm hand CRMM01 All for',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 23.5, 'GBP', NOW());
    END IF;
    
    -- Product 574 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Specially designed walls for extra Mercury 500gm Bottle',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 23.5, 'GBP', NOW());
    END IF;
    
    -- Product 575 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Contains: 50 x 1.3g Pola Day syringes 16% Kit 1 or 2 x 30 min/day OR',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 23.25, 'GBP', NOW());
    END IF;
    
    -- Product 576 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ICE + SHADE all at £23.97',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 23.16, 'GBP', NOW());
    END IF;
    
    -- Product 577 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Shades A1, A2, A3.5, B2, C3 applicator. Box 50 pulp.',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 578 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS373 £12.95 LX3C',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 579 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS364 £12.95 BDS374 £12.95 LX3CA £22.95 LX3S',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 580 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS364 £12.95 BDS374 £12.95 LX3CA',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 581 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS375 £12.95 LX1C £22.95 LX5S',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 582 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS375 £12.95 LX1C',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 583 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'anaesthesia SEPPH01 150ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 584 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS373 £12.95 LX3C £22.95 LX5C',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 585 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Childs Upper Incisor Canines 37 LX2S £22.95 LX1S',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 586 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Childs Upper Incisor Canines 37 LX2S',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 587 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'COM248X2A2 Light Yellow',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 588 (Page 45)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '10 Box Rate £4.50 chains. Size 33 x 48cm. small medium large. Frame and 6 shields',
        dental_id, cat_id,
        'From catalogue.pdf, page 45'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 589 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'unidose complets COM248X2A3.5 Dark Yellow',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 590 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Strongly engineered applicator for all COM248X2A3 Universal',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 591 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SDI Applicator COM248X2A1 Light',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.95, 'GBP', NOW());
    END IF;
    
    -- Product 592 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '2 or 4 hole EC-50PK SHS-EG Handpiece £65.00 handpiece',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.85, 'GBP', NOW());
    END IF;
    
    -- Product 593 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Hydrogen Peroxide 3%. Buy 3 for £37.50 each',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.75, 'GBP', NOW());
    END IF;
    
    -- Product 594 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'and accessories. POLANM16',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.75, 'GBP', NOW());
    END IF;
    
    -- Product 595 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Bulk kit Poladay 6%',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.75, 'GBP', NOW());
    END IF;
    
    -- Product 596 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '2 or 3 x 30 min/day OR',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.75, 'GBP', NOW());
    END IF;
    
    -- Product 597 (Page 51)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'machines. 36 tablets. 12 x 12 (red/blue).',
        dental_id, cat_id,
        'From catalogue.pdf, page 51'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.5, 'GBP', NOW());
    END IF;
    
    -- Product 598 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TB404 Anterior SBSPIL2 2 Spill x 500 £359.29 ETCH04 50ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.5, 'GBP', NOW());
    END IF;
    
    -- Product 599 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RIVARS _ _ (shade) £64.50 thermal conductivity problems CART01',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.5, 'GBP', NOW());
    END IF;
    
    -- Product 600 (Page 8)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'bulk prices on NACYC01 £23.70 significantly extend the life of the',
        dental_id, cat_id,
        'From catalogue.pdf, page 8'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 22.22, 'GBP', NOW());
    END IF;
    
    -- Product 601 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'OCM01 £19.50 CL01 £11.95 BOND01 6ml + accessories £29.50 ENA02',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 21.95, 'GBP', NOW());
    END IF;
    
    -- Product 602 (Page 31)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SPEN01 £6.00 Bite Gauge mirror',
        dental_id, cat_id,
        'From catalogue.pdf, page 31'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 21.8, 'GBP', NOW());
    END IF;
    
    -- Product 603 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Septoject SEPXG01 15g Tube £3.79',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 21.5, 'GBP', NOW());
    END IF;
    
    -- Product 604 (Page 32)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Large Tray Rack (cheapest) one free DISTIP01 Box of 200 £16.50 MES03',
        dental_id, cat_id,
        'From catalogue.pdf, page 32'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 21.5, 'GBP', NOW());
    END IF;
    
    -- Product 605 (Page 24)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Sterilizing temp 134° to 138° for light SELEBU',
        dental_id, cat_id,
        'From catalogue.pdf, page 24'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 21.5, 'GBP', NOW());
    END IF;
    
    -- Product 606 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SEPTUSP30S 30g Short',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 21.5, 'GBP', NOW());
    END IF;
    
    -- Product 607 (Page 32)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '5 instruments 18.0 x 8.5 x 1.5cm',
        dental_id, cat_id,
        'From catalogue.pdf, page 32'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 21.5, 'GBP', NOW());
    END IF;
    
    -- Product 608 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'crowns bridges and splints.',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 21.5, 'GBP', NOW());
    END IF;
    
    -- Product 609 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Scandonest 3% Plain SEPTUSP27L 27g Long',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 21.5, 'GBP', NOW());
    END IF;
    
    -- Product 610 (Page 14)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• 10 preset options PANASPRAY 500ml can',
        dental_id, cat_id,
        'From catalogue.pdf, page 14'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 21.24, 'GBP', NOW());
    END IF;
    
    -- Product 611 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Pack of 3 Surgical Tip. Pack of 3 MAT01 Bags of 100 £2.55 Sterile black braided silk, box of 12 (577)',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 21.0, 'GBP', NOW());
    END IF;
    
    -- Product 612 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'HFP _ _ _ £22.95 RIVAAPP £31.00 RIVAPRO02 £68.49 CRMB01',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 21.0, 'GBP', NOW());
    END IF;
    
    -- Product 613 (Page 51)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'E-Speed Film XRD02',
        dental_id, cat_id,
        'From catalogue.pdf, page 51'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 20.95, 'GBP', NOW());
    END IF;
    
    -- Product 614 (Page 51)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Flexible, soft adult periapical X-Ray film 2 Rate £19.50',
        dental_id, cat_id,
        'From catalogue.pdf, page 51'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 20.95, 'GBP', NOW());
    END IF;
    
    -- Product 615 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Without Modifier',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 20.95, 'GBP', NOW());
    END IF;
    
    -- Product 616 (Page 30)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS113 £2.90 BDS08 £1.60 BDS251 £2.90 KIT-HY',
        dental_id, cat_id,
        'From catalogue.pdf, page 30'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 20.95, 'GBP', NOW());
    END IF;
    
    -- Product 617 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SEPLS22 50 x 2.2ml £18.95 SEPS1222 50 x 2.2ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 20.5, 'GBP', NOW());
    END IF;
    
    -- Product 618 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Rapid on-set SEPS1122 50 x 2.2ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 20.5, 'GBP', NOW());
    END IF;
    
    -- Product 619 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'CMS01 £19.50 FUJICON',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 20.06, 'GBP', NOW());
    END IF;
    
    -- Product 620 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Hydrogen Peroxide 3%. Buy 3 for',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 20.0, 'GBP', NOW());
    END IF;
    
    -- Product 621 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'and a pack of 6 carbon sachets valued Menu-driven LCD control panel STERILISATION POUCH',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 20.0, 'GBP', NOW());
    END IF;
    
    -- Product 622 (Page 47)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '1 Ply white. 60mtr x 12 Rolls.',
        dental_id, cat_id,
        'From catalogue.pdf, page 47'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 20.0, 'GBP', NOW());
    END IF;
    
    -- Product 623 (Page 6)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ME-80M 4 HOLE £200.57 Sealed Prophy Snap-on 16:1 Reduction Shank for BDSI',
        dental_id, cat_id,
        'From catalogue.pdf, page 6'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.99, 'GBP', NOW());
    END IF;
    
    -- Product 624 (Page 41)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '4 x 541, 4 x 542, 4 x 554, 4 x 556 • Size 3 £2.40 ICSB03',
        dental_id, cat_id,
        'From catalogue.pdf, page 41'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.95, 'GBP', NOW());
    END IF;
    
    -- Product 625 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Surgical Tip ASPI01 2L',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.95, 'GBP', NOW());
    END IF;
    
    -- Product 626 (Page 32)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'DMNTR01 £45.00 5 Rate £15 5 Rate',
        dental_id, cat_id,
        'From catalogue.pdf, page 32'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.95, 'GBP', NOW());
    END IF;
    
    -- Product 627 (Page 51)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'offers superb quality, is easy to work XRF01',
        dental_id, cat_id,
        'From catalogue.pdf, page 51'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.95, 'GBP', NOW());
    END IF;
    
    -- Product 628 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'mv is medium and Wave hv is high. PASTE02',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.95, 'GBP', NOW());
    END IF;
    
    -- Product 629 (Page 32)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SSCG5 Green £14.50',
        dental_id, cat_id,
        'From catalogue.pdf, page 32'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.95, 'GBP', NOW());
    END IF;
    
    -- Product 630 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'NE (Eugenol Free)',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.95, 'GBP', NOW());
    END IF;
    
    -- Product 631 (Page 48)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Large Tubing Covers 457mm x 53mm XRHC01 pack 250',
        dental_id, cat_id,
        'From catalogue.pdf, page 48'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.95, 'GBP', NOW());
    END IF;
    
    -- Product 632 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'rates HC2001B borden fitting £219.00 QDJKB01 Halogen',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.95, 'GBP', NOW());
    END IF;
    
    -- Product 633 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '10 RATE £17.95 10 RATE',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.5, 'GBP', NOW());
    END IF;
    
    -- Product 634 (Page 51)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Intra-oral x-ray films with the 2 Rate',
        dental_id, cat_id,
        'From catalogue.pdf, page 51'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.5, 'GBP', NOW());
    END IF;
    
    -- Product 635 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'working characteristics. 7g syringe cavities Dentine Bond Kit',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.5, 'GBP', NOW());
    END IF;
    
    -- Product 636 (Page 51)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Flexible, soft adult periapical X-Ray film 2 Rate',
        dental_id, cat_id,
        'From catalogue.pdf, page 51'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.5, 'GBP', NOW());
    END IF;
    
    -- Product 637 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '30g Powder Kit. FUJI Light cured conditioner 25g SET_ _ (Shade) box of 50 £129.00 self curing, glass ionomer luting',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.5, 'GBP', NOW());
    END IF;
    
    -- Product 638 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'CMS01 £19.50 FUJICON £20.06 Assorted box of 50 contains 10 of each cement, designed for final cementation',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.0, 'GBP', NOW());
    END IF;
    
    -- Product 639 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'temporary filling. KLZ03 40g Powder £6.99 BOND701 5ml £29.95 BEST',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 19.0, 'GBP', NOW());
    END IF;
    
    -- Product 640 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '1 - 4 minutes SEPXS01 36g',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 18.99, 'GBP', NOW());
    END IF;
    
    -- Product 641 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SEPLS22 50 x 2.2ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 18.95, 'GBP', NOW());
    END IF;
    
    -- Product 642 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SEPSS22 50 x 2.2ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 18.95, 'GBP', NOW());
    END IF;
    
    -- Product 643 (Page 39)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Setting time of only 2.5 minutes Box 50 Ideal for lining dentinal wall of cavities',
        dental_id, cat_id,
        'From catalogue.pdf, page 39'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 18.95, 'GBP', NOW());
    END IF;
    
    -- Product 644 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'AVAILABLE IN 14 SHADES 3 rate',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 18.95, 'GBP', NOW());
    END IF;
    
    -- Product 645 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SEPSP22 50 x 2.2ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 18.95, 'GBP', NOW());
    END IF;
    
    -- Product 646 (Page 4)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'A derivative of Penicillin with a wider KPIBU20084 84pk £1.99 VOPV01 10ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 4'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 18.95, 'GBP', NOW());
    END IF;
    
    -- Product 647 (Page 51)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'with, is soft and comfortable for the 2 Rate',
        dental_id, cat_id,
        'From catalogue.pdf, page 51'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 18.5, 'GBP', NOW());
    END IF;
    
    -- Product 648 (Page 42)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'CPBS03 (6 FG 6 RA burs) £5.95 TC_ _ _(HP) 701 702 –',
        dental_id, cat_id,
        'From catalogue.pdf, page 42'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 18.5, 'GBP', NOW());
    END IF;
    
    -- Product 649 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'luting cement for cementation of',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 18.5, 'GBP', NOW());
    END IF;
    
    -- Product 650 (Page 47)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '7oz squat cups. Box of 2000.',
        dental_id, cat_id,
        'From catalogue.pdf, page 47'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 18.25, 'GBP', NOW());
    END IF;
    
    -- Product 651 (Page 47)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Spearmint Flavour HT01 23 x 33cm',
        dental_id, cat_id,
        'From catalogue.pdf, page 47'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 18.0, 'GBP', NOW());
    END IF;
    
    -- Product 652 (Page 43)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BBS01N £15.50 BBSN01',
        dental_id, cat_id,
        'From catalogue.pdf, page 43'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 18.0, 'GBP', NOW());
    END IF;
    
    -- Product 653 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SEPSS22 50 x 2.2ml £18.95',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.95, 'GBP', NOW());
    END IF;
    
    -- Product 654 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'KLZ02 15ml Liquid',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.95, 'GBP', NOW());
    END IF;
    
    -- Product 655 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'reg. set light body yellow',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.95, 'GBP', NOW());
    END IF;
    
    -- Product 656 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'reg. set medium body buff',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.95, 'GBP', NOW());
    END IF;
    
    -- Product 657 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'fast set light body yellow',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.95, 'GBP', NOW());
    END IF;
    
    -- Product 658 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'fast set medium body buff',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.95, 'GBP', NOW());
    END IF;
    
    -- Product 659 (Page 47)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RT01 £27.95 10 Box Rate £5.85 DCH001',
        dental_id, cat_id,
        'From catalogue.pdf, page 47'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.95, 'GBP', NOW());
    END IF;
    
    -- Product 660 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Buy 5 @ £14.00 each',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.95, 'GBP', NOW());
    END IF;
    
    -- Product 661 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'A1.A2,A3,A3.5,B1,B2,B3,C2,C3,D3,',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.95, 'GBP', NOW());
    END IF;
    
    -- Product 662 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SEPLS22 50 x 2.2ml £18.95 SEPS1222 50 x 2.2ml £20.50 before anaesthetic injection',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.95, 'GBP', NOW());
    END IF;
    
    -- Product 663 (Page 46)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '6 Rate £6.29 6 Rate £2.39 SURFD01 5ltr',
        dental_id, cat_id,
        'From catalogue.pdf, page 46'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.9, 'GBP', NOW());
    END IF;
    
    -- Product 664 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'JJJaaapppaaannn... (((222))) DDDrrr GGGrrreeeggg MMMoooooorrreee,,, QQQuuueeeeeennnssslllaaannnddd,,, AAAuuussstttrrraaallliiiaaa... (((333))) DDDrrr PPPhhhiiillliiippp CCCaaasssaaannn,,, VVVictoria, Australia. Buy any 100 for only £30.00 POLAP02',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.8, 'GBP', NOW());
    END IF;
    
    -- Product 665 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Light Brown (CERK6)',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.75, 'GBP', NOW());
    END IF;
    
    -- Product 666 (Page 45)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '20 Box Rate £4.30 DISPAPR01 Box 500',
        dental_id, cat_id,
        'From catalogue.pdf, page 45'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.5, 'GBP', NOW());
    END IF;
    
    -- Product 667 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'STERI01 16mm tips £14.75',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.5, 'GBP', NOW());
    END IF;
    
    -- Product 668 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Standard kit • Neutral pH and desensitizing releasing desensitizing gel POLAP',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.25, 'GBP', NOW());
    END IF;
    
    -- Product 669 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'AVAILABLE IN 14 SHADES 3 rate £18.95 each FS02 Opaque',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.0, 'GBP', NOW());
    END IF;
    
    -- Product 670 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'mv is medium and Wave hv is high. PASTE02 £19.95 FS01 Clear',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.0, 'GBP', NOW());
    END IF;
    
    -- Product 671 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'lining material.',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 17.0, 'GBP', NOW());
    END IF;
    
    -- Product 672 (Page 33)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'NITI6%__ £12.99 NITI__',
        dental_id, cat_id,
        'From catalogue.pdf, page 33'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.99, 'GBP', NOW());
    END IF;
    
    -- Product 673 (Page 32)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SCH01 £1.95 END01',
        dental_id, cat_id,
        'From catalogue.pdf, page 32'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.99, 'GBP', NOW());
    END IF;
    
    -- Product 674 (Page 51)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Box of 2000 Envelopes. TRANS02 6mm £4.25',
        dental_id, cat_id,
        'From catalogue.pdf, page 51'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.95, 'GBP', NOW());
    END IF;
    
    -- Product 675 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Foot speed controller ANTH02',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.95, 'GBP', NOW());
    END IF;
    
    -- Product 676 (Page 4)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'KPPENVK250 28pk £1.79 COLDURA01 10ml £28.50 SEPTR4 13ml £28.89 SEPPARSH03 250ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 4'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.95, 'GBP', NOW());
    END IF;
    
    -- Product 677 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'KLZ01 40g Powder',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.95, 'GBP', NOW());
    END IF;
    
    -- Product 678 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SAPAS01 Guard x 4 £10.29 SPECBPS01 50ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.95, 'GBP', NOW());
    END IF;
    
    -- Product 679 (Page 18)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• 4000-20000 rpm ANTH03',
        dental_id, cat_id,
        'From catalogue.pdf, page 18'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.95, 'GBP', NOW());
    END IF;
    
    -- Product 680 (Page 32)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Large Tray Rack (cheapest) one free DISTIP01 Box of 200',
        dental_id, cat_id,
        'From catalogue.pdf, page 32'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.5, 'GBP', NOW());
    END IF;
    
    -- Product 681 (Page 48)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'touched during clinical procedures. Tape for light handles, control panels Size 3 (27x54) Box 100',
        dental_id, cat_id,
        'From catalogue.pdf, page 48'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.5, 'GBP', NOW());
    END IF;
    
    -- Product 682 (Page 35)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'POLYTU01 Medium blue',
        dental_id, cat_id,
        'From catalogue.pdf, page 35'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.21, 'GBP', NOW());
    END IF;
    
    -- Product 683 (Page 35)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Rigid plastic for greater accuracy POLYTU02 Large yellow',
        dental_id, cat_id,
        'From catalogue.pdf, page 35'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.21, 'GBP', NOW());
    END IF;
    
    -- Product 684 (Page 35)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '20 Rate £6.39 per bag ALB03 bowl & spatula £4.95 POLYTL1 Medium blue',
        dental_id, cat_id,
        'From catalogue.pdf, page 35'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.21, 'GBP', NOW());
    END IF;
    
    -- Product 685 (Page 35)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PLUS GET 1 FREE!! POLYTL2 Large yellow',
        dental_id, cat_id,
        'From catalogue.pdf, page 35'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.21, 'GBP', NOW());
    END IF;
    
    -- Product 686 (Page 35)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '10 Rate £6.69 per bag ALB03 spatula £2.95 POLYTL0 Small green',
        dental_id, cat_id,
        'From catalogue.pdf, page 35'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.21, 'GBP', NOW());
    END IF;
    
    -- Product 687 (Page 35)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'POLYTU0 Small green',
        dental_id, cat_id,
        'From catalogue.pdf, page 35'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.21, 'GBP', NOW());
    END IF;
    
    -- Product 688 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Buy 3 for £136.00 each Contains: 50 x 1.3g Pola Night syringes 2 hrs to overnight',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.0, 'GBP', NOW());
    END IF;
    
    -- Product 689 (Page 7)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Mains Transformer',
        dental_id, cat_id,
        'From catalogue.pdf, page 7'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 16.0, 'GBP', NOW());
    END IF;
    
    -- Product 690 (Page 4)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'KPAM250500 500pk',
        dental_id, cat_id,
        'From catalogue.pdf, page 4'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.95, 'GBP', NOW());
    END IF;
    
    -- Product 691 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'additives to minimize sensitivity • 6% Potassium nitrate Buy 3 for',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.95, 'GBP', NOW());
    END IF;
    
    -- Product 692 (Page 48)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '4" x 6" x 1200mts and switches pack 1000 UNOXSC004',
        dental_id, cat_id,
        'From catalogue.pdf, page 48'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.5, 'GBP', NOW());
    END IF;
    
    -- Product 693 (Page 43)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Soflex Pop On Prophy Paste Latch type - Bag of 100',
        dental_id, cat_id,
        'From catalogue.pdf, page 43'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.5, 'GBP', NOW());
    END IF;
    
    -- Product 694 (Page 43)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Standard 1/2” - 12.7mm BBS01 £15.50 BBL01N',
        dental_id, cat_id,
        'From catalogue.pdf, page 43'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.5, 'GBP', NOW());
    END IF;
    
    -- Product 695 (Page 43)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Pack of 3 250g Jar Mint flavour - excellent',
        dental_id, cat_id,
        'From catalogue.pdf, page 43'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.5, 'GBP', NOW());
    END IF;
    
    -- Product 696 (Page 43)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'end of range Screw type - Bag of 100 Snap on - Bag of 100',
        dental_id, cat_id,
        'From catalogue.pdf, page 43'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.5, 'GBP', NOW());
    END IF;
    
    -- Product 697 (Page 43)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Standard 1/2” - 12.7mm BBS01',
        dental_id, cat_id,
        'From catalogue.pdf, page 43'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.5, 'GBP', NOW());
    END IF;
    
    -- Product 698 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TB401 Posterior GS-80 Spherical NEW- UK manufactured, 40%',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.35, 'GBP', NOW());
    END IF;
    
    -- Product 699 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SSPIL5 5 Spill x 50 £74.26',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.35, 'GBP', NOW());
    END IF;
    
    -- Product 700 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SBSPIL5 5 Spill x 500 £658.87',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.35, 'GBP', NOW());
    END IF;
    
    -- Product 701 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TB404 Anterior SBSPIL2 2 Spill x 500 £359.29 ETCH04 50ml £22.50',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.35, 'GBP', NOW());
    END IF;
    
    -- Product 702 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SSPIL2 2 Spill x 50 £41.39',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.35, 'GBP', NOW());
    END IF;
    
    -- Product 703 (Page 32)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'DMNTR01 £45.00 5 Rate',
        dental_id, cat_id,
        'From catalogue.pdf, page 32'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.0, 'GBP', NOW());
    END IF;
    
    -- Product 704 (Page 37)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '5 rate £17.95 each 4 or more rate',
        dental_id, cat_id,
        'From catalogue.pdf, page 37'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.0, 'GBP', NOW());
    END IF;
    
    -- Product 705 (Page 49)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Dishes POIN04 Superfine',
        dental_id, cat_id,
        'From catalogue.pdf, page 49'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.0, 'GBP', NOW());
    END IF;
    
    -- Product 706 (Page 27)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• 3 Mirror Handles ~ 3 Ball Burnishers & Premolars CSA04 1.8ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 27'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.0, 'GBP', NOW());
    END IF;
    
    -- Product 707 (Page 27)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• 1 Box of Mirror Heads • 349 Lower Incisors, Canines CSA02 2.2ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 27'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.0, 'GBP', NOW());
    END IF;
    
    -- Product 708 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Easy to read LCD display shows',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.0, 'GBP', NOW());
    END IF;
    
    -- Product 709 (Page 14)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'HPN03(Pointed) £5.95 automatically cleans and lubricates up',
        dental_id, cat_id,
        'From catalogue.pdf, page 14'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.0, 'GBP', NOW());
    END IF;
    
    -- Product 710 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'WTD03 Storage Jar',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 15.0, 'GBP', NOW());
    END IF;
    
    -- Product 711 (Page 17)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Buy any 3 of the above for £36.00 each',
        dental_id, cat_id,
        'From catalogue.pdf, page 17'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 14.95, 'GBP', NOW());
    END IF;
    
    -- Product 712 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '3% Kit • High viscosity, spearmint flavoured gel • 0.11% fluoride ions Buy 10 for',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 14.95, 'GBP', NOW());
    END IF;
    
    -- Product 713 (Page 36)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ULTCF1 1 Spill x 50 £27.56 SUPERETCH04',
        dental_id, cat_id,
        'From catalogue.pdf, page 36'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 14.95, 'GBP', NOW());
    END IF;
    
    -- Product 714 (Page 45)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '20 Box Rate £4.30 DISPAPR01 Box 500 £17.50 SGA01 £4.95 PVMS02 12 pack shields',
        dental_id, cat_id,
        'From catalogue.pdf, page 45'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 14.95, 'GBP', NOW());
    END IF;
    
    -- Product 715 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'STERI01 16mm tips',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 14.75, 'GBP', NOW());
    END IF;
    
    -- Product 716 (Page 4)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SEPRTRSY Each £59.95 SEPEL01 10ml',
        dental_id, cat_id,
        'From catalogue.pdf, page 4'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 14.5, 'GBP', NOW());
    END IF;
    
    -- Product 717 (Page 32)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Small Tray Rack SSCB5 Blue',
        dental_id, cat_id,
        'From catalogue.pdf, page 32'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 14.5, 'GBP', NOW());
    END IF;
    
    -- Product 718 (Page 27)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• 3 Mirror Handles ~ 3 Ball Burnishers & Premolars CSA04 1.8ml £15.00',
        dental_id, cat_id,
        'From catalogue.pdf, page 27'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 14.0, 'GBP', NOW());
    END IF;
    
    -- Product 719 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SEPSP22 50 x 2.2ml £18.95',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 14.0, 'GBP', NOW());
    END IF;
    
    -- Product 720 (Page 35)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BOX OF 100 Anterior IMPR09 £5.35 3 Rate £5.45 each',
        dental_id, cat_id,
        'From catalogue.pdf, page 35'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 13.95, 'GBP', NOW());
    END IF;
    
    -- Product 721 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'RBDK £35.00 base 300ml catalyst IMPTIP05 White',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 13.75, 'GBP', NOW());
    END IF;
    
    -- Product 722 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'STERI02 11mm tips',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 13.75, 'GBP', NOW());
    END IF;
    
    -- Product 723 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Contains rubber dam, metal frame, IMPTIP03 Green',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 13.75, 'GBP', NOW());
    END IF;
    
    -- Product 724 (Page 34)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'punch, holder and 5 clamps. A dark blue A silicone putty. 300ml IMPTIP04 Blue',
        dental_id, cat_id,
        'From catalogue.pdf, page 34'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 13.75, 'GBP', NOW());
    END IF;
    
    -- Product 725 (Page 24)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'and chiropody surgeries 134 C 3 mins x 100',
        dental_id, cat_id,
        'From catalogue.pdf, page 24'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 13.5, 'GBP', NOW());
    END IF;
    
    -- Product 726 (Page 46)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '6 Rate £6.29 6 Rate £2.39 SURFD01 5ltr £17.90 STAB01 1ltr',
        dental_id, cat_id,
        'From catalogue.pdf, page 46'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 13.49, 'GBP', NOW());
    END IF;
    
    -- Product 727 (Page 52)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'POLADB6 £145.00 Bulk kit Polanight 10% POLATR01',
        dental_id, cat_id,
        'From catalogue.pdf, page 52'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 13.25, 'GBP', NOW());
    END IF;
    
    -- Product 728 (Page 33)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'NITI4%__ £12.99 • Packs of 6 assorted 1 of each file above',
        dental_id, cat_id,
        'From catalogue.pdf, page 33'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.99, 'GBP', NOW());
    END IF;
    
    -- Product 729 (Page 33)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Rotating speed 150-350 rpm • Packs of 6 finishing files MF1, MF2, MF3',
        dental_id, cat_id,
        'From catalogue.pdf, page 33'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.99, 'GBP', NOW());
    END IF;
    
    -- Product 730 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS314 £12.95 BDS336 £12.95 BDS355',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 731 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Warwick James RIGHT BDS310',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 732 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS330 £12.95 BDS351',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 733 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Upper Molars (Left) 18L Lower Molars 22',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 734 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Pereosteal 411 BDS329',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 735 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Upper Roots 76N Upper Molars (Left) 97L',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 736 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Hospital Pattern Right BDS41 £2.90 BDS322',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 737 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS49 £2.90 BDS326',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 738 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS324 £12.95 BDS342',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 739 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Pereosteal 411 BDS329 £12.95 BDS349',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 740 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Upper Anterior Roots 1',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 741 (Page 30)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Short NOSE ADAMS CPITN-C £4.75 BDS247 £2.90',
        dental_id, cat_id,
        'From catalogue.pdf, page 30'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 742 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Childs Upper Pre Molars 159 £200or more & receive a20% Discount* available.',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 743 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Childs Upper Teeth & Roots 138 Tofflemire LX3C, LX5C, LX3S, LX5S. All complete RINGS - BOX OF 50',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 744 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Childs Upper Molars 158',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 745 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Childs Upper Incisor Canines 37 LX2S £22.95 LX1S £22.95',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 746 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS38 £2.90 BDS319',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 747 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS314 £12.95 BDS336',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 748 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Hospital Pattern Right BDS41 £2.90 BDS322 £12.95 BDS340',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 749 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS49 £2.90 BDS326 £12.95 BDS345',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 750 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS38 £2.90 BDS319 £12.95 BDS337 £12.95 BDS359',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 751 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Childs Lower Molars (Hawks) 160 3mm Curved Tip 5mm Curved Tip',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 752 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS321 £12.95 BDS338',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 753 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Matrix Bands Narrow Available in various colours.',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 754 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Lower Roots 74N Childs Lower Molars 161 3mm Contra Angled Tip 3mm Straight Tip',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 755 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Lower Molars & Roots',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 756 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS364 £12.95 BDS374',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 757 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS38 £2.90 BDS319 £12.95 BDS337',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 758 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS382 £7.90 BDS311',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 759 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Upper Premolar Roots 7',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 760 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Warwick James LEFT Upper Anterior 29S BDS335 £12.95 BDS354',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 761 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS375 £12.95 LX1C £22.95 LX5S £22.95',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 762 (Page 29)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Childs Upper Molars 39',
        dental_id, cat_id,
        'From catalogue.pdf, page 29'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 763 (Page 28)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Warwick James LEFT Upper Anterior 29S BDS335',
        dental_id, cat_id,
        'From catalogue.pdf, page 28'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.95, 'GBP', NOW());
    END IF;
    
    -- Product 764 (Page 48)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'ACP10 135 x 278 mm',
        dental_id, cat_id,
        'From catalogue.pdf, page 48'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 12.9, 'GBP', NOW());
    END IF;
    
    -- Product 765 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Surgical Tip ASPIRATOR CLEANER',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 766 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Autoclaveable box of 10 Blue',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 767 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Item 11 Tube Brush. Pack of 3',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 768 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Surgical Tip ASPI01 2L £19.95',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 769 (Page 42)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SURG02 Round 8 H/P Fitting £7.50 ISO Ø 1/10mm 010 012 ISO Ø 1/10mm 009 012 ( S C U oa P r A s D e) 0 R 1 e f i l l B l a c k .',
        dental_id, cat_id,
        'From catalogue.pdf, page 42'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 770 (Page 42)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Head L mm 4.4 4.5 Head L mm 4.0 4.5',
        dental_id, cat_id,
        'From catalogue.pdf, page 42'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 771 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Pack of 3 Surgical Tip. Pack of 3 MAT01 Bags of 100 £2.55 Sterile black braided silk, box of 12 (577)',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 772 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'To clean large tips',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 773 (Page 50)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Tube Brush. Pack of 3 makes 100L. Non foaming and can be',
        dental_id, cat_id,
        'From catalogue.pdf, page 50'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 774 (Page 42)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'A solid base chrome plated bur stand ISO Ø 1/10mm 012 016 021 ISO Ø 1/10mm 012 008 010 SUPAD05',
        dental_id, cat_id,
        'From catalogue.pdf, page 42'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 775 (Page 42)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'of Each. US No. 701 702 703 US No. 332 330 331 SUPAD06',
        dental_id, cat_id,
        'From catalogue.pdf, page 42'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 776 (Page 48)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'AWSC01 pack 500 £9.95 75mm Width',
        dental_id, cat_id,
        'From catalogue.pdf, page 48'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 777 (Page 42)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '(Fine) Green Mini.',
        dental_id, cat_id,
        'From catalogue.pdf, page 42'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 778 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'OCM01 £19.50 CL01',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 779 (Page 42)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'TC_ _ _ _(FG) 1157 1158 TC_ _(FG) 56 58',
        dental_id, cat_id,
        'From catalogue.pdf, page 42'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.95, 'GBP', NOW());
    END IF;
    
    -- Product 780 (Page 41)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• ISO size 060 ACR06',
        dental_id, cat_id,
        'From catalogue.pdf, page 41'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.85, 'GBP', NOW());
    END IF;
    
    -- Product 781 (Page 41)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• ISO size 060 ACR02',
        dental_id, cat_id,
        'From catalogue.pdf, page 41'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.85, 'GBP', NOW());
    END IF;
    
    -- Product 782 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '5 KITS £41.40 each reinforced',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.7, 'GBP', NOW());
    END IF;
    
    -- Product 783 (Page 48)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Size 0 (20x30) Box 100',
        dental_id, cat_id,
        'From catalogue.pdf, page 48'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.5, 'GBP', NOW());
    END IF;
    
    -- Product 784 (Page 48)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Size 1 (20x40) Box 100',
        dental_id, cat_id,
        'From catalogue.pdf, page 48'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.5, 'GBP', NOW());
    END IF;
    
    -- Product 785 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Procedures in upper jaw: 10 RATE £36.50 SEPEV001 27g short',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.49, 'GBP', NOW());
    END IF;
    
    -- Product 786 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• Procedures in lower jaw: SEPEV002 30g long',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.49, 'GBP', NOW());
    END IF;
    
    -- Product 787 (Page 44)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '…201 …202 …211 …212 60 assorted £29.95',
        dental_id, cat_id,
        'From catalogue.pdf, page 44'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.45, 'GBP', NOW());
    END IF;
    
    -- Product 788 (Page 41)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• ISO size 060 ACR06 £11.85 • ISO size 060 ACR07',
        dental_id, cat_id,
        'From catalogue.pdf, page 41'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.35, 'GBP', NOW());
    END IF;
    
    -- Product 789 (Page 41)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        '• ISO size 060 ACR02 £11.85 • ISO size 060 ACR04',
        dental_id, cat_id,
        'From catalogue.pdf, page 41'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.35, 'GBP', NOW());
    END IF;
    
    -- Product 790 (Page 38)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Ceram II VLC Metallized Glass Ionomer for Build up',
        dental_id, cat_id,
        'From catalogue.pdf, page 38'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.2, 'GBP', NOW());
    END IF;
    
    -- Product 791 (Page 51)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Horseshoe Articulating Paper',
        dental_id, cat_id,
        'From catalogue.pdf, page 51'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 11.2, 'GBP', NOW());
    END IF;
    
    -- Product 792 (Page 43)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Diamond powdered polishing paste for',
        dental_id, cat_id,
        'From catalogue.pdf, page 43'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 10.95, 'GBP', NOW());
    END IF;
    
    -- Product 793 (Page 26)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'WTD04 Charcoal Sachets',
        dental_id, cat_id,
        'From catalogue.pdf, page 26'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 10.9, 'GBP', NOW());
    END IF;
    
    -- Product 794 (Page 43)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'PCSN01 Buy 1 bag £7.50 PCL01 Buy 1 bag',
        dental_id, cat_id,
        'From catalogue.pdf, page 43'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 10.5, 'GBP', NOW());
    END IF;
    
    -- Product 795 (Page 30)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Front Surface (12) BDS124 £2.90 Item 268 Shepards 197',
        dental_id, cat_id,
        'From catalogue.pdf, page 30'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 10.45, 'GBP', NOW());
    END IF;
    
    -- Product 796 (Page 31)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'BDS424S £2.90 BDS150 £2.90 BDSWR',
        dental_id, cat_id,
        'From catalogue.pdf, page 31'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 10.45, 'GBP', NOW());
    END IF;
    
    -- Product 797 (Page 3)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'SAPAS01 Guard x 4',
        dental_id, cat_id,
        'From catalogue.pdf, page 3'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 10.29, 'GBP', NOW());
    END IF;
    
    -- Product 798 (Page 49)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'Plain polished 6" x 3" x 5⁄"',
        dental_id, cat_id,
        'From catalogue.pdf, page 49'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 10.25, 'GBP', NOW());
    END IF;
    
    -- Product 799 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'to tooth and restorations. High',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 10.2, 'GBP', NOW());
    END IF;
    
    -- Product 800 (Page 40)
    INSERT INTO products (name, vertical_id, category_id, description)
    VALUES (
        'shade of restoration. Very low film',
        dental_id, cat_id,
        'From catalogue.pdf, page 40'
    )
    ON CONFLICT DO NOTHING
    RETURNING id INTO pid;
    
    IF pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (pid, supp_id, 10.2, 'GBP', NOW());
    END IF;
    
    RAISE NOTICE '✅ Loaded % products from catalogue.pdf', (SELECT COUNT(*) FROM products WHERE description LIKE '%catalogue.pdf%');
END $$;