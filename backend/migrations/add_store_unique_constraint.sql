-- Add unique constraint to prevent duplicate stores per chain
-- This ensures that each chain can only have one store with a specific store_code

-- First, check if constraint already exists
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'stores_chain_store_unique'
    ) THEN
        ALTER TABLE stores 
        ADD CONSTRAINT stores_chain_store_unique 
        UNIQUE (chain_id, store_code);
        
        RAISE NOTICE 'Added unique constraint: stores_chain_store_unique';
    ELSE
        RAISE NOTICE 'Constraint already exists: stores_chain_store_unique';
    END IF;
END $$;

-- Also add index for better performance
CREATE INDEX IF NOT EXISTS idx_stores_chain_code 
ON stores(chain_id, store_code);

-- Show current stores count per chain
SELECT 
    c.name,
    COUNT(s.id) as store_count
FROM chains c
LEFT JOIN stores s ON s.chain_id = c.id
GROUP BY c.id, c.name
ORDER BY store_count DESC;
