-- Smart Category Cleanup (Merge & Deduplicate)

DO $$ 
DECLARE
    r RECORD;
    target_id INT;
    duplicate_ids INT[];
    dup_id INT;
BEGIN 
    -- 1. Add name_en column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='categories' AND column_name='name_en') THEN 
        ALTER TABLE categories ADD COLUMN name_en VARCHAR(255); 
        RAISE NOTICE 'Added name_en column';
    END IF; 

    -- 2. Find duplicate groups (same full_path, count > 1)
    FOR r IN 
        SELECT full_path 
        FROM categories 
        GROUP BY full_path 
        HAVING COUNT(*) > 1
    LOOP 
        RAISE NOTICE 'Processing duplicates for: %', r.full_path;
        
        -- Get the ID we want to KEEP (e.g., the smallest ID)
        SELECT MIN(id) INTO target_id FROM categories WHERE full_path = r.full_path;
        
        -- Get the IDs we want to REMOVE
        SELECT ARRAY_AGG(id) INTO duplicate_ids 
        FROM categories 
        WHERE full_path = r.full_path AND id <> target_id;
        
        -- Iterate over duplicates to migrate products and delete
        IF duplicate_ids IS NOT NULL THEN
            FOREACH dup_id IN ARRAY duplicate_ids
            LOOP
                -- A. Move products from duplicate category to target category
                UPDATE products 
                SET category_id = target_id 
                WHERE category_id = dup_id;
                
                -- B. Move child categories (if any) to target parent
                UPDATE categories 
                SET parent_id = target_id 
                WHERE parent_id = dup_id;
                
                -- C. Delete the duplicate category
                DELETE FROM categories WHERE id = dup_id;
                
                RAISE NOTICE 'Merged duplicate category ID % into ID %', dup_id, target_id;
            END LOOP;
        END IF;
    END LOOP;

    -- 3. Add UNIQUE constraint on full_path (Now it should be safe)
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'categories_full_path_key'
    ) THEN
        ALTER TABLE categories ADD CONSTRAINT categories_full_path_key UNIQUE (full_path);
        RAISE NOTICE 'Added UNIQUE constraint on full_path';
    END IF;

END $$;
