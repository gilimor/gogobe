/**
 * Gogobe Price Comparison Frontend
 * Main JavaScript application
 */

// Use relative path for API - works with any host/port
const API_BASE = '';

// Global error handler for catching JavaScript errors
window.addEventListener('error', function (event) {
    logClientError({
        type: event.error?.name || 'Error',
        message: event.message,
        stack: event.error?.stack,
        url: event.filename,
        line: event.lineno,
        column: event.colno,
        userAgent: navigator.userAgent
    });
});

// Catch unhandled promise rejections
window.addEventListener('unhandledrejection', function (event) {
    logClientError({
        type: 'UnhandledPromiseRejection',
        message: event.reason?.message || String(event.reason),
        stack: event.reason?.stack,
        url: window.location.href,
        userAgent: navigator.userAgent
    });
});

// Function to log client errors to server
async function logClientError(errorData) {
    try {
        await fetch(`${API_BASE}/api/errors/client`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(errorData)
        });
    } catch (e) {
        // Silently fail if can't log error
        console.error('Failed to log error to server:', e);
    }
}

// State
let currentPage = 1;
let currentView = 'table'; // 'grid' or 'table' - DEFAULT: table
let currentFilters = {
    q: '',
    category: null,
    supplier: null,
    min_price: null,
    max_price: null,
    currency: 'ILS',
    sort_by: 'price_asc'
};

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    console.log('🚀 Gogobe app initialized');

    // Set initial view
    switchView(currentView);

    // Check API health
    checkAPIHealth();

    // Load minimal initial data
    loadStats(); // Only stats for hero section
    // Categories and suppliers will load when filters are opened

    // Don't auto-search - show empty state instead for better performance
    showEmptyState();

    // Event listeners
    setupEventListeners();
});

// ===================================
// Event Listeners
// ===================================

function setupEventListeners() {
    // Search
    const searchBtn = document.getElementById('search-btn');
    const searchInput = document.getElementById('search-input');
    if (searchBtn) searchBtn.addEventListener('click', handleSearch);
    if (searchInput) {
        searchInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') handleSearch();
        });
    }

    // Filters
    const categoryFilter = document.getElementById('category-filter');
    const supplierFilter = document.getElementById('supplier-filter');
    const minPrice = document.getElementById('min-price');
    const maxPrice = document.getElementById('max-price');
    const currencyFilter = document.getElementById('currency-filter');
    const sortFilter = document.getElementById('sort-filter');

    if (categoryFilter) categoryFilter.addEventListener('change', handleSearch);
    if (supplierFilter) supplierFilter.addEventListener('change', handleSearch);
    if (minPrice) minPrice.addEventListener('change', handleSearch);
    if (maxPrice) maxPrice.addEventListener('change', handleSearch);
    if (currencyFilter) currencyFilter.addEventListener('change', handleSearch);
    if (sortFilter) sortFilter.addEventListener('change', handleSearch);

    // Clear filters
    const clearFiltersBtn = document.getElementById('clear-filters');
    if (clearFiltersBtn) clearFiltersBtn.addEventListener('click', clearFilters);

    // View toggle
    const viewGrid = document.getElementById('view-grid');
    const viewTable = document.getElementById('view-table');
    if (viewGrid) viewGrid.addEventListener('click', () => switchView('grid'));
    if (viewTable) viewTable.addEventListener('click', () => switchView('table'));

    // Modal close
    const modalOverlay = document.querySelector('.modal-overlay');
    const modalClose = document.querySelector('.modal-close');
    if (modalOverlay) modalOverlay.addEventListener('click', closeModal);
    if (modalClose) modalClose.addEventListener('click', closeModal);
}

// ===================================
// View Management
// ===================================

