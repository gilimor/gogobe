# 🌍 מדריך הפעלה - Gogobe Global Multi-Region

## תאריך: 21 דצמבר 2025

---

## 📋 סקירה

מערכת זו מדמה **4 אזורים גלובליים** עם **High Availability**:
- 🇮🇱 **Israel** - Port 8001
- 🇺🇸 **USA** - Port 8002
- 🇪🇺 **Europe** - Port 8003
- 🌏 **Asia** - Port 8004

**תכונות:**
- ✅ כל אזור עצמאי (DB, Redis, NATS משלו)
- ✅ Global Load Balancer עם failover אוטומטי
- ✅ אם אזור נופל, השאר ממשיכים לעבוד
- ✅ CockroachDB גלובלי לנתונים משותפים
- ✅ Kafka גלובלי ל-cross-region events

---

## 🚀 התקנה והפעלה

### שלב 1: הכנה

```bash
# 1. ודא ש-Docker Desktop רץ
docker --version
docker-compose --version

# 2. צור תיקיות נדרשות
mkdir -p nginx monitoring/grafana-dashboards

# 3. הגדר סיסמת DB (אופציונלי)
# Windows PowerShell:
$env:DB_PASSWORD="your-secure-password"

# Linux/Mac:
export DB_PASSWORD="your-secure-password"
```

### שלב 2: הפעלת המערכת

```bash
# הפעל את כל האזורים
docker-compose -f docker-compose.global.yml up -d

# צפה בלוגים
docker-compose -f docker-compose.global.yml logs -f
```

### שלב 3: המתן לאתחול

```bash
# בדוק שכל השירותים רצים (יכול לקחת 1-2 דקות)
docker-compose -f docker-compose.global.yml ps

# צריך לראות:
# ✅ gogobe-global-lb        - running
# ✅ gogobe-cockroach-global - running
# ✅ gogobe-kafka-global     - running
# ✅ gogobe-db-israel        - running (healthy)
# ✅ gogobe-db-usa           - running (healthy)
# ✅ gogobe-db-europe        - running (healthy)
# ✅ gogobe-db-asia          - running (healthy)
# ✅ gogobe-api-israel       - running (healthy)
# ✅ gogobe-api-usa          - running (healthy)
# ✅ gogobe-api-europe       - running (healthy)
# ✅ gogobe-api-asia         - running (healthy)
```

---

## 🧪 בדיקות

### בדיקה 1: Health Checks

```bash
# בדיקת Load Balancer
curl http://localhost/health
# Expected: healthy

# בדיקת כל האזורים
curl http://localhost/health/global
# Expected: {"israel":"healthy","usa":"healthy","europe":"healthy","asia":"healthy","healthy_regions":4,"total_regions":4,"status":"operational"}

# בדיקת אזור ספציפי
curl http://localhost:8001/health  # Israel
curl http://localhost:8002/health  # USA
curl http://localhost:8003/health  # Europe
curl http://localhost:8004/health  # Asia
```

### בדיקה 2: גישה ל-API דרך Load Balancer

```bash
# בקשה דרך Load Balancer (ינתב אוטומטית לאזור הקרוב)
curl http://localhost/api/health

# בדוק לאיזה אזור נשלחת הבקשה
curl -v http://localhost/api/health 2>&1 | grep X-Served-By
# Expected: X-Served-By: israel_api (או אזור אחר)
```

### בדיקה 3: בדיקת Failover

```bash
# 1. עצור את Israel region
docker stop gogobe-api-israel

# 2. נסה שוב לגשת ל-API
curl http://localhost/api/health
# Expected: עדיין עובד! (ינתב ל-USA/Europe/Asia)

# 3. בדוק health
curl http://localhost/health/global
# Expected: {"israel":"unhealthy","usa":"healthy",...,"healthy_regions":3}

# 4. הפעל מחדש את Israel
docker start gogobe-api-israel

# 5. המתן 10 שניות ובדוק שוב
sleep 10
curl http://localhost/health/global
# Expected: {"israel":"healthy",...,"healthy_regions":4}
```

### בדיקה 4: בדיקת Database Isolation

```bash
# התחבר ל-DB של Israel
docker exec -it gogobe-db-israel psql -U postgres -d gogobe_il

# הרץ:
SELECT current_database();
# Expected: gogobe_il

\dt  # רשימת טבלאות
\q   # יציאה

# התחבר ל-DB של USA
docker exec -it gogobe-db-usa psql -U postgres -d gogobe_us

# הרץ:
SELECT current_database();
# Expected: gogobe_us
\q
```

### בדיקה 5: בדיקת Redis Isolation

