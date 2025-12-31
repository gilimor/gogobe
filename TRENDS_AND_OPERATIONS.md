# Trends and Operations Documentation
**Version:** 1.0  
**Date:** 2025-12-27  
**Module:** Analytics & Backend Ops

## 1. Overview
This document outlines the architecture and usage of the new **Trends Analysis** module and the enhanced **Operational "God Mode"** added to the Gogobe system.

These features enable:
1.  **Market Intelligence:** Detecting price drops (>25%) and hikes in real-time.
2.  **High-Performance Analytics:** Using batched SQL updates instead of per-request calculation.
3.  **Emergency Ops:** Bypassing local environment issues using remote script execution.

---

## 2. Trends Analysis System

### Frontend: `trends.html`
A new analytics dashboard accessible via the "Explore" ("גלה") menu.
*   **Time Machine:** Compare current prices vs. 2 days, 1 week, or 1 month ago.
*   **Sensitivity:** User-defined threshold (default 10%).
*   **Visuals:** Green/Red cards for drops/hikes with clear percentage indicators.

### Backend: `/api/products/trends/analyze`
*   **Logic:** Executes an optimized SQL query comparing `AVG(price)` from the last 24h vs. a historical window.
*   **Performance:** Uses database indices; response time is typically <200ms for thousands of products.
*   **Endpoint:** `GET /api/products/trends/analyze?days_back=7&min_change_pct=10`

### Database Architecture
To support high-scale ingestion without slowing down reads:
1.  **New Column:** `products.price_change_24h` (Numeric, Indexed).
2.  **Batch Strategy:** During Ingestion, we only INSERT raw prices.
3.  **Post-Processing:** A scheduled job (or manual trigger) updates the `price_change_24h` column in bulk.

**Command to trigger calculation:**
```http
POST /api/management/stats/recalc
```

---

## 3. Operational "God Mode" (Backend Ops)

Due to local environment restrictions (Python DLL issues on Windows), we implemented a **Remote Execution Layer**. This allows administrators to run Python scripts and SQL commands *inside* the stable backend container.

### A. Run Remote Script
Executes a script locating in the `scripts/` folder or absolute path.

**Endpoint:** `POST /api/management/run-script`
**Body:**
```json
{
  "script_name": "run_generic_import.py" 
}
```

### B. Run Raw SQL
The ultimate bypass for fixing DB issues or injecting data.

**Endpoint:** `POST /api/management/run-sql`
**Body:**
```json
{
  "sql_query": "UPDATE products SET is_active=true WHERE id=123"
}
```

---

## 4. Scraper Registry Improvements

The `ScraperRegistry` (`backend/scrapers/scraper_registry.py`) was hardened:
1.  **Status Reporting:** Now includes `last_error` field to expose loading failures in the `/api/admin/sources/status` response.
2.  **Absolute Imports:** Fixed module paths to use `backend.scrapers...` for reliability across Docker/Local envs.

---

## 5. Development Scripts

New utility scripts created in `scripts/`:
*   `run_generic_import.py`: A standardized runner that tests the Registry loading logic and runs a scrape + stats recalc cycle.
*   `inject_demo_history.py`: Generates synthetic history (7 days back) for 20 products to demonstrate the Trends UI immediately.

## 6. Next Steps
1.  **Automate Recalc:** Configure `Celery` or `Cron` to call `/api/management/stats/recalc` every night at 04:00.
2.  **Alerts:** Connect the Trends engine to a notification system (Email/WhatsApp) for "Price Drop Alerts".
