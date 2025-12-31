# 🐛 הבאגים והלקחים שלנו - Gogobe

מסמך זה מרכז באגים שנתקלנו בהם, הפתרונות שלהם, והלקחים לעתיד כדי שלא נחזור על אותן טעויות.

## 28/12/2025 - API vs Frontend Mismatch

### הבעיה
ה-Frontend (`products.html`) נכשל בהצגת מוצרים וזרק שגיאה טכנית, למרות שה-API החזיר תשובה תקינה (Status 200).
המשתמש קיבל הודעת שגיאה "שגיאה בטעינת הנתונים".

### ניתוח שורש (Root Cause)
1.  **ציפייה שגויה:** ה-JS ב-Frontend עשה `await res.json()` וציפה לקבל מערך שטוח `[...]`.
2.  **שינוי ב-Backend:** ה-API (`routers/products.py`) שודרג והחזיר אובייקט עוטף כדי לכלול מטה-דאטה:
    ```json
    {
      "products": [...],
      "meta": { "count": 100, "time_ms": 12 }
    }
    ```
3.  **כשל בתקשורת:** לא היה תיאום בין מבנה התשובה החדש לקוד הישן בדפדפן.

### הפתרון
עדכון ה-JS שיחלץ את המערך מתוך האובייקט:
```javascript
const responseData = await res.json();
let products = responseData.products || []; 
```

### 💡 הלקח
*   **תמיד לבדוק את ה-Response:** כשמשנים API, חובה לבדוק ב-Browser Console או ב-Network Tab מה בדיוק חוזר.
*   **מבנה אחיד:** עדיף תמיד לעטוף תשובות באובייקט (למשל `data: [...]`) כדי לאפשר הוספת שדות מטה-דאטה בעתיד ללא שבירת קוד.

---

## 28/12/2025 - Database Constraints (Categories)

### הבעיה
סקריפט הקטגוריזציה (`auto_categorizer.py`) נכשל עם שגיאת `IntegrityError` בגלל שדה `slug`.

### ניתוח שורש
1.  טבלת `categories` הוגדרה עם `slug NOT NULL`.
2.  הסקריפט ניסה להכניס קטגוריה חדשה ללא חישוב הערך ל-`slug`.

### הפתרון
עדכון הסקריפט לייצר `slug` (על בסיס השם) לפני ה-INSERT.

### 💡 הלקח
*   **בדיקת סכמה:** לפני כתיבת INSERT, לוודא באילו שדות יש `NOT NULL` ב-DB.

---

## 28/12/2025 - API Integration Failures (Frontend Mismatch)

### הבעיה
לאחר "תיקון" הבעיה הקודמת, המערכת עדיין זרקה שגיאות `404 Not Found` ו-`500 Internal Server Error` בעת המעבר לייצור (Integration).

### ניתוח שורש (Root Cause)
1.  **כתובת לא קיימת:** ה-Frontend פנה ל-`/api/products` (שורש שלא קיים בראוטר), במקום ל-`/api/products/search`.
    *   *סיבה:* הנחה שגויה שה-Endpoint מוגדר בשורש.
2.  **שם פרמטר שגוי:** ה-Frontend שלח פרמטר `q` לחיפוש, בעוד ה-API ציפה ל-`query`.
    *   *סיבה:* חוסר סנכרון בין מפרט ה-API ליישום בלקוח.
3.  **תהליך:** דיווחתי למשתמש שהכל תקין לפני שביצעתי בדיקת אינטגרציה מלאה (End-to-End) בדפדפן או בסימולציה מלאה של הקריאה.

### הפתרון
תיקון ה-URL והפרמטרים ב-`products.html`:
```javascript
// Old (Wrong)
let url = `/api/products?q=${query}`;

// New (Fixed)
let url = `/api/products/search?query=${query}`;
```

