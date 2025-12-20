-- Generated from catalogue
-- Date: 2025-12-19T10:59:40.324991
-- Total: 1402 products

DO $$
DECLARE 
    v_vertical_id INTEGER;
    v_cat_id INTEGER;
    v_supp_id INTEGER;
    v_pid BIGINT;
BEGIN
    -- Create supplier
    INSERT INTO suppliers (name, slug, country_code)
    VALUES ('catalogue', 'catalogue', 'GB')
    ON CONFLICT (slug) DO NOTHING;
    SELECT id INTO v_supp_id FROM suppliers WHERE slug = 'catalogue';


    -- ===== Vertical: automotive (45 products) =====
    SELECT id INTO v_vertical_id FROM verticals WHERE slug = 'automotive';
    SELECT id INTO v_cat_id FROM categories WHERE vertical_id = v_vertical_id LIMIT 1;

    -- • Spend over and get Electric Motor Sets 16...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Spend over and get Electric Motor Sets 16', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- ME-20B 20,000 rpm 2 hole Motor Buy 3 for each bur...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ME-20B 20,000 rpm 2 hole Motor Buy 3 for each bur', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 56.56, 'GBP', NOW());
    END IF;

    -- ME-80M 5,000 rpm 4 hole Motor EH-30BLP...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ME-80M 5,000 rpm 4 hole Motor EH-30BLP', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 75.0, 'GBP', NOW());
    END IF;

    -- ARYS Head only E4R 4:1 Reduction 4:1 reduction up to 10,000 ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARYS Head only E4R 4:1 Reduction 4:1 reduction up to 10,000 rpm Easy Cartridge Replacement', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 37.14, 'GBP', NOW());
    END IF;

    -- ARYS Head only E4R 4:1 Reduction 4:1 reduction up to 10,000 ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARYS Head only E4R 4:1 Reduction 4:1 reduction up to 10,000 rpm Easy Cartridge Replacement', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 117.06, 'GBP', NOW());
    END IF;

    -- E10R 10:1 Reduction FX-15M Cartridges are easily replaced wi...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('E10R 10:1 Reduction FX-15M Cartridges are easily replaced with the', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 195.09, 'GBP', NOW());
    END IF;

    -- E10R 10:1 Reduction FX-15M Cartridges are easily replaced wi...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('E10R 10:1 Reduction FX-15M Cartridges are easily replaced with the', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 168.17, 'GBP', NOW());
    END IF;

    -- M65 Non-optic hard-to-reach molars that a standard motors na...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('M65 Non-optic hard-to-reach molars that a standard motors nano contra angles give the', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 334.23, 'GBP', NOW());
    END IF;

    -- RRP save 25% For smaller head Prestige range Electric Motors...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% For smaller head Prestige range Electric Motors', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1040.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% For smaller head Prestige range Electric Motors...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% For smaller head Prestige range Electric Motors', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 780.0, 'GBP', NOW());
    END IF;

    -- 360º rotation for engine files. ENDOMATE TC2 PACK...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('360º rotation for engine files. ENDOMATE TC2 PACK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 999.82, 'GBP', NOW());
    END IF;

    -- EXEND0128 Auto-detects the apex accurately in any SGS-E2...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EXEND0128 Auto-detects the apex accurately in any SGS-E2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 386.69, 'GBP', NOW());
    END IF;

    -- EXEND0128 Auto-detects the apex accurately in any SGS-E2...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EXEND0128 Auto-detects the apex accurately in any SGS-E2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 698.16, 'GBP', NOW());
    END IF;

    -- HPN02(Quick) maintenance at your office. Care3 Plus...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HPN02(Quick) maintenance at your office. Care3 Plus', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.95, 'GBP', NOW());
    END IF;

    -- HPN03(Pointed) automatically cleans and lubricates up...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HPN03(Pointed) automatically cleans and lubricates up', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.95, 'GBP', NOW());
    END IF;

    -- • Durable 6 CANS each Spray Plus every time before autoclavi...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Durable 6 CANS each Spray Plus every time before autoclaving', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.65, 'GBP', NOW());
    END IF;

    -- ARTIM1 PANASPRAYOIL...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTIM1 PANASPRAYOIL', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2350.0, 'GBP', NOW());
    END IF;

    -- OILN003 the unit...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('OILN003 the unit', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.4, 'GBP', NOW());
    END IF;

    -- cutting capacity shortens treatment OILN001 ensures optimum ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('cutting capacity shortens treatment OILN001 ensures optimum lubrication of the', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.4, 'GBP', NOW());
    END IF;

    -- • Stand aloneThe quality efficient OILN06 care cycle CARE3Pl...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Stand aloneThe quality efficient OILN06 care cycle CARE3Plus C1', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.4, 'GBP', NOW());
    END IF;

    -- • Stand aloneThe quality efficient OILN06 care cycle CARE3Pl...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Stand aloneThe quality efficient OILN06 care cycle CARE3Plus C1', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1427.06, 'GBP', NOW());
    END IF;

    -- and cooling and eliminates the need OILN05 integrated deterg...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('and cooling and eliminates the need OILN05 integrated detergent and foaming oil CARE3Plus C2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1503.08, 'GBP', NOW());
    END IF;

    -- Osteotome, Tiny round Osteotomy, OILN05 •Optimum cleaning: W...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Osteotome, Tiny round Osteotomy, OILN05 •Optimum cleaning: With the including E type available', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.4, 'GBP', NOW());
    END IF;

    -- ARTOP1 Set OILN02 QUAT2104 POA Care3oil...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTOP1 Set OILN02 QUAT2104 POA Care3oil', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2250.0, 'GBP', NOW());
    END IF;

    -- ARTOP1 Set OILN02 QUAT2104 POA Care3oil...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTOP1 Set OILN02 QUAT2104 POA Care3oil', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.4, 'GBP', NOW());
    END IF;

    -- ARTOP1 Set OILN02 QUAT2104 POA Care3oil...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTOP1 Set OILN02 QUAT2104 POA Care3oil', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 59.87, 'GBP', NOW());
    END IF;

    -- SATP5NEW • Autoclavable Satelec®style peroxide,chlorhexidine...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SATP5NEW • Autoclavable Satelec®style peroxide,chlorhexidine and sodium To remove supragingival heavy calculus.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 959.2, 'GBP', NOW());
    END IF;

    -- autoclavable box tips: 2 universal, 1 flat chisel, 1 round C...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('autoclavable box tips: 2 universal, 1 flat chisel, 1 round Compatible with Woodpecker and EMS WOOD09 EMS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- motor. Unit supplied with 2 universal CAV25KTB ART25INS02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('motor. Unit supplied with 2 universal CAV25KTB ART25INS02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- motor. Unit supplied with 2 universal CAV25KTB ART25INS02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('motor. Unit supplied with 2 universal CAV25KTB ART25INS02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- PLIWS6801 any brand of “E” fitting micro-motor....
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PLIWS6801 any brand of “E” fitting micro-motor.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 595.0, 'GBP', NOW());
    END IF;

    -- kit alone Motor Only ANTH07...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('kit alone Motor Only ANTH07', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 59.5, 'GBP', NOW());
    END IF;

    -- kit alone Motor Only ANTH07...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('kit alone Motor Only ANTH07', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 34.95, 'GBP', NOW());
    END IF;

    -- Mobile cart made in USA ASPI06 TRID02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Mobile cart made in USA ASPI06 TRID02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1665.0, 'GBP', NOW());
    END IF;

    -- Mobile cart made in USA ASPI06 TRID02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Mobile cart made in USA ASPI06 TRID02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1395.0, 'GBP', NOW());
    END IF;

    -- BECART01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BECART01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1650.0, 'GBP', NOW());
    END IF;

    -- Wall mounted version Fimet mobile cart available as part of ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Wall mounted version Fimet mobile cart available as part of a CAT21 11mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.0, 'GBP', NOW());
    END IF;

    -- PICO Pioneer AUTO01SEAL1 each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PICO Pioneer AUTO01SEAL1 each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.6, 'GBP', NOW());
    END IF;

    -- Economy model. As the Pico Flush model without the MEDIPCD A...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Economy model. As the Pico Flush model without the MEDIPCD AUTO01SEAL pack 4', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 111.51, 'GBP', NOW());
    END IF;

    -- Medium RDRC03 Sterilisable in autoclave and dry heat. integr...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Medium RDRC03 Sterilisable in autoclave and dry heat. integrity on removal. Precise A-silicone impression material', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.95, 'GBP', NOW());
    END IF;

    -- SDI Applicator COM248X2A1 Light cartridges for fabricating p...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SDI Applicator COM248X2A1 Light cartridges for fabricating provisional', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- Strongly engineered applicator for all COM248X2A3 Universal ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Strongly engineered applicator for all COM248X2A3 Universal VOSC01 cartridge 75gm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- RIVARS _ _ (shade) thermal conductivity problems CART01 powd...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RIVARS _ _ (shade) thermal conductivity problems CART01 powder (universal shade), 15ml liquid,', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 64.5, 'GBP', NOW());
    END IF;

    -- RIVARS _ _ (shade) thermal conductivity problems CART01 powd...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RIVARS _ _ (shade) thermal conductivity problems CART01 powder (universal shade), 15ml liquid,', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.5, 'GBP', NOW());
    END IF;

    -- TUBC02 pack 250 Self Seal Autoclave...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TUBC02 pack 250 Self Seal Autoclave', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.95, 'GBP', NOW());
    END IF;


    -- ===== Vertical: dental (1321 products) =====
    SELECT id INTO v_vertical_id FROM verticals WHERE slug = 'dental';
    SELECT id INTO v_cat_id FROM categories WHERE vertical_id = v_vertical_id LIMIT 1;

    -- that exceed in value (excludes vat and multi-buy rates and S...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('that exceed in value (excludes vat and multi-buy rates and SDI 500 alloy tubs)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 200.0, 'GBP', NOW());
    END IF;

    -- • Spend over and get Dental Chairs 18...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Spend over and get Dental Chairs 18', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 100.0, 'GBP', NOW());
    END IF;

    -- • Spend over and get Autoclaves & Curing Lights 22...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Spend over and get Autoclaves & Curing Lights 22', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 200.0, 'GBP', NOW());
    END IF;

    -- *Minimum spend otherwise postage or courier charges apply...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('*Minimum spend otherwise postage or courier charges apply', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- *Minimum spend otherwise postage or courier charges apply...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('*Minimum spend otherwise postage or courier charges apply', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.5, 'GBP', NOW());
    END IF;

    -- *Minimum spend otherwise postage or courier charges apply...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('*Minimum spend otherwise postage or courier charges apply', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.0, 'GBP', NOW());
    END IF;

    -- • Lidocaine Hydrochloride 2% with • 4% Articane Hydrochlorid...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Lidocaine Hydrochloride 2% with • 4% Articane Hydrochloride with HDEN01 27g Long ULTRAC01 30ml POA', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.95, 'GBP', NOW());
    END IF;

    -- HDEN02 30g Short...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HDEN02 30g Short', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.95, 'GBP', NOW());
    END IF;

    -- 10 Rate each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Rate each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.65, 'GBP', NOW());
    END IF;

    -- 20 Rate each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Rate each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.4, 'GBP', NOW());
    END IF;

    -- • Rapid on-set SEPS1122 50 x 2.2ml Xylonor Gel...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Rapid on-set SEPS1122 50 x 2.2ml Xylonor Gel', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 20.5, 'GBP', NOW());
    END IF;

    -- SEPLS22 50 x 2.2ml SEPS1222 50 x 2.2ml before anaesthetic in...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPLS22 50 x 2.2ml SEPS1222 50 x 2.2ml before anaesthetic injection', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 18.95, 'GBP', NOW());
    END IF;

    -- SEPLS22 50 x 2.2ml SEPS1222 50 x 2.2ml before anaesthetic in...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPLS22 50 x 2.2ml SEPS1222 50 x 2.2ml before anaesthetic injection', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 20.5, 'GBP', NOW());
    END IF;

    -- 10 RATE 10 RATE • Fast acting gives anaesthesia within...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 RATE 10 RATE • Fast acting gives anaesthesia within', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.95, 'GBP', NOW());
    END IF;

    -- 10 RATE 10 RATE • Fast acting gives anaesthesia within...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 RATE 10 RATE • Fast acting gives anaesthesia within', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.5, 'GBP', NOW());
    END IF;

    -- Septoject SEPXG01 15g Tube...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Septoject SEPXG01 15g Tube', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.79, 'GBP', NOW());
    END IF;

    -- 6 x 15g...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 x 15g', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 21.5, 'GBP', NOW());
    END IF;

    -- SEPT027L 27g Long...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPT027L 27g Long', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.99, 'GBP', NOW());
    END IF;

    -- SEPT030S 30g Short...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPT030S 30g Short', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.99, 'GBP', NOW());
    END IF;

    -- • For producing local or loco-regional DENCSA18 100 x 2.2ml ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• For producing local or loco-regional DENCSA18 100 x 2.2ml force, resulting in less tissue buccal cavity', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 37.5, 'GBP', NOW());
    END IF;

    -- • Rapid on-set DENC18 100 x 2.2ml comfort. metered spray...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Rapid on-set DENC18 100 x 2.2ml comfort. metered spray', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 37.5, 'GBP', NOW());
    END IF;

    -- • Procedures in upper jaw: 10 RATE SEPEV001 27g short • Fast...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Procedures in upper jaw: 10 RATE SEPEV001 27g short • Fast acting gives anaesthesia within', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 36.5, 'GBP', NOW());
    END IF;

    -- • Procedures in upper jaw: 10 RATE SEPEV001 27g short • Fast...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Procedures in upper jaw: 10 RATE SEPEV001 27g short • Fast acting gives anaesthesia within', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.49, 'GBP', NOW());
    END IF;

    -- • Procedures in lower jaw: SEPEV002 30g long • Spearmint fla...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Procedures in lower jaw: SEPEV002 30g long • Spearmint flavoured', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.49, 'GBP', NOW());
    END IF;

    -- 1 - 4 minutes SEPXS01 36g...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('1 - 4 minutes SEPXS01 36g', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 18.99, 'GBP', NOW());
    END IF;

    -- SEPSS22 50 x 2.2ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPSS22 50 x 2.2ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 18.95, 'GBP', NOW());
    END IF;

    -- 10 RATE...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 RATE', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.95, 'GBP', NOW());
    END IF;

    -- CSA01 2.2ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CSA01 2.2ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.0, 'GBP', NOW());
    END IF;

    -- CSA03 1.8ml Sterile single use self aspirating system • Tetr...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CSA03 1.8ml Sterile single use self aspirating system • Tetrafluoroethane cryo-anaesthetic', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.0, 'GBP', NOW());
    END IF;

    -- Buy 5 @ each specially designed to prevent needle spray...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 5 @ each specially designed to prevent needle spray', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.0, 'GBP', NOW());
    END IF;

    -- Scandonest 3% Plain SEPTUSP27L 27g Long deciduous or periodo...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Scandonest 3% Plain SEPTUSP27L 27g Long deciduous or periodontally', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 21.5, 'GBP', NOW());
    END IF;

    -- SEPTUSP30S 30g Short compromised teeth or to the lancing...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPTUSP30S 30g Short compromised teeth or to the lancing', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 21.5, 'GBP', NOW());
    END IF;

    -- anaesthesia SEPPH01 150ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('anaesthesia SEPPH01 150ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- CSA02 2.2ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CSA02 2.2ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.0, 'GBP', NOW());
    END IF;

    -- CSA04 1.8ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CSA04 1.8ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.0, 'GBP', NOW());
    END IF;

    -- SEPSP22 50 x 2.2ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPSP22 50 x 2.2ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 18.95, 'GBP', NOW());
    END IF;

    -- Buy 5 @ each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 5 @ each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 14.0, 'GBP', NOW());
    END IF;

    -- 10 RATE Aim Safe Finger Guard...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 RATE Aim Safe Finger Guard', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.95, 'GBP', NOW());
    END IF;

    -- SAPAS01 Guard x 4 SPECBPS01 50ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SAPAS01 Guard x 4 SPECBPS01 50ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.29, 'GBP', NOW());
    END IF;

    -- SAPAS01 Guard x 4 SPECBPS01 50ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SAPAS01 Guard x 4 SPECBPS01 50ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.95, 'GBP', NOW());
    END IF;

    -- KPAS300100 100pk...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPAS300100 100pk', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 0.69, 'GBP', NOW());
    END IF;

    -- A derivative of Penicillin with a wider KPIBU20084 84pk VOPV...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('A derivative of Penicillin with a wider KPIBU20084 84pk VOPV01 10ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.99, 'GBP', NOW());
    END IF;

    -- A derivative of Penicillin with a wider KPIBU20084 84pk VOPV...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('A derivative of Penicillin with a wider KPIBU20084 84pk VOPV01 10ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 18.95, 'GBP', NOW());
    END IF;

    -- KPIBU40084 84pk...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPIBU40084 84pk', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.39, 'GBP', NOW());
    END IF;

    -- KPAM25021 21pk250mg Desensitizing Gel...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPAM25021 21pk250mg Desensitizing Gel', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.49, 'GBP', NOW());
    END IF;

    -- KMAP50021 21pk 500mg...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KMAP50021 21pk 500mg', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.79, 'GBP', NOW());
    END IF;

    -- KPPAR50032 32pk...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPPAR50032 32pk', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 0.29, 'GBP', NOW());
    END IF;

    -- SEPLARG01 125ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPLARG01 125ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 34.95, 'GBP', NOW());
    END IF;

    -- KPPAR5001232 12 x 32pk...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPPAR5001232 12 x 32pk', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.25, 'GBP', NOW());
    END IF;

    -- KPAM250500 500pk...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPAM250500 500pk', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.95, 'GBP', NOW());
    END IF;

    -- SOOTH1 4pk...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SOOTH1 4pk', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 31.5, 'GBP', NOW());
    END IF;

    -- KPAMSP02 3g x 2...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPAMSP02 3g x 2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.95, 'GBP', NOW());
    END IF;

    -- SEPAP01 12g hydroxide gel for endodontic...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPAP01 12g hydroxide gel for endodontic', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 31.49, 'GBP', NOW());
    END IF;

    -- SEPECH01 2.5g...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPECH01 2.5g', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 36.95, 'GBP', NOW());
    END IF;

    -- KPAP25028 28pk...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPAP25028 28pk', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.5, 'GBP', NOW());
    END IF;

    -- KPESF01 100ml periodontitis. Use following scaling and...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPESF01 100ml periodontitis. Use following scaling and', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.05, 'GBP', NOW());
    END IF;

    -- KPETC01 28pk BLDENT01 5pk...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPETC01 28pk BLDENT01 5pk', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.5, 'GBP', NOW());
    END IF;

    -- KPETC01 28pk BLDENT01 5pk...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPETC01 28pk BLDENT01 5pk', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 89.9, 'GBP', NOW());
    END IF;

    -- Cones pack of 2 x 0.3cm3 SEPEP01 14g...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Cones pack of 2 x 0.3cm3 SEPEP01 14g', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 45.99, 'GBP', NOW());
    END IF;

    -- Metronidazole SEPRTRCON Pack SEPEP02 3 x 14g...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Metronidazole SEPRTRCON Pack SEPEP02 3 x 14g', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 69.95, 'GBP', NOW());
    END IF;

    -- Metronidazole SEPRTRCON Pack SEPEP02 3 x 14g...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Metronidazole SEPRTRCON Pack SEPEP02 3 x 14g', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 96.16, 'GBP', NOW());
    END IF;

    -- SEPRTRSY Each SEPEL01 10ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPRTRSY Each SEPEL01 10ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 59.95, 'GBP', NOW());
    END IF;

    -- SEPRTRSY Each SEPEL01 10ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPRTRSY Each SEPEL01 10ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 14.5, 'GBP', NOW());
    END IF;

    -- KPMET20021 21pk Duraphat...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPMET20021 21pk Duraphat', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 0.99, 'GBP', NOW());
    END IF;

    -- KPMET40021 21pk...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPMET40021 21pk', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 0.95, 'GBP', NOW());
    END IF;

    -- KPPENVK250 28pk COLDURA01 10ml SEPTR4 13ml SEPPARSH03 250ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPPENVK250 28pk COLDURA01 10ml SEPTR4 13ml SEPPARSH03 250ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.79, 'GBP', NOW());
    END IF;

    -- KPPENVK250 28pk COLDURA01 10ml SEPTR4 13ml SEPPARSH03 250ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPPENVK250 28pk COLDURA01 10ml SEPTR4 13ml SEPPARSH03 250ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 28.5, 'GBP', NOW());
    END IF;

    -- KPPENVK250 28pk COLDURA01 10ml SEPTR4 13ml SEPPARSH03 250ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPPENVK250 28pk COLDURA01 10ml SEPTR4 13ml SEPPARSH03 250ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 28.89, 'GBP', NOW());
    END IF;

    -- KPPENVK250 28pk COLDURA01 10ml SEPTR4 13ml SEPPARSH03 250ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KPPENVK250 28pk COLDURA01 10ml SEPTR4 13ml SEPPARSH03 250ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.95, 'GBP', NOW());
    END IF;

    -- med 0.8Ø 2.5mtr...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('med 0.8Ø 2.5mtr', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 23.95, 'GBP', NOW());
    END IF;

    -- med 0.8Ø 4mtr...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('med 0.8Ø 4mtr', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.35, 'GBP', NOW());
    END IF;

    -- Ledermix Kit BLLEDKIT01 Pack Racestyptine solution...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Ledermix Kit BLLEDKIT01 Pack Racestyptine solution', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 62.45, 'GBP', NOW());
    END IF;

    -- No.2 paste BLLEDRP01 5g...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('No.2 paste BLLEDRP01 5g', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 44.5, 'GBP', NOW());
    END IF;

    -- No.3 powder BLLEDP3 3g...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('No.3 powder BLLEDP3 3g', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.25, 'GBP', NOW());
    END IF;

    -- No. 4 hardener fast BLLEDH405 5ml Racegel is a brand new gel...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('No. 4 hardener fast BLLEDH405 5ml Racegel is a brand new gel specifically', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.6, 'GBP', NOW());
    END IF;

    -- No. 5 hardener slow BLLEDH505 5ml designed to make gingival ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('No. 5 hardener slow BLLEDH505 5ml designed to make gingival preparation', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.6, 'GBP', NOW());
    END IF;

    -- SEPRACE01 13ml 3 x 1.4g + 20 tips...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPRACE01 13ml 3 x 1.4g + 20 tips', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 20.89, 'GBP', NOW());
    END IF;

    -- SEPRACE01 13ml 3 x 1.4g + 20 tips...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPRACE01 13ml 3 x 1.4g + 20 tips', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 64.95, 'GBP', NOW());
    END IF;

    -- SYBTUBCS01 Pack...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SYBTUBCS01 Pack', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 34.59, 'GBP', NOW());
    END IF;

    -- SEPHS01 24pk...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPHS01 24pk', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 32.95, 'GBP', NOW());
    END IF;

    -- Buy any 6 for...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy any 6 for', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.5, 'GBP', NOW());
    END IF;

    -- BLCLOR01 300ml Original...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BLCLOR01 300ml Original', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.95, 'GBP', NOW());
    END IF;

    -- BLCLOR02 300ml Mint...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BLCLOR02 300ml Mint', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.95, 'GBP', NOW());
    END IF;

    -- SEPBIO01 15 capsules...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEPBIO01 15 capsules', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 124.95, 'GBP', NOW());
    END IF;

    -- 12 x 20 packs...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('12 x 20 packs', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.95, 'GBP', NOW());
    END IF;

    -- 1 x pack 1000...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('1 x pack 1000', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 42.95, 'GBP', NOW());
    END IF;

    -- Full Septodont range available – please ask PLAQ03 liquid 25...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Full Septodont range available – please ask PLAQ03 liquid 25ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.49, 'GBP', NOW());
    END IF;

    -- ES-30A EC-30TL Latch Fitting...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ES-30A EC-30TL Latch Fitting', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 76.53, 'GBP', NOW());
    END IF;

    -- E-Type straight handpiece 40,000rpm. EH-20L...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('E-Type straight handpiece 40,000rpm. EH-20L', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.85, 'GBP', NOW());
    END IF;

    -- 3 Ball Bearing EHN-20L (for NSK)...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('3 Ball Bearing EHN-20L (for NSK)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 26.04, 'GBP', NOW());
    END IF;

    -- ES-30A...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ES-30A', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 109.25, 'GBP', NOW());
    END IF;

    -- EC-30BL EH-50PK...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EC-30BL EH-50PK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 109.25, 'GBP', NOW());
    END IF;

    -- EC-30BL EH-50PK...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EC-30BL EH-50PK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.85, 'GBP', NOW());
    END IF;

    -- EHN-50PK (for NSK)...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EHN-50PK (for NSK)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 28.93, 'GBP', NOW());
    END IF;

    -- ME-20MKIT...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ME-20MKIT', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 315.25, 'GBP', NOW());
    END IF;

    -- ME-20BKIT E-Type straight handpiece 4:1...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ME-20BKIT E-Type straight handpiece 4:1', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 315.25, 'GBP', NOW());
    END IF;

    -- ME-20MPKIT ESG-30AR 30,000 rpm ball bearing push button Scre...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ME-20MPKIT ESG-30AR 30,000 rpm ball bearing push button Screw In Prophy', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 378.5, 'GBP', NOW());
    END IF;

    -- ME-20MPKIT ESG-30AR 30,000 rpm ball bearing push button Scre...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ME-20MPKIT ESG-30AR 30,000 rpm ball bearing push button Screw In Prophy', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 138.25, 'GBP', NOW());
    END IF;

    -- ME-20BPKIT contra EH-50PS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ME-20BPKIT contra EH-50PS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 378.5, 'GBP', NOW());
    END IF;

    -- ME-20BPKIT contra EH-50PS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ME-20BPKIT contra EH-50PS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.85, 'GBP', NOW());
    END IF;

    -- EHN-50PS (for NSK)...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EHN-50PS (for NSK)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 28.93, 'GBP', NOW());
    END IF;

    -- EC-30BLP...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EC-30BLP', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 133.0, 'GBP', NOW());
    END IF;

    -- Buy 3 for each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.7, 'GBP', NOW());
    END IF;

    -- EC-30FGP EH-30TL...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EC-30FGP EH-30TL', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 34.65, 'GBP', NOW());
    END IF;

    -- EC-20L EC-30GFP...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EC-20L EC-30GFP', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 133.0, 'GBP', NOW());
    END IF;

    -- EC-20L 30,000 ball bearing for contra angle...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EC-20L 30,000 ball bearing for contra angle', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 62.85, 'GBP', NOW());
    END IF;

    -- EH-30BL...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EH-30BL', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 56.85, 'GBP', NOW());
    END IF;

    -- EHN-30BL (for NSK)...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EHN-30BL (for NSK)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 56.85, 'GBP', NOW());
    END IF;

    -- ME-20M 4 HOLE...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ME-20M 4 HOLE', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 172.85, 'GBP', NOW());
    END IF;

    -- ME-20B 2 HOLE...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ME-20B 2 HOLE', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 172.85, 'GBP', NOW());
    END IF;

    -- Sealed Prophy Screw-in EC-20APS 30,000 ball bearing push but...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Sealed Prophy Screw-in EC-20APS 30,000 ball bearing push button for', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 120.0, 'GBP', NOW());
    END IF;

    -- EC-50PS contra angle bur...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EC-50PS contra angle bur', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 62.85, 'GBP', NOW());
    END IF;

    -- EHN-30BLP (for NSK)...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EHN-30BLP (for NSK)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 75.0, 'GBP', NOW());
    END IF;

    -- SHS-EC Handpiece...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SHS-EC Handpiece', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 42.5, 'GBP', NOW());
    END IF;

    -- 2 or 4 hole EC-50PK SHS-EG Handpiece handpiece...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('2 or 4 hole EC-50PK SHS-EG Handpiece handpiece', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 65.0, 'GBP', NOW());
    END IF;

    -- RA-10PK...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RA-10PK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.85, 'GBP', NOW());
    END IF;

    -- ME-80M 4 HOLE Sealed Prophy Snap-on 16:1 Reduction Shank for...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ME-80M 4 HOLE Sealed Prophy Snap-on 16:1 Reduction Shank for BDSI', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 200.57, 'GBP', NOW());
    END IF;

    -- Buy 3 for each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.99, 'GBP', NOW());
    END IF;

    -- ME-80B 2 HOLE EC-50PK SHS-EGG Handpiece...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ME-80B 2 HOLE EC-50PK SHS-EGG Handpiece', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 200.57, 'GBP', NOW());
    END IF;

    -- ME-80B 2 HOLE EC-50PK SHS-EGG Handpiece...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ME-80B 2 HOLE EC-50PK SHS-EGG Handpiece', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 62.85, 'GBP', NOW());
    END IF;

    -- ME-80B 2 HOLE EC-50PK SHS-EGG Handpiece...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ME-80B 2 HOLE EC-50PK SHS-EGG Handpiece', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 117.2, 'GBP', NOW());
    END IF;

    -- TCP450M 4 hole WITH LIGHT...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TCP450M 4 hole WITH LIGHT', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 149.0, 'GBP', NOW());
    END IF;

    -- TCP450B 2 hole Standard head, 25000 LUX light, 3 port...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TCP450B 2 hole Standard head, 25000 LUX light, 3 port', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 149.0, 'GBP', NOW());
    END IF;

    -- Buy 3 for each spray, 340000 rpm idle speed, ceramic...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 for each spray, 340000 rpm idle speed, ceramic', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 129.0, 'GBP', NOW());
    END IF;

    -- TI9500C...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TI9500C', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 249.0, 'GBP', NOW());
    END IF;

    -- HC7021K KaVo fitting • Simple installation into any brand of...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HC7021K KaVo fitting • Simple installation into any brand of', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 449.0, 'GBP', NOW());
    END IF;

    -- TCP200 HC7021W W&H fitting TI9500B new or existing dental un...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TCP200 HC7021W W&H fitting TI9500B new or existing dental unit', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 449.0, 'GBP', NOW());
    END IF;

    -- Triple pack • Phatellus optic hoses fit directly to...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Triple pack • Phatellus optic hoses fit directly to', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1215.0, 'GBP', NOW());
    END IF;

    -- TCP200 resistance...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TCP200 resistance', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 169.0, 'GBP', NOW());
    END IF;

    -- BUY 3 @ each • Glass fibre optic rod adaptor and PTL-4HP hos...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BUY 3 @ each • Glass fibre optic rod adaptor and PTL-4HP hose', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 149.0, 'GBP', NOW());
    END IF;

    -- and get a free connector PTLOP01 Complete Pack...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('and get a free connector PTLOP01 Complete Pack', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 322.89, 'GBP', NOW());
    END IF;

    -- PTLCM01 Control Module...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PTLCM01 Control Module', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 145.78, 'GBP', NOW());
    END IF;

    -- PTL4HP01Optic Hose...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PTL4HP01Optic Hose', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 135.1, 'GBP', NOW());
    END IF;

    -- TITANIUM LINE couplings PTLAD01 Power adaptor...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TITANIUM LINE couplings PTLAD01 Power adaptor', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 27.54, 'GBP', NOW());
    END IF;

    -- WITHOUT LIGHT TI9500BLUX...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WITHOUT LIGHT TI9500BLUX', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 299.0, 'GBP', NOW());
    END IF;

    -- TCQJM4 HC5021S Sirona fitting GLOWS OPTIC PACK...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TCQJM4 HC5021S Sirona fitting GLOWS OPTIC PACK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 359.0, 'GBP', NOW());
    END IF;

    -- HC5021K KaVo fitting...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HC5021K KaVo fitting', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 359.0, 'GBP', NOW());
    END IF;

    -- HC5021W W&H fitting...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HC5021W W&H fitting', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 359.0, 'GBP', NOW());
    END IF;

    -- TCQJM4...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TCQJM4', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 45.0, 'GBP', NOW());
    END IF;

    -- Triple pack...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Triple pack', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 969.0, 'GBP', NOW());
    END IF;

    -- QDJK01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('QDJK01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 59.0, 'GBP', NOW());
    END IF;

    -- HC2022MW QDJK02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HC2022MW QDJK02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 85.0, 'GBP', NOW());
    END IF;

    -- mid west fitting...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('mid west fitting', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 219.0, 'GBP', NOW());
    END IF;

    -- QDJK03 Light Control Module...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('QDJK03 Light Control Module', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 109.0, 'GBP', NOW());
    END IF;

    -- PL325...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PL325', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 89.0, 'GBP', NOW());
    END IF;

    -- PL325A...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PL325A', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.0, 'GBP', NOW());
    END IF;

    -- As above with 1 port spray couplings PL324C...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('As above with 1 port spray couplings PL324C', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 69.0, 'GBP', NOW());
    END IF;

    -- rates HC2001B borden fitting QDJKB01 Halogen Complete Pack...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('rates HC2001B borden fitting QDJKB01 Halogen Complete Pack', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 219.0, 'GBP', NOW());
    END IF;

    -- rates HC2001B borden fitting QDJKB01 Halogen Complete Pack...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('rates HC2001B borden fitting QDJKB01 Halogen Complete Pack', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.95, 'GBP', NOW());
    END IF;

    -- Triple pack LEDB01 LED PLSET01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Triple pack LEDB01 LED PLSET01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 590.0, 'GBP', NOW());
    END IF;

    -- Triple pack LEDB01 LED PLSET01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Triple pack LEDB01 LED PLSET01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 49.5, 'GBP', NOW());
    END IF;

    -- Triple pack LEDB01 LED PLSET01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Triple pack LEDB01 LED PLSET01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 169.0, 'GBP', NOW());
    END IF;

    -- Non-optic, latch type for use with Non-optic, push button ch...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Non-optic, latch type for use with Non-optic, push button chuck for use technologies developed throughout FX-65M', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 149.14, 'GBP', NOW());
    END IF;

    -- NAC-EC 1:1 Latch Contra Angle Handpiece offers a more secure...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('NAC-EC 1:1 Latch Contra Angle Handpiece offers a more secure grip. Stainless', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 135.15, 'GBP', NOW());
    END IF;

    -- Handpiece FPBY01 Head only steel material ensures high durab...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Handpiece FPBY01 Head only steel material ensures high durability', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 78.86, 'GBP', NOW());
    END IF;

    -- Handpiece FPBY01 Head only steel material ensures high durab...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Handpiece FPBY01 Head only steel material ensures high durability', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 83.38, 'GBP', NOW());
    END IF;

    -- Buy 3 for each and lighter weight, resulting in excellent...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 for each and lighter weight, resulting in excellent', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 72.79, 'GBP', NOW());
    END IF;

    -- NAC-Y Head only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('NAC-Y Head only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 36.18, 'GBP', NOW());
    END IF;

    -- Non-optic, latch type for use with FFB-EC FX205MM4 4 hole...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Non-optic, latch type for use with FFB-EC FX205MM4 4 hole', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 400.42, 'GBP', NOW());
    END IF;

    -- CA/RA burs diameter 2.35mm. Contra Angle Handpiece FX205Mb2 ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CA/RA burs diameter 2.35mm. Contra Angle Handpiece FX205Mb2 2 hole', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 132.81, 'GBP', NOW());
    END IF;

    -- CA/RA burs diameter 2.35mm. Contra Angle Handpiece FX205Mb2 ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CA/RA burs diameter 2.35mm. Contra Angle Handpiece FX205Mb2 2 hole', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 400.42, 'GBP', NOW());
    END IF;

    -- BB-EC 1:1 Latch Contra Thermo Disinfector Proof...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BB-EC 1:1 Latch Contra Thermo Disinfector Proof', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 146.8, 'GBP', NOW());
    END IF;

    -- Handpiece FFBY01 Head only FX-25M...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Handpiece FFBY01 Head only FX-25M', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 98.96, 'GBP', NOW());
    END IF;

    -- Handpiece FFBY01 Head only FX-25M...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Handpiece FFBY01 Head only FX-25M', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 81.04, 'GBP', NOW());
    END IF;

    -- BBY01 Head only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BBY01 Head only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 47.2, 'GBP', NOW());
    END IF;

    -- FX-25M...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('FX-25M', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 149.14, 'GBP', NOW());
    END IF;

    -- EX-6B Straight Handpiece...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EX-6B Straight Handpiece', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 121.17, 'GBP', NOW());
    END IF;

    -- Contra Angle Handpiece FX205MM4...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Contra Angle Handpiece FX205MM4', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 88.93, 'GBP', NOW());
    END IF;

    -- Contra Angle Handpiece FX205MM4...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Contra Angle Handpiece FX205MM4', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 257.12, 'GBP', NOW());
    END IF;

    -- ARECM FX205MB2...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARECM FX205MB2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 257.12, 'GBP', NOW());
    END IF;

    -- Thermo Disinfector Proof FX-15M...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Thermo Disinfector Proof FX-15M', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 102.91, 'GBP', NOW());
    END IF;

    -- EC 1:1 EC01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EC 1:1 EC01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 51.78, 'GBP', NOW());
    END IF;

    -- E16R 16:1 Reduction accessory tools provided, helping you...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('E16R 16:1 Reduction accessory tools provided, helping you', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 209.03, 'GBP', NOW());
    END IF;

    -- E64R 64:1 Reduction save on costs and reduce downtime...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('E64R 64:1 Reduction save on costs and reduce downtime', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 233.02, 'GBP', NOW());
    END IF;

    -- AREK01 EMC 1:1 FX57M products from our...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AREK01 EMC 1:1 FX57M products from our', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 65.76, 'GBP', NOW());
    END IF;

    -- Contra Angle Handpiece ER4M 4:1 Reduction heavily discounted...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Contra Angle Handpiece ER4M 4:1 Reduction heavily discounted', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 88.93, 'GBP', NOW());
    END IF;

    -- Contra Angle Handpiece ER4M 4:1 Reduction heavily discounted...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Contra Angle Handpiece ER4M 4:1 Reduction heavily discounted', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 131.04, 'GBP', NOW());
    END IF;

    -- AREMK ER10M 10:1Reduction...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AREMK ER10M 10:1Reduction', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 209.08, 'GBP', NOW());
    END IF;

    -- Thermo Disinfector Proof ER16M 16:1Reduction original and ex...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Thermo Disinfector Proof ER16M 16:1Reduction original and exclusive dustproof prices and we will', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 102.91, 'GBP', NOW());
    END IF;

    -- Thermo Disinfector Proof ER16M 16:1Reduction original and ex...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Thermo Disinfector Proof ER16M 16:1Reduction original and exclusive dustproof prices and we will', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 223.0, 'GBP', NOW());
    END IF;

    -- ARYK Head only ER64M 64:1Reduction also apply any free...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARYK Head only ER64M 64:1Reduction also apply any free', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 37.14, 'GBP', NOW());
    END IF;

    -- ARYK Head only ER64M 64:1Reduction also apply any free...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARYK Head only ER64M 64:1Reduction also apply any free', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 262.08, 'GBP', NOW());
    END IF;

    -- bulk prices on NACYC01 significantly extend the life of the...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('bulk prices on NACYC01 significantly extend the life of the', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 23.7, 'GBP', NOW());
    END IF;

    -- Buy 3 for each handpiece. offers – Advised at...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 for each handpiece. offers – Advised at', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.22, 'GBP', NOW());
    END IF;

    -- ARYKC01 FX57M...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARYKC01 FX57M', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.53, 'GBP', NOW());
    END IF;

    -- ARYKC01 FX57M...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARYKC01 FX57M', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 168.17, 'GBP', NOW());
    END IF;

    -- TIX95 1:5 Non-optic...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TIX95 1:5 Non-optic', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 643.12, 'GBP', NOW());
    END IF;

    -- TIX95L 1:5 Optic...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TIX95L 1:5 Optic', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 816.1, 'GBP', NOW());
    END IF;

    -- M95 Non-optic...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('M95 Non-optic', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 533.06, 'GBP', NOW());
    END IF;

    -- M95LOptic 1:5 speed increasing, quattro spray, nano95LS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('M95LOptic 1:5 speed increasing, quattro spray, nano95LS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 674.71, 'GBP', NOW());
    END IF;

    -- Z95L...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Z95L', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 933.04, 'GBP', NOW());
    END IF;

    -- M25 Non-optic nano95LS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('M25 Non-optic nano95LS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 358.82, 'GBP', NOW());
    END IF;

    -- M25 Non-optic nano95LS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('M25 Non-optic nano95LS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 995.25, 'GBP', NOW());
    END IF;

    -- Z25L...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Z25L', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 776.19, 'GBP', NOW());
    END IF;

    -- M25LOptic nano25LS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('M25LOptic nano25LS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 546.51, 'GBP', NOW());
    END IF;

    -- nano25LS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('nano25LS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 827.94, 'GBP', NOW());
    END IF;

    -- M15 Non-optic For use with CA/RA burs diameter 2,500 rpm max...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('M15 Non-optic For use with CA/RA burs diameter 2,500 rpm max, CA burs 2.35 dia', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 426.26, 'GBP', NOW());
    END IF;

    -- M15LOptic 2.35mm. Z10L nano15LS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('M15LOptic 2.35mm. Z10L nano15LS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 639.29, 'GBP', NOW());
    END IF;

    -- M15LOptic 2.35mm. Z10L nano15LS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('M15LOptic 2.35mm. Z10L nano15LS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 892.26, 'GBP', NOW());
    END IF;

    -- TIX25 1:1 Non-optic 4:1 speed reducing, single spray,...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TIX25 1:1 Non-optic 4:1 speed reducing, single spray,', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 435.82, 'GBP', NOW());
    END IF;

    -- Straight Handpiece TIX25L 1:1 Optic 10,000 rpm max, CA burs ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Straight Handpiece TIX25L 1:1 Optic 10,000 rpm max, CA burs 2.35 dia', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 662.35, 'GBP', NOW());
    END IF;

    -- TIX15 4:1 Non-optic nano15LS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TIX15 4:1 Non-optic nano15LS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 515.98, 'GBP', NOW());
    END IF;

    -- TIX15 4:1 Non-optic nano15LS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TIX15 4:1 Non-optic nano15LS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 896.3, 'GBP', NOW());
    END IF;

    -- TIX15L 4:1 Optic nano65LS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TIX15L 4:1 Optic nano65LS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 717.05, 'GBP', NOW());
    END IF;

    -- TIX12 10:1 Non-optic...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TIX12 10:1 Non-optic', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 545.55, 'GBP', NOW());
    END IF;

    -- TIX12L 10:1 Optic...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TIX12L 10:1 Optic', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 761.4, 'GBP', NOW());
    END IF;

    -- TIX10 16:1 Non-optic Ti Max Z45L nano65LS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TIX10 16:1 Non-optic Ti Max Z45L nano65LS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 545.55, 'GBP', NOW());
    END IF;

    -- TIX10 16:1 Non-optic Ti Max Z45L nano65LS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TIX10 16:1 Non-optic Ti Max Z45L nano65LS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 736.31, 'GBP', NOW());
    END IF;

    -- TIX10L 16:1 Optic 45° angle provides effortless access to In...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TIX10L 16:1 Optic 45° angle provides effortless access to In combination with the NLX nano', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 761.4, 'GBP', NOW());
    END IF;

    -- TimaxZ45L...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TimaxZ45L', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 901.94, 'GBP', NOW());
    END IF;

    -- TIX65 1:1 Non-optic World first - Provides LED illumination ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TIX65 1:1 Non-optic World first - Provides LED illumination from a non optic hose', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 406.58, 'GBP', NOW());
    END IF;

    -- TIX65L 1:1 Optic The micro power generator instantly convert...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TIX65L 1:1 Optic The micro power generator instantly converts non optic Borden 2 hole and Midwest', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 613.55, 'GBP', NOW());
    END IF;

    -- SMaxM205 performance is not impaired in any way...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SMaxM205 performance is not impaired in any way', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 381.94, 'GBP', NOW());
    END IF;

    -- life of the bearings. TIX205L M205LGM4...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('life of the bearings. TIX205L M205LGM4', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 676.39, 'GBP', NOW());
    END IF;

    -- life of the bearings. TIX205L M205LGM4...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('life of the bearings. TIX205L M205LGM4', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 676.39, 'GBP', NOW());
    END IF;

    -- • ISB Turbine SXMUO3...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• ISB Turbine SXMUO3', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- • Cellular Glass Optics SXSUO3...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Cellular Glass Optics SXSUO3', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- • Ceramic Bearings SXMUO3...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Ceramic Bearings SXMUO3', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- Pana Max • Clean Head System LED Light SXSUO3...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Pana Max • Clean Head System LED Light SXSUO3', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- Screw on type high speed turbine, • Push Button Chuck For NS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Screw on type high speed turbine, • Push Button Chuck For NSK with water volume adjuster Buy 3 for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 112.05, 'GBP', NOW());
    END IF;

    -- clean head system, ultra push chuck, • Quattro Spray PTL-CL-...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('clean head system, ultra push chuck, • Quattro Spray PTL-CL-LEDIII', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 162.02, 'GBP', NOW());
    END IF;

    -- NPAT03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('NPAT03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 81.32, 'GBP', NOW());
    END IF;

    -- PAXSUM4 Midwest 4 Hole • Non optic versions available for NP...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXSUM4 Midwest 4 Hole • Non optic versions available for NPAS03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 216.22, 'GBP', NOW());
    END IF;

    -- PAXSUM4 Midwest 4 Hole • Non optic versions available for NP...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXSUM4 Midwest 4 Hole • Non optic versions available for NPAS03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 81.32, 'GBP', NOW());
    END IF;

    -- PAXSUB2 Borden 2 Hole KaVo®and W&H®couplings Mini...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXSUB2 Borden 2 Hole KaVo®and W&H®couplings Mini', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 216.22, 'GBP', NOW());
    END IF;

    -- NPAM03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('NPAM03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 81.32, 'GBP', NOW());
    END IF;

    -- PAXTUM4 Midwest 4 Hole Sirona®, W&H®and Bien Air® KCL-LED Bu...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXTUM4 Midwest 4 Hole Sirona®, W&H®and Bien Air® KCL-LED Buy 3 for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 216.22, 'GBP', NOW());
    END IF;

    -- PAXTUM4 Midwest 4 Hole Sirona®, W&H®and Bien Air® KCL-LED Bu...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXTUM4 Midwest 4 Hole Sirona®, W&H®and Bien Air® KCL-LED Buy 3 for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 76.24, 'GBP', NOW());
    END IF;

    -- PAXTUB2 Borden 2 Hole For KaVo®and MULTIflex®LUX with...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXTUB2 Borden 2 Hole For KaVo®and MULTIflex®LUX with', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 216.22, 'GBP', NOW());
    END IF;

    -- KCL-LED...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KCL-LED', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 229.66, 'GBP', NOW());
    END IF;

    -- TiMU03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TiMU03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- SCL-LED for Sirona®...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SCL-LED for Sirona®', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 229.66, 'GBP', NOW());
    END IF;

    -- Mini (500) head power 16W TiSU03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Mini (500) head power 16W TiSU03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- Speed 380000-450000 rpm TiTU03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Speed 380000-450000 rpm TiTU03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- Size 10.6dia x 12.5H Buy 3 for each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Size 10.6dia x 12.5H Buy 3 for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 112.05, 'GBP', NOW());
    END IF;

    -- All non optic versions...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('All non optic versions', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 467.5, 'GBP', NOW());
    END IF;

    -- PAXPSUM4 Midwest 4 Hole NCHSU...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXPSUM4 Midwest 4 Hole NCHSU', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 230.1, 'GBP', NOW());
    END IF;

    -- PAXPSUM4 Midwest 4 Hole NCHSU...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXPSUM4 Midwest 4 Hole NCHSU', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- All optic versions...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('All optic versions', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 501.58, 'GBP', NOW());
    END IF;

    -- PAXPSUB2 Borden 2 Hole NCHTU...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXPSUB2 Borden 2 Hole NCHTU', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 230.1, 'GBP', NOW());
    END IF;

    -- PAXPSUB2 Borden 2 Hole NCHTU...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXPSUB2 Borden 2 Hole NCHTU', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- Torque Head - Size 12.1dia x 13.5H FM-CL-M4 Buy 3 for each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Torque Head - Size 12.1dia x 13.5H FM-CL-M4 Buy 3 for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 112.05, 'GBP', NOW());
    END IF;

    -- PAXPTUM4 Midwest 4 Hole...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXPTUM4 Midwest 4 Hole', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 230.1, 'GBP', NOW());
    END IF;

    -- PAXPTUB2 Borden 2 Hole Pana-Air Ultra Push...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXPTUB2 Borden 2 Hole Pana-Air Ultra Push', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 230.1, 'GBP', NOW());
    END IF;

    -- Ti-MAX X SERIES FMCLM4...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Ti-MAX X SERIES FMCLM4', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 97.03, 'GBP', NOW());
    END IF;

    -- TURBINES NPATU03 Torque...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TURBINES NPATU03 Torque', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- NPASU03 Standard...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('NPASU03 Standard', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- NSK’s Premium Series Turbines 2/3 HOLE BORDEN NPAMU03 Mini...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('NSK’s Premium Series Turbines 2/3 HOLE BORDEN NPAMU03 Mini', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- • Titanium Body with Scratch NON OPTICAL FITTING Buy 3 for e...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Titanium Body with Scratch NON OPTICAL FITTING Buy 3 for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 112.05, 'GBP', NOW());
    END IF;

    -- QD couplings • Clean Head System FM-CL-B NMCTU03 Torque...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('QD couplings • Clean Head System FM-CL-B NMCTU03 Torque', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- Standard Head - Size 10.6dia x 12.5H • Push Button Chuck Sta...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Standard Head - Size 10.6dia x 12.5H • Push Button Chuck Stainless Steel Body. NMCSU03 Standard', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- PAXQDSU • Quattro Spray FMCLB NMCMU03 Mini...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXQDSU • Quattro Spray FMCLB NMCMU03 Mini', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 256.39, 'GBP', NOW());
    END IF;

    -- PAXQDSU • Quattro Spray FMCLB NMCMU03 Mini...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXQDSU • Quattro Spray FMCLB NMCMU03 Mini', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 97.03, 'GBP', NOW());
    END IF;

    -- PAXQDSU • Quattro Spray FMCLB NMCMU03 Mini...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXQDSU • Quattro Spray FMCLB NMCMU03 Mini', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 119.52, 'GBP', NOW());
    END IF;

    -- Buy 3 for each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 112.05, 'GBP', NOW());
    END IF;

    -- PAXQDTU • 3 head sizes available...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PAXQDTU • 3 head sizes available', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 256.39, 'GBP', NOW());
    END IF;

    -- Connects Borden handpieces to Mid FBRO01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Connects Borden handpieces to Mid FBRO01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 25.58, 'GBP', NOW());
    END IF;

    -- ADAPT01 B to MW FBRO02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ADAPT01 B to MW FBRO02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.95, 'GBP', NOW());
    END IF;

    -- ADAPT01 B to MW FBRO02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ADAPT01 B to MW FBRO02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 25.58, 'GBP', NOW());
    END IF;

    -- ADAPT02 MW to B Buy a 3 pack for...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ADAPT02 MW to B Buy a 3 pack for', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.95, 'GBP', NOW());
    END IF;

    -- ADAPT02 MW to B Buy a 3 pack for...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ADAPT02 MW to B Buy a 3 pack for', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 61.4, 'GBP', NOW());
    END IF;

    -- QDJC01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('QDJC01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 77.62, 'GBP', NOW());
    END IF;

    -- QDJC02 All optic versions...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('QDJC02 All optic versions', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 77.62, 'GBP', NOW());
    END IF;

    -- QDJC02 All optic versions...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('QDJC02 All optic versions', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 677.62, 'GBP', NOW());
    END IF;

    -- QDJNLED...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('QDJNLED', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 99.0, 'GBP', NOW());
    END IF;

    -- Used together, the MX2 and Micro- RRP save 25%...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Used together, the MX2 and Micro- RRP save 25%', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 183.0, 'GBP', NOW());
    END IF;

    -- Used together, the MX2 and Micro- RRP save 25%...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Used together, the MX2 and Micro- RRP save 25%', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 137.25, 'GBP', NOW());
    END IF;

    -- RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 267.0, 'GBP', NOW());
    END IF;

    -- RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 226.95, 'GBP', NOW());
    END IF;

    -- RRP save 25% end of the day. 12 months warranty BAUNI03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% end of the day. 12 months warranty BAUNI03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 737.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% end of the day. 12 months warranty BAUNI03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% end of the day. 12 months warranty BAUNI03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 552.75, 'GBP', NOW());
    END IF;

    -- RRP save 25%...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25%', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 183.0, 'GBP', NOW());
    END IF;

    -- RRP save 25%...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25%', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 137.25, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 933.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 699.75, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 357.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 303.45, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 994.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 745.5, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 425.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 361.25, 'GBP', NOW());
    END IF;

    -- RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1125.0, 'GBP', NOW());
    END IF;

    -- RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 956.25, 'GBP', NOW());
    END IF;

    -- BAMCA1L 1:1 direct RRP save 25%...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BAMCA1L 1:1 direct RRP save 25%', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 700.0, 'GBP', NOW());
    END IF;

    -- BAMCA1L 1:1 direct RRP save 25%...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BAMCA1L 1:1 direct RRP save 25%', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 525.0, 'GBP', NOW());
    END IF;

    -- RRP save 25%...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25%', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 867.0, 'GBP', NOW());
    END IF;

    -- RRP save 25%...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25%', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 650.25, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP 25% off...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP 25% off', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 493.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP 25% off...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP 25% off', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 369.75, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP 25% off...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP 25% off', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 901.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP 25% off...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP 25% off', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 675.75, 'GBP', NOW());
    END IF;

    -- RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1033.0, 'GBP', NOW());
    END IF;

    -- RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 774.75, 'GBP', NOW());
    END IF;

    -- RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2450.0, 'GBP', NOW());
    END IF;

    -- RRP only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1837.5, 'GBP', NOW());
    END IF;

    -- RRP save 25% details of...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% details of', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 755.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% details of...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% details of', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 566.25, 'GBP', NOW());
    END IF;

    -- RRP save 25% Standard head, dual optics glass rod, Bien Air®...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% Standard head, dual optics glass rod, Bien Air®', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 500.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% Standard head, dual optics glass rod, Bien Air®...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% Standard head, dual optics glass rod, Bien Air®', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 375.0, 'GBP', NOW());
    END IF;

    -- BACA1L 1:1 direct RRP 25% off...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BACA1L 1:1 direct RRP 25% off', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1050.0, 'GBP', NOW());
    END IF;

    -- BACA1L 1:1 direct RRP 25% off...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BACA1L 1:1 direct RRP 25% off', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 787.5, 'GBP', NOW());
    END IF;

    -- RRP save 25% special...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% special', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 867.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% special...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% special', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 650.25, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP 25% off promotions...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP 25% off promotions', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1040.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP 25% off promotions...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP 25% off promotions', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 780.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP 25% off promotions...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP 25% off promotions', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2900.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP 25% off promotions...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP 25% off promotions', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2175.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP save 25% available at same rates as above...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP save 25% available at same rates as above', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1109.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP save 25% available at same rates as above...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP save 25% available at same rates as above', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 831.75, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP save 25% available at same rates as above...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP save 25% available at same rates as above', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 493.0, 'GBP', NOW());
    END IF;

    -- RRP save 25% RRP save 25% available at same rates as above...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RRP save 25% RRP save 25% available at same rates as above', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 369.75, 'GBP', NOW());
    END IF;

    -- TEQ-E10R shank files...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TEQ-E10R shank files', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 285.33, 'GBP', NOW());
    END IF;

    -- TEQ-E 1.1 MPAF16R 20:1 Reduction implant handpiece...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TEQ-E 1.1 MPAF16R 20:1 Reduction implant handpiece', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 151.95, 'GBP', NOW());
    END IF;

    -- TEQ-E 1.1 MPAF16R 20:1 Reduction implant handpiece...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TEQ-E 1.1 MPAF16R 20:1 Reduction implant handpiece', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 252.2, 'GBP', NOW());
    END IF;

    -- torque calibration enabling optimum SG-20...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('torque calibration enabling optimum SG-20', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 628.91, 'GBP', NOW());
    END IF;

    -- for hand files 1/4 Turn Endodontic with MPASF16R 8programs, ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('for hand files 1/4 Turn Endodontic with MPASF16R 8programs, motor speed 200-40000.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 252.2, 'GBP', NOW());
    END IF;

    -- TEP-E10R reduction handpiece...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TEP-E10R reduction handpiece', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 285.37, 'GBP', NOW());
    END IF;

    -- SURGPRO2 RRP POA...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SURGPRO2 RRP POA', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4680.0, 'GBP', NOW());
    END IF;

    -- With Apex locator head...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('With Apex locator head', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1091.12, 'GBP', NOW());
    END IF;

    -- MPER64...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MPER64', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 303.65, 'GBP', NOW());
    END IF;

    -- X-SG20L 20:1 reduction...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('X-SG20L 20:1 reduction', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 745.0, 'GBP', NOW());
    END IF;

    -- 2.35mm 1:1 direct drive. X-SG25L 1:1 direct...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('2.35mm 1:1 direct drive. X-SG25L 1:1 direct', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 571.74, 'GBP', NOW());
    END IF;

    -- 128:1 Reduction, Miniature Head. 360º SGS-ES...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('128:1 Reduction, Miniature Head. 360º SGS-ES', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 292.37, 'GBP', NOW());
    END IF;

    -- precisely detect the location of the IMPLANT HANDPIECES X-SG...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('precisely detect the location of the IMPLANT HANDPIECES X-SG93L 1:3 increasing', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 711.41, 'GBP', NOW());
    END IF;

    -- Ti-ENDO provides the precise torque iPEX PACK...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Ti-ENDO provides the precise torque iPEX PACK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 593.57, 'GBP', NOW());
    END IF;

    -- Ti-ENDO ⁰...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Ti-ENDO ⁰', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 557.43, 'GBP', NOW());
    END IF;

    -- Works equally well in wet or dry SGM-ER20i 20:1 Straight 1:1...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Works equally well in wet or dry SGM-ER20i 20:1 Straight 1:1 drive, titanium body with', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 345.86, 'GBP', NOW());
    END IF;

    -- volume. Unit supplied with 4 lip hooks, SGM-ER64i 64:1 burs ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('volume. Unit supplied with 4 lip hooks, SGM-ER64i 64:1 burs 2.35ø (with supplied bur stopper),', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 375.39, 'GBP', NOW());
    END IF;

    -- \16:1 Reduction, miniature head, for 2 apex fire holders 2 a...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('\16:1 Reduction, miniature head, for 2 apex fire holders 2 apex probe leads SGM-ER256i 256:1 external cooling, max speed', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 398.49, 'GBP', NOW());
    END IF;

    -- MPF16R DENAP01 depth indicator TiSG65L 1:1...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MPF16R DENAP01 depth indicator TiSG65L 1:1', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 192.19, 'GBP', NOW());
    END IF;

    -- MPF16R DENAP01 depth indicator TiSG65L 1:1...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MPF16R DENAP01 depth indicator TiSG65L 1:1', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 215.0, 'GBP', NOW());
    END IF;

    -- MPF16R DENAP01 depth indicator TiSG65L 1:1...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MPF16R DENAP01 depth indicator TiSG65L 1:1', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 515.32, 'GBP', NOW());
    END IF;

    -- MPF16R DENAP01 depth indicator TiSG65L 1:1...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MPF16R DENAP01 depth indicator TiSG65L 1:1', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 545.43, 'GBP', NOW());
    END IF;

    -- HPN01(Multiflex) Care3 Plus to facilitate handpiece...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HPN01(Multiflex) Care3 Plus to facilitate handpiece', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.95, 'GBP', NOW());
    END IF;

    -- Buy 3 for to 3 handpieces at one time with the...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 for to 3 handpieces at one time with the', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.0, 'GBP', NOW());
    END IF;

    -- • Ergonomic hand piece TKP01 1 CAN and durability. Apply Pan...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Ergonomic hand piece TKP01 1 CAN and durability. Apply Pana', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.8, 'GBP', NOW());
    END IF;

    -- • User friendly interface 12 CANS each any handpiece or air ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• User friendly interface 12 CANS each any handpiece or air motor.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.25, 'GBP', NOW());
    END IF;

    -- • 10 preset options PANASPRAY 500ml can...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• 10 preset options PANASPRAY 500ml can', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 21.24, 'GBP', NOW());
    END IF;

    -- HANDPIECE OIL 6 x 500ml cans...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HANDPIECE OIL 6 x 500ml cans', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 114.65, 'GBP', NOW());
    END IF;

    -- at each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('at each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 72.78, 'GBP', NOW());
    END IF;

    -- AS2000B...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AS2000B', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 327.18, 'GBP', NOW());
    END IF;

    -- Universal Type Tip Midwest 4 hole fitting Air powered tooth ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Universal Type Tip Midwest 4 hole fitting Air powered tooth polishing system.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 510.0, 'GBP', NOW());
    END IF;

    -- AS2000M • Excellent weight balance...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AS2000M • Excellent weight balance', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 327.18, 'GBP', NOW());
    END IF;

    -- TITANG...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TITANG', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.0, 'GBP', NOW());
    END IF;

    -- TITANTS Sickle tip...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TITANTS Sickle tip', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 42.5, 'GBP', NOW());
    END IF;

    -- Universal TITANTU Universal tip...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Universal TITANTU Universal tip', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 42.5, 'GBP', NOW());
    END IF;

    -- TITANTP Perio tip...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TITANTP Perio tip', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 42.5, 'GBP', NOW());
    END IF;

    -- with push on silicone protector. PMN01 Set...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('with push on silicone protector. PMN01 Set', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 657.41, 'GBP', NOW());
    END IF;

    -- AIRSCALE01 Perio S3...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AIRSCALE01 Perio S3', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 199.0, 'GBP', NOW());
    END IF;

    -- AIRSCALE03 Universal tip...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AIRSCALE03 Universal tip', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 31.25, 'GBP', NOW());
    END IF;

    -- AIRSCALE04 Sickle tip...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AIRSCALE04 Sickle tip', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 31.25, 'GBP', NOW());
    END IF;

    -- AIRSCALE05 Perio tip...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AIRSCALE05 Perio tip', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 31.25, 'GBP', NOW());
    END IF;

    -- AS2000TIP1...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AS2000TIP1', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 48.0, 'GBP', NOW());
    END IF;

    -- Buy 3 tips for each Prophy 300 Air...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 tips for each Prophy 300 Air', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 27.5, 'GBP', NOW());
    END IF;

    -- AS2000TIP2...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AS2000TIP2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 48.0, 'GBP', NOW());
    END IF;

    -- AS2000TIP3 Economical stain and plaque remover,...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AS2000TIP3 Economical stain and plaque remover,', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 48.0, 'GBP', NOW());
    END IF;

    -- Solid titanium body. 3 Level power ring, 6000, Hz elliptical...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Solid titanium body. 3 Level power ring, 6000, Hz elliptical movement, complete PROP300B2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 199.0, 'GBP', NOW());
    END IF;

    -- S1,S2,S3 wrench and cover. Available Non optic PROP300M4...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('S1,S2,S3 wrench and cover. Available Non optic PROP300M4', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 199.0, 'GBP', NOW());
    END IF;

    -- S950 KAVOSF05 Universal No.5 Flash Pearl...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('S950 KAVOSF05 Universal No.5 Flash Pearl', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 687.25, 'GBP', NOW());
    END IF;

    -- S950 KAVOSF05 Universal No.5 Flash Pearl...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('S950 KAVOSF05 Universal No.5 Flash Pearl', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 85.0, 'GBP', NOW());
    END IF;

    -- Optic KASVOFG06 SICKLE No.6...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Optic KASVOFG06 SICKLE No.6', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 85.0, 'GBP', NOW());
    END IF;

    -- S950L KAVOSF07 Perio No.7...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('S950L KAVOSF07 Perio No.7', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 802.75, 'GBP', NOW());
    END IF;

    -- S950L KAVOSF07 Perio No.7...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('S950L KAVOSF07 Perio No.7', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 85.0, 'GBP', NOW());
    END IF;

    -- design, easy maintenance with FLASHPS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('design, easy maintenance with FLASHPS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 117.92, 'GBP', NOW());
    END IF;

    -- GK1 Universal...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GK1 Universal', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 35.0, 'GBP', NOW());
    END IF;

    -- plaque are quickly erased FLASHPB...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('plaque are quickly erased FLASHPB', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 85.69, 'GBP', NOW());
    END IF;

    -- GK2 Interproximal...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GK2 Interproximal', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 35.0, 'GBP', NOW());
    END IF;

    -- GK3 Perio...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GK3 Perio', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 35.0, 'GBP', NOW());
    END IF;

    -- GK4 Longer tip Perio...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GK4 Longer tip Perio', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 35.0, 'GBP', NOW());
    END IF;

    -- PROP600B2...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PROP600B2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 195.0, 'GBP', NOW());
    END IF;

    -- Buy 3 for each Midwest...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 for each Midwest', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- PROP600M4 130g bottle...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PROP600M4 130g bottle', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 195.0, 'GBP', NOW());
    END IF;

    -- Replacement Tip PLP01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Replacement Tip PLP01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.95, 'GBP', NOW());
    END IF;

    -- PROTIP 6 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PROTIP 6 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- PROTIP 6 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PROTIP 6 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.95, 'GBP', NOW());
    END IF;

    -- ULTRASONIC PIEZO STYLE SCALERS Buy any 3 tips below each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ULTRASONIC PIEZO STYLE SCALERS Buy any 3 tips below each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 25.0, 'GBP', NOW());
    END IF;

    -- WOOD14 EMS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WOOD14 EMS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- WOOD22 Satelec and NSK...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WOOD22 Satelec and NSK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- As above but with LED handpiece handpiece hypochlorite via t...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('As above but with LED handpiece handpiece hypochlorite via the water bottle system WOOD15 EMS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- SATP5NEWLED • Vibration frequency 28kHz WOOD23 Satelec and N...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SATP5NEWLED • Vibration frequency 28kHz WOOD23 Satelec and NSK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1263.2, 'GBP', NOW());
    END IF;

    -- SATP5NEWLED • Vibration frequency 28kHz WOOD23 Satelec and N...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SATP5NEWLED • Vibration frequency 28kHz WOOD23 Satelec and NSK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- Satelec Scaler Handpiece WOOD17...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Satelec Scaler Handpiece WOOD17', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 399.0, 'GBP', NOW());
    END IF;

    -- SATHPKIT WOOD18 DTE-D7...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SATHPKIT WOOD18 DTE-D7', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 210.0, 'GBP', NOW());
    END IF;

    -- SATHPKIT WOOD18 DTE-D7...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SATHPKIT WOOD18 DTE-D7', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 399.0, 'GBP', NOW());
    END IF;

    -- WOOD05 EMS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WOOD05 EMS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- WOOD24 Satelec and NSK...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WOOD24 Satelec and NSK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- • EMS style handpiece WOOD13 EMS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• EMS style handpiece WOOD13 EMS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- • Detachable autoclavable handpiece WOOD25 Satelec and NSK...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Detachable autoclavable handpiece WOOD25 Satelec and NSK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- SATN02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SATN02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 54.95, 'GBP', NOW());
    END IF;

    -- SAT04 complete with 6 tips: 2 x GD1, 1 x WOOD01 P1/PD1...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SAT04 complete with 6 tips: 2 x GD1, 1 x WOOD01 P1/PD1', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 54.95, 'GBP', NOW());
    END IF;

    -- SAT04 complete with 6 tips: 2 x GD1, 1 x WOOD01 P1/PD1...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SAT04 complete with 6 tips: 2 x GD1, 1 x WOOD01 P1/PD1', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 319.0, 'GBP', NOW());
    END IF;

    -- SAT1S...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SAT1S', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 54.95, 'GBP', NOW());
    END IF;

    -- WOOD16 EMS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WOOD16 EMS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- WOOD31...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WOOD31', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 295.0, 'GBP', NOW());
    END IF;

    -- Interproximal recommended for the WOOD20 Satelec...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Interproximal recommended for the WOOD20 Satelec', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- SAT03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SAT03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 54.95, 'GBP', NOW());
    END IF;

    -- WOOD28 WOOD04 EMS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WOOD28 WOOD04 EMS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 349.0, 'GBP', NOW());
    END IF;

    -- WOOD28 WOOD04 EMS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WOOD28 WOOD04 EMS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- WOOD21 Satelec...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WOOD21 Satelec', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- WOOD19...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WOOD19', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 144.0, 'GBP', NOW());
    END IF;

    -- ARTMB325K flat and tip changer scaler. WOOD32 Satelec and NS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTMB325K flat and tip changer scaler. WOOD32 Satelec and NSK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 399.0, 'GBP', NOW());
    END IF;

    -- ARTMB325K flat and tip changer scaler. WOOD32 Satelec and NS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTMB325K flat and tip changer scaler. WOOD32 Satelec and NSK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- ARTMB330K ARTP6 WOOD02 WOOD12 6 x U Files Size 25...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTMB330K ARTP6 WOOD02 WOOD12 6 x U Files Size 25', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 399.0, 'GBP', NOW());
    END IF;

    -- ARTMB330K ARTP6 WOOD02 WOOD12 6 x U Files Size 25...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTMB330K ARTP6 WOOD02 WOOD12 6 x U Files Size 25', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 299.0, 'GBP', NOW());
    END IF;

    -- ARTMB330K ARTP6 WOOD02 WOOD12 6 x U Files Size 25...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTMB330K ARTP6 WOOD02 WOOD12 6 x U Files Size 25', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 144.0, 'GBP', NOW());
    END IF;

    -- ARTMB330K ARTP6 WOOD02 WOOD12 6 x U Files Size 25...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTMB330K ARTP6 WOOD02 WOOD12 6 x U Files Size 25', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.5, 'GBP', NOW());
    END IF;

    -- Buy any 3 tips below each ULTRASONIC INSERT STYLE SCALERS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy any 3 tips below each ULTRASONIC INSERT STYLE SCALERS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 25.0, 'GBP', NOW());
    END IF;

    -- ART MB3 25K...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ART MB3 25K', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 379.0, 'GBP', NOW());
    END IF;

    -- ART MB3 30K...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ART MB3 30K', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 379.0, 'GBP', NOW());
    END IF;

    -- WOOD33 EMS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WOOD33 EMS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- WOOD34 Satelec and NSK...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WOOD34 Satelec and NSK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- ART25INS04 ART25INS05...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ART25INS04 ART25INS05', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- ART25INS04 ART25INS05...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ART25INS04 ART25INS05', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- ARTTIPS1 magnetostrictive ultrasonic scaler 30K UNIVERSAL ME...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTTIPS1 magnetostrictive ultrasonic scaler 30K UNIVERSAL METAL INSERT 30K UNIVERSAL METAL SLIM INSERT', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- ART30INS04 ART30INS05...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ART30INS04 ART30INS05', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- ART30INS04 ART30INS05...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ART30INS04 ART30INS05', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- ARTTIPSE1 pump, simple and precise control,...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTTIPSE1 pump, simple and precise control,', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- ARTTIPS2...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTTIPS2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- ARTTIPE2...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTTIPE2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- ARTM3II25K (25k) CAV30KTB ART30INS02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTM3II25K (25k) CAV30KTB ART30INS02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 495.0, 'GBP', NOW());
    END IF;

    -- ARTM3II25K (25k) CAV30KTB ART30INS02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTM3II25K (25k) CAV30KTB ART30INS02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- ARTM3II25K (25k) CAV30KTB ART30INS02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTM3II25K (25k) CAV30KTB ART30INS02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- ARTTIPS3...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTTIPS3', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- ARTTIPE3 25K UNIVERSAL INSERT 25K SLIM INSERT...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTTIPE3 25K UNIVERSAL INSERT 25K SLIM INSERT', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- ART25INS01 ART25INS03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ART25INS01 ART25INS03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- ART25INS01 ART25INS03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ART25INS01 ART25INS03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- ART30INS01 ART30INS03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ART30INS01 ART30INS03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- ART30INS01 ART30INS03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ART30INS01 ART30INS03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- Buy any 3 of the above for each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy any 3 of the above for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 36.0, 'GBP', NOW());
    END IF;

    -- WOOD08 Ultrasonic Scaling Unit...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WOOD08 Ultrasonic Scaling Unit', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 14.95, 'GBP', NOW());
    END IF;

    -- CAV103 Each Replacement O Rings...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CAV103 Each Replacement O Rings', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.5, 'GBP', NOW());
    END IF;

    -- WOOD07 power setting and operation mode...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WOOD07 power setting and operation mode', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.0, 'GBP', NOW());
    END IF;

    -- ART325 (25k)...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ART325 (25k)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 325.0, 'GBP', NOW());
    END IF;

    -- ART330 (30k)...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ART330 (30k)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 325.0, 'GBP', NOW());
    END IF;

    -- 1/4ADAPT2...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('1/4ADAPT2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.0, 'GBP', NOW());
    END IF;

    -- 1/4ADAPT3...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('1/4ADAPT3', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.0, 'GBP', NOW());
    END IF;

    -- worktop footprint. ARTSPA25K insert only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('worktop footprint. ARTSPA25K insert only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- Buy a pair for...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy a pair for', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 18.0, 'GBP', NOW());
    END IF;

    -- ELDENT01 ARTSPA30K ARTENDO120...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ELDENT01 ARTSPA30K ARTENDO120', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 399.0, 'GBP', NOW());
    END IF;

    -- ELDENT01 ARTSPA30K ARTENDO120...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ELDENT01 ARTSPA30K ARTENDO120', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- ELDENT01 ARTSPA30K ARTENDO120...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ELDENT01 ARTSPA30K ARTENDO120', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- NLXSET01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('NLXSET01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1536.74, 'GBP', NOW());
    END IF;

    -- PLPS680...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PLPS680', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 695.0, 'GBP', NOW());
    END IF;

    -- MC3LED for only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MC3LED for only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 624.75, 'GBP', NOW());
    END IF;

    -- MC3LED for only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MC3LED for only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 399.0, 'GBP', NOW());
    END IF;

    -- solution. The pH shock, so induced, PLEWS6802...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('solution. The pH shock, so induced, PLEWS6802', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 435.0, 'GBP', NOW());
    END IF;

    -- system and removal of all residues no M40LED...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('system and removal of all residues no M40LED', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 661.98, 'GBP', NOW());
    END IF;

    -- matter how stubborn. Ensure all M40N non optic...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('matter how stubborn. Ensure all M40N non optic', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 415.99, 'GBP', NOW());
    END IF;

    -- • Foot speed controller ANTH02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Foot speed controller ANTH02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.95, 'GBP', NOW());
    END IF;

    -- • 4000-20000 rpm ANTH03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• 4000-20000 rpm ANTH03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.95, 'GBP', NOW());
    END IF;

    -- Data Sheets LXC-12V02 MX2-LED ANTH04...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Data Sheets LXC-12V02 MX2-LED ANTH04', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 330.0, 'GBP', NOW());
    END IF;

    -- Data Sheets LXC-12V02 MX2-LED ANTH04...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Data Sheets LXC-12V02 MX2-LED ANTH04', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 620.25, 'GBP', NOW());
    END IF;

    -- Data Sheets LXC-12V02 MX2-LED ANTH04...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Data Sheets LXC-12V02 MX2-LED ANTH04', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.95, 'GBP', NOW());
    END IF;

    -- ALP001 BRS full starter kit LXC-12V01 ANTH05...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALP001 BRS full starter kit LXC-12V01 ANTH05', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 99.5, 'GBP', NOW());
    END IF;

    -- ALP001 BRS full starter kit LXC-12V01 ANTH05...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALP001 BRS full starter kit LXC-12V01 ANTH05', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 260.0, 'GBP', NOW());
    END IF;

    -- ALP001 BRS full starter kit LXC-12V01 ANTH05...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALP001 BRS full starter kit LXC-12V01 ANTH05', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.95, 'GBP', NOW());
    END IF;

    -- ALP003 Alpron 5L refill LXC-125 ANTH06...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALP003 Alpron 5L refill LXC-125 ANTH06', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 149.5, 'GBP', NOW());
    END IF;

    -- ALP003 Alpron 5L refill LXC-125 ANTH06...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALP003 Alpron 5L refill LXC-125 ANTH06', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 156.2, 'GBP', NOW());
    END IF;

    -- ALP003 Alpron 5L refill LXC-125 ANTH06...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALP003 Alpron 5L refill LXC-125 ANTH06', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 34.95, 'GBP', NOW());
    END IF;

    -- ALP005 Dip Slide LB-20EMJ (Jack) Set spare wires 2 x 150mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALP005 Dip Slide LB-20EMJ (Jack) Set spare wires 2 x 150mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- ALP005 Dip Slide LB-20EMJ (Jack) Set spare wires 2 x 150mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALP005 Dip Slide LB-20EMJ (Jack) Set spare wires 2 x 150mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 129.8, 'GBP', NOW());
    END IF;

    -- ALP006 Dip Slide Pack 10 LB-20EM (Din) MCX-LED ANTH08...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALP006 Dip Slide Pack 10 LB-20EM (Din) MCX-LED ANTH08', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.95, 'GBP', NOW());
    END IF;

    -- ALP006 Dip Slide Pack 10 LB-20EM (Din) MCX-LED ANTH08...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALP006 Dip Slide Pack 10 LB-20EM (Din) MCX-LED ANTH08', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 129.8, 'GBP', NOW());
    END IF;

    -- ALP006 Dip Slide Pack 10 LB-20EM (Din) MCX-LED ANTH08...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALP006 Dip Slide Pack 10 LB-20EM (Din) MCX-LED ANTH08', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 561.0, 'GBP', NOW());
    END IF;

    -- ALP006 Dip Slide Pack 10 LB-20EM (Din) MCX-LED ANTH08...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALP006 Dip Slide Pack 10 LB-20EM (Din) MCX-LED ANTH08', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 34.95, 'GBP', NOW());
    END IF;

    -- Assistant stool, 12" gas lift with SRS08...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Assistant stool, 12" gas lift with SRS08', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 235.0, 'GBP', NOW());
    END IF;

    -- GRA14 free float action, lockable position, foot-...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GRA14 free float action, lockable position, foot-', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 265.0, 'GBP', NOW());
    END IF;

    -- SRA07...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SRA07', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 325.0, 'GBP', NOW());
    END IF;

    -- GRS13...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GRS13', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 225.0, 'GBP', NOW());
    END IF;

    -- SRS07...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SRS07', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 295.0, 'GBP', NOW());
    END IF;

    -- F1STOOL01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('F1STOOL01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 270.0, 'GBP', NOW());
    END IF;

    -- GRA11 SRA09...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GRA11 SRA09', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 270.0, 'GBP', NOW());
    END IF;

    -- GRA11...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GRA11', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 215.0, 'GBP', NOW());
    END IF;

    -- GRS12 Surgeon saddle stool, ergonomically...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GRS12 Surgeon saddle stool, ergonomically', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 175.0, 'GBP', NOW());
    END IF;

    -- F1PONY designed to retain correct posture, tilt...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('F1PONY designed to retain correct posture, tilt', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 325.0, 'GBP', NOW());
    END IF;

    -- Available in Fimet GMS10...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Available in Fimet GMS10', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 315.0, 'GBP', NOW());
    END IF;

    -- SRA05...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SRA05', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 335.0, 'GBP', NOW());
    END IF;

    -- ASPI07...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ASPI07', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2025.0, 'GBP', NOW());
    END IF;

    -- FCCB with adaptors 1.3mts...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('FCCB with adaptors 1.3mts', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 140.0, 'GBP', NOW());
    END IF;

    -- BEWALL01 Fimet package. CAT22 16mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BEWALL01 Fimet package. CAT22 16mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1850.0, 'GBP', NOW());
    END IF;

    -- BEWALL01 Fimet package. CAT22 16mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BEWALL01 Fimet package. CAT22 16mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.0, 'GBP', NOW());
    END IF;

    -- • Standard main power • HTM 2030 and HTM 01-05 compliant 3EZ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Standard main power • HTM 2030 and HTM 01-05 compliant 3EZYME 4 litre', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 62.5, 'GBP', NOW());
    END IF;

    -- MAXIM05 5 Litre...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MAXIM05 5 Litre', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 42.5, 'GBP', NOW());
    END IF;

    -- MDCK25 25 pack...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MDCK25 25 pack', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 55.0, 'GBP', NOW());
    END IF;

    -- PICO XXL 2 x 25 pack...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PICO XXL 2 x 25 pack', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 99.5, 'GBP', NOW());
    END IF;

    -- 4 x 25 pack AWT01 2 x 0.5L...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('4 x 25 pack AWT01 2 x 0.5L', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 195.0, 'GBP', NOW());
    END IF;

    -- 4 x 25 pack AWT01 2 x 0.5L...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('4 x 25 pack AWT01 2 x 0.5L', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.45, 'GBP', NOW());
    END IF;

    -- AWT02 6 x 0.5L...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AWT02 6 x 0.5L', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 78.75, 'GBP', NOW());
    END IF;

    -- MDCKINC...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MDCKINC', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 149.0, 'GBP', NOW());
    END IF;

    -- handpiece manifold. 1 x PCD and 10 CEI test strips EXTENDED ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('handpiece manifold. 1 x PCD and 10 CEI test strips EXTENDED CAPACITY MODELS & ACCESSORIES', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 89.25, 'GBP', NOW());
    END IF;

    -- PICO04 POA MEDICEI10 CEI 10 pack strips AVAILABLE ON REQUEST...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PICO04 POA MEDICEI10 CEI 10 pack strips AVAILABLE ON REQUEST', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 47.25, 'GBP', NOW());
    END IF;

    -- touchscreen display CU100A...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('touchscreen display CU100A', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 179.0, 'GBP', NOW());
    END IF;

    -- • Sterilizing temp 134° to 138° for light SELEBU...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Sterilizing temp 134° to 138° for light SELEBU', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 21.5, 'GBP', NOW());
    END IF;

    -- CU100ALG...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CU100ALG', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 49.0, 'GBP', NOW());
    END IF;

    -- ULTRA1800E Radiical and Radiiplus...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ULTRA1800E Radiical and Radiiplus', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 395.0, 'GBP', NOW());
    END IF;

    -- RADIIC01 Cal light...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RADIIC01 Cal light', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 395.0, 'GBP', NOW());
    END IF;

    -- RADIP01 Plus light...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RADIP01 Plus light', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 565.0, 'GBP', NOW());
    END IF;

    -- ACUA12B sterilisers handpiece...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ACUA12B sterilisers handpiece', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3250.0, 'GBP', NOW());
    END IF;

    -- • Easy to record and interpret small hands RADIIP06 bleach a...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Easy to record and interpret small hands RADIIP06 bleach arch kit', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 249.0, 'GBP', NOW());
    END IF;

    -- MEDBD01 • Built-in light check in the charger RADIIP07 bleac...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MEDBD01 • Built-in light check in the charger RADIIP07 bleach arch stand', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 59.95, 'GBP', NOW());
    END IF;

    -- pack 20 sheets • 5 second audible bleep for “eyes- Light Met...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('pack 20 sheets • 5 second audible bleep for “eyes- Light Meter', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 54.6, 'GBP', NOW());
    END IF;

    -- ULTRA1000E...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ULTRA1000E', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 325.0, 'GBP', NOW());
    END IF;

    -- and chiropody surgeries 134 C 3 mins x 100 LED-C MET200...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('and chiropody surgeries 134 C 3 mins x 100 LED-C MET200', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 13.5, 'GBP', NOW());
    END IF;

    -- and chiropody surgeries 134 C 3 mins x 100 LED-C MET200...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('and chiropody surgeries 134 C 3 mins x 100 LED-C MET200', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 59.95, 'GBP', NOW());
    END IF;

    -- ACUA4 MEDSAT01 19mm x 50mts LEDC WOOD29...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ACUA4 MEDSAT01 19mm x 50mts LEDC WOOD29', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2395.0, 'GBP', NOW());
    END IF;

    -- ACUA4 MEDSAT01 19mm x 50mts LEDC WOOD29...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ACUA4 MEDSAT01 19mm x 50mts LEDC WOOD29', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.6, 'GBP', NOW());
    END IF;

    -- ACUA4 MEDSAT01 19mm x 50mts LEDC WOOD29...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ACUA4 MEDSAT01 19mm x 50mts LEDC WOOD29', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 149.0, 'GBP', NOW());
    END IF;

    -- ACUA4 MEDSAT01 19mm x 50mts LEDC WOOD29...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ACUA4 MEDSAT01 19mm x 50mts LEDC WOOD29', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 185.0, 'GBP', NOW());
    END IF;

    -- sensor driver. UltiMax works with Windows XP, Vista and Seve...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('sensor driver. UltiMax works with Windows XP, Vista and Seven both 32 and 64bit versions ORAC01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 395.0, 'GBP', NOW());
    END IF;

    -- ORAC011...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ORAC011', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 49.5, 'GBP', NOW());
    END IF;

    -- lOX3l RRP IOX32 RRP lOX33 RRP...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('lOX3l RRP IOX32 RRP lOX33 RRP', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3995.0, 'GBP', NOW());
    END IF;

    -- lOX3l RRP IOX32 RRP lOX33 RRP...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('lOX3l RRP IOX32 RRP lOX33 RRP', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4795.0, 'GBP', NOW());
    END IF;

    -- lOX3l RRP IOX32 RRP lOX33 RRP...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('lOX3l RRP IOX32 RRP lOX33 RRP', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7495.0, 'GBP', NOW());
    END IF;

    -- VIEW01 capsules. Speed 4200opm. Italian • Economical Alginat...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('VIEW01 capsules. Speed 4200opm. Italian • Economical Alginate Mixer', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 120.0, 'GBP', NOW());
    END IF;

    -- please ring ALMT01 • 15 minute timer • Mixing free from bubb...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('please ring ALMT01 • 15 minute timer • Mixing free from bubbles and lumps', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 195.0, 'GBP', NOW());
    END IF;

    -- U95 ALGMIX01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('U95 ALGMIX01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 215.0, 'GBP', NOW());
    END IF;

    -- U95 ALGMIX01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('U95 ALGMIX01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 149.0, 'GBP', NOW());
    END IF;

    -- U300...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('U300', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 349.0, 'GBP', NOW());
    END IF;

    -- VIEW02 • Digital LED shows speed and time...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('VIEW02 • Digital LED shows speed and time', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 79.5, 'GBP', NOW());
    END IF;

    -- ALMTG7 (W x D x H) • 5" lens with cover...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALMTG7 (W x D x H) • 5" lens with cover', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 159.0, 'GBP', NOW());
    END IF;

    -- MAGNIFY01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MAGNIFY01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 34.95, 'GBP', NOW());
    END IF;

    -- at over . Validation:• Dual cycle traceability SEALING MACHI...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('at over . Validation:• Dual cycle traceability SEALING MACHINE', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 20.0, 'GBP', NOW());
    END IF;

    -- WTD01 Distiller • SD port for digital cycle traceability...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WTD01 Distiller • SD port for digital cycle traceability', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 199.0, 'GBP', NOW());
    END IF;

    -- WTD02 Cleaner Ultramat 2 • Integral printer provides hard co...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WTD02 Cleaner Ultramat 2 • Integral printer provides hard copy', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.99, 'GBP', NOW());
    END IF;

    -- WTD03 Storage Jar validation:...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WTD03 Storage Jar validation:', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.0, 'GBP', NOW());
    END IF;

    -- WTD04 Charcoal Sachets High precision microprocessor - Pract...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WTD04 Charcoal Sachets High precision microprocessor - Practice & Operator names', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.9, 'GBP', NOW());
    END IF;

    -- ALMT03 • NP143 Scottish Contract approved...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALMT03 • NP143 Scottish Contract approved', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 295.0, 'GBP', NOW());
    END IF;

    -- • Monopolar unit cleaning SPSM01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Monopolar unit cleaning SPSM01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 249.0, 'GBP', NOW());
    END IF;

    -- ARTE101 ARTE103 HYGEA2 See page 46 for sterilisation rolls...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTE101 ARTE103 HYGEA2 See page 46 for sterilisation rolls', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 399.0, 'GBP', NOW());
    END IF;

    -- ARTE101 ARTE103 HYGEA2 See page 46 for sterilisation rolls...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTE101 ARTE103 HYGEA2 See page 46 for sterilisation rolls', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 75.0, 'GBP', NOW());
    END IF;

    -- ARTE101 ARTE103 HYGEA2 See page 46 for sterilisation rolls...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTE101 ARTE103 HYGEA2 See page 46 for sterilisation rolls', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1995.0, 'GBP', NOW());
    END IF;

    -- BDS133...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS133', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- CSA01 2.2ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CSA01 2.2ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.0, 'GBP', NOW());
    END IF;

    -- CSA03 1.8ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CSA03 1.8ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.0, 'GBP', NOW());
    END IF;

    -- Forceps Kit Contains: Buy 5 @ each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Forceps Kit Contains: Buy 5 @ each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.0, 'GBP', NOW());
    END IF;

    -- 3 Tray Setting Contains: • 308 Upper Anterior Roots BDS139...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('3 Tray Setting Contains: • 308 Upper Anterior Roots BDS139', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- • 6 Excavators • 330 Left Upper Molars BDS140 Self Aspiratin...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• 6 Excavators • 330 Left Upper Molars BDS140 Self Aspirating', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- • 1 Box of Mirror Heads • 349 Lower Incisors, Canines CSA02 ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• 1 Box of Mirror Heads • 349 Lower Incisors, Canines CSA02 2.2ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.0, 'GBP', NOW());
    END IF;

    -- • 3 Mirror Handles ~ 3 Ball Burnishers & Premolars CSA04 1.8...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• 3 Mirror Handles ~ 3 Ball Burnishers & Premolars CSA04 1.8ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.0, 'GBP', NOW());
    END IF;

    -- Buy 5 @ each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 5 @ each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 14.0, 'GBP', NOW());
    END IF;

    -- KIT1 All for KIT2 All for BDS141...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KIT1 All for KIT2 All for BDS141', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 99.5, 'GBP', NOW());
    END IF;

    -- KIT1 All for KIT2 All for BDS141...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KIT1 All for KIT2 All for BDS141', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 110.0, 'GBP', NOW());
    END IF;

    -- KIT1 All for KIT2 All for BDS141...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KIT1 All for KIT2 All for BDS141', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- • Elevators (Kit of 3) BBF01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Elevators (Kit of 3) BBF01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.95, 'GBP', NOW());
    END IF;

    -- BDS157...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS157', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- KIT3 All for BBS02 Item 433 LE-CRON...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KIT3 All for BBS02 Item 433 LE-CRON', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 267.5, 'GBP', NOW());
    END IF;

    -- KIT3 All for BBS02 Item 433 LE-CRON...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KIT3 All for BBS02 Item 433 LE-CRON', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.95, 'GBP', NOW());
    END IF;

    -- BDS433...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS433', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- Item 146 155 HOPSON DYAP01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Item 146 155 HOPSON DYAP01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.15, 'GBP', NOW());
    END IF;

    -- ARTF01 BDS146...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTF01 BDS146', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.3, 'GBP', NOW());
    END IF;

    -- ARTF01 BDS146...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTF01 BDS146', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- Straight AMC01 BDS119 BDS413...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Straight AMC01 BDS119 BDS413', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- Straight AMC01 BDS119 BDS413...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Straight AMC01 BDS119 BDS413', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- Buy one at...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy one at', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.9, 'GBP', NOW());
    END IF;

    -- BDS99 Item 167 1AM-PAT Couplands 2...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS99 Item 167 1AM-PAT Couplands 2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- Buy 6 at each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 6 at each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.7, 'GBP', NOW());
    END IF;

    -- Buy 12 at each BDS167 BDS414...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 12 at each BDS167 BDS414', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.6, 'GBP', NOW());
    END IF;

    -- Buy 12 at each BDS167 BDS414...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 12 at each BDS167 BDS414', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- Buy 12 at each BDS167 BDS414...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 12 at each BDS167 BDS414', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- Straight TIP AMCT01 Item 100...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Straight TIP AMCT01 Item 100', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.25, 'GBP', NOW());
    END IF;

    -- 45 Degree TIP AMCT02 Blacks serrated Item 168 1LAM-PAT Coupl...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('45 Degree TIP AMCT02 Blacks serrated Item 168 1LAM-PAT Couplands 3', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.25, 'GBP', NOW());
    END IF;

    -- 90 Degree TIP AMCT03 BDS100 BDS168 BDS415...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('90 Degree TIP AMCT03 BDS100 BDS168 BDS415', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.25, 'GBP', NOW());
    END IF;

    -- 90 Degree TIP AMCT03 BDS100 BDS168 BDS415...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('90 Degree TIP AMCT03 BDS100 BDS168 BDS415', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- 90 Degree TIP AMCT03 BDS100 BDS168 BDS415...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('90 Degree TIP AMCT03 BDS100 BDS168 BDS415', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- 90 Degree TIP AMCT03 BDS100 BDS168 BDS415...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('90 Degree TIP AMCT03 BDS100 BDS168 BDS415', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- BDS407 BDS39...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS407 BDS39', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- BDS407 BDS39...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS407 BDS39', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS321 BDS338...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS321 BDS338', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS321 BDS338...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS321 BDS338', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS406 BDS40...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS406 BDS40', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- BDS406 BDS40...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS406 BDS40', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS393...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS393', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- BDS42...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS42', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS394...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS394', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- BDS324 BDS342...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS324 BDS342', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS324 BDS342...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS324 BDS342', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS48...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS48', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS384...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS384', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- BDS49 BDS326 BDS345...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS49 BDS326 BDS345', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS49 BDS326 BDS345...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS49 BDS326 BDS345', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS49 BDS326 BDS345...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS49 BDS326 BDS345', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS385...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS385', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- Pereosteal 411 BDS329 BDS349...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Pereosteal 411 BDS329 BDS349', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- Pereosteal 411 BDS329 BDS349...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Pereosteal 411 BDS329 BDS349', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS411...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS411', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- BDS308...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS308', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS412...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS412', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- BDS330 BDS351...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS330 BDS351', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS330 BDS351...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS330 BDS351', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- Warwick James RIGHT BDS310...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Warwick James RIGHT BDS310', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS381...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS381', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- Warwick James LEFT Upper Anterior 29S BDS335 BDS354...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Warwick James LEFT Upper Anterior 29S BDS335 BDS354', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- Warwick James LEFT Upper Anterior 29S BDS335 BDS354...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Warwick James LEFT Upper Anterior 29S BDS335 BDS354', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS382 BDS311...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS382 BDS311', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- BDS382 BDS311...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS382 BDS311', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS383...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS383', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- BDS314 BDS336 BDS355...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS314 BDS336 BDS355', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS314 BDS336 BDS355...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS314 BDS336 BDS355', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS314 BDS336 BDS355...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS314 BDS336 BDS355', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS38 BDS319 BDS337 BDS359...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS38 BDS319 BDS337 BDS359', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS38 BDS319 BDS337 BDS359...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS38 BDS319 BDS337 BDS359', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS38 BDS319 BDS337 BDS359...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS38 BDS319 BDS337 BDS359', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS38 BDS319 BDS337 BDS359...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS38 BDS319 BDS337 BDS359', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- Spend over on BDS instruments...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Spend over on BDS instruments', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- BDS373 LX3C LX5C...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS373 LX3C LX5C', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS373 LX3C LX5C...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS373 LX3C LX5C', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- BDS373 LX3C LX5C...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS373 LX3C LX5C', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- BDS364 BDS374 LX3CA LX3S...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS364 BDS374 LX3CA LX3S', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS364 BDS374 LX3CA LX3S...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS364 BDS374 LX3CA LX3S', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS364 BDS374 LX3CA LX3S...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS364 BDS374 LX3CA LX3S', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- BDS364 BDS374 LX3CA LX3S...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS364 BDS374 LX3CA LX3S', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- BDS375 LX1C LX5S...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS375 LX1C LX5S', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS375 LX1C LX5S...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS375 LX1C LX5S', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- BDS375 LX1C LX5S...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS375 LX1C LX5S', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- BDS365...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS365', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- Childs Upper Incisor Canines 37 LX2S LX1S...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Childs Upper Incisor Canines 37 LX2S LX1S', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- Childs Upper Incisor Canines 37 LX2S LX1S...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Childs Upper Incisor Canines 37 LX2S LX1S', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- BDS366...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS366', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- LXSS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('LXSS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.95, 'GBP', NOW());
    END IF;

    -- BDS367...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS367', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- MXBH01 INSTRUMENT KITS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MXBH01 INSTRUMENT KITS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.1, 'GBP', NOW());
    END IF;

    -- Childs Lower Teeth & Roots 123 MXBH02 Coloured instrument co...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Childs Lower Teeth & Roots 123 MXBH02 Coloured instrument code tape.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.1, 'GBP', NOW());
    END IF;

    -- BDS368...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS368', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- MXB02 99p TNT01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MXB02 99p TNT01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.85, 'GBP', NOW());
    END IF;

    -- TNT02 Assorted Reel...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TNT02 Assorted Reel', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.35, 'GBP', NOW());
    END IF;

    -- BDS369 Tofflemire Holder with sharpening stone....
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS369 Tofflemire Holder with sharpening stone.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- MXBH03 holder LUX001...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MXBH03 holder LUX001', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.95, 'GBP', NOW());
    END IF;

    -- MXBH03 holder LUX001...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MXBH03 holder LUX001', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 85.0, 'GBP', NOW());
    END IF;

    -- MXB03 Pk 12 LX3C, LX5C, LX3S, LX5S, LX2S,...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MXB03 Pk 12 LX3C, LX5C, LX3S, LX5S, LX2S,', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.75, 'GBP', NOW());
    END IF;

    -- MXB04 Pk 12 LUX002...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MXB04 Pk 12 LUX002', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.75, 'GBP', NOW());
    END IF;

    -- MXB04 Pk 12 LUX002...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MXB04 Pk 12 LUX002', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 145.0, 'GBP', NOW());
    END IF;

    -- BDS370 All ourDental Instruments are manufactured...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS370 All ourDental Instruments are manufactured', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- spend or more & receive a10% Discount*...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('spend or more & receive a10% Discount*', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.0, 'GBP', NOW());
    END IF;

    -- or more& receive a15% Discount*...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('or more& receive a15% Discount*', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 100.0, 'GBP', NOW());
    END IF;

    -- Childs Upper Pre Molars 159 or more & receive a20% Discount*...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Childs Upper Pre Molars 159 or more & receive a20% Discount* available.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 200.0, 'GBP', NOW());
    END IF;

    -- BDS372 * ONLY APPLIES TO PRODUCTS CONTAINING BDS CODES AND E...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS372 * ONLY APPLIES TO PRODUCTS CONTAINING BDS CODES AND EXCLUDES INSTRUMENT KITS ICR01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDS372 * ONLY APPLIES TO PRODUCTS CONTAINING BDS CODES AND E...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS372 * ONLY APPLIES TO PRODUCTS CONTAINING BDS CODES AND EXCLUDES INSTRUMENT KITS ICR01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.0, 'GBP', NOW());
    END IF;

    -- MRH01 99p BDS114 BDS10 BDS255...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MRH01 99p BDS114 BDS10 BDS255', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- MRH01 99p BDS114 BDS10 BDS255...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MRH01 99p BDS114 BDS10 BDS255', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.6, 'GBP', NOW());
    END IF;

    -- MRH01 99p BDS114 BDS10 BDS255...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MRH01 99p BDS114 BDS10 BDS255', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS117 BDS11 BDS256...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS117 BDS11 BDS256', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS117 BDS11 BDS256...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS117 BDS11 BDS256', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.6, 'GBP', NOW());
    END IF;

    -- BDS117 BDS11 BDS256...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS117 BDS11 BDS256', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS121 BDS21 BDS265...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS121 BDS21 BDS265', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS121 BDS21 BDS265...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS121 BDS21 BDS265', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.6, 'GBP', NOW());
    END IF;

    -- BDS121 BDS21 BDS265...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS121 BDS21 BDS265', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS4MIRR...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS4MIRR', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.2, 'GBP', NOW());
    END IF;

    -- Magnifying Item 266 Cumine 152...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Magnifying Item 266 Cumine 152', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.2, 'GBP', NOW());
    END IF;

    -- BDS123 BDS22...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS123 BDS22', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS123 BDS22...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS123 BDS22', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.6, 'GBP', NOW());
    END IF;

    -- BDS266...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS266', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- 4MH01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('4MH01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.95, 'GBP', NOW());
    END IF;

    -- Front Surface (12) BDS124 Item 268 Shepards 197...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Front Surface (12) BDS124 Item 268 Shepards 197', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- FMH01 BDS268...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('FMH01 BDS268', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.45, 'GBP', NOW());
    END IF;

    -- FMH01 BDS268...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('FMH01 BDS268', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- RAT01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RAT01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- INSTRUMENT BDS125 Item 278 Towner U15...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('INSTRUMENT BDS125 Item 278 Towner U15', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS278...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS278', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS170 BDS147 Scaler 204...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS170 BDS147 Scaler 204', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS170 BDS147 Scaler 204...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS170 BDS147 Scaler 204', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- Item 222 Williams BDS204S...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Item 222 Williams BDS204S', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.15, 'GBP', NOW());
    END IF;

    -- ORTHODONTIC PLIERS BDS222...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ORTHODONTIC PLIERS BDS222', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS148...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS148', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- Item 245 Jaquette 1 BDSH6/7...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Item 245 Jaquette 1 BDSH6/7', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.15, 'GBP', NOW());
    END IF;

    -- BDS245...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS245', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS154...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS154', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDSOP01 Item 246 Jaquette 2...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDSOP01 Item 246 Jaquette 2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- BDSMF2/3...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDSMF2/3', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.15, 'GBP', NOW());
    END IF;

    -- PROBES BDS246...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PROBES BDS246', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- CPITN-C BDSMF4/5...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CPITN-C BDSMF4/5', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.15, 'GBP', NOW());
    END IF;

    -- Short NOSE ADAMS CPITN-C BDS247...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Short NOSE ADAMS CPITN-C BDS247', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.75, 'GBP', NOW());
    END IF;

    -- Short NOSE ADAMS CPITN-C BDS247...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Short NOSE ADAMS CPITN-C BDS247', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDSOP02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDSOP02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- INSTRUMENTS BDS04 BDS248...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('INSTRUMENTS BDS04 BDS248', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.15, 'GBP', NOW());
    END IF;

    -- INSTRUMENTS BDS04 BDS248...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('INSTRUMENTS BDS04 BDS248', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS106 BDS06 BDS249...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS106 BDS06 BDS249', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS106 BDS06 BDS249...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS106 BDS06 BDS249', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.6, 'GBP', NOW());
    END IF;

    -- BDS106 BDS06 BDS249...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS106 BDS06 BDS249', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS113 BDS08 BDS251 KIT-HY...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS113 BDS08 BDS251 KIT-HY', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS113 BDS08 BDS251 KIT-HY...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS113 BDS08 BDS251 KIT-HY', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.6, 'GBP', NOW());
    END IF;

    -- BDS113 BDS08 BDS251 KIT-HY...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS113 BDS08 BDS251 KIT-HY', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS113 BDS08 BDS251 KIT-HY...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS113 BDS08 BDS251 KIT-HY', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 20.95, 'GBP', NOW());
    END IF;

    -- Spend over on BDS instruments...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Spend over on BDS instruments', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 200.0, 'GBP', NOW());
    END IF;

    -- BDS425...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS425', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS416 BDS424C reduced rate of...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS416 BDS424C reduced rate of', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS416 BDS424C reduced rate of...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS416 BDS424C reduced rate of', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS416 BDS424C reduced rate of...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS416 BDS424C reduced rate of', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.0, 'GBP', NOW());
    END IF;

    -- BDS426...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS426', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS417...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS417', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- Item 78 Alginate BDS427...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Item 78 Alginate BDS427', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS78...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS78', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS418 Item 79 3 Western BDS428...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS418 Item 79 3 Western BDS428', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS418 Item 79 3 Western BDS428...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS418 Item 79 3 Western BDS428', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS79...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS79', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- ITEM 419 (CURVED) 5 GUM BDS81...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ITEM 419 (CURVED) 5 GUM BDS81', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS419...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS419', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS82...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS82', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS420...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS420', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS430...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS430', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS86 • Totally waterproof unit enables cold...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS86 • Totally waterproof unit enables cold', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- Item 421 (STRAIGHT) Crown Bee Bee BDS431 heat and has an inc...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Item 421 (STRAIGHT) Crown Bee Bee BDS431 heat and has an incredibly long life', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS421 • Low energy bulb has 1/15 the...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS421 • Low energy bulb has 1/15 the', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS422 SPEN02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS422 SPEN02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS422 SPEN02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS422 SPEN02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.0, 'GBP', NOW());
    END IF;

    -- SPEN01 Bite Gauge mirror...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SPEN01 Bite Gauge mirror', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.0, 'GBP', NOW());
    END IF;

    -- WBG01 PINL01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WBG01 PINL01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 21.8, 'GBP', NOW());
    END IF;

    -- WBG01 PINL01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WBG01 PINL01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 49.95, 'GBP', NOW());
    END IF;

    -- PINL02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PINL02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.95, 'GBP', NOW());
    END IF;

    -- BDS423...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS423', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- PINL03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PINL03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.95, 'GBP', NOW());
    END IF;

    -- BDS149...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS149', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS4MIRR...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS4MIRR', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.95, 'GBP', NOW());
    END IF;

    -- BDS424S BDS150 BDSWR PINL06...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS424S BDS150 BDSWR PINL06', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS424S BDS150 BDSWR PINL06...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS424S BDS150 BDSWR PINL06', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- BDS424S BDS150 BDSWR PINL06...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS424S BDS150 BDSWR PINL06', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.45, 'GBP', NOW());
    END IF;

    -- BDS424S BDS150 BDSWR PINL06...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BDS424S BDS150 BDSWR PINL06', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.95, 'GBP', NOW());
    END IF;

    -- DMNP_ _ Large...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DMNP_ _ Large', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.0, 'GBP', NOW());
    END IF;

    -- ILT001 1 PACK STB02 size 11 A precision gauge specially desi...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ILT001 1 PACK STB02 size 11 A precision gauge specially designed', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.95, 'GBP', NOW());
    END IF;

    -- ILT001 1 PACK STB02 size 11 A precision gauge specially desi...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ILT001 1 PACK STB02 size 11 A precision gauge specially designed', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.95, 'GBP', NOW());
    END IF;

    -- 6 + each 6 + PACKS each STB04 size 15 for the standardisatio...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 + each 6 + PACKS each STB04 size 15 for the standardisation of endodontic', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.5, 'GBP', NOW());
    END IF;

    -- 6 + each 6 + PACKS each STB04 size 15 for the standardisatio...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 + each 6 + PACKS each STB04 size 15 for the standardisation of endodontic', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.25, 'GBP', NOW());
    END IF;

    -- 6 + each 6 + PACKS each STB04 size 15 for the standardisatio...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 + each 6 + PACKS each STB04 size 15 for the standardisation of endodontic', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.95, 'GBP', NOW());
    END IF;

    -- DMMNP_ _ Mini measurements. The endometer offers a...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DMMNP_ _ Mini measurements. The endometer offers a', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.35, 'GBP', NOW());
    END IF;

    -- 6 + each simple, fast and economical way to...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 + each simple, fast and economical way to', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.15, 'GBP', NOW());
    END IF;

    -- DMNPL01 Large...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DMNPL01 Large', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.0, 'GBP', NOW());
    END IF;

    -- SCH01 END01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SCH01 END01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.95, 'GBP', NOW());
    END IF;

    -- SCH01 END01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SCH01 END01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.99, 'GBP', NOW());
    END IF;

    -- DMMNPL01 Mini...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DMMNPL01 Mini', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.35, 'GBP', NOW());
    END IF;

    -- SBR...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SBR', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.5, 'GBP', NOW());
    END IF;

    -- Aluminium Perforated MONO01 box 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Aluminium Perforated MONO01 box 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.89, 'GBP', NOW());
    END IF;

    -- DMP_ _ Large INSTRUMENT TRAY...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DMP_ _ Large INSTRUMENT TRAY', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- DSB03 size 11...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DSB03 size 11', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.45, 'GBP', NOW());
    END IF;

    -- 6 + each INSERTS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 + each INSERTS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.0, 'GBP', NOW());
    END IF;

    -- DSB05 size 15...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DSB05 size 15', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.45, 'GBP', NOW());
    END IF;

    -- DMMP_ _ Mini...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DMMP_ _ Mini', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.35, 'GBP', NOW());
    END IF;

    -- 6 + each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 + each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.15, 'GBP', NOW());
    END IF;

    -- DMPTL01 Large...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DMPTL01 Large', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- DMMPTL01 Mini...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DMMPTL01 Mini', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.75, 'GBP', NOW());
    END IF;

    -- DMALTR01 LARGE...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DMALTR01 LARGE', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.25, 'GBP', NOW());
    END IF;

    -- Mini size: 18 x 14cm ENDSTOP...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Mini size: 18 x 14cm ENDSTOP', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.95, 'GBP', NOW());
    END IF;

    -- 6 + LARGE each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 + LARGE each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.0, 'GBP', NOW());
    END IF;

    -- _ _ Colour Code 01 Grey, 02 Blue, 03 DMALTR02 MINI...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('_ _ Colour Code 01 Grey, 02 Blue, 03 DMALTR02 MINI', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.0, 'GBP', NOW());
    END IF;

    -- Red, 04 Green, 05 Yellow 6 + MINI each (Includes 2 Free Tips...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Red, 04 Green, 05 Yellow 6 + MINI each (Includes 2 Free Tips)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.8, 'GBP', NOW());
    END IF;

    -- 3IN1S01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('3IN1S01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.95, 'GBP', NOW());
    END IF;

    -- 3IN1ST01 pk of 5...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('3IN1ST01 pk of 5', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.95, 'GBP', NOW());
    END IF;

    -- SSCG10 Green...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SSCG10 Green', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.5, 'GBP', NOW());
    END IF;

    -- SSCB10 Blue...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SSCB10 Blue', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.5, 'GBP', NOW());
    END IF;

    -- MES01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MES01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 21.5, 'GBP', NOW());
    END IF;

    -- SSCG5 Green...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SSCG5 Green', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 14.5, 'GBP', NOW());
    END IF;

    -- 5 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.95, 'GBP', NOW());
    END IF;

    -- Small Tray Rack SSCB5 Blue Disposable 3 IN 1 Tips Monoject 3...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Small Tray Rack SSCB5 Blue Disposable 3 IN 1 Tips Monoject 3cc endodontic syringes with', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 14.5, 'GBP', NOW());
    END IF;

    -- DMNTR02 BUY any 5 get Economical white disposable tips 27g x...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DMNTR02 BUY any 5 get Economical white disposable tips 27g x 1.25 needles (100).', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.0, 'GBP', NOW());
    END IF;

    -- Large Tray Rack (cheapest) one free DISTIP01 Box of 200 MES0...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Large Tray Rack (cheapest) one free DISTIP01 Box of 200 MES03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.5, 'GBP', NOW());
    END IF;

    -- Large Tray Rack (cheapest) one free DISTIP01 Box of 200 MES0...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Large Tray Rack (cheapest) one free DISTIP01 Box of 200 MES03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 21.5, 'GBP', NOW());
    END IF;

    -- DMNTR01 5 Rate 5 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DMNTR01 5 Rate 5 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 45.0, 'GBP', NOW());
    END IF;

    -- DMNTR01 5 Rate 5 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DMNTR01 5 Rate 5 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.0, 'GBP', NOW());
    END IF;

    -- DMNTR01 5 Rate 5 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DMNTR01 5 Rate 5 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.95, 'GBP', NOW());
    END IF;

    -- HFI...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HFI', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.75, 'GBP', NOW());
    END IF;

    -- HRE EFI ERE (S. Steel) ASSORTMENT 25/40...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HRE EFI ERE (S. Steel) ASSORTMENT 25/40', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.75, 'GBP', NOW());
    END IF;

    -- HRE EFI ERE (S. Steel) ASSORTMENT 25/40...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HRE EFI ERE (S. Steel) ASSORTMENT 25/40', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.95, 'GBP', NOW());
    END IF;

    -- HRE EFI ERE (S. Steel) ASSORTMENT 25/40...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HRE EFI ERE (S. Steel) ASSORTMENT 25/40', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.95, 'GBP', NOW());
    END IF;

    -- 10 rate KFI PF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 rate KFI PF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.25, 'GBP', NOW());
    END IF;

    -- 10 rate KFI PF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 rate KFI PF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.75, 'GBP', NOW());
    END IF;

    -- 10 rate KFI PF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 rate KFI PF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.95, 'GBP', NOW());
    END IF;

    -- ERE15-40 (NiTi)...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ERE15-40 (NiTi)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.95, 'GBP', NOW());
    END IF;

    -- 10 rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.25, 'GBP', NOW());
    END IF;

    -- PR Pkt 6 FP15-40 (25mm) Pkt 6 (50mm) No handles With handles...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PR Pkt 6 FP15-40 (25mm) Pkt 6 (50mm) No handles With handles Pkt 6', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.25, 'GBP', NOW());
    END IF;

    -- PR Pkt 6 FP15-40 (25mm) Pkt 6 (50mm) No handles With handles...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PR Pkt 6 FP15-40 (25mm) Pkt 6 (50mm) No handles With handles Pkt 6', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.75, 'GBP', NOW());
    END IF;

    -- GG 15 BB10 XXF BB01 XXXXF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GG 15 BB10 XXF BB01 XXXXF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.95, 'GBP', NOW());
    END IF;

    -- GG 15 BB10 XXF BB01 XXXXF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GG 15 BB10 XXF BB01 XXXXF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.75, 'GBP', NOW());
    END IF;

    -- GG 15 BB10 XXF BB01 XXXXF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GG 15 BB10 XXF BB01 XXXXF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.25, 'GBP', NOW());
    END IF;

    -- GG 15 BB10 XXF BB01 XXXXF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GG 15 BB10 XXF BB01 XXXXF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.35, 'GBP', NOW());
    END IF;

    -- 20 BB11 XF BB02 XXXF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 BB11 XF BB02 XXXF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.75, 'GBP', NOW());
    END IF;

    -- 20 BB11 XF BB02 XXXF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 BB11 XF BB02 XXXF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.25, 'GBP', NOW());
    END IF;

    -- 20 BB11 XF BB02 XXXF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 BB11 XF BB02 XXXF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.35, 'GBP', NOW());
    END IF;

    -- 25 BB12 F BB03 XXF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('25 BB12 F BB03 XXF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.75, 'GBP', NOW());
    END IF;

    -- 25 BB12 F BB03 XXF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('25 BB12 F BB03 XXF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.25, 'GBP', NOW());
    END IF;

    -- 25 BB12 F BB03 XXF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('25 BB12 F BB03 XXF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.35, 'GBP', NOW());
    END IF;

    -- 30 BB13 M BB04 XF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('30 BB13 M BB04 XF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.75, 'GBP', NOW());
    END IF;

    -- 30 BB13 M BB04 XF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('30 BB13 M BB04 XF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.25, 'GBP', NOW());
    END IF;

    -- 30 BB13 M BB04 XF...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('30 BB13 M BB04 XF', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.35, 'GBP', NOW());
    END IF;

    -- 15-40 BB08 AAST BB05 F...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('15-40 BB08 AAST BB05 F', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.75, 'GBP', NOW());
    END IF;

    -- 15-40 BB08 AAST BB05 F...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('15-40 BB08 AAST BB05 F', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.25, 'GBP', NOW());
    END IF;

    -- 15-40 BB08 AAST BB05 F...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('15-40 BB08 AAST BB05 F', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.35, 'GBP', NOW());
    END IF;

    -- No handles Pkt 10 BB06 M...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('No handles Pkt 10 BB06 M', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.35, 'GBP', NOW());
    END IF;

    -- BB BB07 C...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BB BB07 C', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.25, 'GBP', NOW());
    END IF;

    -- BB BB07 C...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BB BB07 C', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.35, 'GBP', NOW());
    END IF;

    -- NITI4%__ • Packs of 6 assorted 1 of each file above...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('NITI4%__ • Packs of 6 assorted 1 of each file above', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.99, 'GBP', NOW());
    END IF;

    -- NITI6%__ NITI__...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('NITI6%__ NITI__', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.99, 'GBP', NOW());
    END IF;

    -- NITI6%__ NITI__...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('NITI6%__ NITI__', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.99, 'GBP', NOW());
    END IF;

    -- each each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('each each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.49, 'GBP', NOW());
    END IF;

    -- each each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('each each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.75, 'GBP', NOW());
    END IF;

    -- Thin RDRC02 Quick and easy to apply. Secures a impressions e...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Thin RDRC02 Quick and easy to apply. Secures a impressions eliminating remakes. Contains 300ml each base and catalyst', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.95, 'GBP', NOW());
    END IF;

    -- Heavy RDRC05 sterile and dry operation. Contains 6 regular a...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Heavy RDRC05 sterile and dry operation. Contains 6 regular and 6 intra oral tips. AFFPU01 Fast', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.25, 'GBP', NOW());
    END IF;

    -- Heavy RDRC05 sterile and dry operation. Contains 6 regular a...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Heavy RDRC05 sterile and dry operation. Contains 6 regular and 6 intra oral tips. AFFPU01 Fast', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 49.95, 'GBP', NOW());
    END IF;

    -- Extra Heavy RDRC06 RDF01 Regular set: work time 2.30min, set...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Extra Heavy RDRC06 RDF01 Regular set: work time 2.30min, set AFFPU02 Soft', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.45, 'GBP', NOW());
    END IF;

    -- Extra Heavy RDRC06 RDF01 Regular set: work time 2.30min, set...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Extra Heavy RDRC06 RDF01 Regular set: work time 2.30min, set AFFPU02 Soft', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.95, 'GBP', NOW());
    END IF;

    -- Extra Heavy RDRC06 RDF01 Regular set: work time 2.30min, set...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Extra Heavy RDRC06 RDF01 Regular set: work time 2.30min, set AFFPU02 Soft', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 49.95, 'GBP', NOW());
    END IF;

    -- time 1.00 min AFFPU03 Super soft...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('time 1.00 min AFFPU03 Super soft', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 49.95, 'GBP', NOW());
    END IF;

    -- reg. set light body yellow...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('reg. set light body yellow', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.95, 'GBP', NOW());
    END IF;

    -- reg. set medium body buff...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('reg. set medium body buff', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.95, 'GBP', NOW());
    END IF;

    -- fast set light body yellow...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('fast set light body yellow', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.95, 'GBP', NOW());
    END IF;

    -- fast set medium body buff...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('fast set medium body buff', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.95, 'GBP', NOW());
    END IF;

    -- RDCH01 Available in yellow green blue and pink...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RDCH01 Available in yellow green blue and pink', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.95, 'GBP', NOW());
    END IF;

    -- IMPTIP01 Yellow...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('IMPTIP01 Yellow', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 13.75, 'GBP', NOW());
    END IF;

    -- Contains rubber dam, metal frame, IMPTIP03 Green...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Contains rubber dam, metal frame, IMPTIP03 Green', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 13.75, 'GBP', NOW());
    END IF;

    -- RBDK base 300ml catalyst IMPTIP05 White...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RBDK base 300ml catalyst IMPTIP05 White', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 35.0, 'GBP', NOW());
    END IF;

    -- RBDK base 300ml catalyst IMPTIP05 White...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RBDK base 300ml catalyst IMPTIP05 White', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 13.75, 'GBP', NOW());
    END IF;

    -- IMPP01 Fast set...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('IMPP01 Fast set', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.95, 'GBP', NOW());
    END IF;

    -- IMPP02 Regular set Intra oral tips pack of 100...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('IMPP02 Regular set Intra oral tips pack of 100', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.95, 'GBP', NOW());
    END IF;

    -- INTTIP01 Yellow...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('INTTIP01 Yellow', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.9, 'GBP', NOW());
    END IF;

    -- INTTIP02 White...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('INTTIP02 White', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.9, 'GBP', NOW());
    END IF;

    -- RDP01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RDP01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 25.95, 'GBP', NOW());
    END IF;

    -- RBDC _ _ _ exceeding 118°C (224°F). regular body 6611 MDW01 ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RBDC _ _ _ exceeding 118°C (224°F). regular body 6611 MDW01 450', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.75, 'GBP', NOW());
    END IF;

    -- RBDC _ _ _ exceeding 118°C (224°F). regular body 6611 MDW01 ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RBDC _ _ _ exceeding 118°C (224°F). regular body 6611 MDW01 450', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 32.95, 'GBP', NOW());
    END IF;

    -- RBDC _ _ _ exceeding 118°C (224°F). regular body 6611 MDW01 ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RBDC _ _ _ exceeding 118°C (224°F). regular body 6611 MDW01 450', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.95, 'GBP', NOW());
    END IF;

    -- Assortment, one of each number. Dark Medium RDR01 AFFW02 Aff...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Assortment, one of each number. Dark Medium RDR01 AFFW02 Affinis wash fast 5 rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.95, 'GBP', NOW());
    END IF;

    -- Assortment, one of each number. Dark Medium RDR01 AFFW02 Aff...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Assortment, one of each number. Dark Medium RDR01 AFFW02 Affinis wash fast 5 rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.55, 'GBP', NOW());
    END IF;

    -- RBDCKIT Light Medium RDR02 light body 6601 10 rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RBDCKIT Light Medium RDR02 light body 6601 10 rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 37.0, 'GBP', NOW());
    END IF;

    -- RBDCKIT Light Medium RDR02 light body 6601 10 rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RBDCKIT Light Medium RDR02 light body 6601 10 rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.95, 'GBP', NOW());
    END IF;

    -- RBDCKIT Light Medium RDR02 light body 6601 10 rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RBDCKIT Light Medium RDR02 light body 6601 10 rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 32.95, 'GBP', NOW());
    END IF;

    -- RBDCKIT Light Medium RDR02 light body 6601 10 rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RBDCKIT Light Medium RDR02 light body 6601 10 rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.15, 'GBP', NOW());
    END IF;

    -- KA01 per bag ALB01 bowl Lower...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KA01 per bag ALB01 bowl Lower', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.99, 'GBP', NOW());
    END IF;

    -- KA01 per bag ALB01 bowl Lower...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KA01 per bag ALB01 bowl Lower', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.95, 'GBP', NOW());
    END IF;

    -- 10 Rate per bag ALB03 spatula POLYTL0 Small green...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Rate per bag ALB03 spatula POLYTL0 Small green', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.69, 'GBP', NOW());
    END IF;

    -- 10 Rate per bag ALB03 spatula POLYTL0 Small green...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Rate per bag ALB03 spatula POLYTL0 Small green', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.95, 'GBP', NOW());
    END IF;

    -- 10 Rate per bag ALB03 spatula POLYTL0 Small green...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Rate per bag ALB03 spatula POLYTL0 Small green', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.21, 'GBP', NOW());
    END IF;

    -- 20 Rate per bag ALB03 bowl & spatula POLYTL1 Medium blue...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Rate per bag ALB03 bowl & spatula POLYTL1 Medium blue', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.39, 'GBP', NOW());
    END IF;

    -- 20 Rate per bag ALB03 bowl & spatula POLYTL1 Medium blue...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Rate per bag ALB03 bowl & spatula POLYTL1 Medium blue', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.95, 'GBP', NOW());
    END IF;

    -- 20 Rate per bag ALB03 bowl & spatula POLYTL1 Medium blue...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Rate per bag ALB03 bowl & spatula POLYTL1 Medium blue', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.21, 'GBP', NOW());
    END IF;

    -- PLUS GET 1 FREE!! POLYTL2 Large yellow...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PLUS GET 1 FREE!! POLYTL2 Large yellow', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.21, 'GBP', NOW());
    END IF;

    -- (equals each)...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('(equals each)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.09, 'GBP', NOW());
    END IF;

    -- POLYTU0 Small green...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLYTU0 Small green', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.21, 'GBP', NOW());
    END IF;

    -- POLYTU01 Medium blue...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLYTU01 Medium blue', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.21, 'GBP', NOW());
    END IF;

    -- • Rigid plastic for greater accuracy POLYTU02 Large yellow...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Rigid plastic for greater accuracy POLYTU02 Large yellow', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.21, 'GBP', NOW());
    END IF;

    -- EA02 454g Large Upper IMPR01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EA02 454g Large Upper IMPR01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.24, 'GBP', NOW());
    END IF;

    -- EA02 454g Large Upper IMPR01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EA02 454g Large Upper IMPR01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.35, 'GBP', NOW());
    END IF;

    -- 10 Rate each Large Lower IMPR02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Rate each Large Lower IMPR02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.86, 'GBP', NOW());
    END IF;

    -- 10 Rate each Large Lower IMPR02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Rate each Large Lower IMPR02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.35, 'GBP', NOW());
    END IF;

    -- materials. Can be used angled or with Medium Lower IMPR04...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('materials. Can be used angled or with Medium Lower IMPR04', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.35, 'GBP', NOW());
    END IF;

    -- a straight tip to easily reach Small Upper IMPR05...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('a straight tip to easily reach Small Upper IMPR05', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.35, 'GBP', NOW());
    END IF;

    -- Small Lower IMPR06...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Small Lower IMPR06', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.35, 'GBP', NOW());
    END IF;

    -- tightly so it can be used with liquids for Lower Right IMPR0...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('tightly so it can be used with liquids for Lower Right IMPR07', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.35, 'GBP', NOW());
    END IF;

    -- prophy-paste and cement. Lower Left IMPR08 TTP01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('prophy-paste and cement. Lower Left IMPR08 TTP01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.35, 'GBP', NOW());
    END IF;

    -- prophy-paste and cement. Lower Left IMPR08 TTP01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('prophy-paste and cement. Lower Left IMPR08 TTP01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.75, 'GBP', NOW());
    END IF;

    -- BOX OF 100 Anterior IMPR09 3 Rate each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BOX OF 100 Anterior IMPR09 3 Rate each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.35, 'GBP', NOW());
    END IF;

    -- BOX OF 100 Anterior IMPR09 3 Rate each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BOX OF 100 Anterior IMPR09 3 Rate each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.45, 'GBP', NOW());
    END IF;

    -- DIS01 SPRAY ON 200ML...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DIS01 SPRAY ON 200ML', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 13.95, 'GBP', NOW());
    END IF;

    -- Hydrogum TTS01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Hydrogum TTS01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.65, 'GBP', NOW());
    END IF;

    -- 3 Rate each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('3 Rate each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.35, 'GBP', NOW());
    END IF;

    -- HYDR01 500gm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HYDR01 500gm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.75, 'GBP', NOW());
    END IF;

    -- 10 Rate each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Rate each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.4, 'GBP', NOW());
    END IF;

    -- 20 Rate each Excellent quality impression trays, 25 in...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Rate each Excellent quality impression trays, 25 in', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.2, 'GBP', NOW());
    END IF;

    -- Upper Edentulous deep perf...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Upper Edentulous deep perf', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- Lower Edentulous deep perf PEGO01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Lower Edentulous deep perf PEGO01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- Lower Edentulous deep perf PEGO01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Lower Edentulous deep perf PEGO01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- SIT05 No.5 3 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SIT05 No.5 3 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.25, 'GBP', NOW());
    END IF;

    -- Upper Edentulous shallow perf...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Upper Edentulous shallow perf', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- Lower Edentulous shallow perf Upper Dentate Orthodontic plai...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Lower Edentulous shallow perf Upper Dentate Orthodontic plain', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- Lower Edentulous shallow perf Upper Dentate Orthodontic plai...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Lower Edentulous shallow perf Upper Dentate Orthodontic plain', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- Upper Dentate large perf Lower Dentate Orthodonticplain...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Upper Dentate large perf Lower Dentate Orthodonticplain', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- Upper Dentate large perf Lower Dentate Orthodonticplain...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Upper Dentate large perf Lower Dentate Orthodonticplain', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- lilac colour with fruity berry flavour, extra Lower Dentate ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('lilac colour with fruity berry flavour, extra Lower Dentate large perf Upper Dentate Small perf', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- lilac colour with fruity berry flavour, extra Lower Dentate ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('lilac colour with fruity berry flavour, extra Lower Dentate large perf Upper Dentate Small perf', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- HYDR05 453gm Upper Dentate average perf Lower Dentate Small ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HYDR05 453gm Upper Dentate average perf Lower Dentate Small perf', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.9, 'GBP', NOW());
    END IF;

    -- HYDR05 453gm Upper Dentate average perf Lower Dentate Small ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HYDR05 453gm Upper Dentate average perf Lower Dentate Small perf', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- HYDR05 453gm Upper Dentate average perf Lower Dentate Small ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HYDR05 453gm Upper Dentate average perf Lower Dentate Small perf', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- 10 Rate each SIT14 No.14 SITHO1U Tekpro universal tray adhes...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Rate each SIT14 No.14 SITHO1U Tekpro universal tray adhesive', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.6, 'GBP', NOW());
    END IF;

    -- 20 Rate each Lower Dentate average perf Tray handles pack of...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Rate each Lower Dentate average perf Tray handles pack of 10 UNIV01 2 x 14ml bottles', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.4, 'GBP', NOW());
    END IF;

    -- 20 Rate each Lower Dentate average perf Tray handles pack of...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Rate each Lower Dentate average perf Tray handles pack of 10 UNIV01 2 x 14ml bottles', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- 20 Rate each Lower Dentate average perf Tray handles pack of...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Rate each Lower Dentate average perf Tray handles pack of 10 UNIV01 2 x 14ml bottles', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.5, 'GBP', NOW());
    END IF;

    -- 20 Rate each Lower Dentate average perf Tray handles pack of...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Rate each Lower Dentate average perf Tray handles pack of 10 UNIV01 2 x 14ml bottles', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.95, 'GBP', NOW());
    END IF;

    -- ETCH02A...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ETCH02A', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.5, 'GBP', NOW());
    END IF;

    -- 3 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('3 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.0, 'GBP', NOW());
    END IF;

    -- 5 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.5, 'GBP', NOW());
    END IF;

    -- • Good corrosion resistance SPIL01 1 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Good corrosion resistance SPIL01 1 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 31.85, 'GBP', NOW());
    END IF;

    -- Non-gamma 2 amalgam alloy SPIL02 2 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Non-gamma 2 amalgam alloy SPIL02 2 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.88, 'GBP', NOW());
    END IF;

    -- high silver (70% Ag) SPIL03 3 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('high silver (70% Ag) SPIL03 3 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 47.56, 'GBP', NOW());
    END IF;

    -- • Wide occlusal plane AMARM241X 30g POA SPIL05 5 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Wide occlusal plane AMARM241X 30g POA SPIL05 5 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 71.22, 'GBP', NOW());
    END IF;

    -- • Strong and tough plastic MCY01 BSPIL01 1 Spill x 500...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Strong and tough plastic MCY01 BSPIL01 1 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 279.0, 'GBP', NOW());
    END IF;

    -- • Specially designed walls for extra Mercury 500gm Bottle BS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Specially designed walls for extra Mercury 500gm Bottle BSPIL02 2 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 23.5, 'GBP', NOW());
    END IF;

    -- • Specially designed walls for extra Mercury 500gm Bottle BS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Specially designed walls for extra Mercury 500gm Bottle BSPIL02 2 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 342.09, 'GBP', NOW());
    END IF;

    -- retention BSPIL03 3 Spill x 500...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('retention BSPIL03 3 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 396.13, 'GBP', NOW());
    END IF;

    -- • Tear resistant quality mesh BSPIL05 5 Spill x 500 BDSI Etc...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Tear resistant quality mesh BSPIL05 5 Spill x 500 BDSI Etchant Gel', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 627.7, 'GBP', NOW());
    END IF;

    -- 36pcs/pack aqueous orthophosphoric acid, green in...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('36pcs/pack aqueous orthophosphoric acid, green in', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.35, 'GBP', NOW());
    END IF;

    -- SSPIL1 1 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SSPIL1 1 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 33.47, 'GBP', NOW());
    END IF;

    -- SSPIL2 2 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SSPIL2 2 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 41.39, 'GBP', NOW());
    END IF;

    -- SSPIL3 3 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SSPIL3 3 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 49.94, 'GBP', NOW());
    END IF;

    -- SSPIL5 5 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SSPIL5 5 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 74.26, 'GBP', NOW());
    END IF;

    -- 48pcs/pack...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('48pcs/pack', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.35, 'GBP', NOW());
    END IF;

    -- SBSPIL1 1 Spill x 500 Best value...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SBSPIL1 1 Spill x 500 Best value', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 303.98, 'GBP', NOW());
    END IF;

    -- TB404 Anterior SBSPIL2 2 Spill x 500 ETCH04 50ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TB404 Anterior SBSPIL2 2 Spill x 500 ETCH04 50ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 359.29, 'GBP', NOW());
    END IF;

    -- TB404 Anterior SBSPIL2 2 Spill x 500 ETCH04 50ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TB404 Anterior SBSPIL2 2 Spill x 500 ETCH04 50ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.5, 'GBP', NOW());
    END IF;

    -- 32pcs/pack...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('32pcs/pack', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.35, 'GBP', NOW());
    END IF;

    -- SBSPIL3 3 Spill x 500...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SBSPIL3 3 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 444.88, 'GBP', NOW());
    END IF;

    -- SBSPIL5 5 Spill x 500...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SBSPIL5 5 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 658.87, 'GBP', NOW());
    END IF;

    -- 28pcs/pack...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('28pcs/pack', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.35, 'GBP', NOW());
    END IF;

    -- FSPIL1 1 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('FSPIL1 1 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 31.85, 'GBP', NOW());
    END IF;

    -- Ultracaps+ FSPIL2 2 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Ultracaps+ FSPIL2 2 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.88, 'GBP', NOW());
    END IF;

    -- Regular Set FSPIL3 3 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Regular Set FSPIL3 3 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 47.56, 'GBP', NOW());
    END IF;

    -- ALLOYS FBSPIL1 1 Spill x 500...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALLOYS FBSPIL1 1 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 279.0, 'GBP', NOW());
    END IF;

    -- ULTC1 1 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ULTC1 1 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 27.56, 'GBP', NOW());
    END IF;

    -- FBSPIL2 2 Spill x 500...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('FBSPIL2 2 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 342.09, 'GBP', NOW());
    END IF;

    -- ULTC2 2 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ULTC2 2 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 35.64, 'GBP', NOW());
    END IF;

    -- FBSPIL3 3 Spill x 500...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('FBSPIL3 3 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 396.13, 'GBP', NOW());
    END IF;

    -- ULTC3 3 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ULTC3 3 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 41.41, 'GBP', NOW());
    END IF;

    -- GS80P GS80 Powder 250g...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GS80P GS80 Powder 250g', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 627.7, 'GBP', NOW());
    END IF;

    -- ULTC5 5 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ULTC5 5 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 67.79, 'GBP', NOW());
    END IF;

    -- BULTC1 1 Spill x 500...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BULTC1 1 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 232.35, 'GBP', NOW());
    END IF;

    -- BULTC2 2 Spill x 500...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BULTC2 2 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 304.16, 'GBP', NOW());
    END IF;

    -- BULTC3 3 Spill x 500 37% Phosphoric acid thixotropic blue ge...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BULTC3 3 Spill x 500 37% Phosphoric acid thixotropic blue gel', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 380.12, 'GBP', NOW());
    END IF;

    -- SUPERETCH01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SUPERETCH01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 29.5, 'GBP', NOW());
    END IF;

    -- ULTCF1 1 Spill x 50 SUPERETCH04...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ULTCF1 1 Spill x 50 SUPERETCH04', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 27.56, 'GBP', NOW());
    END IF;

    -- ULTCF1 1 Spill x 50 SUPERETCH04...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ULTCF1 1 Spill x 50 SUPERETCH04', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 14.95, 'GBP', NOW());
    END IF;

    -- ULTCF2 2 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ULTCF2 2 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 35.64, 'GBP', NOW());
    END IF;

    -- BULTCF1 1 Spill x 500...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BULTCF1 1 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 232.35, 'GBP', NOW());
    END IF;

    -- BULTCF2 2 Spill x 500...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BULTCF2 2 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 304.16, 'GBP', NOW());
    END IF;

    -- LSPIL1 Lojic+1 Spill x 50 PSPIL1 1 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('LSPIL1 Lojic+1 Spill x 50 PSPIL1 1 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 44.52, 'GBP', NOW());
    END IF;

    -- LSPIL1 Lojic+1 Spill x 50 PSPIL1 1 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('LSPIL1 Lojic+1 Spill x 50 PSPIL1 1 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 44.52, 'GBP', NOW());
    END IF;

    -- LSPIL2 Lojic+2 Spill x 50 Full SDI range PSPIL2 2 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('LSPIL2 Lojic+2 Spill x 50 Full SDI range PSPIL2 2 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 55.86, 'GBP', NOW());
    END IF;

    -- LSPIL2 Lojic+2 Spill x 50 Full SDI range PSPIL2 2 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('LSPIL2 Lojic+2 Spill x 50 Full SDI range PSPIL2 2 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 55.86, 'GBP', NOW());
    END IF;

    -- LSPIL3 Lojic+3 Spill x 50 PSPIL3 3 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('LSPIL3 Lojic+3 Spill x 50 PSPIL3 3 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 65.14, 'GBP', NOW());
    END IF;

    -- LSPIL3 Lojic+3 Spill x 50 PSPIL3 3 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('LSPIL3 Lojic+3 Spill x 50 PSPIL3 3 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 65.14, 'GBP', NOW());
    END IF;

    -- LSPIL5 Lojic+5 Spill x 50 available – PSPIL5 5 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('LSPIL5 Lojic+5 Spill x 50 available – PSPIL5 5 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 96.62, 'GBP', NOW());
    END IF;

    -- LSPIL5 Lojic+5 Spill x 50 available – PSPIL5 5 Spill x 50...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('LSPIL5 Lojic+5 Spill x 50 available – PSPIL5 5 Spill x 50', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 96.62, 'GBP', NOW());
    END IF;

    -- BLSPIL1 Lojic+1 Spill x 500 BPSPIL1 1 Spill x 500 Metal Etch...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BLSPIL1 Lojic+1 Spill x 500 BPSPIL1 1 Spill x 500 Metal Etch Tips', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 354.87, 'GBP', NOW());
    END IF;

    -- BLSPIL1 Lojic+1 Spill x 500 BPSPIL1 1 Spill x 500 Metal Etch...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BLSPIL1 Lojic+1 Spill x 500 BPSPIL1 1 Spill x 500 Metal Etch Tips', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 354.87, 'GBP', NOW());
    END IF;

    -- BLSPIL2 Lojic+2 Spill x 500 please ask BPSPIL2 2 Spill x 500...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BLSPIL2 Lojic+2 Spill x 500 please ask BPSPIL2 2 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 450.5, 'GBP', NOW());
    END IF;

    -- BLSPIL2 Lojic+2 Spill x 500 please ask BPSPIL2 2 Spill x 500...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BLSPIL2 Lojic+2 Spill x 500 please ask BPSPIL2 2 Spill x 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 450.5, 'GBP', NOW());
    END IF;

    -- BLSPIL5 Lojic+5 Spill x 500 BPSPIL5 5 Spill x 500 MET01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BLSPIL5 Lojic+5 Spill x 500 BPSPIL5 5 Spill x 500 MET01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 807.7, 'GBP', NOW());
    END IF;

    -- BLSPIL5 Lojic+5 Spill x 500 BPSPIL5 5 Spill x 500 MET01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BLSPIL5 Lojic+5 Spill x 500 BPSPIL5 5 Spill x 500 MET01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 807.7, 'GBP', NOW());
    END IF;

    -- BLSPIL5 Lojic+5 Spill x 500 BPSPIL5 5 Spill x 500 MET01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BLSPIL5 Lojic+5 Spill x 500 BPSPIL5 5 Spill x 500 MET01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.95, 'GBP', NOW());
    END IF;

    -- Natural B2 ICE FCK01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Natural B2 ICE FCK01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 29.95, 'GBP', NOW());
    END IF;

    -- Natural B2 ICE FCK01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Natural B2 ICE FCK01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.95, 'GBP', NOW());
    END IF;

    -- ROK + SHADE all at microfilled hybrid composite. Designed...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ROK + SHADE all at microfilled hybrid composite. Designed', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 26.34, 'GBP', NOW());
    END IF;

    -- Buy 3 at for both anterior and posterior...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 at for both anterior and posterior', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 25.28, 'GBP', NOW());
    END IF;

    -- Buy 5 at restorations. Available in:...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 5 at restorations. Available in:', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.23, 'GBP', NOW());
    END IF;

    -- ICE + SHADE all at...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ICE + SHADE all at', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 23.97, 'GBP', NOW());
    END IF;

    -- Buy 3 at...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 at', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 23.16, 'GBP', NOW());
    END IF;

    -- Buy 5 at...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 5 at', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.41, 'GBP', NOW());
    END IF;

    -- Wave mv, Wave hv ICE + SHADE COMP...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Wave mv, Wave hv ICE + SHADE COMP', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 37.92, 'GBP', NOW());
    END IF;

    -- Buy 3 at Tekpro chemical cure paste/paste Sealant Light Cure...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 at Tekpro chemical cure paste/paste Sealant Light Cured', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 36.56, 'GBP', NOW());
    END IF;

    -- Buy 5 at composite. 28g kit containing: Excellent value Tekp...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 5 at composite. 28g kit containing: Excellent value Tekpro 6ML bottle', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 35.09, 'GBP', NOW());
    END IF;

    -- mv is medium and Wave hv is high. PASTE02 FS01 Clear...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('mv is medium and Wave hv is high. PASTE02 FS01 Clear', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.95, 'GBP', NOW());
    END IF;

    -- mv is medium and Wave hv is high. PASTE02 FS01 Clear...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('mv is medium and Wave hv is high. PASTE02 FS01 Clear', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.0, 'GBP', NOW());
    END IF;

    -- AVAILABLE IN 14 SHADES 3 rate each FS02 Opaque...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AVAILABLE IN 14 SHADES 3 rate each FS02 Opaque', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 18.95, 'GBP', NOW());
    END IF;

    -- AVAILABLE IN 14 SHADES 3 rate each FS02 Opaque...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AVAILABLE IN 14 SHADES 3 rate each FS02 Opaque', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.0, 'GBP', NOW());
    END IF;

    -- 5 rate each 4 or more rate each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 rate each 4 or more rate each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.95, 'GBP', NOW());
    END IF;

    -- 5 rate each 4 or more rate each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 rate each 4 or more rate each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.0, 'GBP', NOW());
    END IF;

    -- WAVES BEST SELLER...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WAVES BEST SELLER', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.14, 'GBP', NOW());
    END IF;

    -- WAVEC...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WAVEC', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 35.0, 'GBP', NOW());
    END IF;

    -- LCT01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('LCT01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.95, 'GBP', NOW());
    END IF;

    -- 2 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('2 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.95, 'GBP', NOW());
    END IF;

    -- COMPAP01 • Optimal light diffusion...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('COMPAP01 • Optimal light diffusion', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.95, 'GBP', NOW());
    END IF;

    -- COM248X3A1 Light...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('COM248X3A1 Light', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.95, 'GBP', NOW());
    END IF;

    -- COM248X3A2 Light Yellow...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('COM248X3A2 Light Yellow', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.95, 'GBP', NOW());
    END IF;

    -- COM248X3A3 Universal...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('COM248X3A3 Universal', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.95, 'GBP', NOW());
    END IF;

    -- COM248X3A3.5 Dark Yellow...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('COM248X3A3.5 Dark Yellow', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.95, 'GBP', NOW());
    END IF;

    -- Buy any 5 at each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy any 5 at each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.25, 'GBP', NOW());
    END IF;

    -- COM248X2A2 Light Yellow crowns, bridges, inlays and onlays...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('COM248X2A2 Light Yellow crowns, bridges, inlays and onlays', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- unidose complets COM248X2A3.5 Dark Yellow shade A3...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('unidose complets COM248X2A3.5 Dark Yellow shade A3', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- unidose complets COM248X2A3.5 Dark Yellow shade A3...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('unidose complets COM248X2A3.5 Dark Yellow shade A3', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 57.5, 'GBP', NOW());
    END IF;

    -- COMPAP...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('COMPAP', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 45.0, 'GBP', NOW());
    END IF;

    -- RIVAFS _ _ (shade) • Shades A2, A3, A3.5 in 12gm hand CRMM01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RIVAFS _ _ (shade) • Shades A2, A3, A3.5 in 12gm hand CRMM01 All for', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 64.5, 'GBP', NOW());
    END IF;

    -- RIVAFS _ _ (shade) • Shades A2, A3, A3.5 in 12gm hand CRMM01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RIVAFS _ _ (shade) • Shades A2, A3, A3.5 in 12gm hand CRMM01 All for', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 23.5, 'GBP', NOW());
    END IF;

    -- Riva Light Cure AMALGA2...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Riva Light Cure AMALGA2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 33.5, 'GBP', NOW());
    END IF;

    -- AMALGA3...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AMALGA3', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 33.5, 'GBP', NOW());
    END IF;

    -- AMALGA3.5...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AMALGA3.5', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 33.5, 'GBP', NOW());
    END IF;

    -- RIVARLC _ _ (shade)...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RIVARLC _ _ (shade)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 68.5, 'GBP', NOW());
    END IF;

    -- RIVASIL01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RIVASIL01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 69.75, 'GBP', NOW());
    END IF;

    -- AMALGCR Universal (CERK3) and pins. No corrosion. Fluoride...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AMALGCR Universal (CERK3) and pins. No corrosion. Fluoride', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 40.5, 'GBP', NOW());
    END IF;

    -- CNC01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CNC01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.75, 'GBP', NOW());
    END IF;

    -- 1 KIT...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('1 KIT', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 45.0, 'GBP', NOW());
    END IF;

    -- 2 KITS each Ceramcore B silver...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('2 KITS each Ceramcore B silver', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 42.75, 'GBP', NOW());
    END IF;

    -- 5 KITS each reinforced...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 KITS each reinforced', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 41.4, 'GBP', NOW());
    END IF;

    -- 1 Refill...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('1 Refill', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.7, 'GBP', NOW());
    END IF;

    -- 3 Rate each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('3 Rate each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.2, 'GBP', NOW());
    END IF;

    -- CERA01 AMALGINT ordering....
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CERA01 AMALGINT ordering.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.95, 'GBP', NOW());
    END IF;

    -- CERA01 AMALGINT ordering....
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CERA01 AMALGINT ordering.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 159.0, 'GBP', NOW());
    END IF;

    -- SRI01 Only...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SRI01 Only', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 28.5, 'GBP', NOW());
    END IF;

    -- Kind to pulp, bonds to tooth only FUJI_ _ Only your prosthes...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Kind to pulp, bonds to tooth only FUJI_ _ Only your prosthesis.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 41.6, 'GBP', NOW());
    END IF;

    -- release, tooth coloured, Radiopaque. FUJLC and Translucent. ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('release, tooth coloured, Radiopaque. FUJLC and Translucent. Riva Luting Plus is a resin modified,', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 35.07, 'GBP', NOW());
    END IF;

    -- 30g Powder Kit. FUJI Light cured conditioner 25g SET_ _ (Sha...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('30g Powder Kit. FUJI Light cured conditioner 25g SET_ _ (Shade) box of 50 self curing, glass ionomer luting', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 129.0, 'GBP', NOW());
    END IF;

    -- CMS01 FUJICON Assorted box of 50 contains 10 of each cement,...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CMS01 FUJICON Assorted box of 50 contains 10 of each cement, designed for final cementation', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.5, 'GBP', NOW());
    END IF;

    -- CMS01 FUJICON Assorted box of 50 contains 10 of each cement,...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CMS01 FUJICON Assorted box of 50 contains 10 of each cement, designed for final cementation', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 20.06, 'GBP', NOW());
    END IF;

    -- 2 KIT rate each FUJI PLUS02 liquid 8g...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('2 KIT rate each FUJI PLUS02 liquid 8g', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.0, 'GBP', NOW());
    END IF;

    -- SET01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SET01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 129.0, 'GBP', NOW());
    END IF;

    -- FUJIPLUS02 bridges, inlays and onlays plus ceramic...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('FUJIPLUS02 bridges, inlays and onlays plus ceramic', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 27.86, 'GBP', NOW());
    END IF;

    -- FUJIPLUS01 chemically bonds to dentin, enamel and...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('FUJIPLUS01 chemically bonds to dentin, enamel and', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 41.49, 'GBP', NOW());
    END IF;

    -- seTpp RIVALPC...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('seTpp RIVALPC', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 64.95, 'GBP', NOW());
    END IF;

    -- SETPP 2 x 7g...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SETPP 2 x 7g', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 67.95, 'GBP', NOW());
    END IF;

    -- HFSP01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HFSP01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 58.1, 'GBP', NOW());
    END IF;

    -- HFL01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HFL01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 18.95, 'GBP', NOW());
    END IF;

    -- Hi-Fi Liquid 10ml SET_ _ (Shade) box of 50 RIVALC for compos...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Hi-Fi Liquid 10ml SET_ _ (Shade) box of 50 RIVALC for composite restoration.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 125.0, 'GBP', NOW());
    END IF;

    -- Hi-Fi Liquid 10ml SET_ _ (Shade) box of 50 RIVALC for compos...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Hi-Fi Liquid 10ml SET_ _ (Shade) box of 50 RIVALC for composite restoration.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 48.12, 'GBP', NOW());
    END IF;

    -- Assorted box of 50 contains 10 of each CERI01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Assorted box of 50 contains 10 of each CERI01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 23.7, 'GBP', NOW());
    END IF;

    -- HFL02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HFL02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.95, 'GBP', NOW());
    END IF;

    -- SET01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SET01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 125.0, 'GBP', NOW());
    END IF;

    -- HFTC01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HFTC01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.95, 'GBP', NOW());
    END IF;

    -- HFDP_ _ _ RIVAPRO01 adhesion to dentine enamel and pins....
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HFDP_ _ _ RIVAPRO01 adhesion to dentine enamel and pins.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 26.95, 'GBP', NOW());
    END IF;

    -- HFDP_ _ _ RIVAPRO01 adhesion to dentine enamel and pins....
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HFDP_ _ _ RIVAPRO01 adhesion to dentine enamel and pins.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 68.49, 'GBP', NOW());
    END IF;

    -- HFP _ _ _ RIVAAPP RIVAPRO02 CRMB01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HFP _ _ _ RIVAAPP RIVAPRO02 CRMB01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- HFP _ _ _ RIVAAPP RIVAPRO02 CRMB01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HFP _ _ _ RIVAAPP RIVAPRO02 CRMB01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 31.0, 'GBP', NOW());
    END IF;

    -- HFP _ _ _ RIVAAPP RIVAPRO02 CRMB01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HFP _ _ _ RIVAAPP RIVAPRO02 CRMB01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 68.49, 'GBP', NOW());
    END IF;

    -- HFP _ _ _ RIVAAPP RIVAPRO02 CRMB01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HFP _ _ _ RIVAAPP RIVAPRO02 CRMB01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 21.0, 'GBP', NOW());
    END IF;

    -- go! VCAK01 All for...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('go! VCAK01 All for', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 26.99, 'GBP', NOW());
    END IF;

    -- Combi Pack VCR_ _ _ then shade each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Combi Pack VCR_ _ _ then shade each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.5, 'GBP', NOW());
    END IF;

    -- RZC01 rub or agitate it! Just one application is...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RZC01 rub or agitate it! Just one application is', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 18.5, 'GBP', NOW());
    END IF;

    -- RZP01 go! bottle kit 1 x 5ml...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RZP01 go! bottle kit 1 x 5ml', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.2, 'GBP', NOW());
    END IF;

    -- GO01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GO01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 59.0, 'GBP', NOW());
    END IF;

    -- RZL01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RZL01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.2, 'GBP', NOW());
    END IF;

    -- CMC01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CMC01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 21.5, 'GBP', NOW());
    END IF;

    -- TPB01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TPB01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 20.95, 'GBP', NOW());
    END IF;

    -- TPB02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TPB02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.95, 'GBP', NOW());
    END IF;

    -- KLZ01 40g Powder...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KLZ01 40g Powder', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.95, 'GBP', NOW());
    END IF;

    -- GO02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GO02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 59.0, 'GBP', NOW());
    END IF;

    -- KLZ02 15ml Liquid...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KLZ02 15ml Liquid', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.95, 'GBP', NOW());
    END IF;

    -- METP01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('METP01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.95, 'GBP', NOW());
    END IF;

    -- temporary filling. KLZ03 40g Powder BOND701 5ml BEST...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('temporary filling. KLZ03 40g Powder BOND701 5ml BEST', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.99, 'GBP', NOW());
    END IF;

    -- temporary filling. KLZ03 40g Powder BOND701 5ml BEST...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('temporary filling. KLZ03 40g Powder BOND701 5ml BEST', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 29.95, 'GBP', NOW());
    END IF;

    -- CBC01 KLZ04 15ml Liquid VALUE...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CBC01 KLZ04 15ml Liquid VALUE', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.0, 'GBP', NOW());
    END IF;

    -- CBC01 KLZ04 15ml Liquid VALUE...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CBC01 KLZ04 15ml Liquid VALUE', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.3, 'GBP', NOW());
    END IF;

    -- ENA01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ENA01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.95, 'GBP', NOW());
    END IF;

    -- DYC01 each Light cure self etching one step...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DYC01 each Light cure self etching one step', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.0, 'GBP', NOW());
    END IF;

    -- OCM01 CL01 BOND01 6ml + accessories ENA02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('OCM01 CL01 BOND01 6ml + accessories ENA02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.5, 'GBP', NOW());
    END IF;

    -- OCM01 CL01 BOND01 6ml + accessories ENA02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('OCM01 CL01 BOND01 6ml + accessories ENA02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.95, 'GBP', NOW());
    END IF;

    -- OCM01 CL01 BOND01 6ml + accessories ENA02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('OCM01 CL01 BOND01 6ml + accessories ENA02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 29.5, 'GBP', NOW());
    END IF;

    -- OCM01 CL01 BOND01 6ml + accessories ENA02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('OCM01 CL01 BOND01 6ml + accessories ENA02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 21.95, 'GBP', NOW());
    END IF;

    -- • Size 1⁄ 2 RSB00...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 1⁄ 2 RSB00', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 1 RSB01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 1 RSB01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 2 RSB02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 2 RSB02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 3 RSB03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 3 RSB03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 4 RSB04...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 4 RSB04', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 5 RSB05...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 5 RSB05', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 6 RSB06...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 6 RSB06', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 7 RSB07...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 7 RSB07', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 8 RSB08...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 8 RSB08', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 9 RSB09...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 9 RSB09', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.5, 'GBP', NOW());
    END IF;

    -- • Size 10 RSB10...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 10 RSB10', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.5, 'GBP', NOW());
    END IF;

    -- 85p per bur - BUY in BULK • Size 11 RSB11...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('85p per bur - BUY in BULK • Size 11 RSB11', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.5, 'GBP', NOW());
    END IF;

    -- In packs of 10 and save • Size 12 RSB12...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('In packs of 10 and save • Size 12 RSB12', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.5, 'GBP', NOW());
    END IF;

    -- Buy 20 get 4 FREE = 71p each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 20 get 4 FREE = 71p each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.2, 'GBP', NOW());
    END IF;

    -- • Size 1⁄ 2 ICSB00...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 1⁄ 2 ICSB00', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- Contains 24 burs in a box. • Size 1 ICSB01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Contains 24 burs in a box. • Size 1 ICSB01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- Kit contains 4 x 521, 4 x 522, • Size 2 ICSB02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Kit contains 4 x 521, 4 x 522, • Size 2 ICSB02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- 4 x 541, 4 x 542, 4 x 554, 4 x 556 • Size 3 ICSB03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('4 x 541, 4 x 542, 4 x 554, 4 x 556 • Size 3 ICSB03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- DBBUR01 • Size 4 ICSB04...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DBBUR01 • Size 4 ICSB04', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.95, 'GBP', NOW());
    END IF;

    -- DBBUR01 • Size 4 ICSB04...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DBBUR01 • Size 4 ICSB04', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 5 ICSB05...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 5 ICSB05', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 6 ICSB06...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 6 ICSB06', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- Bud HP Cross Cut ref 85 Bud HP Plain Cut ref 75 • Size 1⁄ 2 ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Bud HP Cross Cut ref 85 Bud HP Plain Cut ref 75 • Size 1⁄ 2 FFSB00', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 1 FFSB01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 1 FFSB01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • ISO size 060 ACR02 • ISO size 060 ACR04...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• ISO size 060 ACR02 • ISO size 060 ACR04', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.85, 'GBP', NOW());
    END IF;

    -- • ISO size 060 ACR02 • ISO size 060 ACR04...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• ISO size 060 ACR02 • ISO size 060 ACR04', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.35, 'GBP', NOW());
    END IF;

    -- • Size 2 FFSB02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 2 FFSB02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 3 FFSB03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 3 FFSB03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 4 FFSB04...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 4 FFSB04', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • Size 5 FFSB05...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Size 5 FFSB05', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- ref 87 ref 77 • Size 6 FFSB06...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ref 87 ref 77 • Size 6 FFSB06', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- • ISO size 060 ACR06 • ISO size 060 ACR07 • Size 7 FFSB07...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• ISO size 060 ACR06 • ISO size 060 ACR07 • Size 7 FFSB07', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.85, 'GBP', NOW());
    END IF;

    -- • ISO size 060 ACR06 • ISO size 060 ACR07 • Size 7 FFSB07...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• ISO size 060 ACR06 • ISO size 060 ACR07 • Size 7 FFSB07', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.35, 'GBP', NOW());
    END IF;

    -- • ISO size 060 ACR06 • ISO size 060 ACR07 • Size 7 FFSB07...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• ISO size 060 ACR06 • ISO size 060 ACR07 • Size 7 FFSB07', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.4, 'GBP', NOW());
    END IF;

    -- 5 PER PACK 5 PER PACK...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 PER PACK 5 PER PACK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.35, 'GBP', NOW());
    END IF;

    -- 5 PER PACK 5 PER PACK...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 PER PACK 5 PER PACK', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.35, 'GBP', NOW());
    END IF;

    -- FINBUR_ _ Each style...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('FINBUR_ _ Each style', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.7, 'GBP', NOW());
    END IF;

    -- SUPA01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SUPA01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 58.5, 'GBP', NOW());
    END IF;

    -- SURG03 TF 702 R/A Fitting TC_ _(FG) 35 37 38 TC_ _ _ _(FG) 1...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SURG03 TF 702 R/A Fitting TC_ _(FG) 35 37 38 TC_ _ _ _(FG) 1557 1558', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.5, 'GBP', NOW());
    END IF;

    -- SURG04 TF 702 H/P Fitting...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SURG04 TF 702 H/P Fitting', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.5, 'GBP', NOW());
    END IF;

    -- SURG01 Round 8 R/A Fitting...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SURG01 Round 8 R/A Fitting', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.5, 'GBP', NOW());
    END IF;

    -- SURG02 Round 8 H/P Fitting ISO Ø 1/10mm 010 012 ISO Ø 1/10mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SURG02 Round 8 H/P Fitting ISO Ø 1/10mm 010 012 ISO Ø 1/10mm 009 012 ( S C U oa P r A s D e) 0 R 1 e f i l l B l a c k .', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.5, 'GBP', NOW());
    END IF;

    -- SURG02 Round 8 H/P Fitting ISO Ø 1/10mm 010 012 ISO Ø 1/10mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SURG02 Round 8 H/P Fitting ISO Ø 1/10mm 010 012 ISO Ø 1/10mm 009 012 ( S C U oa P r A s D e) 0 R 1 e f i l l B l a c k .', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.95, 'GBP', NOW());
    END IF;

    -- SUPAD02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SUPAD02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.95, 'GBP', NOW());
    END IF;

    -- SUPAD03...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SUPAD03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.95, 'GBP', NOW());
    END IF;

    -- SUPAD04...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SUPAD04', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.95, 'GBP', NOW());
    END IF;

    -- A solid base chrome plated bur stand ISO Ø 1/10mm 012 016 02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('A solid base chrome plated bur stand ISO Ø 1/10mm 012 016 021 ISO Ø 1/10mm 012 008 010 SUPAD05', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.95, 'GBP', NOW());
    END IF;

    -- of Each. US No. 701 702 703 US No. 332 330 331 SUPAD06...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('of Each. US No. 701 702 703 US No. 332 330 331 SUPAD06', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.95, 'GBP', NOW());
    END IF;

    -- CPBS01 (12 FG burs) TC_ _ _(FG) 701 702 703 TC_ _ _(FG) 332 ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CPBS01 (12 FG burs) TC_ _ _(FG) 701 702 703 TC_ _ _(FG) 332 330 331 Shofu Super=Snap', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.95, 'GBP', NOW());
    END IF;

    -- CPBS02 (12 RA burs) TC_ _ _(RA) 701 702 – Mandrels (Ca)...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CPBS02 (12 RA burs) TC_ _ _(RA) 701 702 – Mandrels (Ca)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.95, 'GBP', NOW());
    END IF;

    -- CPBS03 (6 FG 6 RA burs) TC_ _ _(HP) 701 702 –...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CPBS03 (6 FG 6 RA burs) TC_ _ _(HP) 701 702 –', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.95, 'GBP', NOW());
    END IF;

    -- SUPAMAN...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SUPAMAN', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 18.5, 'GBP', NOW());
    END IF;

    -- PBT01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PBT01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.95, 'GBP', NOW());
    END IF;

    -- SUPAST01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SUPAST01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.6, 'GBP', NOW());
    END IF;

    -- SUPAST02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SUPAST02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.6, 'GBP', NOW());
    END IF;

    -- BBL01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BBL01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.5, 'GBP', NOW());
    END IF;

    -- SOF-FMAN quality....
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SOF-FMAN quality.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.5, 'GBP', NOW());
    END IF;

    -- PROPH01 Buy 1 at...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PROPH01 Buy 1 at', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.95, 'GBP', NOW());
    END IF;

    -- Buy 2 at...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 2 at', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.5, 'GBP', NOW());
    END IF;

    -- SOF-LEXpop on disc refills Buy 5 at...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SOF-LEXpop on disc refills Buy 5 at', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 29.95, 'GBP', NOW());
    END IF;

    -- SOF-LEXpop on disc refills Buy 5 at...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SOF-LEXpop on disc refills Buy 5 at', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.25, 'GBP', NOW());
    END IF;

    -- Standard 1/2” - 12.7mm BBS01 BBL01N...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Standard 1/2” - 12.7mm BBS01 BBL01N', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.5, 'GBP', NOW());
    END IF;

    -- Standard 1/2” - 12.7mm BBS01 BBL01N...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Standard 1/2” - 12.7mm BBS01 BBL01N', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.5, 'GBP', NOW());
    END IF;

    -- DLPP01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DLPP01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.95, 'GBP', NOW());
    END IF;

    -- BBS01N BBSN01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BBS01N BBSN01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.5, 'GBP', NOW());
    END IF;

    -- BBS01N BBSN01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BBS01N BBSN01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 18.0, 'GBP', NOW());
    END IF;

    -- PCSN01 Buy 1 bag PCL01 Buy 1 bag PCS01 Buy 1 bag...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PCSN01 Buy 1 bag PCL01 Buy 1 bag PCS01 Buy 1 bag', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.5, 'GBP', NOW());
    END IF;

    -- PCSN01 Buy 1 bag PCL01 Buy 1 bag PCS01 Buy 1 bag...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PCSN01 Buy 1 bag PCL01 Buy 1 bag PCS01 Buy 1 bag', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.5, 'GBP', NOW());
    END IF;

    -- PCSN01 Buy 1 bag PCL01 Buy 1 bag PCS01 Buy 1 bag...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PCSN01 Buy 1 bag PCL01 Buy 1 bag PCS01 Buy 1 bag', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.5, 'GBP', NOW());
    END IF;

    -- PCSN01 Buy 5 bags each PCL01 Buy 5 bags each PCS01 Buy 5 bag...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PCSN01 Buy 5 bags each PCL01 Buy 5 bags each PCS01 Buy 5 bags each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.0, 'GBP', NOW());
    END IF;

    -- PCSN01 Buy 5 bags each PCL01 Buy 5 bags each PCS01 Buy 5 bag...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PCSN01 Buy 5 bags each PCL01 Buy 5 bags each PCS01 Buy 5 bags each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.5, 'GBP', NOW());
    END IF;

    -- PCSN01 Buy 5 bags each PCL01 Buy 5 bags each PCS01 Buy 5 bag...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PCSN01 Buy 5 bags each PCL01 Buy 5 bags each PCS01 Buy 5 bags each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.0, 'GBP', NOW());
    END IF;

    -- PCSN01 Buy 10 bags each PCL01 Buy 10 bags each PCS01 Buy 10 ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PCSN01 Buy 10 bags each PCL01 Buy 10 bags each PCS01 Buy 10 bags each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.5, 'GBP', NOW());
    END IF;

    -- PCSN01 Buy 10 bags each PCL01 Buy 10 bags each PCS01 Buy 10 ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PCSN01 Buy 10 bags each PCL01 Buy 10 bags each PCS01 Buy 10 bags each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.5, 'GBP', NOW());
    END IF;

    -- PCSN01 Buy 10 bags each PCL01 Buy 10 bags each PCS01 Buy 10 ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PCSN01 Buy 10 bags each PCL01 Buy 10 bags each PCS01 Buy 10 bags each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.5, 'GBP', NOW());
    END IF;

    -- ALTM01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALTM01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 49.5, 'GBP', NOW());
    END IF;

    -- Canines EX-LGE Canines Lower Canines Molars ALTCR_ _ _...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Canines EX-LGE Canines Lower Canines Molars ALTCR_ _ _', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.95, 'GBP', NOW());
    END IF;

    -- ALTPM01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALTPM01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 42.5, 'GBP', NOW());
    END IF;

    -- per pair 20 pins + 1 drill...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('per pair 20 pins + 1 drill', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.45, 'GBP', NOW());
    END IF;

    -- …201 …202 …211 …212 60 assorted...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('…201 …202 …211 …212 60 assorted', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 29.95, 'GBP', NOW());
    END IF;

    -- …201 …202 …211 …212 60 assorted...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('…201 …202 …211 …212 60 assorted', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.45, 'GBP', NOW());
    END IF;

    -- CCFKIT...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CCFKIT', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 29.95, 'GBP', NOW());
    END IF;

    -- CCFKIT...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CCFKIT', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.25, 'GBP', NOW());
    END IF;

    -- SHELL01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SHELL01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 27.95, 'GBP', NOW());
    END IF;

    -- FPS01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('FPS01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.95, 'GBP', NOW());
    END IF;

    -- Temporary Crowns FPS02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Temporary Crowns FPS02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.95, 'GBP', NOW());
    END IF;

    -- GPA01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GPA01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 54.95, 'GBP', NOW());
    END IF;

    -- PTC01 PTCR – – –...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PTC01 PTCR – – –', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 42.5, 'GBP', NOW());
    END IF;

    -- PTC01 PTCR – – –...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PTC01 PTCR – – –', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.95, 'GBP', NOW());
    END IF;

    -- GPA _ _ _ _...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GPA _ _ _ _', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.65, 'GBP', NOW());
    END IF;

    -- UPPER RIGHT CUSPID 300 301 30 31 32 33 34 6 GPARS06 GPARM06 ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('UPPER RIGHT CUSPID 300 301 30 31 32 33 34 6 GPARS06 GPARM06 GPARL06 GPARXL06', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.49, 'GBP', NOW());
    END IF;

    -- BICUSP SMALL 50 51 52 53 54 - - GPK01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BICUSP SMALL 50 51 52 53 54 - - GPK01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.55, 'GBP', NOW());
    END IF;

    -- L/ANTS LONG 60 61 62 63 64 - - FPD02 100 pack Blue KEY Cross...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('L/ANTS LONG 60 61 62 63 64 - - FPD02 100 pack Blue KEY Cross', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 26.3, 'GBP', NOW());
    END IF;

    -- L/ANTS SHORT 65 66 67 68 69 - - FPD02A 100 pack Green GPK02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('L/ANTS SHORT 65 66 67 68 69 - - FPD02A 100 pack Green GPK02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 26.3, 'GBP', NOW());
    END IF;

    -- L/ANTS SHORT 65 66 67 68 69 - - FPD02A 100 pack Green GPK02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('L/ANTS SHORT 65 66 67 68 69 - - FPD02A 100 pack Green GPK02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.55, 'GBP', NOW());
    END IF;

    -- FM01 Looped type...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('FM01 Looped type', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.35, 'GBP', NOW());
    END IF;

    -- FM02 Tie on type...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('FM02 Tie on type', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.35, 'GBP', NOW());
    END IF;

    -- 10 Box Rate Plastic Aprons...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Box Rate Plastic Aprons', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.95, 'GBP', NOW());
    END IF;

    -- DA01 white BLHOH01 Ladies black...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DA01 white BLHOH01 Ladies black', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.95, 'GBP', NOW());
    END IF;

    -- DA01 white BLHOH01 Ladies black...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DA01 white BLHOH01 Ladies black', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.95, 'GBP', NOW());
    END IF;

    -- DA02 blue BLHOG02 Ladies blue...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DA02 blue BLHOG02 Ladies blue', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.95, 'GBP', NOW());
    END IF;

    -- DA02 blue BLHOG02 Ladies blue...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DA02 blue BLHOG02 Ladies blue', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.95, 'GBP', NOW());
    END IF;

    -- 5 Rate BLHOG03 Ladies pink...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 Rate BLHOG03 Ladies pink', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.95, 'GBP', NOW());
    END IF;

    -- 5 Rate BLHOG03 Ladies pink...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 Rate BLHOG03 Ladies pink', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.95, 'GBP', NOW());
    END IF;

    -- BLHOG04 Gents black...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BLHOG04 Gents black', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.95, 'GBP', NOW());
    END IF;

    -- BLHOG05 Gents blue...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BLHOG05 Gents blue', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.95, 'GBP', NOW());
    END IF;

    -- BLHOG07 Childs blue...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BLHOG07 Childs blue', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.95, 'GBP', NOW());
    END IF;

    -- 1 Box Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('1 Box Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.44, 'GBP', NOW());
    END IF;

    -- 5 Box Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 Box Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.65, 'GBP', NOW());
    END IF;

    -- 10 Box Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Box Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.13, 'GBP', NOW());
    END IF;

    -- 20+ Box Rate 50 x 80cm paper bib with perforated...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20+ Box Rate 50 x 80cm paper bib with perforated', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.6, 'GBP', NOW());
    END IF;

    -- BIBROLL01 white...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BIBROLL01 white', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.95, 'GBP', NOW());
    END IF;

    -- BVB01 1 Rate BIBROLL02 blue...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BVB01 1 Rate BIBROLL02 blue', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.05, 'GBP', NOW());
    END IF;

    -- BVB01 1 Rate BIBROLL02 blue...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BVB01 1 Rate BIBROLL02 blue', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.95, 'GBP', NOW());
    END IF;

    -- BVB01 5 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BVB01 5 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.95, 'GBP', NOW());
    END IF;

    -- KGA01 Adults...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KGA01 Adults', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.75, 'GBP', NOW());
    END IF;

    -- BVB01 10 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BVB01 10 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.85, 'GBP', NOW());
    END IF;

    -- KGS02 Childrens...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('KGS02 Childrens', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.75, 'GBP', NOW());
    END IF;

    -- 1 Box Rate Two ply polythene backed absorbent glasses with s...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('1 Box Rate Two ply polythene backed absorbent glasses with side shields and Protect+ visor mask set', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.3, 'GBP', NOW());
    END IF;

    -- 10 Box Rate chains. Size 33 x 48cm. small medium large. Fram...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Box Rate chains. Size 33 x 48cm. small medium large. Frame and 6 shields', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.5, 'GBP', NOW());
    END IF;

    -- 10 Box Rate chains. Size 33 x 48cm. small medium large. Fram...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Box Rate chains. Size 33 x 48cm. small medium large. Frame and 6 shields', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.95, 'GBP', NOW());
    END IF;

    -- 20 Box Rate DISPAPR01 Box 500 SGA01 PVMS02 12 pack shields...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Box Rate DISPAPR01 Box 500 SGA01 PVMS02 12 pack shields', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.3, 'GBP', NOW());
    END IF;

    -- 20 Box Rate DISPAPR01 Box 500 SGA01 PVMS02 12 pack shields...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Box Rate DISPAPR01 Box 500 SGA01 PVMS02 12 pack shields', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.5, 'GBP', NOW());
    END IF;

    -- 20 Box Rate DISPAPR01 Box 500 SGA01 PVMS02 12 pack shields...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Box Rate DISPAPR01 Box 500 SGA01 PVMS02 12 pack shields', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.95, 'GBP', NOW());
    END IF;

    -- 20 Box Rate DISPAPR01 Box 500 SGA01 PVMS02 12 pack shields...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Box Rate DISPAPR01 Box 500 SGA01 PVMS02 12 pack shields', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 14.95, 'GBP', NOW());
    END IF;

    -- Hand Wash WL500 and viruses including HIV...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Hand Wash WL500 and viruses including HIV', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.0, 'GBP', NOW());
    END IF;

    -- WL1000 and MRSA....
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WL1000 and MRSA.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.0, 'GBP', NOW());
    END IF;

    -- MIKR01 tub 200...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MIKR01 tub 200', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.75, 'GBP', NOW());
    END IF;

    -- needs of the NHS. MIKR02 refill 200 • Advantages - effective...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('needs of the NHS. MIKR02 refill 200 • Advantages - effective in 2 minutes,', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.45, 'GBP', NOW());
    END IF;

    -- MELIF01 750ml Spray...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MELIF01 750ml Spray', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.49, 'GBP', NOW());
    END IF;

    -- 6 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.25, 'GBP', NOW());
    END IF;

    -- LIFO01 500ml Pump Scrub Brushes...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('LIFO01 500ml Pump Scrub Brushes', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.99, 'GBP', NOW());
    END IF;

    -- 6 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.79, 'GBP', NOW());
    END IF;

    -- LIFO02 1ltr Pump SCB01 with handle dental instruments and se...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('LIFO02 1ltr Pump SCB01 with handle dental instruments and sensitive', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.99, 'GBP', NOW());
    END IF;

    -- LIFO02 1ltr Pump SCB01 with handle dental instruments and se...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('LIFO02 1ltr Pump SCB01 with handle dental instruments and sensitive', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.95, 'GBP', NOW());
    END IF;

    -- 6 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.79, 'GBP', NOW());
    END IF;

    -- SCB02 without surfaces. 5L...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SCB02 without surfaces. 5L', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.95, 'GBP', NOW());
    END IF;

    -- NEUT01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('NEUT01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 28.5, 'GBP', NOW());
    END IF;

    -- 6 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.8, 'GBP', NOW());
    END IF;

    -- Bulk 12 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Bulk 12 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.4, 'GBP', NOW());
    END IF;

    -- 24 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('24 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.3, 'GBP', NOW());
    END IF;

    -- SOFT01 500ml Pump MELIW01 Tub 100 Wipes Low working concentr...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SOFT01 500ml Pump MELIW01 Tub 100 Wipes Low working concentrations:', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.69, 'GBP', NOW());
    END IF;

    -- SOFT01 500ml Pump MELIW01 Tub 100 Wipes Low working concentr...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SOFT01 500ml Pump MELIW01 Tub 100 Wipes Low working concentrations:', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.79, 'GBP', NOW());
    END IF;

    -- 6 Rate 6 Rate Hard surface disinfectant spray 2 % for 15 min...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 Rate 6 Rate Hard surface disinfectant spray 2 % for 15 minutes, 1 % for 30', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.49, 'GBP', NOW());
    END IF;

    -- 6 Rate 6 Rate Hard surface disinfectant spray 2 % for 15 min...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 Rate 6 Rate Hard surface disinfectant spray 2 % for 15 minutes, 1 % for 30', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.59, 'GBP', NOW());
    END IF;

    -- SOFT02 1ltr Pump MELIW02 Refill 100 Wipes economy refill. mi...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SOFT02 1ltr Pump MELIW02 Refill 100 Wipes economy refill. minutes, 0.5 % for 1 hour', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.49, 'GBP', NOW());
    END IF;

    -- SOFT02 1ltr Pump MELIW02 Refill 100 Wipes economy refill. mi...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SOFT02 1ltr Pump MELIW02 Refill 100 Wipes economy refill. minutes, 0.5 % for 1 hour', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.49, 'GBP', NOW());
    END IF;

    -- 6 Rate 6 Rate SURFD01 5ltr STAB01 1ltr...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 Rate 6 Rate SURFD01 5ltr STAB01 1ltr', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.29, 'GBP', NOW());
    END IF;

    -- 6 Rate 6 Rate SURFD01 5ltr STAB01 1ltr...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 Rate 6 Rate SURFD01 5ltr STAB01 1ltr', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.39, 'GBP', NOW());
    END IF;

    -- 6 Rate 6 Rate SURFD01 5ltr STAB01 1ltr...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 Rate 6 Rate SURFD01 5ltr STAB01 1ltr', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.9, 'GBP', NOW());
    END IF;

    -- 6 Rate 6 Rate SURFD01 5ltr STAB01 1ltr...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 Rate 6 Rate SURFD01 5ltr STAB01 1ltr', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 13.49, 'GBP', NOW());
    END IF;

    -- RCD01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RCD01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.35, 'GBP', NOW());
    END IF;

    -- • Spearmint Flavour HT01 23 x 33cm Gauze Napkins...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Spearmint Flavour HT01 23 x 33cm Gauze Napkins', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 18.0, 'GBP', NOW());
    END IF;

    -- 1 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('1 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.95, 'GBP', NOW());
    END IF;

    -- MWC01 100ml 6 Rate Sterilised Pellets....
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MWC01 100ml 6 Rate Sterilised Pellets.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.99, 'GBP', NOW());
    END IF;

    -- MWC01 100ml 6 Rate Sterilised Pellets....
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MWC01 100ml 6 Rate Sterilised Pellets.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.75, 'GBP', NOW());
    END IF;

    -- 6 Rate CPJJ01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 Rate CPJJ01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.99, 'GBP', NOW());
    END IF;

    -- 6 Rate CPJJ01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('6 Rate CPJJ01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.5, 'GBP', NOW());
    END IF;

    -- Rolls CPDISP01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Rolls CPDISP01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.5, 'GBP', NOW());
    END IF;

    -- MCF01 DISPOSABLE CUPS...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MCF01 DISPOSABLE CUPS', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 20.0, 'GBP', NOW());
    END IF;

    -- Mixed MWT06 1 Ply white. 300mtr x 6 Rolls. THR01 1 x 10m Rol...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Mixed MWT06 1 Ply white. 300mtr x 6 Rolls. THR01 1 x 10m Roll', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.4, 'GBP', NOW());
    END IF;

    -- 1 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('1 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.55, 'GBP', NOW());
    END IF;

    -- SCF01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SCF01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.0, 'GBP', NOW());
    END IF;

    -- 5 x 10m Roll...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 x 10m Roll', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.1, 'GBP', NOW());
    END IF;

    -- 5 Rate 10 x 10m Roll...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 Rate 10 x 10m Roll', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.35, 'GBP', NOW());
    END IF;

    -- 5 Rate 10 x 10m Roll...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 Rate 10 x 10m Roll', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.8, 'GBP', NOW());
    END IF;

    -- 10 Rate Centre Feed Roll...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Rate Centre Feed Roll', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.15, 'GBP', NOW());
    END IF;

    -- CFR01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CFR01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 18.25, 'GBP', NOW());
    END IF;

    -- DC01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('DC01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 23.99, 'GBP', NOW());
    END IF;

    -- 20% chlorhexidine mouthwash Sosoft. Cotton Wool Rolls - DC02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20% chlorhexidine mouthwash Sosoft. Cotton Wool Rolls - DC02 All for', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 32.99, 'GBP', NOW());
    END IF;

    -- 1 Box Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('1 Box Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.75, 'GBP', NOW());
    END IF;

    -- 3 x 500ml assorted...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('3 x 500ml assorted', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.0, 'GBP', NOW());
    END IF;

    -- 10 Box Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Box Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.65, 'GBP', NOW());
    END IF;

    -- 3 x 500ml mint...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('3 x 500ml mint', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.0, 'GBP', NOW());
    END IF;

    -- antiseptic mouthwash 2 Ply white. 125 sheets x 18 Rolls. 1 B...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('antiseptic mouthwash 2 Ply white. 125 sheets x 18 Rolls. 1 Box Rate Wall mounted', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.95, 'GBP', NOW());
    END IF;

    -- RT01 10 Box Rate DCH001...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RT01 10 Box Rate DCH001', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 27.95, 'GBP', NOW());
    END IF;

    -- RT01 10 Box Rate DCH001...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RT01 10 Box Rate DCH001', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.85, 'GBP', NOW());
    END IF;

    -- RT01 10 Box Rate DCH001...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('RT01 10 Box Rate DCH001', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.95, 'GBP', NOW());
    END IF;

    -- Large Tubing Covers 457mm x 53mm XRHC01 pack 250...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Large Tubing Covers 457mm x 53mm XRHC01 pack 250', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.95, 'GBP', NOW());
    END IF;

    -- TUBC01 pack 250...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TUBC01 pack 250', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.95, 'GBP', NOW());
    END IF;

    -- ACP07 59 x 127 mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ACP07 59 x 127 mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.5, 'GBP', NOW());
    END IF;

    -- 5 Box Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 Box Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.1, 'GBP', NOW());
    END IF;

    -- 10 Box Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 Box Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.72, 'GBP', NOW());
    END IF;

    -- HCC01 pack 125...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HCC01 pack 125', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.95, 'GBP', NOW());
    END IF;

    -- ACP08 83 x 159 mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ACP08 83 x 159 mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.59, 'GBP', NOW());
    END IF;

    -- ACP10 135 x 278 mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ACP10 135 x 278 mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.9, 'GBP', NOW());
    END IF;

    -- XRSC01 pack 500...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('XRSC01 pack 500', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.95, 'GBP', NOW());
    END IF;

    -- AWSC01 pack 500 75mm Width...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AWSC01 pack 500 75mm Width', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.95, 'GBP', NOW());
    END IF;

    -- AWSC01 pack 500 75mm Width...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AWSC01 pack 500 75mm Width', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.95, 'GBP', NOW());
    END IF;

    -- 100mm Width...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('100mm Width', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.95, 'GBP', NOW());
    END IF;

    -- 150mm Width...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('150mm Width', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 23.95, 'GBP', NOW());
    END IF;

    -- Digital X Ray 200mm Width...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Digital X Ray 200mm Width', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 29.95, 'GBP', NOW());
    END IF;

    -- Size 0 (20x30) Box 100...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Size 0 (20x30) Box 100', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.5, 'GBP', NOW());
    END IF;

    -- Size 1 (20x40) Box 100...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Size 1 (20x40) Box 100', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.5, 'GBP', NOW());
    END IF;

    -- WrapAround provides a mechanical Size 2 (30x40) Box 300...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WrapAround provides a mechanical Size 2 (30x40) Box 300', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- WABF01 DISPO01 Size 4 (54x75) Bbox 100...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WABF01 DISPO01 Size 4 (54x75) Bbox 100', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.5, 'GBP', NOW());
    END IF;

    -- WABF01 DISPO01 Size 4 (54x75) Bbox 100...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WABF01 DISPO01 Size 4 (54x75) Bbox 100', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.6, 'GBP', NOW());
    END IF;

    -- WABF01 DISPO01 Size 4 (54x75) Bbox 100...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('WABF01 DISPO01 Size 4 (54x75) Bbox 100', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.0, 'GBP', NOW());
    END IF;

    -- MPA01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MPA01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.85, 'GBP', NOW());
    END IF;

    -- MPB01 MXS01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MPB01 MXS01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.95, 'GBP', NOW());
    END IF;

    -- MPB01 MXS01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MPB01 MXS01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.55, 'GBP', NOW());
    END IF;

    -- MPC01 Tekpro applicators 100 pack...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MPC01 Tekpro applicators 100 pack', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.95, 'GBP', NOW());
    END IF;

    -- MAP01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MAP01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.99, 'GBP', NOW());
    END IF;

    -- MXW01 2...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MXW01 2', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.75, 'GBP', NOW());
    END IF;

    -- GSPP01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GSPP01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.9, 'GBP', NOW());
    END IF;

    -- GSPP02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GSPP02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 10.25, 'GBP', NOW());
    END IF;

    -- GSF01 APB01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GSF01 APB01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.9, 'GBP', NOW());
    END IF;

    -- GSF01 APB01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('GSF01 APB01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.95, 'GBP', NOW());
    END IF;

    -- POIN01 Medium...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POIN01 Medium', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.0, 'GBP', NOW());
    END IF;

    -- POIN02 Assorted...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POIN02 Assorted', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.0, 'GBP', NOW());
    END IF;

    -- POIN03 Fine...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POIN03 Fine', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.0, 'GBP', NOW());
    END IF;

    -- Dishes POIN04 Superfine...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Dishes POIN04 Superfine', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.0, 'GBP', NOW());
    END IF;

    -- 5 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.5, 'GBP', NOW());
    END IF;

    -- PDP01 Metal Etch Tips...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('PDP01 Metal Etch Tips', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.99, 'GBP', NOW());
    END IF;

    -- MET01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MET01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.95, 'GBP', NOW());
    END IF;

    -- CAT21 11mm Item 14...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CAT21 11mm Item 14', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.0, 'GBP', NOW());
    END IF;

    -- CAT22 16mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CAT22 16mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.0, 'GBP', NOW());
    END IF;

    -- CAT23 11mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CAT23 11mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 45.0, 'GBP', NOW());
    END IF;

    -- CAT24 16mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('CAT24 16mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 45.0, 'GBP', NOW());
    END IF;

    -- HYGO02 Bags of 100...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HYGO02 Bags of 100', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.55, 'GBP', NOW());
    END IF;

    -- Item 15 10 packs for...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Item 15 10 packs for', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.0, 'GBP', NOW());
    END IF;

    -- STERI01 16mm tips...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('STERI01 16mm tips', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 14.75, 'GBP', NOW());
    END IF;

    -- STERI02 11mm tips...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('STERI02 11mm tips', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 13.75, 'GBP', NOW());
    END IF;

    -- BABYJET01 16mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BABYJET01 16mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 14.95, 'GBP', NOW());
    END IF;

    -- used with amalgam collector Active...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('used with amalgam collector Active', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.95, 'GBP', NOW());
    END IF;

    -- SEC01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SEC01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.9, 'GBP', NOW());
    END IF;

    -- Item 19 10 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Item 19 10 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.68, 'GBP', NOW());
    END IF;

    -- 10 packs for SUT01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 packs for SUT01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 21.0, 'GBP', NOW());
    END IF;

    -- 10 packs for SUT01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 packs for SUT01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.95, 'GBP', NOW());
    END IF;

    -- 10 packs for SUT01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 packs for SUT01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.0, 'GBP', NOW());
    END IF;

    -- 10 packs for SUT01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('10 packs for SUT01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 9.95, 'GBP', NOW());
    END IF;

    -- VELCLEAN ARTIPAP01 80µ Kerr Hawe Strips...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('VELCLEAN ARTIPAP01 80µ Kerr Hawe Strips', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.5, 'GBP', NOW());
    END IF;

    -- VELCLEAN ARTIPAP01 80µ Kerr Hawe Strips...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('VELCLEAN ARTIPAP01 80µ Kerr Hawe Strips', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.95, 'GBP', NOW());
    END IF;

    -- TRANS01 8mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TRANS01 8mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.25, 'GBP', NOW());
    END IF;

    -- Box of 2000 Envelopes. TRANS02 6mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Box of 2000 Envelopes. TRANS02 6mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.25, 'GBP', NOW());
    END IF;

    -- XRE01 XFH01 1 Film...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('XRE01 XFH01 1 Film', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.95, 'GBP', NOW());
    END IF;

    -- XRE01 XFH01 1 Film...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('XRE01 XFH01 1 Film', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.95, 'GBP', NOW());
    END IF;

    -- XFH02 10 Films...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('XFH02 10 Films', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 13.95, 'GBP', NOW());
    END IF;

    -- See page 45 for X-Ray XFH03 14 Films...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('See page 45 for X-Ray XFH03 14 Films', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 14.95, 'GBP', NOW());
    END IF;

    -- AGFA02 Bausch...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('AGFA02 Bausch', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 32.99, 'GBP', NOW());
    END IF;

    -- ARTIPBRA...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTIPBRA', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 11.2, 'GBP', NOW());
    END IF;

    -- ARTIPAP02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTIPAP02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.45, 'GBP', NOW());
    END IF;

    -- Developer & Fixer Refill 12 z 12 thin blue 71µ MYLA01 Refill...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Developer & Fixer Refill 12 z 12 thin blue 71µ MYLA01 Refill and dispenser', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.95, 'GBP', NOW());
    END IF;

    -- ARTIC02 MYLA02 Refill...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTIC02 MYLA02 Refill', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.35, 'GBP', NOW());
    END IF;

    -- ARTIC02 MYLA02 Refill...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ARTIC02 MYLA02 Refill', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.5, 'GBP', NOW());
    END IF;

    -- XRD01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('XRD01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 20.95, 'GBP', NOW());
    END IF;

    -- Intra-oral x-ray films with the 2 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Intra-oral x-ray films with the 2 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.5, 'GBP', NOW());
    END IF;

    -- offers superb quality, is easy to work XRF01 hygiene message...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('offers superb quality, is easy to work XRF01 hygiene message on each one they', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.95, 'GBP', NOW());
    END IF;

    -- E-Speed Film XRD02...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('E-Speed Film XRD02', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 20.95, 'GBP', NOW());
    END IF;

    -- MOT04...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('MOT04', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.99, 'GBP', NOW());
    END IF;

    -- Flexible, soft adult periapical X-Ray film 2 Rate...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Flexible, soft adult periapical X-Ray film 2 Rate', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.5, 'GBP', NOW());
    END IF;

    -- EX01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('EX01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 20.95, 'GBP', NOW());
    END IF;

    -- 5 Rate each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 Rate each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.9, 'GBP', NOW());
    END IF;

    -- *Mimimum per order otherwise...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('*Mimimum per order otherwise', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.0, 'GBP', NOW());
    END IF;

    -- Bite Wing Tabs Royal Mail postage or...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Bite Wing Tabs Royal Mail postage or', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3.5, 'GBP', NOW());
    END IF;

    -- Bite Wing Tabs Royal Mail postage or...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Bite Wing Tabs Royal Mail postage or', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.0, 'GBP', NOW());
    END IF;

    -- BWT01 XRDKO10 Developer...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BWT01 XRDKO10 Developer', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.95, 'GBP', NOW());
    END IF;

    -- BWT01 XRDKO10 Developer...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BWT01 XRDKO10 Developer', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.95, 'GBP', NOW());
    END IF;

    -- 2 Rate each XRFKO01 Fixer...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('2 Rate each XRFKO01 Fixer', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.25, 'GBP', NOW());
    END IF;

    -- 2 Rate each XRFKO01 Fixer...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('2 Rate each XRFKO01 Fixer', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.95, 'GBP', NOW());
    END IF;

    -- Standard kit • Neutral pH and desensitizing releasing desens...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Standard kit • Neutral pH and desensitizing releasing desensitizing gel POLAP', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 17.25, 'GBP', NOW());
    END IF;

    -- additives to minimize sensitivity • 6% Potassium nitrate Buy...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('additives to minimize sensitivity • 6% Potassium nitrate Buy 3 for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.95, 'GBP', NOW());
    END IF;

    -- 3% Kit • High viscosity, spearmint flavoured gel • 0.11% flu...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('3% Kit • High viscosity, spearmint flavoured gel • 0.11% fluoride ions Buy 10 for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 14.95, 'GBP', NOW());
    END IF;

    -- POLAD3...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLAD3', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.5, 'GBP', NOW());
    END IF;

    -- POLAD6 Standard kit...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLAD6 Standard kit', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.5, 'GBP', NOW());
    END IF;

    -- SOOTH1...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SOOTH1', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 31.5, 'GBP', NOW());
    END IF;

    -- POLAN10...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLAN10', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.5, 'GBP', NOW());
    END IF;

    -- and accessories. POLAN16...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('and accessories. POLAN16', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 39.5, 'GBP', NOW());
    END IF;

    -- Hydrogen Peroxide 3%. Buy 3 for each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Hydrogen Peroxide 3%. Buy 3 for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 37.5, 'GBP', NOW());
    END IF;

    -- POLADM3 Poladay 3%...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLADM3 Poladay 3%', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.75, 'GBP', NOW());
    END IF;

    -- POLADM6...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLADM6', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.75, 'GBP', NOW());
    END IF;

    -- POLANM10...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLANM10', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.75, 'GBP', NOW());
    END IF;

    -- POLAGIN...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLAGIN', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 23.25, 'GBP', NOW());
    END IF;

    -- and accessories. POLANM16...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('and accessories. POLANM16', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 22.75, 'GBP', NOW());
    END IF;

    -- Hydrogen Peroxide 3%. Buy 3 for each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Hydrogen Peroxide 3%. Buy 3 for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 20.0, 'GBP', NOW());
    END IF;

    -- POLARES...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLARES', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.25, 'GBP', NOW());
    END IF;

    -- POLADB3...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLADB3', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 145.0, 'GBP', NOW());
    END IF;

    -- POLADB6 Bulk kit Polanight 10% POLATR01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLADB6 Bulk kit Polanight 10% POLATR01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 145.0, 'GBP', NOW());
    END IF;

    -- POLADB6 Bulk kit Polanight 10% POLATR01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLADB6 Bulk kit Polanight 10% POLATR01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 13.25, 'GBP', NOW());
    END IF;

    -- POLACASE...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLACASE', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.0, 'GBP', NOW());
    END IF;

    -- POLANB10 Polanight 16%...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLANB10 Polanight 16%', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 145.0, 'GBP', NOW());
    END IF;

    -- POLANB16...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLANB16', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 145.0, 'GBP', NOW());
    END IF;

    -- Buy 3 for each...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 for each', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 136.0, 'GBP', NOW());
    END IF;

    -- POLAOFF61 rrp...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLAOFF61 rrp', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 36.44, 'GBP', NOW());
    END IF;

    -- POLAOFF61 rrp...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLAOFF61 rrp', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 30.5, 'GBP', NOW());
    END IF;

    -- POLAOFF63 rrp...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLAOFF63 rrp', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 99.4, 'GBP', NOW());
    END IF;

    -- POLAOFF63 rrp...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('POLAOFF63 rrp', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 83.5, 'GBP', NOW());
    END IF;

    -- bleaching gel with 10%/16% CRTA02 Child CRTA03 Buy 1 for...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('bleaching gel with 10%/16% CRTA02 Child CRTA03 Buy 1 for', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.45, 'GBP', NOW());
    END IF;

    -- bleaching gel with 10%/16% CRTA02 Child CRTA03 Buy 1 for...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('bleaching gel with 10%/16% CRTA02 Child CRTA03 Buy 1 for', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.99, 'GBP', NOW());
    END IF;

    -- Pack of 10 for (1.99 each)...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Pack of 10 for (1.99 each)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.9, 'GBP', NOW());
    END IF;

    -- VOPB10R 10%...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('VOPB10R 10%', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.95, 'GBP', NOW());
    END IF;

    -- Pack of 50 for (1.79 each)...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Pack of 50 for (1.79 each)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 89.5, 'GBP', NOW());
    END IF;

    -- VOPB16R 16%...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('VOPB16R 16%', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 24.95, 'GBP', NOW());
    END IF;


    -- ===== Vertical: fashion (2 products) =====
    SELECT id INTO v_vertical_id FROM verticals WHERE slug = 'fashion';
    SELECT id INTO v_cat_id FROM categories WHERE vertical_id = v_vertical_id LIMIT 1;

    -- for CA burs 2.35dia max speed DURACOAT. Cellular glass optic...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('for CA burs 2.35dia max speed DURACOAT. Cellular glass optics. Z15L', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 840.29, 'GBP', NOW());
    END IF;

    -- conditions, sound alarm indicates SGM-ER16i 16:1 scratch res...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('conditions, sound alarm indicates SGM-ER16i 16:1 scratch resistant Duracoat, cellular', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 346.36, 'GBP', NOW());
    END IF;


    -- ===== Vertical: home-garden (14 products) =====
    SELECT id INTO v_vertical_id FROM verticals WHERE slug = 'home-garden';
    SELECT id INTO v_cat_id FROM categories WHERE vertical_id = v_vertical_id LIMIT 1;

    -- HC7021S Sirona fitting • Adjustable illumination intensity...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HC7021S Sirona fitting • Adjustable illumination intensity', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 449.0, 'GBP', NOW());
    END IF;

    -- standard and torque heads. Suitable for KaVo®, and Sirona® P...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('standard and torque heads. Suitable for KaVo®, and Sirona® PTL-CL-LED Torque', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 145.62, 'GBP', NOW());
    END IF;

    -- TEP-E10RM (+D) Cordless and portable with SURGPRO1 RRP POA...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TEP-E10RM (+D) Cordless and portable with SURGPRO1 RRP POA', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 298.38, 'GBP', NOW());
    END IF;

    -- TEP-E10RM (+D) Cordless and portable with SURGPRO1 RRP POA...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TEP-E10RM (+D) Cordless and portable with SURGPRO1 RRP POA', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3493.0, 'GBP', NOW());
    END IF;

    -- location of apex, adjustable sound SGM-ER32i 32:1 glass opti...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('location of apex, adjustable sound SGM-ER32i 32:1 glass optics, for HP burs 2.35ø and CA', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 375.39, 'GBP', NOW());
    END IF;

    -- ALP002 Alpron 1L refill Table Top Controller Set of 4 wires...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('ALP002 Alpron 1L refill Table Top Controller Set of 4 wires', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 37.5, 'GBP', NOW());
    END IF;

    -- Classic Flat Bed chair Soft Knee Break chair...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Classic Flat Bed chair Soft Knee Break chair', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3950.0, 'GBP', NOW());
    END IF;

    -- Classic Flat Bed chair Soft Knee Break chair...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Classic Flat Bed chair Soft Knee Break chair', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 3825.0, 'GBP', NOW());
    END IF;

    -- SELF01 New compact, lightweight and portable...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('SELF01 New compact, lightweight and portable', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- punch, holder and 5 clamps. A dark blue A silicone putty. 30...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('punch, holder and 5 clamps. A dark blue A silicone putty. 300ml IMPTIP04 Blue', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 13.75, 'GBP', NOW());
    END IF;

    -- 5 Box Rate tissue rectangular bibs for use with bib adjustab...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 Box Rate tissue rectangular bibs for use with bib adjustable arms with 3 size settings PVMS01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.1, 'GBP', NOW());
    END IF;

    -- Half Chair Cover ACP05 90 x 230 mm...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Half Chair Cover ACP05 90 x 230 mm', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 7.9, 'GBP', NOW());
    END IF;

    -- 5 Rate Suitable for etch gel and flowable...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('5 Rate Suitable for etch gel and flowable', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 1.5, 'GBP', NOW());
    END IF;

    -- with, is soft and comfortable for the 2 Rate make a fun and ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('with, is soft and comfortable for the 2 Rate make a fun and educational memento', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 18.5, 'GBP', NOW());
    END IF;


    -- ===== Vertical: medical (20 products) =====
    SELECT id INTO v_vertical_id FROM verticals WHERE slug = 'medical';
    SELECT id INTO v_cat_id FROM categories WHERE vertical_id = v_vertical_id LIMIT 1;

    -- TEQ-ER10M (TD) Surgic Pro Surgical...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('TEQ-ER10M (TD) Surgic Pro Surgical', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 298.4, 'GBP', NOW());
    END IF;

    -- Full Surgery Kit Contains: BDS155...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Full Surgery Kit Contains: BDS155', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- • Non and Self Aspirating Cartridge Syringes BDS156...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('• Non and Self Aspirating Cartridge Syringes BDS156', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- Hospital Pattern Right BDS41 BDS322 BDS340...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Hospital Pattern Right BDS41 BDS322 BDS340', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.9, 'GBP', NOW());
    END IF;

    -- Hospital Pattern Right BDS41 BDS322 BDS340...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Hospital Pattern Right BDS41 BDS322 BDS340', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- Hospital Pattern Right BDS41 BDS322 BDS340...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Hospital Pattern Right BDS41 BDS322 BDS340', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 12.95, 'GBP', NOW());
    END IF;

    -- 20 Rate each Disposable syringe for impression Medium Upper ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Rate each Disposable syringe for impression Medium Upper IMPR03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 4.54, 'GBP', NOW());
    END IF;

    -- 20 Rate each Disposable syringe for impression Medium Upper ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('20 Rate each Disposable syringe for impression Medium Upper IMPR03', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 5.35, 'GBP', NOW());
    END IF;

    -- 36pcs/pack dispensing into 10 applicator syringes...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('36pcs/pack dispensing into 10 applicator syringes', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 15.35, 'GBP', NOW());
    END IF;

    -- BULTC5 5 Spill x 500 10 x 2 ml syringes with 50 tips...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BULTC5 5 Spill x 500 10 x 2 ml syringes with 50 tips', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 546.81, 'GBP', NOW());
    END IF;

    -- BLSPIL3 Lojic+3 Spill x 500 BPSPIL3 3 Spill x 500 For Etch G...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BLSPIL3 Lojic+3 Spill x 500 BPSPIL3 3 Spill x 500 For Etch Gel Syringes. 50 Pack.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 532.91, 'GBP', NOW());
    END IF;

    -- BLSPIL3 Lojic+3 Spill x 500 BPSPIL3 3 Spill x 500 For Etch G...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('BLSPIL3 Lojic+3 Spill x 500 BPSPIL3 3 Spill x 500 For Etch Gel Syringes. 50 Pack.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 532.91, 'GBP', NOW());
    END IF;

    -- HRDBC01 pack 250 water syringe covers 64mm x 255mm ACPR01...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('HRDBC01 pack 250 water syringe covers 64mm x 255mm ACPR01', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 6.5, 'GBP', NOW());
    END IF;

    -- touched during clinical procedures. Tape for light handles, ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('touched during clinical procedures. Tape for light handles, control panels Size 3 (27x54) Box 100', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 16.5, 'GBP', NOW());
    END IF;

    -- Surgical Tip ASPI01 2L...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Surgical Tip ASPI01 2L', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 19.95, 'GBP', NOW());
    END IF;

    -- Pack of 3 Surgical Tip. Pack of 3 MAT01 Bags of 100 Sterile ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Pack of 3 Surgical Tip. Pack of 3 MAT01 Bags of 100 Sterile black braided silk, box of 12 (577)', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 2.55, 'GBP', NOW());
    END IF;

    -- Buy 3 for each Contains: 10 x 1.3g Pola Night syringes...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 for each Contains: 10 x 1.3g Pola Night syringes', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 37.5, 'GBP', NOW());
    END IF;

    -- Buy 3 for each Contains: 4 x 1.3g Pola Night syringes...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 for each Contains: 4 x 1.3g Pola Night syringes', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 20.0, 'GBP', NOW());
    END IF;

    -- Buy 3 for each Contains: 50 x 1.3g Pola Night syringes 2 hrs...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Buy 3 for each Contains: 50 x 1.3g Pola Night syringes 2 hrs to overnight', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 136.0, 'GBP', NOW());
    END IF;

    -- Refill syringes 3 x 2.4ml CRTA01 Adult 10 contain 8 medium, ...
    INSERT INTO products (name, vertical_id, category_id)
    VALUES ('Refill syringes 3 x 2.4ml CRTA01 Adult 10 contain 8 medium, 1 green, 1 red.', v_vertical_id, v_cat_id)
    ON CONFLICT DO NOTHING RETURNING id INTO v_pid;
    IF v_pid IS NOT NULL THEN
        INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
        VALUES (v_pid, v_supp_id, 8.45, 'GBP', NOW());
    END IF;

END $$;