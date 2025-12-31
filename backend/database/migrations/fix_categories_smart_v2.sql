-- Smart Category Cleanup V2 (Recursive Merge for Constraint Conflicts)

DO $$ 
DECLARE
    r RECORD;
    target_id INT;
    duplicate_ids INT[];
    dup_id INT;
    child_r RECORD;
    existing_child_id INT;
BEGIN 
    -- 1. Create name_en if missing (re-run safety)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='categories' AND column_name='name_en') THEN 
        ALTER TABLE categories ADD COLUMN name_en VARCHAR(255); 
    END IF; 

    -- 2. Loop over duplicated paths
    FOR r IN 
        SELECT full_path 
        FROM categories 
        GROUP BY full_path 
        HAVING COUNT(*) > 1
    LOOP 
        RAISE NOTICE 'Processing duplicates for: %', r.full_path;
        
        -- Target ID: Smallest ID
        SELECT MIN(id) INTO target_id FROM categories WHERE full_path = r.full_path;
        
        -- Duplicate IDs: All others
        SELECT ARRAY_AGG(id) INTO duplicate_ids 
        FROM categories 
        WHERE full_path = r.full_path AND id <> target_id;
        
        IF duplicate_ids IS NOT NULL THEN
            FOREACH dup_id IN ARRAY duplicate_ids
            LOOP
                -- A. Move products to target
                UPDATE products SET category_id = target_id WHERE category_id = dup_id;
                
                -- B. Handle Children categories
                FOR child_r IN SELECT id, slug FROM categories WHERE parent_id = dup_id
                LOOP
                    -- Check if target already has a child with this slug
                    SELECT id INTO existing_child_id 
                    FROM categories 
                    WHERE parent_id = target_id AND slug = child_r.slug;
                    
                    IF existing_child_id IS NOT NULL THEN
                        -- CONFLICT! Merge child products to existing sibling, then delete child
                        RAISE NOTICE 'Merging conflict child % -> %', child_r.id, existing_child_id;
                        UPDATE products SET category_id = existing_child_id WHERE category_id = child_r.id;
                        -- Recursively handle grandchildren if needed (simple case: assume 2 levels max or safe delete)
                        -- For safety, update grandchildren parent_id to new parent
                        UPDATE categories SET parent_id = existing_child_id WHERE parent_id = child_r.id; 
                        
                        DELETE FROM categories WHERE id = child_r.id;
                    ELSE
                        -- NO CONFLICT: Just move the child to new parent
                        UPDATE categories SET parent_id = target_id WHERE id = child_r.id;
                    END IF;
                END LOOP;
                
                -- C. Delete the duplicate category
                DELETE FROM categories WHERE id = dup_id;
                
                RAISE NOTICE 'Merged duplicate category ID % into ID %', dup_id, target_id;
            END LOOP;
        END IF;
    END LOOP;

    -- 3. Add UNIQUE constraint on full_path
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'categories_full_path_key'
    ) THEN
        ALTER TABLE categories ADD CONSTRAINT categories_full_path_key UNIQUE (full_path);
        RAISE NOTICE 'Added UNIQUE constraint on full_path';
    END IF;

END $$;
