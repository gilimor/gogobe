// Shared navigation component
function createNavigation(activePage) {
    return `
    <nav class="main-nav">
        <div class="nav-container">
            <div class="nav-content">
                <a href="/dashboard.html" class="nav-brand">
                    <span>🛒</span>
                    <span>Gogobe</span>
                </a>
                <div class="nav-links">
                    <a href="/dashboard.html" class="nav-link ${activePage === 'dashboard' ? 'active' : ''}">🏠 דף הבית</a>
                    <a href="/" class="nav-link ${activePage === 'products' ? 'active' : ''}">📦 מוצרים</a>
                    <a href="/categories.html" class="nav-link ${activePage === 'categories' ? 'active' : ''}">📂 קטגוריות</a>
                    <a href="/stores.html" class="nav-link ${activePage === 'stores' ? 'active' : ''}">🏪 רשתות וסניפים</a>
                    <a href="/import-sources.html" class="nav-link ${activePage === 'sources' ? 'active' : ''}">📥 מקורות יבוא</a>
                    <a href="/brands.html" class="nav-link ${activePage === 'brands' ? 'active' : ''}">🏷️ מותגים</a>
                    <a href="/uncategorized.html" class="nav-link ${activePage === 'uncategorized' ? 'active' : ''}">❓ ללא קטגוריה</a>
                    <a href="/price-analytics.html" class="nav-link ${activePage === 'analytics' ? 'active' : ''}">📊 ניתוח מחירים</a>
                    <a href="/errors.html" class="nav-link ${activePage === 'errors' ? 'active' : ''}">🔍 Errors</a>
                </div>
            </div>
        </div>
    </nav>
    `;
}

// Common styles
const commonStyles = `
    .main-nav {
        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        position: sticky;
        top: 0;
        z-index: 100;
    }
    .nav-container { max-width: 1600px; margin: 0 auto; padding: 0; }
    .nav-content { display: flex; align-items: center; justify-content: space-between; padding: 12px 20px; }
    .nav-brand { color: white; font-size: 1.5rem; font-weight: bold; text-decoration: none; display: flex; align-items: center; gap: 10px; }
    .nav-links { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; }
    .nav-link { color: white; text-decoration: none; padding: 8px 16px; border-radius: 6px; transition: background 0.3s; font-size: 14px; font-weight: 500; }
    .nav-link:hover { background: rgba(255,255,255,0.2); }
    .nav-link.active { background: rgba(255,255,255,0.3); }
    
    .page-container { max-width: 1600px; margin: 0 auto; padding: 40px 20px; }
    .page-header { margin-bottom: 32px; }
    .page-title { font-size: 2rem; font-weight: bold; color: #1f2937; margin-bottom: 8px; }
    .page-description { color: #6b7280; font-size: 16px; }
    
    .data-table {
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        overflow: hidden;
    }
    
    .table-header {
        background: #f9fafb;
        padding: 20px;
        border-bottom: 2px solid #e5e7eb;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    table { width: 100%; border-collapse: collapse; }
    thead { background: #f9fafb; }
    th { padding: 12px 16px; text-align: right; font-weight: 600; color: #4b5563; font-size: 14px; border-bottom: 2px solid #e5e7eb; }
    td { padding: 12px 16px; border-bottom: 1px solid #e5e7eb; }
    tbody tr:hover { background: #f9fafb; }
`;

// Utilities
function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function formatDate(dateStr) {
    if (!dateStr) return '-';
    return new Date(dateStr).toLocaleString('he-IL');
}

function formatNumber(num) {
    return (num || 0).toLocaleString();
}

const API_BASE = 'http://localhost:8000';

