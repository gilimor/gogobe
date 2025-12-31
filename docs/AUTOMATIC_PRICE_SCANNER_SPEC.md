# אפיון מערכת סורק מחירים אוטומטי (Automatic Price Scanner - APS)

## 1. תקציר מנהלים
המטרה: פיתוח מנוע אוטומטי לגילוי, סריקה ויבוא מחירים מאתרי מסחר אלקטרוני (E-commerce) באופן גנרי, ללא צורך בכתיבת סקרייפר ייעודי לכל אתר. המערכת תדע לקבל כתובת אתר (Domain), למצוא את מפת האתר (Sitemap), לאתר דפי מוצרים, ולשלוף מהם בצורה חכמה את שם המוצר והמחיר.

## 2. ארכיטקטורה וזרימת נתונים (Data Flow)

תהליך הסריקה מחולק ל-4 שלבים עיקריים:

### שלב 1: מודול הגילוי (Discovery Module)
מודול האחראי על איתור "דלת הכניסה" למוצרי האתר.
1.  **קלט**: דומיין (למשל `www.zara.com`).
2.  **פעולה**: גישה לקובץ `robots.txt` לאיתור מיקום ה-`sitemap.xml`.
3.  **אתגר הרקורסיה**: רוב האתרים הגדולים משתמשים ב-`Sitemap Index` (מפה שמפנה למפות אחרות). המודול יבצע צלילה (Drill Down) רקורסיבית עד למציאת מפות קצה המכילות כתובות URL של עמודים.

### שלב 2: מודול הסינון (Filtering Module)
מודול האחראי על הפרדת המוצרים מיתר דפי האתר (תקנון, סניפים, צור קשר).
*   **לוגיקה**: סינון URLs לפי תבניות נפוצות של מוצרים (`/product/`, `/p/`, `/item/`, `/shop/`).
*   **הגדרות מתקדמות**: אפשרות להזרקת חוקי Regex ספציפיים לכל דומיין במידת הצורך.

### שלב 3: מודול השליפה (The Scraper Engine)
מנוע הליבה שמבצע את חילוץ הנתונים (Extraction) בצורה אגנוסטית (מבלי להכיר את מבנה ה-HTML הספציפי).
הסורק יפעל לפי **סדר עדיפויות יורד** (Waterfall Strategy):

1.  **Structured Data (עדיפות עליונה)**:
    *   **Meta Tags**: `og:price:amount`, `product:price:amount`, `schema.org/Offer`.
    *   **JSON-LD**: חיפוש אובייקטים מסוג `Product` או `Offer` בתוך סקריפטים של העמוד.
2.  **CSS Selectors (הירוריסטיקה)**:
    *   חיפוש אלמנטים עם מחלקות (Classes) חשודות: `.price`, `.current-price`, `.pdp-price`, `.amount`.
3.  **Regex Fallback (מוצא אחרון)**:
    *   סריקת הטקסט החופשי בעמוד אחר תבניות מחיר (למשל `XX.XX ₪`, `$XX.XX`).
4.  **AI Fallback (אופציונלי - למקורות קריטיים)**:
    *   במידה וכל השיטות נכשלו והאתר מסומן כחשוב (High Priority), ה-HTML הגולמי יישלח למודל שפה קטן ומהיר (כגון GPT-4o-mini).
    *   **Prompt**: `"Extract product name and price from this HTML. Return JSON."`
    *   זהו פתרון יקר ואיטי יותר, ולכן ישמש רק כמוצא אחרון בהחלט ורק לאתרים עם Success Rate נמוך מ-50%.

### שלב 4: מודול הניהול והבקרה (Management & Output)
ניהול מחזור החיים של המקור (Source Lifecycle).
*   **Discovered Sources DB**: טבלה המרכזת את כל המקורות שהתגלו.
*   **Health Check**: בדיקת "דופק" למקור - האם הלינקים תקינים? האם המחירים נשלפים?
*   **Scheduling**: קביעת תדירות סריקה אוטומטית (למשל: כל 24 שעות).

