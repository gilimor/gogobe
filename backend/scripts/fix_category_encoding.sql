-- Fix corrupted category name encoding
-- This script fixes category ID 151 which has gibberish instead of Hebrew

BEGIN;

-- Update category name with proper UTF-8 encoding
UPDATE categories 
SET name = 'אחר' 
WHERE id = 151 AND slug = 'acher';

-- Verify the fix
SELECT id, name, slug 
FROM categories 
WHERE id = 151;

COMMIT;


