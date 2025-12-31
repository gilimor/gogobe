# 🌍 ארכיטקטורה גלובלית - Gogobe Worldwide

## תאריך: 21 דצמבר 2025
## חזון: פלטפורמת השוואת מחירים בינלאומית בסדר גודל של Google

---

## 🎯 החזון

**Gogobe Global** - פלטפורמה עולמית להשוואת מחירים:
- 🌍 **Multi-Region** - שרתים בכל יבשת
- 🗄️ **Multi-Database** - DB נפרד לכל אזור/domain
- 🚀 **Massive Scale** - מיליארדי מוצרים, מיליוני משתמשים
- ⚡ **Low Latency** - <100ms בכל מקום בעולם
- 💰 **Multi-Currency** - תמיכה בכל מטבעות העולם

---

## 🗺️ ארכיטקטורה גיאוגרפית

### אזורים גלובליים (Regions)

```
┌─────────────────────────────────────────────────────────────┐
│                    Global Architecture                       │
└─────────────────────────────────────────────────────────────┘

🌍 EMEA (Europe, Middle East, Africa)
├─ Israel Region (IL)
│  ├─ DB: gogobe_il (PostgreSQL)
│  ├─ Cache: Redis IL
│  ├─ Services: Import, Product, Price
│  └─ Data: רמי לוי, שופרסל, יינות ביתן...
│
├─ Europe Region (EU)
│  ├─ DB: gogobe_eu (PostgreSQL)
│  ├─ Cache: Redis EU
│  ├─ Services: Import, Product, Price
│  └─ Data: Tesco, Carrefour, Lidl...
│
└─ Middle East Region (ME)
   ├─ DB: gogobe_me (PostgreSQL)
   └─ Data: Dubai, Saudi Arabia...

🌎 Americas
├─ US East Region (US-EAST)
│  ├─ DB: gogobe_us_east (PostgreSQL)
│  ├─ Cache: Redis US-EAST
│  ├─ Services: Import, Product, Price
│  └─ Data: Walmart, Target, Whole Foods...
│
├─ US West Region (US-WEST)
│  ├─ DB: gogobe_us_west (PostgreSQL)
│  └─ Data: Safeway, Kroger...
│
└─ Latin America Region (LATAM)
   ├─ DB: gogobe_latam (PostgreSQL)
   └─ Data: Brazil, Mexico, Argentina...

🌏 Asia-Pacific (APAC)
├─ Asia Region (ASIA)
│  ├─ DB: gogobe_asia (PostgreSQL)
│  └─ Data: China, Japan, Korea...
│
└─ Australia Region (AU)
   ├─ DB: gogobe_au (PostgreSQL)
   └─ Data: Woolworths, Coles...
```

---

## 🗄️ אסטרטגיית בסיסי נתונים

### אפשרות 1: **Database per Region** (מומלץ!)

