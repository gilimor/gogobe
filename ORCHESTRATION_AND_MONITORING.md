
# Gogobe Orchestration & Monitoring Architecture
**Version:** 2.0 (Live Streaming Edition)
**Date:** 2025-12-27

## 1. Overview
This document describes the real-time orchestration system and monitoring dashboard ("The Cockpit") developed to manage the parallel ingestion of data from dozens of supermarket chains.

The system is designed to be **Generic**, **Scalable**, and **Self-Healing**.

## 2. Orchestration Engine
**Script:** `backend/scripts/import_all_sources_parallel.py`

*   **Parallel Execution:** Uses Python's `ProcessPoolExecutor` to run multiple scrapers simultaneously.
*   **Dynamic Discovery:** Fetches enabled scrapers dynamically from `scraper_registry.py`. No hardcoded lists.
*   **Resource Management:** Limits concurrency based on available CPU cores.

### 2.1 Optimization Mechanisms (Generic)

#### A. In-Memory Batch Deduplication
*   **Location:** `BaseSupermarketScraper._flush_price_batch`
*   **Problem:** Some source files contain duplicate rows (same product in same store). PostgreSQL `INSERT ... ON CONFLICT` fails if the batch itself has duplicates.
*   **Solution:** Before insertion, the scraper creates a dictionary `{(store_id, product_id): item}` to keep only the latest occurance in the batch. This is applied to ALL scrapers automatically.

#### B. "One-Pass Daily" Logic
*   **Location:** `FileProcessingTracker.should_process_store_today`
*   **Goal:** Prevent redundant processing of the same store branch multiple times a day (saving CPU/DB IO).
*   **Logic:**
    1.  Extracts `Store ID` from filename using regex (e.g., `-001-`).
    2.  Checks DB for any `completed` file for this Store ID + Current Date.
    3.  If found -> Skips file.
    4.  If not found -> Processes file.

## 3. Real-time Monitoring (The Cockpit)

### 3.1 Architecture
The dashboard uses **Server-Sent Events (SSE)** for one-way, efficient real-time updates without polling.

*   **Backend:** `GET /api/stream-status` (FastAPI)
    *   Generates a continuous stream of JSON events.
    *   Polls DB `file_processing_log` and `psutil` (System Metrics).
    *   Graceful handling of DB disconnections.
*   **Frontend:** `dashboard.html`
    *   Vanilla JS + Tailwind CSS + Chart.js.
    *   Zero dependencies (all CDNs).
    *   **Features:**
        *   Live Sparkline Charts (Prices/sec, New SKUs/sec).
        *   System Gauges (CPU, RAM, Fleet Status, Reliability).
        *   Smart Session Timer (compares to historical average).
        *   Live Log Terminal.

### 3.2 Feature Spotlight: The Fleet Matrix (Ops Center)
Instead of a simple list of running tasks, V2.4 introduces the **Fleet Matrix**:
*   **Visual:** A horizontal scrollable bar of "status chips" for all 16+ chains.
*   **States:** `Waiting` (Gray), `Running` (Pulse Blue), `Done` (Green), `Error` (Red).
*   **Optimization:** The status of the entire fleet is fetched in a **single SQL query** (`SELECT DISTINCT ON`) executing in milliseconds, preventing DB overload even during high-concurrency refreshes (every 3s).
*   **ETA Calculation:** The system estimates completion time based on: `(Waiting Chains + Running/2) * AvgChainRuntime / ConcurrentWorkers`.

### 3.3 Key Metrics Explained

| Metric | Source | Description |
| :--- | :--- | :--- |
| **Fleet Activity** | `file_processing_log` (distinct source 7 days) | How many unique scrapers are active vs target. |
| **Store Coverage** | `stores` table | % of Active Stores scanned in the last 24h. |
| **Reliability** | `file_processing_log` (status) | Success/Fail ratio of file imports. |
| **Live Ingestion** | SSE Stream Delta | Calculated client-side based on `total_prices` delta. |

## 4. How to Run
1.  **Start System:**
    ```bash
    RUN_ORCHESTRA.bat
    ```
    This script starts the API server (if needed) and launches the parallel import process.

2.  **View Dashboard:**
    Open `http://localhost:8000/dashboard.html`

## 5. Adding New Scrapers
1.  Create Scraper Class inheriting from `BaseSupermarketScraper`.
2.  Register in `scraper_registry.py`.
3.  **Done.** The Orchestrator picks it up automatically, the deduplication protects it, and the dashboard monitors it.