function switchView(view) {
    currentView = view;

    // Update buttons
    const viewGrid = document.getElementById('view-grid');
    const viewTable = document.getElementById('view-table');
    if (viewGrid) viewGrid.classList.toggle('active', view === 'grid');
    if (viewTable) viewTable.classList.toggle('active', view === 'table');

    // Show/hide containers
    const productsGrid = document.getElementById('products-grid');
    const productsTable = document.getElementById('products-table-container');
    if (productsGrid) productsGrid.style.display = view === 'grid' ? 'grid' : 'none';
    if (productsTable) productsTable.style.display = view === 'table' ? 'block' : 'none';
}

// ===================================
// API Functions
// ===================================

async function apiRequest(endpoint) {
    try {
        const response = await fetch(`${API_BASE}${endpoint}`);
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        return await response.json();
    } catch (error) {
        console.error('API Error:', error);
        throw error;
    }
}

async function checkAPIHealth() {
    try {
        const health = await apiRequest('/api/health');
        const statusEl = document.getElementById('api-status');
        if (health.status === 'healthy') {
            statusEl.textContent = '✅ מחובר';
            statusEl.style.color = '#10b981';
        } else {
            statusEl.textContent = '⚠️ שגיאה';
            statusEl.style.color = '#f59e0b';
        }
    } catch {
        const statusEl = document.getElementById('api-status');
        statusEl.textContent = '❌ לא מחובר';
        statusEl.style.color = '#ef4444';
    }
}

async function loadStats() {
    try {
        const stats = await apiRequest('/api/stats');

        document.getElementById('total-products').textContent =
            formatNumber(stats.total_products);
        document.getElementById('total-suppliers').textContent =
            formatNumber(stats.total_suppliers);
        document.getElementById('total-prices').textContent =
            formatNumber(stats.total_prices);
    } catch (error) {
        console.error('Failed to load stats:', error);
    }
}

async function loadCategories() {
    try {
        const data = await apiRequest('/api/categories');
        const select = document.getElementById('category-filter');

        data.categories.forEach(cat => {
            const option = document.createElement('option');
            option.value = cat.id;
            option.textContent = `${cat.name} (${cat.product_count})`;
            select.appendChild(option);
        });
    } catch (error) {
        console.error('Failed to load categories:', error);
    }
}

async function loadSuppliers() {
    try {
        const data = await apiRequest('/api/suppliers');
        const select = document.getElementById('supplier-filter');

        data.suppliers.forEach(sup => {
            const option = document.createElement('option');
            option.value = sup.id;
            option.textContent = `${sup.name} (${sup.product_count})`;
            select.appendChild(option);
        });
    } catch (error) {
        console.error('Failed to load suppliers:', error);
    }
}

async function searchProducts(page = 1) {
    showLoading();
    hideError();

    try {
        // Build query params
        const params = new URLSearchParams();

        if (currentFilters.q) params.append('q', currentFilters.q);
        if (currentFilters.category) params.append('category', currentFilters.category);
        if (currentFilters.supplier) params.append('supplier', currentFilters.supplier);
        if (currentFilters.min_price) params.append('min_price', currentFilters.min_price);
        if (currentFilters.max_price) params.append('max_price', currentFilters.max_price);
        if (currentFilters.currency) params.append('currency', currentFilters.currency);
        if (currentFilters.sort_by) params.append('sort_by', currentFilters.sort_by);
        params.append('page', page);
        params.append('per_page', 20);

        const data = await apiRequest(`/api/products/search?${params}`);

        displayProducts(data.products);
        displayPagination(data.pagination);
        displayResultsInfo(data);

        currentPage = page;

    } catch (error) {
        showError('שגיאה בטעינת המוצרים. נסה שוב.');
        console.error('Search error:', error);
    } finally {
        hideLoading();
    }
}

async function loadProduct(itemId, type = 'orphan') {
    try {
        let item;
        if (type === 'master') {
            item = await apiRequest(`/api/masters/${itemId}`);
            displayMasterModal(item);
        } else {
            item = await apiRequest(`/api/products/${itemId}`);
            displayProductModal(item);
        }
    } catch (error) {
        showError('שגיאה בטעינת פרטי הפריט');
        console.error('Load item error:', error);
    }
}