```
┌─────────────────────────────────────────────────────────────┐
│ Israel Region (Tel Aviv)                                    │
├─────────────────────────────────────────────────────────────┤
│ PostgreSQL: gogobe_il                                       │
│ ├─ Schema: public                                           │
│ │  ├─ store_chains (רמי לוי, שופרסל...)                    │
│ │  ├─ stores (סניפים בישראל)                               │
│ │  ├─ products (מוצרים בישראל)                             │
│ │  ├─ prices (מחירים בשקלים)                               │
│ │  └─ master_products (אב מוצרים - גלובלי!)               │
│ │                                                            │
│ ├─ Schema: analytics                                        │
│ │  ├─ price_history                                         │
│ │  └─ user_searches                                         │
│ │                                                            │
│ └─ Schema: cache                                            │
│    └─ materialized_views                                    │
│                                                              │
│ Size: ~500GB (10M products × 100M prices)                   │
│ Location: AWS eu-south-1 (Tel Aviv)                         │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ US East Region (Virginia)                                   │
├─────────────────────────────────────────────────────────────┤
│ PostgreSQL: gogobe_us_east                                  │
│ ├─ Schema: public                                           │
│ │  ├─ store_chains (Walmart, Target...)                    │
│ │  ├─ stores (סניפים בארה"ב)                               │
│ │  ├─ products (מוצרים בארה"ב)                             │
│ │  ├─ prices (מחירים בדולרים)                              │
│ │  └─ master_products (אב מוצרים - גלובלי!)               │
│ │                                                            │
│ Size: ~5TB (100M products × 1B prices)                      │
│ Location: AWS us-east-1 (Virginia)                          │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Global Master Database (Multi-Region)                       │
├─────────────────────────────────────────────────────────────┤
│ PostgreSQL: gogobe_global (Replicated)                      │
│ ├─ master_products (קטלוג גלובלי)                          │
│ ├─ categories (קטגוריות גלובליות)                          │
│ ├─ brands (מותגים גלובליים)                                │
│ ├─ users (משתמשים גלובליים)                                │
│ └─ region_mapping (מיפוי אזורים)                           │
│                                                              │
│ Replication: Multi-Master (CockroachDB / YugabyteDB)       │
│ Size: ~100GB                                                │
│ Locations: IL, US-EAST, EU, ASIA                            │
└─────────────────────────────────────────────────────────────┘
```

### אפשרות 2: **Schema per Domain** (באותו DB)

```sql
-- Single PostgreSQL instance, multiple schemas

-- Israel Domain
CREATE SCHEMA il;
CREATE TABLE il.store_chains (...);
CREATE TABLE il.stores (...);
CREATE TABLE il.products (...);
CREATE TABLE il.prices (...);

-- US Domain
CREATE SCHEMA us;
CREATE TABLE us.store_chains (...);
CREATE TABLE us.stores (...);
CREATE TABLE us.products (...);
CREATE TABLE us.prices (...);

-- EU Domain
CREATE SCHEMA eu;
CREATE TABLE eu.store_chains (...);
CREATE TABLE eu.stores (...);
CREATE TABLE eu.products (...);
CREATE TABLE eu.prices (...);

-- Global Domain (shared)
CREATE SCHEMA global;
CREATE TABLE global.master_products (...);
CREATE TABLE global.categories (...);
CREATE TABLE global.brands (...);
CREATE TABLE global.users (...);
```

**יתרונות:**
- ✅ ניהול פשוט יותר (DB אחד)
- ✅ Joins בין schemas אפשריים
- ✅ Backup אחד

**חסרונות:**
- ❌ לא ניתן להפריד גיאוגרפית
- ❌ Single point of failure
- ❌ קשה ל-scale

### אפשרות 3: **Database per Service** (Microservices Pattern)

```
┌─────────────────────────────────────────────────────────────┐
│ Product Service                                             │
├─────────────────────────────────────────────────────────────┤
│ PostgreSQL: products_db                                     │
│ ├─ products                                                 │
│ ├─ product_attributes                                       │
│ └─ product_images                                           │
│                                                              │
│ Sharding: By product_id hash                                │
│ Replicas: 3 (IL, US, EU)                                    │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Price Service                                               │
├─────────────────────────────────────────────────────────────┤
│ TimescaleDB: prices_db (time-series optimized)             │
│ ├─ prices (hypertable)                                      │
│ ├─ price_history                                            │
│ └─ price_alerts                                             │
│                                                              │
│ Partitioning: By time (monthly) + region                   │
│ Retention: 2 years                                          │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Store Service                                               │
├─────────────────────────────────────────────────────────────┤
│ PostgreSQL + PostGIS: stores_db                             │
│ ├─ store_chains                                             │
│ ├─ stores (with geom column)                                │
│ └─ store_hours                                              │
│                                                              │
│ Sharding: By region                                         │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ User Service                                                │
├─────────────────────────────────────────────────────────────┤
│ PostgreSQL: users_db                                        │
│ ├─ users                                                    │
│ ├─ user_preferences                                         │
│ └─ user_searches                                            │
│                                                              │
│ Replication: Global (CockroachDB)                           │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Analytics Service                                           │
├─────────────────────────────────────────────────────────────┤
│ ClickHouse: analytics_db (OLAP)                             │
│ ├─ events (billions of rows)                                │
│ ├─ price_trends                                             │
│ └─ user_behavior                                            │
│                                                              │
│ Partitioning: By date                                       │
│ Compression: 10:1 ratio                                     │
└─────────────────────────────────────────────────────────────┘
```

