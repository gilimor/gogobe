# 🎯 תכנית יישום - Gogobe Global Price Platform

## תאריך: 21 דצמבר 2025

---

## 📋 סדר עדיפויות נכון

### ❌ לא נכון:
```
1. Frontend מדהים
2. AI/LLM
3. Global infrastructure
4. ואז... אולי ייבוא נתונים?
```

### ✅ נכון:
```
1. ✅ מנגנון קליטת מחירים עובד (עם כל החוקים!)
2. ✅ Microservices לטיפול בלוגיקה
3. ✅ Cache + DB optimization
4. ✅ API בסיסי
5. ⏳ Frontend פשוט
6. ⏳ LLM/AI (רק אחרי שהבסיס עובד!)
7. ⏳ Global scale
```

---

## 🏗️ Phase 1: מנגנון קליטת מחירים (שבועות 1-4)

### Week 1: Import Service (Go) - הבסיס

```go
// services/import-service/main.go
package main

/*
תפקיד: קריאת קבצים XML/GZ ושליחת events ל-Kafka

חוקים שצריך לטפל בהם:
1. ✅ בדיקת קיום סניף (לא ליצור כפילויות)
2. ✅ בדיקת קיום מוצר (לפי ברקוד)
3. ✅ מניעת כפילויות במחירים (upsert_price)
4. ✅ Geocoding (אסינכרוני)
5. ✅ קישור לאב מוצר (אסינכרוני)
6. ✅ המרת מטבעות
*/

import (
    "encoding/xml"
    "github.com/confluentinc/confluent-kafka-go/kafka"
    "compress/gzip"
    "io"
    "os"
)

type Product struct {
    Name     string  `xml:"ItemNm"`
    Barcode  string  `xml:"ItemCode"`
    Price    float64 `xml:"ItemPrice"`
    StoreID  string  `xml:"StoreId"`
}

type PriceFile struct {
    XMLName  xml.Name  `xml:"Root"`
    Products []Product `xml:"Items>Item"`
    StoreID  string    `xml:"StoreId"`
    ChainID  string    `xml:"ChainId"`
}

func main() {
    // 1. Setup Kafka producer
    producer, err := kafka.NewProducer(&kafka.ConfigMap{
        "bootstrap.servers": "kafka:9092",
        "compression.type":  "snappy",
        "batch.size":        16384,
        "linger.ms":         10,
    })
    if err != nil {
        panic(err)
    }
    defer producer.Close()

    // 2. Parse XML file
    file, _ := os.Open("prices.xml.gz")
    defer file.Close()
    
    gzReader, _ := gzip.NewReader(file)
    defer gzReader.Close()
    
    var priceFile PriceFile
    decoder := xml.NewDecoder(gzReader)
    decoder.Decode(&priceFile)

    // 3. Send events to Kafka
    for _, product := range priceFile.Products {
        event := map[string]interface{}{
            "type":      "product.raw",
            "region":    "IL",
            "chain_id":  priceFile.ChainID,
            "store_id":  product.StoreID,
            "barcode":   product.Barcode,
            "name":      product.Name,
            "price":     product.Price,
            "currency":  "ILS",
            "timestamp": time.Now(),
        }
        
        jsonEvent, _ := json.Marshal(event)
        
        producer.Produce(&kafka.Message{
            TopicPartition: kafka.TopicPartition{
                Topic:     &[]string{"products.raw"}[0],
                Partition: kafka.PartitionAny,
            },
            Value: jsonEvent,
        }, nil)
    }
    
    producer.Flush(15000)
    log.Printf("✅ Sent %d products to Kafka", len(priceFile.Products))
}
```

---

### Week 2: Product Processor (Go) - הלוגיקה המרכזית

