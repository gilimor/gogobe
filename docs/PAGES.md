# List of all pages in the Gogobe system

## Current Pages (Implemented)

| Page | Route | File | Status |
|------|-------|------|--------|
| 🏠 Dashboard | `/dashboard.html` | `frontend/dashboard.html` | ✅ Live |
| 📦 Products | `/` | `frontend/index.html` | ✅ Live |
| 💰 Prices | `/prices.html` | `frontend/prices.html` | ✅ Live |
| 📂 Categories | `/categories.html` | `frontend/categories.html` | ✅ Live |
| 🏪 Stores | `/stores.html` | `frontend/stores.html` | ✅ Live |
| 🔍 Errors | `/errors.html` | `frontend/errors.html` | ✅ Live |

---

## Navigation Structure

All pages should have this exact navigation:

```html
<nav class="main-nav">
    <div class="nav-container">
        <div class="nav-content">
            <a href="/dashboard.html" class="nav-brand">
                <span>🛒</span>
                <span>Gogobe</span>
            </a>
            <div class="nav-links">
                <a href="/dashboard.html" class="nav-link">🏠 דף הבית</a>
                <a href="/" class="nav-link">📦 מוצרים</a>
                <a href="/prices.html" class="nav-link">💰 מחירים</a>
                <a href="/categories.html" class="nav-link">📂 קטגוריות</a>
                <a href="/stores.html" class="nav-link">🏪 רשתות וסניפים</a>
                <a href="/errors.html" class="nav-link">🔍 Errors</a>
            </div>
        </div>
    </div>
</nav>
```

**Important**: The current page should have `class="nav-link active"`

---

## Future Pages (Planned)

| Page | Route | Priority | Notes |
|------|-------|----------|-------|
| 📥 Import Sources | `/import-sources.html` | Medium | Manage data sources |
| 🏷️ Brands | `/brands.html` | Medium | Brand management |
| 📊 Price Analytics | `/price-analytics.html` | High | Price trends & insights |
| 🔄 Uncategorized Products | `/uncategorized.html` | Low | Products without category |
| 👥 Users | `/users.html` | Future | User management (admin) |
| ⚙️ Settings | `/settings.html` | Future | System configuration |

---

## Checklist for Adding New Page

When adding a new page, update ALL of these:

### 1. Create the file
- [ ] `frontend/new-page.html`

### 2. Add backend route
- [ ] Add route in `backend/api/main.py`:
```python
@app.get("/new-page.html")
async def serve_new_page():
    return FileResponse(Path(__file__).parent.parent.parent / "frontend" / "new-page.html")
```

### 3. Update ALL existing navigation menus
- [ ] `frontend/index.html`
- [ ] `frontend/dashboard.html`
- [ ] `frontend/prices.html`
- [ ] `frontend/categories.html`
- [ ] `frontend/stores.html`
- [ ] `frontend/errors.html`
- [ ] (and the new page itself!)

### 4. Update documentation
- [ ] This file (`docs/PAGES.md`)
- [ ] `README.md` (if major feature)

### 5. Run QA checks
- [ ] `.\scripts\qa\check_navigation.ps1`
- [ ] `python scripts\qa\check_routes.py`
- [ ] Manual smoke test (open all pages)

### 6. Restart API
- [ ] `docker restart gogobe-api-1`

---

## Quick Reference

**Total Pages**: 6 (live) + 6 (planned) = 12

**Files to update when adding a page**: 9
- 1 new file
- 7 existing HTML files (for nav)
- 1 main.py (for route)

**Average time to add new page**: 30-45 minutes (if following checklist)