// ===================================
// Display Functions
// ===================================

function displayProducts(products) {
    if (products.length === 0) {
        showNoResults();
        return;
    }

    hideNoResults();

    if (currentView === 'grid') {
        displayProductsGrid(products);
    } else {
        displayProductsTable(products);
    }
}

function displayProductsGrid(products) {
    const grid = document.getElementById('products-grid');
    if (!grid) return;

    grid.innerHTML = '';

    products.forEach(product => {
        const card = createProductCard(product);
        grid.appendChild(card);
    });
}

function displayProductsTable(products) {
    const tbody = document.getElementById('products-table-body');
    if (!tbody) return;

    tbody.innerHTML = '';

    products.forEach(product => {
        const row = createProductRow(product);
        tbody.appendChild(row);
    });
}

function createProductCard(product) {
    const isMaster = product.type === 'master';
    const card = document.createElement('div');
    card.className = `product-card ${isMaster ? 'master-card' : ''}`;
    card.onclick = () => loadProduct(product.id, product.type);

    const minPrice = product.min_price ? formatPrice(product.min_price, 'ILS') : 'N/A';
    const maxPrice = product.max_price && product.max_price !== product.min_price ?
        formatPrice(product.max_price, 'ILS') : '';
    const lastUpdated = product.last_updated ? formatDate(product.last_updated) : 'לא ידוע';

    // Check if on sale (simulated for now - will connect to real data)
    const isOnSale = product.is_on_sale || (product.discount_percentage && product.discount_percentage > 0);
    const discountPct = product.discount_percentage || 0;
    const originalPrice = product.original_price;

    // Product image (placeholder for now)
    const productImage = product.main_image_url || getProductPlaceholder(product.category_name);

    card.innerHTML = `
        ${isOnSale ? `
            <div class="sale-badge">
                🔥 מבצע <span class="sale-percentage">-${discountPct}%</span>
            </div>
        ` : ''}

        <div class="add-to-basket" onclick="event.stopPropagation(); addToBasket(${product.id}, '${escapeHtml(product.name)}', ${product.min_price})" title="הוסף לסל החכם">
            🛒
        </div>

        <div class="product-image">
            ${productImage ?
            `<img src="${productImage}" alt="${escapeHtml(product.name)}" onerror="this.src='data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22><text y=%2250%%25%22 x=%2250%%25%22 text-anchor=%22middle%22 font-size=%2260%22>🛒</text></svg>'">` :
            '🛒'
        }
        </div>

        <div class="product-body">
            ${isMaster ? '<span class="master-badge">👑 אב מוצר</span>' : ''}

            <div class="product-name" title="${escapeHtml(product.name)}">
                ${escapeHtml(product.name)}
            </div>

            <div class="product-meta">
                ${product.category_name ?
            `<span class="product-badge badge-category">${escapeHtml(product.category_name)}</span>` :
            ''}
                ${product.ean || product.upc ?
            `<span class="product-badge badge-barcode">${product.ean || product.upc}</span>` :
            ''}
            </div>

            <div class="price-display">
                <div class="price-container">
                    <div class="price-min">${minPrice}</div>
                    ${originalPrice && isOnSale ?
            `<div class="price-original">${formatPrice(originalPrice, 'ILS')}</div>` :
            ''}
                    ${maxPrice ? `<div class="price-max">עד ${maxPrice}</div>` : ''}
                </div>
                <div class="price-suppliers">
                    📊 ${product.store_count} סניפים
                    ${product.avg_price ?
            `• ממוצע: ${formatPrice(product.avg_price, 'ILS')}` : ''}
                </div>
            </div>
        </div>

        <div class="product-footer">
            <span class="last-updated">עודכן: ${lastUpdated}</span>
            <button class="view-details" onclick="event.stopPropagation(); loadProduct(${product.id}, '${product.type}')">
                לכל המחירים
            </button>
        </div>
    `;

    return card;
}

