# 🗂️ מבנה קטגוריות - Supermarket

## סקירה כללית

המערכת כוללת מבנה קטגוריות היררכי דו-רמתי עבור מוצרי סופרמרקט, תואם למפרט `schema.sql`.

---

## 📊 המבנה

```
VERTICAL: Supermarket (id: 1)
  ↓
13 קטגוריות ראשיות (level 1)
  ↓
50 תת-קטגוריות (level 2)
  ↓
9,131 מוצרים מסווגים
```

---

## 🗂️ הקטגוריות המלאות

### 1. חלב ומוצרי חלב (1,274 מוצרים)
- חלב טרי
- חלב מעובד
- גבינות קשות
- גבינות רכות
- יוגורטים
- שמנת וחמאה
- מעדנים

### 2. בשר ודגים (665 מוצרים)
- בשר בקר
- בשר עוף
- בשר מעובד
- דגים

### 3. לחמים ומאפים (659 מוצרים)
- לחמים
- חלות
- מאפים מתוקים
- עוגיות וביסקוויטים

### 4. פירות וירקות (642 מוצרים)
- פירות טריים
- ירקות טריים
- פירות קפואים
- ירקות קפואים

### 5. דגנים ופסטות (404 מוצרים)
- אורז
- פסטות
- קמח
- דגני בוקר

### 6. שימורים (477 מוצרים)
- שימורי דגים
- שימורי ירקות
- שימורי פירות

### 7. ממתקים וחטיפים (897 מוצרים)
- שוקולד
- סוכריות
- חטיפים מלוחים

### 8. משקאות (935 מוצרים)
- משקאות קלים
- מיצים
- משקאות חמים
- אלכוהול

### 9. מוצרי ניקיון (915 מוצרים)
- ניקוי כלים
- ניקוי כביסה
- ניקוי רצפות
- ניקוי אסלה

### 10. מוצרי היגיינה (567 מוצרים)
- נייר טואלט
- מוצרי רחצה
- טיפוח שיער
- טיפוח פה

### 11. תינוקות (340 מוצרים)
- חיתולים
- מזון לתינוקות
- אביזרים לתינוקות

### 12. נייר ומוצרי חד פעמי (484 מוצרים)
- מגבות נייר
- צלחות חד פעמי
- כוסות וסכו"ם

### 13. תבלינים ורטבים (872 מוצרים)
- תבלינים
- רטבים
- שמנים

---

## 🔧 איך זה עובד

### מבנה DB (לפי schema.sql):

```sql
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    vertical_id INTEGER REFERENCES verticals(id),
    parent_id INTEGER REFERENCES categories(id),
    
    name VARCHAR(200),
    slug VARCHAR(200),
    full_path VARCHAR(500),  -- "supermarket/חלב-ומוצרי-חלב"
    level INTEGER,            -- 1 = ראשי, 2 = משני
    
    attribute_schema JSONB,  -- לעתיד
    product_count INTEGER
);
```

### דוגמה:
```json
{
  "id": 88,
  "name": "חלב ומוצרי חלב",
  "slug": "חלב-ומוצרי-חלב",
  "full_path": "supermarket/חלב-ומוצרי-חלב",
  "level": 1,
  "parent_id": null,
  "vertical_id": 1
}

{
  "id": 89,
  "name": "חלב טרי",
  "slug": "חלב-טרי",
  "full_path": "supermarket/חלב-ומוצרי-חלב/חלב-טרי",
  "level": 2,
  "parent_id": 88,
  "vertical_id": 1
}
```

---

## 🤖 סיווג אוטומטי

המערכת משתמשת במילות מפתח לסיווג:

```python
CATEGORY_KEYWORDS = {
    'חלב ומוצרי חלב': [
        'חלב', 'גבינה', 'קוטג', 'יוגורט', 
        'שמנת', 'חמאה', 'לבן', 'מעדן'
    ],
    'בשר ודגים': [
        'בשר', 'עוף', 'הודו', 'נקניק',
        'דג', 'פילה', 'המבורגר'
    ],
    # ...
}
```

אלגוריתם:
1. עובר על כל מוצר
2. בודק אם שם המוצר מכיל אחת ממילות המפתח
3. משייך לקטגוריה המתאימה
4. אם לא נמצאה התאמה → "אחר"

---

## 📈 שיפורים עתידיים

### רמה 3 (תת-תת-קטגוריות):
```
חלב ומוצרי חלב
  → גבינות קשות
    → גבינה צהובה
    → גבינה לבנה
    → פרמזן
```

### AI Classification:
- שימוש ב-LLM (Ollama) לסיווג מדויק יותר
- למידה מהיסטוריית משתמשים
- זיהוי מותגים ותכונות

### Attribute Schema:
```json
{
  "category": "חלב ומוצרי חלב",
  "attributes": {
    "fat_percentage": "3%",
    "volume": "1L",
    "is_kosher": true,
    "shelf_life_days": 7
  }
}
```

---

## 🔨 סקריפטים

### יצירת מבנה:
```bash
docker exec gogobe-api-1 python /app/backend/scripts/create_hierarchical_categories.py
```

### סיווג מחדש:
```bash
docker exec gogobe-api-1 python /app/backend/scripts/auto_categorize.py
```

### עדכון product_count:
```sql
UPDATE categories
SET product_count = (
    SELECT COUNT(*) 
    FROM products 
    WHERE category_id = categories.id
);
```

---

## 📚 קישורים

- [Schema.sql](../../backend/database/schema.sql) - מבנה DB
- [create_hierarchical_categories.py](../../backend/scripts/create_hierarchical_categories.py) - סקריפט יצירה
- [auto_categorize.py](../../backend/scripts/auto_categorize.py) - סיווג אוטומטי

---

**תאריך:** 20 דצמבר 2025  
**גרסה:** 1.0

