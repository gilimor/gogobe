
// ===================================
// Smart Basket Functions
// ===================================

let smartBasket = JSON.parse(localStorage.getItem('smartBasket')) || [];

function addToBasket(productId, productName, price) {
    const existing = smartBasket.find(item => item.id === productId);

    if (existing) {
        // Remove if already in basket
        smartBasket = smartBasket.filter(item => item.id !== productId);
        showToast(`הוסר מהסל: ${productName}`);
    } else {
        // Add to basket
        smartBasket.push({
            id: productId,
            name: productName,
            price: price,
            addedAt: new Date().toISOString()
        });
        showToast(`נוסף לסל: ${productName} 🛒`);
    }

    // Save to localStorage
    localStorage.setItem('smartBasket', JSON.stringify(smartBasket));

    // Update UI
    updateBasketCount();
    updateBasketButtons();
}

function updateBasketCount() {
    const countElem = document.getElementById('basket-count');
    if (countElem) {
        if (smartBasket.length > 0) {
            countElem.textContent = smartBasket.length;
            countElem.style.display = 'flex';
        } else {
            countElem.style.display = 'none';
        }
    }
}

function updateBasketButtons() {
    smartBasket.forEach(item => {
        const btn = document.querySelector(`.add-to-basket[data-product-id="${item.id}"]`);
        if (btn) {
            btn.classList.add('added');
        }
    });
}

function openBasket() {
    if (smartBasket.length === 0) {
        showToast('הסל ריק - הוסף מוצרים כדי למצוא את השילוב הכי זול! 🛒');
        return;
    }

    // Show basket modal
    showBasketModal();
}

function showBasketModal() {
    const modal = document.getElementById('product-modal');
    const body = document.getElementById('modal-body');

    if (!modal || !body) return;

    const totalItems = smartBasket.length;
    const totalPrice = smartBasket.reduce((sum, item) => sum + item.price, 0);

    body.innerHTML = `
        <h2>🛒 הסל החכם שלי</h2>
        
        <div class="basket-summary">
            <div class="basket-stat">
                <span class="stat-value">${totalItems}</span>
                <span class="stat-label">מוצרים</span>
            </div>
            <div class="basket-stat">
                <span class="stat-value">${formatPrice(totalPrice, 'ILS')}</span>
                <span class="stat-label">סה"כ משוער</span>
            </div>
        </div>
        
        <div class="basket-items">
            ${smartBasket.map(item => `
                <div class="basket-item">
                    <div class="basket-item-name">${escapeHtml(item.name)}</div>
                    <div class="basket-item-price">${formatPrice(item.price, 'ILS')}</div>
                    <button onclick="removeFromBasket(${item.id})" class="basket-item-remove">🗑️</button>
                </div>
            `).join('')}
        </div>
        
        <div class="basket-actions">
            <button onclick="findBestDeal()" class="btn-primary">🎯 מצא לי את העסקה הטובה ביותר!</button>
            <button onclick="clearBasket()" class="btn-secondary">🗑️ רוקן סל</button>
        </div>
        
        <div id="best-deal-result" style="display: none; margin-top: 20px;"></div>
    `;

    modal.style.display = 'flex';
}

function removeFromBasket(productId) {
    smartBasket = smartBasket.filter(item => item.id !== productId);
    localStorage.setItem('smartBasket', JSON.stringify(smartBasket));
    updateBasketCount();

    if (smartBasket.length === 0) {
        closeModal();
        showToast('הסל רוקן');
    } else {
        showBasketModal(); // Refresh
    }
}

function clearBasket() {
    if (confirm('האם אתה בטוח שתרצה לרוקן את הסל?')) {
        smartBasket = [];
        localStorage.setItem('smartBasket', JSON.stringify(smartBasket));
        updateBasketCount();
        closeModal();
        showToast('הסל רוקן');
    }
}

async function findBestDeal() {
    const resultDiv = document.getElementById('best-deal-result');
    if (!resultDiv) return;

    resultDiv.innerHTML = '<div class="loading">מחשב...</div>';
    resultDiv.style.display = 'block';

    try {
        // Call Smart Basket API
        const response = await fetch(`${API_BASE}/api/smart-basket/optimize`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                products: smartBasket.map(item => item.id)
            })
        });

        const result = await response.json();

        if (result.recommendations && result.recommendations.length > 0) {
            resultDiv.innerHTML = `
                <h3>💡 המלצות חכמות:</h3>
                ${result.recommendations.map((rec, idx) => `
                    <div class="recommendation-card">
                        <div class="rec-header">
                            <span class="rec-rank">#${idx + 1}</span>
                            <span class="rec-store">${rec.store_name}</span>
                            <span class="rec-savings">${rec.savings > 0 ? `חסכון: ₪${rec.savings.toFixed(2)}` : ''}</span>
                        </div>
                        <div class="rec-details">
                            <div>סה"כ: <strong>${formatPrice(rec.total_price, 'ILS')}</strong></div>
                            <div>${rec.items_available}/${totalItems} מוצרים זמינים</div>
                            ${rec.distance ? `<div>מרחק: ${rec.distance.toFixed(1)} ק"מ</div>` : ''}
                        </div>
                    </div>
                `).join('')}
            `;
        } else {
            resultDiv.innerHTML = '<p>לא נמצאו המלצות. נסה להוסיף עוד מוצרים.</p>';
        }
    } catch (error) {
        resultDiv.innerHTML = `
            <div class="error-message">
                ⚠️ השירות בפיתוח. בקרוב תוכל למצוא את העסקה הטובה ביותר!
            </div>
        `;
    }
}

// Toast notifications
function showToast(message, duration = 3000) {
    // Remove existing toast
    const existingToast = document.querySelector('.toast');
    if (existingToast) {
        existingToast.remove();
    }

    // Create new toast
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.textContent = message;
    document.body.appendChild(toast);

    // Show
    setTimeout(() => toast.classList.add('show'), 100);

    // Hide and remove
    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 300);
    }, duration);
}

// Initialize basket on page load
document.addEventListener('DOMContentLoaded', () => {
    updateBasketCount();
});
