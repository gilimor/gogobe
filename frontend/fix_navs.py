
import os
import re

files_to_fix = [
    'map.html',
    'product.html',
    'prices.html',
    'stores.html',
    'sources.html',
    'import-logs.html',
    'tasks.html'
]

def fix_file(filename):
    if not os.path.exists(filename):
        print(f"Skipping {filename} (not found)")
        return

    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Remove legacy nav styles/html if easy to identify
    # Remove <main-nav>...</main-nav>
    content = re.sub(r'<main-nav>.*?</main-nav>', '', content, flags=re.DOTALL)
    
    # Remove old script ref
    content = content.replace('<script src="/static/nav.js"></script>', '')
    content = content.replace('<script src="static/nav.js"></script>', '')
    
    # 2. Inject new script if not present
    if 'src="nav.js"' not in content:
        if '</head>' in content:
            content = content.replace('</head>', '<script src="nav.js" defer></script>\n</head>')
        else:
            # Fallback
            content = content + '\n<script src="nav.js" defer></script>'
            
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Fixed {filename}")

if __name__ == "__main__":
    for f in files_to_fix:
        fix_file(f)
