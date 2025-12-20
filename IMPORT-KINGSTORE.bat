@echo off
chcp 65001 >nul

echo ════════════════════════════════════════════════════════════
echo   🏪 KingStore - Import via Docker
echo ════════════════════════════════════════════════════════════
echo.

cd /d "%~dp0\..\.."

echo בודק Docker...
docker ps >nul 2>&1
if errorlevel 1 (
    echo.
    echo ❌ Docker לא רץ!
    echo.
    echo פתח Docker Desktop והמתן 30 שניות.
    echo אחר כך הרץ את הסקריפט שוב.
    echo.
    echo או הרץ: START-DOCKER.bat
    echo.
    pause
    exit /b 1
)

echo ✓ Docker רץ
echo.
echo ════════════════════════════════════════════════════════════
echo מעבד קבצי XML...
echo זה יכול לקחת 10-15 דקות
echo ════════════════════════════════════════════════════════════
echo.

REM Copy the processor script to container
docker cp backend\scripts\kingstore_xml_processor.py gogobe-api-1:/app/processor.py

REM Run inside container
docker exec -it gogobe-api-1 python /app/processor.py /app/backend/data/kingstore

echo.
echo ════════════════════════════════════════════════════════════
echo.

if errorlevel 1 (
    echo ❌ היתה שגיאה בעיבוד
    echo.
    echo בדוק לוגים:
    echo docker-compose logs api
    echo.
) else (
    echo ✅ יבוא הושלם!
    echo.
    echo פתח את האתר:
    echo http://localhost:8000
    echo.
)

pause