### 2.5. יעדי ביצועים (Performance Targets / SLA)
*   **זמן גילוי אתר חדש**: פחות מ-10 דקות מרגע הזנת הדומיין.
*   **אחוז הצלחה מינימלי**: מעל 70% מהדפים שזוהו כמוצרים חייבים להחזיר מחיר תקין.
*   **זמן תגובה מקסימלי**: 5 שניות ל-Page Load (מעבר לזה ייחשב כ-Timeout).
*   **קיבולת סריקה**: תמיכה ב-10,000+ מוצרים ביום בשלב ההתחלתי.
*   **Re-scan Cycle**: בין 7 ל-30 ימים, בהתאם לציון ה-Success Rate של האתר.

---

## 3. מחסנית טכנולוגית (Tech Stack)

*   **שפה**: Python 3.9+
*   **ספריית ליבה**: **Scrapy** (Framework לסריקה אסינכרונית מהירה).
*   **טיפול ב-JS/דינמיות**: **Scrapy-Playwright** (דפדפן Headless מלא לרינדור עמודים מורכבים).
*   **עקיפת חסימות**: **scrapy-impersonate** (חיקוי טביעת אצבע של דפדפן TLS למניעת חסימות Cloudflare/Akamai).
*   **Database**: PostgreSQL (שמירת הגדרות המקורות והתוצאות).

---

## 4. מפרט טכני למימוש (Implementation Spec)

### 4.1. טבלת מעקב מקורות (`source_discovery_tracking`)

| Column Name | Type | Description |
| :--- | :--- | :--- |
| `id` | UUID | מזהה ייחודי |
| `domain` | VARCHAR | כתובת האתר (למשל `zara.com`) |
| `sitemap_url` | VARCHAR | הכתובת שנמצאה ל-Sitemap |
| `discovery_status` | ENUM | PENDING, SCANNING, ACTIVE, ERROR, BLOCKED |
| `last_scan_at` | TIMESTAMP | זמן סריקה אחרון |
| `products_found` | INT | כמה מוצרים נמצאו בסריקה האחרונה |
| `success_rate` | FLOAT | אחוז הדפים מהם חולץ מחיר בהצלחה |
| `schedule_interval` | INT | כל כמה שעות להריץ (ברירת מחדל: 24) |
| `parser_config` | JSON | הגדרות ספציפיות אם האוטומציה נכשלת (Custom Selectors) |

### 4.4. ניטור בריאות המקור (Health Monitoring)
טבלה: `source_health_log`

| Column | Type | Description |
|---|---|---|
| `source_id` | UUID | מזהה המקור |
| `checked_at` | TIMESTAMP | זמן הבדיקה |
| `status_code` | INT | קוד תשובה (200, 404, 403) |
| `avg_response_ms` | INT | זמן תגובה ממוצע (ms) |
| `prices_found` | INT | כמות מחירים שנמצאו בבדיקה המקרית |
| `error_log` | TEXT | פירוט שגיאות טכניות |

**לוגיקה**:
*   אחת ל-6 שעות, המערכת תבצע דגימה (Sampling) של 5 כתובות URL אקראיות מתוך ה-Sitemap של המקור.
*   אם ליותר מ-3 כתובות חזרה תשובת שגיאה -> המקור יסומן כ-`ERROR`.
*   אם זמן התגובה הממוצע מעל 10 שניות -> יסומן כ-`SLOW`.
*   אם יש רצף של 3 בדיקות נכשלות -> המקור יחסם אוטומטית (`BLOCKED_AUTO`) והתראה תישלח.

### 4.2. דוגמת קוד ל-Spider (קונספטואלי)

```python
import scrapy
from scrapy.spiders import SitemapSpider

class GenericPriceSpider(SitemapSpider):
    name = 'price_hunter'
    
    def __init__(self, domain, sitemap_url, *args, **kwargs):
        self.sitemap_urls = [sitemap_url]
        # חוקים דינמיים לסינון URLs
        self.sitemap_rules = [
            ('/product/', 'parse_product'),
            ('/p/', 'parse_product'),
            ('/item/', 'parse_product'),
        ]
        super().__init__(*args, **kwargs)

    def parse_product(self, response):
        """
        לוגיקת החילוץ החכמה
        """
        # 1. נסה Meta Tags
        price = response.css('meta[property="product:price:amount"]::attr(content)').get()
        currency = response.css('meta[property="product:price:currency"]::attr(content)').get()

        # 2. נסה JSON-LD
        if not price:
            # (פונקציה לחילוץ מ-JSON פנימי)
            pass

        # 3. נסה Selectors גנריים
        if not price:
            price = response.css('.price::text, .current-price::text').get()

        if price:
            yield {
                'url': response.url,
                'name': response.css('h1::text').get(),
                'price': self.clean_price(price),
                'currency': currency or 'ILS', # ברירת מחדל
                'scraped_at': datetime.now()
            }
```

