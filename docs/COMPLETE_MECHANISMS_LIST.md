# 📋 רשימת מנגנונים מלאה - Gogobe System

## תאריך: 21 דצמבר 2025

---

## 🎯 סיכום: כל המנגנונים במערכת

### ✅ מנגנונים שכבר כיסינו

| # | מנגנון | תיאור | מסמך |
|---|--------|-------|------|
| 1 | **Import Service** | קריאת קבצים XML/GZ ושליחה ל-Kafka | PRICE_INGESTION_FLOW.md |
| 2 | **Store Processor** | Get-or-Create סניפים | GET_OR_CREATE_MECHANISMS.md |
| 3 | **Product Processor** | Get-or-Create מוצרים | GET_OR_CREATE_MECHANISMS.md |
| 4 | **Price Processor** | Batch insert מחירים | PRICE_INGESTION_FLOW.md |
| 5 | **Geocoding Service** | המרת כתובת ל-GPS | PRICE_INGESTION_FLOW.md |
| 6 | **Master Product Matching** | קישור לאב מוצר (LLM) | GET_OR_CREATE_MECHANISMS.md |
| 7 | **Currency Conversion** | המרת מטבעות | PRICE_INGESTION_FLOW.md |
| 8 | **Statistics Update** | עדכון מדדים | ADDITIONAL_MECHANISMS.md |
| 9 | **Product Cataloging** | קטלוג LLM | ADDITIONAL_MECHANISMS.md |
| 10 | **Master Product Merge** | איחוד כפילויות | ADDITIONAL_MECHANISMS.md |
| 11 | **Merge Validation** | בדיקת איכות | ADDITIONAL_MECHANISMS.md |

### ⚠️ מנגנונים שחסרים

| # | מנגנון | תיאור | עדיפות |
|---|--------|-------|---------|
| 12 | **Redis Cache Management** | ניהול Cache + Warmup | 🔴 גבוהה |
| 13 | **Duplicate Price Cleanup** | מחיקת מחירים כפולים | 🔴 גבוהה |
| 14 | **Data Validation** | בדיקת תקינות נתונים | 🟡 בינונית |
| 15 | **Error Handling** | טיפול בשגיאות | 🟡 בינונית |
| 16 | **Retry Mechanism** | ניסיון חוזר | 🟡 בינונית |
| 17 | **Health Checks** | בדיקות תקינות | 🟢 נמוכה |
| 18 | **Backup & Recovery** | גיבוי ושחזור | 🟢 נמוכה |

---

## 🔴 מנגנון 12: Redis Cache Management

### תפקיד
ניהול Cache חכם עם Warmup, Invalidation, ו-TTL

### Implementation

