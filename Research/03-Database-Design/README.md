# 03 - Database Design

**Focus:** Complete database schemas, models, and design patterns for the global price tracking system.

---

## 📚 Contents

1. [PostgreSQL Schema](./01-postgresql-schema.md) - Main database tables
2. [TimescaleDB Schema](./02-timescaledb-schema.md) - Time-series price data
3. [Elasticsearch Indexes](./03-elasticsearch-indexes.md) - Search configuration
4. [Redis Patterns](./04-redis-patterns.md) - Caching strategies
5. [Data Models](./05-data-models.md) - Application layer models
6. [Migration Strategy](./06-migration-strategy.md) - Schema evolution
7. [Optimization Guide](./07-optimization-guide.md) - Performance tuning

---

## 🎯 Design Principles

### 1. Normalization vs Denormalization
```yaml
PostgreSQL (Main DB):
  - 3NF (Third Normal Form)
  - Minimize redundancy
  - Use foreign keys
  - Data integrity first

TimescaleDB (Time-Series):
  - Denormalized for performance
  - Embedded common fields
  - Pre-computed aggregates
  - Query speed over storage

Elasticsearch:
  - Fully denormalized
  - Self-contained documents
  - No joins needed
  - Search optimized
```

### 2. Data Partitioning
```yaml
Horizontal (Sharding):
  - By geography (US, EU, Asia)
  - By category (future)
  - By time period (archives)

Vertical:
  - Hot data (recent prices) separate from cold
  - Frequently accessed fields in cache
```

### 3. Indexing Strategy
```yaml
Primary Indexes:
  - B-tree for equality and range
  - GiST for full-text and geospatial
  - Hash for exact matches only
  - GIN for JSON and arrays

Secondary Indexes:
  - Covering indexes for common queries
  - Partial indexes for filtered data
  - Expression indexes for computed values
```

---

## 🗃️ Database Overview

### PostgreSQL - Main Database

**Tables: 15+**

```
Core Entities:
├── products          (10M rows)
├── suppliers         (50K rows)
├── categories        (5K rows)
├── brands            (100K rows)
└── countries         (200 rows)

Relationships:
├── product_suppliers
├── product_categories
├── product_attributes
└── product_images

User Management:
├── users            (1M rows)
├── user_alerts
├── user_favorites
└── user_sessions

System:
├── api_keys
├── audit_logs
└── migrations
```

[→ Full PostgreSQL Schema](./01-postgresql-schema.md)

---

### TimescaleDB - Price History

**Tables: 2 main + materialized views**

```
Time-Series Data:
├── price_history    (100M+ rows, partitioned by time)
└── price_snapshots  (daily aggregates)

Continuous Aggregates:
├── hourly_prices
├── daily_prices
├── weekly_prices
└── monthly_prices
```

**Special Features:**
- Automatic compression (7 days old)
- Retention policies (10 years)
- Continuous aggregates (real-time)
- Hypertable partitioning

[→ Full TimescaleDB Schema](./02-timescaledb-schema.md)

---

### Elasticsearch - Search Index

**Indexes: 3 main**

```
Search Indexes:
├── products_v1      (10M documents)
├── suppliers_v1     (50K documents)
└── categories_v1    (5K documents)

Aliases:
├── products → products_v1
├── suppliers → suppliers_v1
└── categories → categories_v1
```

**Features:**
- Multi-language analyzers
- Synonym dictionaries
- Fuzzy matching
- Faceted search
- Autocomplete

[→ Full Elasticsearch Config](./03-elasticsearch-indexes.md)

---

### Redis - Cache & Sessions

**Data Structures:**

```
Cache:
├── product:{id}              (String) - Product details
├── prices:{product_id}       (Sorted Set) - Recent prices
├── hot:products              (Sorted Set) - Top 10K products
└── search:{query}            (String) - Cached search results

Sessions:
├── session:{session_id}      (Hash) - User session data
├── user:{user_id}:alerts     (List) - User alerts queue
└── rate_limit:{ip}           (String) - Rate limiting counter

Real-time:
├── price:updates             (Pub/Sub) - Price change events
└── notifications             (Pub/Sub) - User notifications
```

[→ Full Redis Patterns](./04-redis-patterns.md)

---

## 📊 Entity Relationship Diagram

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│  categories  │────────▶│   products   │◀────────│    brands    │
└──────────────┘  parent └──────────────┘  brand  └──────────────┘
                            │      │
                            │      │
           ┌────────────────┘      └────────────────┐
           │                                         │
           ▼                                         ▼
┌──────────────────┐                      ┌──────────────────┐
│  price_history   │                      │  product_images  │
│  (TimescaleDB)   │                      └──────────────────┘
└──────────────────┘                               
           │
           │ product_id + supplier_id
           │
           ▼
┌──────────────────┐
│    suppliers     │
└──────────────────┘
```

---

## 🔑 Key Design Decisions

### 1. Why Separate Time-Series Database?

```yaml
Problem:
  - 100M+ price records growing daily
  - PostgreSQL slow for time-range queries at scale
  - Storage costs high without compression

Solution:
  - TimescaleDB for price_history
  - 10x faster queries
  - 95% storage savings (compression)
  - SQL-compatible (easy migration)

Trade-off:
  - One more database to manage
  - Worth it for performance gains
```

### 2. Why Denormalize in Elasticsearch?

```yaml
Problem:
  - Joins slow down search
  - Need sub-second search responses
  - Complex relevance scoring