```go
// services/product-processor/main.go
package main

/*
תפקיד: עיבוד מוצרים עם כל החוקים

חוקים:
1. ✅ בדיקה ב-Redis Cache (99% hit rate)
2. ✅ בדיקה ב-DB (רק אם לא ב-Cache)
3. ✅ יצירת מוצר חדש (אם לא קיים)
4. ✅ Batch insert למחירים (1000 בכל פעם)
5. ✅ upsert_price (מניעת כפילויות)
*/

import (
    "github.com/go-redis/redis/v8"
    "github.com/confluentinc/confluent-kafka-go/kafka"
    "database/sql"
    _ "github.com/lib/pq"
)

var (
    redisClient *redis.Client
    db          *sql.DB
    priceQueue  []Price
)

type Price struct {
    ProductID int64
    StoreID   int64
    Price     float64
    Currency  string
}

func main() {
    // Setup
    redisClient = redis.NewClient(&redis.Options{
        Addr: "redis:6379",
    })
    
    db, _ = sql.Open("postgres", "postgres://...")
    
    // Kafka consumer
    consumer, _ := kafka.NewConsumer(&kafka.ConfigMap{
        "bootstrap.servers": "kafka:9092",
        "group.id":          "product-processor",
        "auto.offset.reset": "earliest",
    })
    
    consumer.Subscribe("products.raw", nil)
    
    for {
        msg, _ := consumer.ReadMessage(-1)
        
        var event map[string]interface{}
        json.Unmarshal(msg.Value, &event)
        
        processProduct(event)
    }
}

func processProduct(event map[string]interface{}) {
    barcode := event["barcode"].(string)
    
    // חוק 1: בדיקה ב-Redis Cache
    productID := getProductFromCache(barcode)
    
    if productID == 0 {
        // חוק 2: בדיקה ב-DB
        productID = getProductFromDB(barcode)
        
        if productID == 0 {
            // חוק 3: יצירת מוצר חדש
            productID = createProduct(event)
        }
        
        // שמירה ב-Cache לפעם הבאה
        cacheProduct(barcode, productID)
    }
    
    // חוק 4: הוספה ל-Batch Queue
    priceQueue = append(priceQueue, Price{
        ProductID: productID,
        StoreID:   getStoreID(event["store_id"].(string)),
        Price:     event["price"].(float64),
        Currency:  event["currency"].(string),
    })
    
    // חוק 5: Batch Insert (כל 1000 מחירים)
    if len(priceQueue) >= 1000 {
        batchInsertPrices(priceQueue)
        priceQueue = []Price{}
    }
}

func getProductFromCache(barcode string) int64 {
    val, err := redisClient.Get(ctx, "product:ean:"+barcode).Int64()
    if err != nil {
        return 0
    }
    return val
}

func getProductFromDB(barcode string) int64 {
    var id int64
    db.QueryRow(`
        SELECT id FROM products 
        WHERE ean = $1 OR manufacturer_code = $1
        LIMIT 1
    `, barcode).Scan(&id)
    return id
}

func createProduct(event map[string]interface{}) int64 {
    var id int64
    db.QueryRow(`
        INSERT INTO products (name, ean, vertical_id)
        VALUES ($1, $2, 1)
        ON CONFLICT (ean) DO UPDATE SET name = EXCLUDED.name
        RETURNING id
    `, event["name"], event["barcode"]).Scan(&id)
    
    log.Printf("✅ Created product: %s (ID: %d)", event["name"], id)
    return id
}

func cacheProduct(barcode string, productID int64) {
    redisClient.Set(ctx, "product:ean:"+barcode, productID, 24*time.Hour)
}

func batchInsertPrices(prices []Price) {
    // חוק 6: upsert_price (מניעת כפילויות)
    stmt, _ := db.Prepare(`
        SELECT upsert_price($1, $2, $3, $4, $5, TRUE, 0.01)
    `)
    defer stmt.Close()
    
    for _, price := range prices {
        stmt.Exec(
            price.ProductID,
            1, // supplier_id
            price.StoreID,
            price.Price,
            price.Currency,
        )
    }
    
    log.Printf("✅ Inserted %d prices", len(prices))
}
```

---

### Week 3: Store Processor (Go) - ניהול סניפים