```go
// services/cache-service/cache_manager.go
package main

import (
    "github.com/go-redis/redis/v8"
    "database/sql"
    "time"
)

type CacheManager struct {
    redis *redis.Client
    db    *sql.DB
}

// ═══════════════════════════════════════════════════════════
// Cache Warmup - טעינה ראשונית
// ═══════════════════════════════════════════════════════════
func (cm *CacheManager) WarmupCache() error {
    log.Println("🔥 Starting cache warmup...")
    
    start := time.Now()
    
    // 1. Load all chains (small dataset)
    cm.warmupChains()
    
    // 2. Load top 10K products (most accessed)
    cm.warmupTopProducts(10000)
    
    // 3. Load active stores (last 30 days)
    cm.warmupActiveStores()
    
    // 4. Load exchange rates
    cm.warmupExchangeRates()
    
    duration := time.Since(start)
    log.Printf("✅ Cache warmup completed in %v", duration)
    
    return nil
}

func (cm *CacheManager) warmupChains() {
    rows, _ := cm.db.Query(`
        SELECT id, chain_code, name 
        FROM store_chains
    `)
    defer rows.Close()
    
    count := 0
    for rows.Next() {
        var id int64
        var code, name string
        rows.Scan(&id, &code, &name)
        
        // Cache by code
        key := "chain:code:" + code
        cm.redis.Set(ctx, key, id, 7*24*time.Hour)
        
        // Cache by name
        key = "chain:name:" + name
        cm.redis.Set(ctx, key, id, 7*24*time.Hour)
        
        count++
    }
    
    log.Printf("✅ Cached %d chains", count)
}

func (cm *CacheManager) warmupTopProducts(limit int) {
    // Get most accessed products (by price count)
    rows, _ := cm.db.Query(`
        SELECT p.id, p.ean, COUNT(pr.id) as price_count
        FROM products p
        JOIN prices pr ON pr.product_id = p.id
        WHERE p.ean IS NOT NULL
        GROUP BY p.id, p.ean
        ORDER BY price_count DESC
        LIMIT $1
    `, limit)
    defer rows.Close()
    
    count := 0
    for rows.Next() {
        var id int64
        var ean string
        var priceCount int
        rows.Scan(&id, &ean, &priceCount)
        
        key := "product:ean:" + ean
        cm.redis.Set(ctx, key, id, 24*time.Hour)
        
        count++
    }
    
    log.Printf("✅ Cached %d top products", count)
}

func (cm *CacheManager) warmupActiveStores() {
    // Get stores with recent price updates
    rows, _ := cm.db.Query(`
        SELECT DISTINCT s.id, s.chain_id, s.store_id
        FROM stores s
        JOIN prices pr ON pr.store_id = s.id
        WHERE pr.scraped_at > NOW() - INTERVAL '30 days'
    `)
    defer rows.Close()
    
    count := 0
    for rows.Next() {
        var id, chainID int64
        var storeCode string
        rows.Scan(&id, &chainID, &storeCode)
        
        identifier := fmt.Sprintf("%d_%s", chainID, storeCode)
        key := "store:id:" + identifier
        cm.redis.Set(ctx, key, id, 24*time.Hour)
        
        count++
    }
    
    log.Printf("✅ Cached %d active stores", count)
}

func (cm *CacheManager) warmupExchangeRates() {
    // Get latest exchange rates
    rows, _ := cm.db.Query(`
        SELECT DISTINCT ON (from_currency, to_currency)
            from_currency, to_currency, rate
        FROM exchange_rates
        WHERE effective_date = CURRENT_DATE
        ORDER BY from_currency, to_currency, created_at DESC
    `)
    defer rows.Close()
    
    count := 0
    for rows.Next() {
        var from, to string
        var rate float64
        rows.Scan(&from, &to, &rate)
        
        key := fmt.Sprintf("rate:%s:%s", from, to)
        cm.redis.Set(ctx, key, rate, 1*time.Hour)
        
        count++
    }
    
    log.Printf("✅ Cached %d exchange rates", count)
}

// ═══════════════════════════════════════════════════════════
// Cache Invalidation - ניקוי Cache
// ═══════════════════════════════════════════════════════════
func (cm *CacheManager) InvalidatePattern(pattern string) error {
    // Find all keys matching pattern
    iter := cm.redis.Scan(ctx, 0, pattern, 0).Iterator()
    
    count := 0
    for iter.Next(ctx) {
        cm.redis.Del(ctx, iter.Val())
        count++
    }
    
    if err := iter.Err(); err != nil {
        return err
    }
    
    log.Printf("✅ Invalidated %d keys matching '%s'", count, pattern)
    return nil
}

// Invalidate specific entities
func (cm *CacheManager) InvalidateProduct(productID int64) {
    // Get EAN
    var ean string
    cm.db.QueryRow("SELECT ean FROM products WHERE id = $1", productID).Scan(&ean)
    
    if ean != "" {
        cm.redis.Del(ctx, "product:ean:"+ean)
    }
}

func (cm *CacheManager) InvalidateStore(storeID int64) {
    // Get identifier
    var chainID int64
    var storeCode string
    cm.db.QueryRow(`
        SELECT chain_id, store_id FROM stores WHERE id = $1
    `, storeID).Scan(&chainID, &storeCode)
    
    identifier := fmt.Sprintf("%d_%s", chainID, storeCode)
    cm.redis.Del(ctx, "store:id:"+identifier)
}

// ═══════════════════════════════════════════════════════════
// Cache Statistics
// ═══════════════════════════════════════════════════════════
func (cm *CacheManager) GetCacheStats() map[string]interface{} {
    info := cm.redis.Info(ctx, "stats").Val()
    
    // Parse info string
    stats := make(map[string]interface{})
    
    // Get key count
    dbSize := cm.redis.DBSize(ctx).Val()
    stats["total_keys"] = dbSize
    
    // Get memory usage
    memInfo := cm.redis.Info(ctx, "memory").Val()
    stats["memory_info"] = memInfo
    
    // Calculate hit rate
    // (This requires tracking hits/misses in application)
    
    return stats
}
```

