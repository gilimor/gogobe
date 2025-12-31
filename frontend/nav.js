/**
 * Gogobe Master Navigation
 * Injects a unified, comprehensive navbar into all pages.
 */

document.addEventListener("DOMContentLoaded", function () {
    // 1. Clean up existing/old nav elements to prevent duplication
    const oldNav = document.querySelector('nav:not(.keep-nav)');
    if (oldNav) oldNav.remove();
    const oldTag = document.querySelector('main-nav');
    if (oldTag) oldTag.remove();

    // 2. Identify current page for 'active' state highlighting
    const path = window.location.pathname;
    const isActive = (p) => (path === p || path.endsWith(p) || (path === '/' && p === 'index.html')) ? 'text-blue-600 bg-blue-50 font-bold' : 'text-slate-600 hover:text-blue-600 hover:bg-slate-50';

    // 3. Inject Tailwind CDN if missing (Self-Healing)
    if (!document.querySelector('script[src*="tailwindcss"]')) {
        const tw = document.createElement('script');
        tw.src = "https://cdn.tailwindcss.com";
        document.head.appendChild(tw);
    }

    // 4. Inject FontAwesome if missing
    if (!document.querySelector('link[href*="font-awesome"]')) {
        const fa = document.createElement('link');
        fa.rel = "stylesheet";
        fa.href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css";
        document.head.appendChild(fa);
    }

    // 5. The Navbar HTML Structure
    const navHTML = `
    <div id="gogobe-master-nav" class="fixed top-0 left-0 right-0 h-16 bg-white/95 backdrop-blur-md border-b border-slate-200 shadow-sm flex items-center justify-between px-6 z-[99999] font-sans transition-all duration-300">
        
        <!-- Left: Branding -->
        <a href="/" class="flex items-center gap-3 group decoration-0">
            <div class="w-9 h-9 bg-gradient-to-br from-blue-600 to-blue-700 text-white rounded-xl flex items-center justify-center font-black text-xl shadow-lg shadow-blue-500/30 group-hover:scale-105 transition">G</div>
            <div class="flex flex-col leading-none">
                <span class="font-black text-lg tracking-tight text-slate-800">GOGOBE</span>
                <span class="text-[0.6rem] font-bold text-blue-500 uppercase tracking-widest">Intelligence</span>
            </div>
        </a>

        <!-- Center: Main Menu (Desktop) -->
        <div class="hidden lg:flex items-center gap-1 bg-slate-50/50 p-1 rounded-lg border border-slate-100/50">
            
            <a href="/" class="px-4 py-2 rounded-md text-sm transition ${isActive('index.html')}">
                <i class="fas fa-home opacity-70"></i> ראשי
            </a>
            
            <a href="/dashboard.html" class="px-4 py-2 rounded-md text-sm transition ${isActive('dashboard.html')}">
                <i class="fas fa-chart-pie opacity-70"></i> דשבורד
            </a>

            <!-- Dropdown: Explore -->
            <div class="relative group h-full flex items-center">
                <button class="px-4 py-2 rounded-md text-sm text-slate-600 hover:text-blue-600 hover:bg-slate-50 transition flex items-center gap-2 h-10">
                    <i class="fas fa-search opacity-70"></i> גלה <i class="fas fa-chevron-down text-xs opacity-50"></i>
                </button>
                <!-- Added pt-4 to bridge the gap -->
                <div class="absolute top-10 left-0 pt-4 w-48 hidden group-hover:block transition-all duration-200 ease-in-out">
                    <div class="bg-white border border-slate-100 rounded-xl shadow-xl p-2 animate-in fade-in slide-in-from-top-2">
                        <a href="/products.html" class="block px-3 py-2 rounded text-sm text-slate-600 hover:bg-slate-50 hover:text-blue-600 mb-1">
                            <i class="fas fa-box w-5"></i> מוצרים
                        </a>
                        <a href="/prices.html" class="block px-3 py-2 rounded text-sm text-slate-600 hover:bg-slate-50 hover:text-blue-600 mb-1">
                            <i class="fas fa-tags w-5"></i> מחירים
                        </a>
                        <a href="/trends.html" class="block px-3 py-2 rounded text-sm text-slate-600 hover:bg-slate-50 hover:text-blue-600 mb-1">
                            <i class="fas fa-chart-line w-5"></i> מגמות
                        </a>
                        <a href="/map.html" class="block px-3 py-2 rounded text-sm text-slate-600 hover:bg-slate-50 hover:text-blue-600">
                            <i class="fas fa-map w-5"></i> מפה
                        </a>
                    </div>
                </div>
            </div>

            <!-- Dropdown: System -->
            <div class="relative group h-full flex items-center">
                <button class="px-4 py-2 rounded-md text-sm text-slate-600 hover:text-blue-600 hover:bg-slate-50 transition flex items-center gap-2 h-10">
                    <i class="fas fa-cogs opacity-70"></i> ניהול <i class="fas fa-chevron-down text-xs opacity-50"></i>
                </button>
                <!-- Added pt-4 and right-0 alignment -->
                <div class="absolute top-10 right-0 pt-4 w-56 hidden group-hover:block transition-all duration-200 ease-in-out">
                    <div class="bg-white border border-slate-100 rounded-xl shadow-xl p-2 animate-in fade-in slide-in-from-top-2">
                        <div class="px-3 py-2 text-xs font-bold text-slate-400 uppercase tracking-wider">תשתית</div>
                        <a href="/sources.html" class="block px-3 py-2 rounded text-sm text-slate-600 hover:bg-slate-50 hover:text-blue-600 mb-1">
                            <i class="fas fa-server w-5 text-amber-500"></i> מקורות (Scrapers)
                        </a>
                        <a href="/stores.html" class="block px-3 py-2 rounded text-sm text-slate-600 hover:bg-slate-50 hover:text-blue-600 mb-1">
                            <i class="fas fa-store w-5 text-purple-500"></i> סניפים
                        </a>
                        <div class="h-px bg-slate-100 my-1"></div>
                        <div class="px-3 py-2 text-xs font-bold text-slate-400 uppercase tracking-wider">ניטור</div>
                        <a href="/master_products.html" class="block px-3 py-2 rounded text-sm text-slate-600 hover:bg-slate-50 hover:text-blue-600 mb-1">
                            <i class="fas fa-cubes w-5 text-indigo-500"></i> Master Products
                        </a>
                        <a href="/import-logs.html" class="block px-3 py-2 rounded text-sm text-slate-600 hover:bg-slate-50 hover:text-blue-600 mb-1">
                            <i class="fas fa-list-alt w-5 text-gray-400"></i> לוגים
                        </a>
                        <a href="/operations.html" class="block px-3 py-2 rounded text-sm text-slate-600 hover:bg-slate-50 hover:text-blue-600">
                            <i class="fas fa-cogs w-5 text-blue-400"></i> תפעול (Operations)
                        </a>
                    </div>
                </div>
            </div>

        </div>

        <!-- Right: Status -->
        <div class="flex items-center gap-4">
            <div class="hidden md:flex flex-col items-end">
                <div class="flex items-center gap-2 text-xs font-bold text-emerald-600 bg-emerald-50 px-3 py-1 rounded-full border border-emerald-100">
                    <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span> ONLINE
                </div>
            </div>
        </div>

    </div>
    
    <!-- Spacers to prevent content overlap -->
    <div style="height: 64px;"></div>
    `;

    // 6. Inject into DOM
    const div = document.createElement('div');
    div.innerHTML = navHTML;
    document.body.prepend(div);

});