### 💡 הלקח
*   **אימות נתיבים (Routes):** לבדוק בקובץ ה-Python (`routers/products.py`) מה ה-`prefix` ומה ה-endpoints המוגדרים תחתיו.
*   **בדיקת אינטגרציה מלאה:** לא להסתפק בכך ש"הקוד נראה נכון". יש להריץ `curl` שמחקה *בדיוק* את מה שהדפדפן שולח, או לפתוח את הדפדפן ולראות שהבקשה יוצאת וחוזרת (Network Tab 200 OK).
*   **דיווח אחראי:** לא להגיד "זה עובד" עד שלא ראיתי את זה עובד בעיניים (צילום מסך או לוג הצלחה).

---

## 27/12/2025 - Frontend Performance & UX

### 1. Map Render Crash (36k Markers)

### הבעיה
הדפדפן קרס בניסיון לטעון את כל 36,000 הסניפים בבת אחת למפה ב-`map.html`.

### ניתוח שורש
1.  **Too Much Data:** ה-API החזיר Payload של 15MB ב-JSON.
2.  **DOM Overload:** ניסיון ליצור 36,000 אלמנטים של `<div>` (Markers) בבת אחת חנק את ה-Main Thread.

### הפתרון
1.  **API רזה:** יצירת Endpoint ייעודי (`/api/stores/geo`) שמחזיר רק Lat/Lon/ID.
2.  **Clustering:** שימוש ב-`Leaflet.markercluster` לאיגוד נקודות.

### 💡 הלקח
*   **גבולות:** לעולם לא לשלוח יותר מ-1,000 אובייקטים ל-Client ללא Pagination או Clustering.

---

### 2. Search Engine Choke

### הבעיה
חיפוש טקסט חופשי בטבלת מוצרים (מיליוני רשומות) לקח 4-10 שניות וגרם ל-Timeouts.

### ניתוח שורש
1.  **Full Table Scan:** שימוש ב-`ILIKE '%term%'` ללא אינדקס מתאים מחייב סריקה מלאה.
2.  **Heavy Joins:** השאילתה המקורית עשתה Join לטבלת מחירים (הענקית) *לפני* הסינון.

### הפתרון
1.  **GIN Index:** הוספת אינדקס `pg_trgm` לחיפוש טקסט מהיר.
2.  **Two-Step Fetch:** קודם שולפים IDs של מוצרים (טבלה קטנה), ורק אז שולפים את המחירים שלהם (IN query).

### 💡 הלקח
*   **Separation of Concerns:** בביצועים קריטיים, עדיף 2 שאילתות קטנות ומהירות על פני שאילתה אחת מפלצתית ("The N+1 Problem" is sometimes faster if N is small).

---

### 3. Visual Clutter (Map UX)

### הבעיה
משתמשים התלוננו שלא מבינים כלום מהמפה - "ים של אייקונים".

### ניתוח שורש
**עודף מידע:** ניסינו להציג את כל המידע (לוגו, שם, סוג) על המפה עצמה.

### הפתרון
**Simplification:** הצגת מחיר בלבד (טקסט) וצביעה לפי יקר/זול (Heatmap לוגי).

### 💡 הלקח
*   **Less is More:** במפה, המידע הכי חשוב הוא "איפה זול", לא "איזה לוגו יש לסופר".

---

## 28/12/2025 - AI Over-Clustering (The #592 Case)