Solution:
  - Embed product + supplier + category data
  - Self-contained documents
  - No joins needed

Trade-off:
  - Data duplication
  - Sync required on updates
  - Worth it for search speed
```

### 3. UUID vs Auto-Increment IDs?

```yaml
Decision: Use BIGINT auto-increment (SERIAL)

Reasons:
  ✅ Smaller index size (8 bytes vs 16 bytes)
  ✅ Better query performance
  ✅ Easier to debug
  ✅ Sequential = better cache locality
  
When to use UUID:
  ❌ Distributed systems (we're centralized)
  ❌ Security (IDs not exposed in URLs anyway)
```

### 4. JSON vs Columns for Product Attributes?

```yaml
Decision: JSONB for flexible attributes

Example:
  Electronics: {screen_size, resolution, ram}
  Clothing: {size, color, material}
  Books: {author, isbn, pages}

Reasons:
  ✅ Schema flexibility
  ✅ No ALTER TABLE needed
  ✅ PostgreSQL JSONB is fast (indexable)
  ✅ Different products have different attributes

Trade-off:
  ❌ Less type safety
  ✅ Use JSON Schema validation in app
```

---

## 📈 Capacity Planning

### Storage Estimates

```yaml
PostgreSQL:
  products: 10M × 2KB = 20GB
  suppliers: 50K × 1KB = 50MB
  users: 1M × 500B = 500MB
  indexes: ~15GB
  TOTAL: ~40GB (Year 1)

TimescaleDB:
  price_history: 100M × 200B = 20GB (raw)
  After compression: 1GB (95% saving!)
  indexes: 500MB
  TOTAL: ~2GB (Year 1)

Elasticsearch:
  products: 10M × 5KB = 50GB
  replicas (2x): 100GB
  TOTAL: ~100GB

Redis:
  Hot cache: 5GB
  Sessions: 1GB
  TOTAL: ~6GB

Grand Total: ~150GB (Year 1)
```

### Growth Projections

```yaml
Year 2: 300GB (2x data)
Year 3: 600GB (2x data)
Year 5: 2TB (3x data)

Note: Compression keeps it manageable
```

---

## 🔒 Data Security

### Encryption

```yaml
At Rest:
  - PostgreSQL: Transparent Data Encryption (TDE)
  - TimescaleDB: Same as PostgreSQL
  - Elasticsearch: X-Pack encryption
  - Redis: RDB/AOF encryption
  - Backups: AWS S3 encryption (AES-256)

In Transit:
  - TLS 1.3 for all connections
  - Certificate pinning for mobile apps
```

### Access Control

```yaml
PostgreSQL:
  - Row-level security (RLS) for multi-tenancy
  - Separate read-only user for replicas
  - Audit logging enabled

Application:
  - API key authentication
  - JWT tokens for user sessions
  - Rate limiting by IP and user
```

---

## 🔄 Data Lifecycle

### Retention Policies

```yaml
Price History:
  - Keep forever (compressed after 7 days)
  - Aggregates pre-computed for speed

User Data:
  - Active users: Keep forever
  - Inactive (2 years): Soft delete
  - Deleted accounts: Hard delete after 30 days

Logs:
  - Application logs: 90 days
  - Audit logs: 7 years (compliance)
  - Access logs: 30 days
```

### Backup Strategy

```yaml
Full Backups:
  - Daily at 2 AM UTC
  - Retention: 30 days
  - Stored in S3 (multiple regions)

Incremental Backups:
  - Every 6 hours
  - Retention: 7 days

Point-in-Time Recovery:
  - WAL archiving enabled
  - 7-day recovery window
```

---

## 🎓 Best Practices

### DO ✅

```sql
-- Use explicit column names
SELECT id, name, price FROM products;

-- Use prepared statements (prevent SQL injection)
$stmt = $pdo->prepare("SELECT * FROM products WHERE id = ?");

-- Add indexes for foreign keys
CREATE INDEX idx_product_supplier ON products(supplier_id);

-- Use transactions for multi-step operations
BEGIN;
  INSERT INTO products ...;
  INSERT INTO price_history ...;
COMMIT;

-- Partition large tables
CREATE TABLE price_history (
  ...
) PARTITION BY RANGE (time);
```

### DON'T ❌

```sql
-- Don't use SELECT *
SELECT * FROM products; -- ❌ Slow, retrieves unused columns

-- Don't forget indexes
SELECT * FROM products WHERE supplier_id = 123; -- ❌ Slow without index

-- Don't use LIKE with leading wildcard
SELECT * FROM products WHERE name LIKE '%phone%'; -- ❌ Can't use index

-- Don't store large BLOBs in database
INSERT INTO products (image) VALUES (...5MB image...); -- ❌ Use S3

-- Don't cascade delete without thinking
ON DELETE CASCADE -- ❌ Can accidentally delete lots of data
```

---

## 📚 Additional Resources

### Schema Documentation
- [PostgreSQL Full Schema](./01-postgresql-schema.md)
- [TimescaleDB Schema](./02-timescaledb-schema.md)
- [Elasticsearch Mappings](./03-elasticsearch-indexes.md)
- [Redis Data Structures](./04-redis-patterns.md)

### Guides
- [Migration Strategy](./06-migration-strategy.md)
- [Performance Optimization](./07-optimization-guide.md)
- [Backup & Recovery](./08-backup-recovery.md)

---

**Last Updated:** December 18, 2025  
**Next Review:** January 2026  
**Status:** ✅ Ready for Implementation