### 4.3. טיפול באתגרים (Challenges Mitigation)

1.  **Blocker: Cloudflare / Akamai**
    *   **פתרון**: שימוש ב-`scrapy-impersonate` שמחליף את ה-TLS Fingerprint של Python בזה של Chrome/Firefox אמיתי.
    *   **Proxy Rotation**: חיבור לשירות פרוקסי בתשלום (Smartproxy / Bright Data) להחלפת IP בכל בקשה.

2.  **Blocker: Dynamic Content (React/Vue/Angular)**
    *   **פתרון**: אתרים שלא מחזירים מחיר ב-HTML הראשוני יסומנו בטבלה כ-`REQUIRES_RENDER`.
3.  **Blocker: Geo-Restrictions (חסימה גיאוגרפית)**
    *   **הבעיה**: אתרים מסוימים מציגים תוכן רק למשתמשים ממדינות ספציפיות (למשל, חנות בארה"ב החוסמת IP מישראל), או מחזירים קוד `451 Unavailable For Legal Reasons`.
    *   **הפתרון**:
        *   שימוש ב-Proxy מסתובב עם מיקום גיאוגרפי (Geo-Targeting).
        *   שמירת שדה `required_country` בטבלת המקורות (למשל `ES` לספרד).
        *   אם זוהתה חסימה, ה-Spider ינסה אוטומטית דרך פרוקסי מהמדינה הרלוונטית לפני ויתור.

## 5. ממשק ניהול (UI Requirement)
יש להוסיף מסך ב-Admin (`admin/sources-discovery.html`) שיאפשר:
1.  הזנת דומיין חדש לסריקה.
2.  צפייה בסטטוס הסריקות (כמה מוצרים נמצאו).
3.  כפתור "Approve Source": הופך את המקור ממצב "זמני" למקור קבוע במערכת, ומגדיר אותו ב-Pipeline הקבוע של Kafka.
### 5.1. מדדים בלוח הבקרה (Dashboard Metrics)
*   **Pie Chart**: התפלגות מקורות לפי סטטוס (Active, Pending, Blocked, Error).
*   **New Products**: גרף כמות מוצרים חדשים שנוספו ב-24 שעות האחרונות.
*   **Alerts**: רשימת אתרים שצנחו מתחת ל-70% הצלחה.

### 5.2. פעולות גורפות (Bulk Actions)
*   **Pause All**: כפתור חירום לעצירת כל הסריקות.
*   **Re-scan Failed**: כפתור להרצה מחדש מיידית של כל המקורות בסטטוס ERROR.
*   **Export CSV**: ייצוא רשימת המקורות והסטטוסים לניתוח חיצוני.

## 6. סיכום ותוכנית עבודה
1.  **הקמת התשתית**: התקנת Scrapy ו-PostgreSQL Table.
2.  **פיתוח ה-Spider**: מימוש המחלקה הגנרית הירוריסטית.
3.  **טסטים**: הרצה על 3 אתרים פשוטים (ללא חסימות) לווידוא שליפת מחירים.
4.  **טיפול בחסימות**: אינטגרציה עם Impersonate/Playwright.
5.  **UI**: בניית מסך הניהול.

---

## 7. אתיקה וזיהוי (Scraping Ethics & Identification)
בהתאם למסמך המדיניות `Research/Getting-Started/00-LEGAL-BASICS.md`, הסורק יקפיד על הכללים הבאים כדי לשמור על שקיפות והוגנות:

1.  **זיהוי עצמי (User-Agent)**:
    *   הסורק יזדהה בשם ברור ולא יתחזה למשתמש אנושי אלא אם כן מדובר בפתרון חסימה ספציפי.
    *   מחרוזת הזיהוי תכלול כתובת ליצירת קשר:
        ```
        GogobePriceBot/1.0 (+http://gogobe.com/bot; bot@gogobe.com)
        ```
2.  **ציות ל-robots.txt**:
    *   לפני תחילת סריקה, המערכת תבדוק את קובץ `robots.txt` של האתר.
    *   אם יש איסור מפורש (`Disallow: /`) או איסור על תיקיות ספציפיות, הסורק **ידלג** עליהן ויסמן את המקור כ-`BLOCKED_BY_ROBOTS`.
3.  **הגבלת קצב (Rate Limiting)**:
    *   ברירת המחדל תהיה השהייה של **3-5 שניות** בין בקשות לאותו דומיין, כדי למנוע עומס על שרתי היעד.
    *   שימוש ב-`AUTOTHROTTLE_ENABLED = True` של Scrapy.
4.  **עמוד מידע לבעלי אתרים (Info Page - English)**:
    *   כתובת ה-URL שב-User-Agent תוביל לעמוד הסבר באנגלית המפרט:
        *   Who we are (Price Comparison Engine).
        *   What data we collect (Public data only: Product Name & Price).
        *   How to opt-out (Instructions to block via robots.txt or contact form).

---

## 8. ניתוח משפטי אוטומטי (ToS Analysis AI)
**שאלה קריטית**: האם הבוט יכול לקרוא את "תנאי השימוש" (Terms of Service) ולהבין אם הסריקה אסורה?
**תשובה**: טכנית - כן, באמצעות מודל שפה (LLM), אם כי זה לא ייעוץ משפטי מחייב.

### מנגנון "Safety Check" (אופציונלי):
1.  **חיפוש עמוד התנאים**: הסורק יחפש בתפריט התחתון (Footer) קישורים כמו `Terms`, `Legal`, `תקנון`, `תנאי שימוש`.
2.  **חילוץ הטקסט**: הורדת הטקסט המשפטי.
3.  **שיפוט AI**: שליחת הטקסט ל-LLM (כגון GPT-4o-mini) עם השאילתה:
    > "Analyze the following Terms of Service. Does it explicitly prohibit automated data collection, scraping, or crawling specifically for price comparison purposes? Return JSON: {allowed: boolean, reason: string, risk_level: high/medium/low}"
4.  **פעולה**:
    *   **Risk Low**: המשך סריקה.
    *   **Risk Medium**: דגל צהוב - סרוק אבל שמור לוג לביקורת (`warning_log`).
    *   **Risk High**: עצור סריקה וסמן את המקור כ-`NEEDS_LEGAL_REVIEW`. שלח התראה למנהל.
5.  **Override Manual**:
    *   מנהל מערכת יכול לאשר ידנית גם אתרים בסיכון גבוה, תוך תיעוד הסיבה בטבלה (`legal_override_log`). גמישות זו נדרשת כי לעיתים האיסור הוא גנרי ולא נאכף או לא רלוונטי למידע פומבי.

### הבהרה חשובה (Disclaimer)
המערכת היא כלי טכנולוגי בלבד. היכולת הטכנית לקרוא את התקנון **אינה** מהווה תחליף לייעוץ משפטי אנושי. בוטים עלולים לטעות בפרשנות משפטית. האחריות על הפעלת הסורק חלה על המפעיל בלבד בהתאם לחוקי המדינה הרלוונטית.

---

## 9. אסטרטגיית גילוי (Discovery Strategy)
איך אנחנו בכלל יודעים איזה אתרים לסרוק, ואיך נמנעים מעבודה כפולה?

### 9.1. מניעת סריקה כפולה וניהול תדירות (Dynamic Re-Scan)
ה-DB שלנו הוא מקור האמת היחיד. התדירות תיקבע דינמית לפי הצלחת הסריקה האחרונה:

| Status (Success Rate) | Re-Scan Interval | הסיבה |
|---|---|---|
| **Excellent (> 80%)** | כל 7 ימים | מקור אמין ופעיל, שווה לעקוב |
| **Good (50-80%)** | כל 14 ימים | איכות סבירה, שינויים פחות תכופים |
| **Risky (20-50%)** | כל 30 ימים | חשד לבעיות טכניות, הפחת עומס |
| **Poor (< 20%)** | כל 90 ימים | כמעט לא שמיש, בדיקה רבעונית |
| **NO_PRICES** | כל 365 ימים | אתר ריק או לא רלוונטי |
| **BLOCKED** | ידני בלבד | דורש התערבות מפתח |

הלוגיקה תיושם ב-Scheduler היומי.

### 9.2. שיטות לגילוי אתרים חדשים (Source Discovery Methods)
המערכת תשתמש במספר ערוצים כדי למלא את "בנק המטרות" (Target Bank):

1.  **אינדקסים פומביים (Google CSE)**:
    *   שימוש ב-Google Custom Search API עם שאילתות ממוקדות מסחר, כגון:
        `inurl:store OR inurl:shop site:.il "הוסף לסל" -site:facebook.com`
    *   שאיבת תוצאות החיפוש והכנסתן לטבלת המועמדים (`leads`).

2.  **מעקב אחרי מתחרים (Competitor Analysis)**:
    *   ניתוח אתרי השוואת מחירים קיימים (כמו Zap) וזיהוי הדומיינים שאליהם הם מפנים.

3.  **רשימות Crowdsourced**:
    *   יבוא רשימות מאגרים פתוחים (כמו רשימות של חנויות Shopify/WooCommerce פופולריות בישראל).

4.  **גילוי פסיבי (Passive Discovery)**:
### 9.3. סינון אתרי אגרגטור (Filtering Aggregators)
חשוב מאוד: אנחנו לא רוצים לסרוק אתרים שבעצמם הם אתרי השוואת מחירים (כמו Zap, Retalix, PriceSpy), כדי להימנע מבעיות משפטיות ("גניבת DB") ומידע כפול ומעגלי.

**מנגנון הזיהוי והחסימה**:
1.  **רשימה שחורה (Static Blacklist)**: רשימה של דומיינים ידועים שאסור לסרוק (zap.co.il, kama.co.il, pricespy.co.uk וכו').
2.  **זיהוי מבני (Heuristic Detection)**:
    *   הסייר יחפש מילות מפתח ב-Title וב-Meta Description המעידות על אגרגטור: "השוואת מחירים", "Compare Prices", "Best Deals from Stores".
    *   אם נמצא שיותר מ-50% מהלינקים בעמוד מובילים לדומיינים חיצוניים (External Links) ואינם כפתורי "הוסף לסל" אלא "לקנייה בחנות" -> **חשד גבוה לאגרגטור**.
    *   אתרים אלו יסומנו בסטטוס `AGGREGATOR` וייסגרו לסריקה לצמיתות.

---

## 10. אינטגרציה עם מערכת Master Product (חיבור למנוע הליבה)

המחירים שנשלפים ע"י ה-Scanner הם "מידע גולמי" (Raw Data) בלבד. ללא קישור למוצר אב (Master Product), הם חסרי ערך להשוואה.
תהליך הקישור יתבצע באופן הבא:

1.  **חילוץ ברקוד (Barcode Extraction)**:
    *   הסורק יחפש באופן אקטיבי שדות `GTIN`, `EAN`, `ISBN` בתוך ה-Structured Data (JSON-LD) של הדף.
    *   אם נמצא ברקוד -> הקישור למוצר האב הוא **מידי ואוטומטי** (Match Confidence = 100%).

2.  **התאמת שמות (Fuzzy Matching)**:
    *   במידה ואין ברקוד, שם המוצר (`Scanning Result`) יישלח למנוע ה-Elasticsearch הקיים.
    *   יופעל אלגוריתם שקלול (Levenshtein Distance + Token Overlap) מול מסד הנתונים של ה-Master Products.
    *   **Confidence Score**:
        *   **> 90%**: קישור אוטומטי.
        *   **70%-90%**: יכנס לתור "Matching Review" לאישור מנהל.
        *   **< 70%**: המוצר יישמר ב-DB אך לא יוצג בהשוואת המחירים עד שמישהו יקשר אותו ידנית.

3.  **ממשק אישורים (Matching Queue UI)**:
    *   מסך Admin ייעודי שיציג לצד זה את המוצר שנסרק (עם תמונה ומחיר) ואת המוצר המזוהה במערכת, ויאפשר למפעיל ללחוץ "Approve" או "Reject".

3.  **אכלוס אוטומטי של הרשימה השחורה (Proactive Blacklist Population)**:
    *   לפני תחילת פעילות במדינה חדשה (למשל ספרד), המערכת תבצע חיפוש מקדים בגוגל:
        `Top 20 price comparison sites in Spain`, `Mejores comparadores de precios España`.




