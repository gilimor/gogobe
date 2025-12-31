/**
 * Performance & UX Enhancements
 * Debouncing, Autocomplete, Infinite Scroll, Collapsible Filters
 */

// Debounce utility
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Autocomplete functionality
let autocompleteCache = {};
let currentAutocompleteRequest = null;

const debouncedAutocomplete = debounce(async (query) => {
    if (query.length < 2) {
        hideAutocomplete();
        return;
    }

    // Check cache
    if (autocompleteCache[query]) {
        showAutocomplete(autocompleteCache[query]);
        return;
    }

    // Cancel previous request
    if (currentAutocompleteRequest) {
        currentAutocompleteRequest.abort();
    }

    // Show loading
    showAutocompleteLoading();

    try {
        currentAutocompleteRequest = new AbortController();
        const response = await fetch(`${API_BASE}/api/products/search?q=${encodeURIComponent(query)}&per_page=5`, {
            signal: currentAutocompleteRequest.signal
        });

        const data = await response.json();

        // Cache results
        autocompleteCache[query] = data.products || [];

        showAutocomplete(data.products || []);
    } catch (error) {
        if (error.name !== 'AbortError') {
            console.error('Autocomplete error:', error);
            hideAutocomplete();
        }
    }
}, 300);

function showAutocompleteLoading() {
    const autocomplete = document.querySelector('.search-autocomplete');
    if (!autocomplete) createAutocomplete();

    const ac = document.querySelector('.search-autocomplete');
    ac.innerHTML = '<div class="autocomplete-loading">מחפש...</div>';
    ac.classList.add('active');
}

function showAutocomplete(products) {
    const autocomplete = document.querySelector('.search-autocomplete');
    if (!autocomplete) createAutocomplete();

    const ac = document.querySelector('.search-autocomplete');

    if (products.length === 0) {
        ac.innerHTML = '<div class="autocomplete-loading">לא נמצאו תוצאות</div>';
        ac.classList.add('active');
        return;
    }

    ac.innerHTML = products.map(product => `
        <div class="autocomplete-item" onclick="selectAutocompleteItem(${product.id}, '${escapeHtml(product.name).replace(/'/g, "\\'")}')">
            <span class="autocomplete-item-name">${escapeHtml(product.name)}</span>
            <span class="autocomplete-item-price">${formatPrice(product.min_price, 'ILS')}</span>
        </div>
    `).join('');

    ac.classList.add('active');
}

function hideAutocomplete() {
    const autocomplete = document.querySelector('.search-autocomplete');
    if (autocomplete) {
        autocomplete.classList.remove('active');
    }
}

function createAutocomplete() {
    const searchBox = document.querySelector('.search-box');
    if (!searchBox) return;

    const autocomplete = document.createElement('div');
    autocomplete.className = 'search-autocomplete';
    searchBox.parentElement.appendChild(autocomplete);

    // Close on click outside
    document.addEventListener('click', (e) => {
        if (!searchBox.contains(e.target) && !autocomplete.contains(e.target)) {
            hideAutocomplete();
        }
    });
}

function selectAutocompleteItem(productId, productName) {
    document.getElementById('search-input').value = productName;
    hideAutocomplete();
    handleSearch();
}

// Collapsible Filters
function setupCollapsibleFilters() {
    const filtersSection = document.querySelector('.filters');
    if (!filtersSection) return;

    // Wrap filters
    const wrapper = document.createElement('div');
    wrapper.className = 'filters-container';

    const header = document.createElement('div');
    header.className = 'filters-header';
    header.innerHTML = `
        <h3>🔍 סינון מתקדם</h3>
        <button class="filters-toggle">הסתר פילטרים</button>
    `;

    const body = document.createElement('div');
    body.className = 'filters-body';

    // Move filters into body
    filtersSection.parentElement.insertBefore(wrapper, filtersSection);
    body.appendChild(filtersSection);
    wrapper.appendChild(header);
    wrapper.appendChild(body);

    // Toggle functionality
    const toggleBtn = header.querySelector('.filters-toggle');
    toggleBtn.addEventListener('click', () => {
        body.classList.toggle('collapsed');
        toggleBtn.textContent = body.classList.contains('collapsed') ?
            'הצג פילטרים' : 'הסתר פילטרים';
    });

    // Start collapsed on mobile
    if (window.innerWidth < 768) {
        body.classList.add('collapsed');
        toggleBtn.textContent = 'הצג פילטרים';
    }
}

// Skeleton Loaders
function showSkeletonLoaders(count = 6) {
    const grid = document.getElementById('products-grid');
    if (!grid) return;

    grid.innerHTML = '';
    grid.classList.add('skeleton-grid');

    for (let i = 0; i < count; i++) {
        const skeleton = document.createElement('div');
        skeleton.className = 'skeleton skeleton-card';
        grid.appendChild(skeleton);
    }
}