```go
// services/store-processor/main.go
package main

/*
תפקיד: ניהול סניפים

חוקים:
1. ✅ בדיקת קיום סניף (ON CONFLICT)
2. ✅ עדכון פרטים (אם השתנו)
3. ✅ שליחת event ל-Geocoding (אסינכרוני)
*/

func processStore(event map[string]interface{}) {
    chainID := getChainID(event["chain_id"].(string))
    storeCode := buildStoreIdentifier(event)
    
    // חוק 1+2: Get or Create + Update
    var storeID int64
    db.QueryRow(`
        INSERT INTO stores (
            chain_id, store_id, name, city, address, bikoret_no
        )
        VALUES ($1, $2, $3, $4, $5, $6)
        ON CONFLICT (chain_id, store_id) 
        DO UPDATE SET
            name = EXCLUDED.name,
            city = EXCLUDED.city,
            address = EXCLUDED.address,
            bikoret_no = EXCLUDED.bikoret_no
        RETURNING id
    `, chainID, storeCode, event["name"], event["city"], 
       event["address"], event["bikoret_no"]).Scan(&storeID)
    
    // חוק 3: שליחת event ל-Geocoding (רק אם אין GPS)
    if !hasGPS(storeID) {
        sendToGeocoding(storeID, event)
    }
    
    log.Printf("✅ Store processed: %s (ID: %d)", event["name"], storeID)
}

func hasGPS(storeID int64) bool {
    var lat float64
    db.QueryRow(`
        SELECT latitude FROM stores WHERE id = $1
    `, storeID).Scan(&lat)
    return lat != 0
}

func sendToGeocoding(storeID int64, event map[string]interface{}) {
    geocodingEvent := map[string]interface{}{
        "type":      "geocoding.request",
        "store_id":  storeID,
        "address":   event["address"],
        "city":      event["city"],
    }
    
    // שליחה ל-Kafka
    producer.Produce(&kafka.Message{
        TopicPartition: kafka.TopicPartition{
            Topic: &[]string{"geocoding.requests"}[0],
        },
        Value: jsonEvent,
    }, nil)
}
```

---

### Week 4: Geocoding Service (Go) - GPS אסינכרוני

```go
// services/geocoding-service/main.go
package main

/*
תפקיד: Geocoding אסינכרוני

חוקים:
1. ✅ לא חוסם את הייבוא
2. ✅ Rate limiting (1 req/sec)
3. ✅ Retry logic
4. ✅ Cache תוצאות
*/

func main() {
    consumer, _ := kafka.NewConsumer(&kafka.ConfigMap{
        "bootstrap.servers": "kafka:9092",
        "group.id":          "geocoding-service",
    })
    
    consumer.Subscribe("geocoding.requests", nil)
    
    // Rate limiter - 1 request per second
    limiter := time.NewTicker(1 * time.Second)
    
    for {
        msg, _ := consumer.ReadMessage(-1)
        
        var event map[string]interface{}
        json.Unmarshal(msg.Value, &event)
        
        // המתן ל-rate limiter
        <-limiter.C
        
        // Geocoding (async)
        go geocodeStore(event)
    }
}

func geocodeStore(event map[string]interface{}) {
    storeID := int64(event["store_id"].(float64))
    address := event["address"].(string)
    city := event["city"].(string)
    
    // חוק 1: בדיקה ב-Cache
    cacheKey := fmt.Sprintf("geo:%s:%s", address, city)
    cached := redisClient.Get(ctx, cacheKey).Val()
    
    var lat, lon float64
    
    if cached != "" {
        // Parse from cache
        fmt.Sscanf(cached, "%f,%f", &lat, &lon)
    } else {
        // חוק 2: קריאה ל-OSM API
        lat, lon = callOSMAPI(address, city)
        
        // Cache לשנה
        redisClient.Set(ctx, cacheKey, 
            fmt.Sprintf("%f,%f", lat, lon), 
            365*24*time.Hour)
    }
    
    if lat != 0 && lon != 0 {
        // חוק 3: עדכון DB
        db.Exec(`
            UPDATE stores 
            SET latitude = $1, longitude = $2,
                geom = ST_SetSRID(ST_MakePoint($2, $1), 4326)
            WHERE id = $3
        `, lat, lon, storeID)
        
        log.Printf("✅ Geocoded store %d: %f, %f", storeID, lat, lon)
    }
}
```

---

## 📊 Phase 2: Optimization (שבועות 5-6)

### Week 5: Redis Cache Layer

