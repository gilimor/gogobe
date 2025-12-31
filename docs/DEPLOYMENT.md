# מדריך התקנה ופריסה (Deployment Guide)

המדריך הזה מסביר איך להתקין את המערכת על מחשב חדש או ענן מאפס, ואיך לשחזר את הדאטה במידת הצורך.

## 1. התקנה על מחשב חדש (Fresh Install) 🖥️
אם אתה עובר למחשב חדש או משתמש בענן (Cloud), בצע את השלבים הבאים. המערכת תותקן באופן מלא, אך הדאטה-בייס יתחיל ריק.

### דרישות מקדימות:
- **Git**: [הורדה](https://git-scm.com/downloads)
- **Docker Desktop**: [הורדה](https://www.docker.com/products/docker-desktop)

### שלבי ההתקנה:
1.  **שכפול הפרויקט (Clone):**
    פתח את הטרמינל והרץ:
    ```bash
    git clone https://github.com/gilimor/gogobe.git
    cd gogobe
    ```

2.  **הרצת המערכת:**
    בתוך התיקייה, הרץ פקודה אחת פשוטה שתבנה את הכל (דאטה-בייס, שרת, ממשק משתמש):
    ```bash
    docker-compose up -d --build
    ```

3.  **גישה למערכת:**
    פתח את הדפדפן בכתובת:
    - דף הבית: `http://localhost:8000`
    - דשבורד ניהול: `http://localhost:8000/dashboard.html`

---

## 2. העברת הדאטה (Database Migration) 💾
הקוד נמצא ב-GitHub, אבל המידע שאספת (המחירים והמוצרים) נמצא רק על המחשב הנוכחי בתוך ה-Docker Volume.
אם אתה רוצה להעביר גם את המידע למחשב החדש:

### במחשב הישן (גיבוי):
הרץ את הפקודה הבאה לגיבוי הדאטה לקובץ:
```bash
docker-compose exec -T db pg_dump -U postgres gogobe > gogobe_backup.sql
```
*(קובץ `gogobe_backup.sql` יווצר בתיקייה הראשית. העבר אותו למחשב החדש).*

### במחשב החדש (שחזור):
אחרי שהרצת את `docker-compose up` והמערכת באוויר, הרץ:
```bash
cat gogobe_backup.sql | docker-compose exec -T db psql -U postgres -d gogobe
```

---

## 3. פריסה לענן (Cloud / VPS) ☁️
התהליך זהה לחלוטין ל"התקנה על מחשב חדש".
מומלץ להשתמש בשרת לינוקס (Ubuntu) עם לפחות **4GB RAM** (בגלל Kafka ו-Postgres).