---

## 🌐 ארכיטקטורה מלאה - Global Scale

```
                    ┌──────────────────────────┐
                    │   Global Load Balancer   │
                    │   (Cloudflare / AWS)     │
                    │   - GeoDNS               │
                    │   - DDoS Protection      │
                    │   - CDN                  │
                    └────────────┬─────────────┘
                                 │
                ┌────────────────┼────────────────┐
                │                │                │
        ┌───────▼──────┐  ┌──────▼─────┐  ┌──────▼─────┐
        │ IL Region    │  │ US Region  │  │ EU Region  │
        │ (Tel Aviv)   │  │ (Virginia) │  │ (Frankfurt)│
        └───────┬──────┘  └──────┬─────┘  └──────┬─────┘
                │                │                │
        ┌───────▼──────────────────────────────────▼─────┐
        │         Regional API Gateway (Kong)            │
        │         - Authentication (JWT)                 │
        │         - Rate Limiting (per user/IP)          │
        │         - Request Routing                      │
        └───────┬────────────────────────────────────────┘
                │
        ┌───────▼──────────────────────────────────────┐
        │   Message Broker (Kafka / NATS)              │
        │   - Multi-Region Replication                 │
        │   - Exactly-once delivery                    │
        └───────┬──────────────────────────────────────┘
                │
    ┌───────────┼───────────┬──────────┬──────────┐
    │           │           │          │          │
┌───▼────┐ ┌───▼────┐ ┌────▼───┐ ┌────▼───┐ ┌───▼────┐
│Product │ │Price   │ │Store   │ │User    │ │Import  │
│Service │ │Service │ │Service │ │Service │ │Service │
│(Go)    │ │(Go)    │ │(Go)    │ │(Python)│ │(Go)    │
│        │ │        │ │        │ │        │ │        │
│Scale:  │ │Scale:  │ │Scale:  │ │Scale:  │ │Scale:  │
│10-100  │ │10-100  │ │5-50    │ │5-50    │ │0-20    │
└───┬────┘ └───┬────┘ └────┬───┘ └────┬───┘ └───┬────┘
    │          │           │          │         │
    └──────────┴───────────┴──────────┴─────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
┌───────▼────────┐  ┌──────▼──────┐  ┌───────▼────────┐
│ Redis Cluster  │  │ PostgreSQL  │  │ ClickHouse     │
│ (Cache)        │  │ (OLTP)      │  │ (Analytics)    │
│                │  │             │  │                │
│ - Products     │  │ - Products  │  │ - Events       │
│ - Prices       │  │ - Prices    │  │ - Trends       │
│ - Stores       │  │ - Stores    │  │ - Aggregates   │
│                │  │             │  │                │
│ Sharding: 16   │  │ Sharding: 8 │  │ Partitions:    │
│ nodes          │  │ nodes       │  │ 365 (daily)    │
└────────────────┘  └─────────────┘  └────────────────┘
```

---

## 🔀 Database Sharding Strategy

### Sharding by Region + Hash