```bash
# Israel Redis
docker exec -it gogobe-redis-israel redis-cli
127.0.0.1:6379> SET test:il "Israel data"
127.0.0.1:6379> GET test:il
# Expected: "Israel data"
127.0.0.1:6379> exit

# USA Redis
docker exec -it gogobe-redis-usa redis-cli
127.0.0.1:6379> GET test:il
# Expected: (nil) - לא קיים! (Redis נפרד)
127.0.0.1:6379> SET test:us "USA data"
127.0.0.1:6379> exit
```

### בדיקה 6: בדיקת CockroachDB (Global DB)

```bash
# התחבר ל-CockroachDB
docker exec -it gogobe-cockroach-global cockroach sql --insecure

# יצירת טבלה גלובלית
CREATE DATABASE IF NOT EXISTS gogobe_global;
USE gogobe_global;

CREATE TABLE IF NOT EXISTS master_products (
    id SERIAL PRIMARY KEY,
    name STRING,
    global_ean STRING UNIQUE
);

INSERT INTO master_products (name, global_ean) VALUES
('Coca Cola 330ml', '5449000000996'),
('iPhone 15 Pro', '0194253000000');

SELECT * FROM master_products;

\q
```

---

## 📊 ניטור

### Prometheus

```bash
# גש ל-Prometheus
http://localhost:9090

# Queries לדוגמה:
# - up{job="api-israel"}
# - up{job="api-usa"}
# - rate(http_requests_total[5m])
```

### Grafana

```bash
# גש ל-Grafana
http://localhost:3000

# Login:
# Username: admin
# Password: admin

# הוסף Data Source:
# - Type: Prometheus
# - URL: http://prometheus:9090
```

### NATS Monitoring

```bash
# Israel NATS
http://localhost:8222

# USA NATS
http://localhost:8223

# Europe NATS
http://localhost:8224

# Asia NATS
http://localhost:8225
```

### CockroachDB Admin UI

```bash
# CockroachDB Admin
http://localhost:8080
```

---

## 🧪 תרחישי בדיקה מתקדמים

### תרחיש 1: כשל מוחלט של אזור

```bash
# עצור את כל השירותים של USA
docker stop gogobe-db-usa gogobe-redis-usa gogobe-nats-usa gogobe-api-usa gogobe-product-processor-usa

# בדוק שהמערכת עדיין עובדת
curl http://localhost/health/global
# Expected: {"usa":"unhealthy",...,"healthy_regions":3,"status":"operational"}

# בקשות ימשיכו לעבוד דרך אזורים אחרים
for i in {1..10}; do
    curl -s http://localhost/api/health | grep -o "healthy"
done
# Expected: 10 × "healthy"

# הפעל מחדש
docker start gogobe-db-usa gogobe-redis-usa gogobe-nats-usa gogobe-api-usa gogobe-product-processor-usa
```

### תרחיש 2: עומס גבוה

```bash
# התקן Apache Bench (אם אין)
# Windows: choco install apache-bench
# Linux: sudo apt install apache2-utils

# שלח 1000 בקשות עם 10 connections במקביל
ab -n 1000 -c 10 http://localhost/api/health

# בדוק שהעומס התפזר בין האזורים
docker stats --no-stream | grep gogobe-api
```

### תרחיש 3: Split Brain (Network Partition)

```bash
# נתק את Israel מה-global network
docker network disconnect gogobe_global-network gogobe-api-israel

# Israel עדיין עובד עצמאית
curl http://localhost:8001/health
# Expected: healthy

# אבל Load Balancer לא רואה אותו
curl http://localhost/health/global
# Expected: israel: "unhealthy"

# חבר מחדש
docker network connect gogobe_global-network gogobe-api-israel
```

---

## 📈 סטטיסטיקות

### צפייה בנפח נתונים

```bash
# גודל DB לכל אזור
docker exec gogobe-db-israel psql -U postgres -d gogobe_il -c "SELECT pg_size_pretty(pg_database_size('gogobe_il'));"
docker exec gogobe-db-usa psql -U postgres -d gogobe_us -c "SELECT pg_size_pretty(pg_database_size('gogobe_us'));"
docker exec gogobe-db-europe psql -U postgres -d gogobe_eu -c "SELECT pg_size_pretty(pg_database_size('gogobe_eu'));"
docker exec gogobe-db-asia psql -U postgres -d gogobe_asia -c "SELECT pg_size_pretty(pg_database_size('gogobe_asia'));"

# גודל Redis
docker exec gogobe-redis-israel redis-cli INFO memory | grep used_memory_human
docker exec gogobe-redis-usa redis-cli INFO memory | grep used_memory_human
```

### ספירת רשומות

