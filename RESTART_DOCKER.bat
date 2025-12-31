@echo off
echo ===================================
echo Restarting Gogobe Docker Container
echo ===================================

echo Restarting container...
docker-compose restart api

if errorlevel 1 (
    echo.
    echo Failed to restart. Trying full restart...
    docker-compose down
    docker-compose up -d
)

echo.
echo ===================================
echo Docker container restarted!
echo Checking logs...
echo ===================================
timeout /t 2 /nobreak >nul

docker-compose logs --tail=20 api

echo.
echo ===================================
echo Server should be ready at:
echo http://localhost:8000/dashboard.html
echo ===================================
pause
