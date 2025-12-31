# PostgreSQL Schema - Main Database

**Purpose:** Store products, suppliers, users, and all relational data.

---

## 📋 Complete Schema

### Core Tables

#### 1. Products

```sql
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    normalized_name VARCHAR(500), -- Lowercase, no special chars for matching
    description TEXT,
    brand_id INTEGER REFERENCES brands(id),
    category_id INTEGER REFERENCES categories(id),
    
    -- Flexible attributes (different per category)
    attributes JSONB DEFAULT '{}',
    
    -- Common fields
    model VARCHAR(200),
    sku VARCHAR(100),
    ean VARCHAR(13),
    upc VARCHAR(12),
    asin VARCHAR(10), -- Amazon ID
    
    -- Images
    main_image_url VARCHAR(500),
    image_urls TEXT[], -- Array of image URLs
    
    -- Metadata
    is_active BOOLEAN DEFAULT TRUE,
    view_count INTEGER DEFAULT 0,
    favorite_count INTEGER DEFAULT 0,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    last_scraped_at TIMESTAMPTZ,
    
    -- Search optimization
    search_vector TSVECTOR GENERATED ALWAYS AS (
        to_tsvector('english', COALESCE(name, '') || ' ' || COALESCE(description, ''))
    ) STORED
);

-- Indexes
CREATE INDEX idx_products_brand ON products(brand_id) WHERE is_active = TRUE;
CREATE INDEX idx_products_category ON products(category_id) WHERE is_active = TRUE;
CREATE INDEX idx_products_normalized_name ON products(normalized_name);
CREATE INDEX idx_products_search_vector ON products USING gin(search_vector);
CREATE INDEX idx_products_ean ON products(ean) WHERE ean IS NOT NULL;
CREATE INDEX idx_products_asin ON products(asin) WHERE asin IS NOT NULL;
CREATE INDEX idx_products_attributes ON products USING gin(attributes);
CREATE INDEX idx_products_view_count ON products(view_count DESC) WHERE is_active = TRUE;

-- Update timestamp trigger
CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
```

#### 2. Brands

```sql
CREATE TABLE brands (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL UNIQUE,
    normalized_name VARCHAR(200) UNIQUE,
    logo_url VARCHAR(500),
    website VARCHAR(500),
    description TEXT,
    country_code CHAR(2) REFERENCES countries(code),
    
    -- Stats
    product_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_brands_normalized_name ON brands(normalized_name);
CREATE INDEX idx_brands_country ON brands(country_code);
```

#### 3. Categories

```sql
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    parent_id INTEGER REFERENCES categories(id),
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) NOT NULL UNIQUE,
    
    -- Hierarchical path (using ltree extension)
    path LTREE,
    level INTEGER,
    
    -- Display
    icon VARCHAR(100),
    description TEXT,
    
    -- Stats
    product_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable ltree extension
CREATE EXTENSION IF NOT EXISTS ltree;

CREATE INDEX idx_categories_path ON categories USING gist(path);
CREATE INDEX idx_categories_parent ON categories(parent_id);
CREATE INDEX idx_categories_slug ON categories(slug);

-- Example ltree paths:
-- Electronics
-- Electronics.Phones
-- Electronics.Phones.Smartphones
-- Electronics.Phones.Smartphones.Apple
```

#### 4. Suppliers

```sql
CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) UNIQUE,
    website VARCHAR(500),
    country_code CHAR(2) REFERENCES countries(code),
    
    -- Contact
    email VARCHAR(255),
    phone VARCHAR(50),
    
    -- Location (PostGIS)
    location GEOGRAPHY(POINT),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    
    -- Chain/Parent (for multi-location retailers)
    parent_id INTEGER REFERENCES suppliers(id),
    
    -- Ratings
    reliability_score DECIMAL(3,2) CHECK (reliability_score BETWEEN 0 AND 5),
    review_count INTEGER DEFAULT 0,
    
    -- Shipping
    ships_internationally BOOLEAN DEFAULT FALSE,
    ships_to_countries TEXT[], -- Array of country codes
    
    -- Metadata
    logo_url VARCHAR(500),
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Stats
    product_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable PostGIS extension
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE INDEX idx_suppliers_country ON suppliers(country_code);
CREATE INDEX idx_suppliers_parent ON suppliers(parent_id);
CREATE INDEX idx_suppliers_location ON suppliers USING gist(location);
CREATE INDEX idx_suppliers_slug ON suppliers(slug);
CREATE INDEX idx_suppliers_reliability ON suppliers(reliability_score DESC) WHERE is_active = TRUE;
```

#### 5. Countries

```sql
CREATE TABLE countries (
    code CHAR(2) PRIMARY KEY, -- ISO 3166-1 alpha-2
    name VARCHAR(100) NOT NULL,
    currency_code CHAR(3), -- ISO 4217
    language_code CHAR(2), -- ISO 639-1
    flag_url VARCHAR(500),
    
    -- Stats
    supplier_count INTEGER DEFAULT 0,
    product_count INTEGER DEFAULT 0,
    
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Sample data
INSERT INTO countries (code, name, currency_code, language_code) VALUES
    ('US', 'United States', 'USD', 'en'),
    ('IL', 'Israel', 'ILS', 'he'),
    ('GB', 'United Kingdom', 'GBP', 'en'),
    ('DE', 'Germany', 'EUR', 'de'),
    ('FR', 'France', 'EUR', 'fr'),
    ('CN', 'China', 'CNY', 'zh');
```