// Helper function for product placeholders
function getProductPlaceholder(category) {
    const placeholders = {
        'חלב וביצים': '🥛',
        'לחם ומאפים': '🍞',
        'פירות וירקות': '🥬',
        'בשר ודגים': '🍖',
        'משקאות': '🥤',
        'חטיפים וממתקים': '🍫',
        'מוצרי ניקיון': '🧹',
        'קוסמטיקה': '💄',
        'תינוקות': '👶'
    };
    return null; // Will show emoji from CSS
}

function createProductRow(product) {
    const isMaster = product.type === 'master';
    const row = document.createElement('tr');
    if (isMaster) row.className = 'master-row';

    const minPrice = product.min_price ? formatPrice(product.min_price, 'ILS') : 'N/A';
    const maxPrice = product.max_price && product.max_price !== product.min_price ?
        formatPrice(product.max_price, 'ILS') : '-';
    const avgPrice = product.avg_price ? formatPrice(product.avg_price, 'ILS') : '-';
    const lastUpdated = product.last_updated ? formatDate(product.last_updated) : 'לא ידוע';

    row.innerHTML = `
        <td>
            <div class="table-product-name" title="${escapeHtml(product.name)}">
                ${isMaster ? '<span class="master-indicator" title="אב מוצר">👑</span> ' : ''}
                ${escapeHtml(product.name)}
            </div>
        </td>
        <td>${product.ean || product.upc || '-'}</td>
        <td>${escapeHtml(product.brand_name || '-')}</td>
        <td>
            ${product.category_name ?
            `<span class="table-category">${escapeHtml(product.category_name)}</span>` :
            '-'}
        </td>
        <td>
            <span class="table-stores">
                ${isMaster ? `${product.variant_count} גרסאות ב-${product.store_count} סניפים` : `${product.store_count} סניפים`}
            </span>
        </td>
        <td><span class="table-price table-price-min">${minPrice}</span></td>
        <td><span class="table-price table-price-max">${maxPrice}</span></td>
        <td><span class="table-price table-price-avg">${avgPrice}</span></td>
        <td><span class="table-date">${lastUpdated}</span></td>
        <td>
            <div class="table-actions">
                <button class="table-btn ${isMaster ? 'btn-master' : ''}" onclick="loadProduct(${product.id}, '${product.type}')">
                    ${isMaster ? 'צפה בכולם' : 'פרטים'}
                </button>
            </div>
        </td>
    `;

    return row;
}

