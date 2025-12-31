# 🎯 המלצות Microservices - ארכיטקטורה גמישה ויעילה

## תאריך: 21 דצמבר 2025

---

## 📋 עקרונות מנחים

1. ✅ **גמישות** - קל להוסיף/להסיר/לאחד שירותים
2. ✅ **Auto-scaling** - שירותים מתעוררים לפי צורך ונכבים כשלא צריך
3. ✅ **Load Balancing** - מספר instances של אותו שירות רצים במקביל
4. ✅ **חיסכון ב-CPU** - כמה שפחות צריכת משאבים כש-idle
5. ✅ **Observability** - ניטור ולוגים מרכזיים

---

## 🏗️ רשימת Microservices מומלצת

### 📊 טבלת שירותים

| # | שם השירות | תפקיד | שפה | עדיפות | Auto-scale | CPU Idle |
|---|-----------|-------|-----|---------|------------|----------|
| 1 | **API Gateway** | ניתוב, אימות, rate limiting | Python/FastAPI | 🔴 גבוהה | כן | נמוך |
| 2 | **Import Service** | קריאת קבצים, שליחת events | Go | 🔴 גבוהה | כן | אפס |
| 3 | **Product Processor** | עיבוד מוצרים, DB writes | Go | 🔴 גבוהה | כן | אפס |
| 4 | **Price Processor** | עיבוד מחירים, batch insert | Go | 🔴 גבוהה | כן | אפס |
| 5 | **Store Processor** | עיבוד סניפים | Go | 🟡 בינונית | כן | אפס |
| 6 | **Geocoding Service** | המרת כתובות ל-GPS | Go | 🟡 בינונית | כן | אפס |
| 7 | **Product Matching** | קישור לאב מוצר (AI) | Python | 🟡 בינונית | כן | נמוך |
| 8 | **Cache Service** | ניהול Redis, invalidation | Go | 🟢 נמוכה | לא | נמוך |
| 9 | **Analytics Service** | חישוב סטטיסטיקות | Python | 🟢 נמוכה | כן | אפס |
| 10 | **Notification Service** | התראות (email, webhook) | Go | 🟢 נמוכה | כן | אפס |
| 11 | **Image Service** | עיבוד תמונות מוצרים | Go | 🟢 נמוכה | כן | אפס |
| 12 | **Report Generator** | יצירת דוחות | Python | 🟢 נמוכה | כן | אפס |

---

## 🔄 ארכיטקטורה גמישה - Domain-Driven Design

### עיקרון: כל Domain = Microservice נפרד

```
┌─────────────────────────────────────────────────────────────┐
│                    API Gateway (FastAPI)                     │
│  - Authentication (JWT)                                      │
│  - Rate Limiting                                             │
│  - Request Routing                                           │
│  - Load Balancing                                            │
└────────────────┬────────────────────────────────────────────┘
                 │
    ┌────────────┴────────────┐
    │   Message Broker        │
    │   (Kafka / NATS)        │
    │   Topics:               │
    │   - files.uploaded      │
    │   - products.raw        │
    │   - products.processed  │
    │   - prices.raw          │
    │   - stores.new          │
    │   - geocoding.request   │
    │   - matching.request    │
    └────────────┬────────────┘
                 │
    ┌────────────┴──────────────────────────────────────────┐
    │                                                        │
┌───▼──────────┐  ┌──────────────┐  ┌────────────────────┐ │
│ Import       │  │ Product      │  │ Price              │ │
│ Service      │  │ Processor    │  │ Processor          │ │
│ (Go)         │  │ (Go)         │  │ (Go)               │ │
│              │  │              │  │                    │ │
│ Instances:   │  │ Instances:   │  │ Instances:         │ │
│ 0-5 (auto)   │  │ 0-10 (auto)  │  │ 0-10 (auto)        │ │
└──────────────┘  └──────────────┘  └────────────────────┘ │
                                                            │
┌──────────────┐  ┌──────────────┐  ┌────────────────────┐ │
│ Store        │  │ Geocoding    │  │ Product            │ │
│ Processor    │  │ Service      │  │ Matching           │ │
│ (Go)         │  │ (Go)         │  │ (Python + AI)      │ │
│              │  │              │  │                    │ │
│ Instances:   │  │ Instances:   │  │ Instances:         │ │
│ 0-3 (auto)   │  │ 0-2 (auto)   │  │ 0-3 (auto)         │ │
└──────────────┘  └──────────────┘  └────────────────────┘ │
                                                            │
         ┌──────────────────────────────────────────────────┘
         │
    ┌────▼─────────────────────────────────┐
    │   Shared Services (Always On)        │
    │   - Redis (Cache)                    │
    │   - PostgreSQL (DB)                  │
    │   - Prometheus (Monitoring)          │
    └──────────────────────────────────────┘
```

