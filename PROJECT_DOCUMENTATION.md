
# 🦒 Gogobe System Documentation

## 📚 Overview
Gogobe is a multi-region supermarket price comparison engine. It ingests massive amounts of data from various retail chains, normalizes it, matches products globally using AI, and presents it to users via a modern web interface.

## 🏗️ Architecture

### 1. The Core (Monolith V1 -> Microservices V2)
*   **Backend:** Python (FastAPI/Django)
*   **Database:** PostgreSQL (with PostGIS for geolocation) + CockroachDB (Global)
*   **Cache:** Redis
*   **Queue:** Apache Kafka (V2 Architecture)

### 2. The Import System (`backend/scrapers`)
The heart of the system. It runs in two modes:
*   **Legacy Parallel:** `import_all_sources_parallel.py` - Uses multiprocessing to run `BaseSupermarketScraper` instances.
*   **Kafka Swarm (V2):**
    *   **Scout:** Finds files and pushes to Kafka.
    *   **Carrier:** Parallel workers that download files.
    *   **Processor:** Parallel workers that parse and ingest data.

- **Monitoring & Orchestration**: [ORCHESTRATION_AND_MONITORING.md](ORCHESTRATION_AND_MONITORING.md) (New! v2.0)

### 3. Master Product Matching (`backend/services`)
*   **Goal:** Identify that "Coca Cola 1.5L" in Shufersal is the same as in Rami Levy.
*   **Mechanism:** `MasterProductMatcher` uses:
    *   Barcode (EAN) matching (Primary).
    *   Name similarity (Levenshtein).
    *   **AI/Vector Search:** (Planned V2) for semantic matching.

### 3.5 Dynamic Taxonomy & Categorization (New! v2.6)
*   **Goal:** Automatically classify raw supermarket products into a structured, hierarchical tree with I18N support.
*   **Mechanism:** `AutoCategorizer` service:
    *   **Rule-Based Engine:** Assigns categories based on keyword matching (Hebrew names) to defined parents (Google Product Taxonomy style).
    *   **Hierarchy:** Supports 2-level depth (Vertical -> Category).
    *   **I18N:** All categories have `name_en` for future English support.
    *   **Deduplication:** Enforces unique paths (`supermarket/dairy/milk`) to prevent "Dairy" vs "Milk Products" split.

### 4. Supported Supermarkets
| Supermarket    | Type           | Scraper Module    | Status    |
| :------------- | :------------- | :---------------- | :-------- |
| Shufersal      | API            | `shufersal`       | ✅ Active |
| Rami Levy      | PublishedPrices| `rami_levy`       | ✅ Active |
| Osher Ad       | PublishedPrices| `osher_ad`        | ✅ Active |
| Fresh Market   | PublishedPrices| `fresh_market`    | ✅ Active |
| Tiv Taam       | PublishedPrices| `tiv_taam`        | ✅ Active |
| Yohananof      | PublishedPrices| `yohananof`       | ✅ Active |
| SuperPharm     | API            | `superpharm`      | ✅ Active |
| King Store     | Scraping       | `kingstore`       | ✅ Active |
| Victory        | PublishedPrices| `victory`         | ⚠️ Disabled (Auth) |

## 🛠️ Key Components & Files

### 📂 Scrapers
*   `base_supermarket_scraper.py`: The mother class. Handles downloading, unzipping, parsing (streaming), and DB insertion.
*   `superpharm_scraper.py`: Handles XML parsing for SuperPharm.
*   `osher_ad_scraper.py`: Handles Osher Ad specific logic.
*   `fresh_market_scraper.py`: Handles XML parsing for FreshMarket.
*   `published_prices_scraper.py`: Base for "Cerberus" style sites.

### 📂 Services
*   `auto_categorizer.py`: Automatic product classification service.
*   `file_processing_tracker.py`: Tracks every file's lifecycle (download -> extract -> parse -> done) in the DB.
*   `master_product_matcher.py`: The logic for deduplicating products.

### 📂 Scripts
*   `import_all_sources_parallel.py`: The daily job controller.
*   `kafka_services/simulate_kafka_swarm.py`: Validation script for V2 architecture.

## 🚀 How to Run

### Standard Import
```bash
docker-compose up -d
docker exec gogobe-api-1 python /app/backend/scripts/import_all_sources_parallel.py
```

### Kafka Swarm (Simulation)
```bash
docker-compose up -d zookeeper kafka
docker exec gogobe-api-1 pip install kafka-python
docker exec gogobe-api-1 python /app/backend/kafka_services/simulate_kafka_swarm.py
```

## 📊 Database Schema
*   `products`: Raw items from stores.
*   `prices`: Historic price data (Partitioned).
*   `master_products`: The global "Golden Record" for a product.
*   `categories`: Hierarchical category tree (id, name, name_en, parent_id).
*   `product_master_links`: The link table (products -> master_products).
*   `file_processing_log`: Audit trail of every imported file.

### 6. Frontend Ecosystem (v2.6 UPDATE)
The frontend has been unified into a single **Portal Architecture**:
*   **Entry Point**: `index.html` (The "Mega-Menu").
*   **Global Navigation**: `nav.js` injects a standardized Sticky Header into every page automatically.
*   **Apps**:
    *   **Mission Control (`dashboard.html`)**: Real-time SSE-based monitoring with Fleet Matrix.
    *   **Geo Intel (`map.html`)**: Interactive store/price mapping.
    *   **Product Catalog (`products.html`)**: 
        *   Dynamic Category Tree (served via Redis Cache).
        *   Real-time search with facet filtering.
        *   Modern Card UI (Tailwind CSS).
    *   **Data Hub**: Dedicated pages for Prices, Stores, and Sources.

### 7. Key Learnings & Optimizations
*   **API Response Structure**: Always wrap API list responses in an object (e.g., `{products: [...]}`) to allow future metadata expansion without breaking clients.
*   **Batch Deduplication**: PostgreSQL `ON CONFLICT` fails if the *input batch* contains duplicates. We implemented pre-insert deduplication in Python (`BaseSupermarketScraper`).
*   **One-Pass Daily**: To save resources, scrapers now check `FileProcessingTracker` before processing. If a store was already successfully imported today, it is skipped.
*   **Fleet Matrix Optimization**: Instead of polling status for 20 scrapers individually (20 queries/sec), we use a single `SELECT DISTINCT ON (source)` query to fetch the entire fleet status in <10ms.

### 8. System Stability & Resource Governance (v2.5)
To ensure the system runs reliably on standard hardware without freezing:
*   **Smart Governor:** The orchestration script (`import_all_sources_parallel.py`) checks CPU load (>90%) before starting heavy tasks.
*   **Concurrency Limits:** Hard limit of 3-4 parallel workers.
*   **Aggressive GC:** Scrapers force `gc.collect()` after every file to prevent RAM leaks.
*   **Auto-Resume:** The DB-based `FileProcessingTracker` ensures that if a crash occurs, we resume exactly where we left off (no duplicate work).

### 9. Backup Protocol
*   **Code Safety:** Before major automated refactoring, critical files are backed up to `backups/YYYY-MM-DD/`.
*   **Data Safety:** Raw files are kept in `data/` until processing is confirmed.
*   **Retention:** Backup folders should be rotated/deleted every 30 days (Manual maintenance or cron job).

## Roadmap (V2)
1.  **Full Decoupling:** Move `parse_file` out of the monolithic scraper into a standalone Kafka consumer.
2.  **Vector DB:** Install `pgvector` for AI matching.
3.  **Frontend:** Real-time price alerts via WebSockets.

