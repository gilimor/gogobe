@echo off
echo ===================================
echo Running Import Inside Docker
echo ===================================

echo Running Published Prices chains import...
docker-compose exec -T api python /app/run_published_prices_chains.py

if errorlevel 1 (
    echo ERROR: Import failed
    pause
    exit /b 1
)

echo.
echo ===================================
echo Import completed!
echo ===================================
pause