---

## 🚀 Auto-Scaling עם Kubernetes (K8s)

### למה Kubernetes?

✅ **Auto-scaling מובנה** - HPA (Horizontal Pod Autoscaler)
✅ **Load Balancing** - Service mesh מובנה
✅ **Self-healing** - אם container נופל, K8s מעלה חדש
✅ **Resource limits** - מגביל CPU/Memory לכל service
✅ **Zero-downtime deployments** - Rolling updates

### דוגמה: Product Processor עם Auto-scaling

```yaml
# k8s/product-processor-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: product-processor
spec:
  replicas: 2  # מינימום 2 instances (HA)
  selector:
    matchLabels:
      app: product-processor
  template:
    metadata:
      labels:
        app: product-processor
    spec:
      containers:
      - name: product-processor
        image: gogobe/product-processor:latest
        resources:
          requests:
            cpu: 100m      # מינימום 0.1 CPU
            memory: 128Mi  # מינימום 128MB RAM
          limits:
            cpu: 500m      # מקסימום 0.5 CPU
            memory: 512Mi  # מקסימום 512MB RAM
        env:
        - name: KAFKA_BROKERS
          value: "kafka:9092"
        - name: REDIS_HOST
          value: "redis:6379"
        - name: DB_HOST
          value: "postgres:5432"

---
# Auto-scaling configuration
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: product-processor-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: product-processor
  minReplicas: 0    # 🔥 אפס instances כש-idle!
  maxReplicas: 10   # מקסימום 10 instances בעומס
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70  # Scale up כש-CPU > 70%
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80  # Scale up כש-Memory > 80%
  - type: Pods
    pods:
      metric:
        name: kafka_consumer_lag  # Scale up כשיש lag ב-Kafka
      target:
        type: AverageValue
        averageValue: "100"  # Scale up אם יש יותר מ-100 messages ב-queue
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300  # המתן 5 דקות לפני scale down
      policies:
      - type: Percent
        value: 50
        periodSeconds: 60  # Scale down עד 50% כל דקה
    scaleUp:
      stabilizationWindowSeconds: 0  # Scale up מיידי!
      policies:
      - type: Percent
        value: 100
        periodSeconds: 15  # Scale up עד 100% כל 15 שניות
```

### איך זה עובד?

```
┌─────────────────────────────────────────────────────────────┐
│ Scenario 1: אין עבודה (Idle)                                │
├─────────────────────────────────────────────────────────────┤
│ Kafka Queue: 0 messages                                     │
│ CPU Usage: 0%                                               │
│ → HPA: Scale down to 0 replicas                            │
│ → CPU Usage: 0% (אפס instances = אפס CPU!)                 │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Scenario 2: ייבוא קטן (100 מוצרים)                         │
├─────────────────────────────────────────────────────────────┤
│ Kafka Queue: 100 messages                                   │
│ → HPA: Scale up to 1 replica                               │
│ → Instance processes 100 messages in ~10 seconds           │
│ → Kafka Queue: 0 messages                                  │
│ → HPA: Wait 5 minutes, then scale down to 0                │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Scenario 3: ייבוא ענק (100,000 מוצרים)                     │
├─────────────────────────────────────────────────────────────┤
│ Kafka Queue: 100,000 messages                               │
│ → HPA: Scale up to 10 replicas (max)                       │
│ → Each instance processes 10,000 messages                  │
│ → Total time: ~40 seconds                                  │
│ → Kafka Queue: 0 messages                                  │
│ → HPA: Scale down gradually: 10→5→2→0                      │
└─────────────────────────────────────────────────────────────┘
```

