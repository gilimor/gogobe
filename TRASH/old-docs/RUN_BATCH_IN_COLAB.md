# 🚀 הרצת Batch Processor ב-Google Colab

## בעיה: Python לא עובד מקומית
## פתרון: Google Colab! (חינמי ועובד!)

---

## ⚡ צעדים (10 דקות):

### 1. גש ל-Google Colab
```
https://colab.research.google.com
```

### 2. צור Notebook חדש
- File → New notebook

### 3. העתק והדבק את הקוד (8 תאים)

---

## 📋 תא 1: התקנת ספריות

```python
!pip install -q pdfplumber pandas openpyxl
print("✅ Libraries installed!")
```

**הרץ:** Shift+Enter

---

## 📋 תא 2: העלאת PDFs

```python
from google.colab import files
import os

print("📤 Upload your PDF files (you can select multiple!):")
uploaded = files.upload()

pdf_files = [f for f in uploaded.keys() if f.lower().endswith('.pdf')]
print(f"\n✅ Uploaded {len(pdf_files)} PDF file(s):")
for f in pdf_files:
    print(f"   📄 {f}")
```

**הרץ** וב**העלה את `catalogue.pdf`** (או כמה קבצים שתרצה!)

---

## 📋 תא 3: הגדרות

```python
import pdfplumber, pandas as pd, re, json
from datetime import datetime

stats = {
    'total_pdfs': len(pdf_files),
    'processed': 0,
    'failed': 0,
    'total_products': 0,
    'total_pages': 0,
    'start_time': datetime.now(),
    'files': []
}

all_results = {}
print("✅ Setup complete!")
```

---

## 📋 תא 4: פונקציות עזר

```python
def extract_text_from_pdf(pdf_path):
    pages = []
    with pdfplumber.open(pdf_path) as pdf:
        for i, page in enumerate(pdf.pages, 1):
            text = page.extract_text()
            if text:
                pages.append({'page': i, 'text': text})
    return pages

def find_products_with_prices(text, page_num):
    products = []
    patterns = [
        (r'£([\d,]+(?:\.\d{2})?)', 'GBP'),
        (r'\$([\d,]+(?:\.\d{2})?)', 'USD'),
        (r'€([\d,]+(?:\.\d{2})?)', 'EUR'),
        (r'₪([\d,]+(?:\.\d{2})?)', 'ILS'),
    ]
    
    for pattern, currency in patterns:
        for match in re.finditer(pattern, text):
            price_str = match.group(1).replace(',', '')
            try:
                price = float(price_str)
            except:
                continue
            
            if price < 5:
                continue
            
            start = max(0, match.start() - 300)
            end = min(len(text), match.end() + 300)
            context = text[start:end]
            
            before = context[:match.start()-start]
            lines = [l.strip() for l in before.split('\n') if l.strip()]
            
            product_name = ''
            for line in reversed(lines):
                if len(line) > 10 and not re.match(r'^[£$€₪\d,.\s]+$', line):
                    product_name = line
                    break
            
            if product_name:
                products.append({
                    'page': page_num,
                    'name': product_name[:300],
                    'price': price,
                    'currency': currency
                })
    return products

def is_valid_product(name):
    exclude = ['subscription', 'magazine', 'event', 'training', 'course']
    return not any(kw in name.lower() for kw in exclude)

def clean_products(df):
    if df.empty:
        return df
    df = df.drop_duplicates(subset=['name', 'price', 'currency'])
    df = df[df['name'].str.len() > 15]
    df = df[df['price'] > 10]
    df = df[df['price'] < 100000]
    df = df[df['name'].apply(is_valid_product)]
    return df.sort_values('price', ascending=False).reset_index(drop=True)

print("✅ Functions ready!")
```

---

## 📋 תא 5: עיבוד כל הPDFs

```python
print("="*80)
print("🦷 Gogobe Batch PDF Processor")
print("="*80)

for pdf_file in pdf_files:
    print(f"\n📄 Processing: {pdf_file}")
    
    try:
        # Extract
        pages = extract_text_from_pdf(pdf_file)
        print(f"   ✅ {len(pages)} pages")
        stats['total_pages'] += len(pages)
        
        # Find products
        all_products = []
        for page in pages:
            all_products.extend(find_products_with_prices(page['text'], page['page']))
        print(f"   ✅ {len(all_products)} products found")
        
        # Clean
        df = pd.DataFrame(all_products)
        df = clean_products(df)
        print(f"   ✅ {len(df)} products cleaned")
        
        if not df.empty:
            all_results[pdf_file] = df
            stats['processed'] += 1
            stats['total_products'] += len(df)
        else:
            stats['failed'] += 1
            
    except Exception as e:
        print(f"   ❌ Error: {e}")
        stats['failed'] += 1

print("\n✅ Processing complete!")
```

---

## 📋 תא 6: סיכום

