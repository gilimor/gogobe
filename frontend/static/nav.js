// Main Navigation Component
class MainNav extends HTMLElement {
    connectedCallback() {
        this.innerHTML = `
            <nav class="main-nav">
                <div class="nav-container">
                    <div class="nav-content">
                        <a href="/" class="nav-brand">
                            <span>🔍</span>
                            <span>Gogobe</span>
                        </a>
                        <div class="nav-links">
                            <a href="/" class="nav-link active">🏠 דף הבית</a>
                            <a href="/dashboard.html" class="nav-link">📊 דשבורד</a>
                            <a href="/map.html" class="nav-link">🗺️ מפת חנויות</a>
                            <a href="/data-sources.html" class="nav-link">📂 מקורות מידע</a>
                            <a href="/api/docs" class="nav-link">📚 API</a>
                            <a href="/docs/" class="nav-link" target="_blank">📖 תיעוד טכני</a>
                            <a href="/admin.html" class="nav-link">⚙️ ניהול</a>
                        </div>
                    </div>
                </div>
            </nav>
        `;

        // Set active link based on current path
        this.setActiveLink();
    }

    setActiveLink() {
        const currentPath = window.location.pathname;
        const links = this.querySelectorAll('.nav-link');

        links.forEach(link => {
            link.classList.remove('active');
            const href = link.getAttribute('href');

            if (href === currentPath ||
                (href !== '/' && currentPath.startsWith(href))) {
                link.classList.add('active');
            }
        });
    }
}

customElements.define('main-nav', MainNav);