```python
# shard_router.py
class ShardRouter:
    """
    Routes database queries to the correct shard
    based on region and entity ID
    """
    
    REGIONS = {
        'IL': {
            'db_host': 'postgres-il.gogobe.com',
            'shards': 4,  # 4 shards for Israel
        },
        'US': {
            'db_host': 'postgres-us.gogobe.com',
            'shards': 16,  # 16 shards for US (bigger)
        },
        'EU': {
            'db_host': 'postgres-eu.gogobe.com',
            'shards': 8,  # 8 shards for EU
        },
    }
    
    def get_shard(self, region: str, entity_id: int) -> str:
        """
        Calculate shard number based on entity ID
        
        Example:
        - Product ID: 123456 in IL → Shard 0 (123456 % 4 = 0)
        - Product ID: 789012 in US → Shard 12 (789012 % 16 = 12)
        """
        region_config = self.REGIONS[region]
        shard_num = entity_id % region_config['shards']
        
        return f"{region_config['db_host']}/gogobe_shard_{shard_num}"
    
    def get_connection(self, region: str, entity_id: int):
        """Get database connection for specific shard"""
        shard_url = self.get_shard(region, entity_id)
        return psycopg2.connect(shard_url)

# Usage
router = ShardRouter()

# Insert product in Israel
product_id = 123456
conn = router.get_connection('IL', product_id)
cursor = conn.cursor()
cursor.execute("""
    INSERT INTO products (id, name, ean, ...)
    VALUES (%s, %s, %s, ...)
""", (product_id, "חלב תנובה", "7290000000001", ...))

# Query product in US
product_id = 789012
conn = router.get_connection('US', product_id)
cursor = conn.cursor()
cursor.execute("""
    SELECT * FROM products WHERE id = %s
""", (product_id,))
```

### Consistent Hashing (Advanced)

```go
// consistent_hash.go
package sharding

import (
    "hash/crc32"
    "sort"
)

type ConsistentHash struct {
    circle map[uint32]string
    nodes  []uint32
}

func NewConsistentHash() *ConsistentHash {
    return &ConsistentHash{
        circle: make(map[uint32]string),
        nodes:  []uint32{},
    }
}

func (ch *ConsistentHash) AddNode(node string, replicas int) {
    // Add virtual nodes for better distribution
    for i := 0; i < replicas; i++ {
        hash := crc32.ChecksumIEEE([]byte(fmt.Sprintf("%s:%d", node, i)))
        ch.circle[hash] = node
        ch.nodes = append(ch.nodes, hash)
    }
    sort.Slice(ch.nodes, func(i, j int) bool {
        return ch.nodes[i] < ch.nodes[j]
    })
}

func (ch *ConsistentHash) GetNode(key string) string {
    hash := crc32.ChecksumIEEE([]byte(key))
    
    // Find first node >= hash
    idx := sort.Search(len(ch.nodes), func(i int) bool {
        return ch.nodes[i] >= hash
    })
    
    if idx == len(ch.nodes) {
        idx = 0  // Wrap around
    }
    
    return ch.circle[ch.nodes[idx]]
}

// Usage
ch := NewConsistentHash()
ch.AddNode("postgres-il-shard-0", 100)
ch.AddNode("postgres-il-shard-1", 100)
ch.AddNode("postgres-il-shard-2", 100)
ch.AddNode("postgres-il-shard-3", 100)

// Get shard for product
shard := ch.GetNode("product:123456")  // → "postgres-il-shard-2"
```

---

## 🌍 Multi-Currency Support

### Currency Table

```sql
-- Global schema
CREATE TABLE global.currencies (
    code CHAR(3) PRIMARY KEY,  -- ISO 4217
    name VARCHAR(100),
    symbol VARCHAR(10),
    decimal_places INT DEFAULT 2,
    is_active BOOLEAN DEFAULT TRUE
);

INSERT INTO global.currencies VALUES
('ILS', 'Israeli Shekel', '₪', 2, TRUE),
('USD', 'US Dollar', '$', 2, TRUE),
('EUR', 'Euro', '€', 2, TRUE),
('GBP', 'British Pound', '£', 2, TRUE),
('JPY', 'Japanese Yen', '¥', 0, TRUE);

-- Exchange rates (updated daily)
CREATE TABLE global.exchange_rates (
    id BIGSERIAL PRIMARY KEY,
    from_currency CHAR(3) REFERENCES global.currencies(code),
    to_currency CHAR(3) REFERENCES global.currencies(code),
    rate DECIMAL(18, 6),
    effective_date DATE DEFAULT CURRENT_DATE,
    source VARCHAR(50),  -- 'ECB', 'Bank of Israel', etc.
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_exchange_rates_lookup 
ON global.exchange_rates(from_currency, to_currency, effective_date DESC);

-- Example data
INSERT INTO global.exchange_rates (from_currency, to_currency, rate, source) VALUES
('USD', 'ILS', 3.65, 'Bank of Israel'),
('EUR', 'ILS', 4.05, 'Bank of Israel'),
('ILS', 'USD', 0.274, 'Bank of Israel'),
('USD', 'EUR', 0.92, 'ECB');
```