```python
duration = (datetime.now() - stats['start_time']).total_seconds()

print(f"\n{'='*80}")
print("📊 SUMMARY")
print(f"{'='*80}")
print(f"PDFs processed: {stats['processed']}/{stats['total_pdfs']}")
print(f"Total pages: {stats['total_pages']}")
print(f"Total products: {stats['total_products']}")
print(f"Time: {duration:.1f} seconds")
if stats['processed'] > 0:
    print(f"Average: {stats['total_products']/stats['processed']:.1f} products/PDF")
print(f"{'='*80}")
```

---

## 📋 תא 7: יצירת קבצים

```python
# Individual CSVs and SQLs
for pdf_name, df in all_results.items():
    base = pdf_name.replace('.pdf', '')
    
    # CSV
    df[['page', 'name', 'price', 'currency']].to_csv(f"{base}_products.csv", index=False)
    
    # SQL
    with open(f"{base}_products.sql", 'w') as f:
        f.write(f"-- {pdf_name}: {len(df)} products\n\n")
        f.write("DO $$\nDECLARE dental_id INT; cat_id INT; supp_id INT; pid BIGINT;\nBEGIN\n")
        f.write("  SELECT id INTO dental_id FROM verticals WHERE slug='dental';\n")
        f.write("  SELECT id INTO cat_id FROM categories WHERE vertical_id=dental_id LIMIT 1;\n")
        f.write(f"  INSERT INTO suppliers(name,slug) VALUES('{base}','{base.lower()}') ON CONFLICT DO NOTHING;\n")
        f.write(f"  SELECT id INTO supp_id FROM suppliers WHERE slug='{base.lower()}';\n\n")
        
        for _, row in df.iterrows():
            name = row['name'].replace("'", "''")
            f.write(f"  INSERT INTO products(name,vertical_id,category_id) VALUES('{name}',dental_id,cat_id) ON CONFLICT DO NOTHING RETURNING id INTO pid;\n")
            f.write(f"  IF pid IS NOT NULL THEN INSERT INTO prices(product_id,supplier_id,price,currency,scraped_at) VALUES(pid,supp_id,{row['price']},'{row['currency']}',NOW()); END IF;\n")
        
        f.write("END $$;\n")

# Combined files
all_dfs = []
for pdf_name, df in all_results.items():
    df_copy = df[['page','name','price','currency']].copy()
    df_copy['source'] = pdf_name.replace('.pdf', '')
    all_dfs.append(df_copy)

combined = pd.concat(all_dfs)[['source','page','name','price','currency']]
combined.to_csv('ALL_PRODUCTS_COMBINED.csv', index=False)

# Combined SQL
with open('ALL_PRODUCTS_COMBINED.sql', 'w') as f:
    f.write(f"-- Combined: {len(combined)} products from {len(all_results)} files\n\n")
    for pdf_name, df in all_results.items():
        base = pdf_name.replace('.pdf', '')
        f.write(f"\n-- {pdf_name}\n")
        f.write("DO $$\nDECLARE dental_id INT; cat_id INT; supp_id INT; pid BIGINT;\nBEGIN\n")
        f.write("  SELECT id INTO dental_id FROM verticals WHERE slug='dental';\n")
        f.write("  SELECT id INTO cat_id FROM categories WHERE vertical_id=dental_id LIMIT 1;\n")
        f.write(f"  INSERT INTO suppliers(name,slug) VALUES('{base}','{base.lower()}') ON CONFLICT DO NOTHING;\n")
        f.write(f"  SELECT id INTO supp_id FROM suppliers WHERE slug='{base.lower()}';\n\n")
        for _, row in df.iterrows():
            name = row['name'].replace("'", "''")
            f.write(f"  INSERT INTO products(name,vertical_id,category_id) VALUES('{name}',dental_id,cat_id) ON CONFLICT DO NOTHING RETURNING id INTO pid;\n")
            f.write(f"  IF pid IS NOT NULL THEN INSERT INTO prices(product_id,supplier_id,price,currency,scraped_at) VALUES(pid,supp_id,{row['price']},'{row['currency']}',NOW()); END IF;\n")
        f.write("END $$;\n\n")

print("✅ Files created!")
```

---

## 📋 תא 8: הורדה

```python
from google.colab import files

for pdf_name in all_results.keys():
    base = pdf_name.replace('.pdf', '')
    files.download(f"{base}_products.csv")
    files.download(f"{base}_products.sql")

files.download('ALL_PRODUCTS_COMBINED.csv')
files.download('ALL_PRODUCTS_COMBINED.sql')

print("🎉 Done! Check your downloads folder!")
```

---

## ✅ סיימת!

**עכשיו יש לך:**
- `catalogue_products.csv`
- `catalogue_products.sql`  
- `ALL_PRODUCTS_COMBINED.csv`
- `ALL_PRODUCTS_COMBINED.sql`

**טען לדאטהבייס:**
```powershell
psql -U postgres -d gogobe -f "ALL_PRODUCTS_COMBINED.sql"
```

---

## 🎯 יתרונות:

```yaml
✅ עובד בטוח (בלי בעיות Python)
✅ יכול להעלות כמה קבצים בבת אחת
✅ מהיר וקל
✅ חינמי
✅ תוצאות מיידיות
```

**זמן: 10-15 דקות**
**תוצאה: מאות מוצרים!** 🎉