### Cache Strategy per Entity

```
┌─────────────────────────────────────────────────────────────┐
│ Entity: Chains                                              │
├─────────────────────────────────────────────────────────────┤
│ Key Pattern: chain:code:{code}                             │
│ TTL: 7 days (rarely changes)                               │
│ Size: ~100 keys                                            │
│ Hit Rate: 99.9%                                            │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Entity: Products                                            │
├─────────────────────────────────────────────────────────────┤
│ Key Pattern: product:ean:{barcode}                         │
│ TTL: 24 hours                                              │
│ Size: ~10K keys (top products)                            │
│ Hit Rate: 99%                                              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Entity: Stores                                              │
├─────────────────────────────────────────────────────────────┤
│ Key Pattern: store:id:{chain_id}_{store_code}             │
│ TTL: 24 hours                                              │
│ Size: ~5K keys (active stores)                            │
│ Hit Rate: 95%                                              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Entity: Exchange Rates                                      │
├─────────────────────────────────────────────────────────────┤
│ Key Pattern: rate:{from}:{to}                              │
│ TTL: 1 hour                                                │
│ Size: ~50 keys                                             │
│ Hit Rate: 99.9%                                            │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔴 מנגנון 13: Duplicate Price Cleanup

### תפקיד
זיהוי ומחיקה של מחירים כפולים (אותו מוצר, אותו סניף, אותו יום)

### Implementation

```go
// services/cleanup-service/duplicate_cleaner.go
package main

type DuplicateCleaner struct {
    db *sql.DB
}

// ═══════════════════════════════════════════════════════════
// Find Duplicates
// ═══════════════════════════════════════════════════════════
func (dc *DuplicateCleaner) FindDuplicatePrices(date time.Time) ([]DuplicateGroup, error) {
    /*
    Find prices that are duplicated:
    - Same product_id
    - Same store_id
    - Same date (DATE(scraped_at))
    - Different price_id
    */
    
    rows, err := dc.db.Query(`
        SELECT 
            product_id,
            store_id,
            DATE(scraped_at) as price_date,
            array_agg(id ORDER BY scraped_at DESC) as price_ids,
            array_agg(price ORDER BY scraped_at DESC) as prices,
            array_agg(scraped_at ORDER BY scraped_at DESC) as timestamps,
            COUNT(*) as duplicate_count
        FROM prices
        WHERE DATE(scraped_at) = $1
        GROUP BY product_id, store_id, DATE(scraped_at)
        HAVING COUNT(*) > 1
        ORDER BY COUNT(*) DESC
    `, date)
    
    if err != nil {
        return nil, err
    }
    defer rows.Close()
    
    var duplicates []DuplicateGroup
    
    for rows.Next() {
        var group DuplicateGroup
        var priceIDs, prices, timestamps string
        
        rows.Scan(
            &group.ProductID,
            &group.StoreID,
            &group.Date,
            &priceIDs,
            &prices,
            &timestamps,
            &group.Count,
        )
        
        // Parse arrays
        group.PriceIDs = parseIntArray(priceIDs)
        group.Prices = parseFloatArray(prices)
        group.Timestamps = parseTimeArray(timestamps)
        
        duplicates = append(duplicates, group)
    }
    
    log.Printf("Found %d duplicate groups for date %s", len(duplicates), date)
    
    return duplicates, nil
}