### הבעיה
משתמש דיווח על Master Product (#592) שמקושר ל-28 מוצרים שונים לחלוטין (סרום, קרם פנים, סבון) של אותו מותג (Guerlain).

### ניתוח שורש
1.  **Fuzzy Matching Aggression:** האלגוריתם הישן השתמש ב-Fuzzy Matching מרחבי (Levenshtein) על שם המוצר.
2.  **Brand Dominance:** מכיוון שכל המוצרים התחילו במילים "Guerlain Abeille Royale...", האלגוריתם חשב שהם וריאציות של אותו מוצר ואיחד אותם.

### הפתרון
1.  **Strict Mode:** מעבר לקישור אך ורק לפי ברקוד (EAN) או התאמה מדויקת (100%) של שם+מותג.
2.  **Cluster Buster:** כתיבת סקריפט ייעודי שמזהה "Mega Clusters" (מאסטרים עם יותר מ-5 ברקודים שונים בתוכם) ומפרק אותם.

### 💡 הלקח
*   **Trust but Verify:** אלגוריתמים של AI (כמו Fuzzy Matching) מעולים לניקוי דאטה, אבל מסוכנים לקישור רשומות קריטי (Master Data). ב-Master Data, עדיף False Negative (לא קישרנו מוצר) מאשר False Positive (קישרנו מוצרים לא קשורים).

---

## 28/12/2025 - Navigation Robustness (ID vs Name)

### הבעיה
קישורים בין דפים שהתבססו על שמות מוצרים (`products.html?query=שם מוצר`) נכשלו כשהשם כלל תווים מיוחדים, רווחים כפולים, או כשמנוע החיפוש החזיר תוצאות דומות אך לא מדויקות.

### הפתרון
מעבר לקישור מבוסס ID חד-ערכי (`products.html?master_id=592`).
זה חייב עדכון API כדי לתמוך בסינון לפי ID, ועדכון Frontend שידע לקרוא את הפרמטר.

### 💡 הלקח
*   **IDs are King:** במערכות ניהול (Admin/Backoffice), *תמיד* לקשר לפי ID (מפתח ראשי) ולא לפי טקסט חופשי. טקסט משתנה, IDs הם לנצח.


---

## 28/12/2025 - Metadata Enrichment (Generic Store Names)

### הבעיה
שמות סניפים מיובאים כמו שהם מהרשתות ("סניף 15", "סניף מרכז").
במפה או ברשימה, למשתמש אין מושג איפה זה "סניף 15". זה יוצר חווית משתמש גרועה ("Mystery Meat Navigation").

### הפתרון
העשרת דאטה (Data Enrichment) באמצעות Service חיצוני (Nominatim/Google Maps).
הסקריפט לא רק מביא קואורדינטות, אלא גם שולף את שם העיר והכתובת המנורמלת, ומעדכן את שם הסניף ל-"סניף 15 - רמת גן".

### 💡 הלקח
*   **Raw Data != UI Ready:** דאטה שמגיע מ-Scraping הוא כמעט אף פעם לא מוכן לתצוגה ישירה. חייבים שכבת "פוליש" (Normalization/Enrichment) לפני שחושפים אותו ליוזר.

---

## 28/12/2025 - Missing Index on Foreign Keys (Performance)

### הבעיה
הוספת הפיצ'ר "מוצרים דומים" (`Similar Products`) לדף המוצר גרמה לזמני טעינה של 10+ שניות ולשגיאות TimeOut.
השאילתה המריצה הייתה פשוטה יחסית: `SELECT * FROM products WHERE master_product_id = X`.

### ניתוח שורש (Root Cause)
1.  **Missing Index:** למרות שקיים שדה `master_product_id` (Foreign Key), לא היה עליו אינדקס בטבלת `products` (רק בטבלת `prices` היה).
2.  **Sequential Scan:** ללא אינדקס, בסיס הנתונים נאלץ לסרוק את כל טבלת `products` (עשרות אלפי רשומות) עבור כל קריאה ל-API, כדי למצוא את ה-5 הדומים.

### הפתרון
יצירת אינדקס ייעודי:
```sql
CREATE INDEX CONCURRENTLY idx_products_master_product_id ON products(master_product_id);
```
לאחר היצירה, זמן השאילתה ירד מ-2 שניות ל-0.003 שניות (!).

### 💡 הלקח
*   **Foreign Keys are NOT Indices:** ב-PostgreSQL, יצירת FK *לא* יוצרת אוטומטית אינדקס.
*   **Query Review:** בכל פעם שמוסיפים שאילתה חדשה (במיוחד ב-API תדיר), חובה לבדוק באמצעות `EXPLAIN ANALYZE` האם היא משתמשת באינדקס, *לפני* שהיא עולה לפרודקשן.
