/**
 * Lazy Loading for Filters
 * Load categories and suppliers only when user opens filters
 */

let filtersLoaded = false;
let filtersExpanded = true; // Start expanded by default

// Override setupCollapsibleFilters from performance.js
const originalSetupCollapsible = window.setupCollapsibleFilters;

window.setupCollapsibleFilters = function () {
    // Call original if exists
    if (originalSetupCollapsible) {
        originalSetupCollapsible();
    }

    const filtersSection = document.querySelector('.filters');
    if (!filtersSection) return;

    // Find or create wrapper
    let wrapper = filtersSection.closest('.filters-container');
    if (!wrapper) return;

    const toggleBtn = wrapper.querySelector('.filters-toggle');
    const body = wrapper.querySelector('.filters-body');

    if (toggleBtn && body) {
        toggleBtn.addEventListener('click', () => {
            const isCollapsed = body.classList.contains('collapsed');

            // If expanding and filters not loaded yet
            if (isCollapsed && !filtersLoaded) {
                loadFiltersData();
            }

            filtersExpanded = !isCollapsed;
        });

        // Load on first open if starting collapsed
        if (body.classList.contains('collapsed') && !filtersLoaded) {
            // Will load when user clicks to expand
        } else if (!filtersLoaded) {
            // If starting expanded, load immediately
            loadFiltersData();
        }
    }
};

async function loadFiltersData() {
    if (filtersLoaded) return;

    console.log('📦 Loading filters data...');
    filtersLoaded = true;

    try {
        // Load categories and suppliers in parallel
        await Promise.all([
            loadCategories(),
            loadSuppliers()
        ]);
        console.log('✅ Filters data loaded');
    } catch (error) {
        console.error('❌ Error loading filters:', error);
        filtersLoaded = false; // Allow retry
    }
}

// Also load filters when user focuses on a filter dropdown
document.addEventListener('DOMContentLoaded', () => {
    const filterSelects = ['category-filter', 'supplier-filter'];

    filterSelects.forEach(id => {
        const select = document.getElementById(id);
        if (select) {
            select.addEventListener('focus', () => {
                if (!filtersLoaded) {
                    loadFiltersData();
                }
            }, { once: true }); // Only trigger once
        }
    });
});