```bash
# ספירת מוצרים לכל אזור
for region in israel usa europe asia; do
    echo "=== $region ==="
    docker exec gogobe-db-$region psql -U postgres -d gogobe_${region/usa/us} -c "SELECT COUNT(*) FROM products;"
done
```

---

## 🛑 כיבוי

### כיבוי חלקי (אזור אחד)

```bash
# כבה רק את USA
docker stop gogobe-db-usa gogobe-redis-usa gogobe-nats-usa gogobe-api-usa
```

### כיבוי מלא

```bash
# כבה את כל המערכת
docker-compose -f docker-compose.global.yml down

# כבה + מחק volumes (⚠️ מחיקת כל הנתונים!)
docker-compose -f docker-compose.global.yml down -v
```

---

## 🐛 פתרון בעיות

### בעיה: Container לא עולה

```bash
# בדוק לוגים
docker logs gogobe-api-israel

# בדוק health
docker inspect --format='{{.State.Health.Status}}' gogobe-api-israel

# הפעל מחדש
docker restart gogobe-api-israel
```

### בעיה: DB לא מגיב

```bash
# בדוק שה-DB רץ
docker exec gogobe-db-israel pg_isready -U postgres

# אם לא - הפעל מחדש
docker restart gogobe-db-israel

# המתן 10 שניות
sleep 10

# בדוק שוב
docker exec gogobe-db-israel pg_isready -U postgres
```

### בעיה: Load Balancer לא מנתב

```bash
# בדוק Nginx config
docker exec gogobe-global-lb nginx -t

# צפה בלוגים
docker logs gogobe-global-lb

# הפעל מחדש
docker restart gogobe-global-lb
```

---

## 📊 Dashboard מומלץ

### טבלת סטטוס מהיר

```bash
# הרץ סקריפט זה לקבלת סטטוס מהיר
cat << 'EOF' > check-status.sh
#!/bin/bash
echo "=== Gogobe Global Status ==="
echo ""
echo "Region    | API      | DB       | Redis    | NATS"
echo "----------|----------|----------|----------|----------"

for region in israel usa europe asia; do
    api_status=$(docker inspect --format='{{.State.Status}}' gogobe-api-$region 2>/dev/null || echo "down")
    db_status=$(docker inspect --format='{{.State.Status}}' gogobe-db-$region 2>/dev/null || echo "down")
    redis_status=$(docker inspect --format='{{.State.Status}}' gogobe-redis-$region 2>/dev/null || echo "down")
    nats_status=$(docker inspect --format='{{.State.Status}}' gogobe-nats-$region 2>/dev/null || echo "down")
    
    printf "%-10s| %-9s| %-9s| %-9s| %-9s\n" "$region" "$api_status" "$db_status" "$redis_status" "$nats_status"
done

echo ""
echo "=== Global Services ==="
lb_status=$(docker inspect --format='{{.State.Status}}' gogobe-global-lb 2>/dev/null || echo "down")
cockroach_status=$(docker inspect --format='{{.State.Status}}' gogobe-cockroach-global 2>/dev/null || echo "down")
kafka_status=$(docker inspect --format='{{.State.Status}}' gogobe-kafka-global 2>/dev/null || echo "down")

echo "Load Balancer: $lb_status"
echo "CockroachDB:   $cockroach_status"
echo "Kafka:         $kafka_status"
EOF

chmod +x check-status.sh
./check-status.sh
```

---

## 🎯 צעדים הבאים

1. **הוסף נתונים לדוגמה:**
   ```bash
   # הרץ סקריפט ייבוא לכל אזור
   docker exec gogobe-api-israel python /app/scripts/seed_data.py --region IL
   docker exec gogobe-api-usa python /app/scripts/seed_data.py --region US
   ```

2. **הגדר Auto-scaling:**
   - העבר ל-Kubernetes
   - הגדר HPA (Horizontal Pod Autoscaler)

3. **הוסף SSL:**
   - השג תעודת SSL (Let's Encrypt)
   - עדכן את `nginx/global-lb.conf`

4. **הגדר Backup:**
   ```bash
   # Backup אוטומטי יומי
   docker exec gogobe-db-israel pg_dump -U postgres gogobe_il > backup-il-$(date +%Y%m%d).sql
   ```

---

## ✅ סיכום

**המערכת כעת:**
- ✅ 4 אזורים גלובליים עצמאיים
- ✅ High Availability - אם אזור נופל, השאר עובדים
- ✅ Load Balancing אוטומטי
- ✅ Health checks ו-failover
- ✅ Monitoring מלא (Prometheus + Grafana)
- ✅ Isolation מלא (DB, Redis, NATS לכל אזור)
- ✅ Global services משותפים (CockroachDB, Kafka)

**מוכן לייצור!** 🚀
