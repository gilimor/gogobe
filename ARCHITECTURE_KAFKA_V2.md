
# 🦒 Gogobe V2 Architecture: Kafka-Based Data Streaming pipeline

## 🏗️ Overview
To scale from handling 5 supermarket chains to **thousands**, the current "Monolithic Script" approach must be replaced by a **Distributed Event-Driven Architecture**. We will use **Apache Kafka** as the nervous system of the platform, enabling real-time streaming of massive datasets.

## 🔄 The Pipeline (Stream of Events)

### 1️⃣ Stage 1: File Discovery ("The Crawlers")
*   **Role:** Small, lightweight agents that scan websites/FTPs 24/7.
*   **Action:** When a new file is found, they don't download it. They just convert it to a "Job".
*   **Kafka Topic:** `gogobe.files.discovered`
*   **Message:**
    ```json
    { "chain": "shufersal", "url": "https://...", "timestamp": "2025-12-25T10:00:00Z" }
    ```

### 2️⃣ Stage 2: The Downloader Swarm
*   **Role:** A fleet of workers (running on cheap instances/Lambdas) that listen to `gogobe.files.discovered`.
*   **Action:** 
    1.  Download the file.
    2.  Upload to Object Storage (S3 / MinIO).
    3.  Acknowledge success.
*   **Kafka Topic:** `gogobe.files.downloaded`
*   **Message:**
    ```json
    { "chain": "shufersal", "s3_path": "s3://gogobe-raw/shufersal/price_1.gz", "local_path": "/tmp/..." }
    ```

### 3️⃣ Stage 3: The Parsing Engine (CPU Heavy)
*   **Role:** Intense processing units. Listen to `gogobe.files.downloaded`.
*   **Action:**
    1.  Pull file from S3 (or local cache).
    2.  Decompress & XML Parse (Streaming).
    3.  **Detect Master Product** (Vector Search / AI) in real-time.
    4.  Split data into small "Product Batches" (e.g., 500 items).
*   **Kafka Topic:** `gogobe.products.ingest`
*   **Message:**
    ```json
    { 
      "batch_id": "abc-123", 
      "items": [ 
         {"ean": "729...", "price": 10.90, "master_id": 501},
         {"ean": "729...", "price": 12.00, "master_id": 999}
      ] 
    }
    ```

### 4️⃣ Stage 4: High-Speed DB Writers
*   **Role:** Database gatekeepers.
*   **Action:**
    1.  Consumer batches from `gogobe.products.ingest`.
    2.  Use `COPY` command to blast data into PostgreSQL / CockroachDB.
    3.  Update Materialized Views for frontend.

---

## 🚀 Why This is Better?

1.  **Backpressure Handling:** If Shufersal uploads 1,000 files at once, the "Crawlers" find them instantly. The "Parsers" chew through them at their own pace without crashing the server.
2.  **Fault Tolerance:** If a parser crashes on File #50, the message remains in Kafka. Another parser picks it up automatically. No data loss.
3.  **Infinite Scaling:** 
    *   Need more download speed? Add 10 "Downloader" containers.
    *   Parsing is slow? Add 20 "Parser" containers.
    *   Database choking? Add a "Buffer" consumer.

## 🛠️ Migration Plan

1.  **Deploy Kafka:** `docker-compose up -d kafka zookeeper` (Already present in global compose).
2.  **Refactor Scrapers:** Break `base_supermarket_scraper.py` into 3 separate scripts (`discover.py`, `download.py`, `parse.py`).
3.  **Connect:** Use `confluent-kafka` python library to glue them together.

**Status:** Ready to design.
