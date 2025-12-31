
### ✅ APS & Categorization (Phase 4)
- **Categorization Fix:** מעבר למנגנון Regex למניעת סיווגים שגויים (כמו "Panty Liners" ב-"Tools").
- **Expansion:** הרחבת מילות המפתח לקטגוריות "חשמל ואלקטרוניקה" ו-"כלי בית".
- **APS Spider:** תיקון והפעלה מלאה של `discovery_spider.py` (Headless Playwright). מתחבר ל-DB ושומר לינקים.

### ✅ Trends Page Arbitrage
- **Backend:** הוספת endpoint `/api/products/trends/arbitrage` לאיתור פערי מחיר קיצוניים (>50%).
- **Frontend:** הפעלת כפתור "צפה בהזדמנויות" שמציג את רשימת הארביטראז' בזמן אמת.
- **UI:** תצוגה ברורה של החנות הזולה מול היקרה ואחוז הפער.
