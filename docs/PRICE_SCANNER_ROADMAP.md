# 🧭 Automatic Price Scanner - Status & Roadmap

## 📅 Current Status (as of 27/12/2025)
**System State:** 🏗️ **Alpha / POC Phase**

We have successfully defined the architecture, ethical guidelines, and created the initial codebase structure. The database schema has been initialized, and basic Scrapy infrastructure is in place.

---

## ✅ What's Done
1.  **Specification (Spec)**: Full architecture, waterfall logic, and ethical guidelines in `AUTOMATIC_PRICE_SCANNER_SPEC.md`.
2.  **Database Schema**: Created tables `source_discovery_tracking`, `generic_scraped_prices`.
3.  **Core Spider Improvements**:
    *   **Waterfall Logic**: JSON-LD -> Meta Tags -> CSS -> AI Fallback.
    *   **Playwright Integration**: Dynamic rendering support using `scrapy-playwright`.
    *   **Sitemap Parsing**: Robust recursive sitemap handling (including GZIP).
4.  **AI Fallback**:
    *   Implemented `ai_extractor.py` using OpenAI GPT-4o-mini.
    *   Spider automatically calls AI if standard methods fail (via `use_ai=true`).
5.  **Scheduler Service**:
    *   Created `run_scheduler.py` background service.
    *   Manages "Dynamic Re-Scan" intervals based on success rate.
    *   Automatically triggers AI matching daily.
6.  **Proxy System**:
    *   Implemented `RotatingProxyMiddleware` for future IP rotation.
7.  **Global Brain (AI Matching)**:
    *   Implemented `MasterProductMatcher` service.
    *   Replaced vector search with **Fuzzy Search + LLM Validation** (Language Agnostic).
    *   Created Admin UI (`admin/ai-matching.html`) for reviewing matches.
    *   Added API endpoints for running, approving, and rejecting matches.
8.  **Management Dashboard (UI)**:
    *   `admin/sources-discovery.html`: Add/Monitor sources.
    *   `admin/ai-matching.html`: Review AI suggestions.

---

## 🚧 What's Missing / Next Steps
### Phase 5: Optimization & Scale
1.  **Proxy Lists**: Populate the `PROXY_LIST` env var with real rotating proxies (BrightData/SmartProxy).
2.  **Selector Refinement**: Monitor logs from `rozenfeld.co.il` and others to fine-tune CSS selectors.
3.  **Data Cleanup**: Implement a job to archive/delete prices older than 30 days to save DB space.
4.  **Geo-Blocking**: Finalize country-specific proxy routing (infrastructure exists, just need configuration).

---

## 💡 Tech Stack Overview
*   **Engine**: Scrapy + Playwright (Browser Rendering)
*   **Infrastructure**: Docker (Scheduler Service + API + DB)
*   **Intelligence**:
    *   **Extraction**: GPT-4o-mini (Fallback)
    *   **Matching**: pg_trgm (Fuzzy) + GPT-4o-mini (Validation)
*   **Database**: PostgreSQL (Relational + JSONB support)

---

## 🐛 Known Issues
1.  **Long Sitemaps**: Very large sitemaps (like Rozenfeld) take a long time to map. Consider streaming or chunking.
2.  **Duplicate Prices**: Currently inserts new rows per scan. Grouping by `scraped_at` is required in analytics.

---

## 📍 How to Continue
**To run the spider manually:**
```bash
# Inside Docker
cd backend/price_scanner
scrapy crawl price_hunter -a domain=books.toscrape.com -a sitemap_url=http://books.toscrape.com/sitemap.xml
```

**To add a new source:**
Insert directly into DB:
```sql
INSERT INTO source_discovery_tracking (domain, sitemap_url, discovery_status) 
VALUES ('example.com', 'https://example.com/sitemap.xml', 'PENDING');
```