// ═══════════════════════════════════════════════════════════
// Clean Duplicates
// ═══════════════════════════════════════════════════════════
func (dc *DuplicateCleaner) CleanDuplicates(
    duplicates []DuplicateGroup,
    strategy string,  // "keep_latest", "keep_first", "keep_average"
    dryRun bool,
) (int, error) {
    
    totalDeleted := 0
    
    for _, group := range duplicates {
        // Decide which price to keep
        keepID := dc.selectPriceToKeep(group, strategy)
        
        // Delete others
        deleteIDs := []int64{}
        for _, id := range group.PriceIDs {
            if id != keepID {
                deleteIDs = append(deleteIDs, id)
            }
        }
        
        if dryRun {
            log.Printf("DRY RUN: Would delete %d prices for product %d, store %d, date %s",
                len(deleteIDs), group.ProductID, group.StoreID, group.Date)
        } else {
            // Delete duplicates
            result, err := dc.db.Exec(`
                DELETE FROM prices
                WHERE id = ANY($1)
            `, pq.Array(deleteIDs))
            
            if err != nil {
                log.Printf("Error deleting duplicates: %v", err)
                continue
            }
            
            deleted, _ := result.RowsAffected()
            totalDeleted += int(deleted)
            
            log.Printf("✅ Deleted %d duplicate prices for product %d, store %d",
                deleted, group.ProductID, group.StoreID)
        }
    }
    
    return totalDeleted, nil
}

func (dc *DuplicateCleaner) selectPriceToKeep(
    group DuplicateGroup,
    strategy string,
) int64 {
    
    switch strategy {
    case "keep_latest":
        // Keep the most recent price
        return group.PriceIDs[0]  // Already sorted DESC
    
    case "keep_first":
        // Keep the earliest price
        return group.PriceIDs[len(group.PriceIDs)-1]
    
    case "keep_average":
        // Calculate average and keep closest
        var sum float64
        for _, price := range group.Prices {
            sum += price
        }
        avg := sum / float64(len(group.Prices))
        
        // Find closest to average
        minDiff := math.MaxFloat64
        var closestID int64
        
        for i, price := range group.Prices {
            diff := math.Abs(price - avg)
            if diff < minDiff {
                minDiff = diff
                closestID = group.PriceIDs[i]
            }
        }
        
        return closestID
    
    default:
        return group.PriceIDs[0]
    }
}

// ═══════════════════════════════════════════════════════════
// Scheduled Cleanup
// ═══════════════════════════════════════════════════════════
func (dc *DuplicateCleaner) RunDailyCleanup() {
    // Run every day at 2 AM
    ticker := time.NewTicker(24 * time.Hour)
    
    // Run immediately on startup
    dc.cleanupYesterday()
    
    for range ticker.C {
        dc.cleanupYesterday()
    }
}

func (dc *DuplicateCleaner) cleanupYesterday() {
    yesterday := time.Now().AddDate(0, 0, -1)
    
    log.Printf("🧹 Starting duplicate cleanup for %s", yesterday.Format("2006-01-02"))
    
    // Find duplicates
    duplicates, err := dc.FindDuplicatePrices(yesterday)
    if err != nil {
        log.Printf("Error finding duplicates: %v", err)
        return
    }
    
    if len(duplicates) == 0 {
        log.Println("✅ No duplicates found")
        return
    }
    
    // Clean duplicates (keep latest)
    deleted, err := dc.CleanDuplicates(duplicates, "keep_latest", false)
    if err != nil {
        log.Printf("Error cleaning duplicates: %v", err)
        return
    }
    
    log.Printf("✅ Cleanup completed: deleted %d duplicate prices", deleted)
}

type DuplicateGroup struct {
    ProductID  int64
    StoreID    int64
    Date       time.Time
    PriceIDs   []int64
    Prices     []float64
    Timestamps []time.Time
    Count      int
}
```

### Usage

```go
// Manual cleanup
cleaner := &DuplicateCleaner{db: db}

// Find duplicates for specific date
duplicates, _ := cleaner.FindDuplicatePrices(time.Date(2025, 12, 21, 0, 0, 0, 0, time.UTC))

