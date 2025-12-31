-- Optimize Gogobe Database for High Scale
-- Adding composite indexes to support filtering and sorting on the 'prices' table

-- 1. Default Sort Index: Scraped Time + Price
-- Used when: Viewing "Latest Prices" (API default)
CREATE INDEX IF NOT EXISTS idx_prices_default_sort ON prices (scraped_at DESC, price ASC);

-- 2. Store Page Index: Store + Time
-- Used when: Filtering by a specific store (e.g. Shufersal 001)
CREATE INDEX IF NOT EXISTS idx_prices_store_sort ON prices (store_id, scraped_at DESC);

-- 3. Product History Index: Product + Time
-- Used when: Viewing price history for a specific product
CREATE INDEX IF NOT EXISTS idx_prices_product_sort ON prices (product_id, scraped_at DESC);

-- 4. Chain Filtering Support
-- Index foreign keys that might be missing explicit indexes for joins
CREATE INDEX IF NOT EXISTS idx_stores_chain_id ON stores (chain_id);

-- 5. Maintenance
-- Update statistics to help the query planner use the new indexes
ANALYZE prices;
ANALYZE stores;
ANALYZE products;
