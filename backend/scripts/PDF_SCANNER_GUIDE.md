# 📄 PDF Magazine Scanner - מדריך מלא

**סריקת מגזינים דנטליים לחילוץ מוצרים ומחירים**

---

## 🎯 המטרה

לחלץ מאות/אלפי מוצרים דנטליים ממגזינים PDF אוטומטית!

---

## 🚀 שיטה 1: Google Colab (מומלץ!)

### צעד 1: פתח Colab

```
https://colab.research.google.com
```

### צעד 2: צור Notebook חדש

לחץ: `File → New Notebook`

### צעד 3: העתק את הקוד הזה

```python
# התקנת ספריות
!pip install -q pdfplumber pandas

import re
import pandas as pd
import pdfplumber
from google.colab import files

print("✅ Ready to scan PDFs!")
```

הרץ התא (Shift+Enter)

---

### צעד 4: העלה PDF

```python
# העלאת PDF
uploaded = files.upload()
pdf_path = list(uploaded.keys())[0]
print(f"✅ Uploaded: {pdf_path}")
```

בחר את הPDF שלך (Dentistry Magazine)

---

### צעד 5: חילוץ טקסט

```python
def extract_text_from_pdf(pdf_path):
    """חילוץ טקסט מכל עמוד"""
    pages_text = []
    
    with pdfplumber.open(pdf_path) as pdf:
        print(f"📄 PDF has {len(pdf.pages)} pages")
        
        for i, page in enumerate(pdf.pages, 1):
            text = page.extract_text()
            pages_text.append({
                'page': i,
                'text': text
            })
            print(f"   Page {i}: {len(text)} chars")
    
    return pages_text

# חילוץ
pages = extract_text_from_pdf(pdf_path)
print(f"\\n✅ Extracted {len(pages)} pages")
```

---

### צעד 6: מציאת מוצרים

```python
def find_products_with_prices(text):
    """מציאת מוצרים עם מחירים"""
    products = []
    
    # חיפוש מחירים: £XX.XX או £X,XXX
    price_pattern = r'£([\\d,]+(?:\\.\\d{2})?)'
    
    for match in re.finditer(price_pattern, text):
        price_str = match.group(1).replace(',', '')
        price = float(price_str)
        
        # הקשר סביב המחיר
        start = max(0, match.start() - 300)
        end = min(len(text), match.end() + 300)
        context = text[start:end]
        
        # שורות לפני המחיר (שם המוצר)
        before = context[:match.start()-start]
        lines = before.split('\\n')
        product_name = ''
        
        # נסה למצוא שורה עם שם מוצר
        for line in reversed(lines):
            line = line.strip()
            if len(line) > 10 and not line.startswith('£'):
                product_name = line
                break
        
        if product_name:
            products.append({
                'name': product_name,
                'price': price,
                'currency': 'GBP',
                'context': context[:200]
            })
    
    return products

# חילוץ מכל העמודים
all_products = []
for page_data in pages:
    products = find_products_with_prices(page_data['text'])
    for p in products:
        p['page'] = page_data['page']
    all_products.extend(products)

print(f"✅ Found {len(all_products)} products!")
```

---

### צעד 7: הצגה וניקוי

```python
# המרה ל-DataFrame
df = pd.DataFrame(all_products)
df = df[['page', 'name', 'price', 'currency']]

# ניקוי
df = df.drop_duplicates(subset=['name', 'price'])
df = df[df['name'].str.len() > 15]  # רק שמות ארוכים
df = df[df['price'] > 10]  # מחיר מעל £10
df = df.sort_values('price', ascending=False)

print(f"✅ {len(df)} products after cleaning\\n")
print(df.head(20))
```

---

### צעד 8: ייצוא

```python
# שמירה ל-CSV
csv_file = 'dental_products_extracted.csv'
df.to_csv(csv_file, index=False)
print(f"✅ Saved to {csv_file}")

# הורדה
files.download(csv_file)
```

---

### צעד 9: יצירת SQL

```python
def generate_sql(df):
    """יצירת SQL INSERT statements"""
    sql_lines = [
        "-- Products extracted from PDF magazine",
        "-- Run in PostgreSQL gogobe database\\n"
    ]
    
    for _, row in df.iterrows():
        name = row['name'].replace("'", "''")
        price = row['price']
        
        sql = f'''
-- {name}
INSERT INTO products (name, vertical_id, description, is_active)
VALUES (
    '{name}',
    (SELECT id FROM verticals WHERE slug = 'dental'),
    'Extracted from magazine PDF',
    TRUE
)
ON CONFLICT DO NOTHING
RETURNING id;

INSERT INTO prices (product_id, supplier_id, price, currency, scraped_at)
SELECT 
    (SELECT id FROM products WHERE name = '{name}' LIMIT 1),
    (SELECT id FROM suppliers WHERE slug = 'dental-directory' LIMIT 1),
    {price},
    'GBP',
    NOW()
WHERE EXISTS (SELECT 1 FROM products WHERE name = '{name}');

'''
        sql_lines.append(sql)
    
    return '\\n'.join(sql_lines)

# יצירת SQL
sql_content = generate_sql(df)

# שמירה
sql_file = 'load_extracted_products.sql'
with open(sql_file, 'w', encoding='utf-8') as f:
    f.write(sql_content)

print(f"✅ Generated SQL file")
print(f"\\nPreview:\\n{sql_content[:500]}...")

# הורדה
files.download(sql_file)
```

