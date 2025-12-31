@echo off
chcp 65001 >nul

echo ════════════════════════════════════════════════════════════
echo   🏪 KingStore - Simple Import (via Docker)
echo ════════════════════════════════════════════════════════════
echo.

cd /d "%~dp0\..\.."

REM Check if Docker is running
echo בודק Docker...
docker ps >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker לא רץ!
    echo.
    echo הפתרון:
    echo   1. פתח Docker Desktop
    echo   2. חכה שיעלה (30 שניות)
    echo   3. הרץ שוב את הסקריפט
    echo.
    pause
    exit /b 1
)

echo ✓ Docker רץ
echo.
echo מעבד את כל קבצי KingStore...
echo (זה יכול לקחת 10-15 דקות)
echo.

docker-compose exec -T api python /app/backend/scripts/kingstore_xml_processor.py /app/backend/data/kingstore

if errorlevel 1 (
    echo.
    echo ❌ היתה שגיאה
    echo.
    pause
    exit /b 1
)

echo.
echo ════════════════════════════════════════════════════════════
echo   ✅ הושלם!
echo ════════════════════════════════════════════════════════════
echo.
echo פתח את האתר: http://localhost:8000
echo.
pause