function hideSkeletonLoaders() {
    const grid = document.getElementById('products-grid');
    if (grid) {
        grid.classList.remove('skeleton-grid');
    }
}

// Infinite Scroll
let isLoadingMore = false;
let hasMoreResults = true;

function setupInfiniteScroll() {
    window.addEventListener('scroll', debounce(() => {
        if (isLoadingMore || !hasMoreResults) return;

        const scrollPosition = window.innerHeight + window.scrollY;
        const threshold = document.documentElement.offsetHeight - 500; // 500px before bottom

        if (scrollPosition >= threshold) {
            loadMoreResults();
        }
    }, 200));
}

async function loadMoreResults() {
    if (isLoadingMore || !hasMoreResults) return;

    isLoadingMore = true;
    showLoadingIndicator();

    try {
        currentPage++;
        const response = await fetch(buildSearchURL(currentPage));
        const data = await response.json();

        if (data.products && data.products.length > 0) {
            appendProducts(data.products);

            if (!data.pagination || !data.pagination.has_next) {
                hasMoreResults = false;
                showEndMessage();
            }
        } else {
            hasMoreResults = false;
            showEndMessage();
        }
    } catch (error) {
        console.error('Load more error:', error);
    } finally {
        isLoadingMore = false;
        hideLoadingIndicator();
    }
}

function appendProducts(products) {
    const container = currentView === 'grid' ?
        document.getElementById('products-grid') :
        document.getElementById('products-table-body');

    if (!container) return;

    products.forEach(product => {
        const element = currentView === 'grid' ?
            createProductCard(product) :
            createProductRow(product);

        element.classList.add('fade-in');
        container.appendChild(element);
    });
}

function showLoadingIndicator() {
    let indicator = document.querySelector('.infinite-scroll-loading');
    if (!indicator) {
        indicator = document.createElement('div');
        indicator.className = 'infinite-scroll-loading';
        indicator.innerHTML = '<div class="spinner"></div><p>טוען עוד תוצאות...</p>';
        document.querySelector('.results-section').appendChild(indicator);
    }
    indicator.style.display = 'block';
}

function hideLoadingIndicator() {
    const indicator = document.querySelector('.infinite-scroll-loading');
    if (indicator) {
        indicator.style.display = 'none';
    }
}

function showEndMessage() {
    let message = document.querySelector('.infinite-scroll-end');
    if (!message) {
        message = document.createElement('div');
        message.className = 'infinite-scroll-end';
        message.innerHTML = '✓ זהו! הצגת את כל התוצאות';
        document.querySelector('.results-section').appendChild(message);
    }
    message.style.display = 'block';
}

// Quick Filters (Popular categories)
function setupQuickFilters() {
    const popularCategories = [
        { name: 'חלב וביצים', icon: '🥛' },
        { name: 'לחם ומאפים', icon: '🍞' },
        { name: 'פירות וירקות', icon: '🥬' },
        { name: 'בשר ודגים', icon: '🍖' },
        { name: 'משקאות', icon: '🥤' },
        { name: 'חטיפים', icon: '🍫' }
    ];

    const container = document.querySelector('.search-section .container');
    if (!container) return;

    const quickFilters = document.createElement('div');
    quickFilters.className = 'quick-filters';
    quickFilters.innerHTML = popularCategories.map(cat => `
        <button class="quick-filter-pill" onclick="applyQuickFilter('${cat.name}')">
            ${cat.icon} ${cat.name}
        </button>
    `).join('');

    container.appendChild(quickFilters);
}

function applyQuickFilter(categoryName) {
    document.getElementById('search-input').value = categoryName;
    handleSearch();

    // Highlight active pill
    document.querySelectorAll('.quick-filter-pill').forEach(pill => {
        pill.classList.toggle('active', pill.textContent.includes(categoryName));
    });
}

// Enhanced Search with debouncing
const debouncedSearch = debounce(() => {
    currentPage = 1;
    hasMoreResults = true;
    searchProducts();
}, 500);

// Override handleSearch to use debounced version
const originalHandleSearch = handleSearch;
handleSearch = function () {
    // Reset infinite scroll
    currentPage = 1;
    hasMoreResults = true;

    // Remove end message if exists
    const endMsg = document.querySelector('.infinite-scroll-end');
    if (endMsg) endMsg.remove();

    originalHandleSearch();
};

// Initialize on DOMContentLoaded
document.addEventListener('DOMContentLoaded', () => {
    setupCollapsibleFilters();
    setupQuickFilters();
    setupInfiniteScroll();
    createAutocomplete();

    // Add autocomplete to search input
    const searchInput = document.getElementById('search-input');
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            debouncedAutocomplete(e.target.value);
        });
    }

    console.log('✨ Performance enhancements loaded');
});