---

### צעד 10: סיכום

```python
print("="*60)
print("📊 EXTRACTION SUMMARY")
print("="*60)
print(f"Pages processed: {len(pages)}")
print(f"Products found: {len(all_products)}")
print(f"After cleaning: {len(df)}")
print(f"\\nPrice range: £{df['price'].min():.2f} - £{df['price'].max():.2f}")
print(f"Average price: £{df['price'].mean():.2f}")
print(f"Total value: £{df['price'].sum():.2f}")
print("="*60)
print("\\n✅ Files downloaded:")
print("   1. dental_products_extracted.csv")
print("   2. load_extracted_products.sql")
print("\\n🚀 Next: Run SQL in your database!")
```

---

## 🎯 שיטה 2: Claude Vision (מהיר!)

### אם יש לך גישה ל-Claude:

1. **גש ל:** https://claude.ai

2. **העלה PDF**

3. **שאל:**
```
Extract all dental products with prices from this PDF magazine.

Format as CSV with columns:
- Product Name
- Price (GBP)
- Supplier
- Description
- Page Number

Focus on actual dental equipment, not services or events.
```

4. **Claude יחזיר CSV מוכן!**

5. **שמור כקובץ** → טען ישירות

---

## 🎯 שיטה 3: ידני + AI (פשוט)

### אם אין Colab:

1. **המר PDF לטקסט:**
   - https://pdftotext.com
   - העלה PDF
   - הורד TXT

2. **העתק לClaude/ChatGPT:**
```
Here is text from a dental magazine.
Extract all products with prices.
Format as CSV.
```

3. **שמור CSV**

4. **טען ל-Excel → עדכן → ייצא SQL**

---

## 📊 תוצאה צפויה

```yaml
ממגזין דנטלי ממוצע:
  📄 20-50 עמודים
  🦷 50-200 מוצרים
  💰 £10,000-£500,000 סכום מחירים
  ⏱️ 5-10 דקות עיבוד

מ-10 מגזינים:
  🦷 500-2,000 מוצרים
  💾 ~100MB נתונים
  🚀 דרך מהירה ל-50GB!
```

---

## 🔄 אוטומציה

### לסריקה אוטומטית של מגזינים חדשים:

```python
# רשימת PDFs
pdfs = [
    'Dentistry_2024_06.pdf',
    'Dentistry_2024_05.pdf',
    'Dental_Trade_2024.pdf',
    # ... עוד
]

all_products = []

for pdf_file in pdfs:
    print(f"\\n📄 Processing {pdf_file}")
    pages = extract_text_from_pdf(pdf_file)
    
    for page in pages:
        products = find_products_with_prices(page['text'])
        all_products.extend(products)
    
    print(f"   Found {len(products)} products")

print(f"\\n✅ Total: {len(all_products)} products from {len(pdfs)} magazines!")
```

---

## 💡 טיפים

### לשיפור דיוק:

```python
# הוסף פילטרים נוספים
def is_valid_dental_product(name):
    """בדוק אם זה מוצר דנטלי אמיתי"""
    
    # מילות מפתח חיוביות
    dental_keywords = [
        'dental', 'tooth', 'endo', 'perio',
        'implant', 'scaler', 'turbine', 'handpiece',
        'curing', 'composite', 'forceps', 'elevator'
    ]
    
    # מילות מפתח שליליות (לא מוצרים)
    exclude_keywords = [
        'subscription', 'magazine', 'event', 'course',
        'training', 'seminar', 'conference', 'membership'
    ]
    
    name_lower = name.lower()
    
    # חייב להכיל לפחות מילה דנטלית
    has_dental = any(kw in name_lower for kw in dental_keywords)
    
    # לא יכול להכיל מילת הדרה
    has_exclude = any(kw in name_lower for kw in exclude_keywords)
    
    return has_dental and not has_exclude

# שימוש
df = df[df['name'].apply(is_valid_dental_product)]
```

---

## 🎯 הצעדים הבאים

1. **הרץ Colab notebook** → חלץ מוצרים
2. **הורד SQL file**
3. **הרץ בdatabase:**
   ```cmd
   psql -U postgres -d gogobe -f load_extracted_products.sql
   ```
4. **חזור על התהליך** עם מגזינים נוספים!

---

## 📚 מגזינים דנטליים נפוצים

```yaml
UK:
  - Dentistry Magazine (monthly)
  - British Dental Journal
  - Dental Update
  - Practice Management

USA:
  - Dental Economics
  - Dental Products Report
  - Inside Dentistry
  - Dentistry Today

Online Catalogs:
  - Henry Schein Catalog (PDF)
  - Patterson Dental Catalog
  - Dental Directory Catalog
```

---

## ✅ סיכום

```
יש לך עכשיו:
  ✅ מדריך מלא לColab
  ✅ קוד מוכן להעתקה
  ✅ 3 שיטות שונות
  ✅ אוטומציה למספר PDFs
  ✅ פילטרים חכמים

הצעד הבא:
  🚀 פתח Colab
  📤 העלה PDF
  ▶️ הרץ את הקוד
  💾 הורד CSV + SQL
  🗄️ טען לdatabase!
```

---

**בהצלחה! 🦷🚀**









