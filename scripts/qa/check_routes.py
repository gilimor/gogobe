"""
Check API routes consistency
Verifies that all HTML files have corresponding routes in main.py
"""

import os
import re
from pathlib import Path

def get_html_files():
    """Get all HTML files in frontend/"""
    frontend_path = Path("frontend")
    return list(frontend_path.glob("*.html"))

def get_api_routes():
    """Extract routes from main.py"""
    main_py = Path("backend/api/main.py")
    content = main_py.read_text(encoding='utf-8')
    
    # Find all @app.get routes
    routes = re.findall(r'@app\.get\("([^"]+)"\)', content)
    return routes

def main():
    print("\n=== API Routes Consistency Check ===\n")
    
    html_files = get_html_files()
    api_routes = get_api_routes()
    
    errors = []
    
    for html_file in html_files:
        filename = html_file.name
        
        # Skip index.html (it's served at "/")
        if filename == "index.html":
            if "/" not in api_routes:
                errors.append(f"❌ Missing route for '/' (index.html)")
            else:
                print(f"✓ index.html → /")
            continue
        
        # Check if route exists
        route = f"/{filename}"
        if route in api_routes:
            print(f"✓ {filename} → {route}")
        else:
            errors.append(f"❌ Missing route for {filename} in main.py")
            print(f"❌ {filename} - NO ROUTE")
    
    # Check for orphaned routes
    html_names = [f.name for f in html_files]
    for route in api_routes:
        if route == "/":
            continue
        if route.endswith(".html"):
            html_name = route.lstrip("/")
            if html_name not in html_names:
                errors.append(f"⚠️ Route {route} exists but file not found")
                print(f"⚠️ {route} - FILE NOT FOUND")
    
    print("\n=== Summary ===")
    print(f"HTML files: {len(html_files)}")
    print(f"API routes: {len(api_routes)}")
    print(f"Errors: {len(errors)}")
    
    if errors:
        print("\n=== Errors ===")
        for error in errors:
            print(error)
        print("\n❌ CHECKS FAILED")
        return 1
    else:
        print("\n✅ ALL CHECKS PASSED")
        return 0

if __name__ == "__main__":
    exit(main())

