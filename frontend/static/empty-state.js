
// ===================================
// Empty State & Recommendations
// ===================================

function showEmptyState() {
    // Hide pagination and results info
    const pagination = document.getElementById('pagination');
    const resultsInfo = document.getElementById('results-info');
    if (pagination) pagination.style.display = 'none';
    if (resultsInfo) resultsInfo.style.display = 'none';

    // Show empty state in grid
    const grid = document.getElementById('products-grid');
    const tableContainer = document.getElementById('products-table-container');

    if (grid && currentView === 'grid') {
        grid.innerHTML = `
            <div class="empty-state-full">
                <div class="empty-state-content">
                    <div class="empty-state-icon">🔍</div>
                    <h2 class="empty-state-title">מה תרצה למצוא היום?</h2>
                    <p class="empty-state-subtitle">חפש מוצרים והשווה מחירים בין כל הרשתות</p>
                    
                    <div class="popular-categories">
                        <h3>קטגוריות פופולריות</h3>
                        <div class="category-grid">
                            ${getPopularCategories().map(cat => `
                                <div class="category-card-small" onclick="searchCategory('${cat.name}')">
                                    <div class="cat-icon">${cat.icon}</div>
                                    <div class="cat-name">${cat.name}</div>
                                </div>
                            `).join('')}
                        </div>
                    </div>
                    
                    <div class="trending-searches">
                        <h3>חיפושים פופולריים</h3>
                        <div class="trending-pills">
                            ${getTrendingSearches().map(term => `
                                <button class="trending-pill" onclick="searchTerm('${term}')">
                                    ${term}
                                </button>
                            `).join('')}
                        </div>
                    </div>
                </div>
            </div>
        `;
        grid.style.display = 'block';
    }

    if (tableContainer && currentView === 'table') {
        const tbody = document.getElementById('products-table-body');
        if (tbody) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="10" style="text-align: center; padding: 60px;">
                        <div class="empty-state-icon">🔍</div>
                        <h3>התחל לחפש כדי לראות תוצאות</h3>
                        <p>השתמש בשדה החיפוש למעלה למציאת מוצרים</p>
                    </td>
                </tr>
            `;
        }
        tableContainer.style.display = 'block';
    }
}

function getPopularCategories() {
    return [
        { name: 'חלב וביצים', icon: '🥛' },
        { name: 'לחם ומאפים', icon: '🍞' },
        { name: 'פירות וירקות', icon: '🥬' },
        { name: 'בשר ודגים', icon: '🍖' },
        { name: 'משקאות', icon: '🥤' },
        { name: 'חטיפים וממתקים', icon: '🍫' },
        { name: 'מוצרי ניקיון', icon: '🧹' },
        { name: 'קוסמטיקה', icon: '💄' }
    ];
}

function getTrendingSearches() {
    return [
        'חלב תנובה',
        'לחם שחור',
        'קפה עלית',
        'שמן זית',
        'אורז',
        'ביצים',
        'סוכר',
        'קמח'
    ];
}

function searchCategory(categoryName) {
    document.getElementById('search-input').value = categoryName;
    handleSearch();
}

function searchTerm(term) {
    document.getElementById('search-input').value = term;
    handleSearch();
}
