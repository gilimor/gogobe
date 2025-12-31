
@echo off
chcp 65001 >nul

echo ════════════════════════════════════════════════════════════
echo   GOGOBE ORCHESTRA - FULL IMPORT & MONITOR
echo ════════════════════════════════════════════════════════════
echo.

echo [1/3] Starting Monitor in a new window...
start "Gogobe Monitor" cmd /c "python backend\scripts\monitor_dashboard.py"

echo [2/3] Preparing Docker environment...
cd "%~dp0"
docker-compose up -d db redis

echo [3/3] Launching Parallel Import Engine (Main Window)...
echo.
echo    This window will show the raw logs of the importers.
echo    Check the "Gogobe Monitor" window for the visual dashboard.
echo.
timeout /t 3

docker exec gogobe-api-1 python /app/backend/scripts/import_all_sources_parallel.py

echo.
echo Process Complete.
pause