function displayProductModal(product) {
    const modal = document.getElementById('product-modal');
    const body = document.getElementById('modal-body');

    if (!modal || !body) return;

    // Sort prices by price
    const prices = (product.prices || []).sort((a, b) => a.price - b.price);
    const bestPrice = prices.length > 0 ? prices[0] : null;

    body.innerHTML = `
        <h2 class="modal-product-name">${escapeHtml(product.name)}</h2>
        
        ${product.description ? `
            <div class="modal-section">
                <h3>תיאור</h3>
                <p>${escapeHtml(product.description)}</p>
            </div>
        ` : ''}
        
        <div class="modal-section">
            <h3>השוואת מחירים (${prices.length} מחירים)</h3>
            ${prices.length > 0 ? `
            <table class="price-comparison-table">
                <thead>
                    <tr>
                        <th>חנות</th>
                        <th>עיר</th>
                        <th>מחיר</th>
                        <th>עודכן</th>
                    </tr>
                </thead>
                <tbody>
                    ${prices.map(price => `
                        <tr class="${price === bestPrice ? 'supplier-best' : ''}">
                            <td>
                                <strong>${escapeHtml(price.store_name_he || price.store_name || price.supplier_name || 'לא ידוע')}</strong>
                                ${price === bestPrice ? ' 🏆' : ''}
                            </td>
                            <td>${price.city || '-'}</td>
                            <td class="price-value">${formatPrice(price.price, price.currency || 'ILS')}</td>
                            <td>${formatDate(price.scraped_at)}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
            ` : '<p>אין מחירים זמינים עבור מוצר זה</p>'}
        </div>
        
        ${product.price_history && product.price_history.length > 0 ? `
            <div class="modal-section">
                <h3>היסטוריית מחירים</h3>
                <table class="price-comparison-table">
                    <thead>
                        <tr>
                            <th>תאריך</th>
                            <th>מחיר מינימלי</th>
                            <th>מחיר ממוצע</th>
                            <th>מחיר מקסימלי</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${product.price_history.map(h => {
        const currency = prices.length > 0 ? prices[0].currency : 'ILS';
        return `
                            <tr>
                                <td>${formatDate(h.date)}</td>
                                <td>${formatPrice(h.min_price, currency)}</td>
                                <td>${formatPrice(h.avg_price, currency)}</td>
                                <td>${formatPrice(h.max_price, currency)}</td>
                            </tr>
                        `;
    }).join('')}
                    </tbody>
                </table>
            </div>
        ` : ''}
        
        <div class="modal-section">
            <h3>פרטי מוצר</h3>
            <table class="price-comparison-table">
                <tbody>
                    ${product.brand_name ? `<tr><td><strong>מותג</strong></td><td>${escapeHtml(product.brand_name)}</td></tr>` : ''}
                    ${product.category_name ? `<tr><td><strong>קטגוריה</strong></td><td>${escapeHtml(product.category_name)}</td></tr>` : ''}
                    ${product.vertical_name ? `<tr><td><strong>תחום</strong></td><td>${escapeHtml(product.vertical_name)}</td></tr>` : ''}
                    <tr><td><strong>SKU</strong></td><td>${product.sku || 'N/A'}</td></tr>
                    <tr><td><strong>נוצר</strong></td><td>${formatDate(product.created_at)}</td></tr>
                </tbody>
            </table>
        </div>
    `;

    modal.style.display = 'flex';
}

function displayMasterModal(master) {
    const modal = document.getElementById('product-modal');
    const modalContent = document.getElementById('modal-body');
    if (!modal || !modalContent) return;

    const minPrice = master.prices && master.prices.length > 0 ? master.prices[0].price : 0;
    const maxPrice = master.prices && master.prices.length > 0 ? master.prices[master.prices.length - 1].price : 0;
    const avgPrice = master.prices && master.prices.length > 0 ?
        master.prices.reduce((sum, p) => sum + p.price, 0) / master.prices.length : 0;

    modalContent.innerHTML = `
        <div class="modal-header-complex">
            <div class="modal-title-main">
                <span class="master-crown">👑</span>
                <h2>${escapeHtml(master.name)}</h2>
                <div class="master-type-tag">אב מוצר מאוחד</div>
            </div>
            <button class="close-btn" onclick="closeModal()">&times;</button>
        </div>

        <div class="master-stats-summary">
            <div class="stat-box">
                <span class="stat-label">הכי זול</span>
                <span class="stat-value highlight">${formatPrice(minPrice, 'ILS')}</span>
            </div>
            <div class="stat-box">
                <span class="stat-label">ממוצע</span>
                <span class="stat-value">${formatPrice(avgPrice, 'ILS')}</span>
            </div>
            <div class="stat-box">
                <span class="stat-label">וריאציות</span>
                <span class="stat-value">${master.variants ? master.variants.length : 0}</span>
            </div>
            <div class="stat-box">
                <span class="stat-label">סניפים</span>
                <span class="stat-value">${[...new Set(master.prices.map(p => p.store_id))].length}</span>
            </div>
        </div>

        <div class="modal-body">
            <div class="master-section">
                <h3>📦 וריאציות מוצר (בנים)</h3>
                <div class="variants-list">
                    ${master.variants.map(v => `
                        <div class="variant-item">
                            <span class="variant-name">${escapeHtml(v.name)}</span>
                            <span class="variant-barcode">${v.ean || v.upc || ''}</span>
                        </div>
                    `).join('')}
                </div>
            </div>

            <div class="master-section">
                <h3>💰 השוואת מחירים ארצית (לכל הגרסאות)</h3>
                <div class="modal-prices-table-container">
                    <table class="modal-prices-table">
                        <thead>
                            <tr>
                                <th>חנות/רשת</th>
                                <th>עיר</th>
                                <th>גרסה ספציפית</th>
                                <th>מחיר</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${master.prices.map(p => `
                                <tr>
                                    <td><strong>${escapeHtml(p.store_name_he || p.store_name || p.supplier_name)}</strong></td>
                                    <td>${escapeHtml(p.city || '-')}</td>
                                    <td><span class="variant-tag">${escapeHtml(p.variant_name)}</span></td>
                                    <td><span class="price-val">${formatPrice(p.price, p.currency)}</span></td>
                                </tr>
                            `).join('')}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    `;

    modal.style.display = 'block';
    document.body.style.overflow = 'hidden';
}
function closeModal() {
    const modal = document.getElementById('product-modal');
    if (modal) modal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

function displayPagination(pagination) {
    const container = document.getElementById('pagination');

    if (pagination.pages <= 1) {
        container.style.display = 'none';
        return;
    }

    container.style.display = 'flex';
    container.innerHTML = '';

    // Previous button
    const prevBtn = document.createElement('button');
    prevBtn.className = 'page-btn';
    prevBtn.textContent = '← הקודם';
    prevBtn.disabled = pagination.page === 1;
    prevBtn.onclick = () => searchProducts(pagination.page - 1);
    container.appendChild(prevBtn);

    // Page numbers
    const startPage = Math.max(1, pagination.page - 2);
    const endPage = Math.min(pagination.pages, pagination.page + 2);

    if (startPage > 1) {
        const btn = createPageButton(1, pagination.page);
        container.appendChild(btn);
        if (startPage > 2) {
            const ellipsis = document.createElement('span');
            ellipsis.textContent = '...';
            container.appendChild(ellipsis);
        }
    }

    for (let i = startPage; i <= endPage; i++) {
        const btn = createPageButton(i, pagination.page);
        container.appendChild(btn);
    }

    if (endPage < pagination.pages) {
        if (endPage < pagination.pages - 1) {
            const ellipsis = document.createElement('span');
            ellipsis.textContent = '...';
            container.appendChild(ellipsis);
        }
        const btn = createPageButton(pagination.pages, pagination.page);
        container.appendChild(btn);
    }

    // Next button
    const nextBtn = document.createElement('button');
    nextBtn.className = 'page-btn';
    nextBtn.textContent = 'הבא →';
    nextBtn.disabled = pagination.page === pagination.pages;
    nextBtn.onclick = () => searchProducts(pagination.page + 1);
    container.appendChild(nextBtn);
}

function createPageButton(pageNum, currentPage) {
    const btn = document.createElement('button');
    btn.className = 'page-btn' + (pageNum === currentPage ? ' active' : '');
    btn.textContent = pageNum;
    btn.onclick = () => searchProducts(pageNum);
    return btn;
}

function displayResultsInfo(data) {
    const info = document.getElementById('results-info');
    const count = document.getElementById('results-count');
    const query = document.getElementById('results-query');

    if (count && data && data.pagination) {
        count.textContent = `${data.pagination.total} תוצאות`;
    }

    if (query && data && data.filters) {
        const filters = [];
        if (data.filters.q) filters.push(`"${data.filters.q}"`);
        if (data.filters.category) filters.push('סינון לפי קטגוריה');
        if (data.filters.supplier) filters.push('סינון לפי ספק');
        if (data.filters.min_price || data.filters.max_price) {
            filters.push('סינון לפי מחיר');
        }
        query.textContent = filters.length > 0 ? filters.join(' • ') : '';
    }

    if (info) info.style.display = 'flex';
}

// ===================================
// Handler Functions
// ===================================

function handleSearch() {
    const searchInput = document.getElementById('search-input');
    const categoryFilter = document.getElementById('category-filter');
    const supplierFilter = document.getElementById('supplier-filter');
    const minPrice = document.getElementById('min-price');
    const maxPrice = document.getElementById('max-price');
    const currencyFilter = document.getElementById('currency-filter');
    const sortFilter = document.getElementById('sort-filter');

    currentFilters.q = searchInput ? searchInput.value.trim() : '';
    currentFilters.category = categoryFilter ? (categoryFilter.value || null) : null;
    currentFilters.supplier = supplierFilter ? (supplierFilter.value || null) : null;
    currentFilters.min_price = minPrice ? (minPrice.value || null) : null;
    currentFilters.max_price = maxPrice ? (maxPrice.value || null) : null;
    currentFilters.currency = currencyFilter ? currencyFilter.value : 'ILS';
    currentFilters.sort_by = sortFilter ? sortFilter.value : 'price_asc';

    searchProducts(1);
}

function clearFilters() {
    const searchInput = document.getElementById('search-input');
    const categoryFilter = document.getElementById('category-filter');
    const supplierFilter = document.getElementById('supplier-filter');
    const minPrice = document.getElementById('min-price');
    const maxPrice = document.getElementById('max-price');
    const currencyFilter = document.getElementById('currency-filter');
    const sortFilter = document.getElementById('sort-filter');

    if (searchInput) searchInput.value = '';
    if (categoryFilter) categoryFilter.value = '';
    if (supplierFilter) supplierFilter.value = '';
    if (minPrice) minPrice.value = '';
    if (maxPrice) maxPrice.value = '';
    if (currencyFilter) currencyFilter.value = 'ILS';
    if (sortFilter) sortFilter.value = 'price_asc';

    currentFilters = {
        q: '',
        category: null,
        supplier: null,
        min_price: null,
        max_price: null,
        currency: 'ILS',
        sort_by: 'price_asc'
    };

    searchProducts(1);
}

// ===================================
// UI State Functions
// ===================================

function showLoading() {
    document.getElementById('loading').style.display = 'block';
    const productsGrid = document.getElementById('products-grid');
    const productsTable = document.getElementById('products-table-container');
    if (productsGrid) productsGrid.style.display = 'none';
    if (productsTable) productsTable.style.display = 'none';
    document.getElementById('pagination').style.display = 'none';
    const resultsInfo = document.getElementById('results-info');
    if (resultsInfo) resultsInfo.style.display = 'none';
}

function hideLoading() {
    document.getElementById('loading').style.display = 'none';
    // View will be restored by switchView or displayProducts
}

function showError(message) {
    const errorBox = document.getElementById('error');
    errorBox.textContent = message;
    errorBox.style.display = 'block';
}

function hideError() {
    document.getElementById('error').style.display = 'none';
}

function showNoResults() {
    const noResults = document.getElementById('no-results');
    const productsGrid = document.getElementById('products-grid');
    const productsTable = document.getElementById('products-table-container');
    const pagination = document.getElementById('pagination');

    if (noResults) noResults.style.display = 'block';
    if (productsGrid) productsGrid.style.display = 'none';
    if (productsTable) productsTable.style.display = 'none';
    if (pagination) pagination.style.display = 'none';
}

function hideNoResults() {
    const noResults = document.getElementById('no-results');
    if (noResults) noResults.style.display = 'none';
    // Restore view based on currentView
    switchView(currentView);
}

// ===================================
// Utility Functions
// ===================================

function formatPrice(price, currency) {
    const symbols = { GBP: '£', USD: '$', EUR: '€', ILS: '₪' };
    const symbol = symbols[currency] || currency;
    return `${symbol}${parseFloat(price).toFixed(2)}`;
}

function formatNumber(num) {
    return new Intl.NumberFormat('he-IL').format(num);
}

function formatDate(dateStr) {
    if (!dateStr) return 'N/A';
    const date = new Date(dateStr);
    return date.toLocaleDateString('he-IL');
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Export for debugging
window.gogobeApp = {
    searchProducts,
    loadProduct,
    currentFilters,
    API_BASE
};

console.log('✅ Gogobe app ready!');