---

## ⚖️ Load Balancing - מספר אסטרטגיות

### 1. **Kafka Consumer Groups** (מומלץ!)

```go
// product_processor.go
func main() {
    // כל instance מצטרף לאותו Consumer Group
    consumer := kafka.NewConsumer(&kafka.ConfigMap{
        "bootstrap.servers": "kafka:9092",
        "group.id":          "product-processor-group",  // ✅ אותו group!
        "auto.offset.reset": "earliest",
    })
    
    // Kafka מחלק את ה-partitions בין ה-instances אוטומטית!
    consumer.Subscribe("products.raw", nil)
    
    for {
        msg, _ := consumer.ReadMessage(-1)
        processProduct(msg)
    }
}
```

**איך זה עובד?**

```
Kafka Topic: products.raw (4 partitions)
├─ Partition 0: 25,000 messages
├─ Partition 1: 25,000 messages
├─ Partition 2: 25,000 messages
└─ Partition 3: 25,000 messages

Consumer Group: product-processor-group
├─ Instance 1: reads Partition 0 (25,000 messages)
├─ Instance 2: reads Partition 1 (25,000 messages)
├─ Instance 3: reads Partition 2 (25,000 messages)
└─ Instance 4: reads Partition 3 (25,000 messages)

✅ Load balanced אוטומטית!
✅ אם instance נופל, Kafka מחלק מחדש
```

### 2. **Kubernetes Service** (HTTP Load Balancing)

```yaml
# k8s/product-processor-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: product-processor
spec:
  selector:
    app: product-processor
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 8080
  type: ClusterIP  # Internal load balancer
  sessionAffinity: None  # Round-robin
```

**איך זה עובד?**

```
Client Request → K8s Service → Round-robin:
                                ├─ Instance 1
                                ├─ Instance 2
                                ├─ Instance 3
                                └─ Instance 4
```

### 3. **NATS JetStream** (חלופה ל-Kafka)

```go
// עם NATS - פשוט יותר מ-Kafka!
nc, _ := nats.Connect("nats://nats:4222")
js, _ := nc.JetStream()

// Queue Group - load balancing אוטומטי
js.QueueSubscribe("products.raw", "processors", func(msg *nats.Msg) {
    processProduct(msg.Data)
    msg.Ack()
})
```

**יתרונות NATS:**
- ✅ פשוט יותר מ-Kafka
- ✅ צריכת משאבים נמוכה יותר
- ✅ Load balancing מובנה
- ✅ מתאים למערכות קטנות-בינוניות

---

## 💤 חיסכון ב-CPU כש-Idle

### אסטרטגיה 1: **Scale to Zero** (Kubernetes + KEDA)

```yaml
# k8s/keda-scaledobject.yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: product-processor-scaler
spec:
  scaleTargetRef:
    name: product-processor
  minReplicaCount: 0   # 🔥 Scale to zero!
  maxReplicaCount: 10
  pollingInterval: 10  # בדיקה כל 10 שניות
  cooldownPeriod: 300  # המתנה 5 דקות לפני scale down
  triggers:
  - type: kafka
    metadata:
      bootstrapServers: kafka:9092
      consumerGroup: product-processor-group
      topic: products.raw
      lagThreshold: "10"  # Scale up אם יש יותר מ-10 messages
```

