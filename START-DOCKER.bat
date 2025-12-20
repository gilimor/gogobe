@echo off
chcp 65001 >nul

echo ════════════════════════════════════════════════════════════
echo   🐳 Gogobe - Docker Setup
echo ════════════════════════════════════════════════════════════
echo.

echo בודק את Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker לא מותקן או לא רץ
    echo.
    echo פתח את Docker Desktop והפעל אותו, ואז הרץ שוב.
    pause
    exit /b 1
)

echo ✓ Docker מותקן
echo.

echo שלב 1/3: בונה את ה-Docker image...
echo (זה יכול לקחת 2-3 דקות בפעם הראשונה)
echo.

docker-compose build

if errorlevel 1 (
    echo.
    echo ❌ שגיאה בבניית ה-image
    pause
    exit /b 1
)

echo.
echo שלב 2/3: מפעיל את השרת...
echo.

docker-compose up -d

if errorlevel 1 (
    echo.
    echo ❌ שגיאה בהפעלת השרת
    pause
    exit /b 1
)

echo.
echo שלב 3/3: בודק שהשרת רץ...
echo.
timeout /t 3 >nul

docker-compose ps

echo.
echo ════════════════════════════════════════════════════════════
echo   ✅ השרת פועל!
echo ════════════════════════════════════════════════════════════
echo.
echo האתר זמין בכתובת:
echo   👉 http://localhost:8000
echo.
echo פקודות שימושיות:
echo   docker-compose logs -f     = הצגת לוגים
echo   docker-compose stop        = עצירת השרת
echo   docker-compose restart     = הפעלה מחדש
echo   docker-compose down        = כיבוי מלא
echo.
echo פותח דפדפן...
timeout /t 2 >nul
start http://localhost:8000

echo.
pause