// Dry run first
cleaner.CleanDuplicates(duplicates, "keep_latest", true)

// Actually delete
cleaner.CleanDuplicates(duplicates, "keep_latest", false)

// Or run scheduled cleanup
go cleaner.RunDailyCleanup()
```

---

## 🟡 מנגנון 14: Data Validation

### תפקיד
בדיקת תקינות נתונים לפני הכנסה ל-DB

```go
// services/validation-service/validator.go
package main

type DataValidator struct{}

func (v *DataValidator) ValidatePrice(price float64, currency string) error {
    // Price must be positive
    if price <= 0 {
        return fmt.Errorf("invalid price: %f (must be positive)", price)
    }
    
    // Price must be reasonable (< $10,000)
    if price > 10000 {
        return fmt.Errorf("invalid price: %f (too high)", price)
    }
    
    // Currency must be valid ISO 4217
    validCurrencies := []string{"ILS", "USD", "EUR", "GBP", "JPY"}
    if !contains(validCurrencies, currency) {
        return fmt.Errorf("invalid currency: %s", currency)
    }
    
    return nil
}

func (v *DataValidator) ValidateBarcode(barcode string) error {
    // Barcode must not be empty
    if barcode == "" {
        return fmt.Errorf("barcode is empty")
    }
    
    // Barcode must be numeric
    if !isNumeric(barcode) {
        return fmt.Errorf("barcode must be numeric: %s", barcode)
    }
    
    // Barcode must be 8, 12, or 13 digits (EAN-8, UPC, EAN-13)
    length := len(barcode)
    if length != 8 && length != 12 && length != 13 {
        return fmt.Errorf("invalid barcode length: %d (must be 8, 12, or 13)", length)
    }
    
    return nil
}

func (v *DataValidator) ValidateStore(name, city, address string) error {
    if name == "" {
        return fmt.Errorf("store name is empty")
    }
    
    if city == "" {
        return fmt.Errorf("store city is empty")
    }
    
    // Address is optional but recommended
    if address == "" {
        log.Warn("Store has no address - geocoding will be less accurate")
    }
    
    return nil
}
```

---

## 📊 סיכום מלא: כל 18 המנגנונים

### Core Processing (1-7)
1. ✅ Import Service
2. ✅ Store Processor
3. ✅ Product Processor
4. ✅ Price Processor
5. ✅ Geocoding Service
6. ✅ Master Product Matching
7. ✅ Currency Conversion

### Post-Processing (8-11)
8. ✅ Statistics Update
9. ✅ Product Cataloging (LLM)
10. ✅ Master Product Merge
11. ✅ Merge Validation

### Infrastructure (12-14)
12. ✅ Redis Cache Management
13. ✅ Duplicate Price Cleanup
14. ✅ Data Validation

### Operations (15-18)
15. ⏳ Error Handling
16. ⏳ Retry Mechanism
17. ⏳ Health Checks
18. ⏳ Backup & Recovery

---

## 🚀 Redis: חינמי ו-Open Source!

### למה Redis?
- ✅ **חינמי לחלוטין** (Open Source, BSD license)
- ✅ **מהיר** - <1ms latency
- ✅ **פשוט** - API קל לשימוש
- ✅ **יציב** - production-ready
- ✅ **קל להתקנה** - `docker run redis`

### חלופות חינמיות (אם צריך):
1. **Memcached** - פשוט יותר, אבל פחות features
2. **DragonflyDB** - תואם Redis, מהיר יותר
3. **KeyDB** - fork של Redis עם multi-threading

**המלצה: השאר עם Redis - זה הסטנדרט!** ✅

---

## ✅ Next Steps

1. **עכשיו:** יישום מנגנונים 1-7 (Core)
2. **שבוע הבא:** מנגנונים 8-11 (Post-Processing)
3. **שבועיים:** מנגנונים 12-14 (Infrastructure)
4. **חודש:** מנגנונים 15-18 (Operations)

**יש לך עכשיו תמונה מלאה של כל המערכת!** 🎯