**תוצאה:**
- ✅ אין messages ב-Kafka → 0 instances → **0% CPU!**
- ✅ יש messages → KEDA מעלה instance תוך 5 שניות
- ✅ גמר לעבד → המתנה 5 דקות → scale down ל-0

### אסטרטגיה 2: **Serverless Functions** (AWS Lambda / Google Cloud Functions)

```python
# lambda/product_processor.py
import json

def lambda_handler(event, context):
    """
    נקרא רק כשיש message ב-Kafka/SQS
    CPU: 0% כש-idle!
    """
    for record in event['Records']:
        product = json.loads(record['body'])
        process_product(product)
    
    return {'statusCode': 200}
```

**יתרונות:**
- ✅ **אפס CPU כש-idle** - משלם רק על זמן ריצה
- ✅ **Auto-scaling אוטומטי** - עד מיליוני invocations
- ✅ **אפס ניהול תשתית**

**חסרונות:**
- ❌ Cold start (עיכוב של 1-3 שניות)
- ❌ מוגבל בזמן ריצה (15 דקות ב-Lambda)
- ❌ עלות גבוהה בנפחים גדולים

### אסטרטגיה 3: **Event-Driven Architecture** (מומלץ!)

```go
// עיצוב חכם: השירות "ישן" עד שיש event
func main() {
    consumer := kafka.NewConsumer(...)
    
    for {
        // ReadMessage חוסם עד שיש message
        // CPU: ~0% כשאין messages!
        msg, err := consumer.ReadMessage(-1)
        
        if err != nil {
            continue
        }
        
        // רק כשיש message - CPU עולה
        processProduct(msg)
    }
}
```

**תוצאה:**
- ✅ השירות רץ אבל לא צורך CPU (blocking I/O)
- ✅ כשיש event - מתעורר מיידית
- ✅ אין cold start

---

## 🔧 המלצות טכנולוגיות

### Message Broker: Kafka vs NATS vs RabbitMQ

| תכונה | Kafka | NATS JetStream | RabbitMQ |
|-------|-------|----------------|----------|
| **Throughput** | 1M+ msg/sec | 500K msg/sec | 50K msg/sec |
| **Latency** | 5-10ms | 1-5ms | 10-20ms |
| **Persistence** | כן | כן | כן |
| **Complexity** | גבוה | נמוך | בינוני |
| **CPU Idle** | בינוני | **נמוך** ✅ | בינוני |
| **Memory** | גבוה (2GB+) | **נמוך (100MB)** ✅ | בינוני |
| **Scale to Zero** | לא | **כן** ✅ | לא |

**המלצה:**
- 🏆 **NATS JetStream** - מתאים ל-Gogobe (פשוט, מהיר, חסכוני)
- 🥈 **Kafka** - אם צפוי נפח ענק (מיליוני messages ביום)

### Orchestration: Kubernetes vs Docker Swarm vs Nomad

| תכונה | Kubernetes | Docker Swarm | Nomad |
|-------|-----------|--------------|-------|
| **Auto-scaling** | ✅ מצוין | ⚠️ בסיסי | ✅ טוב |
| **Load Balancing** | ✅ מובנה | ✅ מובנה | ✅ מובנה |
| **Scale to Zero** | ✅ (עם KEDA) | ❌ | ✅ |
| **Complexity** | גבוה | **נמוך** ✅ | בינוני |
| **Community** | ענק | קטן | בינוני |
| **CPU Idle** | בינוני | **נמוך** ✅ | נמוך |

**המלצה:**
- 🏆 **Kubernetes + KEDA** - אם יש ניסיון/תקציב
- 🥈 **Docker Swarm** - אם רוצים פשטות (מתאים להתחלה)

---

## 📦 Docker Compose עם Auto-scaling (פשוט!)

