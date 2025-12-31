# 📋 **Import Types & Strategy**

## סוגי ייבוא במערכת

### **Type 1: Full Catalog (מתעד מלא)**
**דוגמה:** Shufersal PriceFull files

**מאפיינים:**
```
✓ כל המוצרים בסניף
✓ כל המחירים (גם ללא שינוי)
✓ Snapshot מלא של הסניף
```

**התנהגות צפויה:**
```python
if product.ean exists:
    # Update or skip price (upsert_price)
    products_created = 0  # Normal!
else:
    # New product!
    products_created += 1
```

**תוצאה רגילה:**
- ייבוא ראשון: הרבה מוצרים חדשים
- ייבואים הבאים: 0 מוצרים חדשים (אלא אם יש מוצר חדש בסניף)

---

### **Type 2: Price Changes Only (שינויי מחיר בלבד)**
**דוגמה:** ספקים מסוימים, Price Comparison APIs

**מאפיינים:**
```
✓ רק מוצרים ששינו מחיר
✓ רק מחירים חדשים
✓ Delta update
```

**התנהגות צפויה:**
```python
if product.ean not exists:
    # New product discovered!
    products_created += 1
    
if price changed:
    # New price record
    upsert_price() → INSERT
else:
    # Skip (not in delta file)
    pass
```

**תוצאה רגילה:**
- יכולים להיות מוצרים חדשים בכל ייבוא
- רק מחירים שהשתנו

---

### **Type 3: Supplier Catalog (קטלוג ספק)**
**דוגמה:** Excel/CSV מספקים

**מאפיינים:**
```
✓ קטלוג מלא של ספק
✓ מחירי מחירון
✓ עדכון תקופתי
```

**התנהגות צפויה:**
```python
# כל קובץ יכול להכיל:
- מוצרים חדשים
- מחירים מעודכנים
- מוצרים שהוסרו (לא בקובץ)
```

---

## 🎯 **המערכת הנוכחית:**

### **נכון ל-23 דצמבר 2025:**

```python
✅ Support for Type 1 (Full Catalog)
   - Shufersal: Working perfectly
   - 0 new products on re-import: Normal ✓
   
✅ Ready for Type 2 (Price Changes)
   - Will create new products when discovered
   - upsert_price handles changes
   
✅ Ready for Type 3 (Supplier Catalog)
   - Can import any format
   - Product creation on-demand
```

---

## 📊 **ייבוא שופרסל - הסבר:**

### **למה אין מוצרים חדשים?**

```
21 דצמבר: ייבוא ראשון
→ נוצרו 22,810 מוצרים (כל המוצרים של שופרסל)

23 דצמבר: ייבוא סניפים חדשים
→ 0 מוצרים חדשים

למה? כי:
1. זה אותה רשת (שופרסל)
2. אותם מוצרים (EAN זהה)
3. רק מחירים שונים בין סניפים

זה תקין! ✅
```

### **מתי יהיו מוצרים חדשים?**

```python
# מקרה 1: מוצר חדש בסניף
if "new product launched in store":
    → products_created += 1
    
# מקרה 2: ספק חדש
if "new supplier":
    → products_created = many!
    
# מקרה 3: רשת חדשה
if "new chain":
    → products_created = many!
```

---

## 🔧 **Configuration per Supplier:**

```python
# backend/config/suppliers.py (future)

suppliers = {
    "shufersal": {
        "type": "full_catalog",
        "expect_new_products": False,  # רגיל: 0 חדשים
        "expect_price_changes": True,
        "upsert_strategy": "update_timestamp"
    },
    
    "mega": {
        "type": "full_catalog",
        "expect_new_products": False,
        "expect_price_changes": True,
        "upsert_strategy": "update_timestamp"
    },
    
    "supplier_api": {
        "type": "price_changes_only",
        "expect_new_products": True,  # יכולים להיות!
        "expect_price_changes": True,
        "upsert_strategy": "insert_on_change"
    },
    
    "dental_supplier": {
        "type": "supplier_catalog",
        "expect_new_products": True,  # תמיד!
        "expect_price_changes": True,
        "upsert_strategy": "full_replace"
    }
}
```

---

## ✅ **המסקנות:**

### **1. המערכת הנוכחית תקינה:**
```
✓ Shufersal: Type 1 (Full Catalog)
✓ 0 new products: Expected behavior
✓ Price updates: Working perfectly
```

### **2. מוכן לסוגי ייבוא נוספים:**
```
✓ upsert_price: Handles both scenarios
✓ Product creation: On-demand
✓ Flexible architecture
```

### **3. עתידי - Configuration:**
```python
# Add supplier-specific config
# Document expected behavior
# Alert on anomalies
```

---

## 📝 **לזכור:**

```
סוג ייבוא = התנהגות צפויה

Full Catalog:
  ייבוא 1: הרבה מוצרים
  ייבוא 2+: 0 מוצרים (רגיל!)
  
Price Changes:
  כל ייבוא: יכולים להיות חדשים
  
Supplier Catalog:
  תלוי בספק
```

---

**Status:** ✅ System designed correctly  
**Shufersal:** ✅ Working as expected  
**Future:** ✅ Ready for other import types  

🎯 **הארכיטקטורה נכונה לכל סוגי הייבואים!**
