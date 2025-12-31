
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased] - 2025-12-28

### 🚀 Dynamic Categories & Frontend 2.6
- **Architecture:**
    - Developed `AutoCategorizer` service to automatically classify products into a hierarchical tree.
    - Added I18N support (`name_en`) to categories.
    - Implemented `/api/categories` endpoint with Redis caching.
- **Frontend Overhaul (`products.html`):**
    - Redesigned with Tailwind CSS (Glassmorphism).
    - Implemented dynamic category filtering served from DB.
    - Fixed API integration bugs (URL/Query mismatch).

### 🐛 Fixes
- **API/Frontend Mismatch:** Fixed the critical bug where `products.html` crashed because it expected an array but got an object.
- **Database integrity:** Resolved `slug` constraint errors during categorization.

### 🚀 Operations & Backfill (Phase 3)
- **Master Data Hub:** Delived `master_products.html` and `operations.html` dashboards.
- **Backfill Engine:** Successfully linked 60,000+ orphan products to Master Products using a new Strict Mode algorithm.
- **Price History:** Added visual charts to product cards showing price trends over 90 days.
- **Quality Control:** Implemented logic to detect and dissolve "False Positive" clusters (Over-Clustering).
- **Data Integrity:** Ran a massive sync query to update 25,000+ products where `master_product_id` was NULL despite valid links.
- **Global Purification:** Identified and successfully dissolved 58 "Mixed Clusters" (Master Products containing multiple EANs), ensuring 1-to-1 accuracy for 145 affected products.
- **Dashboard Upgrade:** Overhauled `master_products.html` with working Search, Sortable Headers, and Dynamic Pagination.
- **Store Names:** Fixed generic "Branch X" names for King Store (27 branches) by mapping them to their actual cities (e.g., "King Store - Nazareth").
- **Documentation:** Added "Generic Store Names" lesson to `LESSONS_LEARNED.md` and documented the Data Enrichment strategy.
- **Frontend Fix:** Fixed `products.html` crash due to undefined variable `activeMasterId`.

## [Unreleased] - 2025-12-27

### 🚀 Global Integration & UX Revolution
- **New Markets:**
    - **Tokyo (Japan):** Integration with Toyosu Market (Fish/Veg).
    - **Spain:** Integration with National Fuel Geoportal.
- **Map Performance (V2):**
    - Implemented `Leaflet.markercluster` to handle 40k+ points without crashing.
    - Created lightweight `/api/stores/geo` endpoint.
- **Search Engine (V2):**
    - Implemented `GIN Index` (pg_trgm) for instant text search.
    - Optimized Two-Step Fetch strategy (IDs first, then Prices).
- **UX:** 
    - Simplified Map markers (Heatmap logic: Green=Cheap, Red=Expensive).

## [Unreleased] - 2025-12-26

### 🚀 Performance & Scale ("Jet Plane" Mode)
- **Implemented Parallel Processing Swarm:**
    - Configured Kafka topic `gogobe.import.downloaded` with **4 partitions** to allow multiple consumers to process simultaneously.
    - Scaled `parser` service to **2 replicas** (extensible to 4+), enabling concurrent file processing.
    - Achieved throughput of **~380 prices/second per worker** (approx. 45,000 prices/minute combined).
- **Docker Optimization (Fast Boot):**
    - Refactored `parser` and `carrier` services to reuse the base `gogobe-api:patched` image instead of building from scratch.
    - Implemented **runtime dependency installation** (`pip install kafka-python`) in the container command for sub-2-second startup times.
- **Resource Management:**
    - Implemented **auto-deletion** of processed files (both `.gz` source and decompressed XML) to prevent disk saturation.
    - Implemented **Streaming XML Parsing** (`ET.iterparse`) for Shufersal, drastically reducing memory footprint for large files.

### 🐛 Fixes
- **Shufersal Scraper:**
    - Resolved critical `AbstractMethodError` by restoring the correct `parse_file` signature.
    - Fixed XML namespace handling in the streaming parser.
- **Microservices Stability:**
    - Fixed module import issues in Kafka services.
    - Ensured `Scout` -> `Carrier` -> `Parser` pipeline flows correctly for all chains.

### 📊 Visibility
- **Dashboard Upgrade:** Added `prices_added` metric to the live "Kafka Swarm" log ticker, giving immediate feedback on actual import value.
- **Status API:** Updated `/api/kafka/status` to expose price counts.

## [Unreleased] - 2025-12-25

### 🚀 Architecture V2 (Kafka)
- **Added `zookeeper` and `kafka` services** to `docker-compose.yml`.
- **Created `backend/kafka_services/producer_scout.py`**: A service that scans defined scraping sources and dispatches file processing jobs to Kafka (`gogobe.import.discovered`).
- **Created `backend/kafka_services/consumer_carrier.py`**: A worker service that consumes jobs, downloads files in parallel, and reports status to the tracker.
- **Created `backend/kafka_services/consumer_parser.py`**: A worker service that decompresses, parses, and ingests content into the database.
- **Added `simulate_kafka_swarm.py`**: A proof-of-concept script verifying parallel processing capabilities.

### 🐛 Fixes
- **BaseSupermarketScraper**:
    - **CRITICAL FIX:** Added immediate `conn.commit()` after creating a new product. This resolves the `foreign key constraint` error that prevented prices from being inserted for new products during batch flushes.
    - **Optimized Batch Size:** Reduced from 10,000 to **100** to provide immediate user feedback ("Streaming Mode").
    - **Refactored `import_files`**: Implemented a "Pipeline" approach using `ThreadPoolExecutor` for parallel downloads while maintaining sequential, immediate processing of completed files.
    - **SSL Warnings:** Suppressed `urllib3` InsecureRequestWarnings for cleaner logs.

### 📝 Documentation
- **Created `PROJECT_DOCUMENTATION.md`**: Comprehensive guide covering Architecture, How-to-Run, DB Schema, and Roadmap.
- **Created `ARCHITECTURE_KAFKA_V2.md`**: Detailed design document for the new Event-Driven Architecture.
- **Updated `SESSION_SUMMARY_2025_12_25.md`**: Summary of today's work for future context.

### 🧪 Scripts
- Added `backend/scripts/debug_freshmarket_xml.py` for analyzing XML structure.
- Added `backend/scripts/debug_processing_freshmarket.py` for isolating and fixing the import bug.