```yaml
# docker-compose.yml
version: '3.8'

services:
  # Message Broker - NATS (קל ומהיר)
  nats:
    image: nats:latest
    command: "-js -m 8222"  # JetStream enabled
    ports:
      - "4222:4222"  # Client
      - "8222:8222"  # Monitoring
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 256M

  # Redis Cache
  redis:
    image: redis:7-alpine
    command: redis-server --maxmemory 1gb --maxmemory-policy allkeys-lru
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 1G

  # PostgreSQL
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: gogobe
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G

  # API Gateway (Always on - 1 instance)
  api-gateway:
    build: ./backend/api
    ports:
      - "8000:8000"
    environment:
      NATS_URL: nats://nats:4222
      REDIS_URL: redis://redis:6379
      DB_URL: postgresql://postgres:${DB_PASSWORD}@postgres:5432/gogobe
    deploy:
      replicas: 1
      resources:
        limits:
          cpus: '1'
          memory: 512M

  # Import Service (Auto-scale: 0-5)
  import-service:
    build: ./services/import-service
    environment:
      NATS_URL: nats://nats:4222
    deploy:
      replicas: 0  # Start with 0
      resources:
        limits:
          cpus: '0.5'
          memory: 256M

  # Product Processor (Auto-scale: 0-10)
  product-processor:
    build: ./services/product-processor
    environment:
      NATS_URL: nats://nats:4222
      REDIS_URL: redis://redis:6379
      DB_URL: postgresql://postgres:${DB_PASSWORD}@postgres:5432/gogobe
    deploy:
      replicas: 0  # Start with 0
      resources:
        limits:
          cpus: '0.5'
          memory: 512M

  # Price Processor (Auto-scale: 0-10)
  price-processor:
    build: ./services/price-processor
    environment:
      NATS_URL: nats://nats:4222
      REDIS_URL: redis://redis:6379
      DB_URL: postgresql://postgres:${DB_PASSWORD}@postgres:5432/gogobe
    deploy:
      replicas: 0  # Start with 0
      resources:
        limits:
          cpus: '0.5'
          memory: 512M

  # Geocoding Service (Auto-scale: 0-2)
  geocoding-service:
    build: ./services/geocoding-service
    environment:
      NATS_URL: nats://nats:4222
      DB_URL: postgresql://postgres:${DB_PASSWORD}@postgres:5432/gogobe
    deploy:
      replicas: 0  # Start with 0
      resources:
        limits:
          cpus: '0.25'
          memory: 128M

  # Auto-scaler (ניטור ו-scaling)
  autoscaler:
    image: gogobe/autoscaler:latest
    environment:
      NATS_URL: nats://nats:4222
      DOCKER_HOST: unix:///var/run/docker.sock
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    deploy:
      replicas: 1
      resources:
        limits:
          cpus: '0.1'
          memory: 64M
```

### Auto-scaler Script (Go)

```go
// autoscaler/main.go
package main

import (
    "github.com/nats-io/nats.go"
    "github.com/docker/docker/client"
)

func main() {
    nc, _ := nats.Connect("nats://nats:4222")
    js, _ := nc.JetStream()
    docker, _ := client.NewClientWithOpts()
    
    // ניטור כל 10 שניות
    ticker := time.NewTicker(10 * time.Second)
    
    for range ticker.C {
        // בדיקת queue depth
        info, _ := js.StreamInfo("products")
        queueDepth := info.State.Msgs
        
        // חישוב instances נדרשים
        desiredReplicas := calculateReplicas(queueDepth)
        
        // Scale up/down
        scaleService(docker, "product-processor", desiredReplicas)
    }
}

func calculateReplicas(queueDepth uint64) int {
    if queueDepth == 0 {
        return 0  // Scale to zero!
    } else if queueDepth < 100 {
        return 1
    } else if queueDepth < 1000 {
        return 2
    } else if queueDepth < 10000 {
        return 5
    } else {
        return 10  // Max
    }
}
```

---

## 🎯 תכנית יישום מומלצת

### Phase 1: תשתית בסיסית (שבוע 1-2)

