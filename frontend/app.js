/**
 * Gogobe Price Comparison Frontend
 * Main JavaScript application
 */

const API_BASE = 'http://localhost:8000';

// Global error handler for catching JavaScript errors
window.addEventListener('error', function(event) {
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
window.addEventListener('unhandledrejection', function(event) {
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
    
    // Load initial data
    loadStats();
    loadCategories();
    loadSuppliers();
    searchProducts();
    
    // Event listeners
    setupEventListeners();
});

// ===================================
// Event Listeners
// ===================================

function setupEventListeners() {
    // Search
    document.getElementById('search-btn').addEventListener('click', handleSearch);
    document.getElementById('search-input').addEventListener('keypress', (e) => {
        if (e.key === 'Enter') handleSearch();
    });
    
    // Filters
    document.getElementById('category-filter').addEventListener('change', handleSearch);
    document.getElementById('supplier-filter').addEventListener('change', handleSearch);
    document.getElementById('min-price').addEventListener('change', handleSearch);
    document.getElementById('max-price').addEventListener('change', handleSearch);
    document.getElementById('currency-filter').addEventListener('change', handleSearch);
    document.getElementById('sort-filter').addEventListener('change', handleSearch);
    
    // Clear filters
    document.getElementById('clear-filters').addEventListener('click', clearFilters);
    
    // View toggle
    document.getElementById('view-grid').addEventListener('click', () => switchView('grid'));
    document.getElementById('view-table').addEventListener('click', () => switchView('table'));
    
    // Modal close
    document.querySelector('.modal-overlay')?.addEventListener('click', closeModal);
    document.querySelector('.modal-close')?.addEventListener('click', closeModal);
}

// ===================================
// View Management
// ===================================

function switchView(view) {
    currentView = view;
    
    // Update buttons
    document.getElementById('view-grid').classList.toggle('active', view === 'grid');
    document.getElementById('view-table').classList.toggle('active', view === 'table');
    
    // Show/hide containers
    document.getElementById('products-grid').style.display = view === 'grid' ? 'grid' : 'none';
    document.getElementById('products-table-container').style.display = view === 'table' ? 'block' : 'none';
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

async function loadProduct(productId) {
    try {
        const product = await apiRequest(`/api/products/${productId}`);
        displayProductModal(product);
    } catch (error) {
        showError('שגיאה בטעינת פרטי המוצר');
        console.error('Load product error:', error);
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
    grid.innerHTML = '';
    
    products.forEach(product => {
        const card = createProductCard(product);
        grid.appendChild(card);
    });
}

function displayProductsTable(products) {
    const tbody = document.getElementById('products-table-body');
    tbody.innerHTML = '';
    
    products.forEach(product => {
        const row = createProductRow(product);
        tbody.appendChild(row);
    });
}

function createProductCard(product) {
    const card = document.createElement('div');
    card.className = 'product-card';
    card.onclick = () => loadProduct(product.id);
    
    const minPrice = product.min_price ? formatPrice(product.min_price, product.currency) : 'N/A';
    const maxPrice = product.max_price && product.max_price !== product.min_price ? 
        formatPrice(product.max_price, product.currency) : '';
    
    const lastUpdated = product.last_updated ? 
        formatDate(product.last_updated) : 'לא ידוע';
    
    card.innerHTML = `
        <div class="product-header">
            <div class="product-name">${escapeHtml(product.name)}</div>
            <div class="product-meta">
                ${product.category_name ? 
                    `<span class="badge badge-category">${escapeHtml(product.category_name)}</span>` : ''}
                ${product.vertical_name ? 
                    `<span class="badge badge-vertical">${escapeHtml(product.vertical_name)}</span>` : ''}
            </div>
        </div>
        
        <div class="product-prices">
            <div class="price-range">
                <div class="price-min">${minPrice}</div>
                ${maxPrice ? `<div class="price-max">${maxPrice}</div>` : ''}
            </div>
            ${product.supplier_count ? 
                `<div class="price-suppliers">
                    📊 ${product.supplier_count} ספקים
                    ${product.avg_price ? 
                        `• ממוצע: ${formatPrice(product.avg_price, product.currency)}` : ''}
                </div>` : ''}
        </div>
        
        <div class="product-footer">
            <span class="last-updated">עודכן: ${lastUpdated}</span>
            <button class="view-details" onclick="event.stopPropagation(); loadProduct(${product.id})">
                פרטים
            </button>
        </div>
    `;
    
    return card;
}

function createProductRow(product) {
    const row = document.createElement('tr');
    
    const minPrice = product.min_price ? formatPrice(product.min_price, product.currency) : 'N/A';
    const maxPrice = product.max_price && product.max_price !== product.min_price ? 
        formatPrice(product.max_price, product.currency) : '-';
    const avgPrice = product.avg_price ? formatPrice(product.avg_price, product.currency) : '-';
    const lastUpdated = product.last_updated ? formatDate(product.last_updated) : 'לא ידוע';
    
    // ברקוד - EAN או UPC
    const barcode = product.ean || product.upc || product.model_number || '-';
    
    // יצרן/מותג
    const manufacturer = product.brand_name || product.manufacturer_code || '-';
    
    // חנויות - הצג את שמות הסניפים
    let stores = '-';
    if (product.store_names) {
        // יש שמות סניפים ספציפיים
        stores = product.store_names;
    } else if (product.attributes && product.attributes.store_name) {
        // יש שם סניף ב-attributes
        stores = product.attributes.store_name;
    } else if (product.supplier_names) {
        // הצג את שם הרשת (ספק)
        stores = product.supplier_names;
    } else if (product.supplier_count > 0) {
        // מספר ספקים
        stores = `${product.supplier_count} ספקים`;
    }
    
    row.innerHTML = `
        <td>
            <div class="table-product-name" title="${escapeHtml(product.name)}">
                ${escapeHtml(product.name)}
            </div>
        </td>
        <td>
            <span class="table-barcode" title="${escapeHtml(barcode)}">
                ${escapeHtml(barcode)}
            </span>
        </td>
        <td>
            <span class="table-manufacturer" title="${escapeHtml(manufacturer)}">
                ${escapeHtml(manufacturer)}
            </span>
        </td>
        <td>
            ${product.category_name ? 
                `<span class="table-category">${escapeHtml(product.category_name)}</span>` : 
                '-'}
        </td>
        <td>
            <span class="table-stores" title="${escapeHtml(stores)}">
                ${escapeHtml(stores.length > 30 ? stores.substring(0, 27) + '...' : stores)}
            </span>
        </td>
        <td>
            <span class="table-price table-price-min">${minPrice}</span>
        </td>
        <td>
            <span class="table-price table-price-max">${maxPrice}</span>
        </td>
        <td>
            <span class="table-price table-price-avg">${avgPrice}</span>
        </td>
        <td>
            <span class="table-date">${lastUpdated}</span>
        </td>
        <td>
            <div class="table-actions">
                <button class="table-btn" onclick="loadProduct(${product.id})">
                    פרטים
                </button>
            </div>
        </td>
    `;
    
    return row;
}

function displayProductModal(product) {
    const modal = document.getElementById('product-modal');
    const body = document.getElementById('modal-body');
    
    // Sort prices by price
    const prices = product.prices.sort((a, b) => a.price - b.price);
    const bestPrice = prices[0];
    
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
                                <strong>${escapeHtml(price.store_name || price.supplier_name)}</strong>
                                ${price === bestPrice ? ' 🏆' : ''}
                                ${price.store_code ? `<br><small>סניף ${price.store_code}</small>` : ''}
                            </td>
                            <td>${price.city || '-'}</td>
                            <td class="price-value">${formatPrice(price.price, price.currency)}</td>
                            <td>${formatDate(price.scraped_at)}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
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
                        ${product.price_history.map(h => `
                            <tr>
                                <td>${formatDate(h.date)}</td>
                                <td>${formatPrice(h.min_price, prices[0].currency)}</td>
                                <td>${formatPrice(h.avg_price, prices[0].currency)}</td>
                                <td>${formatPrice(h.max_price, prices[0].currency)}</td>
                            </tr>
                        `).join('')}
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

function closeModal() {
    document.getElementById('product-modal').style.display = 'none';
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
    
    count.textContent = `${data.pagination.total} תוצאות`;
    
    const filters = [];
    if (data.filters.q) filters.push(`"${data.filters.q}"`);
    if (data.filters.category) filters.push('סינון לפי קטגוריה');
    if (data.filters.supplier) filters.push('סינון לפי ספק');
    if (data.filters.min_price || data.filters.max_price) {
        filters.push('סינון לפי מחיר');
    }
    
    query.textContent = filters.length > 0 ? filters.join(' • ') : '';
    
    info.style.display = 'flex';
}

// ===================================
// Handler Functions
// ===================================

function handleSearch() {
    currentFilters.q = document.getElementById('search-input').value.trim();
    currentFilters.category = document.getElementById('category-filter').value || null;
    currentFilters.supplier = document.getElementById('supplier-filter').value || null;
    currentFilters.min_price = document.getElementById('min-price').value || null;
    currentFilters.max_price = document.getElementById('max-price').value || null;
    currentFilters.currency = document.getElementById('currency-filter').value;
    currentFilters.sort_by = document.getElementById('sort-filter').value;
    
    searchProducts(1);
}

function clearFilters() {
    document.getElementById('search-input').value = '';
    document.getElementById('category-filter').value = '';
    document.getElementById('supplier-filter').value = '';
    document.getElementById('min-price').value = '';
    document.getElementById('max-price').value = '';
    document.getElementById('currency-filter').value = 'ILS';
    document.getElementById('sort-filter').value = 'price_asc';
    
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
    document.getElementById('products-grid').style.display = 'none';
    document.getElementById('pagination').style.display = 'none';
    document.getElementById('results-info').style.display = 'none';
}

function hideLoading() {
    document.getElementById('loading').style.display = 'none';
    document.getElementById('products-grid').style.display = 'grid';
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
    document.getElementById('no-results').style.display = 'block';
    document.getElementById('products-grid').style.display = 'none';
    document.getElementById('products-table-container').style.display = 'none';
    document.getElementById('pagination').style.display = 'none';
}

function hideNoResults() {
    document.getElementById('no-results').style.display = 'none';
    // Restore view based on currentView
    if (currentView === 'grid') {
        document.getElementById('products-grid').style.display = 'grid';
    } else {
        document.getElementById('products-table-container').style.display = 'block';
    }
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