```go
// services/cache-service/cache.go
package cache

/*
מבנה Cache:

1. Products by EAN:
   Key: "product:ean:7290000000001"
   Value: "12345" (product_id)
   TTL: 24 hours

2. Stores by ID:
   Key: "store:IL:001"
   Value: JSON {id, name, lat, lon}
   TTL: 24 hours

3. Chains:
   Key: "chain:name:Rami_Levy"
   Value: "153" (chain_id)
   TTL: 7 days

4. Exchange Rates:
   Key: "rate:ILS:USD"
   Value: "0.274"
   TTL: 1 hour
*/

func WarmupCache() {
    // טעינה ראשונית של נתונים נפוצים
    
    // 1. כל הרשתות
    rows, _ := db.Query("SELECT id, name FROM store_chains")
    for rows.Next() {
        var id int64
        var name string
        rows.Scan(&id, &name)
        
        key := "chain:name:" + strings.ReplaceAll(name, " ", "_")
        redisClient.Set(ctx, key, id, 7*24*time.Hour)
    }
    
    // 2. מוצרים פופולריים (top 10K)
    rows, _ = db.Query(`
        SELECT id, ean FROM products 
        WHERE ean IS NOT NULL 
        ORDER BY id DESC 
        LIMIT 10000
    `)
    for rows.Next() {
        var id int64
        var ean string
        rows.Scan(&id, &ean)
        
        redisClient.Set(ctx, "product:ean:"+ean, id, 24*time.Hour)
    }
    
    log.Println("✅ Cache warmed up")
}
```

---

### Week 6: Performance Testing

```bash
# test/load-test.sh

# 1. ייבוא 100,000 מוצרים
echo "Testing import of 100K products..."
time docker exec import-service ./import-service --file=test-100k.xml.gz

# Expected: < 60 seconds

# 2. בדיקת Cache Hit Rate
echo "Checking Redis cache hit rate..."
docker exec redis-israel redis-cli INFO stats | grep keyspace_hits

# Expected: > 95%

# 3. בדיקת DB Load
echo "Checking PostgreSQL load..."
docker exec postgres-israel psql -U postgres -c "
    SELECT COUNT(*) FROM pg_stat_activity WHERE state = 'active';
"

# Expected: < 10 active connections

# 4. בדיקת Kafka Lag
echo "Checking Kafka consumer lag..."
docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 \
    --describe --group product-processor

# Expected: lag < 100
```

---

## 🎯 Success Criteria - Phase 1

### ביצועים:
- ✅ ייבוא 100K מוצרים ב-< 60 שניות
- ✅ Cache Hit Rate > 95%
- ✅ DB Queries < 1000/sec
- ✅ אפס כפילויות במחירים
- ✅ אפס כפילויות בסניפים

### איכות נתונים:
- ✅ כל מוצר עם ברקוד תקין
- ✅ כל סניף עם GPS (תוך 24 שעות)
- ✅ כל מחיר עם timestamp
- ✅ היסטוריית מחירים (first_scraped_at, last_scraped_at)

### יציבות:
- ✅ אם שירות נופל - השאר ממשיכים
- ✅ Kafka מבטיח delivery (at-least-once)
- ✅ Redis failover אוטומטי
- ✅ DB backups אוטומטיים

---

## 📁 מבנה תיקיות

```
Gogobe/
├── services/
│   ├── import-service/          # Week 1
│   │   ├── main.go
│   │   ├── parser.go
│   │   └── Dockerfile
│   │
│   ├── product-processor/       # Week 2
│   │   ├── main.go
│   │   ├── cache.go
│   │   ├── batch.go
│   │   └── Dockerfile
│   │
│   ├── store-processor/         # Week 3
│   │   ├── main.go
│   │   └── Dockerfile
│   │
│   └── geocoding-service/       # Week 4
│       ├── main.go
│       ├── osm.go
│       └── Dockerfile
│
├── docker-compose.yml           # כל השירותים
├── monitoring/
│   ├── prometheus.yml
│   └── grafana-dashboards/
│
└── tests/
    ├── load-test.sh
    └── integration-test.sh
```

---

## ✅ Next Steps

### עכשיו (שבוע 1):
```bash
# 1. צור Import Service
cd services/import-service
go mod init gogobe/import-service
go get github.com/confluentinc/confluent-kafka-go/kafka

# 2. כתוב את הקוד (מהדוגמה למעלה)
# 3. Build
docker build -t gogobe/import-service:v1 .

# 4. Test
docker run gogobe/import-service:v1 --file=test.xml.gz
```

### שבוע הבא (שבוע 2):
- Product Processor
- Integration עם Redis
- Batch insert logic

---

**זה הבסיס הנכון - מנגנון קליטה עובד עם כל החוקים!** 🚀

**רק אחרי שזה עובד 100% - נעבור ל-LLM ו-Global scale** ✅