```bash
# 1. הוספת NATS + Redis
docker-compose up -d nats redis

# 2. בדיקה
curl http://localhost:8222/varz  # NATS monitoring
redis-cli ping  # Redis health
```

### Phase 2: שירות ראשון - Import Service (שבוע 3-4)

```bash
# 1. פיתוח Import Service (Go)
cd services/import-service
go build -o import-service

# 2. Dockerfile
docker build -t gogobe/import-service:latest .

# 3. הרצה
docker-compose up -d import-service
```

### Phase 3: Auto-scaling (שבוע 5)

```bash
# 1. פיתוח Autoscaler
cd autoscaler
go build -o autoscaler

# 2. הרצה
docker-compose up -d autoscaler

# 3. בדיקה
# שלח 1000 messages → צפה ל-scaling up
# המתן 5 דקות → צפה ל-scaling down
```

### Phase 4: שאר השירותים (שבוע 6-10)

```bash
# Product Processor
docker-compose up -d product-processor

# Price Processor
docker-compose up -d price-processor

# Geocoding Service
docker-compose up -d geocoding-service
```

---

## 📊 ניטור וצפייה

### Prometheus + Grafana

```yaml
# docker-compose.yml (המשך)
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      GF_SECURITY_ADMIN_PASSWORD: admin
```

### דשבורד מומלץ

```
┌─────────────────────────────────────────────────────────────┐
│ Gogobe System Dashboard                                     │
├─────────────────────────────────────────────────────────────┤
│ Queue Depth:                                                │
│   products.raw:    0 messages     [████░░░░░░] 40%         │
│   prices.raw:      1,234 messages [████████░░] 80%         │
│   stores.new:      0 messages     [░░░░░░░░░░] 0%          │
│                                                             │
│ Active Instances:                                           │
│   import-service:      0/5  (idle)                         │
│   product-processor:   2/10 (active)                       │
│   price-processor:     5/10 (busy)                         │
│   geocoding-service:   0/2  (idle)                         │
│                                                             │
│ CPU Usage:                                                  │
│   Total: 2.5 cores / 8 cores (31%)                         │
│                                                             │
│ Memory Usage:                                               │
│   Total: 3.2 GB / 16 GB (20%)                              │
└─────────────────────────────────────────────────────────────┘
```

---

## ✅ סיכום המלצות

### שירותים מומלצים (סדר עדיפויות)

1. ✅ **API Gateway** (Python/FastAPI) - תמיד רץ
2. ✅ **Import Service** (Go) - Auto-scale 0-5
3. ✅ **Product Processor** (Go) - Auto-scale 0-10
4. ✅ **Price Processor** (Go) - Auto-scale 0-10
5. ✅ **Store Processor** (Go) - Auto-scale 0-3
6. ✅ **Geocoding Service** (Go) - Auto-scale 0-2
7. ⚠️ **Product Matching** (Python+AI) - Auto-scale 0-3 (שלב 2)
8. ⚠️ **Analytics Service** (Python) - Auto-scale 0-2 (שלב 3)

### טכנולוגיות מומלצות

- 🏆 **Message Broker:** NATS JetStream (פשוט, מהיר, חסכוני)
- 🏆 **Cache:** Redis (מהיר, פשוט)
- 🏆 **Orchestration:** Docker Swarm (התחלה) → Kubernetes (ייצור)
- 🏆 **Monitoring:** Prometheus + Grafana
- 🏆 **Languages:** Go (ביצועים) + Python (AI/API)

### חיסכון ב-CPU

- ✅ **Scale to Zero** - 0 instances כש-idle = 0% CPU
- ✅ **Event-Driven** - שירותים "ישנים" עד שיש event
- ✅ **Resource Limits** - מגביל CPU/Memory לכל service
- ✅ **Efficient Code** - Go במקום Python לשירותים קריטיים

---

**מוכן להתחיל?** 🚀

**צעד ראשון:** בחר אם להתחיל עם Docker Swarm (פשוט) או Kubernetes (מתקדם)
