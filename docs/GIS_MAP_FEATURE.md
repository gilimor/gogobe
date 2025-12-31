# 🌍 תכונה חדשה: מפת סניפים ומערכת גיאוגרפית (GIS)

תאריך: 20/12/2025

## 🎯 תקציר
הוספנו יכולות גיאוגרפיות (GIS) מלאות למערכת Gogobe, כולל מסד נתונים מרחבי (Spatial Database), גיאוקודינג אוטומטי וממשק מפה אינטראקטיבי.

## 🛠️ ארכיטקטורה טכנית

### 1. Database (PostgreSQL + PostGIS)
שדרגנו את מסד הנתונים מ-`postgres:15` ל-`postgis/postgis:15-3.4-alpine`.
הוספנו לטבלת `stores`:
*   `latitude` (Decimal) - קו רוחב
*   `longitude` (Decimal) - קו אורך
*   `geom` (Geometry Point, SRID 4326) - שדה גיאוגרפי לביצוע שאילתות מרחביות (כגון "מצא סניפים ברדיוס X").

### 2. Geocoding Service
יצרנו שירות רקע ב-Python (`backend/scripts/geocode_stores.py`) המבצע:
1.  סריקת סניפים ללא קואורדינטות.
2.  שליחת שאילתה ל-Nominatim API (OpenStreetMap).
3.  עדכון ה-DB עם הקואורדינטות ושדה ה-Geometry.
4.  טיפול בשיעורי הגבלה (Rate Limiting) כדי לא להיחסם.

### 3. Frontend Map
דף חדש `map.html` המבוסס על ספריית **Leaflet.js**:
*   תצוגת מפה מלאה של ישראל (OSM Tiles).
*   תצוגת כל הסניפים כנקודות (צבע ירוק לשופרסל, אדום ל-KingStore).
*   פופ-אפ לכל סניף עם מידע על מס' מוצרים ומחירים.
*   סינון צד-לקוח לפי רשת ועיר.
*   סטטיסטיקות בזמן אמת (סה"כ סניפים, סניפים מוצגים).

## 🚀 איך להשתמש?

### צפייה במפה
פשוט כנס לכתובת:
`http://localhost:8000/map.html`

### הרצת הגיאוקודינג (Geocoding) ידנית
התהליך רץ אוטומטית, אך ניתן להפעיל ידנית:
```bash
docker exec -it gogobe-api-1 python /app/backend/scripts/geocode_stores.py
```

## 🗺️ תוכניות לעתיד
*   חיפוש "סניפים לידי" (Nearest Neighbor Search).
*   סינון מוצרים לפי מרחק מהלקוח.
*   מפת חום (Heatmap) של מחירים זולים בארץ.