### Price Conversion Service

```go
// currency_service.go
package currency

type CurrencyService struct {
    redis *redis.Client
    db    *sql.DB
}

func (cs *CurrencyService) ConvertPrice(
    amount float64,
    fromCurrency string,
    toCurrency string,
) (float64, error) {
    // 1. Check cache first
    cacheKey := fmt.Sprintf("rate:%s:%s", fromCurrency, toCurrency)
    cached, err := cs.redis.Get(ctx, cacheKey).Float64()
    if err == nil {
        return amount * cached, nil
    }
    
    // 2. Query database
    var rate float64
    err = cs.db.QueryRow(`
        SELECT rate 
        FROM global.exchange_rates
        WHERE from_currency = $1 
          AND to_currency = $2
          AND effective_date = CURRENT_DATE
        LIMIT 1
    `, fromCurrency, toCurrency).Scan(&rate)
    
    if err != nil {
        return 0, err
    }
    
    // 3. Cache for 1 hour
    cs.redis.Set(ctx, cacheKey, rate, 1*time.Hour)
    
    return amount * rate, nil
}

// Usage in Price Service
func (ps *PriceService) GetPriceInCurrency(
    productID int,
    targetCurrency string,
) (*Price, error) {
    // Get original price
    price := ps.GetPrice(productID)
    
    // Convert if needed
    if price.Currency != targetCurrency {
        converted, _ := ps.currencyService.ConvertPrice(
            price.Amount,
            price.Currency,
            targetCurrency,
        )
        price.Amount = converted
        price.Currency = targetCurrency
    }
    
    return price, nil
}
```

---

## 📊 Data Replication Strategy

### Master Products - Multi-Master Replication

```
┌─────────────────────────────────────────────────────────────┐
│ CockroachDB / YugabyteDB (Distributed SQL)                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│ Node 1 (IL)          Node 2 (US)          Node 3 (EU)       │
│ ┌──────────┐        ┌──────────┐        ┌──────────┐       │
│ │ master_  │◄──────►│ master_  │◄──────►│ master_  │       │
│ │ products │        │ products │        │ products │       │
│ │          │        │          │        │          │       │
│ │ Replica  │        │ Replica  │        │ Replica  │       │
│ └──────────┘        └──────────┘        └──────────┘       │
│                                                              │
│ Write anywhere, read anywhere                               │
│ Consensus: Raft protocol                                    │
│ Consistency: Strong (linearizable)                          │
└─────────────────────────────────────────────────────────────┘
```

### Regional Data - Master-Slave Replication

```
┌─────────────────────────────────────────────────────────────┐
│ Israel Region                                               │
├─────────────────────────────────────────────────────────────┤
│ Master (Read/Write)                                         │
│ ┌──────────────────┐                                        │
│ │ postgres-il-main │                                        │
│ │ - products       │                                        │
│ │ - prices         │                                        │
│ │ - stores         │                                        │
│ └────────┬─────────┘                                        │
│          │                                                   │
│          ├──────────► Replica 1 (Read-only, Tel Aviv)       │
│          ├──────────► Replica 2 (Read-only, Jerusalem)      │
│          └──────────► Replica 3 (Read-only, Haifa)          │
│                                                              │
│ Replication: Streaming (PostgreSQL native)                  │
│ Lag: <1 second                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🚀 Deployment Architecture

### Kubernetes Multi-Cluster

```yaml
# Global deployment across regions
apiVersion: v1
kind: ConfigMap
metadata:
  name: gogobe-config