---

### Relationship Tables

#### 6. Product-Supplier Mapping

```sql
CREATE TABLE product_suppliers (
    product_id BIGINT REFERENCES products(id) ON DELETE CASCADE,
    supplier_id INTEGER REFERENCES suppliers(id) ON DELETE CASCADE,
    
    -- Product info at this supplier
    supplier_sku VARCHAR(100),
    supplier_url VARCHAR(1000),
    
    -- Availability
    is_available BOOLEAN DEFAULT TRUE,
    stock_level VARCHAR(50), -- 'in_stock', 'low_stock', 'out_of_stock'
    
    -- Shipping
    shipping_cost DECIMAL(10,2),
    shipping_time_days INTEGER,
    free_shipping_threshold DECIMAL(10,2),
    
    -- Stats
    last_price DECIMAL(12,2),
    last_price_date TIMESTAMPTZ,
    price_check_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    PRIMARY KEY (product_id, supplier_id)
);

CREATE INDEX idx_product_suppliers_supplier ON product_suppliers(supplier_id);
CREATE INDEX idx_product_suppliers_availability ON product_suppliers(is_available);
```

#### 7. Product Attributes

```sql
-- For commonly filtered attributes, stored separately for indexing
CREATE TABLE product_attributes (
    id SERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES products(id) ON DELETE CASCADE,
    
    attribute_name VARCHAR(100) NOT NULL,
    attribute_value VARCHAR(500) NOT NULL,
    
    attribute_type VARCHAR(50), -- 'string', 'number', 'boolean', 'range'
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(product_id, attribute_name)
);

CREATE INDEX idx_product_attributes_product ON product_attributes(product_id);
CREATE INDEX idx_product_attributes_name_value ON product_attributes(attribute_name, attribute_value);

-- Example: Electronics
-- (product_id=123, 'screen_size', '6.1 inches')
-- (product_id=123, 'ram', '8GB')
-- (product_id=123, 'color', 'Black')
```

---

### User Management

#### 8. Users

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255),
    
    -- Profile
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    avatar_url VARCHAR(500),
    
    -- Preferences
    preferred_currency CHAR(3) DEFAULT 'USD',
    preferred_language CHAR(2) DEFAULT 'en',
    country_code CHAR(2) REFERENCES countries(code),
    timezone VARCHAR(50) DEFAULT 'UTC',
    
    -- Authentication
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    two_factor_enabled BOOLEAN DEFAULT FALSE,
    
    -- OAuth
    google_id VARCHAR(100),
    facebook_id VARCHAR(100),
    apple_id VARCHAR(100),
    
    -- Subscription
    subscription_tier VARCHAR(50) DEFAULT 'free', -- 'free', 'basic', 'premium'
    subscription_expires_at TIMESTAMPTZ,
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    is_banned BOOLEAN DEFAULT FALSE,
    ban_reason TEXT,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    last_login_at TIMESTAMPTZ,
    
    CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

CREATE INDEX idx_users_email ON users(email) WHERE is_active = TRUE;
CREATE INDEX idx_users_username ON users(username) WHERE is_active = TRUE;
CREATE INDEX idx_users_google_id ON users(google_id) WHERE google_id IS NOT NULL;
CREATE INDEX idx_users_subscription ON users(subscription_tier, subscription_expires_at);
```

#### 9. User Alerts

```sql
CREATE TABLE user_alerts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    product_id BIGINT REFERENCES products(id) ON DELETE CASCADE,
    
    -- Alert conditions
    alert_type VARCHAR(50) NOT NULL, -- 'price_drop', 'back_in_stock', 'price_below'
    target_price DECIMAL(12,2), -- For 'price_below' type
    price_drop_percentage INTEGER, -- For 'price_drop' type (e.g., 10 = 10%)
    
    -- Notification preferences
    notify_email BOOLEAN DEFAULT TRUE,
    notify_push BOOLEAN DEFAULT TRUE,
    notify_sms BOOLEAN DEFAULT FALSE,
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    triggered_count INTEGER DEFAULT 0,
    last_triggered_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_user_alerts_user ON user_alerts(user_id) WHERE is_active = TRUE;
CREATE INDEX idx_user_alerts_product ON user_alerts(product_id) WHERE is_active = TRUE;
CREATE INDEX idx_user_alerts_type ON user_alerts(alert_type) WHERE is_active = TRUE;
```

#### 10. User Favorites

```sql
CREATE TABLE user_favorites (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    product_id BIGINT REFERENCES products(id) ON DELETE CASCADE,
    
    notes TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    PRIMARY KEY (user_id, product_id)
);

