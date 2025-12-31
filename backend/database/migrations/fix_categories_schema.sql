-- Fix Categories Schema for Auto-Categorizer & I18N

-- 1. Add name_en column if it doesn't exist
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='categories' AND column_name='name_en') THEN 
        ALTER TABLE categories ADD COLUMN name_en VARCHAR(255); 
    END IF; 
END $$;

-- 2. Clean up duplicates on full_path before adding unique constraint
-- Keep the one with the MIN(id)
DELETE FROM categories a USING (
    SELECT MIN(id) as id, full_path 
    FROM categories 
    GROUP BY full_path HAVING COUNT(*) > 1
) b 
WHERE a.full_path = b.full_path 
AND a.id <> b.id;

-- 3. Add UNIQUE constraint on full_path if not exists
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'categories_full_path_key'
    ) THEN
        ALTER TABLE categories ADD CONSTRAINT categories_full_path_key UNIQUE (full_path);
    END IF;
END $$;