data:
  REGION: "IL"
  DB_SHARD_COUNT: "4"
  KAFKA_BROKERS: "kafka-il-1:9092,kafka-il-2:9092,kafka-il-3:9092"
  REDIS_CLUSTER: "redis-il-cluster:6379"
  
---
# Product Service - deployed in all regions
apiVersion: apps/v1
kind: Deployment
metadata:
  name: product-service
  namespace: gogobe-il
spec:
  replicas: 10  # IL: 10, US: 50, EU: 20
  selector:
    matchLabels:
      app: product-service
      region: il
  template:
    metadata:
      labels:
        app: product-service
        region: il
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - product-service
            topologyKey: kubernetes.io/hostname
      containers:
      - name: product-service
        image: gogobe/product-service:v2.0
        env:
        - name: REGION
          valueFrom:
            configMapKeyRef:
              name: gogobe-config
              key: REGION
        resources:
          requests:
            cpu: 500m
            memory: 1Gi
          limits:
            cpu: 2000m
            memory: 4Gi
```

---

## 📈 Capacity Planning

### Expected Scale (5 years)

| Metric | Israel | USA | Europe | Global |
|--------|--------|-----|--------|--------|
| **Products** | 10M | 100M | 50M | 200M |
| **Prices** | 100M | 1B | 500M | 2B |
| **Stores** | 10K | 100K | 50K | 200K |
| **Users** | 1M | 50M | 20M | 100M |
| **Requests/sec** | 1K | 50K | 20K | 100K |
| **DB Size** | 500GB | 5TB | 2TB | 10TB |
| **Cache Size** | 50GB | 500GB | 200GB | 1TB |

### Infrastructure Costs (Monthly)

| Region | Compute | Database | Cache | Storage | Total |
|--------|---------|----------|-------|---------|-------|
| **IL** | $2K | $1K | $500 | $200 | **$3.7K** |
| **US** | $20K | $10K | $5K | $2K | **$37K** |
| **EU** | $10K | $5K | $2.5K | $1K | **$18.5K** |
| **Global** | $5K | $2K | $1K | $500 | **$8.5K** |
| **TOTAL** | $37K | $18K | $9K | $3.7K | **$67.7K/mo** |

---

## 🎯 Implementation Roadmap

### Phase 1: Israel Only (Months 1-3)
- ✅ Single region (IL)
- ✅ Single database
- ✅ Basic microservices
- ✅ Redis cache
- ✅ Kafka messaging

### Phase 2: Multi-Schema (Months 4-6)
- ✅ Add US schema
- ✅ Add EU schema
- ✅ Currency conversion
- ✅ Shard router

### Phase 3: Multi-Region (Months 7-12)
- ✅ Deploy US region
- ✅ Deploy EU region
- ✅ Global load balancer
- ✅ Cross-region replication

### Phase 4: Global Scale (Year 2)
- ✅ Add APAC region
- ✅ Add LATAM region
- ✅ Sharding per region
- ✅ Multi-master replication

---

## ✅ המלצה סופית

### ארכיטקטורה מומלצת

```
1. Database per Region (PostgreSQL)
   ├─ IL: gogobe_il (4 shards)
   ├─ US: gogobe_us (16 shards)
   └─ EU: gogobe_eu (8 shards)

2. Global Master Database (CockroachDB)
   └─ master_products, categories, users

3. Analytics Database (ClickHouse)
   └─ events, trends, aggregates

4. Cache Layer (Redis Cluster)
   ├─ Per region
   └─ 16 nodes per cluster

5. Message Broker (Kafka)
   ├─ Multi-region replication
   └─ 3 brokers per region
```

---

**מוכן לכבוש את העולם?** 🌍🚀