CREATE INDEX idx_user_favorites_user ON user_favorites(user_id);
CREATE INDEX idx_user_favorites_product ON user_favorites(product_id);
```

---

### System Tables

#### 11. API Keys

```sql
CREATE TABLE api_keys (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    
    key_hash VARCHAR(255) UNIQUE NOT NULL,
    key_prefix VARCHAR(20) NOT NULL, -- First 8 chars for display
    name VARCHAR(100),
    
    -- Permissions
    scopes TEXT[], -- ['read:products', 'read:prices', 'write:alerts']
    rate_limit_per_hour INTEGER DEFAULT 1000,
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    expires_at TIMESTAMPTZ,
    
    -- Usage stats
    request_count BIGINT DEFAULT 0,
    last_used_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_api_keys_key_hash ON api_keys(key_hash) WHERE is_active = TRUE;
CREATE INDEX idx_api_keys_user ON api_keys(user_id);
```

#### 12. Audit Logs

```sql
CREATE TABLE audit_logs (
    id BIGSERIAL PRIMARY KEY,
    
    -- Who
    user_id INTEGER REFERENCES users(id),
    api_key_id INTEGER REFERENCES api_keys(id),
    ip_address INET,
    user_agent TEXT,
    
    -- What
    action VARCHAR(100) NOT NULL, -- 'product.create', 'price.update', 'user.login'
    entity_type VARCHAR(50), -- 'product', 'price', 'user'
    entity_id BIGINT,
    
    -- Changes
    old_values JSONB,
    new_values JSONB,
    
    -- When
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Partition by month for performance
CREATE TABLE audit_logs_2025_12 PARTITION OF audit_logs
    FOR VALUES FROM ('2025-12-01') TO ('2026-01-01');

CREATE INDEX idx_audit_logs_user ON audit_logs(user_id, created_at DESC);
CREATE INDEX idx_audit_logs_action ON audit_logs(action, created_at DESC);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id, created_at DESC);
```

---

## 🔧 Helper Functions

### Update Timestamp Function

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### Normalize String Function

```sql
CREATE OR REPLACE FUNCTION normalize_string(text)
RETURNS text AS $$
    SELECT LOWER(REGEXP_REPLACE($1, '[^a-zA-Z0-9\s]', '', 'g'));
$$ LANGUAGE SQL IMMUTABLE;
```

### Update Counters Function

```sql
CREATE OR REPLACE FUNCTION update_category_product_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE categories 
        SET product_count = product_count + 1 
        WHERE id = NEW.category_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE categories 
        SET product_count = product_count - 1 
        WHERE id = OLD.category_id;
    ELSIF TG_OP = 'UPDATE' AND NEW.category_id != OLD.category_id THEN
        UPDATE categories 
        SET product_count = product_count - 1 
        WHERE id = OLD.category_id;
        UPDATE categories 
        SET product_count = product_count + 1 
        WHERE id = NEW.category_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER category_product_count_trigger
    AFTER INSERT OR UPDATE OR DELETE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_category_product_count();
```

---

## 📊 Example Queries

### Find Products by Brand and Category

```sql
SELECT 
    p.id,
    p.name,
    p.model,
    b.name as brand_name,
    c.name as category_name,
    p.view_count
FROM products p
JOIN brands b ON p.brand_id = b.id
JOIN categories c ON p.category_id = c.id
WHERE 
    b.normalized_name = 'apple'
    AND c.path <@ 'Electronics.Phones'::ltree
    AND p.is_active = TRUE
ORDER BY p.view_count DESC
LIMIT 20;
```

### Get Current Best Price for Product

```sql
SELECT 
    p.name,
    s.name as supplier,
    ph.price,
    ph.currency,
    ps.shipping_cost,
    ph.time as last_updated
FROM products p
JOIN product_suppliers ps ON p.id = ps.product_id
JOIN suppliers s ON ps.supplier_id = s.id
JOIN LATERAL (
    SELECT price, currency, time
    FROM price_history
    WHERE product_id = p.id 
      AND supplier_id = s.id
    ORDER BY time DESC
    LIMIT 1
) ph ON TRUE
WHERE p.id = 12345
  AND ps.is_available = TRUE
ORDER BY ph.price ASC;
```

### Full-Text Search

```sql
SELECT 
    id,
    name,
    description,
    ts_rank(search_vector, query) as rank
FROM products,
     to_tsquery('english', 'iphone & pro') as query
WHERE search_vector @@ query
  AND is_active = TRUE
ORDER BY rank DESC
LIMIT 20;
```

---

## 🎯 Performance Tips

### 1. Use Covering Indexes

```sql
-- Include commonly selected columns in index
CREATE INDEX idx_products_covering ON products(category_id, brand_id)
    INCLUDE (name, model, main_image_url) 
    WHERE is_active = TRUE;
```

### 2. Partial Indexes

```sql
-- Index only active products
CREATE INDEX idx_products_active ON products(name) 
    WHERE is_active = TRUE;
```

### 3. Index Statistics

```sql
-- Update statistics for better query plans
ANALYZE products;
ANALYZE price_history;
```

### 4. Vacuum Regularly

```sql
-- Reclaim space and update statistics
VACUUM ANALYZE products;
```

---

**Next:** [TimescaleDB Schema →](./02-timescaledb-schema.md)









